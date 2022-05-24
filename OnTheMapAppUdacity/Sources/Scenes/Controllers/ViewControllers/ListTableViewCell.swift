//
//  StudentLocationTableViewCell.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/17/22.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    // MARK: Properties

    static let identifier = "TableViewCell"

    //MARK: Outlets

    @IBOutlet var userNameTextLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!


    //MARK: Methods

    func fill(item: StudentLocation) {
        userNameTextLabel.text = "\(item.firstName) \(item.lastName)"
        iconImageView.image = UIImage(named: "locationGray")
    }
}
