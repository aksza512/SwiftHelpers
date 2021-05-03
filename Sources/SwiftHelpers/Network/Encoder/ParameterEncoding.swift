//
//  ParameterEncoding.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/05.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public protocol BinaryEncoder {
	func encode(urlRequest: inout URLRequest, with parameters: Parameters, with dataArray: [(String, Data)]) throws
}

public enum ParameterEncoding {
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
	case multipartEncoding
	
	public func encode(urlRequest: inout URLRequest, bodyParameters: Parameters?, urlParameters: Parameters?, dataArray: [(String, Data)]? = []) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters, let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
			case .multipartEncoding:
				guard let dataArray = dataArray, let bodyParameters = bodyParameters else { return }
				try MULTIPARTParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters, with: dataArray)
            }
        } catch {
            throw error
        }
    }
}

public indirect enum NetworkError : Error {
    case encodingFailed
    case missingURL
	case tokenRefreshFailed
	case clientError(_ error: NetworkError)
	case serverError(_ data: Data?, _ response: HTTPURLResponse?, _ error: NetworkError?)
	case error401(_ data: Data?, _ response: HTTPURLResponse?)
	case unknown
}
