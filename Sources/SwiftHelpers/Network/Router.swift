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

	public init() {
		
	}
	
	@discardableResult public func request<C: Codable>(_ endPoint: T, completion: @escaping (Result<C, Error>) -> ()) -> URLSessionTask? {
		var task: URLSessionTask?
        do {
            let request = try self.buildRequest(from: endPoint)
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                guard response != nil, let data = data else { return }
                let responseObject = try! JSONDecoder().decode(C.self, from: data)
                DispatchQueue.main.async {
					completion(.success(responseObject))
                }
            })
        } catch {
            completion(.failure(error))
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
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters, let bodyEncoding, let urlParameters):
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
}

