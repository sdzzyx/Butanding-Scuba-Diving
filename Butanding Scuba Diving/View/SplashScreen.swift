//
//  SplashScreen.swift
//  Butanding Scuba Diving
//
//  Created by Lenard Cortuna on 5/29/25.
//

import UIKit

class SplashViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let logo = UIImageView(image: UIImage(named: "butanding-logo"))
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)

        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logo.widthAnchor.constraint(equalToConstant: 300),
            logo.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // Delay transition to main screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let mainVC = LoginScreen()
                let navigationController = UINavigationController(rootViewController: mainVC)
                
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        }
    }
}
