//
//  SettingView.swift
//  Sh1rga
//
//  Created by tsg0o0 on 2022/07/18.
//

import UIKit
import WebKit
import SystemConfiguration
import Foundation

class SettingViewController: UIViewController , WKNavigationDelegate , WKUIDelegate , UIApplicationDelegate , UITextFieldDelegate{
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var webView: WKWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .nonPersistent()
        webView = WKWebView(frame: view.bounds, configuration: config)
        webView.navigationDelegate = self
        webView!.isOpaque = false
        webView!.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
        webView.uiDelegate = self
        view = webView
        appDelegate.autoSleepDisable = UserDefaults.standard.bool(forKey: "chat.autoSleepDisable")
        #if !RELEASEBYPASS
        //if ALTRELEASE
        appDelegate.enableBackground = UserDefaults.standard.bool(forKey: "chat.enableBackground")
        #else
        //#elseif RELEASEBYPASS
        appDelegate.enableMuteWord = UserDefaults.standard.bool(forKey: "chat.enableMuteWord")
        appDelegate.muteWord = UserDefaults.standard.string(forKey: "chat.muteWord")
        #endif
        loadSh1rga()
        NotificationCenter.default.addObserver(self, selector: #selector(boldTextStatusDidChangeNotification(notification:)), name: UIAccessibility.boldTextStatusDidChangeNotification, object: nil)
        if #available(iOS 14.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(buttonShapesEnabledStatusDidChangeNotification(notification:)), name: UIAccessibility.buttonShapesEnabledStatusDidChangeNotification, object: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reduceTransparencyStatusDidChangeNotification(notification:)), name: UIAccessibility.reduceTransparencyStatusDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reduceMotionStatusDidChangeNotification(notification:)), name: UIAccessibility.reduceMotionStatusDidChangeNotification, object: nil)
    }
    
    func loadSh1rga() {
        appDelegate.lang = "en"
        if Locale.current.languageCode == "ar" {
            appDelegate.lang = "ar"
        }
        if Locale.current.languageCode == "zh" {
            if Locale.current.identifier == "zh-TW" || Locale.current.identifier.prefix(7) == "zh-Hant"{
                appDelegate.lang = "tw"
            }else{
                appDelegate.lang = "cn"
            }
        }
        if Locale.current.languageCode == "de" {
            appDelegate.lang = "de"
        }
        if Locale.current.languageCode == "es" {
            appDelegate.lang = "es"
        }
        if Locale.current.languageCode == "fr" {
            appDelegate.lang = "fr"
        }
        if Locale.current.languageCode == "ja" {
            appDelegate.lang = "ja"
        }
        if Locale.current.languageCode == "pt" {
            appDelegate.lang = "pt"
        }
        if Locale.current.languageCode == "ru" {
            appDelegate.lang = "ru"
        }
        if Locale.current.languageCode == "ko" {
            appDelegate.lang = "ko"
        }
        if Locale.current.languageCode == "tok" {
            appDelegate.lang = "tok"
        }
        if let html = Bundle.main.path(forResource: "app/setting/setting", ofType: "html") {
            let url = URL(fileURLWithPath: html)
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func CheckReachability(host_name:String)->Bool{

        let reachability = SCNetworkReachabilityCreateWithName(nil, host_name)!
        var flags = SCNetworkReachabilityFlags.connectionAutomatic
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("language = '" + appDelegate.lang + "';settinglangset();")
        
        if UIAccessibility.isBoldTextEnabled {
            webView.evaluateJavaScript("window.setTimeout(\"isBoldTextEnabled(true);\", 200);")
        }
        if #available(iOS 14.0, *) {
            if UIAccessibility.buttonShapesEnabled {
                webView.evaluateJavaScript("window.setTimeout(\"buttonShapesEnabled(true);\", 200);")
            }
        }
        if UIAccessibility.isReduceTransparencyEnabled {
            webView.evaluateJavaScript("window.setTimeout(\"isReduceTransparencyEnabled(true);\", 200);")
        }
        if UIAccessibility.isReduceMotionEnabled {
            webView.evaluateJavaScript("window.setTimeout(\"isReduceMotionEnabled(true);\", 200);")
        }
    }
    
    @objc private func boldTextStatusDidChangeNotification(notification: Notification) {
        if UIAccessibility.isBoldTextEnabled {
            webView.evaluateJavaScript("isBoldTextEnabled(true);")
        }else{
            webView.evaluateJavaScript("isBoldTextEnabled(false);")
        }
    }
    @objc private func buttonShapesEnabledStatusDidChangeNotification(notification: Notification) {
        if #available(iOS 14.0, *) {
            if UIAccessibility.buttonShapesEnabled {
                webView.evaluateJavaScript("buttonShapesEnabled(true);")
            }else{
                webView.evaluateJavaScript("buttonShapesEnabled(false);")
            }
        }
    }
    @objc private func reduceTransparencyStatusDidChangeNotification(notification: Notification) {
        if UIAccessibility.isReduceTransparencyEnabled {
            webView.evaluateJavaScript("isReduceTransparencyEnabled(true);")
        }else{
            webView.evaluateJavaScript("isReduceTransparencyEnabled(false);")
        }
    }
    @objc private func reduceMotionStatusDidChangeNotification(notification: Notification) {
        if UIAccessibility.isReduceMotionEnabled {
            webView.evaluateJavaScript("isReduceMotionEnabled(true);")
        }else{
            webView.evaluateJavaScript("isReduceMotionEnabled(false);")
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if "sh1rga://" == navigationAction.request.url!.absoluteString.prefix(9) {
                decisionHandler(.cancel)
            
            if navigationAction.request.url!.absoluteString == "sh1rga://settingViewLoad" {
                
                if appDelegate.autoSleepDisable == true {
                    webView.evaluateJavaScript("document.getElementById('setting-autoSleepDisable').innerHTML = '<button onclick=\"location.href=\\\'sh1rga://setting/autoSleepDisable/false\\\'\">ON</button>'")
                }else{
                    webView.evaluateJavaScript("document.getElementById('setting-autoSleepDisable').innerHTML = '<button onclick=\"location.href=\\\'sh1rga://setting/autoSleepDisable/true\\\'\" style=\"color:#ddd\">OFF</button>'")
                }
                
                #if !RELEASEBYPASS
                //#if ALTRELEASE
                webView.evaluateJavaScript("document.getElementById('setting-altchange').innerHTML = '<div class=\"setbox\"><h3 style=\"margin:5px\">' + settingLangJson.background + '</h3><div style=\"padding:5px;color:#ccc\">' + settingLangJson.background_1 + '<br>' + settingLangJson.background_2 + '<br></div><div id=\"setting-enableBackground\"><button>&nbsp; &nbsp; &nbsp;</button></div></div><br>'")
                if appDelegate.enableBackground == true {
                    webView.evaluateJavaScript("document.getElementById('setting-enableBackground').innerHTML = '<button onclick=\"location.href=\\\'sh1rga://setting/enableBackground/false\\\'\">ON</button>'")
                }else{
                    webView.evaluateJavaScript("document.getElementById('setting-enableBackground').innerHTML = '<button onclick=\"location.href=\\\'sh1rga://setting/enableBackground/true\\\'\" style=\"color:#ddd\">OFF</button>'")
                }
                #else
                //#elseif RELEASEBYPASS
                if appDelegate.allowMuteWord == true {
                    webView.evaluateJavaScript("document.getElementById('setting-altchange').innerHTML = '<div class=\"setbox\"><h3 style=\"margin:5px\">' + settingLangJson.muteword + '</h3><div style=\"padding:5px;color:#ccc\">' + settingLangJson.muteword_1 + '<br></div><div style=\"display:inline\" id=\"setting-enableMuteWord\"><button>&nbsp; &nbsp; &nbsp;</button></div>&nbsp; &nbsp;<button onclick=\"location.href=\\\'sh1rga://setting/muteWord\\\'\">' + langjson.setting + '</button></div><br>'")
                    if appDelegate.enableMuteWord == true {
                        webView.evaluateJavaScript("document.getElementById('setting-enableMuteWord').innerHTML = '<button onclick=\"location.href=\\\'sh1rga://setting/enableMuteWord/false\\\'\">ON</button>'")
                    }else{
                        webView.evaluateJavaScript("document.getElementById('setting-enableMuteWord').innerHTML = '<button onclick=\"location.href=\\\'sh1rga://setting/enableMuteWord/true\\\'\" style=\"color:#ddd\">OFF</button>'")
                    }
                }
                #endif
                
            }else if navigationAction.request.url!.absoluteString == "sh1rga://setting/icon/0" {
                UIApplication.shared.setAlternateIconName(nil, completionHandler: { error in print(error as Any) })
                    
            }else if navigationAction.request.url!.absoluteString == "sh1rga://setting/icon/1" {
                UIApplication.shared.setAlternateIconName("App", completionHandler: { error in print(error as Any) })
                    
            }else if navigationAction.request.url!.absoluteString == "sh1rga://setting/icon/2" {
                UIApplication.shared.setAlternateIconName("Black", completionHandler: { error in print(error as Any) })
                    
            }else if navigationAction.request.url!.absoluteString == "sh1rga://setting/autoSleepDisable/true" {
                appDelegate.autoSleepDisable = true
                UserDefaults.standard.set(true, forKey: "chat.autoSleepDisable")
                webView.evaluateJavaScript("document.getElementById('setting-autoSleepDisable').innerHTML = '<button onclick=\"location.href=\\\'sh1rga://setting/autoSleepDisable/false\\\'\">ON</button>'")
                
            }else if navigationAction.request.url!.absoluteString == "sh1rga://setting/autoSleepDisable/false" {
                appDelegate.autoSleepDisable = false
                UserDefaults.standard.set(false, forKey: "chat.autoSleepDisable")
                webView.evaluateJavaScript("document.getElementById('setting-autoSleepDisable').innerHTML = '<button onclick=\"location.href=\\\'sh1rga://setting/autoSleepDisable/true\\\'\" style=\"color:#ddd\">OFF</button>'")

                
            }else if navigationAction.request.url!.absoluteString == "sh1rga://setting/notifi" {
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                        switch settings.authorizationStatus {
                        case .notDetermined:
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                            }; break
                            
                        case .denied:
                            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }; break
                            
                        case .authorized:
                            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }; break
                            
                        case .provisional:
                            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }; break
                            
                        case .ephemeral:
                            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }; break
                            
                        @unknown default:
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                            }
                            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }; break
                        }
                }
                
            }
            
            #if !RELEASEBYPASS
            //#if ALTRELEASE
            if navigationAction.request.url!.absoluteString == "sh1rga://setting/enableBackground/true" {
                appDelegate.enableBackground = true
                UserDefaults.standard.set(true, forKey: "chat.enableBackground")
                webView.evaluateJavaScript("document.getElementById('setting-enableBackground').innerHTML = '<button onclick=\"location.href=\\\'sh1rga://setting/enableBackground/false\\\'\">ON</button>'")

            }else if navigationAction.request.url!.absoluteString == "sh1rga://setting/enableBackground/false" {
                appDelegate.enableBackground = false
                UserDefaults.standard.set(false, forKey: "chat.enableBackground")
                webView.evaluateJavaScript("document.getElementById('setting-enableBackground').innerHTML = '<button onclick=\"location.href=\\\'sh1rga://setting/enableBackground/true\\\'\" style=\"color:#ddd\">OFF</button>'")
            }
            #else
            //#elseif RELEASEBYPASS
            if appDelegate.allowMuteWord == true {
                if navigationAction.request.url!.absoluteString == "sh1rga://setting/enableMuteWord/true" {
                    appDelegate.enableMuteWord = true
                    UserDefaults.standard.set(true, forKey: "chat.enableMuteWord")
                    webView.evaluateJavaScript("document.getElementById('setting-enableMuteWord').innerHTML = '<button onclick=\"location.href=\\\'sh1rga://setting/enableMuteWord/false\\\'\">ON</button>'")
                    webView.evaluateJavaScript("enableMuteWord = true;")
                }else if navigationAction.request.url!.absoluteString == "sh1rga://setting/enableMuteWord/false" {
                    appDelegate.enableMuteWord = false
                    UserDefaults.standard.set(false, forKey: "chat.enableMuteWord")
                    webView.evaluateJavaScript("document.getElementById('setting-enableMuteWord').innerHTML = '<button onclick=\"location.href=\\\'sh1rga://setting/enableMuteWord/true\\\'\" style=\"color:#ddd\">OFF</button>'")
                    webView.evaluateJavaScript("enableMuteWord = false;")
                }else if navigationAction.request.url!.absoluteString == "sh1rga://setting/muteWord" {
                    
                    struct Record:Codable {
                        let muteword: String
                        let muteword_1: String
                    }
                    var mutewordAlertText = "Mute Word"
                    var mutewordAlertMes = "Mutes the specified words."
                    let url = URL(string: "https://chat.sh1r.ga/ios/lang/" + appDelegate.lang + ".json")!
                    let request = URLRequest(url: url)
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        guard let data = data else { return }
                        do {
                            let jsonData = try JSONDecoder().decode(Record.self, from: data)
                            DispatchQueue.main.async {
                                mutewordAlertText = jsonData.muteword
                                mutewordAlertMes = jsonData.muteword_1
                            }
                        } catch _ {
                        }
                    }
                    task.resume()
                    
                    let alert = UIAlertController(title: mutewordAlertText, message: mutewordAlertMes, preferredStyle: .alert)
                    alert.addTextField( configurationHandler: { (Word: UITextField!) -> Void in
                        Word.text = self.appDelegate.muteWord
                    })
                    let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                        let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
                        for textField:UITextField in textFields! {
                            self.appDelegate.muteWord = textField.text
                            UserDefaults.standard.set(self.appDelegate.muteWord, forKey: "chat.muteWord")
                            webView.evaluateJavaScript("muteWord = \"" + self.appDelegate.muteWord! + "\";")
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (acrion) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(cancel)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            #endif
            
        } else {
            if "file://" == navigationAction.request.url!.absoluteString.prefix(7) {
                decisionHandler(.allow)
            }else{
                UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
            }
            
        }
    }

override var keyCommands: [UIKeyCommand]? {
    return [
        .init(title: "Reload", action: #selector(self.commandReload), input: "r", modifierFlags: [.command])
        ]
}
@objc func commandReload() {
    if appDelegate.joinFlag == false {
    webView.reload()
    }
}
    
}
