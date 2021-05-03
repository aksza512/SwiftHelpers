//
//  File.swift
//  
//
//  Created by Alexa Márk on 2021. 05. 03..
//

import Foundation

import Foundation

public struct MULTIPARTParameterEncoder: BinaryEncoder {
	public func encode(urlRequest: inout URLRequest, with parameters: Parameters, with dataArray: [(String, Data)]) throws {
		let boundaryString = "Boundary-\(UUID().uuidString)"
		// HEADER
		if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
			urlRequest.setValue("multipart/form-data; boundary=\(boundaryString)", forHTTPHeaderField: "Content-Type")
		}
		
		// BODY
		var body = Data()
		parameters.forEach { (key, value) in
			body.append("--\(boundaryString)\r\n")
			body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
			body.append("\(value)\r\n")
		}
		for data in dataArray {
			body.append("--\(boundaryString)\r\n")
			body.append("Content-Disposition: form-data; name=\"\(data.0)\"; filename=\"\(data.0).\(data.1.format)\"\r\n")
			body.append("Content-Type: image/\(data.1.format)\r\n\r\n")
			body.append(data.1)
			body.append("\r\n")
		}
		body.append("--\(boundaryString)--\r\n")
		urlRequest.httpBody = body
	}
}

