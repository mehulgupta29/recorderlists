//
//  RecordCollectionViewCell.swift
//  Recorder
//
//  Created by Mehul Gupta on 3/21/20.
//  Copyright © 2020 Mehul Gupta. All rights reserved.
//

import UIKit

class RecordCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var field1Label: UILabel!
    @IBOutlet weak var field2Label: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    var isFromTagsScreen: Bool = false
    var record: Record? {
        didSet {
            self.setupCell()
        }
    }
    
    let Colors = [
        UIColor(red: 0.26997111790701567, green: 0.29340057011895126, blue: 0.3904781954634089, alpha: 1.0),
        UIColor(red:  0.7535532756400158,  green:  0.53162825175081,  blue:  0.6036160987815684,  alpha: 1.0),
        UIColor(red: 0.2656122349713712 , green: 0.30678513061418045 , blue: 0.9827522631010304 ,alpha: 1.0),
        
        UIColor(red: 0.6628306597899964 , green: 0.002755081426883521 , blue: 0.8464757799300067 ,alpha: 1.0),
        UIColor(red: 0.2656122349713712 , green: 0.30678513061418045 , blue: 0.9827522631010304 ,alpha: 1.0),
        UIColor(red: 0.8858951305876062 , green: 0.15185986406856955 , blue: 0.30465710174579286 ,alpha: 1.0),
        UIColor(red: 0.7535532756400158 , green: 0.53162825175081 , blue: 0.6036160987815684 ,alpha: 1.0),
        UIColor(red: 0.946370485960081 , green: 0.9438903393544678 , blue: 0.3680398674328167 ,alpha: 1.0),
        UIColor(red: 0.024299155634651015 , green: 0.20496350975160027 , blue: 0.5919545024378117 ,alpha: 1.0),
        UIColor(red: 0.3028291841613324 , green: 0.49819805913440973 , blue: 0.8914952196721551 ,alpha: 1.0),
        UIColor(red: 0.3487494242061331 , green: 0.34925594318672637 , blue: 0.4667197438105255 ,alpha: 1.0),
        UIColor(red: 0.20574398662594717 , green: 0.25985808398917953 , blue: 0.2737909811984416 ,alpha: 1.0),
        UIColor(red: 0.1900442009760006 , green: 0.13056690375966085 , blue: 0.5928930072603364 ,alpha: 1.0),
        UIColor(red: 0.7032910254508415 , green: 0.31465760351781213 , blue: 0.4313711602518282 ,alpha: 1.0),
        UIColor(red: 0.4551141680005557 , green: 0.5818849290761818 , blue: 0.3994081735045576 ,alpha: 1.0),
        
        UIColor(red: 0.38371587480719427 , green: 0.05885891359273643 , blue: 0.6910043733821958 ,alpha: 1.0),
        UIColor(red: 0.742377406033981 , green: 0.07553807853778238 , blue: 0.298525606318119 ,alpha: 1.0),
        UIColor(red: 0.6628306597899964 , green: 0.002755081426883521 , blue: 0.8464757799300067 ,alpha: 1.0),
        UIColor(red: 0.2656122349713712 , green: 0.30678513061418045 , blue: 0.9827522631010304 ,alpha: 1.0),
        UIColor(red: 0.024299155634651015 , green: 0.20496350975160027 , blue: 0.5919545024378117 ,alpha: 1.0),
        UIColor(red: 0.3028291841613324 , green: 0.49819805913440973 , blue: 0.8914952196721551 ,alpha: 1.0),
    ]

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    // MARK: Setup Cell
    fileprivate func setupCell() {
        self.roundCorner()
        self.headerLabel?.text = self.record?.header
        self.field1Label?.text = self.record?.field1
        self.field2Label?.text = self.record?.field2
        
        if !isFromTagsScreen {
            self.tagLabel?.text = self.record?.tag
        }
        
//         self.contentView.backgroundColor = self.randomColor()
        self.contentView.backgroundColor = Colors[0]

    }
    
    // MARK: Methods
    func roundCorner() {
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
    }
    
    // custom function to generate a random UIColor
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let blue = CGFloat(drand48())
        let green = CGFloat(drand48())
        
        if ((self.record?.header) != nil) {
            print("Cell -", self.record?.header as Any, "UIColor(red:", red, ", green:", green, ", blue:", blue, ",alpha: 1.0),")
        }
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
