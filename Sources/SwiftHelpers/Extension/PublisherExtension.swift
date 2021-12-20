//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2021. 12. 20..
//

import Combine

public extension Publisher where Failure == Never {
    func weakAssign<T: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<T, Output>,
        on object: T
    ) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }

    func weakSink<T: AnyObject>(
        _ weaklyCaptured: T,
        receiveValue: @escaping (T, Self.Output) -> Void
    ) -> AnyCancellable {
        sink { [weak weaklyCaptured] output in
            guard let strongRef = weaklyCaptured else { return }
            receiveValue(strongRef, output)
        }
    }
}
