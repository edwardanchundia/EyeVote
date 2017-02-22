

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        let tabBarController = UITabBarController()
        let loginVC = LogInViewController()
        let galleryVC = GalleryViewController()
        let uploadVC = UploadViewController()
        //let navController1 = UINavigationController(rootViewController: galleryVC)
        let navController2 = UINavigationController(rootViewController: uploadVC)
        //let navController3 = UINavigationController(rootViewController: loginVC)
        
        let navController1 = UINavigationController(rootViewController: loginVC)
        let navController3 = UINavigationController(rootViewController: galleryVC)
        tabBarController.viewControllers = [navController1, navController2, navController3]
        UITabBar.appearance().tintColor = EyeVoteColor
            .accentColor
        loginVC.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "user_icon"), tag: 0)
        galleryVC.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "gallery_icon"), tag: 1)
        uploadVC.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "camera_icon"), tag: 2)
        
        tabBarController.tabBar.barTintColor = EyeVoteColor.lightPrimaryColor
        
        navController1.navigationBar.barTintColor = EyeVoteColor.darkPrimaryColor
        navController1.navigationBar.topItem?.title = "CATEGORIES"
        
        navController2.navigationBar.barTintColor = EyeVoteColor.darkPrimaryColor
        navController2.navigationBar.topItem?.title = "UPLOAD"
        
        
        navController3.navigationBar.barTintColor = EyeVoteColor.darkPrimaryColor
        navController3.navigationBar.topItem?.title = "PROFILE"
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: EyeVoteColor.textIconColor]
        
        let navigationBar = UINavigationController()
        navigationBar.setToolbarHidden(false, animated: false)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarController
        //self.window?.rootViewController = GalleryDetailViewController()
        //self.window?.rootViewController = GalleryCollectionViewController()
        self.window?.makeKeyAndVisible()
        
        
        
        return true
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
    
    
}

