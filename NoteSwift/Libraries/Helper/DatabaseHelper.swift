//
//  DatabaseHelper.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseHelper {
    static func migrateRealm() {
        let databaseDirectoryPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppConstants.APP_GROUP_NAME)
        let databasePath = databaseDirectoryPath?.appendingPathComponent("database.realm")
        var config = Realm.Configuration(fileURL: databasePath)
        config.schemaVersion = AppConstants.REALM_DB_VERSION
        config.migrationBlock = { (oldRealm, newRealm) in
            
        }
        Realm.Configuration.defaultConfiguration = config
    }
}
