//
//  AppDelegate.swift
//  Destini
//
import UIKit
import RealmSwift
import CoreData
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
        self.saveContext()
    }
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror),\(nserror.userInfo)")
            }
        }
    }

}

