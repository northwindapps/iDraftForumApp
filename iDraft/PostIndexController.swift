//
//  PostIndexController.swift
//  iDraft
//
//  Created by yujin on 2020/07/14.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

class PostIndexController: BaseController, UITableViewDelegate, UITableViewDataSource,GADBannerViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        languageArry.count
    }
    
    var activeTab = 0
    var arrayJson = NSMutableArray()
    @IBOutlet weak var loadingGear: UIActivityIndicatorView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var questionTable: UITableView!
    @IBOutlet weak var languageSelector: UIPickerView!
    var openingQuestionNSArray = NSArray()
    var selectedLanguage = "en"
    
    let languageArry = [
    "English",
    "Español",
    "Français",
    "Deutsch",
    "中文簡体",
    "中文繁体",
    "한국어",
    "日本語",
    "Русский",
    "Svenska",
    "Dansk",
    "Italiano",
    "Português",
    "Suomi",
    "ภาษาไทย",
    "Türkçe",
    "Nederlands",
    "språk",
    "Ελληνικά",
    "Tiếng Việt",
        "Latin",
    "עברית",
        "ܣܘܪܝܝܐ",
"اللغة العربية",
    ]
    
    let languageCode = [
    "en",
    "es",
    "fr",
    "de",
    "zhsp",
    "zh",
    "ko",
    "ja",
    "ru",
    "sv",
    "da",
    "it",
    "pt",
    "su",
    "th",
    "tr",
    "nl",
    "sk",
    "el",
    "vt",
    "la",
    "he",
    "sy",
    "ar"
    ]
    
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return languageArry[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        print(languageCode[row])
        selectedLanguage = languageCode[row]
        questions3(language: selectedLanguage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingGear.layer.zPosition = 30
        loadingGear.isHidden = false
        tabBar.selectedItem = tabBar.items![activeTab]
        questionTable.delegate = self
        // Do any additional setup after loading the view.
        
        questions3(language: selectedLanguage)
        
        
        bannerView.adUnitID = "ca-app-pub-5284441033171047/3584031026"
//                bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //        "ca-app-pub-3940256099942544/2934735716" test
        bannerView.rootViewController = self
        requestIDFA()
               
        languageSelector.delegate = self
        languageSelector.dataSource = self
       
        languageSelector.layer.cornerRadius = 15
        languageSelector.layer.borderWidth = 0.5
        languageSelector.backgroundColor = UIColor.white
        languageSelector.clipsToBounds = false
        languageSelector.layer.shadowOpacity=0.7
        languageSelector.layer.shadowOffset = CGSize(width: 1, height: 1)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = 100.0
        return CGFloat(height)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openingQuestionNSArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell : QuestionTableViewCell = questionTable.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionTableViewCell
        
//        let cell2 : QuestionTableViewCell = questionTable.dequeueReusableCell(withIdentifier: "QuestionCell2", for: indexPath) as! QuestionTableViewCell error
//        let test = "https://idraft.s3.amazonaws.com/public/cover_images/958072_1594808012.png"
//        cell.avaterImg.load(url: URL.init(string: test)!)
        cell.BgView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        cell.BgView.layer.borderWidth = 1.0
        cell.BgView.layer.cornerRadius = 15.0
//        cell.BgView.layer.shadowColor = UIColor.black.cgColor
//        cell.BgView.layer.shadowOpacity = 0.6
//        cell.BgView.layer.shadowOffset = CGSize(width: 0.6, height: 0.6)
//        cell.BgView.layer.shadowRadius = 0.0
        if indexPath.row == 0{
        let json = openingQuestionNSArray[indexPath.row] as! [String:Any]
        cell.postTitle.text = (json["title"] as! String)
        cell.postBody.text = (json["body"] as! String)
        
        cell.postTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.postTitle.frame.size.height = cell.postTitle.frame.height
        
        let postedDate = (json["createdAt"] as! String)
        let postLanguage = (json["language"] as! String)
        cell.postDate.text = String(postedDate.prefix(10)) + " " + postLanguage
        
        
        
        let name = (json["author"] as! String)
        let size:CGFloat = 40.0 // 35.0 chosen arbitrarily

        cell.avaterLabel.bounds = CGRect(x: 0.0, y: 0.0, width: size, height: size)
        cell.avaterLabel.layer.cornerRadius = size / 2
        cell.avaterLabel.layer.borderWidth = 3.0
        cell.avaterLabel.layer.backgroundColor = UIColor.clear.cgColor
        cell.avaterLabel.layer.borderColor = UIColor.systemRed.cgColor //.random.cgColor
        cell.avaterLabel.text = String(name.prefix(3))
        
     
        return cell
            
        }else{
            let json = openingQuestionNSArray[indexPath.row] as! [String:Any]
            cell.postTitle.text = (json["title"] as! String)
            cell.postBody.text = (json["body"] as! String)
            cell.postTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.postTitle.frame.size.height = cell.postTitle.frame.height
            
            let postedDate = (json["createdAt"] as! String)
            let postLanguage = (json["language"] as! String)
            cell.postDate.text = String(postedDate.prefix(10)) + " " + postLanguage
            
            
            
            let name = (json["author"] as! String)
            let size:CGFloat = 40.0 // 35.0 chosen arbitrarily

            cell.avaterLabel.bounds = CGRect(x: 0.0, y: 0.0, width: size, height: size)
            cell.avaterLabel.layer.cornerRadius = size / 2
            cell.avaterLabel.layer.borderWidth = 3.0
            cell.avaterLabel.layer.backgroundColor = UIColor.clear.cgColor
            cell.avaterLabel.layer.borderColor = UIColor.systemRed.cgColor //.random.cgColor
            cell.avaterLabel.text = String(name.prefix(3))
            
            
         
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let json = openingQuestionNSArray[indexPath.row] as! [String:Any]
        print(json)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vcP = storyBoard.instantiateViewController(withIdentifier: "postshow") as! PostShowController
        vcP.selectedTab = 2
        let id = (json["_id"] as! String)
        vcP.postId = "\(id)"
        vcP.questionJson = json
        vcP.modalPresentationStyle = .fullScreen
        self.present(vcP, animated:false, completion:nil)
    }
    
  
    
    func questions3(language:String) {
        let Url = "https://" + HOST_IP + "/posts/searches?language=" + language
        print("Url",Url)
//           let Url = "https://www.idraft.app/posts"
           
                 let serviceUrl = URL(string: Url)
                 var request = URLRequest(url: serviceUrl!)
                 request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
                 request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
                 
                 request.httpMethod = "GET"
                
           
        session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
                     if let data = data {
                         do {
                            if let httpResponse = response as? HTTPURLResponse {
                                print(httpResponse.statusCode)
                                if httpResponse.statusCode == 400{
                                    //TODO ERROR MSG MODAL
                                    return
                                }
                            }
                           let Ary = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray

                            print("dataArry",Ary as Any)
                            DispatchQueue.main.async(execute: {
                                self.openingQuestionNSArray =  Ary!
                                self.questionTable.reloadData()
                                self.loadingGear.isHidden = true
                                self.questionTable.separatorColor = UIColor.systemGray
                                self.questionTable.separatorStyle = .singleLine
                            })

                         } catch {
                           print(error)
    
                         }
                     }
                     }).resume()
       }
    
    
    
    

}

