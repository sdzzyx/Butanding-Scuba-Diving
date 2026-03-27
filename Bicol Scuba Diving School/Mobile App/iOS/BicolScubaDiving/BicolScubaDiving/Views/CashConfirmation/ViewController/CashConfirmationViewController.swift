//
//  CashConfirmationViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/30/25.
//

import UIKit

class CashConfirmationViewController: UIViewController {
    
    private let confirmationView = CashConfirmationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(confirmationView)
        confirmationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        confirmationView.homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func homeButtonTapped() {
        // Example: Navigate to Home screen
        navigationController?.popToRootViewController(animated: true)
        // OR present a HomeViewController if you don't use navigation
    }
}
