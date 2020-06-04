//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 06. 04..
//

import Foundation

public protocol RouterConfigDelegate: class {
	// Authorization error 401/403
	func handleAuthorizationError(_ completion: (_ successRefresh: Bool) -> ());
}

open class RouterConfig {
	public static let instance = RouterConfig()
	open weak var routerConfigDelegate: RouterConfigDelegate?
	open var extraHeaders: [String: String]?
}
