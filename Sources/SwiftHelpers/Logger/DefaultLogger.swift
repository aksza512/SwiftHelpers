//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 09. 24..
//

public protocol LoggerProtocol {
	func setupLogger()
	func debug(_ message: String)
	func info(_ message: String)
	func warning(_ message: String)
	func error(_ message: String)
}

public class DefaultLogger: LoggerProtocol {
	public func setupLogger() {
	}

	public func debug(_ message: String) {
		print(message)
	}

	public func info(_ message: String) {
		print(message)
	}

	public func warning(_ message: String) {
		print(message)
	}

	public func error(_ message: String) {
		print(message)
	}
}
