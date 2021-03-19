//
//  EmptyView.swift
//  
//
//  Created by Márk József Alexa on 2020. 08. 17..
//

import UIKit

open class EmptyView: BView {
	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var containerStackView: UIStackView!
	@IBOutlet var containerLabelStackView: UIStackView!
	@IBOutlet var mainTitleLabel: UILabel!
	@IBOutlet var secondaryTitleLabel: UILabel!
	@IBOutlet var mainImageView: UIImageView!
	@IBOutlet var actionButton: UIButton!
	@IBOutlet public var contentView: UIView!
	var actionButtonPressed: (() -> Void)?
	var pullToRefresh: (() -> Void)?

	public override func initInternals() {
		super.initInternals()
		createContentView()
		scrollView.alwaysBounceVertical = true
	}
	
	func config(title: String?, subtitle: String?, image: UIImage?, buttonTitle: String?, actionButtonPressed: (() -> Void)?, pullToRefresh: (() -> Void)?) {
		if let title = title {
			mainTitleLabel.text = title
		} else {
			containerLabelStackView.removeArrangedSubview(mainTitleLabel)
			mainTitleLabel.removeFromSuperview()
		}
		if let subtitle = subtitle {
			secondaryTitleLabel.text = subtitle
		} else {
			containerLabelStackView.removeArrangedSubview(secondaryTitleLabel)
			secondaryTitleLabel.removeFromSuperview()
		}
		if let buttonTitle = buttonTitle {
			actionButton.setTitle(buttonTitle, for: .normal)
		} else {
			containerStackView.removeArrangedSubview(actionButton)
			actionButton.removeFromSuperview()
		}
		if let image = image {
			mainImageView.image = image
		} else {
			containerStackView.removeArrangedSubview(mainImageView)
			mainImageView.removeFromSuperview()
		}
		scrollView.refreshControl = UIRefreshControl()
		scrollView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
		self.actionButtonPressed = actionButtonPressed
		self.pullToRefresh = pullToRefresh
	}
	
	func createContentView() {
		Bundle.module.loadNibNamed("EmptyView", owner: self)
		addSubview(contentView)
		contentView.frame = self.bounds
		contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
	}
	
	@IBAction func actionButtonPressed(_ button: UIButton) {
		if let completion = actionButtonPressed { completion() }
	}
	
	@objc func handleRefreshControl() {
		DispatchQueue.main.async {
			self.scrollView.refreshControl?.endRefreshing()
			if let completion = self.pullToRefresh { completion() }
		}
	}
}
