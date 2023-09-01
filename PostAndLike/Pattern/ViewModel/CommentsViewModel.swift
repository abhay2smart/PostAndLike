//
//  CommentsViewModel.swift
//  PostAndLike
//
//  Created by Abhayjeet Singh on 31/08/23.
//

import Foundation

class CommentsViewModel: NSObject {
    var delegate: RefreshDelegate?
    var comments = [CommentModel]()
    private var postId:Int
    
    init(postId: Int) {
        self.postId = postId
    }
    
    
    func loadData() {
        if Network.shared.isConnectedToNetwork {
            fetchRemoteData()
        } else {
            fetchLocalData()
        }
    }
    
    private func fetchRemoteData() {
        let url = baseUrl + "posts/\(postId)/comments"
        print(url)
        Network.shared.makeApiRequest(url: url, expecting: [CommentModel].self) { [weak self] response, error in
            if error == nil {
                guard let response = response else {
                    return
                }
                self?.saveCommentsLocally(data: response)
                self?.comments = response
                self?.delegate?.refreshData()
            } else {
                print("error \(error)")
            }
        }
    }
    
    private func fetchLocalData() {
        guard let data = CommentPersistantManager.shared.fetchRecordFromCoreDataByPostId(postId: postId) else {
            return
        }
        
        comments = data
        delegate?.refreshData()
    }
    
    private func saveCommentsLocally(data: [CommentModel]) {
        let dispatchGroup = DispatchGroup()
        for item in data {
            dispatchGroup.enter()
            
            guard let id = item.id else {
                continue
            }
            
            if let postId = item.postId {
                if !CommentPersistantManager.shared.isRecordExists(id: id, postId: postId) {
                    CommentPersistantManager.shared.saveSingleRecord(data: item) { isSaved in
                        dispatchGroup.leave()
                        print("comments saved \(id)")
                    }
                }
            }
            
        }
    }
}
