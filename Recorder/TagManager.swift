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
    static var Tags = [String]()
    
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
            var distinctTags = [String]()
            for data in result {
                distinctTags.append(((data as AnyObject).value(forKey: RecordsEntity.tag.rawValue) as? String ?? DEFAULT_TAG).uppercased())
            }
            Tags.append(contentsOf: distinctTags)
        } catch {
            print("Failed to read data from entity - ", Entity.Records.rawValue)
        }
    }
    
}
