//
//  AddThoughtViewController+UITextViewDelegate.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/5/22.
//

import Foundation
import UIKit

extension AddThoughtViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "My random thought..." {
            textView.text = ""
            textView.textColor = .darkGray
        }
    }
}
