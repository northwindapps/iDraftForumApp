//
//  CreateCommentController.swift
//  iDraft
//
//  Created by yujin on 2020/07/16.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

class CreateCommentController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,GADBannerViewDelegate {

    @IBOutlet weak var correctionConstraint: NSLayoutConstraint!

    @IBOutlet weak var commentConstraint: NSLayoutConstraint!
    
    var selectedTab = 0
    var postId = ""
    var questionJson = [String : Any]()
    var sentenceArry = [String]()
    var corrected = ""
    var originalArry = [String]()
    var imageFileName = "noimage.png"
    var audioFileName = "ABCD.mp3"
    
    var cview :commentView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var createCommentTable: UITableView!
    
    @IBOutlet weak var fileUploadButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentCreateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        let body = (questionJson["body"] as! String)
//        sentenceArry = body.components(separatedBy:".")
        sentenceArry = body.components(separatedBy: CharacterSet(charactersIn: ".。"))
        originalArry = sentenceArry
        createCommentTable.allowsSelection = false
        
        let label = UITapGestureRecognizer(target: self, action: #selector(self.tappedcell(_:)))
        createCommentTable.addGestureRecognizer(label)
        createCommentTable.delegate = self

        
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.cornerRadius = 8;
        commentTextView.layer.borderColor = UIColor.systemBlue.cgColor
        
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.cornerRadius = 8;
        commentTextView.layer.borderColor = UIColor.orange.cgColor
        
        commentCreateButton.layer.cornerRadius = 8
        commentCreateButton.layer.borderWidth = 1
        commentCreateButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        fileUploadButton.layer.cornerRadius = 8
        fileUploadButton.layer.borderWidth = 1
        fileUploadButton.layer.borderColor = UIColor.systemGreen.cgColor
        
//                ca-app-pub-5284441033171047/3584031026
        bannerView.adUnitID = "ca-app-pub-5284441033171047/3584031026"
        //        ca-app-pub-5284441033171047/3584031026
        //        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //        "ca-app-pub-3940256099942544/2934735716" test
        bannerView.rootViewController = self
       
        // Do any additional setup after loading the view.

    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
         bannerView.isHidden = false
        
     }
     
     func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
         bannerView.isHidden = true
     }
    
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                // Tracking authorization completed. Start loading ads here.
                // loadAd()
                self.bannerView.load(GADRequest())
            })
        } else {
            // Fallback on earlier versions
            bannerView.load(GADRequest())
        }
    }
     
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Move on to upload controller to attach files
    @IBAction func fileUploadCommentAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vcP = storyBoard.instantiateViewController(withIdentifier: "fileUploadComment") as! FileUploadCommentViewController
        vcP.questionJson = questionJson
        vcP.imageFileName = imageFileName
        vcP.audioFileName = audioFileName
        vcP.selectedTab = selectedTab
        vcP.postId = postId
        vcP.sentenceArry = sentenceArry
        vcP.corrected = corrected
        vcP.originalArry = originalArry
        
        
        vcP.modalPresentationStyle = .fullScreen
        self.present(vcP, animated:false, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sentenceArry.last == ""{
            sentenceArry.remove(at: sentenceArry.count-1)
        }
        
        
        return sentenceArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CreateCommentTableViewCell = createCommentTable.dequeueReusableCell(withIdentifier: "CreateCommentCell", for: indexPath) as! CreateCommentTableViewCell
        
        cell.createCommentTextView.text = sentenceArry[indexPath.row]
        cell.createCommentTextView.tag = indexPath.row
     
        cell.indexLabel.textColor = UIColor.black
        cell.indexLabel.text = String(indexPath.row+1) + "/" + String(sentenceArry.count)
       
        
        cell.createCommentTextView.delegate = self
        
        cell.createCommentTextView.layer.cornerRadius = 8
        cell.createCommentTextView.layer.borderWidth = 1
        cell.createCommentTextView.layer.borderColor = UIColor.systemBlue.cgColor
        cell.createCommentTextView.adjustUITextViewHeight()
        
        
        
        return cell
    }
    

    //Returning to show page without change
    @IBAction func returnAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vcP = storyBoard.instantiateViewController(withIdentifier: "postshow") as! PostShowController
        vcP.selectedTab = selectedTab
        vcP.postId = postId
        vcP.questionJson = questionJson
        vcP.modalPresentationStyle = .fullScreen
        self.present(vcP, animated:false, completion:nil)
    }
    
    @IBAction func sendCommentAction(_ sender: Any) {

        // Sending a correction json on server
        //TODO audio img filepath
        if (UserDefaults.standard.object(forKey: "newtoken") != nil) {
            let token = UserDefaults.standard.object(forKey: "newtoken") as! String
            let idNum = (questionJson["id"] as! Int)
            
            for i in 0 ..< sentenceArry.count {
                sentenceArry[i] = sentenceArry[i].replacingOccurrences(of: ".", with: "")
            }
            
         
            commentCreateButton.isEnabled = false
            
            var correctionCheck = false
            var bodytext = commentTextView.text
            for i in 0..<sentenceArry.count {
                if sentenceArry[i].contains(originalArry[i]){
                    
                }else{
                    correctionCheck = true
                }
            }
            
            
            if bodytext?.count == 0{
                bodytext = "Corrected"
            }
            
            if correctionCheck{
                
                commentStore(token: token, id: "\(idNum)",body:bodytext!, correction:sentenceArry.joined(separator:"."),audio: audioFileName,img: imageFileName)
            }else{
              
                commentStore(token: token, id: "\(idNum)",body:bodytext!, correction:"nil", audio: audioFileName,img: imageFileName)
            }
            
       
            
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vcP = storyBoard.instantiateViewController(withIdentifier: "register") as! RegisterController
            vcP.modalPresentationStyle = .fullScreen
            self.present(vcP, animated:false, completion:nil)
        }
    }
    
    func returnPostShow() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vcP = storyBoard.instantiateViewController(withIdentifier: "postshow") as! PostShowController
        vcP.selectedTab = selectedTab
        vcP.postId = postId
        vcP.questionJson = questionJson
        vcP.modalPresentationStyle = .fullScreen
        self.present(vcP, animated:false, completion:nil)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            sentenceArry[textView.tag] = textView.text
            createCommentTable.reloadData()
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //  your code here
        if textView.tag > -1{
            startCorrectionWithId(id:textView.tag)
        }
    }

    

    
//
//    func opencview(){
//        //don't forget first call
//        if cview != nil{
//            cview.removeFromSuperview()
//        }
//
//
//
//        cview = commentView(frame: CGRect(x:10,y:30, width: 270,height: 180))
//
//        cview.commentOkButton.addTarget(self, action: #selector(finishComment), for: UIControl.Event.touchUpInside)
//
//
//        cview.commentTextView.delegate = self
//        cview.commentTextView.layer.borderWidth = 1
//        cview.commentTextView.layer.borderColor = UIColor.darkGray.cgColor
//        cview.commentTextView.tag = -1
//        cview.layer.borderWidth = 1
//        cview.layer.cornerRadius = 8;
//
//        cview.commentTextView.becomeFirstResponder()
//
//        let locationstr = (NSLocale.preferredLanguages[0] as String?)!
//        if locationstr.contains("ja"){
//            cview.commentOkButton.setTitle("完了", for: .normal)
//        }else if locationstr.contains("fr"){
//            cview.commentOkButton.setTitle("supprimer", for: .normal)
//        }else if locationstr.contains("zh"){
//            cview.commentOkButton.setTitle("删除", for: .normal)
//        }else if locationstr.contains("de"){
//            cview.commentOkButton.setTitle("OK", for: .normal)
//        }else if locationstr.contains("it"){
//            cview.commentOkButton.setTitle("Cancellare", for: .normal)
//        }else if locationstr.contains("ru"){
//            cview.commentOkButton.setTitle("удалить", for: .normal)
//        }else if locationstr.contains("es"){
//            cview.commentOkButton.setTitle("borrar", for: .normal)
//        }else if locationstr == "sv"{
//            cview.commentOkButton.setTitle("radera", for: .normal)
//        }else{
//           cview.commentOkButton.setTitle("OK", for: .normal)
//        }
//        self.view.addSubview(cview)
//
//
//        //http://studyswift.blogspot.jp/2015/01/showhide-keyboard-while-using.html
//        //https://stackoverflow.com/questions/46375700/programmatically-create-touchupinside-event-for-uitextfield
//
//    }
    
    @objc func startCorrectionWithId(id:Int){
     
        //don't forget first call
        if cview != nil{
            cview.removeFromSuperview()
        }
        

              
        cview = commentView(frame: CGRect(x:10,y:180, width: 270,height: 180))
        cview.commentOkButton.addTarget(self, action: #selector(closeCommentView), for: UIControl.Event.touchUpInside)
        cview.commentTextView.delegate = self
        cview.commentTextView.layer.borderWidth = 1
        cview.commentTextView.layer.borderColor = UIColor.darkGray.cgColor
        cview.commentTextView.text = sentenceArry[id]
        cview.commentTextView.textColor = UIColor.darkGray
        cview.commentTextView.isSelectable = false
        
        cview.layer.borderWidth = 1
        cview.layer.cornerRadius = 8;
        cview.layer.borderColor = UIColor.gray.cgColor
     
        
        self.view.addSubview(cview)
        
        
        //http://studyswift.blogspot.jp/2015/01/showhide-keyboard-while-using.html
        //https://stackoverflow.com/questions/46375700/programmatically-create-touchupinside-event-for-uitextfield

    }
    
    @objc func startCorrection(button:UIButton){
        print("button tag",button.tag)
        

    }
  
    
    @objc func closeCommentView(){
        print("close")
        cview.resignFirstResponder()
        cview.removeFromSuperview()
    }
    
    @objc func finishComment(){
        cview.resignFirstResponder()
        cview.removeFromSuperview()
        cview.commentTextView.resignFirstResponder()
    }
    
    @IBAction func addCommentAction(_ sender: Any) {
//         if correctionConstraint.multiplier < 0.1 {
//                   let new = correctionConstraint.constraintWithMultiplier(0.5)
//                   self.view.removeConstraint(correctionConstraint)
//                   self.view.addConstraint(new)
//                   self.view.layoutIfNeeded()
//                   correctionConstraint = new
//            
//                let new2 = commentConstraint.constraintWithMultiplier(0.001)
//                self.view.removeConstraint(commentConstraint)
//                self.view.addConstraint(new2)
//                self.view.layoutIfNeeded()
//                commentConstraint = new2
//            
//                    
//               }else{
//                   let new = correctionConstraint.constraintWithMultiplier(0.001)
//                   self.view.removeConstraint(correctionConstraint)
//                   self.view.addConstraint(new)
//                   self.view.layoutIfNeeded()
//                   correctionConstraint = new
//            
//                    let new2 = commentConstraint.constraintWithMultiplier(0.3)
//                    self.view.removeConstraint(commentConstraint)
//                    self.view.addConstraint(new2)
//                    self.view.layoutIfNeeded()
//                    commentConstraint = new2
//               }
    }
    
    
    @objc func tappedcell(_ sender : UITapGestureRecognizer ){
        print("tapped")
        //Common part
            let tableview = sender.view as! UITableView
            let p = sender.location(in: sender.view)
            let indexPath = tableview .indexPathForRow(at: p)
        
        if indexPath != nil {
            
            tableview .deselectRow(at: indexPath!, animated: false)
            
            let cell = tableview.cellForRow(at: indexPath!) as! CreateCommentTableViewCell
            let pointInCell = sender.location(in: cell) as CGPoint
            
            if (cell.indexLabel.frame.contains(pointInCell))
            {
           
                    startCorrectionWithId(id:indexPath!.row)
            
            }
        }
        
    }
    
    
    //add http request comment
    func commentStore(token:String,id:String,body:String, correction:String,audio:String,img:String) {
            let bc = BaseController()
        let Url = "https://" + bc.HOST_IP + "/api/auth/comment/" + id
        let parameterDictionary = ["body":body, "correction" : correction,"audiofile":audio,"imgfile":img]
            print(parameterDictionary)
            let serviceUrl = URL(string: Url)
            var request = URLRequest(url: serviceUrl!)
            request.setValue("Bearer " + token, forHTTPHeaderField:  "Authorization" )
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
            let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[])
            request.httpBody = httpBody
                request.httpMethod = "POST"
                
           
            bc.session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
                     if let data = data {
                         do {
                           let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                           print(json)
                            DispatchQueue.main.async(execute: {
                                self.returnPostShow()
                                self.commentCreateButton.isEnabled = true
                            })
                           

                         } catch {
                           print(error)
                            DispatchQueue.main.async(execute: {
                                self.commentCreateButton.isEnabled = true
                            })
    
                         }
                     }
                     }).resume()
       }
    
}

