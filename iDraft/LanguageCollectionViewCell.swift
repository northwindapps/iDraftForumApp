//
//  LanguageCollectionViewCell.swift
//  iDraft
//
//  Created by yujin on 2020/07/21.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit

class LanguageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var langLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        
        
        //self.layer.cornerRadius = 5.0
    }
}
