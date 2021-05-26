//
//  FileUploadCommentViewController.swift
//  iDraft
//
//  Created by yujin on 2020/11/08.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit
import SwiftyDropbox

class FileUploadCommentViewController:
UIViewController,UIDocumentPickerDelegate,UINavigationControllerDelegate,FileManagerDelegate{
    
    
    var selectedTab = 0
    var postId = ""
    var questionJson = [String : Any]()
    var sentenceArry = [String]()
    var corrected = ""
    var originalArry = [String]()
    var imageFileName = ""
    var audioFileName = ""
    

    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: false)
        
        // Do any additional setup after loading the view.
    }
    
    
    //https://qiita.com/KikurageChan/items/5b33f95cbec9e0d8a05f
    @objc func timerUpdate() {
        
        let source = ["public.text","public.comma-separated-values-text","public.png","public.jpeg","public.mpeg-4","public.mpeg-4-audio","public.mp3","com.adobe.pdf"]
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
        let mydata = try! Data(contentsOf: url)
        let filePathAry = url.absoluteString.components(separatedBy: "/")
        print("fileUrl",filePathAry[filePathAry.count-1])
        if filePathAry.count != 0{
            let fn = filePathAry[filePathAry.count-1]
            if filePathAry[filePathAry.count-1].contains(".mp4"){
                uploadFile(fileData: mydata, filename: "/Audios/" + fn)
                audioFileName = fn
            }else if filePathAry[filePathAry.count-1].contains(".mp3"){
                uploadFile(fileData: mydata, filename: "/Audios/" + fn)
                audioFileName = fn
            }else if filePathAry[filePathAry.count-1].contains(".m4a"){
                uploadFile(fileData: mydata, filename: "/Audios/" + fn)
                audioFileName = fn
            }else{
                uploadFile(fileData: mydata, filename: "/" + fn)
                imageFileName = fn
            }
        }
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vcP = storyBoard.instantiateViewController(withIdentifier: "createcomment") as! CreateCommentController
  
       //Only these one
        vcP.imageFileName = imageFileName
        vcP.audioFileName = audioFileName
      
        //No change
        vcP.selectedTab = selectedTab
        vcP.questionJson = questionJson
        vcP.postId = postId
        vcP.sentenceArry = sentenceArry
        vcP.corrected = corrected
        vcP.originalArry = originalArry
        
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
    
    func uploadFile(fileData:Data,filename:String){
        //        let fileData = "testing data example3".data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        // Reference after programmatic auth flow
        let client = DropboxClientsManager.authorizedClient
        if client == nil {
            authFlowCommence()
        }else{
            
            
            if Int(fileData.count) < 3000000{
                let request2 = client!.files.upload(path: filename, mode:Files.WriteMode.overwrite , autorename: false, mute: false, strictConflict: false, input: fileData)
                    .response { response, error in
                        if let response = response {
                            print(response)
                        } else if let error = error {
                            print(error)
                        }
                }
                .progress { progressData in
                    print(progressData)
                }
            }
            
            
            
            
            
            // in case you want to cancel the request
            //        if someConditionIsSatisfied {
            //            request.cancel()
            //        }
        }
    }
    
    func downloadAction(){
        // Reference after programmatic auth flow
        let client = DropboxClientsManager.authorizedClient
        if client == nil {
            authFlowCommence()
        }else{
            // Download to URL
            let fileManager = FileManager.default
            let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destURL = directoryURL.appendingPathComponent("myTestFile")
            let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                return destURL
            }
            client?.files.download(path: "/test/path/in/Dropbox/account", overwrite: true, destination: destination)
                .response { response, error in
                    if let response = response {
                        print(response)
                    } else if let error = error {
                        print(error)
                    }
            }
            .progress { progressData in
                print(progressData)
            }
            
            
            // Download to Data
            client?.files.download(path: "/test/path/in/Dropbox/account")
                .response { response, error in
                    if let response = response {
                        let responseMetadata = response.0
                        print(responseMetadata)
                        let fileContents = response.1
                        print(fileContents)
                    } else if let error = error {
                        print(error)
                    }
            }
            .progress { progressData in
                print(progressData)
            }
        }
    }
    
}


