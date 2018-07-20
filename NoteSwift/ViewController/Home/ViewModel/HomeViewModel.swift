//
//  HomeViewModel.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import Foundation
import ReactiveSwift
import RealmSwift

class HomeViewModel : BaseViewModel {
    var listNote = MutableProperty<[NoteModel]>([])
    
    override init() {
        super.init()
    }
    
    func updateListNote() {
        self.listNote.value = NoteModel.getListAllNotes()
    }
    
    func getNote(atIndex: NSInteger) -> NoteModel? {
        if atIndex < self.listNote.value.count {
            return self.listNote.value[atIndex]
        }
        return nil
    }
}
