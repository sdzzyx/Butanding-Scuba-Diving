//
//  PaymentViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/3/25.
//

import Foundation

enum PaymentMethodSection: Int, CaseIterable {
    case cash
    case moreOptions
    
    var title: String {
        switch self {
        case .cash: return AppConstant.Payment.cashTitle
        case .moreOptions: return AppConstant.Payment.morePaymentOptionsTitle
        }
    }
}


class PaymentViewModel {
    
    // MARK: - Properties
    private(set) var paymentMethodsBySection: [PaymentMethodSection: [PaymentMethod]] = [:]
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
            
            // Group methods by section
            self.paymentMethodsBySection = [
                .cash: [
                    PaymentMethod(type: .cash,
                                  iconName: AppConstant.Payment.cashLogo,
                                  title: AppConstant.Payment.cashPaymentTitle,
                                  iconSize: 30)
                ],
                .moreOptions: [
                    PaymentMethod(type: .gcash,
                                  iconName: AppConstant.Payment.gcashLogo,
                                  title: nil,
                                  iconSize: 100),
                    PaymentMethod(type: .paypal,
                                  iconName: AppConstant.Payment.paypalLogo,
                                  title: nil,
                                  iconSize: 100)
                ]
            ]
            
            self.onPaymentMethodsLoaded?()
        }
    }
    
    func methods(for section: PaymentMethodSection) -> [PaymentMethod] {
        return paymentMethodsBySection[section] ?? []
    }
    
    func selectMethod(_ method: PaymentMethod) {
        selectedMethod = method
        onMethodSelected?(method)
    }
}
