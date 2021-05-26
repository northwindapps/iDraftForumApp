//
//  UserController.swift
//  iDraft
//
//  Created by yujin on 2020/07/12.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

class UserController: BaseController, UITableViewDelegate, UITableViewDataSource,GADBannerViewDelegate{
    
    var mview: modalView!
    
    @IBOutlet weak var posthistoryLabel: UILabel!
    @IBOutlet weak var loadingGear: UIActivityIndicatorView!
    @IBOutlet weak var userListTable: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    var activeTab = 0
    var user_id = -1
    var postNSArry = NSMutableArray()
    var deleteButtonText = "Delete"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tabBar.selectedItem = tabBar.items![activeTab]
        userListTable.delegate = self
        // Do any additional setup after loading the view.
        
       
        
        if (UserDefaults.standard.object(forKey: "newuserId") != nil ) {
            let userIdStr = UserDefaults.standard.object(forKey: "newuserId") as! String
            loadingGear.isHidden = false
            postingHistory(id: userIdStr)
        }
        
        //Bookmark table
        if (UserDefaults.standard.object(forKey: "newtoken") != nil) {
            let token = UserDefaults.standard.object(forKey: "newtoken") as! String
            bookmarkUser(token: token)
            
        }
        
        bannerView.adUnitID = "ca-app-pub-5284441033171047/3584031026"
        //        ca-app-pub-5284441033171047/3584031026
        //        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //        "ca-app-pub-3940256099942544/2934735716" test
        bannerView.rootViewController = self
        requestIDFA()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if (UserDefaults.standard.object(forKey: "newuserId") == nil ) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vcP = storyBoard.instantiateViewController(withIdentifier: "register") as! RegisterController
            vcP.modalPresentationStyle = .fullScreen
            self.present(vcP, animated:false, completion:nil)
        }
        
        let locationstr = (NSLocale.preferredLanguages[0] as String?)!
        
        if locationstr.contains( "ja")
        {
            
            posthistoryLabel.text = "投稿履歴"
            deleteButtonText = "消去"
        }else if locationstr.contains( "fr")
        {
            posthistoryLabel.text = "Historique des publications"
            deleteButtonText = "effacer"
        }else if locationstr.contains( "zh"){
            posthistoryLabel.text = "删除"
            deleteButtonText = "消去"
        }else if locationstr.contains( "de")
        {
            posthistoryLabel.text = "Post Geschichte"
            deleteButtonText = "löschen"
        }else if locationstr.contains( "it")
        {
            posthistoryLabel.text = "Cronologia dei post"
            deleteButtonText = "Elimina"
        }else if locationstr.contains( "ru")
        {
            posthistoryLabel.text = "История сообщений"
            deleteButtonText = "Удалить"
        }else if locationstr.contains("ar")
        {
            posthistoryLabel.text = "تاريخ النشر"
            deleteButtonText = "حذف"
        }else if locationstr.contains("es")
        {
            posthistoryLabel.text = "Historial de publicaciones"
            deleteButtonText = "Eliminar"
        }else if locationstr.contains("en")
        {
            posthistoryLabel.text = "Post History"
            deleteButtonText = "Delete"
        }else{
           
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postNSArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : BookmarkedUserTableViewCell = userListTable.dequeueReusableCell(withIdentifier: "postingHistory", for: indexPath) as! BookmarkedUserTableViewCell
        
        let json = postNSArry[indexPath.row] as! [String:Any]
        
        cell.bookMarkUserLabel.numberOfLines = 0
        
        cell.bookMarkUserLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.bookMarkUserLabel.text = (json["title"] as! String)
        cell.bookMarkUserLabel.sizeToFit()
        
        cell.bookMarkUserDelete.layer.cornerRadius = 8
        cell.bookMarkUserDelete.layer.borderWidth = 1
        cell.bookMarkUserDelete.layer.borderColor = UIColor.systemRed.cgColor
        
        //new message
        
        let checkUptodate  = json["newReply"] as? Bool
        if checkUptodate == true  {
            cell.bookMarkNewMessageImg.isHidden = false
        }else{
            cell.bookMarkNewMessageImg.isHidden = true
            
        }
        
        cell.bookMarkUserDelete.setTitle(deleteButtonText, for: .normal)
        cell.bookMarkUserDelete.tag = indexPath.row
        cell.bookMarkUserDelete.addTarget(self, action: #selector(openMview), for: UIControl.Event.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let json = postNSArry[indexPath.row] as! [String:Any]
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vcP = storyBoard.instantiateViewController(withIdentifier: "postshow") as! PostShowController
        vcP.selectedTab = 2
        let id = (json["_id"] as! String)
        vcP.postId = "\(id)"
        vcP.questionJson = json
        vcP.modalPresentationStyle = .fullScreen
        self.present(vcP, animated:false, completion:nil)
        
    }
    
    @IBAction func currentUserProfileAction(_ sender: Any) {
    }
    
    func postingHistory(id:String) {
        let Url = "https://" + HOST_IP + "/posts/searches?userId=" + id
        let serviceUrl = URL(string: Url)
        print(Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.httpMethod = "GET"
        
        session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
            if let data = data {
                do {
                    let Ary = try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                    
                    
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
                        self.postNSArry = Ary.mutableCopy() as! NSMutableArray
                        self.userListTable.reloadData()
                        self.loadingGear.isHidden = true
                    })
                    
                    
                } catch {
                    print(error)
                    
                }
            }
        }).resume()
    }
    
    
    func bookmarkUser(token:String) {
        let bc = BaseController()
        let Url = "https://" + bc.HOST_IP + "/api/auth/favorite/user"
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Bearer " + token, forHTTPHeaderField:  "Authorization" )
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.httpMethod = "GET"
        
        
        
        bc.session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    
                    
                    
                    DispatchQueue.main.async(execute: {
                        if json["data"] != nil{
                            let marry = (json["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                            self.postNSArry = marry
                            self.userListTable.reloadData()
                        }
                    })
                    
                    
                } catch {
                    print(error)
                    
                }
            }
        }).resume()
    }
    
    
    func postShow(token:String,id:String) {
        
        let Url = "https://" + HOST_IP + "/api/auth/post/show/" + id
        
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Bearer " + token, forHTTPHeaderField:  "Authorization" )
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        
        request.httpMethod = "GET"
        
        
        session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    
                    
                    
                    DispatchQueue.main.async(execute: {
                        if json["id"] != nil{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let vcP = storyBoard.instantiateViewController(withIdentifier: "postshow") as! PostShowController
                            vcP.selectedTab = 2
                            let idNum = (json["id"] as! Int)
                            vcP.postId = "\(idNum)"
                            vcP.questionJson = json
                            vcP.modalPresentationStyle = .fullScreen
                            self.present(vcP, animated:false, completion:nil)
                            
                        }
                    })
                    
                } catch {
                    print(error)
                    
                }
            }
        }).resume()
    }
    @objc func comentsDelete(postid:String){
        commentsDelete(id:postid)
    }
    func postDelete(id:String,tableCellRow:Int) {
        let Url = "https://" + HOST_IP + "/posts/" + id
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        
        request.httpMethod = "DELETE"
        print(serviceUrl as Any)
        
        session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
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
                                self.comentsDelete(postid:id)
                                self.postNSArry .removeObject(at: tableCellRow)
                                self.userListTable.reloadData()
                                self.loadingGear.isHidden = true
                                self.successModal(message: "Delete Success")
                                return
                            }
                        }
                        self.loadingGear.isHidden = true
                    })
                }
            }
        }).resume()
    }
    //all comments for the post Delete
    func commentsDelete(id:String) {
        let Url = "https://" + HOST_IP + "/comments/postid/" + id
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.httpMethod = "DELETE"
        print(serviceUrl as Any)
        
        session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
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
                                return
                            }
                        }
                        self.loadingGear.isHidden = true
                    })
                }
            }
        }).resume()
    }
    
    func bookmarkUptodate(token:String,id:String) {
        
        let Url = "https://" + HOST_IP + "/api/auth/favorite/" + id
        print("uptodateStart",Url)
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Bearer " + token, forHTTPHeaderField:  "Authorization" )
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        
        request.httpMethod = "POST"
        
        
        session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    
                    
                    
                    
                    DispatchQueue.main.async(execute: {
                        if json["bookmark_post"] != nil{
                            if (UserDefaults.standard.object(forKey: "newtoken") != nil) {
                                let post_id = json["bookmark_post"] as! Int
                                let token = UserDefaults.standard.object(forKey: "newtoken") as! String
                                self.postShow(token: token, id: "\(post_id)")
                                
                            }
                            
                            
                        }
                    })
                    
                    
                } catch {
                    print(error)
                    
                }
            }
        }).resume()
    }
    
    @objc func deleteItem(button:UIButton){
        let json = postNSArry[button.tag] as? [String:Any]
        if json != nil{
        let id = json!["_id"] as! String
            postDelete( id: "\(id)", tableCellRow: button.tag)
        }
        if mview != nil{
            mview.removeFromSuperview()
        }
    }
    
    @objc func cancelDelete(){
        mview.removeFromSuperview()
    }
    
    @objc func openMview(button:UIButton){
        //don't forget first call
        if mview != nil{
            mview.removeFromSuperview()
        }
        
        mview = modalView(frame: CGRect(x:10,y:30, width: 270,height: 95))
        mview.modalOkButton.tag = button.tag
        mview.modalOkButton.addTarget(self, action: #selector(deleteItem), for: UIControl.Event.touchUpInside)
        mview.modalCancelButton.addTarget(self, action: #selector(cancelDelete), for: UIControl.Event.touchUpInside)
        mview.modalLabel.text = "Delete this data?"
        
        mview.layer.cornerRadius = 8
        mview.layer.borderWidth = 1
        mview.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(mview)
        
        
        //http://studyswift.blogspot.jp/2015/01/showhide-keyboard-while-using.html
        //https://stackoverflow.com/questions/46375700/programmatically-create-touchupinside-event-for-uitextfield
        
    }
    
    
    
}

