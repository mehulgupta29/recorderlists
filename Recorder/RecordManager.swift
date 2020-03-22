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
    case misc = "misc"
    case uuid = "uuid"
}

class RecordManager: NSObject {

    static var records = [Record]();
    
    static var managedContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    class func addRecord(header: String, field1: String, field2: String, misc: String, uuid: UUID?) {
        let record = Record(header: header, field1: field1, field2: field2, misc: misc, uuid: uuid ?? UUID())
        records.append(record)
    }
    
    class func addRecord(record: Record) {
        records.append(record)
    }

    class func deleteRecord(id: Int) {
        if records.count > 0  && id >= 0 {
            records.remove(at: id)
        }
    }
    
    class func getRecord(id: Int) -> Record {
        if records.count > 0 && id >= 0 {
            return records[id]
        }
        return Record()
    }
    
    class func updateRecord(oldRecord: Record, record: Record) {
        if records.count > 0, let i = records.firstIndex(of: oldRecord) {
            records[i] = record
        }
    }
    
    class func fetch() {
        // Reset records
        records.removeAll()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Records.rawValue)
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            for data in result as! [NSManagedObject] {
                let header = data.value(forKey: RecordsEntity.header.rawValue) as! String
                let field1 = data.value(forKey: RecordsEntity.field1.rawValue) as! String
                let field2 = data.value(forKey: RecordsEntity.field2.rawValue) as! String
                let misc = data.value(forKey: RecordsEntity.misc.rawValue) as! String
                let uuid = data.value(forKey: RecordsEntity.uuid.rawValue) as? UUID
                
                addRecord(header: header, field1: field1, field2: field2, misc: misc, uuid: uuid)
            }
            
//            displayCDRecords()
        } catch {
            print("Failed to read data from entity - ", Entity.Records.rawValue)
        }
    }
    
    class func save(header: String, field1: String, field2: String, misc: String) {
        let record = Record(header: header, field1: field1, field2: field2, misc: misc, uuid: UUID())
        
        let recordsEntity = NSEntityDescription.entity(forEntityName: Entity.Records.rawValue, in: managedContext)
        let newRecord = NSManagedObject(entity: recordsEntity!, insertInto: managedContext)
        newRecord.setValue(record.header, forKey: RecordsEntity.header.rawValue)
        newRecord.setValue(record.field1, forKey: RecordsEntity.field1.rawValue)
        newRecord.setValue(record.field2, forKey: RecordsEntity.field2.rawValue)
        newRecord.setValue(record.misc, forKey: RecordsEntity.misc.rawValue)
        newRecord.setValue(record.uuid, forKey: RecordsEntity.uuid.rawValue)
        
        do {
            try managedContext.save()
            addRecord(record: record)
            
//            displayCDRecords()
        } catch {
            print("Failed to save record for entity - ", Entity.Records.rawValue)
        }
    }
    
    class func update(oldRecord: Record, header: String, field1: String, field2: String, misc: String) {
        let record = Record(header: header, field1: field1, field2: field2, misc: misc, uuid: oldRecord.uuid!)
        
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: Entity.Records.rawValue)
        request.predicate = NSPredicate(format: "uuid == %@", record.uuid! as CVarArg)
        
        do {
            let test = try managedContext.fetch(request)
            let updatedRecord = test[0] as! NSManagedObject
            updatedRecord.setValue(record.header, forKey: RecordsEntity.header.rawValue)
            updatedRecord.setValue(record.field1, forKey: RecordsEntity.field1.rawValue)
            updatedRecord.setValue(record.field2, forKey: RecordsEntity.field2.rawValue)
            updatedRecord.setValue(record.misc, forKey: RecordsEntity.misc.rawValue)
            updatedRecord.setValue(record.uuid, forKey: RecordsEntity.uuid.rawValue)
            
            do {
                try managedContext.save()
                updateRecord(oldRecord: oldRecord, record: record)
                
//                displayCDRecords()
            } catch {
                print("Failed to update record while saving for entity - ", Entity.Records.rawValue)
            }
        } catch {
            print("Failed to update record while reading for entity - ", Entity.Records.rawValue)
        }
    }
    
    class func delete(forRecordAt: Int) {
        let record = getRecord(id: forRecordAt)
        
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: Entity.Records.rawValue)
        request.predicate = NSPredicate(format: "uuid == %@", record.uuid! as CVarArg)
        do {
            let test = try managedContext.fetch(request)
            let recordToDelete = test[0] as! NSManagedObject
            managedContext.delete(recordToDelete)
            deleteRecord(id: forRecordAt)
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
//                print("----- CURRENT RECORD ----- \n header:", header, "\n field1", field1, "\n field2", field2, "\n misc", misc, "\n uuid", uuid)
//          }
//
//        } catch {
//            print("Failed to display data from entity - ", Entity.Records.rawValue)
//        }
//    }
}
