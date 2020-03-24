//
//  TagRecordCollectionViewCell.swift
//  Recorder
//
//  Created by Mehul Gupta on 3/24/20.
//  Copyright © 2020 Mehul Gupta. All rights reserved.
//

import UIKit

class TagRecordCollectionViewCell: UICollectionViewCell {

        @IBOutlet weak var headerLabel: UILabel!
        @IBOutlet weak var field1Label: UILabel!
        @IBOutlet weak var field2Label: UILabel!
        
        var record: Record? {
            didSet {
                self.setupCell()
            }
        }
        
        let Colors = [
            UIColor(red: 0.26997111790701567, green: 0.29340057011895126, blue: 0.3904781954634089, alpha: 1.0)
        ]

        
        override func awakeFromNib() {
            super.awakeFromNib()
            self.setupCell()
        }
        
        // MARK: Setup Cell
        fileprivate func setupCell() {
            self.roundCorner()
    //        self.contentView.backgroundColor = self.randomColor()
            self.contentView.backgroundColor = Colors[0]
            self.headerLabel?.text = self.record?.header
            self.field1Label?.text = self.record?.field1
            self.field2Label?.text = self.record?.field2
        }
        
        // MARK: Methods
        func roundCorner() {
            self.contentView.layer.cornerRadius = 5.0
            self.contentView.layer.masksToBounds = true
            self.contentView.layer.borderWidth = 1.0
            self.contentView.layer.borderColor = UIColor.clear.cgColor
        }
        // custom function to generate a random UIColor
    //    func randomColor() -> UIColor{
    //        let red = CGFloat(drand48())
    //        let blue = CGFloat(drand48())
    //        let green = CGFloat(drand48())
    //        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    //    }
}
