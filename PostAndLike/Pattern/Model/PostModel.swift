//
//  PostModel.swift
//  PostAndLike
//
//  Created by Abhayjeet Singh on 31/08/23.
//

import Foundation
 
struct PostModel: Codable {
    var id: Int?
    var userId: Int?
    var title: String?
    var body: String?
}
