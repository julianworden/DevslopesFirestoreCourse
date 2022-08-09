//
//  PostDelegate.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/8/22.
//

import Foundation

protocol PostDelegate: AnyObject {
    func postCell(_ cell: PostTableViewCell, selectedDetailsForThought thought: Thought)
}
