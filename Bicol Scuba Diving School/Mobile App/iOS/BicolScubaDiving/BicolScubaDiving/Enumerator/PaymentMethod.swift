//
//  PaymentMethod.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/4/25.
//
import UIKit

enum PaymentMethodType: CaseIterable {
    case cash
    case gcash
    case paypal
    
}

struct PaymentMethod {
    let type: PaymentMethodType
    let iconName: String
    let title: String?
    let iconSize: CGFloat
}
