//
//  AppDelegate.swift
//  iDraft
//
//  Created by yujin on 2020/07/12.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var token = ""
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DropboxClientsManager.setupWithAppKey("znqnlgllf29f2fr")

        
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let initialViewController = storyBoard.instantiateViewController(withIdentifier: "question") as! PostIndexController
                initialViewController.activeTab = 2
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
        

//        }else{
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let initialViewController = storyBoard.instantiateViewController(withIdentifier: "register")
//            self.window?.rootViewController = initialViewController
//            self.window?.makeKeyAndVisible()
//        }
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let oauthCompletion: DropboxOAuthCompletion = {
          if let authResult = $0 {
              switch authResult {
              case .success:
                  print("Success! User is logged into DropboxClientsManager.")
              case .cancel:
                  print("Authorization flow was manually canceled by user!")
              case .error(_, let description):
                  print("Error: \(String(describing: description))")
              }
          }
        }
        let canHandleUrl = DropboxClientsManager.handleRedirectURL(url, completion: oauthCompletion)
        return canHandleUrl
    }
    
}
struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}
enum Language:String {
    case en = "English"
    case es = "Español"
    case fr = "Français"
    case de = "Deutsch"
    case zhsp = "中文簡体"
    case zh = "中文繁体"
    case ko = "한국어"
    case ja = "日本語"
    case ru = "Русский"
    case sv = "Svenska"
    case da = "Dansk"
    case it = "Italiano"
    case pt = "Português"
    case su = "Suomi"
    case th = "ภาษาไทย"
    case tr = "Türkçe"
    case nl = "Nederlands"
    case sk = "språk"
    case el = "Ελληνικά"
    case vt = "Tiếng Việt"
    case la = "Latin"
    case he =
    "עברית"
case sy =
        "ܣܘܪܝܝܐ"
case ar = "اللغة العربية"
    
    func printLanguage()->String{
        return self.rawValue
    }
}


