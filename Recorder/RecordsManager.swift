//
//  RecordsManager.swift
//  Recorder
//
//  Created by Mehul Gupta on 3/25/20.
//  Copyright © 2020 Mehul Gupta. All rights reserved.
//

import UIKit

class RecordsManager: NSObject {

    static var Records = [Record]();
    
    // MARK: - Create
    class func append(record: Record) -> Void {
       Records.append(record)
    }
    
    class func insert(record: Record, at: Int = 0) -> Void {
        Records.insert(record, at: at)
    }
    
    // MARK: - Read
    class func get(recordAt index: Int) -> Record {
        if Records.count > 0 && index >= 0 {
            return Records[index]
        }
        return Record()
    }
    
    // MARK: - Update
    class func update(record old: Record, new: Record) {
        if Records.count > 0, let i = Records.firstIndex(of: old) {
            Records[i] = new
        }
    }
    
    // MARK: - Delete
    class func removeAll() -> Void {
        Records.removeAll()
    }
    class func delete(recordAt index: Int) {
        if Records.count > 0  && index >= 0 {
            Records.remove(at: index)
        }
    }
    class func delete(recordWith uuid: UUID) {
        if Records.count > 0 {
            let index = Records.firstIndex(where: {(record: Record) -> Bool in
                record.uuid == uuid
            })
            Records.remove(at: index!)
        }
    }
}
