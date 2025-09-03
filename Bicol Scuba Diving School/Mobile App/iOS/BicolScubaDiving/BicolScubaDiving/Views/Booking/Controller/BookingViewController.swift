//
//  BookingViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/3/25.
//

import UIKit

class BookingViewController: UIViewController {
    
    private let bookingView = BookingView()
    private let viewModel = BookingViewModel()
    private let package: PackageDetailViewModel
    private let datePicker = UIDatePicker()
    
    // MARK: - Init
    init(package: PackageDetailViewModel) {
        self.package = package
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = bookingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookingView.configureHeader(with: package)
        
        setupDatePicker()
        
        bookingView.onContinueTap = { [weak self] in
            guard let self = self else { return }
            let paymentVC = PaymentViewController()
            self.navigationController?.pushViewController(paymentVC, animated: true)
        }
        
        bookingView.activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.bookingView.activityIndicator.stopAnimating()
        }
    }
    
    private func setupDatePicker() {
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = .current
        
        datePicker.minimumDate = Date()
        
        bookingView.preferredDateTextField.inputView = datePicker
        
        let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: view.frame.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        toolbar.items = [flexibleSpace, doneButton]
        bookingView.preferredDateTextField.inputAccessoryView = toolbar
    }
    
    @objc private func didTapDone() {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        // Update the text field with the selected date
        bookingView.preferredDateTextField.text = formatter.string(from: datePicker.date)
        
        bookingView.preferredDateTextField.resignFirstResponder()
        
    }
}
