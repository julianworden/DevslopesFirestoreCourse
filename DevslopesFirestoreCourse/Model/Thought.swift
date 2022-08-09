//
//  Thought.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/6/22.
//

import Firebase
import Foundation

struct Thought: Equatable {
    private(set) var username: String
    private(set) var timestamp: Timestamp
    private(set) var thoughtText: String
    private(set) var numberOfLikes: Int
    private(set) var numberOfComments: Int
    private(set) var documentId: String
    private(set) var userId: String

    static func parseData(snapshot: QuerySnapshot?) -> [Thought] {
        var thoughts = [Thought]()

        guard let snapshot = snapshot else { return thoughts }
        for document in snapshot.documents {
            let data = document.data()
            let username = data[Constants.fbUsername] as? String ?? "Anonymous"
            let timestamp = data[Constants.timestamp] as? Timestamp ?? Timestamp(date: Date())
            let thoughtText = data[Constants.fbThoughtText] as? String ?? ""
            let numberOfLikes = data[Constants.numberOfLikes] as? Int ?? 0
            let numberOfComments = data[Constants.numberOfComments] as? Int ?? 0
            let documentId =  document.documentID
            let userId = data[Constants.fbUserId] as? String ?? ""

            let thought = Thought(
                username: username,
                timestamp: timestamp,
                thoughtText: thoughtText,
                numberOfLikes: numberOfLikes,
                numberOfComments: numberOfComments,
                documentId: documentId,
                userId: userId
            )

            thoughts.append(thought)
        }

        return thoughts
    }
}
