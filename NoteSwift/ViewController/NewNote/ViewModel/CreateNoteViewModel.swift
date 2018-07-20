//
//  CreateNoteViewModel.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

class CreateNoteViewModel : BaseViewModel {
    var note: MutableProperty<String?> = MutableProperty(nil)
    var isLoading: MutableProperty<Bool> = MutableProperty(false)
    var audioFileName: String!
    var audioFilePath: String!
    var listPhoto: [UIImage] = []
    
    override init() {
        super.init()
        audioFileName = FileHelper.newAudioFileName()
        audioFilePath = FileHelper.filePath(name: audioFileName)
    }
    
    func speechToText() -> SignalProducer<String?, NSError> {
        return APIController().getTextFromAudio(filePath: self.audioFilePath)
            .observe(on: UIScheduler())
            .on(started: { [weak self] in
                self?.isLoading.value = true
                }, failed: { [weak self] (error) in
                    self?.isLoading.value = false
                }, completed: { [weak self] in
                    self?.isLoading.value = false
                }, value: { [weak self] note in
                    self?.note.value = note
            })
    }
    
    func saveListPhoto() -> [String] {
        var photos: [String] = []
        for photo in self.listPhoto {
            let binaryImageData = UIImagePNGRepresentation(photo)
            let fileName = FileHelper.newImageFileName()
            let filePath = FileHelper.filePath(name: fileName)
            try? binaryImageData?.write(to: URL(fileURLWithPath: filePath), options: .atomic)
            photos.append(fileName)
        }
        return photos
    }
    
    func saveData() -> Bool {
        if self.note.value == nil {
            return false
        }
        
        let note = NoteModel()
        note.audioFileName = self.audioFileName
        note.text = self.note.value!
        note.addPhotoList(self.saveListPhoto())
        if let location = LocationManager.sharedManager.currentLocation {
            note.longitude = location.longitude
            note.latitude = location.latitude
        }
        else {
            // We use the default location if we cannot get current location
            // This is only for testing, not recommend it.
            note.longitude = AppConstants.DEFAULT_LONGITUDE
            note.latitude = AppConstants.DEFAULT_LATITUDE
        }
        note.save()
        return true
    }
}
