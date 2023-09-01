//
//  PostViewModel.swift
//  PostAndLike
//
//  Created by Abhayjeet Singh on 31/08/23.
//



import Foundation
import UIKit
class PostViewModel: NSObject {
    var delegate:RefreshDelegate?
    private var postEndPoint = "posts"
    var posts = [PostModel]()
    
    func loadData() {
        if Network.shared.isConnectedToNetwork {
            fetchRemoteData()
        } else {
            fetchOfflineData()
        }
        
    }
    
    private func fetchRemoteData() {
        Network.shared.makeApiRequest(url: baseUrl + postEndPoint, expecting: [PostModel].self) { [weak self] responseData, error in
            if error == nil {
                if let responseData = responseData {
                    self?.saveDataLocally(codableData: responseData)
                    self?.posts = responseData
                    self?.delegate?.refreshData()
                }
            }
        }
    }
    
    private func saveDataLocally(codableData: [PostModel]) {
        let dispatchGroup = DispatchGroup()
        for item in codableData {
            dispatchGroup.enter()
            
            guard let id = item.id else {
                continue
            }
            
            if !PostPersistantManager.shared.isRecordExists(id: id) {
                PostPersistantManager.shared.saveSingleRecord(data: item) { isSaved in
                    dispatchGroup.leave()
                    print("Record saved \(id)")
                }
            }
        }
    }
    
    private func fetchOfflineData() {
        let localData = PostPersistantManager.shared.fetchRecordFromCoreData()
        guard let localData = localData else {
            return
        }
        posts = localData
        delegate?.refreshData()
    }
}
