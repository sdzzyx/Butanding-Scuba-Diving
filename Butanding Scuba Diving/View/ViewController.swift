//
//  ViewController.swift
//  Butanding Scuba Diving
//
//  Created by Lenard Cortuna on 5/29/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        let helloLabel = UILabel()
                helloLabel.text = "Hello World"
                helloLabel.textColor = .white
                helloLabel.font = UIFont.systemFont(ofSize: 24)
                helloLabel.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(helloLabel)

                // Center the label in the view
                NSLayoutConstraint.activate([
                    helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    helloLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
        // Do any additional setup after loading the view.
    }
}

