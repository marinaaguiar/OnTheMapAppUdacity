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
    @IBOutlet var linkTextLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!


    //MARK: Methods

    func fill(item: StudentLocation) {
        let mediaURL = item.mediaURL
        userNameTextLabel.text = "\(item.firstName) \(item.lastName)"
        iconImageView.image = UIImage(named: "locationGray")
        if mediaURL != "" {
            linkTextLabel.isHidden = false
            linkTextLabel.text = item.mediaURL
        } else {
            linkTextLabel.isHidden = true
        }
    }
}


class LoadingCell: UITableViewCell {

    static let identifier = "LoadingCell"

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
}

