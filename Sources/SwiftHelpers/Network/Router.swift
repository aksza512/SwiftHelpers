//
//  NetworkService.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/07.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation

//extension RouterConfig: URLSessionTaskDelegate {
//
//	public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
//
//	}
//
//}

public class Router<T: EndPoint> {
	let session = URLSession.shared
	let routerConfig: RouterConfig
	let logger: LoggerProtocol

	public init(routerConfig: RouterConfig, logger: LoggerProtocol) {
		self.routerConfig = routerConfig
		self.logger = logger
	}

	public init(routerConfig: RouterConfig) {
		self.routerConfig = routerConfig
		self.logger = DefaultLogger()
	}

	deinit {
	}

	@discardableResult public func requestRefresh<C: Codable>(_ endPoint: T, completion: @escaping (Result<C, NetworkError>) -> ()) -> URLSessionTask? {
		return requestOrigin(isRefresh: true, endPoint, completion: completion)
	}
	
	@discardableResult public func request<C: Codable>(_ endPoint: T, completion: @escaping (Result<C, NetworkError>) -> ()) -> URLSessionTask? {
		return requestOrigin(isRefresh: false, endPoint, completion: completion)
	}

	@discardableResult public func requestAbsolute(_ url: String, completion: @escaping (Result<[String: Any], NetworkError>) -> ()) -> URLSessionTask? {
		var task: URLSessionTask?
		var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
		request.httpMethod = "get"
		addExtraHeaders(request: &request, isRefresh: false)
		task = session.dataTask(with: request, completionHandler: { data, response, error in
			guard let data = data else { return }
			if let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) {
				completion(.success(jsonDict as! [String: Any]))
			}
		})
		task?.resume()
		return task
	}

	@discardableResult public func requestOrigin<C: Codable>(isRefresh: Bool, _ endPoint: T, completion: @escaping (Result<C, NetworkError>) -> ()) -> URLSessionTask? {
		var task: URLSessionTask?
        do {
            var request = try self.buildRequest(from: endPoint)
			addExtraHeaders(request: &request, isRefresh: isRefresh)
			print(request.allHTTPHeaderFields ?? "")
            task = session.dataTask(with: request, completionHandler: { data, response, error in
				// REQUEST HAS NEED LOGIN
				let isUserLoggedIn = self.routerConfig.routerConfigDelegate?.isUserLoggedIn() ?? false
				if (!isUserLoggedIn && endPoint.needLogin) {
					self.handleNeedLoginForRequest(endPoint, completion)
					return
				}
				// CLIENT error
				if error != nil || data == nil {
					self.logger.error("❤️ RES \((response as? HTTPURLResponse)?.statusCode ?? -1): [\(request.url?.absoluteString ?? "")], CLIENT ERROR: [\(String(data: data ?? Data(), encoding: .utf8) ?? "")], error: (\(error?.localizedDescription ?? ""))")
					DispatchQueue.main.async {
						completion(.failure(.clientError((error as? NetworkError) ?? .unknown)))
					}
					return
				}
				// AUTHENTICATION error
				// 403
				if let response = response as? HTTPURLResponse, self.isRefreshTokenError(response.statusCode) {
					self.logger.error("❤️ RES \(response.statusCode): [\(request.url?.absoluteString ?? "")], REFRESH TOKEN ERROR: [\(String(data: data ?? Data(), encoding: .utf8) ?? "")]")
					self.handleLogout()
					return
				}
				// 401
				if let response = response as? HTTPURLResponse, self.isAccessTokenError(response.statusCode) {
					self.logger.error("❤️ RES \(response.statusCode): [\(request.url?.absoluteString ?? "")], ACCESS TOKEN ERROR: [\(String(data: data ?? Data(), encoding: .utf8) ?? "")]")
					if isRefresh {
						self.handleLogout()
						completion(.failure(.tokenRefreshFailed))
					} else {
						DispatchQueue.main.async {
							completion(.failure(.error401(data, response)))
						}
						self.handleAuthorizationError(data, endPoint, completion)
					}
					return
				}
				// SERVER error
				if let response = response as? HTTPURLResponse, self.isRequestFailed(response.statusCode) {
					self.logger.error("❤️ RES \(response.statusCode): [\(request.url?.absoluteString ?? "")], SERVER ERROR: [\(String(data: data ?? Data(), encoding: .utf8) ?? "")], error: (\(error?.localizedDescription ?? ""))")
					if let shouldHandleError = self.routerConfig.routerConfigDelegate?.shouldHandleApplicationError(response.statusCode), !shouldHandleError {
						DispatchQueue.main.async {
							completion(.failure(.serverError(data, response, (error as? NetworkError) ?? .unknown)))
						}
					}
					return
				}
				// MIME error
				guard let mime = response?.mimeType, mime == "application/json" || mime == "text/plain" else {
					self.logger.error("❤️ RES \((response as? HTTPURLResponse)?.statusCode ?? -1): [\(request.url?.absoluteString ?? "")], WRONG MIME TYPE, error: (\(error?.localizedDescription ?? ""))")
					return
				}
				// PARSE json
				do {
					if let data = data {
						let json = try JSONDecoder().decode(C.self, from: data)
						DispatchQueue.main.async {
							self.logger.info("💜 RES \((response as? HTTPURLResponse)?.statusCode ?? -1): [\(request.url?.absoluteString ?? "")], DATA: [\(String(data: data, encoding: .utf8) ?? "")]")
							completion(.success(json))
						}
					} else {
						DispatchQueue.main.async {
							completion(.success(EmptyResponse() as! C))
						}
					}
				} catch let jsonError {
					self.logger.error("❤️ RES \((response as? HTTPURLResponse)?.statusCode ?? -1): [\(request.url?.absoluteString ?? "")], JSON PARSE FAILED:\(jsonError)")
				}
            })
        } catch let buildReqError {
			self.logger.error("❤️ BUILD REQ ERROR:\(buildReqError.localizedDescription)")
			DispatchQueue.main.async {
				completion(.failure(buildReqError as! NetworkError))
			}
        }
        task?.resume()
		return task
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
		let completionBlock: () -> Void = {
			self.request(endPoint, completion: completion)
		}
		routerConfig.refreshTokenCompletions.append(completionBlock)
		routerConfig.routerConfigDelegate?.handleAuthorizationError(data: data)
	}

	func handleLogout() {
		routerConfig.routerConfigDelegate?.handleLogout()
	}

	func handleNeedLoginForRequest<C: Codable>(_ endPoint: T, _ completion: @escaping (Result<C, NetworkError>) -> ()) {
		let completionBlock = {
			_ = self.request(endPoint, completion: completion)
		}
		routerConfig.needLoginForRequestCompletion = completionBlock
		routerConfig.routerConfigDelegate?.handleNeedLoginForRequest()
	}

	func addExtraHeaders(request: inout URLRequest, isRefresh: Bool) {
		if let extraHeaders = routerConfig.extraHeaders {
			for (key, value) in extraHeaders {
				request.setValue(value, forHTTPHeaderField: key)
			}
		}
		if let token = isRefresh ? routerConfig.routerConfigDelegate?.refreshToken() : routerConfig.routerConfigDelegate?.accessToken() {
			request.setValue("\(token)", forHTTPHeaderField: "Authorization")
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

public class EmptyResponse: Codable {
}
