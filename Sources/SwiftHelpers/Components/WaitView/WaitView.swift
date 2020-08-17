//
//  WaitView.swift
//  SwiftHelpers
//
//  Created by Márk József Alexa on 2020. 08. 17..
//

import UIKit

public class WaitView: BView {
	@IBOutlet var contentView: UIView!
	
	let indicatorView: UIActivityIndicatorView = {
		if #available(iOS 13.0, *) {
			return UIActivityIndicatorView(style: .medium)
		} else {
			return UIActivityIndicatorView(style: .gray)
		}
	}()
	
	override func initInternals() {
		super.initInternals()
		self.alpha = 0.0
	}
	
	public func show(nibName: String) {
		addCustomWaitViewOnce(nibName: nibName)
	}
	
	public func show() {
		addIndicatorOnce()
		indicatorView.startAnimating()
		self.fadeIn()
	}
	
	public func hide() {
		self.fadeOut()
		indicatorView.stopAnimating()
	}
	
	public func addIndicatorOnce() {
		if #available(iOS 13.0, *) {
			if UITraitCollection.current.userInterfaceStyle == .dark {
				indicatorView.color = .white
			} else {
				indicatorView.color = .gray
			}
		} else {
			indicatorView.color = .gray
		}
		if !self.subviews.contains(indicatorView) {
			self.addSubview(indicatorView)
			indicatorView.translatesAutoresizingMaskIntoConstraints = false
			self.translatesAutoresizingMaskIntoConstraints = false
			indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
			indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
			self.setNeedsLayout()
			self.layoutIfNeeded()
		}
	}
	
	public func addCustomWaitViewOnce(nibName: String) {
		if !self.subviews.contains(contentView) {
			Bundle.main.loadNibNamed(nibName, owner: self)
			addSubview(contentView)
			contentView.translatesAutoresizingMaskIntoConstraints = false
			contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
			contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
			contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
			if (self.traitCollection.horizontalSizeClass == .regular && self.traitCollection.verticalSizeClass == .regular) {
				contentView.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 10.0).isActive = true
				contentView.rightAnchor.constraint(greaterThanOrEqualTo: self.rightAnchor, constant: 10.0).isActive = true
				contentView.widthAnchor.constraint(equalToConstant: 320.0).isActive = true
			}
			else {
				contentView.translatesAutoresizingMaskIntoConstraints = true
				contentView.frame = self.bounds
				contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
			}
		}
		self.fadeIn()
	}
}
