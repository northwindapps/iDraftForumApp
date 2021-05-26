//
//  BaseController.swift
//  iDraft
//
//  Created by yujin on 2020/07/12.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit

class BaseController: UIViewController ,UITabBarDelegate{

    //https://apple.stackexchange.com/questions/20547/how-do-i-find-my-ip-address-from-the-command-line
    //ipconfig getifaddr en0
    //curl ifconfig.me 
    let HOST_IP = "www.idraft.app" //"192.168.100.105:3000"
    
    var selectedTab = 0
    let session = URLSession.shared //URLSession(configuration: .default)
    let errorLabel: UILabel = UILabel()
    let successLabel: UILabel = UILabel()
    @IBOutlet weak var tabBar: UITabBar!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tabBar.delegate = self
        tabBar.items![0].title = "Posting History"
        tabBar.items![1].title = "Write"
        tabBar.items![2].title = "Post"
        tabBar.items![3].title = "Profile"
        
        self.hideKeyboardWhenTappedAround()
        
        
        
    }
    

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
           print(item.tag)
           let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
           switch item.tag {
           case 0:
               let vcP = storyBoard.instantiateViewController(withIdentifier: "user") as! UserController
               vcP.activeTab = 0
               vcP.modalPresentationStyle = .fullScreen
               self.present(vcP, animated:false, completion:nil)
           case 1:
               let vcP = storyBoard.instantiateViewController(withIdentifier: "postcreate") as! PostCreateController
               vcP.activeTab = 1
               vcP.modalPresentationStyle = .fullScreen
               self.present(vcP, animated:false, completion:nil)
           case 2:
               let vcP = storyBoard.instantiateViewController(withIdentifier: "question") as! PostIndexController
               vcP.activeTab = 2
               vcP.modalPresentationStyle = .fullScreen
               self.present(vcP, animated:false, completion:nil)
           case 3:
               let vcP = storyBoard.instantiateViewController(withIdentifier: "createprofile") as! CreateProfileController
               vcP.activeTab = 3
               vcP.modalPresentationStyle = .fullScreen
               self.present(vcP, animated:false, completion:nil)
           default:
               break
           }
           
          
       }
    
    
    func questions(token:String) ->(NSArray,String) {
        var arrayJson = NSArray()
        let Url = String(format: "https://" + HOST_IP + "/api/auth/post")
              guard let serviceUrl = URL(string: Url) else { return (arrayJson,"") }
              var request = URLRequest(url: serviceUrl)
        _ = ""
        let error = ""
              request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
              request.setValue("Bearer " + token, forHTTPHeaderField:  "Authorization" )
              let sem = DispatchSemaphore(value: 0)
              let session = URLSession.shared
              session.dataTask(with: request) { (data, response, error) in
                  defer { sem.signal() }
                
                  if let response = response {
                      print(response)
                  }
                  if let data = data {
                      do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                        arrayJson = json["data"] as! NSArray
                      } catch {
                        print(error)
 
                      }
                  }
                  }.resume()
        
        sem.wait()
        
        return (arrayJson,error)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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

}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIColor {
    static var random: UIColor {
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
}

extension UITextView {
    func adjustUITextViewHeight() {
        self.isScrollEnabled = false
    }
}

// Put this piece of code anywhere you like
//https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//
extension UILabel
{
var optimalHeight : CGFloat
    {
        get
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = self.lineBreakMode
            label.font = self.font
            label.text = self.text

            label.sizeToFit()

            return label.frame.height
         }
    }
}
