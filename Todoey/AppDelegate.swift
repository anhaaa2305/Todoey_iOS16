//
//  AppDelegate.swift
//
import UIKit
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //print("The first path: \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)")
        print ("Realm Database: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        do {
            _ = try Realm()
        } catch {
            print("Error initalising Realm Data\(error)")
        }
        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
        print("App will terminate")
    }
}

