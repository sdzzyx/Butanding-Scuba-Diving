//
//  TermsViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/27/25.
//

import UIKit

class TermsViewController: UIViewController {
    
    private let termsView = TermsView()
    private let viewModel: TermsViewModel
    
    // Callback when user accepts
    var onAccepted: (() -> Void)?
    
    init(viewModel: TermsViewModel = TermsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = termsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Terms & Privacy Policy"
        
        termsView.configure(with: viewModel)
        termsView.acceptButton.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
    }
    
    @objc private func handleAccept() {
        dismiss(animated: true) {
            self.onAccepted?()
        }
    }
}
