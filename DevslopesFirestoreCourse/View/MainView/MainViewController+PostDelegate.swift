//
//  MainViewController+PostDelegate.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/8/22.
//

import Firebase
import Foundation
import UIKit

extension MainViewController: PostDelegate {
    func postCell(_ cell: PostTableViewCell, selectedDetailsForThought thought: Thought) {
        let alert = UIAlertController(
            title: "Delete",
            message: "Do you want to delete your thought?",
            preferredStyle: .actionSheet
        )
        let deleteAction = UIAlertAction(title: "Delete Thought", style: .destructive) { _ in
            self.delete(
                collection: Constants.thoughtsCollectionReference
                    .document(thought.documentId).collection(Constants.fbComments)
            ) { error in
                if let error = error {
                    debugPrint("Could not delete thought's comments: \(error.localizedDescription)")
                } else {
                    Constants.thoughtsCollectionReference
                        .document(thought.documentId)
                        .delete { error in
                            if let error = error {
                                debugPrint("Could not delete thought: \(error.localizedDescription)")
                            }
                        }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func delete(
        collection: CollectionReference,
        batchSize: Int = 100,
        completion: @escaping (Error?) -> ()
    ) {
        collection.limit(to: batchSize).getDocuments { (docset, error) in
            guard let docset = docset else {
                completion(error)
                return
            }

            guard docset.count > 0 else {
                completion(nil)
                return
            }

            let batch = collection.firestore.batch()
            docset.documents.forEach {batch.deleteDocument($0.reference)}

            batch.commit { (batchError) in
                if let batchError = batchError {
                    completion(batchError)
                } else {
                    self.delete(collection: collection, batchSize: batchSize, completion: completion)
                }
            }
        }
    }
}
