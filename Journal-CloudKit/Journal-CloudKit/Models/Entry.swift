//
//  Entry.swift
//  Journal-CloudKit
//
//  Created by Apps on 8/26/19.
//  Copyright © 2019 Apps. All rights reserved.
//

import Foundation
import CloudKit

struct EntryConstants {
    static let TitleKey = "title"
    static let BodyKey = "body"
    static let TimestampKey = "timestamp"
    static let RecordTypeKey = "Entry"
}

class Entry {
    
    var title: String
    var body: String
    let timestamp: Date
    let ckRecordID: CKRecord.ID
    
    init(title: String, body: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.RecordTypeKey, recordID: entry.ckRecordID)
        self.setValue(entry.title, forKey: EntryConstants.TitleKey)
        self.setValue(entry.body, forKey: EntryConstants.BodyKey)
        self.setValue(entry.timestamp, forKey: EntryConstants.TimestampKey)
    }
}

extension Entry {
    convenience init?(ckRecord: CKRecord) {
        guard let entryTitle = ckRecord[EntryConstants.TitleKey] as? String,
        let entryBody = ckRecord[EntryConstants.BodyKey] as? String,
        let entryTimestamp = ckRecord[EntryConstants.TimestampKey] as? Date else { return nil }
        self.init(title: entryTitle, body: entryBody, timestamp: entryTimestamp, ckRecordID: ckRecord.recordID)
    }
}

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
       return lhs.title == rhs.title && lhs.timestamp == rhs.timestamp && lhs.body == rhs.body && lhs.ckRecordID == rhs.ckRecordID
    }
}
