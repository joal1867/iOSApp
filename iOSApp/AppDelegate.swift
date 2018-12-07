
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //MemoListVO클래스 - 인스턴스 변수의 배열 생성
    var memoList = [MemoListVO]()
    
    var window: UIWindow?

    //앱이 시작될 때 호출되는 메소드
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let dataSync = DataSync()
        //비동기적으로 실행 - 스레드
        DispatchQueue.global(qos:.background).async {
            dataSync.downloadData()
        }
        return true
    }
    
    //앱이 실행을 종료할 때 호출되는 메소드
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    //앱이 백그라운드로 진행하기 직전에 호출되는 메소드
    //앱을 종료하는 경우도 있지만 전화등의 인터럽트가 발생한 경우에도 호출
    //실행 중에 필요한 데이터 저장(음악 재생의 경우는 재생 지점을 저장)
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    //앱이 포그라운드로 갈 때 호출되는 메소드
    //앞에서 저장한 데이터를 가지고 작업을 계속 수행
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    //앱이 다시 포그라운드에 진입한 후 호출되는 메소드
    //UI갱신, viewDidLoad를 강제로 호출해서 데이터를 갱신하고 출력하는 경우가 많습니다.
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    //앱이 종료될 때 호출되는 메소드
    //중요한 데이터를 서버에 저장하는 코드 작성
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //코어 데이터를 사용하는 프로젝트에서만 존재하는 코드 : 코어 데이터의 모든 내용을 반영합니다.
        self.saveContext()
    }
    

    // MARK: - Core Data stack
    //코어 데이터 프로젝트에만 존재하는 코드
    
    //코어데이터에 접근하기 위한 포인터를 생성
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "iOSApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    //코어 데이터의 내용을 저장하는 메소드
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

