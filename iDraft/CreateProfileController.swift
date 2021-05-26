//
//  CreateProfileController.swift
//  iDraft
//
//  Created by yujin on 2020/07/19.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit

class CreateProfileController: BaseController, UITextViewDelegate, UITextFieldDelegate{
    
    var mview :modalView!
    var activeTab = 0
//    var nativeLanguage = "English"
    var editJson = [String:Any]()
    
    @IBOutlet weak var loadingGear: UIActivityIndicatorView!
    @IBOutlet weak var createProfileLabel: UILabel!
    @IBOutlet weak var createProfileBody: UITextView!
    @IBOutlet weak var createProfileButton: UIButton!
    @IBOutlet weak var resignButton: UIButton!
    
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        tabBar.selectedItem = tabBar.items![activeTab]
        createProfileBody.delegate = self
 
        
        createProfileBody.layer.borderWidth = 1
        createProfileBody.layer.cornerRadius = 8
        createProfileBody.layer.borderColor = UIColor.lightGray.cgColor
        
        createProfileButton.layer.borderWidth = 1
        createProfileButton.layer.cornerRadius = 8
        createProfileButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        resignButton.layer.borderWidth = 1
        resignButton.layer.cornerRadius = 8
        resignButton.layer.borderColor = UIColor.systemRed.cgColor
    
        if (UserDefaults.standard.object(forKey: "usersProfile") != nil) {
            let profileBody = UserDefaults.standard.object(forKey: "usersProfile") as! String
            createProfileBody.text = profileBody
        }
        loadingGear.isHidden = true
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
            resignButton.setTitle("アカウント削除", for: .normal)
            createProfileButton.setTitle("更新", for: .normal)
            createProfileLabel.text = "あなたのことについて書いてください(任意)"
        }else if locationstr.contains( "fr")
        {
            resignButton.setTitle("Supprimer le compte", for: .normal)
            createProfileButton.setTitle("mettre à jour", for: .normal)
            createProfileLabel.text = "Écrivez sur vous (facultatif)"
        }else if locationstr.contains( "zh"){
            resignButton.setTitle("删除帐户", for: .normal)
            createProfileButton.setTitle("更新", for: .normal)
            createProfileLabel.text = "写关于你自己的信息（可选）"
        }else if locationstr.contains( "de")
        {
            resignButton.setTitle("Konto löschen", for: .normal)
            createProfileButton.setTitle("Aktualisieren", for: .normal)
            createProfileLabel.text = "Schreibe hier über dich selbst."
            
        }else if locationstr.contains( "it")
        {
            resignButton.setTitle("Eliminare l'account", for: .normal)
            createProfileButton.setTitle("Aggiornare", for: .normal)
            createProfileLabel.text = "Scrivi qui di te."
        }else if locationstr.contains( "ru")
        {
            resignButton.setTitle("Удалить аккаунт", for: .normal)
            createProfileButton.setTitle("Обновлять", for: .normal)
            createProfileLabel.text = "Напишите здесь о себе (по желанию)."
          
        }else if locationstr.contains("ar")
        {
            resignButton.setTitle("حذف الحساب", for: .normal)
            createProfileButton.setTitle("تحديث", for: .normal)
            createProfileLabel.text = "الكتابة عن نفسك هنا."
           
        }else if locationstr.contains("es")
        {
            resignButton.setTitle("Borrar cuenta", for: .normal)
            createProfileButton.setTitle("Actualizar", for: .normal)
            createProfileLabel.text = "Escribe sobre ti aqui."
        }else if locationstr.contains("en")
        {
            resignButton.setTitle("Delete account", for: .normal)
            createProfileButton.setTitle("Update", for: .normal)
            createProfileLabel.text = "Write about yourself here(optional)."
        }else{
           
        }
    }
    
    @objc func timerUpdate() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! LoginController
        self.present(resultViewController, animated:false, completion:nil)
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func ProfileRegisterAction(_ sender: Any) {
        if createProfileBody.text.count > 0{
            if (UserDefaults.standard.object(forKey: "newuserId") != nil) {
                let userid = UserDefaults.standard.object(forKey: "newuserId") as! String
                let body = String(createProfileBody.text)
                loadingGear.isHidden = false
                profileUpdate(profile: body, id: userid)
            }
        }
    }
    
   
    @IBAction func logOutAction(_ sender: Any) {
        let defaults0 = UserDefaults.standard
        defaults0.set(false , forKey: "emailVerified")
        defaults0.synchronize()
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let vcP = storyBoard.instantiateViewController(withIdentifier: "register") as! RegisterController
//        vcP.modalPresentationStyle = .fullScreen
//        self.present(vcP, animated:false, completion:nil)
        
    }
    
    @IBAction func resignAction(_ sender: Any) {
        openMview()
    }
    
    
    func logout(token:String) {
               let Url = "https://" + HOST_IP + "/api/auth/logout"
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
                                    print(json as Any)
                                })

                             } catch {
                               print(error)
        
                             }
                         }
                         }).resume()
           }
    
    
   
    
    func profileUpdate(profile:String,id:String) {
        let Url = "https://" + HOST_IP + "/users/" + id
             let parameterDictionary = ["profile":profile]
            let serviceUrl = URL(string: Url)
            var request = URLRequest(url: serviceUrl!)
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
            let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[])
            request.httpBody = httpBody
            request.httpMethod = "PUT"
        print(serviceUrl as Any)
        print(parameterDictionary)
                
           
            session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
                     if let data = data {
                         do {
                            DispatchQueue.main.async(execute: {
                                if let httpResponse = response as? HTTPURLResponse {
                                    if httpResponse.statusCode == 400{
                                        self.errorModal(message: "Error 400")
                                        self.loadingGear.isHidden = true
                                        return
                                    }
                                    if httpResponse.statusCode == 404{
                                        self.errorModal(message: "Error 404")
                                        self.loadingGear.isHidden = true
                                        return
                                    }
                                    if httpResponse.statusCode == 200{
                                        let defaults0 = UserDefaults.standard
                                        defaults0.set(profile , forKey: "usersProfile")
                                        defaults0.synchronize()
                                        self.successModal(message: "Update Success")
                                        self.loadingGear.isHidden = true
                                        return
                                    }
                                }
                            })

                         }
                     }
                     }).resume()
    }
    func postDelete(id:String) {
        let Url = "https://" + HOST_IP + "/posts/userid/" + id
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
                             
                                self.errorModal(message: "Error 400")
                                return
                            }
                            if httpResponse.statusCode == 404{
                             
                                self.errorModal(message: "Error 404")
                                return
                            }
                            if httpResponse.statusCode == 204{
                         
                                self.successModal(message: "Delete Success")
                                self.commentsDelete(id:id)
                                return
                            }
                        }
                        self.loadingGear.isHidden = true
                    })
                }
            }
        }).resume()
    }
    func commentsDelete(id:String) {
        let Url = "https://" + HOST_IP + "/comments/postuserid/" + id
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
                           
                                self.errorModal(message: "Error 404")
                                return
                            }
                            if httpResponse.statusCode == 204{
                              
                                self.successModal(message: "Delete Success")
                                self.userDelete(id:id)
                                return
                            }
                        }
                        self.loadingGear.isHidden = true
                    })
                }
            }
        }).resume()
    }
    func userDelete(id:String) {
        let Url = "https://" + HOST_IP + "/users/" + id
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
                                self.successModal(message: "Account Shutdown")
                                return
                            }
                        }
                        self.loadingGear.isHidden = true
                    })
                }
            }
        }).resume()
    }
    @objc func cancelDelete(){
           mview.removeFromSuperview()
    }
    
    @objc func quitService(){
       if mview != nil{
           mview.removeFromSuperview()
       }
       //SHUT DOWN though user account remains
        if (UserDefaults.standard.object(forKey: "newuserId") != nil) {
            let userid = UserDefaults.standard.object(forKey: "newuserId") as! String
            postDelete(id:userid)
        }
        self.loadingGear.isHidden = false
        let defaults = UserDefaults.standard
        let dict = defaults.dictionaryRepresentation()
        dict.keys.forEach{key in defaults.removeObject(forKey: key)}
    }
       
       @objc func openMview(){
           //don't forget first call
           if mview != nil{
               mview.removeFromSuperview()
           }
           
           mview = modalView(frame: CGRect(x:(view.frame.size.width - 270 ) / 2,y:30, width: 270,height: 95))
           mview.modalOkButton.addTarget(self, action: #selector(quitService), for: UIControl.Event.touchUpInside)
           mview.modalCancelButton.addTarget(self, action: #selector(cancelDelete), for: UIControl.Event.touchUpInside)
           mview.modalLabel.text = "Quit this app?"
           
           mview.layer.cornerRadius = 8
           mview.layer.borderWidth = 1
           mview.layer.borderColor = UIColor.gray.cgColor
           self.view.addSubview(mview)
           
           
           //http://studyswift.blogspot.jp/2015/01/showhide-keyboard-while-using.html
           //https://stackoverflow.com/questions/46375700/programmatically-create-touchupinside-event-for-uitextfield

       }
       
       
}

