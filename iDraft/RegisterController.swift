//
//  RegisterController.swift
//  iDraft
//
//  Created by yujin on 2020/07/13.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var circleButton: UIButton!
    
    @IBOutlet weak var privacyPolicyButton: UILabel!
    @IBOutlet weak var moveLoginView: UIButton!
    var clicked = false
    let yourLabel: UILabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = 15
        moveLoginView.layer.cornerRadius = 15
        hideKeyboardWhenTappedAround()
        
        let locationstr = (NSLocale.preferredLanguages[0] as String?)!
        if locationstr.contains("ja"){
            registerButton.setTitle("登録", for: .normal)
            moveLoginView.setTitle("ログイン", for: .normal)
            emailField.placeholder = "eメール"
            passwordField.placeholder = "パスワード"
        }else if locationstr.contains("fr"){
            registerButton.setTitle("s'inscrire", for: .normal)
            moveLoginView.setTitle("connexion", for: .normal)
            emailField.placeholder = "E-mail"
            passwordField.placeholder = "Mot de passe"
        }else if locationstr.contains("zh"){
            registerButton.setTitle("登记", for: .normal)
            moveLoginView.setTitle("登录", for: .normal)
            emailField.placeholder = "电子邮件"
            passwordField.placeholder = "密码"
        }else if locationstr.contains("de"){
            registerButton.setTitle("registrieren", for: .normal)
            moveLoginView.setTitle("anmeldung", for: .normal)
            emailField.placeholder = "E-Mail"
            passwordField.placeholder = "Passwort"
        }else if locationstr.contains("it"){
            registerButton.setTitle("registrati", for: .normal)
            moveLoginView.setTitle("accedere", for: .normal)
            emailField.placeholder = "E-mail"
            passwordField.placeholder = "Parola d'ordine"
        }else if locationstr.contains("ru"){
            registerButton.setTitle("регистр", for: .normal)
            moveLoginView.setTitle("авторизоваться", for: .normal)
            emailField.placeholder = "Электронное письмо"
            passwordField.placeholder = "Пароль"
        }else if locationstr.contains("es"){
            registerButton.setTitle("registrarse", for: .normal)
            moveLoginView.setTitle("acceso", for: .normal)
            emailField.placeholder = "Correo electrónico"
            passwordField.placeholder = "Contraseña"
        }else if locationstr == "ar"{
            registerButton.setTitle("تسجيل", for: .normal)
            moveLoginView.setTitle("تسجيل الدخول", for: .normal)
            emailField.placeholder = "بريد إلكتروني"
            passwordField.placeholder = "كلمه السر"
        }else{
            registerButton.setTitle("Register", for: .normal)
            moveLoginView.setTitle("Login", for: .normal)
            
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
    @IBAction func goLogin(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! LoginController
        self.present(resultViewController, animated:false, completion:nil)
    }
    
    
    
    @IBAction func registerAction(_ sender: Any) {
        var passStr = String(passwordField.text!)
        var emailStr = String(emailField.text!)
        passStr = passStr.replacingOccurrences(of: " ", with: "")
        emailStr = emailStr.replacingOccurrences(of: " ", with: "")
        if clicked == true{
            registerButton.isEnabled = false
            moveLoginView.isEnabled = false
            register(e:emailStr , p: passStr)
        }
        
    }
    

    //add comment
    func register(e:String,p:String) {
        yourLabel.removeFromSuperview()
        let bc = BaseController()
        let Url = "https://" + bc.HOST_IP + "/register"
        let parameterDictionary = ["email" : e, "password": p]
        print(parameterDictionary)
        let serviceUrl = URL(string: Url)
        var request = URLRequest(url: serviceUrl!)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[])
        request.httpBody = httpBody
        request.httpMethod = "POST"
        
        
        bc.session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
            
            if let e = error{
                DispatchQueue.main.async(execute: {
                print("error",e)
                self.networkErrorMessage()
                self.registerButton.isEnabled = true
                self.moveLoginView.isEnabled = true
                })
            }
            
            if let data = data {
                do {
                    
                    let httpcode = response as? HTTPURLResponse
                    print("statuscode",httpcode!.statusCode)
                    DispatchQueue.main.async(execute: {
                        if let httpResponse = response as? HTTPURLResponse {
                            
                            if httpResponse.statusCode == 400{
                                //TODO ERROR MSG MODAL
                                self.registerButton.isEnabled = true
                                self.moveLoginView.isEnabled = true
                                self.errorModal(message: "Duplicate. Invalid Email address")
                                return
                            }
                            
                            if httpResponse.statusCode == 201{
                                let defaults0 = UserDefaults.standard
                                defaults0.set(e, forKey: "email")
                                defaults0.synchronize()
                                
                                let defaults1 = UserDefaults.standard
                                defaults1.set(p, forKey: "password")
                                defaults1.synchronize()
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                
                                
                                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! LoginController
                                //                                 resultViewController.dialogString = "Invitation email has been sent to your email account. Click an link in the mail to login app."
                                resultViewController.modalPresentationStyle = .fullScreen
                                self.present(resultViewController, animated:false, completion:nil)
                            }
                            else{
                        
                                DispatchQueue.main.async(execute: {
                                    self.networkErrorMessage()
                                    self.registerButton.isEnabled = true
                                    self.moveLoginView.isEnabled = true
                                    return
                                })
                            }
                        }
                    })
                }
            }
        }).resume()
    }
    @IBAction func privacyLinkAction(_ sender: Any) {
        if let appURL = URL(string: "https://startnewlanguagetoday.net/service") {
            UIApplication.shared.open(appURL) { success in
                if success {
                    print("The URL was delivered successfully.")
                } else {
                    print("The URL failed to open.")
                }
            }
        } else {
            print("Invalid URL specified.")
        }
    }
    
    
    @IBAction func circleButtonAction(_ sender: Any) {
        
        switch clicked {
        case false:
            let img = UIImage.init(named: "circleBoxFilled")
            circleButton.setImage(img, for: .normal)
            clicked = true
            break
        case true:
            let img = UIImage.init(named: "circleBox")
            circleButton.setImage(img, for: .normal)
            clicked = false
            break
            
        default:
            clicked = false
            break
        }
    }
    
    func errorModal(message:String){
        yourLabel.frame = CGRect(x: (view.frame.size.width*0.2)/2, y: view.frame.size.height - 80, width: view.frame.size.width*0.8, height: 70)
        yourLabel.layer.shadowOpacity=0.3
        yourLabel.layer.cornerRadius = 25
        yourLabel.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        yourLabel.layer.backgroundColor = UIColor.red.withAlphaComponent(0.7).cgColor
        yourLabel.textColor = UIColor.white
        yourLabel.textAlignment = NSTextAlignment.center
        yourLabel.numberOfLines = 0
        yourLabel.text = message
        self.view.addSubview(yourLabel)
    }
    
    func networkErrorMessage(){
        errorModal(message: "Network Connection Error")
    }
    
    func unknownErrorMessage(){
        errorModal(message: "Error something went wrong.")
    }
}
