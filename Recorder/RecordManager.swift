//
//  RecordManager.swift
//  Recorder
//
//  Created by Mehul Gupta on 3/22/20.
//  Copyright © 2020 Mehul Gupta. All rights reserved.
//

import UIKit
import CoreData

enum Entity: String {
    case Records = "Records"
}

enum RecordsEntity: String {
    case header = "header"
    case field1 = "field1"
    case field2 = "field2"
    case tag = "tag"
    case misc = "misc"
    case uuid = "uuid"
}

class RecordManager: NSObject {

    static var Records = [Record]();
    
    static var managedContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
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
    
    class func Fetch() {
        // Reset records
        Records.removeAll()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Records.rawValue)
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
//            displayCDRecords()
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

    class func Save(header: String, field1: String, field2: String, tag: String, misc: String) {
        let record = Record(header: header, field1: field1, field2: field2, tag: tag, misc: misc, uuid: UUID())

        let recordsEntity = NSEntityDescription.entity(forEntityName: Entity.Records.rawValue, in: managedContext)
        let newRecord = NSManagedObject(entity: recordsEntity!, insertInto: managedContext)
        newRecord.setValue(record.header, forKey: RecordsEntity.header.rawValue)
        newRecord.setValue(record.field1, forKey: RecordsEntity.field1.rawValue)
        newRecord.setValue(record.field2, forKey: RecordsEntity.field2.rawValue)
        newRecord.setValue(record.tag, forKey: RecordsEntity.tag.rawValue)
        newRecord.setValue(record.misc, forKey: RecordsEntity.misc.rawValue)
        newRecord.setValue(record.uuid, forKey: RecordsEntity.uuid.rawValue)
        
        do {
            try managedContext.save()
            AddRecord(record: record)
//            displayCDRecords()
        } catch {
            print("Failed to save record for entity - ", Entity.Records.rawValue)
        }
    }
    
    class func Save(record: Record, at: Int = 0) -> Void {
        let recordsEntity = NSEntityDescription.entity(forEntityName: Entity.Records.rawValue, in: managedContext)
        let newRecord = NSManagedObject(entity: recordsEntity!, insertInto: managedContext)
        newRecord.setValue(record.header, forKey: RecordsEntity.header.rawValue)
        newRecord.setValue(record.field1, forKey: RecordsEntity.field1.rawValue)
        newRecord.setValue(record.field2, forKey: RecordsEntity.field2.rawValue)
        newRecord.setValue(record.tag, forKey: RecordsEntity.tag.rawValue)
        newRecord.setValue(record.misc, forKey: RecordsEntity.misc.rawValue)
        newRecord.setValue(record.uuid, forKey: RecordsEntity.uuid.rawValue)
        
        do {
            try managedContext.save()
            InsertRecord(record: record, at: 0)
//            displayCDRecords()
        } catch {
            print("Failed to save record for entity - ", Entity.Records.rawValue)
        }
    }
    
    class func Update(oldRecord: Record, header: String, field1: String, field2: String, tag: String, misc: String) {
        let record = Record(header: header, field1: field1, field2: field2, tag: tag, misc: misc, uuid: oldRecord.uuid!)
        
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: Entity.Records.rawValue)
        request.predicate = NSPredicate(format: "uuid == %@", record.uuid! as CVarArg)
        
        do {
            let test = try managedContext.fetch(request)
            let updatedRecord = test[0] as! NSManagedObject
            updatedRecord.setValue(record.header, forKey: RecordsEntity.header.rawValue)
            updatedRecord.setValue(record.field1, forKey: RecordsEntity.field1.rawValue)
            updatedRecord.setValue(record.field2, forKey: RecordsEntity.field2.rawValue)
            updatedRecord.setValue(record.tag, forKey: RecordsEntity.tag.rawValue)
            updatedRecord.setValue(record.misc, forKey: RecordsEntity.misc.rawValue)
            updatedRecord.setValue(record.uuid, forKey: RecordsEntity.uuid.rawValue)
            
            do {
                try managedContext.save()
                UpdateRecord(oldRecord: oldRecord, record: record)
//                displayCDRecords()
            } catch {
                print("Failed to update record while saving for entity - ", Entity.Records.rawValue)
            }
        } catch {
            print("Failed to update record while reading for entity - ", Entity.Records.rawValue)
        }
    }
    
    class func Delete(forRecordAt: Int) {
        let record = GetRecord(id: forRecordAt)
        
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: Entity.Records.rawValue)
        request.predicate = NSPredicate(format: "uuid == %@", record.uuid! as CVarArg)
        
        do {
            let test = try managedContext.fetch(request)
            let recordToDelete = test[0] as! NSManagedObject
            managedContext.delete(recordToDelete)
            try managedContext.save()
            DeleteRecord(id: forRecordAt)
        } catch {
            print("Failed to delete record while reading for entity - ", Entity.Records.rawValue)
        }
//        displayCDRecords()
    }

//    class func displayCDRecords() {
//        print("\n\n\n Display CD Records")
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Records.rawValue)
//        request.returnsObjectsAsFaults = false
//        do {
//            let result = try managedContext.fetch(request)
//            for data in result as! [NSManagedObject] {
//                let header = data.value(forKey: RecordsEntity.header.rawValue) as! String
//                let field1 = data.value(forKey: RecordsEntity.field1.rawValue) as! String
//                let field2 = data.value(forKey: RecordsEntity.field2.rawValue) as! String
//                let misc = data.value(forKey: RecordsEntity.misc.rawValue) as! String
//                let uuid = data.value(forKey: RecordsEntity.uuid.rawValue) as? UUID
//
//                print("----- CURRENT RECORD ----- \n header:", header, "\n field1", field1, "\n field2", field2, "\n misc", misc, "\n uuid", uuid!)
//          }
//
//        } catch {
//            print("Failed to display data from entity - ", Entity.Records.rawValue)
//        }
//    }
}
