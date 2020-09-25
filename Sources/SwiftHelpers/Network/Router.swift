//
//  NetworkService.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/07.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation

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
	
	@discardableResult public func requestOrigin<C: Codable>(isRefresh: Bool, _ endPoint: T, completion: @escaping (Result<C, NetworkError>) -> ()) -> URLSessionTask? {
		var task: URLSessionTask?
        do {
            var request = try self.buildRequest(from: endPoint)
			addExtraHeaders(request: &request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
				// REQUEST HAS NEED LOGIN
				if let isUserLoggedIn = self.routerConfig.routerConfigDelegate?.isUserLoggedIn(), !isUserLoggedIn {
					self.handleNeedLoginForRequest(endPoint, completion)
					return
				}
				// CLIENT error
				if error != nil || data == nil {
					self.logger.error("❤️ RES \((response as? HTTPURLResponse)?.statusCode ?? -1): [\(request.url?.absoluteString ?? "")], CLIENT ERROR: [\(String(data: data ?? Data(), encoding: .utf8) ?? "")]")
					completion(.failure(.clientError((error as? NetworkError) ?? .unknown)))
					return
				}
				// AUTHENTICATION error
				if let response = response as? HTTPURLResponse, self.isAuthenticationError(response.statusCode) {
					self.logger.error("❤️ RES \(response.statusCode): [\(request.url?.absoluteString ?? "")], AUTHENTICATION ERROR: [\(String(data: data ?? Data(), encoding: .utf8) ?? "")]")
					if isRefresh {
						completion(.failure(.tokenRefreshFailed))
						return
					}
					self.handleAuthorizationError(endPoint, completion)
					return
				}
				// SERVER error
				if let response = response as? HTTPURLResponse, self.isRequestFailed(response.statusCode) {
					self.logger.error("❤️ RES \(response.statusCode): [\(request.url?.absoluteString ?? "")], SERVER ERROR: [\(String(data: data ?? Data(), encoding: .utf8) ?? "")]")
					if let shouldHandleError = self.routerConfig.routerConfigDelegate?.shouldHandleApplicationError(response.statusCode), !shouldHandleError {
						completion(.failure(.serverError(data, response, (error as? NetworkError) ?? .unknown)))
					}
					return
				}
				// MIME error
				guard let mime = response?.mimeType, mime == "application/json" else {
					self.logger.error("❤️ RES \((response as? HTTPURLResponse)?.statusCode ?? -1): [\(request.url?.absoluteString ?? "")], WRONG MIME TYPE")
					return
				}
				// PARSE json
				do {
					if let data = data {
						let json = try JSONDecoder().decode(C.self, from: data)
						DispatchQueue.main.async {
							self.logger.info("💜 RES \((response as? HTTPURLResponse)?.statusCode ?? -1): [\(request.url?.absoluteString ?? "")], DATA: [\(json.dictionary.debugDescription)]")
							completion(.success(json))
						}
					}
				} catch let jsonError {
					self.logger.error("❤️ RES \((response as? HTTPURLResponse)?.statusCode ?? -1): [\(request.url?.absoluteString ?? "")], JSON PARSE FAILED:\(jsonError)")
				}
            })
        } catch let buildReqError {
			self.logger.error("❤️ BUILD REQ ERROR:\(buildReqError)")
            completion(.failure(buildReqError as! NetworkError))
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
			case .requestParameters(let bodyParameters, let bodyEncoding, let urlParameters):
				logger.info("💛 REQ \(request.httpMethod ?? "UNKNOWN HTTP METHOD"): [\(request.url?.absoluteString ?? "")], DATA: [\(bodyParameters?.debugDescription ?? "")]")
                try self.configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?, bodyEncoding: ParameterEncoding, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
	
	func handleAuthorizationError<C: Codable>(_ endPoint: T, _ completion: @escaping (Result<C, NetworkError>) -> ()) {
		let completionBlock: (_ success: Bool) -> () = { (successRefresh) in
			if !successRefresh {
				completion(.failure(.tokenRefreshFailed))
			} else {
				self.request(endPoint, completion: completion)
			}
		}
		routerConfig.refreshTokenCompletions.append(completionBlock)
		routerConfig.routerConfigDelegate?.handleAuthorizationError()
	}

	func handleNeedLoginForRequest<C: Codable>(_ endPoint: T, _ completion: @escaping (Result<C, NetworkError>) -> ()) {
		let completionBlock = {
			_ = self.request(endPoint, completion: completion)
		}
		routerConfig.needLoginForRequestCompletion = completionBlock
		routerConfig.routerConfigDelegate?.handleNeedLoginForRequest()
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

	func isAuthenticationError(_ statusCode: Int) -> Bool {
		return statusCode == 401 || statusCode == 403
	}
}

