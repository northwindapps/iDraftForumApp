//
//  ViewController1.swift
//  iDraft
//
//  Created by yujin on 2020/07/12.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit

class PostCreateController: BaseController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        languageArry.count
    }
    
    var mview :modalView!
    
    var activeTab = 0
    var posttitle = ""
    var postlanguage = "en"
    var postbody = ""
    var editJson = [String:Any]()
    var iCloudBody = ""
    var profileCheck = false
    var imageFileName = "noimage.png"
    var audioFileName = "ABCD.mp3"
    var postCreateView:PostcreateView!
    

    
    //https://stackoverflow.com/questions/29094129/swift-creating-a-vertical-uiscrollview-programmatically
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.selectedItem = tabBar.items![activeTab]
        
        if (UserDefaults.standard.object(forKey: "emailVerified") != nil) {
            profileCheck = UserDefaults.standard.object(forKey: "emailVerified") as! Bool
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //https://stackoverflow.com/questions/28144739/uiscrollview-not-scrolling-in-swift
//        scrollView.contentSize = CGSize(width: 1000, height: 2300) it works charm as well
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 1150)
  
        
        if !profileCheck{
            //no profile
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vcP = storyBoard.instantiateViewController(withIdentifier: "register") as! RegisterController
            vcP.modalPresentationStyle = .fullScreen
            self.present(vcP, animated:false, completion:nil)
        }
        
        postCreateView = PostcreateView(frame: CGRect(x:0,y:0, width:view.frame.size.width,height: 1150))
        postCreateView.writerField.delegate = self
        postCreateView.categoryField.delegate = self
        postCreateView.patreonField.delegate = self
        postCreateView.paypalField.delegate = self
        postCreateView.postCreatePicker.delegate = self
        postCreateView.postCreatePicker.dataSource = self
        postCreateView.createPostButton.addTarget(self, action: #selector(postSubmit), for: UIControl.Event.touchUpInside)
        postCreateView.postCreateContent.layer.cornerRadius = 15
        postCreateView.postCreateContent.layer.borderWidth = 0.5
        postCreateView.postCreatePicker.layer.cornerRadius = 15
        postCreateView.postCreatePicker.layer.borderWidth = 0.5
        

//        postCreateView.titleLabel.layer.shadowOpacity=0.3
//        postCreateView.titleLabel.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        contentView.addSubview(postCreateView)
        
        let locationstr = (NSLocale.preferredLanguages[0] as String?)!
        
        if locationstr.contains( "ja")
        {
            postCreateView.titleLabel.text = "投稿タイトル"
            postCreateView.languageLabel.text = "言語"
            postCreateView.bodyLabel.text = "本文"
            postCreateView.categoryLabel.text = "カテゴリ設定"
            postCreateView.writerLabel.text = "投稿者名"
            postCreateView.paypalLabel.text = "paypalアカウント"
            postCreateView.patereonLink.text = "patreonアカウント"
        }else if locationstr.contains( "fr")
        {
            postCreateView.titleLabel.text = "Titre"
            postCreateView.languageLabel.text = "Langue"
            postCreateView.bodyLabel.text = "Corps du texte"
            postCreateView.categoryLabel.text = "Catégorie, janre"
            postCreateView.writerLabel.text = "nom de l'auteur"
            postCreateView.paypalLabel.text = "compte Paypal"
            postCreateView.patereonLink.text = "compte Patreon"
        }else if locationstr.contains( "zh"){
            postCreateView.titleLabel.text = "标题"
            postCreateView.languageLabel.text = "语"
            postCreateView.bodyLabel.text = "文字主体"
            postCreateView.categoryLabel.text = "类别"
            postCreateView.writerLabel.text = "投稿者名"
            postCreateView.paypalLabel.text = "贝宝账户"
            postCreateView.patereonLink.text = "patreon帐户"
        }else if locationstr.contains( "de")
        {
            postCreateView.titleLabel.text = "Titel"
            postCreateView.languageLabel.text = "Sprache"
            postCreateView.bodyLabel.text = "Textkörper"
            postCreateView.categoryLabel.text = "Kategorie"
            postCreateView.writerLabel.text = "Autorenname"
            postCreateView.paypalLabel.text = "Paypal-Konto"
            postCreateView.patereonLink.text = "Patreon-Konto"
            
        }else if locationstr.contains( "it")
        {
            postCreateView.titleLabel.text = "titolo"
            postCreateView.languageLabel.text = "linguaggio"
            postCreateView.bodyLabel.text = "corpo del testo"
            postCreateView.categoryLabel.text = "categoria, janre"
            postCreateView.writerLabel.text = "nome dell'autore"
            postCreateView.paypalLabel.text = "account Paypal"
            postCreateView.patereonLink.text = "conto patreon"
        }else if locationstr.contains( "ru")
        {
            postCreateView.titleLabel.text = "заглавие"
            postCreateView.languageLabel.text = "язык"
            postCreateView.bodyLabel.text = "текстовое тело"
            postCreateView.categoryLabel.text = "категория, жанр"
            postCreateView.writerLabel.text = "автор"
            postCreateView.paypalLabel.text = "счет PayPal"
            postCreateView.patereonLink.text = "аккаунт patreon"
          
        }else if locationstr.contains("ar")
        {
            postCreateView.titleLabel.text = "لقب"
            postCreateView.languageLabel.text = "لغة"
            postCreateView.bodyLabel.text = "نص النص"
            postCreateView.categoryLabel.text = "الفئة جانري"
            postCreateView.writerLabel.text = "مؤلف"
            postCreateView.paypalLabel.text = "حساب paypal"
            postCreateView.patereonLink.text = "حساب patreon"
           
        }else if locationstr.contains("es")
        {
            postCreateView.titleLabel.text = "título"
            postCreateView.languageLabel.text = "idioma"
            postCreateView.bodyLabel.text = "cuerpo del texto"
            postCreateView.categoryLabel.text = "categoría, janre"
            postCreateView.writerLabel.text = "nombre del autor"
            postCreateView.paypalLabel.text = "cuenta de Paypal"
            postCreateView.patereonLink.text = "Cuenta de Patreon"
        }else if locationstr.contains("en")
        {
            postCreateView.titleLabel.text = "post title"
            postCreateView.languageLabel.text = "language"
            postCreateView.bodyLabel.text = "text body"
            postCreateView.categoryLabel.text = "category, janre"
            postCreateView.writerLabel.text = "author name"
            postCreateView.paypalLabel.text = "paypal account"
            postCreateView.patereonLink.text = "patreon account"
        }else{
           
        }
    }
    
    @objc func postSubmit(){
        print("send")
        if (UserDefaults.standard.object(forKey: "emailVerified") != nil ) {
            profileCheck = UserDefaults.standard.object(forKey: "emailVerified") as! Bool
        }

        if profileCheck == true {
            var body = ""
            var title = ""
            var userIdStr = ""
            var author = "anonymous"
            var patreon = "none"
            var category = "general"
            var paypal = "none"
            if (postCreateView.postCreateContent.text != nil){
                body = String(postCreateView.postCreateContent.text)
                if body.count<1{
                    //TODO
                    return
                }
            }else{
                return
            }
            if (postCreateView.postCreateTitle.text != nil) {
                title = String(postCreateView.postCreateTitle.text!)
                if title.count<1{
                    //TODO
                    return
                }
            }else{
                return
            }
            if (postCreateView.categoryField.text != nil){
                let categoryStr = String(postCreateView.categoryField.text!)
                if categoryStr.count > 0{
                    category = categoryStr
                }
            }
            if (UserDefaults.standard.object(forKey: "newuserId") != nil ) {
                userIdStr = UserDefaults.standard.object(forKey: "newuserId") as! String
            }else{
                return
            }
            if (UserDefaults.standard.object(forKey: "author") != nil ) {
                author = UserDefaults.standard.object(forKey: "author") as! String
            }
            if (UserDefaults.standard.object(forKey: "patreon") != nil ) {
                patreon = UserDefaults.standard.object(forKey: "patreon") as! String
            }
            if (UserDefaults.standard.object(forKey: "paypal") != nil ) {
                paypal = UserDefaults.standard.object(forKey: "paypal") as! String
            }
            if (UserDefaults.standard.object(forKey: "newtoken") != nil) {
                    postCreateView.createPostButton.isEnabled = false
                postStore(body: body, lang: postlanguage, title: title, author: author, category: category, patreon: patreon, paypal: paypal, userId: userIdStr)

            }
        }
    }

    
    //TODO icloud import docs
    
    @IBAction func uploadFileAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vcP = storyBoard.instantiateViewController(withIdentifier: "fileUpload") as! FileUploadViewController
        vcP.language = postlanguage
        vcP.postbody = postbody
        vcP.posttitle = posttitle
        vcP.editJson = editJson
        vcP.imageFileName = imageFileName
        vcP.audioFileName = audioFileName
        vcP.modalPresentationStyle = .fullScreen
        self.present(vcP, animated:false, completion:nil)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return languageArry[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        print(languageCode[row])
//        languageLabel.text = "Language of post: " + langArry[row]
        postlanguage = languageCode[row]
        
    }
    
    func postStore(body:String, lang:String, title:String,author:String,category:String,patreon:String,paypal:String,userId:String) {
        let Url = "https://" + HOST_IP + "/posts"
        let parameterDictionary = ["body":body, "language" : lang, "title" :title,"author":author,"category":category,"patreonUrl":patreon,"paypalEmail":paypal,"_userId":userId]
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[])
        request.httpBody = httpBody
        request.httpMethod = "POST"


        session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in

            if let data = data {
                do {
                    
                    
                   
                    DispatchQueue.main.async(execute: {
                        
                        if let httpResponse = response as? HTTPURLResponse {
                            print("status",httpResponse.statusCode)
                            if httpResponse.statusCode == 400{
                                //TODO ERROR MSG MODAL
                                self.postCreateView.createPostButton.isEnabled = true
                                return
                            }
                            if httpResponse.statusCode == 201{
                                //TODO ERROR MSG MODAL
                                let defaults0 = UserDefaults.standard
                                defaults0.set(patreon , forKey: "patreon")
                                defaults0.set(paypal, forKey: "paypal")
                                defaults0.set(author , forKey: "author")
                                defaults0.synchronize()
                                
                                self.successModal(message: "Your post has been uploaded.")
                                self.postCreateView.createPostButton.isEnabled = true
                                return
                            }
                        }
                      
                        
                        
                        self.postCreateView.createPostButton.isEnabled = true
                    })
                }
            }
        }).resume()
    }
    
    func postUpdate(token:String,id:String,audio:String,img:String) {
    }
    
    
    @IBAction func createPostDeletePostAction(_ sender: Any) {
        openMview()
    }
    
    
    @objc func cancelDelete(){
        mview.removeFromSuperview()
    }
    
    @objc func openMview(){
        //don't forget first call
        if mview != nil{
            mview.removeFromSuperview()
        }
        
        mview = modalView(frame: CGRect(x:10,y:30, width: 270,height: 95))
        mview.modalCancelButton.addTarget(self, action: #selector(cancelDelete), for: UIControl.Event.touchUpInside)
        mview.modalLabel.text = "Delete this data?"
        
        mview.layer.cornerRadius = 8
        mview.layer.borderWidth = 1
        mview.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(mview)
        
        
        //http://studyswift.blogspot.jp/2015/01/showhide-keyboard-while-using.html
        //https://stackoverflow.com/questions/46375700/programmatically-create-touchupinside-event-for-uitextfield
        
    }
    
    func saveMyPost(postId:String){
        if (UserDefaults.standard.object(forKey: "newtoken") != nil) {
            let token = UserDefaults.standard.object(forKey: "newtoken") as! String
            bookMarkMyPost(token: token,id: postId)
        }
    }
    
    func bookMarkMyPost(token:String,id:String) {
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
    
}


