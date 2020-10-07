//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 09. 29..
//

import UIKit

public class AlertController {
	var uiAlertController: UIAlertController

	public init(title: String?, message: String?, style: UIAlertController.Style?) {
		self.uiAlertController = UIAlertController(title: title, message: message, preferredStyle: style ?? .alert)
	}

	public init(title: String) {
		self.uiAlertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
	}

	public func addButton(_ alertButton: AlertButton) {
		uiAlertController.addAction(UIAlertAction(title: alertButton.title, style: alertButton.style, handler: alertButton.handler))
	}

	public func addTextField(_ textField: AlertTextField) {
		uiAlertController.addTextField { (tmpTextField) in
			tmpTextField.text = textField.text
			tmpTextField.placeholder = textField.placeholder
		}
	}

	public func show(in viewController: UIViewController) {
		viewController.present(uiAlertController, animated: true)
	}

	public func show() {
		UIViewController.topMostViewController()?.present(uiAlertController, animated: true)
	}

	public static func show(title: String?, message: String?, buttonTitle: String?, _ handler: ((UIAlertAction) -> Void)?) {
		let alert = AlertController(title: title, message: message, style: .alert)
		alert.addButton(AlertButton(title: buttonTitle ?? "OK", style: .default, handler))
		alert.show()
	}

	public func firstTextField() -> UITextField? {
		return uiAlertController.textFields?.first
	}
}


public class AlertButton {
	var title: String
	var style: UIAlertAction.Style
	var handler: ((UIAlertAction) -> Void)?

	public init(title: String, style: UIAlertAction.Style, _ handler: ((UIAlertAction) -> Void)?) {
		self.title = title
		self.style = style
		self.handler = handler
	}
}

public class AlertTextField {
	var text: String?
	var placeholder: String?

	public init(text: String?, placeholder: String?) {
		self.text = text
		self.placeholder = placeholder
	}
}
