//
//  BViewController.swift
//  SwiftHelpers
//
//  Created by Alexa Márk on 2019. 11. 07..
//

import UIKit

open class BViewController: UIViewController {
    @IBOutlet public weak var tableView: UITableView!
	// Loading View
	@IBOutlet public weak var loadingView: LoadingView!
	var tmpLoadingView: LoadingView?
	// Empty View
	@IBOutlet public weak var emptyView: EmptyView!
	var tmpEmptyView: EmptyView?
	// Pull to refresh
	var refreshControl: UIRefreshControl?
	var refreshControlActionCompletion: (() -> Void)?

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

	open func loadingState(_ show: Bool) {
		if loadingView != nil {
			show ? loadingView.fadeIn() : loadingView.fadeOut()
		} else if let tmpLoadingView = tmpLoadingView {
			tmpLoadingView.fadeOut {
				self.tmpLoadingView?.removeFromSuperview()
				self.tmpLoadingView = nil
			}
		} else if show {
			tmpLoadingView = LoadingView(frame: .zero)
			if let bgrColor = UIColor(named: "loadingBackgroundColor") {
				tmpLoadingView?.backgroundColor = bgrColor
			}
			tmpLoadingView?.hide()
			tmpLoadingView?.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(tmpLoadingView!)
			tmpLoadingView?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
			tmpLoadingView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
			tmpLoadingView?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
			tmpLoadingView?.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
			tmpLoadingView?.show()
		}
	}
	
	open func hideEmpty() {
		if let tmpEmptyView = tmpEmptyView {
			tmpEmptyView.fadeOut()
			tmpEmptyView.fadeOut {
				self.tmpEmptyView?.removeFromSuperview()
				self.tmpEmptyView = nil
			}
		}
	}
	
	open func showEmpty(show: Bool, title: String?, subtitle: String?, image: UIImage?, buttonTitle: String?, actionButtonPressed: (() -> Void)?, pullToRefresh: (() -> Void)?, backgroundColor: UIColor = .groupTableViewBackground) {
		if emptyView != nil {
			show ? emptyView.fadeIn() : emptyView.fadeOut()
			emptyView.config(title: title, subtitle: subtitle, image: image, buttonTitle: buttonTitle, actionButtonPressed: actionButtonPressed, pullToRefresh: pullToRefresh)
		} else if let tmpEmptyView = tmpEmptyView, !show {
			tmpEmptyView.fadeOut()
			tmpEmptyView.fadeOut {
				self.tmpEmptyView?.removeFromSuperview()
				self.tmpEmptyView = nil
			}
		} else if tmpEmptyView == nil && show {
			tmpEmptyView = EmptyView(frame: .zero)
			tmpEmptyView?.backgroundColor = backgroundColor
			tmpEmptyView?.hide()
			tmpEmptyView?.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(tmpEmptyView!)
			tmpEmptyView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
			tmpEmptyView?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
			tmpEmptyView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
			tmpEmptyView?.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
			tmpEmptyView?.config(title: title, subtitle: subtitle, image: image, buttonTitle: buttonTitle, actionButtonPressed: actionButtonPressed, pullToRefresh: pullToRefresh)
			tmpEmptyView?.fadeIn()
		}
	}
	
	open func addPullToRefresh(_ scrollView: UIScrollView, _ action: @escaping () -> Void) {
		refreshControl = UIRefreshControl()
		refreshControlActionCompletion = action
		refreshControl?.addTarget(self, action: #selector(pulledRefreshControl(_:)), for: UIControl.Event.valueChanged)
		scrollView.refreshControl = refreshControl
	}
	
	open func endPullToRefresh() {
		refreshControl?.endRefreshing()
	}
	
	@objc func pulledRefreshControl(_ sender: Any) {
		if let completion = refreshControlActionCompletion { completion() }
	}

}
