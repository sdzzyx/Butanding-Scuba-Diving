//
//  PaymentViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/3/25.
//

import Foundation

class PaymentViewModel {
    
    // MARK: - Properties
    private(set) var paymentMethods: [String] = [
        AppConstant.Payment.cashTitle,
        AppConstant.Payment.morePaymentOptionsTitle
    ]
    
    private(set) var selectedMethod: String?
    
    var isLoading: Bool = false {
        didSet {
            onLoadingStateChange?(isLoading)
        }
    }
    
    // MARK: - Callbacks for UI Binding
    var onLoadingStateChange: ((Bool) -> Void)?
    var onPaymentMethodsLoaded: (() -> Void)?
    var onMethodSelected: ((String) -> Void)?
    
    // MARK: - Methods
    func fetchPaymentMethods() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            self.onPaymentMethodsLoaded?()
        }
    }
    
    func selectMethod(at index: Int) {
        guard index < paymentMethods.count else { return }
        selectedMethod = paymentMethods[index]
        onMethodSelected?(selectedMethod!)
    }
}
