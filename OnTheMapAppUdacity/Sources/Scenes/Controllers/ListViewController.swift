//
//  ListViewController.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/17/22.
//

import UIKit

class ListViewController: UIViewController {

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

        UserAuthentication.getStudentsLocation { results, error in
            self.results = results
            self.tableView.reloadData()
        }
    }

    //MARK: Interaction Methods

    @IBAction func addLocationButtonPressed(_ sender: Any) {
    }
    @IBAction func reloadButtonPressed(_ sender: Any) {
    }
}
    //MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {

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

extension ListViewController: UITableViewDelegate {

}

