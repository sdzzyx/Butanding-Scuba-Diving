//
//  BookingViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/3/25.
//

import UIKit
import PhotosUI

class BookingViewController: UIViewController, PHPickerViewControllerDelegate {
    
    private let bookingView = BookingView()
    private let viewModel = BookingViewModel()
    private let package: PackageDetailViewModel
    private let datePicker = UIDatePicker()
    
    private let companionPicker = UIPickerView()
    private let companionNumbers = Array(0...20)
    private var currentUploadIndex: Int?
    
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
        
        setupCompanionPicker()
        
        bookingView.onContinueTap = { [weak self] in
            guard let self = self else { return }
            let paymentVC = PaymentViewController()
            self.navigationController?.pushViewController(paymentVC, animated: true)
        }
        
        bookingView.activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.bookingView.activityIndicator.stopAnimating()
        }
        
        viewModel.onNumberOfCompanionsChanged = { [weak self] count in
            guard let self = self else { return }
            self.bookingView.updateCompanions(count: count)
            
        }
        
        bookingView.onUploadTapped = { [weak self] index in
            self?.presentPhotoPicker(for: index)
        }
        
        viewModel.onMainCertificateUpdated = { [weak self] _ in
            self?.bookingView.uploadCertificateButton.setTitle(AppConstant.Booking.certificateUploadedTitle, for: .normal)
            self?.bookingView.uploadCertificateButton.setTitleColor(.systemGreen, for: .normal)
            self?.bookingView.setMainCertificateUploaded(true)
        }
    }
    
    private func presentPhotoPicker(for index: Int) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        currentUploadIndex = index
        present(picker, animated: true)
    }
    
    // MARK: - PHPicker Delegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        guard let provider = results.first?.itemProvider else { return }
        
        let companionIndex = currentUploadIndex ?? 0
        currentUploadIndex = nil
        
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self, let uiImage = image as? UIImage else { return }
                
                DispatchQueue.main.async {
                    if companionIndex == 0 {
                        self.viewModel.updateMainCertificate(image: uiImage)
                    } else {
                        self.viewModel.updateCertificate(for: companionIndex, image: uiImage)
                        if let card = self.bookingView.companionCard(at: companionIndex) {
                            card.updateCertificateUploaded()
                        }
                    }
                }
            }
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
    
    private func setupCompanionPicker() {
        companionPicker.dataSource = self
        companionPicker.delegate = self
        bookingView.numberOfCompanionsTextField.inputView = companionPicker
        
        let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: view.frame.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapCompanionDone))
        toolbar.items = [flexibleSpace, doneButton]
        bookingView.numberOfCompanionsTextField.inputAccessoryView = toolbar
    }
    
    @objc private func didTapCompanionDone() {
        bookingView.numberOfCompanionsTextField.resignFirstResponder()
    }
    
}
extension BookingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        companionNumbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(companionNumbers[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = companionNumbers[row]
        let textField = bookingView.numberOfCompanionsTextField
        
        if selected == 0 {
            textField.text = nil
            textField.font = UIFont.italicSystemFont(ofSize: 13)
            textField.textColor = .primaryGrayDisableText
        } else {
            textField.text = "\(selected)"
            textField.font = UIFont.roboto(.bold, size: 13)
            textField.textColor = .primaryOrange
        }
        
        viewModel.numberOfCompanions = selected
    }
}
