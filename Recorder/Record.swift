//
//  Record.swift
//  Recorder
//
//  Created by Mehul Gupta on 3/21/20.
//  Copyright © 2020 Mehul Gupta. All rights reserved.
//

import UIKit

class Record: NSObject {
    var header: String?
    var field1: String?
    var field2: String?
    var misc: String?
    var uuid: UUID?
    
    init(header: String, field1: String, field2: String, misc: String = "", uuid: UUID = UUID()) {
        self.header = header
        self.field1 = field1
        self.field2 = field2
        self.misc = misc
        self.uuid = uuid
    }
    
    override init() {
        super.init();
    }
}
