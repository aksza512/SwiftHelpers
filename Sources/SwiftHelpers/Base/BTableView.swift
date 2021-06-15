//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 08. 17..
//

import UIKit

@objc public protocol BTableViewDelegate: AnyObject {
	func didPullToRefresh()
}

public class BTableView: UITableView {
	@IBOutlet weak var bTableViewDelegate: BTableViewDelegate?
	public let tmpRefreshControl = UIRefreshControl()
	
	@IBInspectable var pullToRefresh: Bool = false {
		willSet {
			self.addSubview(tmpRefreshControl)
			tmpRefreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
		}
	}
	
	@objc private func refresh(_ sender: Any) {
		bTableViewDelegate?.didPullToRefresh()
	}
	
	public func endRefreshing() {
		tmpRefreshControl.endRefreshing()
	}
}
