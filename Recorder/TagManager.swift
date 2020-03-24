//
//  TagManager.swift
//  Recorder
//
//  Created by Mehul Gupta on 3/23/20.
//  Copyright © 2020 Mehul Gupta. All rights reserved.
//

import UIKit
import CoreData

class TagManager: NSObject {
    static var Tags = [[String]]()
    static var Records = [Record]()
    
    static var managedContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    class func FetchDistinctTags() {
        // Reset tags array
        Tags.removeAll()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Records.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: RecordsEntity.tag.rawValue, ascending: true)]
        request.propertiesToFetch = [RecordsEntity.tag.rawValue]
        request.propertiesToGroupBy = [RecordsEntity.tag.rawValue]
        request.returnsDistinctResults = true
        request.returnsObjectsAsFaults = false
        request.resultType = NSFetchRequestResultType.dictionaryResultType
        
        do {
            let result = try managedContext.fetch(request)
            var defaultTags = [String]()
            var distinctTags = [String]()
            for data in result {
                let value = (data as AnyObject).value(forKey: RecordsEntity.tag.rawValue) as? String
                if (value == nil) {
                    defaultTags.append(DEFAULT_TAG)
                } else {
                    distinctTags.append(value!.uppercased())
                }
            }
            if (defaultTags.count > 0) {
                Tags.append(defaultTags)
            }
            Tags.append(distinctTags)
        } catch {
            print("Failed to read data from entity - ", Entity.Records.rawValue)
        }
    }
    
    class func FetchRecords(for tag: String) {
        // Reset Records array
        Records.removeAll()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Records.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: RecordsEntity.header.rawValue, ascending: true)]
        request.predicate = NSPredicate(format: "\(RecordsEntity.tag.rawValue) == %@", tag as CVarArg)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext.fetch(request)
            for data in result as! [NSManagedObject] {
                let header = data.value(forKey: RecordsEntity.header.rawValue) as! String
                let field1 = data.value(forKey: RecordsEntity.field1.rawValue) as! String
                let field2 = data.value(forKey: RecordsEntity.field2.rawValue) as! String
                let tag = data.value(forKey: RecordsEntity.tag.rawValue) as? String
                let misc = data.value(forKey: RecordsEntity.misc.rawValue) as! String
                let uuid = data.value(forKey: RecordsEntity.uuid.rawValue) as? UUID
                AddRecord(header: header, field1: field1, field2: field2, tag: tag, misc: misc, uuid: uuid)
            }
            print(Records)
        } catch {
            print("Failed to retrive records for given tag -", tag)
        }
    }
    
    
    // Helper func
    class func InsertRecord(record: Record, at: Int) -> Void {
        Records.insert(record, at: at)
    }
    
    class func AddRecord(header: String, field1: String, field2: String, tag: String?, misc: String, uuid: UUID?) {
        Records.append(Record(header: header, field1: field1, field2: field2, tag: tag, misc: misc, uuid: uuid))
    }
    
    class func AddRecord(record: Record) {
        Records.append(record)
    }

    class func DeleteRecord(id: Int) {
        if Records.count > 0  && id >= 0 {
            Records.remove(at: id)
        }
    }
    
    class func GetRecord(id: Int) -> Record {
        if Records.count > 0 && id >= 0 {
            return Records[id]
        }
        return Record()
    }
    
    class func UpdateRecord(oldRecord: Record, record: Record) {
        if Records.count > 0, let i = Records.firstIndex(of: oldRecord) {
            Records[i] = record
        }
    }
}
