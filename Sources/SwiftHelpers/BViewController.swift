//
//  BViewController.swift
//  SwiftHelpers
//
//  Created by Alexa Márk on 2019. 11. 07..
//

import UIKit

open class BViewController: UIViewController {
    @IBOutlet public weak var tableView: UITableView!
    
    @IBAction func closeButtonPressed(_ button: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
