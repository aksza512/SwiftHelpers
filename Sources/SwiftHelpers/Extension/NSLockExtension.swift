//
//  File.swift
//  
//
//  Created by Alexa Márk on 2022. 08. 18..
//

import Foundation

public extension NSLock {
    static func lockableContinuation(_ completion: @escaping (@escaping (() -> Void)) -> Void) async {
        let lock = NSLock()
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            var nillableContinuation: CheckedContinuation<Void, Never>? = continuation
            completion {
                lock.lock()
                defer { lock.unlock() }
                nillableContinuation?.resume()
                nillableContinuation = nil
            }
        }
    }
}
