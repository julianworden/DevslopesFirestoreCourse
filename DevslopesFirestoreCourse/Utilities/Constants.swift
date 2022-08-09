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
    static let thoughtsCollection = "thoughts"
    static let commentsCollection = "comments"
    static let category = "category"
    static let numberOfComments = "numberOfComments"
    static let numberOfLikes = "numberOfLikes"
    static let timestamp = "timestamp"
    static let thoughtText = "thoughtText"
    static let username = "username"
    static let commentText = "commentText"
    static let userId = "userId"
    static let documentId = "documentId"

    // User Data Model for Firebase
    static let usersCollection = "users"
    static let dateCreated = "dateCreated"

    // Firebase References
    static let thoughtsCollectionReference = Firestore.firestore().collection(thoughtsCollection)

    // Table View Reuse IDs
    static let postTableViewCellReuseId = "PostCell"
    static let commentTableViewCellReuseId = "CommentCell"
}
