// Desarrollado por: Sheila Diaz
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // La ventana y la pantalla inicial las crea Main.storyboard
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}
