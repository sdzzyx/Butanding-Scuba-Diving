//
//  PaymentViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/3/25.
//

import Foundation

class PaymentViewModel {
    
    // MARK: - Properties
    private(set) var paymentMethods: [PaymentMethod] = PaymentMethod.allCases
    private(set) var selectedMethod: PaymentMethod?
    
    var isLoading: Bool = false {
        didSet {
            onLoadingStateChange?(isLoading)
        }
    }
    
    // MARK: - Callbacks for UI Binding
    var onLoadingStateChange: ((Bool) -> Void)?
    var onPaymentMethodsLoaded: (() -> Void)?
    var onMethodSelected: ((PaymentMethod) -> Void)?
    
    // MARK: - Methods
    func fetchPaymentMethods() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            self.onPaymentMethodsLoaded?()
        }
    }
    
    func selectMethod(_ method: PaymentMethod) {
        selectedMethod = method
        onMethodSelected?(method)
    }
}
