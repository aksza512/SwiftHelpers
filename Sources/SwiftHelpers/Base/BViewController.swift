//
//  BViewController.swift
//  SwiftHelpers
//
//  Created by Alexa Márk on 2019. 11. 07..
//

import UIKit

open class BViewController: UIViewController {
    @IBOutlet public weak var tableView: UITableView!
    
    @IBAction public func closeButtonPressed(_ button: UIButton) {
        dismiss(animated: true, completion: nil)
    }
	
    @IBAction func backNavbarButtonPressed(_ button: UIButton) {
		if let navController = self.navigationController {
			navController.popViewController(animated: true)
		}
    }

	open override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}

	open func setupUI() {
	}
}
