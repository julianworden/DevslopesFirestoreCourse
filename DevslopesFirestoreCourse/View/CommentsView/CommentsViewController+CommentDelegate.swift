//
//  CommentsViewController+CommentDelegate.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/8/22.
//

import Firebase
import Foundation
import UIKit

// swiftlint:disable function_body_length
extension CommentsViewController: CommentDelegate {
    func commentCell(_ cell: CommentTableViewCell, selectedDetailsForComment comment: Comment) {
        let alert = UIAlertController(
            title: "Edit Comment",
            message: "You can delete or edit",
            preferredStyle: .actionSheet
        )
        let deleteAction = UIAlertAction(
            title: "Delete Comment",
            style: .destructive
        ) { _ in
            self.firestore.runTransaction { transaction, _ in
                var thoughtDocument: DocumentSnapshot!
                var commentDocumentReference: DocumentReference!

                do {
                    try thoughtDocument = transaction.getDocument(
                        Constants.thoughtsCollectionReference
                            .document(self.thought.documentId)
                    )
                } catch let error as NSError {
                    debugPrint("Fetch error: \(error)")
                    return nil
                }

                guard let oldNumComments = thoughtDocument.data()?[Constants.numberOfComments] as? Int else {
                    return nil
                }
                transaction.updateData(
                    [
                        Constants.numberOfComments: oldNumComments - 1
                    ],
                    forDocument: self.thoughtReference)

                commentDocumentReference = Constants.thoughtsCollectionReference
                    .document(self.thought.documentId)
                    .collection(Constants.fbComments)
                    .document(comment.documentId)

                transaction.deleteDocument(commentDocumentReference)

                return nil
            } completion: {_, error in
                if let error = error {
                    debugPrint("Transaction failed: \(error)")
                }
            }
        }
        let editAction = UIAlertAction(title: "Edit Comment", style: .default) { [weak self] _ in
            let updateCommentViewController = UpdateCommentViewController()
            updateCommentViewController.commentToEdit = comment
            updateCommentViewController.thoughtToEdit = self?.thought
            self?.navigationController?.pushViewController(updateCommentViewController, animated: true)
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
