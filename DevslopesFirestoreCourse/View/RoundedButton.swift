//
//  OrangeRoundedButton.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/7/22.
//

import UIKit

class RoundedButton: UIButton {

    convenience init(title: String, color: UIColor) {
        self.init()
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont(name: "Avenir Next Medium", size: 17)
        setTitleColor(.white, for: .normal)
        backgroundColor = color
        layer.cornerRadius = 4
    }
}
