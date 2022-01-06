//
//  RouterCombine.swift
//
//
//  Created by Alexa Márk on 2021. 10. 07.
//

import Foundation
import Combine

public enum RequestError: Error, Equatable {
    case buildRequestFailed
    case requestFailed
    case decodingError
    case unauthorized
    case forbidden
    case needLogin
    case urlSessionFailed(_ error: URLError)
    case unknownError(_ statusCode: Int?)
}

public protocol AuthenticatorProtocol {
    var token: AuthToken? { get set }
    func promptLoginToUser() -> AnyPublisher<AuthToken, RequestError>
    func refreshToken() -> AnyPublisher<AuthToken, RequestError>
    func isUserLoggedIn() -> Bool
}

public protocol RouterConfigProtocol {
    var httpHeaders: [String: String]? { get set }
}

@available(iOS 14, *)
public class RouterCombine<EndPoint: CombineEndPoint, ResponseType: Codable> {
	private let session = URLSession.shared
    let authenticator: AuthenticatorProtocol?
    let config: RouterConfigProtocol?

    public init(authenticator: AuthenticatorProtocol? = nil, config: RouterConfigProtocol? = nil) {
        self.authenticator = authenticator
        self.config = config
    }

    public func publisher(_ endPoint: EndPoint, token: String? = nil) -> AnyPublisher<ResponseType, RequestError> {
		guard var request = try? self.buildRequest(from: endPoint) else {
            return Fail(error: RequestError.buildRequestFailed).eraseToAnyPublisher()
		}
        addHeadersIfNeeded(request: &request, token: token ?? authenticator?.token?.accessToken)
		let dataTaskPublisher = session.dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response -> Data in
                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode), let self = self {
                    throw self.httpError(response.statusCode)
                }
                return data
            }
            .decode(type: ResponseType.self, decoder: JSONDecoder())
            .mapError { error -> RequestError in
                return error as? RequestError ?? .requestFailed
            }
            .tryCatch { error -> AnyPublisher<ResponseType, RequestError> in
                guard error == RequestError.unauthorized, let authenticator = self.authenticator else {
                    throw error
                }
                return authenticator.refreshToken()
                    .flatMap { [weak self] token -> AnyPublisher<ResponseType, RequestError> in
                        guard let self = self else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                        return self.publisher(endPoint, token: token.accessToken)
                    }
                    .eraseToAnyPublisher()
            }
            .mapError { error -> RequestError in
                return error as? RequestError ?? .requestFailed
            }
            .retry(3)
            .eraseToAnyPublisher()

        if let authenticator = authenticator, endPoint.needLogin && !authenticator.isUserLoggedIn() {
            _ = authenticator.promptLoginToUser()
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        }
        return dataTaskPublisher
	}

	private func buildRequest(from endPoint: EndPoint) throws -> URLRequest {
//        var request = URLRequest(url: URL(string: "https://wodio-backend.herokuapp.com/v1")!.appendingPathComponent(endPoint.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        var request = URLRequest(url: URL(string: "https://wodio-backend-staging.herokuapp.com/v1")!.appendingPathComponent(endPoint.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
		request.httpMethod = endPoint.httpMethod.rawValue
		do {
			switch endPoint.requestType {
			case .request:
				print("💛 REQ \(request.httpMethod ?? "UNKNOWN HTTP METHOD"): [\(request.url?.absoluteString ?? "")], DATA: []")
			case .requestParameters(let bodyParameters, let bodyEncoding, let urlParameters, let dataArray):
				try self.configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters, request: &request, dataArray: dataArray)
				print("💛 REQ \(request.httpMethod ?? "UNKNOWN HTTP METHOD"): [\(request.url?.absoluteString ?? "")], DATA: [\(bodyParameters?.debugDescription ?? "")]")
			}
			return request
		} catch {
			throw error
		}
	}

	private func configureParameters(bodyParameters: Parameters?, bodyEncoding: ParameterEncoding, urlParameters: Parameters?, request: inout URLRequest, dataArray: [(String, Data)]?) throws {
		do {
			try bodyEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters, urlParameters: urlParameters, dataArray: dataArray)
		} catch {
			throw error
		}
	}

    private func httpError(_ statusCode: Int) -> RequestError {
        switch statusCode {
        case 401: return .unauthorized
        case 403: return .forbidden
        default: return .unknownError(statusCode)
        }
    }

    private func handleError(_ error: Error) -> RequestError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as RequestError:
            return error
        default:
            return .unknownError(nil)
        }
    }

    func addHeadersIfNeeded(request: inout URLRequest, token: String?) {
        if let headers = config?.httpHeaders {
			for (key, value) in headers {
				request.setValue(value, forHTTPHeaderField: key)
			}
		}
        if let token = token {
            request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        }
	}
}
