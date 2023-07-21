import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		Realm.Configuration.defaultConfiguration = Realm.Configuration(
			schemaVersion: 6
		)
		return true
	}
}

