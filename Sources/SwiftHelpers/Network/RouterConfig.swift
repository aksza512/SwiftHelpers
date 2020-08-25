//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 06. 04..
//

import Foundation

public typealias RefreshTokenCompletionBlock = (_ success: Bool) -> ()

public protocol RouterConfigDelegate: class {
	// Authorization error 401/403
	func handleAuthorizationError();
	// Overwrite customError if needed
	func shouldHandleCustomError(_ statusCode: Int) -> Bool
}

open class RouterConfig {
	public static let instance = RouterConfig()
	open weak var routerConfigDelegate: RouterConfigDelegate?
	open var extraHeaders: [String: String]?
	open var refreshTokenCompletions = [RefreshTokenCompletionBlock]()
	
	open func callRefreshCompletions(success: Bool) {
		for completion in refreshTokenCompletions {
			completion(success)
		}
		refreshTokenCompletions.removeAll()
	}
}
