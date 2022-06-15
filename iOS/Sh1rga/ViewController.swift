//
//  ViewController.swift
//  Sh1rga
//
//  Created by tsg0o0 on 2022/05/14.
//

import UIKit
import WebKit
import SystemConfiguration
import AVFoundation
import Foundation

class ViewController: UIViewController , WKNavigationDelegate , WKUIDelegate , UIApplicationDelegate , AVAudioPlayerDelegate , UITextFieldDelegate{
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var webView: WKWebView!
    var firstTime = true
    var internetConnection = false
    var autoSleepDisable = false
    var enableBackground = false
    var muteWord:String? = nil
    var enableMuteWord = false
    var allowMuteWord = false
    

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
        autoSleepDisable = UserDefaults.standard.bool(forKey: "chat.autoSleepDisable")
        #if ALTRELEASE
        enableBackground = UserDefaults.standard.bool(forKey: "chat.enableBackground")
        #else
        enableMuteWord = UserDefaults.standard.bool(forKey: "chat.enableMuteWord")
        muteWord = UserDefaults.standard.string(forKey: "chat.muteWord")
        #endif
        loadSh1rga()
    }
    
    func loadSh1rga() {
        internetConnection = CheckReachability(host_name: "sh1r.ga")
        appDelegate.lang = "en"
        if Locale.current.languageCode == "ar" {
            appDelegate.lang = "ar"
        }
        if Locale.current.languageCode == "zh" {
            print(Locale.current.identifier)
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
        if (internetConnection == true) {
            if let html = Bundle.main.path(forResource: "app/index", ofType: "html") {
                  let url = URL(fileURLWithPath: html)
                  let request = URLRequest(url: url)
                  webView.load(request)
            }
            
    }else{
            if let html = Bundle.main.path(forResource: "app/error/index", ofType: "html") {
                  let url = URL(fileURLWithPath: html)
                  let request = URLRequest(url: url)
                  webView.load(request)
            }
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


    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if firstTime == true && internetConnection == true {
        #if ALTRELEASE
            struct Record:Codable {
                let ver: String
            }
            let url = URL(string: "https://tsg0o0.com/resource/app/sh1rga/altstore.json")!
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let jsonData = try JSONDecoder().decode(Record.self, from: data)
                    DispatchQueue.main.async {
                        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                        
                        if jsonData.ver != version {
                            self.verOldAlert()
                        }
                    }
                } catch _ {
                }
            }
            task.resume()
        #else
            AppVersionCompare.toAppStoreVersion() { (type) in
                switch type {
                case .latest: break
                case .old:
                    self.verOldAlert()
                case .error: break
                }
            }
            struct Record:Codable {
                let allowMuteWord: Bool
            }
            let url = URL(string: "https://chat.sh1r.ga/ios/appSetting.json")!
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let jsonData = try JSONDecoder().decode(Record.self, from: data)
                    DispatchQueue.main.async {
                        self.allowMuteWord = jsonData.allowMuteWord
                    }
                } catch _ {
                }
            }
            task.resume()
        
        #endif
        self.firstTime = false
    }
        
        if "sh1rga://" == navigationAction.request.url!.absoluteString.prefix(9) {
                decisionHandler(.cancel)
            
            if navigationAction.request.url!.absoluteString == "sh1rga://appSettingLoad" {
                
                #if !ALTRELEASE
                if (enableMuteWord == true) {
                    webView.evaluateJavaScript("muteWord = \"" + muteWord! + "\";")
                    webView.evaluateJavaScript("enableMuteWord = true;")
                }else{
                    webView.evaluateJavaScript("enableMuteWord = false;")
                }
                #endif
                
            }else if navigationAction.request.url!.absoluteString == "sh1rga://reload" {
                
                loadSh1rga()
                
            }else if navigationAction.request.url!.absoluteString == "sh1rga://notifi/getNewMessage" {
                
                let content: UNMutableNotificationContent = UNMutableNotificationContent()
                content.title = "Sh1rga Chat"
                if appDelegate.lang == "ar" {
                    content.subtitle = "لقد تلقيت رسالة جديدة"
                }else if appDelegate.lang == "cn" {
                    content.subtitle = "你会收到一条新消息"
                }else if appDelegate.lang == "tw" {
                    content.subtitle = "您收到一條新消息"
                }else if appDelegate.lang == "de" {
                    content.subtitle = "Sie erhalten eine neue Nachricht"
                }else if appDelegate.lang == "es" {
                    content.subtitle = "Recibe un nuevo mensaje"
                }else if appDelegate.lang == "fr" {
                    content.subtitle = "Vous recevez un nouveau message"
                }else if appDelegate.lang == "ja" {
                    content.subtitle = "新しいメッセージが届きました"
                }else if appDelegate.lang == "pt" {
                    content.subtitle = "Recebe uma nova mensagem"
                }else if appDelegate.lang == "ru" {
                    content.subtitle = "Вы получаете новое сообщение"
                }else if appDelegate.lang == "ko" {
                    content.subtitle = "새 메시지를 받습니다"
                }else{
                    content.subtitle = "You get a new message"
                }
                content.sound = UNNotificationSound.default
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(1), repeats: false)
                let identifier = NSUUID().uuidString
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request){ (error : Error?) in
                     if let error = error {
                          print(error.localizedDescription)
                     }
                }
                
            }else if navigationAction.request.url!.absoluteString == "sh1rga://notifi/joinUser" {
                
                let content: UNMutableNotificationContent = UNMutableNotificationContent()
                content.title = "Sh1rga Chat"
                
                if appDelegate.lang == "ar" {
                    content.subtitle = "انضم المستخدم إلى الغرفة"
                    content.body = "لنبدأ محادثة!"
                }else if appDelegate.lang == "cn" {
                    content.subtitle = "用户已加入该房间"
                    content.body = "让我们开始对话吧!"
                }else if appDelegate.lang == "tw" {
                    content.subtitle = "用戶已加入房間"
                    content.body = "讓我們開始對話吧！"
                }else if appDelegate.lang == "de" {
                    content.subtitle = "Benutzer hat den Raum betreten"
                    content.body = "Lasst uns ein Gespräch beginnen!"
                }else if appDelegate.lang == "es" {
                    content.subtitle = "El usuario se ha unido a la sala"
                    content.body = "¡Iniciemos una conversación!"
                }else if appDelegate.lang == "fr" {
                    content.subtitle = "L'utilisateur a rejoint la salle"
                    content.body = "Commençons une conversation !"
                }else if appDelegate.lang == "ja" {
                    content.subtitle = "ユーザーがルームに参加しました"
                    content.body = "会話を始めましょう！"
                }else if appDelegate.lang == "pt" {
                    content.subtitle = "O utilizador juntou-se à sala"
                    content.body = "Vamos começar uma conversa!"
                }else if appDelegate.lang == "ru" {
                    content.subtitle = "Пользователь присоединился к комнате"
                    content.body = "Давайте начнем разговор!"
                }else if appDelegate.lang == "ko" {
                    content.subtitle = "사용자가 채팅방에 참여했습니다"
                    content.body = "대화를 시작합시다!"
                }else{
                    content.subtitle = "User has joined the room"
                    content.body = "Let's start a conversation!"
                }
                
                content.sound = UNNotificationSound.default
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(1), repeats: false)
                let identifier = NSUUID().uuidString
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request){ (error : Error?) in
                     if let error = error {
                          print(error.localizedDescription)
                     }
                }
                
            }else if navigationAction.request.url!.absoluteString == "sh1rga://flag/join/true" {
                appDelegate.joinFlag = true
                if autoSleepDisable == true {
                    UIApplication.shared.isIdleTimerDisabled = true
                }else{
                    UIApplication.shared.isIdleTimerDisabled = false
                }
                    
            }else if navigationAction.request.url!.absoluteString == "sh1rga://flag/join/false" {
                appDelegate.joinFlag = false
                UIApplication.shared.isIdleTimerDisabled = false
                    
            }else if navigationAction.request.url!.absoluteString == "sh1rga://settingViewLoad" {
                
                if autoSleepDisable == true {
                    webView.evaluateJavaScript("document.getElementById('setting-autoSleepDisable').innerHTML = '<a href=\"sh1rga://setting/autoSleepDisable/false\">ON</a>'")
                }else{
                    webView.evaluateJavaScript("document.getElementById('setting-autoSleepDisable').innerHTML = '<a href=\"sh1rga://setting/autoSleepDisable/true\" style=\"color:#ddd\">OFF</a>'")
                }
                
                #if ALTRELEASE
                webView.evaluateJavaScript("document.getElementById('setting-altchange').innerHTML = '<div class=\"setbox\"><h3 style=\"margin:5px\">' + settingLangJson.background + '</h3><div style=\"padding:5px;color:#ccc\">' + settingLangJson.background_1 + '<br>' + settingLangJson.background_2 + '<br></div><div id=\"setting-enableBackground\"><a>&nbsp; &nbsp; &nbsp;</a></div></div><br>'")
                if enableBackground == true {
                    webView.evaluateJavaScript("document.getElementById('setting-enableBackground').innerHTML = '<a href=\"sh1rga://setting/enableBackground/false\">ON</a>'")
                }else{
                    webView.evaluateJavaScript("document.getElementById('setting-enableBackground').innerHTML = '<a href=\"sh1rga://setting/enableBackground/true\" style=\"color:#ddd\">OFF</a>'")
                }
                #else
                if allowMuteWord == true {
                    webView.evaluateJavaScript("document.getElementById('setting-altchange').innerHTML = '<div class=\"setbox\"><h3 style=\"margin:5px\">' + settingLangJson.muteword + '</h3><div style=\"padding:5px;color:#ccc\">' + settingLangJson.muteword_1 + '<br></div><div style=\"display:inline\" id=\"setting-enableMuteWord\"><a>&nbsp; &nbsp; &nbsp;</a></div>&nbsp; &nbsp;<a href=\"sh1rga://setting/muteWord\">' + langjson.setting + '</a></div><br>'")
                    if enableMuteWord == true {
                        webView.evaluateJavaScript("document.getElementById('setting-enableMuteWord').innerHTML = '<a href=\"sh1rga://setting/enableMuteWord/false\">ON</a>'")
                    }else{
                        webView.evaluateJavaScript("document.getElementById('setting-enableMuteWord').innerHTML = '<a href=\"sh1rga://setting/enableMuteWord/true\" style=\"color:#ddd\">OFF</a>'")
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
                autoSleepDisable = true
                UserDefaults.standard.set(true, forKey: "chat.autoSleepDisable")
                webView.evaluateJavaScript("document.getElementById('setting-autoSleepDisable').innerHTML = '<a href=\"sh1rga://setting/autoSleepDisable/false\">ON</a>'")
                
            }else if navigationAction.request.url!.absoluteString == "sh1rga://setting/autoSleepDisable/false" {
                autoSleepDisable = false
                UserDefaults.standard.set(false, forKey: "chat.autoSleepDisable")
                webView.evaluateJavaScript("document.getElementById('setting-autoSleepDisable').innerHTML = '<a href=\"sh1rga://setting/autoSleepDisable/true\" style=\"color:#ddd\">OFF</a>'")

                
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
            
            #if ALTRELEASE
            if navigationAction.request.url!.absoluteString == "sh1rga://setting/enableBackground/true" {
                enableBackground = true
                UserDefaults.standard.set(true, forKey: "chat.enableBackground")
                webView.evaluateJavaScript("document.getElementById('setting-enableBackground').innerHTML = '<a href=\"sh1rga://setting/enableBackground/false\">ON</a>'")

            }else if navigationAction.request.url!.absoluteString == "sh1rga://setting/enableBackground/false" {
                enableBackground = false
                UserDefaults.standard.set(false, forKey: "chat.enableBackground")
                webView.evaluateJavaScript("document.getElementById('setting-enableBackground').innerHTML = '<a href=\"sh1rga://setting/enableBackground/true\" style=\"color:#ddd\">OFF</a>'")
            }
            #else
            if allowMuteWord == true {
                if navigationAction.request.url!.absoluteString == "sh1rga://setting/enableMuteWord/true" {
                    enableMuteWord = true
                    UserDefaults.standard.set(true, forKey: "chat.enableMuteWord")
                    webView.evaluateJavaScript("document.getElementById('setting-enableMuteWord').innerHTML = '<a href=\"sh1rga://setting/enableMuteWord/false\">ON</a>'")
                    webView.evaluateJavaScript("enableMuteWord = true;")
                }else if navigationAction.request.url!.absoluteString == "sh1rga://setting/enableMuteWord/false" {
                    enableMuteWord = false
                    UserDefaults.standard.set(false, forKey: "chat.enableMuteWord")
                    webView.evaluateJavaScript("document.getElementById('setting-enableMuteWord').innerHTML = '<a href=\"sh1rga://setting/enableMuteWord/true\" style=\"color:#ddd\">OFF</a>'")
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
                        Word.text = self.muteWord
                    })
                    let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                        let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
                        for textField:UITextField in textFields! {
                            self.muteWord = textField.text
                            UserDefaults.standard.set(self.muteWord, forKey: "chat.muteWord")
                            webView.evaluateJavaScript("muteWord = \"" + self.muteWord! + "\";")
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
    
    func verOldAlert() {
        var VerAlertText = "Version is out of date."
        #if ALTRELEASE
        let alert = UIAlertController(title: VerAlertText, message: "Do you want to open the AltStore? Or do you want to update directly?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Open", style: .default) { (action) in
            let urlString = "altstore://"
            let url = NSURL(string: urlString)
            UIApplication.shared.open(url! as URL)
            self.dismiss(animated: true, completion: nil)
        }
        let update = UIAlertAction(title: "Direct Update", style: .default) { (action) in
            let urlString = "altstore://install?url=https://tsg0o0.com/resource/app/sh1rga/ios/Sh1rga.ipa"
            let url = NSURL(string: urlString)
            UIApplication.shared.open(url! as URL)
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "No", style: .cancel) { (acrion) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(update)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
        #else
        
        let queue = DispatchQueue.main
        queue.sync{
                let alert = UIAlertController(title: VerAlertText, message: "Do you want to open the App Store?", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Open", style: .default) { (action) in
                    let urlString = "itms-apps://itunes.apple.com/app/id1622376481"
                    let url = NSURL(string: urlString)
                    UIApplication.shared.open(url! as URL)
                    self.dismiss(animated: true, completion: nil)
                }
                let cancel = UIAlertAction(title: "No", style: .cancel) { (acrion) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancel)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
        }
        #endif
    }
    
}

#if !ALTRELEASE
enum AppVersionCompareType {
    case latest
    case old
    case error
}

class AppVersionCompare {
    static func toAppStoreVersion(completion: @escaping (AppVersionCompareType) -> Void) {
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=1622376481") else {
            completion(.error)
            return
        }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let data = data else {
                completion(.error)
                return
            }
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard let storeVersion = ((jsonData?["results"] as? [Any])?.first as? [String : Any])?["version"] as? String
                    , let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
                        completion(.error)
                        return
                }
                switch storeVersion.compare(appVersion, options: .numeric) {
                case .orderedDescending:
                    completion(.old)
                case .orderedSame, .orderedAscending:
                    completion(.latest)
                }
            } catch {
                completion(.error)
            }
        })
        task.resume()
    }
}
#endif