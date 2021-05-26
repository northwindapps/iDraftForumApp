//
//  ViewController4.swift
//  dictionary
//
//  Created by 矢野悠人 on 2017/06/22.
//  Copyright © 2017年 yumiya. All rights reserved.
//

import UIKit

class iCloudViewController: UIViewController,UIDocumentPickerDelegate,UINavigationControllerDelegate,FileManagerDelegate{
    
//    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
//        documentPicker.delegate = self
//        present(documentPicker, animated: true, completion: nil)
//    }
    
    
    var posttitle = ""
    var language = ""
    var postbody = ""
    var editJson = [String:Any]()
   
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
       
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: false)
        
        // Do any additional setup after loading the view.
    }
    
    
    //https://qiita.com/KikurageChan/items/5b33f95cbec9e0d8a05f
    @objc func timerUpdate() {
        print("update")
        
        let source = ["public.text"]//["public.comma-separated-values-text"]
        let documentPicker = UIDocumentPickerViewController(documentTypes: source, in: UIDocumentPickerMode.import)//Import
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        //csvPath = url.absoluteString
        //http://stackoverflow.com/questions/28641325/using-uidocumentpickerviewcontroller-to-import-text-in-swift
        //http://qiita.com/nwatabou/items/898bc4395adbb2e05f8d
        //http://stackoverflow.com/questions/32263893/cast-nsstringcontentsofurl-to-string
        //http://qiita.com/nwatabou/items/898bc4395adbb2e05f8d
        //http://miyano-harikyu.jp/sola/devlog/2013/11/22/post-113/
        //https://developer.apple.com/reference/foundation/nsfilemanager
        //
        
        var content = ""
        
        //
        if url.absoluteString.contains(".rtf"){

            //let str = try String(contentsOf: url,encoding: String.Encoding.utf8)
            let mydata = try! Data(contentsOf: url)
            let attributeString = try! NSAttributedString(data: mydata, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
            print(attributeString.string)
            
            content = attributeString.string
        
        }else if url.absoluteString.contains(".txt"){
            //let str = try String(contentsOf: url,encoding: String.Encoding.utf8)
            let mydata = try! Data(contentsOf: url)
            let str = swiftDataToString(someData: mydata)
            content = str!
        }else if url.absoluteString.contains(".text"){
            //let str = try String(contentsOf: url,encoding: String.Encoding.utf8)
            let mydata = try! Data(contentsOf: url)
            let str = swiftDataToString(someData: mydata)
            content = str!
        }
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vcP = storyBoard.instantiateViewController(withIdentifier: "postcreate") as! PostCreateController
        vcP.postbody = content
        vcP.postlanguage = language
        vcP.posttitle = posttitle
        vcP.editJson = editJson
        if editJson["body"] != nil{
            vcP.iCloudBody = content
        }else{
            vcP.iCloudBody = ""
        }
        vcP.activeTab = 2
        
        vcP.modalPresentationStyle = .fullScreen
        self.present(vcP, animated:false, completion:nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //https://stackoverflow.com/questions/44160111/what-is-the-equivalent-of-string-encoding-utf8-rawvalue-in-objective-c
    func swiftDataToString(someData:Data) -> String? {
        return String(data: someData, encoding: .utf8)
    }
    
    func swiftStringToData(someStr:String) ->Data? {
        return someStr.data(using: .utf8)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
 
}


