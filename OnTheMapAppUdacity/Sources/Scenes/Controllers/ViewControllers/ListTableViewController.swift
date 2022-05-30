//
//  ListViewController.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/17/22.
//

import UIKit

class ListTableViewController: UIViewController {

    // MARK: Properties
    var results: [StudentLocation] = []

    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!

    //MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UserAuthentication.getStudentsLocationList { results, error in
            self.results = results
            self.tableView.reloadData()
        }
    }

    //MARK: Interaction Methods

    @IBAction func addLocationButtonPressed(_ sender: Any) {
        if UserAuthentication.Auth.latitude == 0.0 && UserAuthentication.Auth.longitude == 0.0 {
            let addLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
            self.show(addLocationViewController, sender: self)
        } else {
            presentAlert()
        }

    }
    @IBAction func reloadButtonPressed(_ sender: Any) {
    }

    //MARK: Methods

    func presentAlert() {
        let alert = UIAlertController(title: "", message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true)
        }))

        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { action in
            let addLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
            self.show(addLocationViewController, sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
    //MARK: - UITableViewDataSource

extension ListTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier,
                                                 for: indexPath) as! ListTableViewCell
        cell.fill(item: results[indexPath.row])
        return cell
    }
}

    //MARK: - UITableViewDelegate

extension ListTableViewController: UITableViewDelegate {

}

