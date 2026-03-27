//
//  PaymentViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/3/25.
//

import UIKit
import SafariServices

class PaymentViewController: UIViewController {
    
    private let paymentView = PaymentView()
    private let viewModel = PaymentViewModel()
    private let paymentService = PaymentService()
    
    private let bookingViewModel: BookingViewModel
    
    var safariVC: SFSafariViewController?
    
    // MARK: - Package Data
        private let package: PackageDetailViewModel
    
    // MARK: - Init
        init(package: PackageDetailViewModel, viewModel: BookingViewModel) {
            self.package = package
            self.bookingViewModel = viewModel
            super.init(nibName: nil, bundle: nil)
            
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    //var bookingAmount: Double = 100.0 // example only, can be passed from Booking screen
    
    // MARK: - Lifecyclenb
    override func loadView() {
        self.view = paymentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
        viewModel.fetchPaymentMethods()
        
        paymentView.continueButton.addTarget(self, action: #selector(confirmPaymentTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePaymentSuccess),
            name: .paymentSuccess,
            object: nil
        )
    }
    
    private func setupTableView() {
        paymentView.tableView.register(UITableViewCell.self,
                                       forCellReuseIdentifier: PaymentMethodCell.identifier)
        paymentView.tableView.register(PaymentSectionHeaderView.self,
                                       forHeaderFooterViewReuseIdentifier: PaymentSectionHeaderView.identifier)
        paymentView.tableView.dataSource = self
        paymentView.tableView.delegate = self
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.paymentView.tableView.isHidden = true
                    self?.paymentView.activityIndicator.startAnimating()
                } else {
                    self?.paymentView.tableView.isHidden = false
                    self?.paymentView.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.onPaymentMethodsLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.paymentView.tableView.reloadData()
            }
        }
        
        viewModel.onMethodSelected = { selected in
            print("Selected method: \(selected.type)")
        }
    }
}

extension PaymentViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PaymentMethodSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = PaymentMethodSection(rawValue: section)!
        return viewModel.methods(for: sectionType).count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = PaymentMethodSection(rawValue: section),
              let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: PaymentSectionHeaderView.identifier) as? PaymentSectionHeaderView else {
            return nil
        }
        header.configure(with: sectionType.title)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = PaymentMethodSection(rawValue: indexPath.section)!
        let method = viewModel.methods(for: sectionType)[indexPath.row]
        let cell = PaymentMethodCell(method: method)
        
        cell.methodRow.radioButton.isSelected = (viewModel.selectedMethod?.type == method.type)
        
        cell.methodRow.radioButton.tag = indexPath.section * 100 + indexPath.row
        cell.methodRow.radioButton.addTarget(self, action: #selector(selectMethod(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc private func selectMethod(_ sender: UIButton) {
        let section = sender.tag / 100
        let row = sender.tag % 100
        guard let sectionType = PaymentMethodSection(rawValue: section) else { return }
        
        let method = viewModel.methods(for: sectionType)[row]
        viewModel.selectMethod(method)
        paymentView.setContinueButtonEnabled(true)
        paymentView.tableView.reloadData()
    }
}
    

// MARK: - Payment Logic
extension PaymentViewController {
    
    @objc private func handlePaymentSuccess() {
        let paymentVc = PaymentConfirmationViewController(package: package, viewModel: bookingViewModel)
        navigationController?.pushViewController(paymentVc, animated: true)
    }

    @objc private func confirmPaymentTapped() {
        guard let selectedMethod = viewModel.selectedMethod else { return }
        
        switch selectedMethod.type {
        case .cash:
            let vc = CashConfirmationViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        case .gcash:
            startGcashPayment()
            
        case .paypal:
            print("Implement PayPal later")
        }
    }
    
    private func startGcashPayment() {
        paymentView.continueButton.isEnabled = false
        paymentView.activityIndicator.startAnimating()
        
        let amount = Double(package.price.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0.0
        print("💰 GCash Payment - packageId: \(package.id), price: \(package.price), amount: \(amount)")
        let description = package.title
        let packageId = package.id // assuming DivePackage has `id`
        
        paymentService.createGcashPayment(packageId: packageId, amount: amount, description: description, email: "testuser@example.com") { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.paymentView.activityIndicator.stopAnimating()
                self.paymentView.continueButton.isEnabled = true
                
                switch result {
                case .success(let redirectUrl):
                    guard let url = URL(string: redirectUrl) else { return }
                    let safariVC = SFSafariViewController(url: url)
                    safariVC.delegate = self
                    self.safariVC = safariVC
                    self.present(safariVC, animated: true)
                    
                case .failure(let error):
                    self.showError(message: "Payment creation failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Safari Delegate
extension PaymentViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true)
    }
}

// MARK: - Handle Deep Link Callback
extension PaymentViewController {
    func handlePaymentResult(from url: URL) {
        safariVC?.dismiss(animated: true)
        
        if url.absoluteString.contains("payment-success") {
            let vc = PaymentConfirmationViewController(package: package, viewModel: bookingViewModel)
            navigationController?.pushViewController(vc, animated: true)
        } else if url.absoluteString.contains("payment-failed") {
            showError(message: "GCash payment failed. Please try again.")
        }
    }
}
