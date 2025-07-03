//
//  SplashVIewController.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/10/25.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController {
    
    var completionHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let logo = UIImageView(image: UIImage(named: "butanding-logo"))
        view.addSubview(logo)
        
        logo.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(300)
        }
        
        let versionLabel = UILabel()
        versionLabel.textAlignment = .center
        versionLabel.textColor = .gray
        versionLabel.font = .systemFont(ofSize: 14, weight: .light)
        
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "Version \(appVersion)"
        } else {
            versionLabel.text = "Unknown Version"
        }
        
        view.addSubview(versionLabel)
        
        versionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        // Delay transition to Next Screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.completionHandler?()
        }
    }
}
