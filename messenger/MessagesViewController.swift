//
//  MessagesViewController.swift
//  messenger
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    let viewModel = HomeViewModel()
    
    var tableViewBinder: TableViewBinding<NoteModel>!
    
    var savedConversation: MSConversation?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseHelper.migrateRealm()
        
        bindViewModel()
        viewModel.updateListNote()
    }
    
    func sendAttachment(_ note: NoteModel) {
        let audioURL = URL(fileURLWithPath: note.getAudioFilePath())
        savedConversation?.insertAttachment(audioURL, withAlternateFilename: nil, completionHandler: nil)
    }
    
    func sendTextMessage(_ note: NoteModel) {
        let message = MSMessage()
        let layout = MSMessageTemplateLayout()
        layout.caption = "Audio Note"
        layout.subcaption = note.text
        message.layout = layout
        savedConversation?.insert(message, completionHandler: nil)
    }
    
    func bindViewModel() {
        tableViewBinder = TableViewBinding(tableView: tableView, sourceSignal: viewModel.listNote.producer, cellName: "MessageTableViewCell")
        tableViewBinder.didSelectRowClosure = { [weak self] item in
            let note = item as! NoteModel
            self?.sendAttachment(note)
            
//             Replace above line by below lines to send text message
//            self?.sendTextMessage(note)
        }
    }
    
    override func willBecomeActive(with conversation: MSConversation) {
        savedConversation = conversation
    }

}
