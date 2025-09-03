//
//  PackageDetailViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 8/26/25.
//

import UIKit

final class PackageDetailViewController: UIViewController {
    
    private let detailView = PackageDetailView()
    private let viewModel: PackageDetailViewModel
    
    // MARK: - Init
    init(viewModel: PackageDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.configure(with: viewModel)
        setupNavigation()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show nav bar (transparent) when detail opens
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Hide nav bar again when going back to package list
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup
    private func setupNavigation() {
        // Transparent nav bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        // Custom back button
        if let logo = UIImage(named: AppConstant.PackagesDetail.logo)?.withRenderingMode(.alwaysOriginal) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: logo,
                style: .plain,
                target: self,
                action: #selector(backTapped)
            )
        }
    }
    
    private func setupActions() {
        detailView.bookButton.addTarget(self, action: #selector(bookTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func bookTapped() {
        // Navigate to booking flow
        let bookingVC = BookingViewController(package: viewModel)
        navigationController?.pushViewController(bookingVC, animated: true)
    }
}
