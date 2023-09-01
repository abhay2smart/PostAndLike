//
//  PostTableViewAdapter.swift
//  PostAndLike
//
//  Created by Abhayjeet Singh on 30/08/23.
//

import Foundation
import UIKit

class PostTableViewAdapter: NSObject, RefreshDelegate {
    
    private var tableView: UITableView?
    private var root: UIViewController?
    private var cellIdentifier = "cell"
    
    private var vm:PostViewModel?
    
    func initialise(tableView: UITableView?, root: UIViewController, vm: PostViewModel) {
        self.vm = vm
        self.tableView = tableView
        self.root = root
        
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        vm.delegate = self
        vm.loadData()
    }
    
    func refreshData() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
 
}

// tableview data source
extension PostTableViewAdapter : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm?.posts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PostTableViewCell
        
        cell?.selectionStyle = .none
        
        if indexPath.row < (vm?.posts.count ?? 0) {
            cell?.fillInfo(info: vm?.posts[indexPath.row])
        }
        return cell ?? UITableViewCell()
    }
}

// tableview delegate

extension PostTableViewAdapter : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < (vm?.posts.count ?? 0) {
            let tappedData = vm?.posts[indexPath.row]
            if let postId = tappedData?.id {
                guard let commentsVC = CommentsViewController.instance(postId: postId) else {
                    return
                }
                
                //let postViewController = root as? PostViewController

                self.root?.navigationController?.pushViewController(commentsVC, animated: true)
            }
        }
    }
}
