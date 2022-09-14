//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 10. 05..
//

import Foundation

public extension Array where Element: Equatable {
	mutating func safeRemove(_ object: Element?) {
		guard let obj = object else { return }
		if let index = firstIndex(of: obj) {
			remove(at: index)
		}
	}

	mutating func safeRemove(_ at: Int) {
		guard (self.count - 1) >= at else { return }
		remove(at: at)
	}
    
    mutating func safeIndex(_ object: Element?) -> Int? {
        guard let object = object else { return nil }
        return self.firstIndex(of: object)
    }

	mutating func appendDistinctionObject(_ object: Element) {
		if !self.contains(object) {
			self.append(object)
		}
	}

	mutating func appendDistinctionObjects(_ objects: [Element]) {
		for object in objects {
			if !self.contains(object) {
				self.append(object)
			}
		}
	}

	mutating func move(_ element: Element, to newIndex: Index) {
		if let oldIndex: Int = self.firstIndex(of: element) { self.move(from: oldIndex, to: newIndex) }
	}

	func contains(array: [Element]) -> Bool {
		for item in array {
			if !self.contains(item) { return false }
		}
		return true
	}
}

public extension Array where Element: Any {
	func safeAt(_ index: Int) -> Element? {
		if (index >= 0 && index < self.count) {
			return self[index]
		}
		return nil
	}

	mutating func safeAdd(_ object: Element?) {
		guard let object = object else { return }
		self.append(object)
	}

	mutating func safeAdd(_ object: Element?, at: Int) {
		guard let object = object else { return }
		self.insert(object, at: at)
	}

    func safeAddNewArray(_ object: Element?, at: Int) -> Self {
        guard let object = object else { return self }
        return self + [object]
    }

	mutating func move(from oldIndex: Index, to newIndex: Index) {
		if oldIndex == newIndex { return }
		if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
		self.insert(self.remove(at: oldIndex), at: newIndex)
	}

    mutating func mutateEach(by transform: (inout Element) throws -> Void) rethrows {
        self = try map { el in
            var el = el
            try transform(&el)
            return el
        }
    }
}
