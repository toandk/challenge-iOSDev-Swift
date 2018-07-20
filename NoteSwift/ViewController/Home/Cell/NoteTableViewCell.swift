//
//  NoteTableViewCell.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import Foundation
import UIKit

class NoteTableViewCell: UITableViewCell, ReactiveView {
    @IBOutlet weak var noteLabel: UILabel!
    
    var note: NoteModel!
    
    func bindViewModel(viewModel: AnyObject) {
        self.note = viewModel as! NoteModel
        noteLabel.text = self.note.text
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        DTPlayer.sharedPlayer.play(filePath: self.note.getAudioFilePath())
    }
    
    func cellHeight() -> CGFloat {
        return 70
    }
}
