//
//  commentView.swift
//  iDraft
//
//  Created by yujin on 2020/07/18.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit

class commentView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var lastLocation = CGPoint(x: 0, y: 0)
    var view:UIView!

    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var commentOkButton: UIButton!
    
    @IBOutlet weak var commentEndButton: UIButton!
    
     override init(frame: CGRect)
     {
         super.init(frame: frame)
        
         let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(detectPan))
         self.gestureRecognizers = [panRecognizer]
        
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
    
     @objc func detectPan(_ recognizer:UIPanGestureRecognizer) {
            let translation  = recognizer.translation(in: self.superview)
            self.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
     }
        
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // Promote the touched view
            self.superview?.bringSubviewToFront(self)
            
            // Remember original location
            lastLocation = self.center
     }
     
     //http://stackoverflow.com/questions/34658838/instantiate-view-from-nib-throws-error
     func loadviewfromNib() ->UIView
     {
             let bundle = Bundle(for: type(of: self))
             let nib = UINib(nibName: "comment",bundle: bundle)
             let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
             return view
     }
     

}
