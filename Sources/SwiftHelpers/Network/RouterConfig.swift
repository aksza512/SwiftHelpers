//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 06. 04..
//

import Foundation

public typealias RefreshTokenCompletionBlock = () -> Void
public typealias NeedLoginForRequestCompletionBlock = () -> Void

public protocol RouterConfigDelegate: AnyObject {
	// Authorization error 401
	func handleAuthorizationError(data: Data?)
	// Authorization error 403
	func handleLogout()
	// Overwrite customError if needed
	func shouldHandleApplicationError(_ statusCode: Int) -> Bool
	// Is user logged in
	func isUserLoggedIn() -> Bool
	// Need Login For Request
	func handleNeedLoginForRequest()
	// AccessToken
	func accessToken() -> String?
	func refreshToken() -> String?
    func pathPrefix() -> String?
    // DeviceId
    func deviceId() -> String?
}

open class RouterConfig: NSObject {
	open weak var routerConfigDelegate: RouterConfigDelegate?
	open var extraHeaders: [String: String]?
	open var refreshTokenCompletions = [RefreshTokenCompletionBlock]()
	open var needLoginForRequestCompletion: NeedLoginForRequestCompletionBlock?

	open func callRefreshCompletions() {
		for completion in refreshTokenCompletions {
			completion()
		}
		removeAllCompletions()
	}
	
	open func removeAllCompletions() {
		refreshTokenCompletions.removeAll()
	}

	public override init() {
	}
}
