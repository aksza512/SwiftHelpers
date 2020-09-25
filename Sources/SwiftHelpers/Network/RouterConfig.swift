//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 06. 04..
//

import Foundation

public typealias RefreshTokenCompletionBlock = (_ success: Bool) -> Void
public typealias NeedLoginForRequestCompletionBlock = () -> Void

public protocol RouterConfigDelegate: class {
	// Authorization error 401/403
	func handleAuthorizationError();
	// Overwrite customError if needed
	func shouldHandleApplicationError(_ statusCode: Int) -> Bool
	// Is user logged in
	func isUserLoggedIn() -> Bool
	// Need Login For Request
	func handleNeedLoginForRequest()
}

open class RouterConfig {
	open weak var routerConfigDelegate: RouterConfigDelegate?
	open var extraHeaders: [String: String]?
	open var refreshTokenCompletions = [RefreshTokenCompletionBlock]()
	open var needLoginForRequestCompletion: NeedLoginForRequestCompletionBlock?

	open func callRefreshCompletions(success: Bool) {
		for completion in refreshTokenCompletions {
			completion(success)
		}
		refreshTokenCompletions.removeAll()
	}

	public init() {
	}
}
