import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window?.overrideUserInterfaceStyle = .light
		guard let _ = (scene as? UIWindowScene) else { return }
	}
}

