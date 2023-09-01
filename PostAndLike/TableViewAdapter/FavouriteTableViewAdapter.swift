//
//  FavouriteTableViewAdapter.swift
//  PostAndLike
//
//  Created by Abhayjeet Singh on 31/08/23.
//

import Foundation
import UIKit

class FavouriteTableViewAdapter: NSObject {
    private var tableView: UITableView?
    private var root: UIViewController?
    private var cellIdentifier = "cell"
    
    var data = [CommentModel]()
    
    func initialise(tableView: UITableView?, root: UIViewController?) {
        self.tableView = tableView
        self.root = root
        self.tableView?.dataSource = self
        fetchData()
    }
    
    func fetchData() {
        if let data = CommentPersistantManager.shared.getFavouriteList() {
            self.data = data
            tableView?.reloadData()
        }
        
        
    }
    
}

extension FavouriteTableViewAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? FavouriteTableViewCell
        cell?.delegate = self
        if indexPath.row < data.count {
            let rowData = data[indexPath.row]
            cell?.fillInfo(info: rowData, indexPath: indexPath)
        }
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }
}

// Button tap handling to remove from favourite
extension FavouriteTableViewAdapter: ButtonTapDelegate {
    func didTapped(indexPath: IndexPath) {
        if indexPath.row < data.count {
            let selectedData = data[indexPath.row]
            if let id = selectedData.id, let postId = selectedData.postId {
                CommentPersistantManager.shared.setLikeUnLike(id: id, postId: postId, isFavourite: false) { [weak self] success in
                    if success {
                        self?.fetchData()
                    } else {
                        print("Unable to mark unlike \(String(describing: self)) \(#line)")
                    }
                }
            }
            
        }
    }
}
