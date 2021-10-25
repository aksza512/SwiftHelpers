//
//  RouterCombine.swift
//
//
//  Created by Alexa Márk on 2021. 10. 07.
//

import Foundation
import Combine

public protocol TokenProtocol {
	var refreshToken: String? { get }
	var accessToken: String? { get }
}

@available(iOS 13, *)
public protocol AuthenticatorProtocol: AnyObject {
	func handleLogout()
	func handleLogin()
	func refreshTokenPublisher() -> AnyPublisher<TokenProtocol, Error>
	func updateToken(token: TokenProtocol)
	func saveToken(token: TokenProtocol)
	func getToken() -> TokenProtocol
}

public enum ClientRequestError: LocalizedError, Equatable {
	case buildRequestError
}

public enum NetworkRequestError: LocalizedError, Equatable {
	case invalidRequest
	case badRequest
	case unauthorized
	case forbidden
	case notFound
	case error4xx(_ code: Int)
	case serverError(_ data: Data?)
	case error5xx(_ code: Int, _ data: Data?)
	case decodingError
	case urlSessionFailed(_ error: URLError)
	case unknownError
}

public enum AuthenticationError: Error {
	case loginRequired
	case invalidToken
}

@available(iOS 13, *)
public class RouterCombine<T: EndPoint> {
	let session = URLSession.shared
	let routerConfig: RouterConfig
	var authenticator: AuthenticatorProtocol?
	let logger: LoggerProtocol

	public init(routerConfig: RouterConfig, logger: LoggerProtocol, authenticator: AuthenticatorProtocol) {
		self.routerConfig = routerConfig
		self.logger = logger
		self.authenticator = authenticator
	}

	deinit {
	}

	private func httpError(_ statusCode: Int?, _ data: Data? = nil) -> NetworkRequestError {
		guard let statusCode = statusCode else { return .unknownError }
		switch statusCode {
		case 400: return .badRequest
		case 401: return .unauthorized
		case 403: return .forbidden
		case 404: return .notFound
		case 402, 405...499: return .error4xx(statusCode)
		case 500: return .serverError(data)
		case 501...599: return .error5xx(statusCode, data)
		default: return .unknownError
		}
	}

	private func handleError(_ error: Error) -> NetworkRequestError {
		switch error {
		case is Swift.DecodingError:
			return .decodingError
		case let urlError as URLError:
			return .urlSessionFailed(urlError)
		case let error as NetworkRequestError:
			return error
		default:
			return .unknownError
		}
	}

	public func publisher(_ endPoint: T, withRefresh: Bool = false) -> AnyPublisher<Data, Error> {
		if !endPoint.needLogin || !withRefresh {
			return publisherWithoutAuth(endPoint)
		} else if let authenticator = authenticator {
			return publisherWithAuth(endPoint, authenticator: authenticator)
		} else {
			return publisherWithoutAuth(endPoint)
		}
	}

	public func publisherWithoutAuth(_ endPoint: T) -> AnyPublisher<Data, Error> {
		// build request
		guard var request = try? self.buildRequest(from: endPoint) else {
			self.logger.error("❤️ BUILD REQ ERROR:\(endPoint.path)")
			return Fail(error: ClientRequestError.buildRequestError).eraseToAnyPublisher()
		}
		// add headers
		addExtraHeaders(request: &request)
		return session.dataTaskPublisher(for: request)
			.tryMap({ (data, response) in
				guard let httpResponse = response as? HTTPURLResponse, !self.isRequestFailed(httpResponse.statusCode) else {
					throw self.httpError((response as? HTTPURLResponse)?.statusCode, data)
				}
				return data
			})
			.eraseToAnyPublisher()
	}

	public func publisherWithAuth(_ endPoint: T, authenticator: AuthenticatorProtocol) -> AnyPublisher<Data, Error> {
		return authenticator.refreshTokenPublisher()
			.flatMap({ token in
				self.publisher(endPoint, withRefresh: false)
			})
			.tryCatch({ error -> AnyPublisher<Data, Error> in
				guard let serviceError = error as? AuthenticationError, serviceError == .invalidToken else {
					throw error
				}
				return authenticator.refreshTokenPublisher()
					.flatMap({ token in
						self.publisher(endPoint, withRefresh: false)
					})
					.eraseToAnyPublisher()
			})
			.eraseToAnyPublisher()
	}

	fileprivate func buildRequest(from endPoint: T) throws -> URLRequest {
		var request = URLRequest(url: endPoint.baseURL.appendingPathComponent(endPoint.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
		request.httpMethod = endPoint.httpMethod.rawValue
		do {
			switch endPoint.requestType {
			case .request:
				logger.info("💛 REQ \(request.httpMethod ?? "UNKNOWN HTTP METHOD"): [\(request.url?.absoluteString ?? "")], DATA: []")
			case .requestParameters(let bodyParameters, let bodyEncoding, let urlParameters, let dataArray):
				try self.configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters, request: &request, dataArray: dataArray)
				logger.info("💛 REQ \(request.httpMethod ?? "UNKNOWN HTTP METHOD"): [\(request.url?.absoluteString ?? "")], DATA: [\(bodyParameters?.debugDescription ?? "")]")
			}
			return request
		} catch {
			throw error
		}
	}

	fileprivate func configureParameters(bodyParameters: Parameters?, bodyEncoding: ParameterEncoding, urlParameters: Parameters?, request: inout URLRequest, dataArray: [(String, Data)]?) throws {
		do {
			try bodyEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters, urlParameters: urlParameters, dataArray: dataArray)
		} catch {
			throw error
		}
	}

	func handleAuthorizationError<C: Codable>(_ data: Data?, _ endPoint: T, _ completion: @escaping (Result<C, NetworkError>) -> ()) {
//		let completionBlock: () -> Void = {
//			self.request(endPoint, completion: completion)
//		}
//		routerConfig.refreshTokenCompletions.append(completionBlock)
//		routerConfig.routerConfigDelegate?.handleAuthorizationError(data: data)
	}

	func handleLogout() {
		routerConfig.routerConfigDelegate?.handleLogout()
	}

	func handleNeedLoginForRequest<C: Codable>(_ endPoint: T, _ completion: @escaping (Result<C, NetworkError>) -> ()) {
//		let completionBlock = {
//			_ = self.request(endPoint, completion: completion)
//		}
//		routerConfig.needLoginForRequestCompletion = completionBlock
//		routerConfig.routerConfigDelegate?.handleNeedLoginForRequest()
	}

	func addExtraHeaders(request: inout URLRequest) {
		if let extraHeaders = routerConfig.extraHeaders {
			for (key, value) in extraHeaders {
				request.setValue(value, forHTTPHeaderField: key)
			}
		}
	}

	func isRequestFailed(_ statusCode: Int) -> Bool {
		return ((statusCode < 200) || (statusCode >= 300))
	}

	func isAccessTokenError(_ statusCode: Int) -> Bool {
		return statusCode == 401
	}

	func isRefreshTokenError(_ statusCode: Int) -> Bool {
		return statusCode == 403
	}
}
