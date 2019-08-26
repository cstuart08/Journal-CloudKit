//
//  EntryController.swift
//  Journal-CloudKit
//
//  Created by Apps on 8/26/19.
//  Copyright © 2019 Apps. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    // MARK: - Singleton
    static let sharedInstance = EntryController()
    
    // MARK: - S.O.T
    var entries: [Entry] = []
    let publicDB = CKContainer(identifier: "iCloud.com.CameronStuart.Journal-CloudKit").publicCloudDatabase
    
    func saveEntry(entry: Entry, completion:(@escaping (Bool) -> Void)) {
        let entryRecord = CKRecord(entry: entry)
        publicDB.save(entryRecord) { (_, error) in
            if let error = error {
                print("Error saving the entry: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // MARK: - CRUD
    // Create
    
    func addEntryWith(title: String, body: String, completion:(@escaping (Bool) -> Void)) {
        let newEntry = Entry(title: title, body: body)
        saveEntry(entry: newEntry) { (success) in
            self.entries.append(newEntry)
            completion(true)
        }
        completion(false)
    }
    
    // Read
    
    func fetchEntries(completion: @escaping (Bool) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: EntryConstants.RecordTypeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error saving the entry: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let records = records else { completion(false); return }
            let entries = records.compactMap({Entry(ckRecord: $0)})
            self.entries = entries
            completion(true)
        }
    }
    
    // Update
    
    func updateEntries(entry: Entry, newTitle: String, body: String) {
        entry.title = newTitle
        entry.body = body
        let entryRecord = CKRecord(entry: entry)
        let operation = CKModifyRecordsOperation(recordsToSave:[entryRecord], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { _,_,error in
            if let error = error {
                print("Error saving the entry: \(error.localizedDescription)")
                return
            }
        }
        self.publicDB.add(operation)
    }
    // Delete
    
    func deleteEntries(entry: Entry, completion: @escaping (Bool) -> Void) {
        let entryRecord = CKRecord(entry: entry)
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [entryRecord.recordID])
        //operation.savePolicy = .allKeys
        operation.modifyRecordsCompletionBlock = { _, _, error in
            if let error = error {
                print("Error saving the entry: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let index = self.entries.firstIndex(of: entry) else { completion(false); return }
            self.entries.remove(at: index)
        completion(true)
        }
        self.publicDB.add(operation)
    }
}
