//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 09. 29..
//

import UIKit
import MessageUI

public enum EmailHandlerError: Error {
	case cantSendMail
}

public class EmailHandler {
	public class func send<T: UIViewController & MFMailComposeViewControllerDelegate>(in viewController: T, recipients: [String]?, htmlBody: String?) throws {
		if MFMailComposeViewController.canSendMail() {
			let mail = MFMailComposeViewController()
			mail.mailComposeDelegate = viewController
			mail.setToRecipients(recipients ?? [])
			mail.setMessageBody(htmlBody ?? "", isHTML: true)
			viewController.present(mail, animated: true)
		} else {
			throw EmailHandlerError.cantSendMail
		}
	}
}
