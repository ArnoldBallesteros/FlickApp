//
//  AppDelegate.swift
//  Movie Reviewer
//
//  Created by Arnold Ballesteros on 1/25/16.
//  Copyright © 2016 Arnold Ballesteros. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //Reference Window to Program Tab Bar
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        //Reference Storyboard to reference pieces in Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
      
        //Tab Bar Color
        UITabBar.appearance().barTintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
       
        //Now Playing Tab
        let nowPlayingNavigationController = storyboard.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
        
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MoviesViewController
        
        nowPlayingViewController.endpoint = "now_playing"
            //Create Tab Bar Button for now Playing
        nowPlayingNavigationController.tabBarItem.title = "Now Playing"
            //Create Tab Bar Icon for now Playing
        nowPlayingNavigationController.tabBarItem.image = UIImage(named: "Now Playing")
        //Top Rated Tab
        let topRatedNavigationController = storyboard.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
        
        let topRatedViewController = topRatedNavigationController.topViewController as! MoviesViewController
        
        topRatedViewController.endpoint = "top_rated"
            //Create Tab Bar Button for Top Rated
        topRatedNavigationController.tabBarItem.title = "Top Rated"
            //Create Tab Bar Icon for Top Rated
        topRatedNavigationController.tabBarItem.image = UIImage(named: "Top Rated")
        //Tab Bar Controller
        let tabBarController = UITabBarController()
            //Reference Controller to pass an array that contains Controllers that need tabs
        tabBarController.viewControllers = [nowPlayingNavigationController, topRatedNavigationController]
        
       
        //Set Initial View Controller - Root View Controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

