//
//  LoginController.swift
//  iDraft
//
//  Created by yujin on 2020/07/14.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loadingGear: UIActivityIndicatorView!
    @IBOutlet weak var loginasguestButton: UIButton!
    var yourLabel: UILabel = UILabel()
    let defaultLabel = UILabel()
    var incorrectMessage: String?
    var unverifiedMessage: String?
    var dialogString = ""
    var cview :commentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        loginButton.layer.cornerRadius = 15
        loginasguestButton.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
        
        if dialogString.count > 0{
            //openDialog(dialog: dialogString) email notification cancelled
        }
        
        if (UserDefaults.standard.object(forKey: "email") != nil) {
            emailField.text = (UserDefaults.standard.object(forKey: "email") as! String)
        }
        
        
        
        if (UserDefaults.standard.object(forKey: "password") != nil) {
            passwordField.text = (UserDefaults.standard.object(forKey: "password") as! String)
        }
        
        
        defaultLabel.frame = CGRect(x: (view.frame.size.width*0.1)/2, y: view.frame.size.height - 210, width: view.frame.size.width*0.9, height: 200)
        
        
        defaultLabel.layer.shadowOpacity=0.3
        defaultLabel.layer.cornerRadius = 15
        defaultLabel.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        defaultLabel.layer.borderWidth = 1.0
        defaultLabel.layer.borderColor = UIColor.red.cgColor //UIColor.systemPink.withAlphaComponent(0.7)
        defaultLabel.textColor = UIColor.black
        defaultLabel.textAlignment = NSTextAlignment.center
        defaultLabel.numberOfLines = 0
        
        
        
        let locationstr = (NSLocale.preferredLanguages[0] as String?)!
        
        if locationstr.contains( "ja")
        {
            defaultLabel.text = "あと数ステップ！ \n 1.確認リンク付きのメールがあなたのメールアドレスに送信されました。リンクを押して登録を完了します。 \n2.その後、このログインビューに戻り、[ログイン]ボタンを押してログインします。"
            
            incorrectMessage = "メールアドレスまたはパスワードが正しくありません。"
            unverifiedMessage = "メールの確認はまだ完了していません。メールボックスで確認メールを確認してください。"
            loginButton.setTitle("ログイン", for: .normal)
            loginasguestButton.setTitle("ゲスト", for: .normal)
        }else if locationstr.contains( "fr")
        {
            defaultLabel.text = "Encore quelques étapes! \n 1. L'e-mail avec un lien de vérification vient d'être envoyé à votre adresse e-mail. Appuyez sur le lien pour terminer l'enregistrement. \n 2. Après cela, revenez à cette vue de connexion, appuyez sur le bouton Connexion pour vous connecter."
            incorrectMessage = "L'e-mail ou le mot de passe est incorrect."
            unverifiedMessage = "La vérification de l'e-mail n'est pas encore terminée. Veuillez vérifier un e-mail de vérification dans votre boîte e-mail."
            loginButton.setTitle("connexion", for: .normal)
            loginasguestButton.setTitle("Utilisateur invité", for: .normal)
        }else if locationstr.contains( "zh"){
            defaultLabel.text = "再走几步！ \n 1.带有验证链接的邮件刚刚发送到您的电子邮件地址。按链接完成注册。 \n 2.之后，返回此登录视图，按“登录”按钮登录。"
            incorrectMessage = "电子邮件或密码不正确。"
            unverifiedMessage = "电子邮件验证尚未完成。请在您的电子邮件框中检查验证邮件。"
            loginButton.setTitle("登录", for: .normal)
            loginasguestButton.setTitle("来宾用户", for: .normal)
        }else if locationstr.contains( "de")
        {
            defaultLabel.text = "Nur noch ein paar Schritte! \n 1. Die E-Mail mit einem Bestätigungslink wurde gerade an Ihre E-Mail-Adresse gesendet. Klicken Sie auf den Link, um die Registrierung abzuschließen. \n 2. Danach kehren Sie zu dieser Anmeldeansicht zurück und klicken auf die Schaltfläche Anmelden, um sich anzumelden."
            incorrectMessage = "Die E-Mail oder das Passwort ist falsch."
            unverifiedMessage = "Die E-Mail-Überprüfung ist noch nicht abgeschlossen. Bitte überprüfen Sie eine Bestätigungsmail in Ihrem E-Mail-Feld."
            loginButton.setTitle("login", for: .normal)
            loginasguestButton.setTitle("Gastbenutzer", for: .normal)
        }else if locationstr.contains( "it")
        {
            defaultLabel.text = "Ancora pochi passaggi! \n 1. La mail con un link di verifica è stata appena inviata al tuo indirizzo email. Fare clic sul collegamento per completare la registrazione. \n 2. Dopodiché, torna a questa vista di accesso, premi il pulsante Accedi per accedere."
            incorrectMessage = "L'e-mail o la password non sono corrette."
            unverifiedMessage = "La verifica dell'email è ancora incompleta. Controlla un'e-mail di verifica nella tua casella di posta elettronica."
            loginButton.setTitle("accedere", for: .normal)
            loginasguestButton.setTitle("Utente ospite", for: .normal)
        }else if locationstr.contains( "ru")
        {
            defaultLabel.text = "Еще несколько шагов! \n 1. Письмо со ссылкой для подтверждения только что было отправлено на ваш адрес электронной почты. Нажмите ссылку, чтобы завершить регистрацию. \n 2. После этого вернитесь к просмотру входа в систему, нажмите кнопку «Вход» для входа."
            incorrectMessage = "Электронная почта или пароль неверны."
            unverifiedMessage = "Проверка электронной почты еще не завершена. Пожалуйста, проверьте письмо с подтверждением в своем электронном ящике."
            loginButton.setTitle("авторизоваться", for: .normal)
            loginasguestButton.setTitle("Гость", for: .normal)
        }else if locationstr.contains("ar")
        {
            defaultLabel.text = "فقط بضع خطوات أخرى! \n 1. تم إرسال البريد الذي يحتوي على رابط التحقق إلى عنوان بريدك الإلكتروني. اضغط على الرابط لإكمال التسجيل. \n 2. بعد ذلك للعودة إلى عرض تسجيل الدخول هذا ، اضغط على زر تسجيل الدخول لتسجيل الدخول."
            incorrectMessage = "البريد الإلكتروني أو كلمة المرور غير صحيحة."
            unverifiedMessage = "التحقق من البريد الإلكتروني لم يكتمل بعد. يرجى التحقق من بريد التحقق في صندوق البريد الإلكتروني الخاص بك."
            loginButton.setTitle("تسجيل الدخول", for: .normal)
            loginasguestButton.setTitle("حساب زائر", for: .normal)
        }else if locationstr.contains("es")
        {
            defaultLabel.text = "¡Solo unos pocos pasos más! \n 1. El correo con un enlace de verificación acaba de ser enviado a su dirección de correo electrónico. Presione el enlace para completar el registro. \n 2. Después de volver a esta vista de inicio de sesión, presione el botón Iniciar sesión para iniciar sesión."
            incorrectMessage = "El correo electrónico o la contraseña son incorrectos."
            unverifiedMessage = "La verificación por correo electrónico aún no ha finalizado. Compruebe un correo de verificación en su casilla de correo electrónico."
            loginButton.setTitle("acceso", for: .normal)
            loginasguestButton.setTitle("Usuario invitada", for: .normal)
        }else if locationstr.contains("en")
        {
            defaultLabel.text = "Just few more steps! \n 1. The mail with a verification link just has been sent to your email address. Press the link to complete registration. \n 2. After that back to this login view, press the Login button to login."
            incorrectMessage = "The email or password is incorrect."
            unverifiedMessage = "Email verification is unfinished yet. Please check a verification mail in your email box."
            loginButton.setTitle("Login", for: .normal)
            loginasguestButton.setTitle("Guest user", for: .normal)
        }else{
            defaultLabel.text = "Just few more steps! \n 1. The mail with a verification link just has been sent to your email address. Press the link to complete registration. \n 2. After that back to this login view, press the Login button to login."
            incorrectMessage = "The email or password is incorrect."
            unverifiedMessage = "Email verification is unfinished yet. Please check a verification mail in your email box."
            loginButton.setTitle("Login", for: .normal)
            loginasguestButton.setTitle("Guest user", for: .normal)
        }
       
        
        
        view.addSubview(defaultLabel)
        loadingGear.isHidden = true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func loginAction(_ sender: Any) {
        loadingGear.isHidden = false
        loginButton.isEnabled = false
        loginRequest(email: emailField.text!, password: passwordField.text!)
    }
    
    @IBAction func loginAsGuestAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "question") as! PostIndexController
        
        resultViewController.activeTab = 3
        resultViewController.modalPresentationStyle = .fullScreen
        self.present(resultViewController, animated:false, completion:nil)
    }
    
    func openDialog(dialog:String) {
    if cview != nil{
            cview.removeFromSuperview()
        }

        cview = commentView(frame: CGRect(x:10,y:200, width: 270,height: 180))
     
        cview.commentOkButton.addTarget(self, action: #selector(closeCommentView), for: UIControl.Event.touchUpInside)
        

        cview.commentTextView.delegate = self
        cview.commentTextView.layer.borderWidth = 1
        cview.commentTextView.layer.borderColor = UIColor.darkGray.cgColor
        cview.commentTextView.tag = -1
        cview.layer.borderWidth = 1
        cview.layer.cornerRadius = 8;

        cview.commentTextView.text = dialog
        cview.commentTextView.textColor = UIColor.black
        
        let locationstr = (NSLocale.preferredLanguages[0] as String?)!
        if locationstr.contains("ja"){
            cview.commentOkButton.setTitle("完了", for: .normal)
        }else if locationstr.contains("fr"){
            cview.commentOkButton.setTitle("supprimer", for: .normal)
        }else if locationstr.contains("zh"){
            cview.commentOkButton.setTitle("删除", for: .normal)
        }else if locationstr.contains("de"){
            cview.commentOkButton.setTitle("OK", for: .normal)
        }else if locationstr.contains("it"){
            cview.commentOkButton.setTitle("Cancellare", for: .normal)
        }else if locationstr.contains("ru"){
            cview.commentOkButton.setTitle("удалить", for: .normal)
        }else if locationstr.contains("es"){
            cview.commentOkButton.setTitle("borrar", for: .normal)
        }else if locationstr == "sv"{
            cview.commentOkButton.setTitle("radera", for: .normal)
        }else{
           cview.commentOkButton.setTitle("OK", for: .normal)
        }
        self.view.addSubview(cview)
        
        
        //http://studyswift.blogspot.jp/2015/01/showhide-keyboard-while-using.html
        //https://stackoverflow.com/questions/46375700/programmatically-create-touchupinside-event-for-uitextfield

    }
    
    @objc func closeCommentView(){
        print("close")
        cview.resignFirstResponder()
        cview.removeFromSuperview()
    }
    
    func loginRequest(email:String,password:String) {
        let bc = BaseController()
        let Url = String(format: "https://" + bc.HOST_IP + "/login")
              let serviceUrl = URL(string: Url)
              let parameterDictionary = ["email" : email, "password" : password]
                var request = URLRequest(url: serviceUrl!)
              request.httpMethod = "POST"
              request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
              request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
              let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: [])
              request.httpBody = httpBody
        
         bc.session.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
                
            if let e = error{
                DispatchQueue.main.async(execute: {
                print("error",e)
                self.networkErrorMessage()
                self.loadingGear.isHidden = true
                self.loginButton.isEnabled = true
                })
            }
                
                  if let data = data {
                      do {
                        let httpcode = response as? HTTPURLResponse
                        print("statuscode",httpcode!.statusCode)
                       
                        
                            if httpcode!.statusCode == 400{
                                DispatchQueue.main.async(execute: {
                                //TODO ERROR MSG MODAL unverified
                                self.unfinishedVerificationMessage()
                                self.loadingGear.isHidden = true
                                self.loginButton.isEnabled = true
                                return
                                })
                            }
                            else if httpcode!.statusCode == 401{
                                DispatchQueue.main.async(execute: {
                                //TODO ERROR MSG MODAL email or password or both of them is incorrect
                                self.incorrectEmailPassMessage()
                                self.loadingGear.isHidden = true
                                self.loginButton.isEnabled = true
                                return
                                })
                            }
                            
                            else if httpcode!.statusCode == 200{
                                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                print("json",json as Any)
                                DispatchQueue.main.async(execute: {
                                if json!["token"] == nil {return}
                                let token = json!["token"] as! String
                                let userId = json!["userId"] as! String
                                let defaults0 = UserDefaults.standard
                                defaults0.set(token , forKey: "newtoken")
                                defaults0.set(true , forKey: "emailVerified")
                                defaults0.set(userId , forKey: "newuserId")
                                defaults0.synchronize()
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "postcreate") as! PostCreateController
                                resultViewController.activeTab = 1
                                resultViewController.modalPresentationStyle = .fullScreen
                                self.present(resultViewController, animated:false, completion:nil)
                                return
                                })
                            }
                            else{
                        
                        DispatchQueue.main.async(execute: {
                        self.unknownErrorMessage()
                        self.loadingGear.isHidden = true
                        self.loginButton.isEnabled = true
                        return
                        })
                            }
                        
                           
                        
                      } catch {
                        DispatchQueue.main.async(execute: {
                        print("error",error)
                        self.unknownErrorMessage()
                        self.loadingGear.isHidden = true
                        self.loginButton.isEnabled = true
                        })
                      }
                  }
         }).resume()
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
    
    func incorrectEmailPassMessage(){
        errorModal(message: incorrectMessage!)
    }
    
    func unfinishedVerificationMessage(){
        errorModal(message: unverifiedMessage!)
    }
    
    func unknownErrorMessage(){
        errorModal(message: "Error something went wrong.")
    }
    
    func networkErrorMessage(){
        errorModal(message: "Network Connection Error")
    }
}
