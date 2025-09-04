//
//  PaymentViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/3/25.
//

import UIKit

class PaymentViewController: UIViewController {
    
    private let paymentView = PaymentView()
    private let viewModel = PaymentViewModel()
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = paymentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.fetchPaymentMethods()
        setupActions()
    }
    
    // MARK: - Bindings with ViewModel
    private func setupBindings() {

        viewModel.onLoadingStateChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.paymentView.activityIndicator.startAnimating()
                } else {
                    self?.paymentView.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.onPaymentMethodsLoaded = { [weak self] in
            guard let self = self else { return }
            print("Loaded methods: \(self.viewModel.paymentMethods)")
        }
        
        viewModel.onMethodSelected = { selected in
            print("Selected: \(selected)")
        }
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        paymentView.cashRow.radioButton.addTarget(self, action: #selector(selectCash), for: .touchUpInside)
        paymentView.gcashRow.radioButton.addTarget(self, action: #selector(selectGCash), for: .touchUpInside)
        paymentView.paypalRow.radioButton.addTarget(self, action: #selector(selectPayPal), for: .touchUpInside)
    }
    
    // MARK: - Selection Handlers
    @objc private func selectCash() {
        updateSelection(selected: paymentView.cashRow)
        viewModel.selectMethod(.cash)
    }
    
    @objc private func selectGCash() {
        updateSelection(selected: paymentView.gcashRow)
        viewModel.selectMethod(.gcash)
    }
    
    @objc private func selectPayPal() {
        updateSelection(selected: paymentView.paypalRow)
        viewModel.selectMethod(.paypal)
    }
    
    private func updateSelection(selected row: PaymentMethodRow) {
        
        [paymentView.cashRow, paymentView.gcashRow, paymentView.paypalRow].forEach {
            $0.radioButton.isSelected = ($0 == row)
        }
        
        let anySelected = [paymentView.cashRow, paymentView.gcashRow, paymentView.paypalRow]
            .contains { $0.radioButton.isSelected }
        
        paymentView.setContinueButtonEnabled(anySelected)
    }
}
