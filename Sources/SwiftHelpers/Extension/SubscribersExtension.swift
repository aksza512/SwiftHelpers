//
//  File.swift
//  
//
//  Created by Alexa Márk on 2021. 10. 08..
//

import Combine

@available(iOS 13.0, *)
public extension Subscribers.Completion {
	func error() throws -> Failure {
		if case let .failure(error) = self {
			return error
		}
		throw ErrorFunctionThrowsError.error
	}
	private enum ErrorFunctionThrowsError: Error { case error }
}
