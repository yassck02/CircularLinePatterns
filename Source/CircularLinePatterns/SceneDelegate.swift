//
//  SceneDelegate.swift
//  Life
//
//  Created by Connor yass on 5/18/20.
//  Copyright © 2020 Chinaberry Tech, LLC. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions)
    {
        let content = ContentView(pattern: TEST_PATRN, gradient: TEST_GRAD)
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: content)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
