//
//  AppDelegate.swift
//  iOSVideoPlug
//
//  Created by Rahul Panzade on 29/03/19.
//  Copyright © 2019 Omni-Bridge. All rights reserved.
//

import UIKit
import AVKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if UserDefaults.standard.value(forKey: "StartURLFromServer") == nil{
            self.callToSetConfigeUrl()
        }else{
            self.loadInitialViewController()
        }
        IQKeyboardManager.shared.enable = true
        turnOnSoundModeWhenInSilenceMode()
        return true
    }
    
    func turnOnSoundModeWhenInSilenceMode(){
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK:- Confige URL
    
    /// Uset to set confige url from server
    private func callToSetConfigeUrl(){
        if Generals.isConnectedToNetwork(){
            if GetApiConfig.execute(){
                self.loadInitialViewController()
            } else {
                if (UserDefaults.standard.value(forKey: "StartURLFromServer") as! NSString?) == nil{
                    showErrorAlert(message: SOMETHING_WENT_WRONG_MSG)
                }else{
                    self.loadInitialViewController()
                }
            }
        }else{
            if (UserDefaults.standard.value(forKey: "StartURLFromServer") as! NSString?) == nil{
                self.showErrorAlert(message: NOINTERNET_MESSAGE)
                
            }else{
                self.loadInitialViewController()
            }
        }
    }
    
    /// Used to load initial view controller
    private func loadInitialViewController(){
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController : UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "HomeNavigationController") as! UINavigationController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    /// Used to show Error alert
    func showErrorAlert(message : String){
        let alertVC = UIAlertController(title: "Oops" , message: message, preferredStyle: UIAlertController.Style.alert)
        let tryAgain = UIAlertAction(title: "Try again", style: .default) { (_) -> Void in
            self.callToSetConfigeUrl()
        }
        
        alertVC.addAction(tryAgain)
        DispatchQueue.main.async {
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindow.Level.alert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(alertVC, animated: true, completion: nil)
        }
    }
    
}

