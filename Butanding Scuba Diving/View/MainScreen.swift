//
//  MainScreen.swift
//  Butanding Scuba Diving
//
//  Created by Lenard Cortuna on 5/29/25.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange

        let label = UILabel()
        label.text = "Welcome to the Main Screen!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
