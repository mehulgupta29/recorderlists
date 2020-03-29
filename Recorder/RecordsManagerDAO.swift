//
//  RecordsManagerDAO.swift
//  Recorder
//
//  Created by Mehul Gupta on 3/25/20.
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
    case tagBgColorRed = "tagBgColorRed"
    case tagBgColorGreen = "tagBgColorGreen"
    case tagBgColorBlue = "tagBgColorBlue"
    case tagBgColorAlpha = "tagBgColorAlpha"
}

class RecordsManagerDAO: NSObject {
    
    static var managedContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    // MARK: - Create
    class func Save(record: Record, at: Int = 0) -> Void {
        let recordsEntity = NSEntityDescription.entity(forEntityName: Entity.Records.rawValue, in: managedContext)
        _ = setValueHelper(NSManagedObject(entity: recordsEntity!, insertInto: managedContext), record: record)
        
        do {
            try managedContext.save()
            RecordsManager.insert(record: record, at: at)
        } catch {
            print("Failed to save record for entity - ", Entity.Records.rawValue)
        }
    }
    
    // MARK: - Read
    class func Fetch() {
        // Reset records
        RecordsManager.removeAll()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Records.rawValue)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext.fetch(request)
            for data in result as! [NSManagedObject] {
                RecordsManager.append(record: getValueHelper(data))
            }
        } catch {
            print("Failed to read data from entity - ", Entity.Records.rawValue)
        }
    }
    
    class func Fetch(forTag: String) {
        // Reset Records array
        RecordsManager.removeAll()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Records.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: RecordsEntity.header.rawValue, ascending: true)]
        request.predicate = NSPredicate(format: "\(RecordsEntity.tag.rawValue) == %@", forTag as CVarArg)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext.fetch(request)
            for data in result as! [NSManagedObject] {
                RecordsManager.append(record: getValueHelper(data))
            }
        } catch {
            print("Failed to retrive records for given tag -", forTag)
        }
    }
    
    // MARK: - Update
    class func Update(record old: Record, new: [String: Any]) {
        let newRecord = Record(
            header: (new["header"] ?? old.header!) as! String,
            field1: (new["field1"] ?? old.field1!) as! String,
            field2: (new["field2"] ?? old.field2!) as! String,
            tag: (new["tag"] ?? old.tag!) as! String,
            tagBgColor: old.tagBgColor!,
            misc: (new["misc"] ?? old.misc!) as! String,
            uuid: old.uuid!
        )
            
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: Entity.Records.rawValue)
        request.predicate = NSPredicate(format: "uuid == %@", old.uuid! as CVarArg)
            
        do {
            let test = try managedContext.fetch(request)
            _ = setValueHelper(test[0] as! NSManagedObject, record: newRecord)
            try managedContext.save()
            RecordsManager.update(record: old, new: newRecord)
        } catch {
            print("Failed to update record while reading for entity - ", Entity.Records.rawValue)
        }
    }
    
    // MARK: - Delete
    class func Delete(forRecordAt index: Int) {
        let record = RecordsManager.get(recordAt: index)
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: Entity.Records.rawValue)
        request.predicate = NSPredicate(format: "uuid == %@", record.uuid! as CVarArg)
        
        do {
            let test = try managedContext.fetch(request)
            let recordToDelete = test[0] as! NSManagedObject
            managedContext.delete(recordToDelete)
            
            // Save for the changes to persist
            try managedContext.save()
            
            // Update local Records array
            RecordsManager.delete(recordAt: index)
        } catch {
            print("Failed to delete record while reading for entity - ", Entity.Records.rawValue)
        }
    }
    
    class func Delete(forRecordWith uuid: UUID) {
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: Entity.Records.rawValue)
        request.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)
        
        do {
            let test = try managedContext.fetch(request)
            let recordToDelete = test[0] as! NSManagedObject
            managedContext.delete(recordToDelete)
            
            // Save for the changes to persist
            try managedContext.save()
            
            // Update local Records array
            RecordsManager.delete(recordWith: uuid)
        } catch {
            print("Failed to delete record while reading for entity - ", Entity.Records.rawValue)
        }
    }
    class func DeleteAll() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Records.rawValue)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            RecordsManager.removeAll()
        } catch {
            print ("There was an error")
        }
    }
    
    
    // MARK: - Helper
    class private func getValueHelper(_ data: NSManagedObject) -> Record{
        let header = data.value(forKey: RecordsEntity.header.rawValue) as! String
        let field1 = data.value(forKey: RecordsEntity.field1.rawValue) as! String
        let field2 = data.value(forKey: RecordsEntity.field2.rawValue) as! String
        let tag = data.value(forKey: RecordsEntity.tag.rawValue) as! String
        let misc = data.value(forKey: RecordsEntity.misc.rawValue) as! String
        let uuid = data.value(forKey: RecordsEntity.uuid.rawValue) as! UUID
        
        let tagBgColorRed = data.value(forKey: RecordsEntity.tagBgColorRed.rawValue) as! Double
        let tagBgColorGreen = data.value(forKey: RecordsEntity.tagBgColorGreen.rawValue) as! Double
        let tagBgColorBlue = data.value(forKey: RecordsEntity.tagBgColorBlue.rawValue) as! Double
        let tagBgColorAlpha = data.value(forKey: RecordsEntity.tagBgColorAlpha.rawValue) as! Double
        let tagBgColor = UIColor(red: CGFloat(tagBgColorRed), green: CGFloat(tagBgColorGreen), blue: CGFloat(tagBgColorBlue), alpha: CGFloat(tagBgColorAlpha))
        
        return Record(header: header, field1: field1, field2: field2, tag: tag, tagBgColor: tagBgColor, misc: misc, uuid: uuid)
    }
    
    class private func setValueHelper(_ object: NSManagedObject, record: Record) -> NSManagedObject {
        object.setValue(record.header!, forKey: RecordsEntity.header.rawValue)
        object.setValue(record.field1!, forKey: RecordsEntity.field1.rawValue)
        object.setValue(record.field2!, forKey: RecordsEntity.field2.rawValue)
        object.setValue(record.tag!, forKey: RecordsEntity.tag.rawValue)
        object.setValue(record.misc!, forKey: RecordsEntity.misc.rawValue)
        object.setValue(record.uuid!, forKey: RecordsEntity.uuid.rawValue)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        record.tagBgColor!.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        object.setValue(red, forKey: RecordsEntity.tagBgColorRed.rawValue)
        object.setValue(green, forKey: RecordsEntity.tagBgColorGreen.rawValue)
        object.setValue(blue, forKey: RecordsEntity.tagBgColorBlue.rawValue)
        object.setValue(alpha, forKey: RecordsEntity.tagBgColorAlpha.rawValue)
        
        return object
    }
    
}
