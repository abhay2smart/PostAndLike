//
//  CommentModel.swift
//  PostAndLike
//
//  Created by Abhayjeet Singh on 31/08/23.
//

import Foundation

struct CommentModel: Codable {
    var postId: Int?
    var id: Int?
    var name: String?
    var email: String?
    var body: String?
}
