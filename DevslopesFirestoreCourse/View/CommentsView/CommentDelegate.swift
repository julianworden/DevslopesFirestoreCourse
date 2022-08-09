//
//  CommentDelegate.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/8/22.
//

import Foundation

protocol CommentDelegate: AnyObject {
    func commentCell(_ cell: CommentTableViewCell, selectedDetailsForComment comment: Comment)
}
