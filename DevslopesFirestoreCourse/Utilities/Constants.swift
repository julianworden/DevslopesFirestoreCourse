//
//  Constants.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/5/22.
//

import Foundation
import UIKit

struct Constants {
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

    // Data Model for Firebase
    static let thoughts = "thoughts"
    static let category = "category"
    static let numberOfComments = "numberOfComments"
    static let numberOfLikes = "numberOfLikes"
    static let timestamp = "timestamp"
    static let thoughtText = "thoughtText"
    static let username = "username"
}
