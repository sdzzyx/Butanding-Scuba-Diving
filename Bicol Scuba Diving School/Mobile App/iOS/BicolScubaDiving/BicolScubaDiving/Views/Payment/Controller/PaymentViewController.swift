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
        setupTableView()
        setupBindings()
        viewModel.fetchPaymentMethods()
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
