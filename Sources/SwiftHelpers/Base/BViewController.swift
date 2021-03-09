//
//  BViewController.swift
//  SwiftHelpers
//
//  Created by Alexa Márk on 2019. 11. 07..
//

import UIKit

open class BViewController: UIViewController {
    @IBOutlet public weak var tableView: UITableView!
	@IBOutlet public weak var loadingView: LoadingView!
	var tmpLoadingView: LoadingView?

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

	open func loadingState(_ show: Bool, isInMyView: Bool = false) {
		if isInMyView {
			show ? loadingView.fadeIn() : loadingView.fadeOut()
		} else if let tmpLoadingView = tmpLoadingView {
			tmpLoadingView.fadeOut()
			self.tmpLoadingView = nil
		} else {
			tmpLoadingView = LoadingView(frame: .zero)
			tmpLoadingView?.hide()
			tmpLoadingView?.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(tmpLoadingView!)
			tmpLoadingView?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
			tmpLoadingView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
			tmpLoadingView?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
			tmpLoadingView?.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
			tmpLoadingView?.fadeIn()
		}
	}
}
