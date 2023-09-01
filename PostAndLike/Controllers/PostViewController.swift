//
//  ViewController.swift
//  PostAndLike
//
//  Created by Abhayjeet Singh on 31/08/23.
//

import UIKit

class PostViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    let tableViewAdapter = PostTableViewAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // show the alert if not connected to internet
        if !Network.shared.isConnectedToNetwork {
            showAlert()
        }
        tableViewAdapter.initialise(tableView: tableView, root: self, vm: PostViewModel())
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "No Internect Connection", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

