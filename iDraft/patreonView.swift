//
//  DetailImageView.swift
//  iDraft
//
//  Created by yujin on 2020/07/18.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit

class PatreonView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var view:UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    
    override init(frame: CGRect)
     {
         super.init(frame: frame)
         setup()
     }
     
    required init(coder aDecoder:NSCoder)
    {
         super.init(coder:aDecoder)!
         setup()
     }
     
     func setup()
     {
         view = loadviewfromNib()
         view.frame = bounds
         //http://stackoverflow.com/questions/30867325/binary-operator-cannot-be-applied-to-two-uiviewautoresizing-operands
         view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
         addSubview(view)
         
     }
    
     
     //http://stackoverflow.com/questions/34658838/instantiate-view-from-nib-throws-error
     func loadviewfromNib() ->UIView
     {
             let bundle = Bundle(for: type(of: self))
             let nib = UINib(nibName: "patreonViewBoard",bundle: bundle)
             let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
             return view
     }
     

}

