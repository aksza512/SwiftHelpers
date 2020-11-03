//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 11. 02..
//

import UIKit

public extension UICollectionView {
	func registerCell(_ identifiers: String...) {
		for identifier in identifiers {
			register(UINib.init(nibName: identifier, bundle: Bundle.main), forCellWithReuseIdentifier: identifier)
		}
	}
}
