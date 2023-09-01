//
//  PostTableViewCell.swift
//  PostAndLike
//
//  Created by Abhayjeet Singh on 31/08/23.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var body: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillInfo(info: PostModel?) {
        guard let info = info else {
            return
        }
        title?.text = info.title
        body?.text = info.body
        
        
        // save the data
//        guard let id = info.id else {
//            return
//        }
//        
//        if !PostPersistantManager.shared.isRecordExists(id: id) {
//            PostPersistantManager.shared.saveSingleRecord(data: info) { isSaved in
//                print("Record saved \(id)")
//            }
//        }
        
        
    }

    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
