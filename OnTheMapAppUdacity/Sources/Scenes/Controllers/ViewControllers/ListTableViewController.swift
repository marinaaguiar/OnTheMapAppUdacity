//
//  ListViewController.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 5/17/22.
//

import UIKit
import SafariServices

class ListTableViewController: UIViewController {

    // MARK: Properties
    var results: [StudentLocation] = []
    private var isLoading = false
    var itemsCount = UserAuthentication.itemsCounts

    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!

    //MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControl()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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

    @IBAction func logoutButtonPressed(_ sender: Any) {
        UserAuthentication.logout(completion: handleSessionResponse(success:error:))
    }

    //MARK: Methods

    func configureRefreshControl() {
       // Add the refresh control to your UIScrollView object.
       tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                          for: .valueChanged)
    }

    @objc func handleRefreshControl() {
       // Update your content…
        results.removeAll()
        itemsCount = 15
        loadMoreData()
        tableView.reloadData()
       // Dismiss the refresh control.
       DispatchQueue.main.async {
          self.tableView.refreshControl?.endRefreshing()
       }
    }

    func handleSessionResponse(success: Bool, error: Error?) {
        if success {
            dismiss(animated: true)
        } else {
            Alert.showBasics(title: "Logout Failed", message: "\(error?.localizedDescription)", vc: self)
        }
    }

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

    func getLocationList(itemsCount: Int) {
        UserAuthentication.getStudentsLocationList(itemsCount: itemsCount, completion: { results, error in
            DispatchQueue.main.async {
                self.results.append(contentsOf: results)
                self.tableView.reloadData()
            }
        })
    }

    func loadMoreData() {
        if !isLoading {
            isLoading = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.getLocationList(itemsCount: self.itemsCount)
                self.itemsCount += 30
                self.isLoading = false
                self.tableView.reloadData()
            }
        }
    }

    func isScrollViewAtEnd() -> Bool {

        let offsetY = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height

        if offsetY > contentHeight - tableView.frame.size.height {
            return true
        } else {
            return false
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isScrollViewAtEnd() {
            loadMoreData()
        }
    }
}
    //MARK: - UITableViewDataSource

extension ListTableViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return results.count
        } else if section == 1 {
            //Return the Loading cell
            return 1
        } else {
            //Return nothing
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {

        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        cell.fill(item: results[indexPath.row])
        return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.identifier, for: indexPath) as! LoadingCell
            cell.loadingIndicator.startAnimating()
            return cell
        }
    }
}

    //MARK: - UITableViewDelegate

extension ListTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let url = URL(string: results[indexPath.row].mediaURL) else {
            tableView.deselectRow(at: indexPath, animated: true)
            Alert.showBasics(title: "Not Able to Open Student Profile", message: "This student does not have a valid link associated", vc: self)
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            tableView.deselectRow(at: indexPath, animated: true)
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            Alert.showBasics(title: "Not Able to Open Student Profile", message: "This student does not have a valid link associated", vc: self)
        }
    }
}

