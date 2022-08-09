//
//  Constants.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/5/22.
//

import Foundation
import Firebase
import UIKit

struct Constants {
    // Colors
    static let yellowColor = UIColor(
        red: 245/255,
        green: 130/255,
        blue: 12/2255,
        alpha: 1
    )
    static let grayColor = UIColor(
        red: 54/255,
        green: 54/255,
        blue: 54/255,
        alpha: 1
    )

    // Thought Data Model for Firebase
    static let fbThoughts = "thoughts"
    static let fbComments = "comments"
    static let fbCategory = "category"
    static let numberOfComments = "numberOfComments"
    static let numberOfLikes = "numberOfLikes"
    static let timestamp = "timestamp"
    static let fbThoughtText = "thoughtText"
    static let fbUsername = "username"
    static let fbCommentText = "commentText"
    static let fbUserId = "userId"
    static let fbDocumentId = "documentId"

    // User Data Model for Firebase
    static let fbUsers = "users"
    static let fbDateCreated = "dateCreated"

    // Firebase References
    static let thoughtsCollectionReference = Firestore.firestore().collection(fbThoughts)

    // Table View Reuse IDs
    static let postTableViewCellReuseId = "PostCell"
    static let commentTableViewCellReuseId = "CommentCell"
}
