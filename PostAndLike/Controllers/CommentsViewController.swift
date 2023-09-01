//
//  CommentsViewController.swift
//  PostAndLike
//
//  Created by Abhayjeet Singh on 31/08/23.
//

import UIKit

class CommentsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    
    private var commentsTableviewAdpter = CommentsTableviewAdapter()
    private var postId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Comments"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !Network.shared.isConnectedToNetwork {
            showAlert(message: "No Internect Connection")
        }
        commentsTableviewAdpter.initialise(tableView: tableView, root: self, vm: CommentsViewModel(postId: postId ?? 0))
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    

}

// storyboard instance

extension CommentsViewController {
    class func instance(postId: Int)->CommentsViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CommentsVC") as? CommentsViewController
        vc?.postId = postId
        return vc
    }
}
