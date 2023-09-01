//
//  CommentsTableViewCell.swift
//  PostAndLike
//
//  Created by Abhayjeet Singh on 31/08/23.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var email: UILabel?
    @IBOutlet weak var comment: UILabel?
    @IBOutlet weak var likeButton: UIButton?
    
    private var indexPath: IndexPath?
    var delegate: ButtonTapDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillInfo(info: CommentModel?, indexPath: IndexPath) {
        guard let info = info else {
            return
        }
        
        self.indexPath = indexPath
        
        name?.text = info.name
        email?.text = info.email
        comment?.text = info.body
    }
    
    func setLikeButton() {
        let likeImage = UIImage(systemName: "heart.fill")
        likeButton?.setImage(likeImage, for: .normal)
    }
    
    func setUnlikeButton() {
        let likeImage = UIImage(systemName: "heart")
        likeButton?.setImage(likeImage, for: .normal)
    }
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
        if let indexPath = self.indexPath {
            delegate?.didTapped(indexPath: indexPath)
        }
    }
}
