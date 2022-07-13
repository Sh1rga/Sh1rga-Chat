//
//  SceneDelegate.swift
//  Sh1rga
//
//  Created by tsg0o0 on 2022/05/14.
//

import UIKit
import AVFoundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate, AVAudioPlayerDelegate {

    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var backgroundTaskID = UIBackgroundTaskIdentifier(rawValue: 6336)
    var window: UIWindow?
    let view = UIView()
    var enableBackground = false
    var playing = false

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        #if !RELEASEBYPASS
        //#if ALTRELEASE
        enableBackground = UserDefaults.standard.bool(forKey: "chat.enableBackground")
        if enableBackground == true && playing == true {
            appDelegate.audioPlayer.stop()
            playing = false
        }
        #endif
        
        self.view.removeFromSuperview()
        UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        if appDelegate.joinFlag == true {
            self.backgroundTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: backEndTask)
        }
        
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
        
        #if !RELEASEBYPASS
        //#if ALTRELEASE
        enableBackground = UserDefaults.standard.bool(forKey: "chat.enableBackground")
        if enableBackground == true && appDelegate.joinFlag == true {
        do {
            guard let path = Bundle.main.path(forResource: "bg", ofType: "mp3") else {
                return
            }
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSession.Category.playback)
            try audioSession.setActive(true)
            appDelegate.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                appDelegate.audioPlayer.delegate = self
                appDelegate.audioPlayer.numberOfLoops = -1
                appDelegate.audioPlayer.volume = 0.0
                appDelegate.audioPlayer.play()
                playing = true
        } catch {
        }
        }
        #endif
        
        self.window?.addSubview(view)
    }
    
    func backEndTask() {
        
        let content: UNMutableNotificationContent = UNMutableNotificationContent()
        content.title = "Sh1rga Chat"
        
        if appDelegate.lang == "ar" {
            content.subtitle = "توقف التحميل في الخلفية ..."
            content.body = "لا يمكن تلقي الرسائل حتى يتم إعادة فتح التطبيق."
        }else if appDelegate.lang == "cn" {
            content.subtitle = "停止在后台加载..."
            content.body = "无法接收信息，直到重新打开应用程序。"
        }else if appDelegate.lang == "tw" {
            content.subtitle = "在後台停止加載..."
            content.body = "在重新打開應用程序之前無法接收消息。"
        }else if appDelegate.lang == "de" {
            content.subtitle = "Laden im Hintergrund gestoppt..."
            content.body = "Kann keine Nachrichten empfangen, bis die App erneut geöffnet wird."
        }else if appDelegate.lang == "es" {
            content.subtitle = "Se ha detenido la carga en segundo plano..."
            content.body = "No se pueden recibir mensajes hasta que se reabre la aplicación."
        }else if appDelegate.lang == "fr" {
            content.subtitle = "Arrêt du chargement en arrière-plan..."
            content.body = "Impossible de recevoir des messages tant que l'application n'est pas rouverte."
        }else if appDelegate.lang == "ja" {
            content.subtitle = "バックグラウンドでの読み込みが停止しました..."
            content.body = "再度アプリを開くまでメッセージを受信できません。"
        }else if appDelegate.lang == "pt" {
            content.subtitle = "Parou o carregamento em segundo plano..."
            content.body = "Não é possível receber mensagens até que a aplicação seja reaberta."
        }else if appDelegate.lang == "ru" {
            content.subtitle = "Перестало загружаться в фоновом режиме..."
            content.body = "Невозможно получать сообщения, пока приложение не будет открыто снова."
        }else if appDelegate.lang == "ko" {
            content.subtitle = "백그라운드에서 로드가 중지되었습니다..."
            content.body = "앱을 다시 열 때까지 메시지를 받을 수 없습니다."
        }else if appDelegate.lang == "tok" {
            content.subtitle = "pali li pini..."
            content.body = "ilo Sh1rga li open la pali li awen tawa open."
        }else{
            content.subtitle = "Stopped loading in background..."
            content.body = "Cannot receive messages until the app is reopened."
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
        UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
    }


}

