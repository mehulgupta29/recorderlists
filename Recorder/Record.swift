//
//  Record.swift
//  Recorder
//
//  Created by Mehul Gupta on 3/21/20.
//  Copyright © 2020 Mehul Gupta. All rights reserved.
//

import UIKit

let DEFAULT_TAG = "DEFAULT"
let DEFAULT_TAG_BG_COLOR = UIColor(red: 0.26997111790701567, green: 0.29340057011895126, blue: 0.3904781954634089, alpha: 1.0)

class Record: NSObject {
    var header: String?
    var field1: String?
    var field2: String?
    var misc: String?
    var uuid: UUID?
    
    var tagBgColor: UIColor?
    
    var tag: String? {
        didSet {
            tag = tag?.uppercased()
        }
    }
    
    init(header: String, field1: String, field2: String, tag: String, tagBgColor: UIColor? = DEFAULT_TAG_BG_COLOR, misc: String = "", uuid: UUID? = UUID()) {
        self.header = header
        self.field1 = field1
        self.field2 = field2
        self.misc = misc
        self.uuid = uuid ?? UUID()
        self.tag = tag.count == 0 ? DEFAULT_TAG : tag.uppercased()
        self.tagBgColor = tagBgColor == nil ? DEFAULT_TAG_BG_COLOR : tagBgColor
    }
    
    override init() {
        super.init();
    }
}
