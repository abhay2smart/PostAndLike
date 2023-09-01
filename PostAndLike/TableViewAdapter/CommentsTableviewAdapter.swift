//
//  CommentsTableviewAdapter.swift
//  PostAndLike
//
//  Created by Abhayjeet Singh on 31/08/23.
//

import Foundation


import UIKit

class CommentsTableviewAdapter: NSObject, RefreshDelegate {
    
    private var tableView: UITableView?
    private var root: UIViewController?
    private var cellIdentifier = "cell"
    
    private var vm:CommentsViewModel?
    
    func initialise(tableView: UITableView?, root: UIViewController, vm: CommentsViewModel) {
        self.vm = vm
        self.tableView = tableView
        self.root = root
        
        self.tableView?.dataSource = self
        
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
extension CommentsTableviewAdapter : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm?.comments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CommentsTableViewCell
        
        cell?.selectionStyle = .none
        cell?.delegate = self
        
        if indexPath.row < (vm?.comments.count ?? 0) {
            let rowData = vm?.comments[indexPath.row]
            cell?.fillInfo(info: rowData, indexPath: indexPath)
            
            if CommentPersistantManager.shared.isAlreadyLiked(id: rowData?.id ?? 0, postId: rowData?.postId ?? 0) {
                cell?.setLikeButton()
            } else {
                cell?.setUnlikeButton()
            }
            
        }
        return cell ?? UITableViewCell()
    }
}

// ButtonTapDelegate delegate

extension CommentsTableviewAdapter : ButtonTapDelegate {
    
    // handle tap to mark favourite/unfavourite
    func didTapped(indexPath: IndexPath) {
        let selectedItem = vm?.comments[indexPath.row]
        if let id = selectedItem?.id, let postId = selectedItem?.postId {
            let cell = tableView?.cellForRow(at: indexPath) as? CommentsTableViewCell
            
            let isLiked = CommentPersistantManager.shared.isAlreadyLiked(id: id, postId: postId)
            
            CommentPersistantManager.shared.setLikeUnLike(id: id, postId: postId, isFavourite: !isLiked) {[weak self] succes in
                if succes {
                    self?.tableView?.reloadData()
                } else {
                    let root = self?.root as? CommentsViewController
                    root?.showAlert(message: "Something went wrong")
                }
            }
        }
        
    }
    
    
}

