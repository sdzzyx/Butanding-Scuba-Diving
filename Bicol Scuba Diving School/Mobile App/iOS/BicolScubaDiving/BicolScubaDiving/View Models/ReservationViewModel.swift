//
//  ReservationViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 8/26/25.
//

import UIKit

class ReservationViewModel {
    
    // MARK: - Properties
    let logoImage: UIImage?
    let titleText: String
    let tabTitles: [String]
    private(set) var selectedTabIndex: Int = 0
    
    var onTabChanged: ((Int) -> Void)?
    
    // MARK: - Init
    init() {
        self.logoImage = UIImage(named: AppConstant.Reservation.logo)
        self.titleText = AppConstant.Reservation.reservationTitle
        self.tabTitles = [
            AppConstant.Reservation.Tabs.active,
            AppConstant.Reservation.Tabs.completed,
            AppConstant.Reservation.Tabs.cancelled
        ]
        self.selectedTabIndex = 0
    }
    
    func selectTab(at index: Int) {
        guard index >= 0 && index < tabTitles.count else { return }
        selectedTabIndex = index
        onTabChanged?(index)
    }
}
