//
//  CommentsViewController+CommentDelegate.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/8/22.
//

import Firebase
import Foundation
import UIKit

extension CommentsViewController: CommentDelegate {
    func commentCell(_ cell: CommentTableViewCell, selectedDetailsForComment comment: Comment) {
        let alert = UIAlertController(title: "Edit Comment", message: "You can delete or edit", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete Comment", style: .destructive) { action in
            self.firestore.runTransaction { transaction, _ in
                var thoughtDocument: DocumentSnapshot!
                var commentDocumentReference: DocumentReference!

                do {
                    try thoughtDocument = transaction
                        .getDocument(self.firestore.collection(Constants.thoughtsCollection)
                        .document(self.thought.documentId))
                } catch let error as NSError {
                    debugPrint("Fetch error: \(error)")
                    return nil
                }

                guard let oldNumComments = thoughtDocument.data()?[Constants.numberOfComments] as? Int else { return nil }
                transaction.updateData([Constants.numberOfComments: oldNumComments - 1], forDocument: self.thoughtReference)

                commentDocumentReference = self.firestore
                    .collection(Constants.thoughtsCollection)
                    .document(self.thought.documentId)
                    .collection(Constants.commentsCollection)
                    .document(comment.documentId)

                transaction.deleteDocument(commentDocumentReference)

                return nil
            } completion: {_, error in
                if let error = error {
                    debugPrint("Transaction failed: \(error)")
                }
            }
        }
        let editAction = UIAlertAction(title: "Edit Comment", style: .default) { action in
            // Edit comment
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(deleteAction)
        alert.addAction(editAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func deleteComment() {

    }
}
