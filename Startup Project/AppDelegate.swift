//
//  AppDelegate.swift
//  Startup Project
//
//  Created by Swapnanil Dhol on 9/2/19.
//  Copyright © 2019 Swapnanil Dhol. All rights reserved.
//

import UIKit
import ApiAI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        //Configuration for
        
        let configuration = AIDefaultConfiguration()
        configuration.clientAccessToken = "25374d9d9446453d85c34d091e570a20"
        
        let apiai = ApiAI.shared()
        apiai?.configuration = configuration
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
   
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

