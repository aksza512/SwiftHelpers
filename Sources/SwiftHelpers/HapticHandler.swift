//
//  HapticHandler.swift
//  
//
//  Created by Alexa Márk on 2020. 02. 12..
//

import UIKit

public class HapticHandler {
	public init() { }
	
	public static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
		let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: style)
		impactFeedbackgenerator.impactOccurred()
	}
	
	public static func impactNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
		let impactFeedbackgenerator = UINotificationFeedbackGenerator()
		impactFeedbackgenerator.notificationOccurred(type)
	}
	
	public static func impactSelectionChanged() {
		let impactFeedbackgenerator = UISelectionFeedbackGenerator()
		impactFeedbackgenerator.selectionChanged()
	}
}
