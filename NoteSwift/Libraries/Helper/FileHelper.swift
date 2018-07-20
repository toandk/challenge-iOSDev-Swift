//
//  FileHelper.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import Foundation
import QuartzCore

class FileHelper {
    static func documentPath() -> String {
        //        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppConstants.APP_GROUP_NAME)?.path
        return path ?? ""
    }
    
    static func newAudioFileName() -> String {
        let time = CACurrentMediaTime()
        return String(format: "sound_%.0f.caf", time)
    }
    
    static func newImageFileName() -> String {
        return String(format: "image_%.0f_%d", CACurrentMediaTime(), arc4random() % 10000)
    }
    
    static func filePath(name: String) -> String {
        return documentPath().appendingFormat("/%@", name)
    }
}
