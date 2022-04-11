//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 12. 04..
//

import Foundation

public extension Date {
	func isBetween(_ date1: Date?, and date2: Date?) -> Bool {
        guard let date1 = date1, let date2 = date2 else { return false }
	   return (min(date1, date2) ... max(date1, date2)).contains(self)
	}
    
    var today: Date? {
        let calendar = Calendar.current
        return calendar.dateInterval(of: .day, for: self)?.start
    }
    
    var yesterday: Date? {
        let calendar = Calendar.current
        let now = Date()
        var components = calendar.dateComponents([.hour, .minute, .second], from: now)
        components.hour = -(components.hour ?? 0)
        components.minute = -(components.minute ?? 0)
        components.second = -(components.second ?? 0)
        let today = calendar.date(byAdding: components, to: now)
        components.hour = -24
        components.minute = 0
        components.second = 0
        return calendar.date(byAdding: components, to: today ?? Date())
    }

    var tomorrow: Date? {
        let calendar = Calendar.current
        let now = Date()
        var components = calendar.dateComponents([.hour, .minute, .second], from: now)
        components.hour = -(components.hour ?? 0)
        components.minute = -(components.minute ?? 0)
        components.second = -(components.second ?? 0)
        let today = calendar.date(byAdding: components, to: now)
        components.hour = +24
        components.minute = 0
        components.second = 0
        return calendar.date(byAdding: components, to: today ?? Date())
    }
    
    var hour: Int {
        let calendar = Calendar(identifier: .gregorian)
        let ret = calendar.component(.hour, from: self)
        return ret
    }

    var minute: Int {
        let calendar = Calendar(identifier: .gregorian)
        let ret = calendar.component(.minute, from: self)
        return ret
    }

	var startOfWeek: Date? {
	   let calendar = Calendar.current
	   return calendar.dateInterval(of: .weekOfMonth, for: self)?.start
	}

	var endOfWeek: Date? {
		let calendar = Calendar.current
		return calendar.dateInterval(of: .weekOfMonth, for: self)?.end
	}

	var startOfMonth: Date? {
		let calendar = Calendar.current
		return calendar.dateInterval(of: .month, for: self)?.start
	}

	var endOfMonth: Date? {
		let calendar = Calendar.current
		return calendar.dateInterval(of: .month, for: self)?.end
	}

	var weekNumber: Int? {
		let calendar = Calendar.current
		let currentComponents = calendar.dateComponents([.weekOfYear], from: self)
		return currentComponents.weekOfYear
	}

	var monthNumber: Int? {
		let calendar = Calendar.current
		let currentComponents = calendar.dateComponents([.month], from: self)
		return currentComponents.month
	}

	var year: Int? {
		let calendar = Calendar.current
		let currentComponents = calendar.dateComponents([.year], from: self)
		return currentComponents.year
	}

	static func getWeekOfYear(from week: Int, year: Int? = Date().year, locale: Locale? = nil) -> Date? {
		var calendar = Calendar(identifier: .iso8601)
		 calendar.locale = locale
		 let dateComponents = DateComponents(calendar: calendar, year: year, weekday: 1, weekOfYear: week)
		 return calendar.date(from: dateComponents)
	}

	func timeIntervalSince1970InMilliseconds() -> Int64! {
		return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
	}

	init(milliseconds: Int64) {
		self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
	}
}
