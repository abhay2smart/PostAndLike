//
//  FavouriteViewController.swift
//  PostAndLike
//
//  Created by Abhayjeet Singh on 31/08/23.
//

import UIKit

class FavouriteViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    private var favouriteTableViewAdapter = FavouriteTableViewAdapter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favourite"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favouriteTableViewAdapter.initialise(tableView: tableView, root: self)
    }

}
