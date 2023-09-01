//
//  FavouriteTableViewCell.swift
//  PostAndLike
//
//  Created by Abhayjeet Singh on 31/08/23.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var email: UILabel?
    @IBOutlet weak var comment: UILabel?
    
    private var indexPath: IndexPath?
    var delegate: ButtonTapDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func unlikeAction(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.didTapped(indexPath: indexPath)
        }
        
    }

}
