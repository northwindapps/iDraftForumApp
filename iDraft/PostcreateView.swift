//
//  DetailImageView.swift
//  iDraft
//
//  Created by yujin on 2020/07/18.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit

class PostcreateView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var view:UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var createPostButton: UIButton!
    @IBOutlet weak var postCreatePicker: UIPickerView!
    @IBOutlet weak var postCreateTitle: UITextField!
    @IBOutlet weak var postCreateContent: UITextView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var patereonLink: UILabel!
    @IBOutlet weak var paypalLabel: UILabel!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var writerField: UITextField!
    @IBOutlet weak var patreonField: UITextField!
    @IBOutlet weak var paypalField: UITextField!
    
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
             let nib = UINib(nibName: "postcreateViewBoard",bundle: bundle)
             let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
             return view
     }
     

}
