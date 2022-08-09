//
//  Comment.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/7/22.
//

import Firebase
import Foundation

struct Comment {
    private(set) var username: String
    private(set) var timestamp: Timestamp
    private(set) var commentText: String
    private(set) var documentId: String
    private(set) var userId: String

    static func parseData(snapshot: QuerySnapshot?) -> [Comment] {
        var comments = [Comment]()

        guard let snapshot = snapshot else { return comments }
        for document in snapshot.documents {
            let data = document.data()
            let username = data[Constants.fbUsername] as? String ?? "Anonymous"
            let timestamp = data[Constants.timestamp] as? Timestamp ?? Timestamp(date: Date())
            let commentText = data[Constants.fbCommentText] as? String ?? ""
            let documentId = document.documentID
            let userId = data[Constants.fbUserId] as? String ?? ""

            let comment = Comment(
                username: username,
                timestamp: timestamp,
                commentText: commentText,
                documentId: documentId,
                userId: userId
            )

            comments.append(comment)
        }

        return comments
    }
}
