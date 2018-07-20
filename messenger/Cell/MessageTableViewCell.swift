//
//  MessengeTableViewCell.swift
//  messenger
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import Foundation
import UIKit

class MessageTableViewCell: UITableViewCell, ReactiveView {
    @IBOutlet weak var noteLabel: UILabel!
    
    func bindViewModel(viewModel: AnyObject) {
        let note = viewModel as! NoteModel
        noteLabel.text = note.text
    }
    
    func cellHeight() -> CGFloat {
        return 50
    }
}
