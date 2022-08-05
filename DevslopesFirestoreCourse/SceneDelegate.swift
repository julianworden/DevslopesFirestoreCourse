//
//  SceneDelegate.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/4/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let mainViewController = MainViewController()
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)

        mainNavigationController.navigationBar.barTintColor = Constants.yellowColor
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = Constants.grayColor
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(
                red: 245/255,
                green: 130/255,
                blue: 12/2255,
                alpha: 1
            )
        ]
        UINavigationBar.appearance().tintColor = Constants.yellowColor
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance

        window?.rootViewController = mainNavigationController
        window?.makeKeyAndVisible()
    }
}
