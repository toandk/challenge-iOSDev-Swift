//
//  NoteModel.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import Foundation
import RealmSwift

class NoteModel: Object {
    @objc dynamic var text = ""
    @objc dynamic var audioFileName = ""
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    let listPhoto = List<PhotoModel>()
    
    func addPhotoList(_ list: [String]) {
        for fileName in list {
            let photo = PhotoModel()
            photo.fileName = fileName
            self.listPhoto.append(photo)
        }
    }
    
    func getAudioFilePath() -> String {
        return FileHelper.filePath(name: self.audioFileName)
    }
    
    func save() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }
    
    class func getListAllNotes() -> [NoteModel] {
        if let realm = try? Realm() {
            let list = realm.objects(NoteModel.self)
            var notes: [NoteModel] = []
            for note in list {
                notes.append(note)
            }
            return notes
        }
        return []
    }
}
