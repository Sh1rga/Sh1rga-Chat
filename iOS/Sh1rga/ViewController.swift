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
        if let html = Bundle.main.path(forResource: "app/loading", ofType: "html") {
              let url = URL(fileURLWithPath: html)
              let request = URLRequest(url: url)
              webView.load(request)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(boldTextStatusDidChangeNotification(notification:)), name: UIAccessibility.boldTextStatusDidChangeNotification, object: nil)
        if #available(iOS 14.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(buttonShapesEnabledStatusDidChangeNotification(notification:)), name: UIAccessibility.buttonShapesEnabledStatusDidChangeNotification, object: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reduceTransparencyStatusDidChangeNotification(notification:)), name: UIAccessibility.reduceTransparencyStatusDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reduceMotionStatusDidChangeNotification(notification:)), name: UIAccessibility.reduceMotionStatusDidChangeNotification, object: nil)
    }
    
    func loadSh1rga() {
        internetConnection = CheckReachability(host_name: "sh1r.ga")
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            if (internetConnection == true) {
                if let html = Bundle.main.path(forResource: "app/chat/index", ofType: "html") {
                    let url = URL(fileURLWithPath: html)
                    let request = URLRequest(url: url)
                    webView.load(request)
                }
                
            }else{
                if let html = Bundle.main.path(forResource: "app/chat/error", ofType: "html") {
                    let url = URL(fileURLWithPath: html)
                    let request = URLRequest(url: url)
                    webView.load(request)
                    firstTime = false
                }
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

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if firstTime == true {
            loadSh1rga()
        }
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
        
        if firstTime == true && internetConnection == true {
                #if ALTRELEASE
                struct Record:Codable {
                    let ver: String
                }
                let url = URL(string: "https://sh1r.ga/iOSAppSetting.json")!
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
                let url = URL(string: "https://sh1r.ga/iOSAppSetting.json")!
                let request = URLRequest(url: url)
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard let data = data else { return }
                    do {
                        let jsonData = try JSONDecoder().decode(Record.self, from: data)
                        DispatchQueue.main.async {
                            self.appDelegate.allowMuteWord = jsonData.allowMuteWord
                            if jsonData.allowMuteWord == false {
                                self.appDelegate.enableMuteWord = false
                            }
                        }
                    } catch _ {
                    }
                }
                task.resume()
                
                #endif
            firstTime = false
        }
        
        if "sh1rga://" == navigationAction.request.url!.absoluteString.prefix(9) {
                decisionHandler(.cancel)
            
            if navigationAction.request.url!.absoluteString == "sh1rga://appSettingLoad" {
                
                #if RELEASEBYPASS
                if (appDelegate.enableMuteWord == true && appDelegate.enableMuteWord == true) {
                    webView.evaluateJavaScript("muteWord = \"" + appDelegate.muteWord! + "\";")
                    webView.evaluateJavaScript("enableMuteWord = true;")
                }else{
                    webView.evaluateJavaScript("enableMuteWord = false;")
                }
                #endif
                
            }else if navigationAction.request.url!.absoluteString == "sh1rga://reload" {
                
                firstTime = true
                loadSh1rga()
                
            }else if navigationAction.request.url!.absoluteString == "sh1rga://notifi/getNewMessage" {
                if (appDelegate.selectedTabBar != "Chat") {
                    let tabBarItem = tabBarController?.viewControllers?[0].tabBarItem
                    tabBarItem?.badgeValue = "!"
                    tabBarItem?.badgeColor = UIColor.red
                }
                
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
                }else if appDelegate.lang == "tok" {
                    content.subtitle = "sina jo e sin toki"
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
                }else if appDelegate.lang == "tok" {
                    content.subtitle = "ona li kama"
                    content.body = "o open e toki!"
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
                if appDelegate.autoSleepDisable == true {
                    UIApplication.shared.isIdleTimerDisabled = true
                }else{
                    UIApplication.shared.isIdleTimerDisabled = false
                }
                    
            }else if navigationAction.request.url!.absoluteString == "sh1rga://flag/join/false" {
                appDelegate.joinFlag = false
                UIApplication.shared.isIdleTimerDisabled = false
                    
            }
            
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
        var VerAlertTitle = "Version is out of date"
        var VerAlertOpen = "Open"
        var VerAlertNo = "No"
        if appDelegate.lang == "ar" {
            VerAlertTitle = "الإصدار قديم"
            VerAlertOpen = "فتح"
            VerAlertNo = "لا"
        }else if appDelegate.lang == "cn" {
            VerAlertTitle = "版本已过期"
            VerAlertOpen = "打开"
            VerAlertNo = "不"
        }else if appDelegate.lang == "tw" {
            VerAlertTitle = "版本已過期"
            VerAlertOpen = "打開"
            VerAlertNo = "不"
        }else if appDelegate.lang == "de" {
            VerAlertTitle = "Die Version ist veraltet"
            VerAlertOpen = "Öffnen Sie"
            VerAlertNo = "Nein"
        }else if appDelegate.lang == "es" {
            VerAlertTitle = "La versión está desfasada"
            VerAlertOpen = "Abrir"
            VerAlertNo = "No"
        }else if appDelegate.lang == "fr" {
            VerAlertTitle = "La version n'est pas à jour"
            VerAlertOpen = "Ouvrir"
            VerAlertNo = "Non"
        }else if appDelegate.lang == "ja" {
            VerAlertTitle = "バージョンが古くなっています"
            VerAlertOpen = "開く"
            VerAlertNo = "いいえ"
        }else if appDelegate.lang == "pt" {
            VerAlertTitle = "A versão está desactualizada"
            VerAlertOpen = "Aberto"
            VerAlertNo = "Não"
        }else if appDelegate.lang == "ru" {
            VerAlertTitle = "Версия устарела"
            VerAlertOpen = "Открыть"
            VerAlertNo = "Нет"
        }else if appDelegate.lang == "ko" {
            VerAlertTitle = "버전이 오래되었습니다"
            VerAlertOpen = "열려 있는"
            VerAlertNo = "아니"
        }else if appDelegate.lang == "tok" {
            VerAlertTitle = "age ona ni li sin ala"
            VerAlertOpen = "open"
            VerAlertNo = "ala"
        }
        #if ALTRELEASE
        var VerAlertMsg = "Do you want to open the AltStore?\nOr do you want to update directly?"
        var VerAlertDirectUpdate = "Direct Update"
        if appDelegate.lang == "ar" {
            VerAlertMsg = "هل تريد فتح AltStore؟\nأم تريد التحديث مباشرة؟"
            VerAlertDirectUpdate = "تحديث مباشر"
        }else if appDelegate.lang == "cn" {
            VerAlertMsg = "你想打开AltStore吗？\n还是想直接更新？"
            VerAlertDirectUpdate = "直接更新"
        }else if appDelegate.lang == "tw" {
            VerAlertMsg = "您要打開AltStore嗎？\n還是要直接更新？"
            VerAlertDirectUpdate = "直接更新"
        }else if appDelegate.lang == "de" {
            VerAlertMsg = "Möchten Sie den AltStore öffnen?\nOder möchten Sie direkt aktualisieren?"
            VerAlertDirectUpdate = "Direkt aktualisieren"
        }else if appDelegate.lang == "es" {
            VerAlertMsg = "¿Desea abrir la AltStore?\n¿O quiere actualizar directamente?"
            VerAlertDirectUpdate = "Actualización directa"
        }else if appDelegate.lang == "fr" {
            VerAlertMsg = "Voulez-vous ouvrir le magasin AltStore ?\nOu voulez-vous faire une mise à jour directe ?"
            VerAlertDirectUpdate = "Mise à jour directe"
        }else if appDelegate.lang == "ja" {
            VerAlertMsg = "AltStoreを開きますか？\nそれとも直接アップデートしますか？"
            VerAlertDirectUpdate = "直接アップデート"
        }else if appDelegate.lang == "pt" {
            VerAlertMsg = "Quer abrir a AltStore?\nOu quer actualizar directamente?"
            VerAlertDirectUpdate = "Actualização directa"
        }else if appDelegate.lang == "ru" {
            VerAlertMsg = "Хотите ли вы открыть AltStore?\nИли вы хотите обновить напрямую?"
            VerAlertDirectUpdate = "Прямое обновление"
        }else if appDelegate.lang == "ko" {
            VerAlertMsg = "AltStore를 여시겠습니까?\n아니면 직접 업데이트하시겠습니까?"
            VerAlertDirectUpdate = "직접 업데이트"
        }else if appDelegate.lang == "tok" {
            VerAlertMsg = "open e ilo AltStore ala sona sin kepeken ni?"
            VerAlertDirectUpdate = "sona sin"
        }
        let alert = UIAlertController(title: VerAlertTitle, message: VerAlertMsg, preferredStyle: .alert)
        let ok = UIAlertAction(title: VerAlertOpen, style: .default) { (action) in
            let urlString = "altstore://"
            let url = NSURL(string: urlString)
            UIApplication.shared.open(url! as URL)
            self.dismiss(animated: true, completion: nil)
        }
        let update = UIAlertAction(title: VerAlertDirectUpdate, style: .default) { (action) in
            let urlString = "altstore://install?url=https://tsg0o0.com/resource/app/sh1rga/ios/Sh1rga.ipa"
            let url = NSURL(string: urlString)
            UIApplication.shared.open(url! as URL)
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: VerAlertNo, style: .cancel) { (acrion) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        alert.addAction(update)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
        #else
        
        var VerAlertMsg = "Do you want to open the App Store?"
        if appDelegate.lang == "ar" {
            VerAlertMsg = "هل تريد فتح متجر التطبيقات؟"
        }else if appDelegate.lang == "cn" {
            VerAlertMsg = "你想打开App Store吗？"
        }else if appDelegate.lang == "tw" {
            VerAlertMsg = "您要打開App Store嗎？"
        }else if appDelegate.lang == "de" {
            VerAlertMsg = "Möchten Sie den App Store öffnen?"
        }else if appDelegate.lang == "es" {
            VerAlertMsg = "¿Desea abrir la App Store?"
        }else if appDelegate.lang == "fr" {
            VerAlertMsg = "Voulez-vous ouvrir l'App Store ?"
        }else if appDelegate.lang == "ja" {
            VerAlertMsg = "App Storeを開きますか？"
        }else if appDelegate.lang == "pt" {
            VerAlertMsg = "Quer abrir a App Store?"
        }else if appDelegate.lang == "ru" {
            VerAlertMsg = "Вы хотите открыть App Store?"
        }else if appDelegate.lang == "ko" {
            VerAlertMsg = "앱 스토어를 열시겠습니까?"
        }else if appDelegate.lang == "tok" {
            VerAlertMsg = "open e ilo App Store ala open ni?"
        }
        let queue = DispatchQueue.main
        queue.sync{
            let alert = UIAlertController(title: VerAlertTitle, message: VerAlertMsg, preferredStyle: .alert)
            let ok = UIAlertAction(title: VerAlertOpen, style: .default) { (action) in
                let urlString = "itms-apps://itunes.apple.com/app/id1622376481"
                let url = NSURL(string: urlString)
                UIApplication.shared.open(url! as URL)
                self.dismiss(animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: VerAlertNo, style: .cancel) { (acrion) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            alert.addAction(cancel)
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
