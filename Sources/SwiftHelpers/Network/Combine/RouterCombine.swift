//
//  RouterCombine.swift
//
//
//  Created by Alexa Márk on 2021. 10. 07.
//

import Foundation
import Combine

public enum RequestError: Error {
    case buildRequestFailed
    case requestFailed
    case jsonDecodeFailed
    case unauthorized
    case forbidden
    case needLogin
}

public protocol AuthenticatorProtocol {
    var token: AuthToken? { get }
    func promptLoginToUser() -> PassthroughSubject<Bool, Never>
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
            .tryMap { data, response -> ResponseType in
                guard let response = response as? HTTPURLResponse else { throw RequestError.requestFailed }
                switch response.statusCode {
                case 401:
                    throw RequestError.unauthorized
                case 403:
                    throw RequestError.forbidden
                case let statusCode where ((statusCode < 200) || (statusCode >= 300)):
                    throw RequestError.requestFailed
                default:
                    break
                }
                print(String(data: data, encoding: .utf8))
                guard let decoded = try? JSONDecoder().decode(ResponseType.self, from: data) else {
                    throw RequestError.jsonDecodeFailed
                }
                return decoded
            }
            .mapError { error -> RequestError in
                error as? RequestError ?? .requestFailed
            }
            .tryCatch { error -> AnyPublisher<ResponseType, RequestError> in
                guard error == RequestError.unauthorized, let authenticator = self.authenticator else {
                    throw error
                }
                return authenticator.refreshToken()
                    .flatMap { token -> AnyPublisher<ResponseType, RequestError> in
                        self.publisher(endPoint)
                    }
                    .eraseToAnyPublisher()
            }
            .retry(3)
            .mapError { $0 as! RequestError }
            .eraseToAnyPublisher()

        if let authenticator = authenticator, endPoint.needLogin && !authenticator.isUserLoggedIn() {
            return authenticator.promptLoginToUser()
                .flatMap { _ in
                    self.publisher(endPoint)
                }
                .eraseToAnyPublisher()
        }
        return dataTaskPublisher
	}

	private func buildRequest(from endPoint: EndPoint) throws -> URLRequest {
		var request = URLRequest(url: URL(string: "https://wodio-backend.herokuapp.com/v1")!.appendingPathComponent(endPoint.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
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

    func addHeadersIfNeeded(request: inout URLRequest, token: String?) {
        if let headers = config?.httpHeaders {
			for (key, value) in headers {
				request.setValue(value, forHTTPHeaderField: key)
			}
		}
        if let token = token {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
	}
}
