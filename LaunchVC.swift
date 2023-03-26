//
//  LaunchVC.swift
//  NewFantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/25/23.
//

import Foundation
import SwiftUI

class LaunchVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let splashScreenView = BaseballDiamondAnimationView()
        let hostingController = UIHostingController(rootView: splashScreenView)

//        addChild(hostingController)
//        view.addSubview(hostingController.view)
////            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
//
//        hostingController.view.frame = view.bounds
        
//            NSLayoutConstraint.activate([
//                hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//                hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
//                hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//            ])

        view.backgroundColor = .green

//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                // Replace the splash screen with the main view of your app
//                let mainView = MainView()
//                let mainHostingController = UIHostingController(rootView: mainView)
//
//                self.view.window?.rootViewController = mainHostingController
//            }
    }
}
