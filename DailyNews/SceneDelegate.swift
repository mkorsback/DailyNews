//
//  SceneDelegate.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-08.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    window?.windowScene = windowScene

    // forcing light mode until we have added support for dark mode
    if #available(iOS 13.0, *) {
      window?.overrideUserInterfaceStyle = .light
    }

    let headlinesVC = UINavigationController(rootViewController: HeadlinesViewController())
    headlinesVC.navigationBar.prefersLargeTitles = true
    headlinesVC.tabBarItem = UITabBarItem(title: "Headlines", image: UIImage(systemName: "globe"), tag: 0)

//    let searchVC = UINavigationController(rootViewController: SearchViewController())
//    searchVC.navigationBar.prefersLargeTitles = true
//    searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)

    let sourcesVC = UINavigationController(rootViewController: SourcesViewController())
    sourcesVC.navigationBar.prefersLargeTitles = true
    sourcesVC.tabBarItem = UITabBarItem(title: "Sources", image: UIImage(systemName: "building.columns"), tag: 2)

    let tabBar = UITabBarController()
    tabBar.tabBar.tintColor = .black
    tabBar.viewControllers = [
      headlinesVC,
//      searchVC,
      sourcesVC,
    ]

    window?.rootViewController = tabBar
    window?.makeKeyAndVisible()
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }

}
