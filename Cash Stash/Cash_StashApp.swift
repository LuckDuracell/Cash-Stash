//
//  Cash_StashApp.swift
//  Cash Stash
//
//  Created by Luke Drushell on 7/25/21.
//

import SwiftUI

@main
struct Cash_StashApp: App {
    var body: some Scene {
        WindowGroup {
            ContentViewV2()
        }
    }
}

extension UITabBarController {
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let standardAppearance = UITabBarAppearance()

        standardAppearance.backgroundColor = .red
        standardAppearance.shadowColor = .green

        standardAppearance.configureWithOpaqueBackground()
        
        tabBar.standardAppearance = standardAppearance
    }
}
