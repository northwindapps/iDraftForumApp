//
//  PostShowController.swift
//  iDraft
//
//  Created by yujin on 2020/07/14.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit
import MessageUI
import AVFoundation
import SwiftyDropbox

var SCREENSIZE_w = ScreenSize.SCREEN_WIDTH
var SCREENSIZE = ScreenSize.SCREEN_HEIGHT
class PostShowController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate{
    
    var selectedTab = 0
    var postId = ""
    var questionJson = [String:Any]()
    var commentArry = NSArray()
    var imageFileURL = "none"
    var audioFileURL = "none"
    var AVAPlayer: AVAudioPlayer?
    var KEYBOARDLOCATION = CGFloat()
    var mview: modalView!
    var rView : ReplyView!
    var textEditView: TextEditView!
    var detailView:DetailImageView!
    var patreonView:PatreonView!
    var threeView:ThreedotView!
    var firstUse = true
    let errorLabel: UILabel = UILabel()
    let successLabel: UILabel = UILabel()
    var tableCellHeightArry = [CGFloat]()
    var threeViewRowIndex = Int()
    var clientsideUserid = String()
    var bookmarkedposts = [String]()
    var bookmarkedcomments = [String]()
    var isViewLoading = true
    var isReplyClicked = false
    var currentRowIndex = -1
    //https://stackoverflow.com/questions/46413060/why-am-i-unable-to-install-a-constraint-on-my-view

    

    @IBOutlet weak var postshowcommentTable: UITableView!
    @IBOutlet weak var postshowClose: UIButton!
    @IBOutlet weak var postshowBan: UIButton!
    @IBOutlet weak var postshowReturn: UIButton!
    @IBOutlet weak var loadingGear: UIActivityIndicatorView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingGear.isHidden = false
        loadingGear.layer.zPosition = 30
        postshowcommentTable.delegate = self
        postshowcommentTable.allowsSelection = false
//        audioFileURL = questionJson["cover_audio"] as! String
//        imageFileURL = questionJson["cover_image"] as! String
        
//        var checkURL = ""
//        if let test = questionJson["s3_img_url"] {
//            checkURL = questionJson["s3_img_url"] as! String
//        }

        
        commentShow(token: "notoken", id: postId)
        print("questionJson", questionJson)
      
//            imageView.load(url: URL(string: imageFileURL)!) first row
        
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        if (UserDefaults.standard.object(forKey: "newuserId") != nil ) {
            clientsideUserid = UserDefaults.standard.object(forKey: "newuserId") as! String
        }
        
        if (UserDefaults.standard.object(forKey: "bookmarkedposts") != nil ) {
            //it's _id
            bookmarkedposts = UserDefaults.standard.object(forKey: "bookmarkedposts") as! [String]
        }
        
        if (UserDefaults.standard.object(forKey: "bookmarkedcomments") != nil ) {
            //it's _id
            bookmarkedcomments = UserDefaults.standard.object(forKey: "bookmarkedcomments") as! [String]
        }
        
        threeViewRowIndex = -1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //3.0 seconds after previous one. this will do in normal root
//        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.checkedNewComments), userInfo: nil, repeats: false)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func returnAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vcP = storyBoard.instantiateViewController(withIdentifier: "question") as! PostIndexController
        vcP.activeTab = 2
        vcP.modalPresentationStyle = .fullScreen
        self.present(vcP, animated:false, completion:nil)
    }
    

    
    func commentShow(token:String,id:String) {
        let bc = BaseController()
        let Url = "https://" + bc.HOST_IP + "/comments/searches?id=" + id
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.httpMethod = "GET"
     
        bc.session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
            if let data = data {
                do {
                    let Ary = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray
                    
                    
                    DispatchQueue.main.async(execute: {
                        if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode == 400{
                                self.loadingGear.isHidden = true
                                return
                            }
                            if httpResponse.statusCode == 404{
                                self.loadingGear.isHidden = true
                                return
                            }
                        }
                        self.commentArry = Ary!
//                        print("commentArry",self.commentArry)
                        self.postshowcommentTable.reloadData()
                        self.loadingGear.isHidden = true
                        
                        if self.isViewLoading{
                            self.isViewLoading = false
                            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.checkedNewComments), userInfo: nil, repeats: false)
                        }
                    })
               
                } catch {
                    print(error)
                    
                }
            }
        }).resume()
    }
    
    //new comment notify
    func gotNewComment(postId:String) {
        let bc = BaseController()
        let Url = "https://" + bc.HOST_IP + "/posts/notify/" + postId
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.httpMethod = "GET"
     
        bc.session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            if let data = data {
                do {
                    DispatchQueue.main.async(execute: {
                        if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode == 400{
                                self.loadingGear.isHidden = true
                                return
                            }
                            if httpResponse.statusCode == 404{
                                self.loadingGear.isHidden = true
                                return
                            }
                            if httpResponse.statusCode == 200{
                                self.loadingGear.isHidden = true
                                print("notification flag turned on")
                                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.commentUploaded), userInfo: nil, repeats: false)
                                return
                            }
                        }
                    })
                }
            }
        }).resume()
    }
    func checkedNewComment(postId:String) {
        let bc = BaseController()
        let Url = "https://" + bc.HOST_IP + "/posts/notify/off/" + postId
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.httpMethod = "GET"
     
        bc.session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            if let data = data {
                do {
                    DispatchQueue.main.async(execute: {
                        if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode == 400{
                                self.loadingGear.isHidden = true
                                return
                            }
                            if httpResponse.statusCode == 404{
                                self.loadingGear.isHidden = true
                                return
                            }
                            if httpResponse.statusCode == 200{
                                self.loadingGear.isHidden = true
                                print("author checked new comments")
                                return
                            }
                        }
                    })
                }
            }
        }).resume()
    }
    
    func bookMarkPost(token:String,id:String) {
        let bc = BaseController()
        let Url = "https://" + bc.HOST_IP + "/api/auth/favorite/store/" + id
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Bearer " + token, forHTTPHeaderField:  "Authorization" )
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.httpMethod = "POST"
        
   
        bc.session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    DispatchQueue.main.async(execute: {
                        print(json)
                        
                    })
                 
                } catch {
                    print(error)
                    
                }
            }
        }).resume()
    }
    
    func reportPost(token:String,id:String) {
        let bc = BaseController()
        let Url = "https://" + bc.HOST_IP + "/api/auth/report/store/" + id
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Bearer " + token, forHTTPHeaderField:  "Authorization" )
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.httpMethod = "POST"
         
        bc.session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
    
                    DispatchQueue.main.async(execute: {
                        print(json)
                        
                    })
                    
                } catch {
                    print(error)
                }
            }
        }).resume()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var commentBody = ""
        if indexPath.section == 0{
            let title = (questionJson["title"] as! String)
            let body = (questionJson["body"] as! String)
            commentBody = title + body + "pseudospacertext"
        }
        if indexPath.section == 1{
            let json = commentArry[indexPath.row] as! [String:Any]
            commentBody = (json["body"] as! String)
        }
        
//        print("body",commentBody.count)
        var lineCount = Double(commentBody.count / 25)//a line char count
        lineCount += 1.0
        
        var height:CGFloat = CGFloat()
        height = CGFloat(((lineCount * 30) / 0.75) + 100)
        if height < 180{
            height = 180.0
        }
//        if indexPath.section == 0{
//            height = 300.0
//        }
//        print(height)
        tableCellHeightArry.append(height)
        return height
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return commentArry.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  //TODO TextOnly or withImage
        let cell : CommentTableViewCell = postshowcommentTable.dequeueReusableCell(withIdentifier: "commentCellTextOnly", for: indexPath) as! CommentTableViewCell
        
        //        let test = "https://idraft.s3.amazonaws.com/public/cover_images/958072_1594808012.png"
        //        cell.avaterImg.load(url: URL.init(string: test)!)
        
        if indexPath.section > 0{
        //meaning comment contents with no title
        let json = commentArry[indexPath.row] as! [String:Any]
        let commenter = (json["commentatorName"] as! String)
        let body = (json["body"] as! String)
        let date = (json["createdAt"] as! String)
        cell.answerer.setTitle((String(date.prefix(10)) + " " + commenter), for: .normal)
            cell.answerer.tag =  indexPath.row
            cell.buycolaButton.tag = indexPath.row
        cell.buycolaButton.addTarget(self, action: #selector(openpateonView), for: UIControl.Event.touchUpInside)
            cell.thumbupButton.tag = indexPath.row
        cell.thumbupButton.addTarget(self, action: #selector(commentThumbUpAction), for: UIControl.Event.touchUpInside)
        cell.commentBodyTextView.text = body
        cell.replyButton.tag = indexPath.row
            currentRowIndex = indexPath.row
        cell.replyButton.addTarget(self, action: #selector(openreplyView), for: UIControl.Event.touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.cellBgView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(
          target: self,
          action: #selector(handleTapCommentator)
        )
        tapGesture.delegate = self
//        next update TODO
//        cell.commentImageView.isUserInteractionEnabled = true
//        cell.commentImageView.tag = indexPath.row
    
        cell.editButton.addGestureRecognizer(tapGesture)
        
        
 
        cell.commentBodyTextView.isHidden = false
//        cell.commentImageView.isHidden = false


        cell.cellBgView.clipsToBounds = false
        let sb = UIColor.orange
        cell.cellBgView.layer.borderColor = sb.cgColor
        cell.cellBgView.layer.borderWidth = 2.0
        cell.cellBgView.layer.cornerRadius = 10.0
        cell.replyButton.layer.zPosition = 2
        cell.thumbupButton.layer.zPosition = 2
        cell.buycolaButton.layer.zPosition = 2
        return cell
            
        }else{
            //section 0
            let tapGesture = UITapGestureRecognizer(
              target: self,
              action: #selector(handleTapAuthor)
            )
            tapGesture.delegate = self
            cell.editButton.addGestureRecognizer(tapGesture)
            let commenter = (questionJson["author"] as! String)
            let date = (questionJson["createdAt"] as! String)
            let title = (questionJson["title"] as! String)
            let body = (questionJson["body"] as! String)
            cell.answerer.setTitle((String(date.prefix(10)) + " " + commenter), for: .normal)
            cell.answerer.tag = -1 //indexPath.row
            cell.buycolaButton.tag = -1
            cell.buycolaButton.addTarget(self, action: #selector(openpateonView), for: UIControl.Event.touchUpInside)
            cell.thumbupButton.addTarget(self, action: #selector(articleThumbUpAction), for: UIControl.Event.touchUpInside)
            cell.answerer.contentHorizontalAlignment = .right
            cell.commentBodyTextView.text = title + ":\n" + body
            cell.replyButton.tag = -1
            cell.replyButton.addTarget(self, action: #selector(openreplyView), for: UIControl.Event.touchUpInside)
            cell.cellBgView.clipsToBounds = false
            cell.cellBgView.layer.backgroundColor = UIColor.white.cgColor
            cell.cellBgView.layer.cornerRadius = 10.0
            cell.cellBgView.layer.borderWidth = 2.0
            cell.cellBgView.layer.borderColor = UIColor.lightGray.cgColor
            cell.commentBodyTextView.isHidden = false
            cell.editButton.tag = -1 //indexPath.row
            cell.cellBgView.isUserInteractionEnabled = true
            return cell
        }
    }
  
  
    @objc func openThreedotAuthor(button:UIButton){
        
        
//        threeView.clipsToBounds = false
//        threeView.layer.cornerRadius = 15.0
//        threeView.layer.shadowOpacity=0.7
//        threeView.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
    }
    
    @objc func openThreedotCommentator(button:UIButton){
       
    }
    
    @objc func closeThreedot(){
        if threeView != nil{
            threeView.removeFromSuperview()
        }
        
        threeViewRowIndex = -1
    }
    
    @objc func showCorrection(button:UIButton) {
    }
    

    @objc func textUpdateCommentator(){
        if textEditView != nil{
            textEditView.removeFromSuperview()
        }
        let json = commentArry[threeViewRowIndex ] as! [String:Any]
        let body = (json["body"] as! String)
        textEditView = TextEditView(frame: CGRect(x:0,y:Int(SCREENSIZE - KEYBOARDLOCATION - 240), width: Int(view.frame.size.width),height: 240))
        textEditView.textView.delegate = self
        textEditView.textView.becomeFirstResponder()
        textEditView.textView.text = body
        //no title field
        textEditView.titleView.isHidden = true
        textEditView.closeButton.addTarget(self, action: #selector(closetexteditView), for: UIControl.Event.touchUpInside)
        textEditView.editedSubtmitButton.addTarget(self, action: #selector(commentUpdateAction), for: UIControl.Event.touchUpInside)
        textEditView.textView.layer.cornerRadius = 10.0
        let color = UIColor.lightGray.withAlphaComponent(0.8)
        textEditView.view.backgroundColor = color
        view.addSubview(textEditView)
    }
    @objc func textUpdateAuthor(){
        if textEditView != nil{
            textEditView.removeFromSuperview()
        }
        let body = questionJson["body"] as? String
        let title = questionJson["title"] as? String
        textEditView = TextEditView(frame: CGRect(x:0,y:Int(SCREENSIZE - KEYBOARDLOCATION - 240), width: Int(view.frame.size.width),height: 240))
        textEditView.textView.delegate = self
        textEditView.textView.becomeFirstResponder()
        textEditView.textView.text = body
        textEditView.titleView.text = title
        
        textEditView.closeButton.addTarget(self, action: #selector(closetexteditView), for: UIControl.Event.touchUpInside)
        textEditView.editedSubtmitButton.addTarget(self, action: #selector(articleUpdateAction), for: UIControl.Event.touchUpInside)
        textEditView.textView.layer.cornerRadius = 10.0
        textEditView.titleView.layer.cornerRadius = 10.0
        let color = UIColor.lightGray.withAlphaComponent(0.8)
        textEditView.view.backgroundColor = color
        view.addSubview(textEditView)
    }
    
    @objc func handleTapAuthor(_ gesture: UITapGestureRecognizer) {
        print(gesture.location(in: postshowcommentTable))
        print("tag",gesture.view?.tag as Any)
        let location = gesture.location(in: postshowcommentTable)
        
        if threeView != nil{
            threeView.removeFromSuperview()
        }
        threeView = ThreedotView(frame: CGRect(x:view.frame.size.width - 300,y:location.y-20, width:240,height:130))
        threeView.tag = gesture.view!.tag
        threeView.closeButton.addTarget(self, action: #selector(closeThreedot), for: UIControl.Event.touchUpInside)
        threeView.editTextButton.addTarget(self, action: #selector(textUpdateAuthor), for: UIControl.Event.touchUpInside)
        threeView.editTextButton.tag = gesture.view!.tag
        threeView.reportAsSpamButton.addTarget(self, action: #selector(sendReportEmail), for: UIControl.Event.touchUpInside)
        threeView.layer.cornerRadius = 10.0
        threeView.layer.borderWidth = 0.7
        threeView.layer.borderColor = UIColor.systemBlue.cgColor
        //delete
        threeView.deleteButton.addTarget(self, action: #selector(openMview), for: UIControl.Event.touchUpInside)
        
        let userId = questionJson["_userId"] as? String
        if userId == nil{
            threeView.editTextButton.isHidden = true
        }
        if clientsideUserid != userId{
            threeView.editTextButton.isHidden = true
        }
        //not for article
        threeView.deleteButton.isHidden = true
        
        postshowcommentTable.addSubview(threeView)
    }
    
    @objc func handleTapCommentator(_ gesture: UITapGestureRecognizer) {
        print(gesture.location(in: postshowcommentTable))
        print("tag",gesture.view?.tag as Any)
        let location = gesture.location(in: postshowcommentTable)
        if threeView != nil{
            threeView.removeFromSuperview()
        }
        threeView = ThreedotView(frame: CGRect(x:Int(view.frame.size.width) - 300,y:Int(location.y-20), width:240,height:130))
        threeView.tag = gesture.view!.tag
        threeViewRowIndex = gesture.view!.tag
        threeView.closeButton.addTarget(self, action: #selector(closeThreedot), for: UIControl.Event.touchUpInside)
        threeView.editTextButton.addTarget(self, action: #selector(textUpdateCommentator), for: UIControl.Event.touchUpInside)
        threeView.reportAsSpamButton.addTarget(self, action: #selector(sendReportEmail), for: UIControl.Event.touchUpInside)
        threeView.layer.cornerRadius = 10.0
        threeView.layer.borderWidth = 0.7
        threeView.layer.borderColor = UIColor.systemBlue.cgColor
        //delete
        threeView.deleteButton.addTarget(self, action: #selector(openMview), for: UIControl.Event.touchUpInside)
        
        let json = commentArry[threeViewRowIndex ] as! [String:Any]
        let userId = json["_userId"] as? String
        if userId == nil{
            threeView.editTextButton.isHidden = true
            threeView.deleteButton.isHidden = true
        }
        if clientsideUserid != userId{
            threeView.editTextButton.isHidden = true
            threeView.deleteButton.isHidden = true
        }
        postshowcommentTable.addSubview(threeView)
        
    }
    
    @objc func openMview(button:UIButton){
        //don't forget first call
        if mview != nil{
            mview.removeFromSuperview()
        }
        
        mview = modalView(frame: CGRect(x:(view.frame.size.width - 270) / 2 ,y:30, width: 270,height: 95))
        mview.modalOkButton.tag = button.tag
        mview.modalOkButton.addTarget(self, action: #selector(deleteItem), for: UIControl.Event.touchUpInside)
        mview.modalCancelButton.addTarget(self, action: #selector(cancelDelete), for: UIControl.Event.touchUpInside)
        mview.modalLabel.text = "Delete this data?"
        mview.modalLabel.textColor = UIColor.white
        mview.view.backgroundColor = UIColor.lightGray
        mview.view.layer.cornerRadius = 8
//        mview.layer.borderWidth = 1
//        mview.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(mview)
    }
     
    @objc func deleteItem(button:UIButton){
        //delete a comment not article
        if threeViewRowIndex > -1{
            let json = commentArry[threeViewRowIndex ] as! [String:Any]
            let id = (json["_id"] as! String)
            commentDelete(id:id)
        }
    }
    
    @objc func cancelDelete(){
        mview.removeFromSuperview()
    }
    
    @objc func playAudio(button:UIButton) {
        print("playAudio")
        button.layer.cornerRadius = 8
        button.layer.backgroundColor = UIColor.gray.cgColor
        let json = commentArry[button.tag] as! [String:Any]
        
//        button.isEnabled = false
        var checkURL = ""
        if let test = json["s3_audio_url"] {
            checkURL = json["s3_audio_url"] as! String
        }
        
        if checkURL  ==  "ABCD.mp3" {
            button.isEnabled = true
        }else{

            let uurl = getDocumentsDirectory().appendingPathComponent(checkURL)
            if FileManager.default.fileExists(atPath: uurl.path) {
                playback(url: uurl)
            }else{
                downloadAction(filename: checkURL)
            }
            button.isEnabled = true
        }
        
        
        button.layer.cornerRadius = 8
        button.layer.backgroundColor = UIColor.systemOrange.cgColor
       
        
    }
    
    
    @IBAction func postshowshowBodyAction(_ sender: Any) {
//        postshowtextview.text = (questionJson["body"] as! String)
//        let postedDate = (questionJson["created_at"] as! String)
//        postshowTitle.setTitle((questionJson["title"] as! String), for: .normal)
//        postshowQuestioner.setTitle(String(postedDate.prefix(10)) + " " + (questionJson["questioner"] as! String), for: .normal)
    }
    
    @objc func moveProfileShow(button:UIButton){
      
    }
    
    @IBAction func questionerProfileAction(_ sender: Any) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let vcP = storyBoard.instantiateViewController(withIdentifier: "showprofile") as! ShowProfileController
//        vcP.selectedTab = 1
//        vcP.profileId = questionJson["user_id"] as! Int
//        vcP.modalPresentationStyle = .fullScreen
//        self.present(vcP, animated:false, completion:nil)
    }
    @IBAction func bookMarkPostAction(_ sender: Any) {
        if (UserDefaults.standard.object(forKey: "newtoken") != nil) {
            let token = UserDefaults.standard.object(forKey: "newtoken") as! String
            let idNum = (questionJson["id"] as! Int)
            bookMarkPost(token: token, id: "\(idNum)")
            
        }
        
    }
    
    
    @IBAction func reportPostAction(_ sender: Any) {
        if (UserDefaults.standard.object(forKey: "newtoken") != nil) {
            let token = UserDefaults.standard.object(forKey: "newtoken") as! String
            let idNum = (questionJson["id"] as! Int)
            reportPost(token: token, id: "\(idNum)")
            
        }
    }
    @IBAction func audioplaybackAction(_ sender: Any) {
        
 
        var checkURL = ""
        if let test = questionJson["s3_audio_url"] {
            checkURL = questionJson["s3_audio_url"] as! String
        }
        
        if checkURL  ==  "ABCD.mp3" {
            
        }else{
            
            
            
            
            let uurl = getDocumentsDirectory().appendingPathComponent(checkURL)
            if FileManager.default.fileExists(atPath: uurl.path) {
                playback(url: uurl)
            }else{
                downloadAction(filename: checkURL)
            }
            
            
            
            
            
        }
    }
    
    //https://stackoverflow.com/questions/28630833/change-avaudioplayer-output-to-speaker-in-swift
    //iPhone speaker not working when some songs having too small volumes played back.
    func playback(url:URL){
//        postshowPlayAudio.isEnabled = true
        do {
        
            SetSessionPlayerOn()
           
            AVAPlayer = try AVAudioPlayer(contentsOf: url)
            AVAPlayer?.play()
            AVAPlayer?.volume = 3
            print("good")
        } catch {
            // couldn't load file :(
            print(":(")
        }
    }
    
    func SetSessionPlayerOn()
    {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch _ {
        }
    }
    
    
    @IBAction func showimageAction(_ sender: Any) {
        //Close
        
        
        
        
        
    }
    
    @objc func authFlowCommence() {
        
        // Use only one of these two flows at once:
        
        // New: OAuth 2 code flow with PKCE that grants a short-lived token with scopes.
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read","files.content.write","files.content.read"], includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: self,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )
    }
    
    func downloadAction(filename:String){
        // Reference after programmatic auth flow
        let client = DropboxClientsManager.authorizedClient
        if client == nil {
            authFlowCommence()
        }else{
            // Download to URL
            
            let fileManager = FileManager.default
            let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destURL = directoryURL.appendingPathComponent(filename)
            let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                return destURL
            }
            client?.files.download(path: "/Audios/" + filename, overwrite: true, destination: destination)
                .response { response, error in
                    if let response = response {
                        print(response)
                        self.playback(url: destURL)
                        
                    } else if let error = error {
                        print(error)
//                        self.postshowPlayAudio.isEnabled = true
                    }
            }
            .progress { progressData in
                print(progressData)
            }
            
            
            
        }
    }
    
    //getDocuments
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            KEYBOARDLOCATION = keyboardHeight
            
            
            if firstUse{
            Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: false)
            }
            firstUse = false
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
     //TODO terminate
//        rView.replyTextView.resignFirstResponder()
    }
    
    @objc func openreplyView(button:UIButton) {
        if rView != nil{
            rView.removeFromSuperview()
        }
        isReplyClicked = true
        rView = ReplyView(frame: CGRect(x:0,y:Int(SCREENSIZE - KEYBOARDLOCATION - 120.0), width: Int(view.frame.size.width),height: 120))
        rView.replyTextView.delegate = self
        rView.replyTextView.becomeFirstResponder()
        currentRowIndex = button.tag
        rView.closeButton.addTarget(self, action: #selector(closereplyView), for: UIControl.Event.touchUpInside)
        rView.replySubtmitButton.addTarget(self, action: #selector(sendreplyAction), for: UIControl.Event.touchUpInside)
        rView.replyTextView.layer.cornerRadius = 10.0
        let color = UIColor.lightGray.withAlphaComponent(0.8)
        rView.view.backgroundColor = color
        view.addSubview(rView)
    }
    
    @objc func closereplyView() {
        if rView != nil{
            rView.removeFromSuperview()
        }
    }
    
    @objc func closetexteditView() {
        if textEditView != nil{
            textEditView.removeFromSuperview()
        }
    }
    
    @objc func closedetailView() {
        if detailView != nil{
            detailView.removeFromSuperview()
        }
    }
    @objc func closepatreonView() {
        if patreonView != nil{
            patreonView.removeFromSuperview()
        }
    }
    
    @objc func opendetailView() {
        if detailView != nil{
            detailView.removeFromSuperview()
        }
        detailView = DetailImageView(frame: CGRect(x:0,y:0, width:view.frame.size.width,height: view.frame.size.height))
       
        let color = UIColor.black.withAlphaComponent(0.8)
        detailView.view.backgroundColor = color
        
        detailView.iamgecloseButton.addTarget(self, action: #selector(closedetailView), for: UIControl.Event.touchUpInside)
        view.addSubview(detailView)
    }
    
    @objc func openpateonView(button:UIButton) {
        var name = ""
        var paypal = ""
        var patreon = ""
        //TODO paypal patreon
        if button.tag > -1{
            let json = commentArry[button.tag] as! [String:Any]
            name = json["commentatorName"] as! String
            patreon = json["patreonUrl"] as! String
            paypal = json["paypalEmail"] as! String
        }else{
            name = questionJson["author"] as! String
            patreon = questionJson["patreonUrl"] as! String
            paypal = questionJson["paypalEmail"] as! String
            
        }
        let body = "patreon account info:" + patreon + "\n" + "paypal payment info:" + paypal + "\n"
        
        if patreonView != nil{
            patreonView.removeFromSuperview()
        }
        patreonView = PatreonView(frame: CGRect(x:10,y:(view.frame.size.height - 350) / 2, width:view.frame.size.width - 20,height:350 ))
       
//        let color = UIColor.black.withAlphaComponent(0.8)
//        patreonView.view.backgroundColor = color
        patreonView.textView.dataDetectorTypes = UIDataDetectorTypes.link
        patreonView.closeButton.addTarget(self, action: #selector(closepatreonView), for: UIControl.Event.touchUpInside)
        
        
//        patreonView.layer.cornerRadius = 15
//        patreonView.layer.borderWidth = 5.0
        patreonView.layer.borderColor = UIColor.systemBlue.cgColor
        patreonView.clipsToBounds = false
        patreonView.layer.shadowOpacity=0.7
        patreonView.layer.shadowOffset = CGSize(width: 1, height: 1)
        patreonView.nameLabel.text = name
        patreonView.textView.text = body
        view.addSubview(patreonView)
    }
    
    @objc func timerUpdate(){
        
        if isReplyClicked{
            let btn = UIButton()
            btn.tag = currentRowIndex 
            openreplyView(button: btn)
            return
        }
        if threeViewRowIndex > -1{
            textUpdateCommentator()
            return
        }
        textUpdateAuthor()
        return  
    }
    @objc func timerUpdate2(){
        commentShow(token: "notoken", id: postId)
    }
    @objc func commentUpdateAction(){
        var json = commentArry[threeViewRowIndex ] as! [String:Any]
        let commentid = json["_id"] as? String
        let body = textEditView.textView.text
        if commentid == nil || body == nil {
            return
        }
        let bc = BaseController()
        //posts put
        let Url = "https://" + bc.HOST_IP + "/comments/" + commentid!
        let parameterDictionary = ["body":body]
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[])
        request.httpBody = httpBody
        request.httpMethod = "PUT"
        print(serviceUrl as Any)
        
        bc.session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
            if let data = data {
                do {
                    DispatchQueue.main.async(execute: {
                        if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode == 400{
                                self.loadingGear.isHidden = true
                                self.errorModal(message: "Error 400")
                                return
                            }
                            if httpResponse.statusCode == 404{
                                self.loadingGear.isHidden = true
                                self.errorModal(message: "Error 404")
                                return
                            }
                            if httpResponse.statusCode == 200{
                                self.loadingGear.isHidden = true
                                self.successModal(message: "Update Success")
                                self.textEditView.textView.resignFirstResponder()
                                self.textEditView.titleView.resignFirstResponder()
                                self.closetexteditView()
//                                self.postshowcommentTable.reloadData()
                                self.timerUpdate2()
                                return
                            }
                        }
                        self.loadingGear.isHidden = true
                    })
                }
            }
        }).resume()
    }
    @objc func articleUpdateAction(){
        let pid = questionJson["_id"] as? String
        let body = textEditView.textView.text
        let title = textEditView.titleView.text
        if pid == nil || body == nil || title == nil{
            return
        }
        let bc = BaseController()
        //posts put
        let Url = "https://" + bc.HOST_IP + "/posts/" + pid!
        let parameterDictionary = ["body":body, "title" :title]
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[])
        request.httpBody = httpBody
        request.httpMethod = "PUT"
        print(serviceUrl as Any)
        
        bc.session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
            if let data = data {
                do {
                    DispatchQueue.main.async(execute: {
                        if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode == 400{
                                self.loadingGear.isHidden = true
                                self.errorModal(message: "Error 400")
                                return
                            }
                            if httpResponse.statusCode == 404{
                                self.loadingGear.isHidden = true
                                self.errorModal(message: "Error 404")
                                return
                            }
                            if httpResponse.statusCode == 200{
                                self.loadingGear.isHidden = true
                                self.successModal(message: "Update Success")
                                self.textEditView.textView.resignFirstResponder()
                                self.textEditView.titleView.resignFirstResponder()
                                self.questionJson["title"] = title
                                self.questionJson["body"] = body
                                self.closetexteditView()
                                self.postshowcommentTable.reloadData()
                                return
                            }
                        }
                        self.loadingGear.isHidden = true
                    })
                }
            }
        }).resume()
    }
    @objc func sendreplyAction() {
        let replyBody = rView.replyTextView.text
        if replyBody?.count == 0{
            return
        }
        var author = "anonymous"
        var patreon = "none"
        var paypal = "none"
        //user id of the person posted this question not commentators
        let postUserId = questionJson["_userId"] as! String
        //In this context author is the owner of this device. commentator.  also the owner can be a author in other post. 
        if (UserDefaults.standard.object(forKey: "author") != nil ) {
            author = UserDefaults.standard.object(forKey: "author") as! String
        }
        if (UserDefaults.standard.object(forKey: "patreon") != nil ) {
            patreon = UserDefaults.standard.object(forKey: "patreon") as! String
        }
        if (UserDefaults.standard.object(forKey: "paypal") != nil ) {
            paypal = UserDefaults.standard.object(forKey: "paypal") as! String
        }
        if (UserDefaults.standard.object(forKey: "newuserId") != nil ) {
            let userIdStr = UserDefaults.standard.object(forKey: "newuserId") as! String
            commentStore(userId:userIdStr , postId: postId,body:replyBody!, author:author,patreon: patreon,paypal: paypal,postUserId: postUserId)
            loadingGear.isHidden = false
        }else{
            return
        }
    }
    
    //add http request comment params body, paypal,patreon postid,userid,author,originalpostuserid
    func commentStore(userId:String,postId:String,body:String, author:String,patreon:String,paypal:String,postUserId:String) {
            let bc = BaseController()
        let Url = "https://" + bc.HOST_IP + "/comments"
        let parameterDictionary = ["body":body, "_userId" : userId,"postId":postId,"commentatorName":author,"patreon":patreon,"paypal":paypal,"postUserId":postUserId]
            let serviceUrl = URL(string: Url)
            var request = URLRequest(url: serviceUrl!)
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
            let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[])
            request.httpBody = httpBody
                request.httpMethod = "POST"
            print(parameterDictionary)
           
            bc.session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
                     if let data = data {
                         do {
                            DispatchQueue.main.async(execute: {
                                self.loadingGear.isHidden = true
                                //TODO Do something to update the datasource.. wait, just go back at here
//                                self.postshowcommentTable.reloadData()
                                
                                if let httpResponse = response as? HTTPURLResponse {
                                    print(httpResponse.statusCode)
                                    if httpResponse.statusCode == 400{
                                        //TODO ERROR MSG MODAL
                                        self.errorModal(message: "Error 404")
                                        return
                                    }
                                    if httpResponse.statusCode == 201{
                                        self.rView.replyTextView.resignFirstResponder()
                                        self.rView.removeFromSuperview()
                                        self.successModal(message: "Your comment has been uploaded.")
                                        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.postGotNewComment), userInfo: nil, repeats: false)
                                        
                                    }
                                }
                            })
                         }
                     }
                     }).resume()
       }
    
    //delete comment
    func commentDelete(id:String) {
        let bc = BaseController()
        let Url = "https://" + bc.HOST_IP + "/comments/" + id
        
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        
        request.httpMethod = "DELETE"
        print(serviceUrl as Any)
        
        bc.session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
            if let data = data {
                do {
                    DispatchQueue.main.async(execute: {
                        if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode == 400{
                                self.loadingGear.isHidden = true
                                self.errorModal(message: "Error 400")
                                return
                            }
                            if httpResponse.statusCode == 404{
                                self.loadingGear.isHidden = true
                                self.errorModal(message: "Error 404")
                                return
                            }
                            if httpResponse.statusCode == 204{
                                self.loadingGear.isHidden = true
                                self.successModal(message: "Delete Success")
                                self.timerUpdate2()
                                self.mview.removeFromSuperview()
                                self.threeView.removeFromSuperview()
                                return
                            }
                        }
                        self.loadingGear.isHidden = true
                    })
                }
            }
        }).resume()
    }
    @objc func commentThumbUpAction(button:UIButton){
        //Even guest user can do it
        //button.tag start from 0
        let json = commentArry[button.tag] as! [String:Any]
        let commentid = json["_id"] as? String
        var thumbup = json["popularity"] as? Int
        if commentid == nil || thumbup == nil{
            return
        }else{
            thumbup! += 1
        }
        if bookmarkedcomments.contains(commentid!){
            errorModal(message: "You already liked it.")
            return
        }else{
            bookmarkedcomments.append(commentid!)
            let defaults0 = UserDefaults.standard
            defaults0.set(bookmarkedcomments , forKey: "bookmarkedcomments")
            defaults0.synchronize()
        }
        
        let bc = BaseController()
        //posts put
        let Url = "https://" + bc.HOST_IP + "/comments/" + commentid!
        let parameterDictionary = ["popularity":thumbup]
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[])
        request.httpBody = httpBody
        request.httpMethod = "PUT"
        print(serviceUrl as Any)
        
        bc.session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
            if let data = data {
                do {
                    DispatchQueue.main.async(execute: {
                        if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode == 400{
                                self.loadingGear.isHidden = true
                                self.errorModal(message: "Error 400")
                                return
                            }
                            if httpResponse.statusCode == 404{
                                self.loadingGear.isHidden = true
                                self.errorModal(message: "Error 404")
                                return
                            }
                            if httpResponse.statusCode == 200{
                                self.loadingGear.isHidden = true
                                self.successModal(message: "You liked this comment.")
                                return
                            }
                        }
                        self.loadingGear.isHidden = true
                    })
                }
            }
        }).resume()
    }
    @objc func articleThumbUpAction(){
        let pid = questionJson["_id"] as? String
        if pid == nil{
            return
        }
        var thumbup = questionJson["popularity"] as? Int
        if thumbup == nil{
            return
        }else{
            thumbup! += 1
        }
        if bookmarkedposts.contains(pid!){
            errorModal(message: "You already liked it.")
            return
        }else{
            bookmarkedposts.append(pid!)
            let defaults0 = UserDefaults.standard
            defaults0.set(bookmarkedposts , forKey: "bookmarkedposts")
            defaults0.synchronize()
        }
        let bc = BaseController()
        //posts put
        let Url = "https://" + bc.HOST_IP + "/posts/" + pid!
        let parameterDictionary = ["popularity":thumbup]
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[])
        request.httpBody = httpBody
        request.httpMethod = "PUT"
        print(serviceUrl as Any)
        
        bc.session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
            if let data = data {
                do {
                    DispatchQueue.main.async(execute: {
                        if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode == 400{
                                self.loadingGear.isHidden = true
                                self.errorModal(message: "Error 400")
                                return
                            }
                            if httpResponse.statusCode == 404{
                                self.loadingGear.isHidden = true
                                self.errorModal(message: "Error 404")
                                return
                            }
                            if httpResponse.statusCode == 200{
                                self.loadingGear.isHidden = true
                                self.successModal(message: "You liked this post.")
                                return
                            }
                        }
                        self.loadingGear.isHidden = true
                    })
                }
            }
        }).resume()
    }
    @objc func commentUploaded(){
        commentShow(token: "notoken", id: postId)
    }
    @objc func postGotNewComment(){
        gotNewComment(postId:postId)
    }
    @objc func checkedNewComments(){
        checkedNewComment(postId: postId)
    }
    func errorModal(message:String){
        errorLabel.frame = CGRect(x: (view.frame.size.width*0.2)/2, y: view.frame.size.height - 120, width: view.frame.size.width*0.8, height: 50)
        errorLabel.layer.shadowOpacity=0.3
        errorLabel.layer.cornerRadius = 25
        errorLabel.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        errorLabel.layer.backgroundColor = UIColor.red.withAlphaComponent(0.7).cgColor
        errorLabel.textColor = UIColor.white
        errorLabel.textAlignment = NSTextAlignment.center
        errorLabel.numberOfLines = 0
        errorLabel.text = message
        self.view.addSubview(errorLabel)
        self.errorLabel.layer.zPosition = 30
    }
    
    func successModal(message:String){
        successLabel.frame = CGRect(x: (view.frame.size.width*0.2)/2, y: view.frame.size.height - 120, width: view.frame.size.width*0.8, height: 50)
        successLabel.layer.shadowOpacity=0.3
        successLabel.layer.cornerRadius = 25
        successLabel.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        successLabel.layer.backgroundColor = UIColor.green.withAlphaComponent(0.7).cgColor
        successLabel.textColor = UIColor.white
        successLabel.textAlignment = NSTextAlignment.center
        successLabel.numberOfLines = 0
        successLabel.text = message
        self.view.addSubview(successLabel)
        self.successLabel.layer.zPosition = 30
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @objc func sendReportEmail() {
        var reportedUserId : String?
        var reporterUserId : String?
        var contentId: String?
        var reportedContent: String?
        if (UserDefaults.standard.object(forKey: "newuserId") == nil ) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vcP = storyBoard.instantiateViewController(withIdentifier: "register") as! RegisterController
            vcP.modalPresentationStyle = .fullScreen
            self.present(vcP, animated:false, completion:nil)
        }else{
            reporterUserId = UserDefaults.standard.object(forKey: "newuserId") as! String
        }
        
        if threeViewRowIndex > -1 {
            let json = commentArry[threeViewRowIndex] as! [String:Any]
            contentId = (json["_id"] as! String)
            reportedUserId = (json["_userId"] as! String)
            reportedContent = (json["body"] as! String)
        }else{
            contentId = (questionJson["_id"] as! String)
            reportedUserId = (questionJson["_userId"] as! String)
            reportedContent = (questionJson["body"] as! String)
        }
        if contentId == nil || reportedUserId == nil || reportedContent == nil{
            return
        }
        if MFMailComposeViewController.canSendMail() {
//            let today: Date = Date()
//            let dateFormatter: DateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
//            var date = dateFormatter.string(from: today)
//            let dateStr = String(date)
//            dateStr.replacingOccurrences(of: ":", with: "_")
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            
            mail.setSubject("Spam,threatening, abusal, other malicious content:" + contentId! + ", created by " +  reportedUserId!  )
            mail.setToRecipients(["idraft@startnewlanguagetoday.net"])
            mail.setMessageBody(reportedContent!, isHTML: false)
            
            present(mail, animated: true)
        }
    }
    
}
extension UIColor {
    func createOnePixelImage() -> UIImage? {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIButton {
    func setBackground(_ color: UIColor, for state: UIControl.State) {
        setBackgroundImage(color.createOnePixelImage(), for: state)
    }
}
extension UITextView {
    func numberOfLines() -> Int {
        let layoutManager = self.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0

        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(
                forGlyphAt: index, effectiveRange: &lineRange
            )
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
}
//https://stackoverflow.com/questions/31663159/get-number-of-lines-in-uitextview-without-contentsize-height
