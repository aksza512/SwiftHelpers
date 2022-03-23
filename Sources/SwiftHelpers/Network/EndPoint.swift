//
//  EndPoint.swift
//  NetworkLayer
//
//  Created by Alexa Mark on 2018/03/05.
//  Copyright © 2018 Alexa Mark. All rights reserved.
//

import Foundation

public protocol EndPoint {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var requestType: RequestType { get }
	var needLogin: Bool { get }
    var sendPrefix: Bool { get }
}

public protocol CombineEndPoint {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var requestType: RequestType { get }
    var needLogin: Bool { get }
}
