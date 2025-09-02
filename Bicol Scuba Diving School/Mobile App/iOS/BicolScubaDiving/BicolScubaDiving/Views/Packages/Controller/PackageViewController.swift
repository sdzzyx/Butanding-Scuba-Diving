//
//  PackageViewController.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 7/9/25.
//

import UIKit

final class PackageViewController: UIViewController {
    
    private let viewModel = PackageViewModel()
    private let packageView = PackageView()
    
    override func loadView() {
        view = packageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
        viewModel.fetchPackages()
    }
    
    private func setupTableView() {
        packageView.tableView.register(PackagesCell.self, forCellReuseIdentifier: PackagesCell.identifier)
        packageView.tableView.dataSource = self
        packageView.tableView.delegate = self
    }
    
    private func setupBindings() {
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.packageView.activityIndicator.startAnimating()
                } else {
                    self?.packageView.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.packageView.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension PackageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PackagesCell.identifier, for: indexPath) as? PackagesCell else {
            return UITableViewCell()
        }
        let package = viewModel.package(at: indexPath.row)
        cell.configure(with: package)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PackageViewController: UITableViewDelegate {
    // Spacing between cards
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let package = viewModel.package(at: indexPath.row)
        let detailVM = PackageDetailViewModel(package: package)
        let detailVC = PackageDetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
