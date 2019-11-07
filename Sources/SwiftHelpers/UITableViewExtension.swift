//
//  File.swift
//  
//
//  Created by Alexa Márk on 2019. 11. 07..
//

import UIKit

public extension UITableView {
    func registerCell(_ identifiers: String...) {
        for identifier in identifiers {
            register(UINib.init(nibName: identifier, bundle: Bundle.main), forCellReuseIdentifier: identifier)
        }
    }
    
    func dequeueCell(_ cellName: String, indexPath: IndexPath) -> UITableViewCell? {
        dequeueReusableCell(withIdentifier: cellName, for: indexPath)
    }
}
