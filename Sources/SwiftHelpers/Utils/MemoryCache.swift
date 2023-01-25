//
//  MemoryCache.swift
//  
//
//  Created by Alexa Márk on 2022. 11. 24..
//

import Foundation
import Combine

@available(iOS 15.0, *)
public enum CacheExpDate {
    case seconds(Int)
    case never
}

@available(iOS 15.0, *)
public struct MemoryCache<Key: Hashable, Value: Codable> {
    public struct CacheExpiry<Value> {

        public let value: Value
        public let exp: CacheExpDate
        let created: TimeInterval
        var isExpired: Bool {
            switch exp {
            case .seconds(let seconds):
                let now: TimeInterval = Date.now.timeIntervalSince1970
                let diff = now - created
                return diff > Double(seconds)
            case .never:
                return false
            }
        }

        public init(value: Value, exp: CacheExpDate, created: TimeInterval = Date.now.timeIntervalSince1970) {
            self.value = value
            self.exp = exp
            self.created = created
        }
    }

    public var cachedData: [Key: CacheExpiry<Value>]

    public var resetCachePublisher = PassthroughSubject<Bool, Never>()

    public init(cachedData: [Key : CacheExpiry<Value>] = [:]) {
        self.cachedData = cachedData
    }

    public func getData(key: Key?) -> Value? {
        guard let key else { return nil }
        return cachedData[key]?.value
    }

    public func getData(key: Key?, nilIfExpired: Bool) -> Value? {
        guard let key else { return nil }
        if nilIfExpired {
            return isExpired(key: key) ? nil : cachedData[key]?.value
        }
        return cachedData[key]?.value
    }

    public mutating func setValue(_ value: Value?, forKey: Key, expiry: CacheExpDate = .seconds(5)) {
        guard let value else { return }
        guard let cachedValue = cachedData[forKey] else {
            cachedData[forKey] = .init(value: value, exp: expiry)
            return
        }
        if !cachedValue.isExpired {
            cachedData[forKey] = .init(value: value, exp: expiry, created: cachedValue.created)
        } else {
            cachedData[forKey] = .init(value: value, exp: expiry)
        }
    }

    public func isExpired(key: Key?) -> Bool {
        guard let key, let cacheExpiry: CacheExpiry<Value> = cachedData[key] else { return true }
        return cacheExpiry.isExpired
    }

    public mutating func resetCache() {
        cachedData.removeAll()
        resetCachePublisher.send(true)
    }

    public func isEmpty() -> Bool {
        return cachedData.isEmpty
    }

    public func allValues() -> [Value] {
        let allValue = Array(cachedData.values.compactMap({ $0.value }))
        return allValue
    }
}
