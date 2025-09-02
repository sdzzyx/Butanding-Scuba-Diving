//
//  ReservationViewController.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 7/9/25.
//

import UIKit

class ReservationViewController: UIViewController {
    
    // MARK: - Properties
    private let reservationView = ReservationView()
    private let reservationViewModel = ReservationViewModel()
    private let packageViewModel = PackageViewModel()
    
    // Filtered bookings by tab
    private var activePackages: [DivePackage] = []
    private var completedPackages: [DivePackage] = []
    private var cancelledPackages: [DivePackage] = []
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = reservationView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupTableView()
        packageViewModel.fetchPackages()
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Setup
    private func setupBindings() {
        reservationView.configure(with: reservationViewModel)
        
        // Tab change (Active / Completed / Cancelled)
        reservationViewModel.onTabChanged = { [weak self] _ in
            self?.reservationView.tableView.reloadData()
        }
        
        // Data loading state
        packageViewModel.onLoadingStateChanged = { [weak self] isLoading in
            if isLoading {
                self?.reservationView.activityIndicator.startAnimating()
            } else {
                self?.reservationView.activityIndicator.stopAnimating()
            }
        }
        
        // When Firestore packages are loaded
        packageViewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            
            let allPackages = self.packageViewModel.packages
            
            // Active
            if let last = allPackages.last {
                self.activePackages = [last]
            } else {
                self.activePackages = []
            }
            
            // Completed sample Data for demo
            self.completedPackages = Array(allPackages.dropFirst().prefix(3))
            
            // Cancelled, Data from the list for now
            self.cancelledPackages = Array(allPackages.prefix(1))
            
            self.reservationView.tableView.reloadData()
        
        }
    }
    
    private func setupTableView() {
        reservationView.tableView.dataSource = self
        reservationView.tableView.delegate = self
        reservationView.tableView.register(ReservationCell.self, forCellReuseIdentifier: "ReservationCell")
        reservationView.tableView.separatorStyle = .none
        reservationView.tableView.backgroundColor = .clear
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ReservationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch reservationViewModel.selectedTabIndex {
        case 0: return activePackages.count
        case 1: return completedPackages.count
        case 2: return cancelledPackages.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell", for: indexPath) as? ReservationCell else {
            return UITableViewCell()
        }
        
        let package: DivePackage
        switch reservationViewModel.selectedTabIndex {
        case 0: package = activePackages[indexPath.row]
        case 1: package = completedPackages[indexPath.row]
        case 2: package = cancelledPackages[indexPath.row]
        default: fatalError("Invalid tab index")
        }
        
        cell.configure(with: package)
        return cell
    }
    
    // Custom card size
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
}
