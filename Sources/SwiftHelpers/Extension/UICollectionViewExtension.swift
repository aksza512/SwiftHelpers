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

@available(iOS 13.0, *)
public extension UICollectionViewDiffableDataSource {
	func reloadData(snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, completion: (() -> Void)? = nil) {
		if #available(iOS 15.0, *) {
			self.applySnapshotUsingReloadData(snapshot, completion: completion)
		} else {
			self.apply(snapshot, animatingDifferences: false, completion: completion)
		}
	}
}
