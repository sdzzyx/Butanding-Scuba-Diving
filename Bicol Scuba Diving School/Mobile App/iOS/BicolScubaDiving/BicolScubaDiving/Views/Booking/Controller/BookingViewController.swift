//
//  BookingViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/3/25.
//

import UIKit
import PhotosUI
import FirebaseAuth
import FirebaseFirestore

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
        
        loadUserInfo()
        
        bookingView.onContinueTap = { [weak self] in
            guard let self = self else { return }
            let paymentVC = PaymentViewController(package: self.package, viewModel: self.viewModel)
            self.navigationController?.pushViewController(paymentVC, animated: true)
        }
        
        bookingView.activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.bookingView.activityIndicator.stopAnimating()
        }
        
        bookingView.onPhoneNumberChanged = { [weak self] phone in
            self?.viewModel.phoneNumber = phone
            print("✅ Updated phone number in viewModel: \(phone)")
        }
        
        
        viewModel.onCompanionsUpdated = { [weak self] companions in
            guard let self = self else { return }
            let cards = self.bookingView.visibleCompanionCards()

            for (index, card) in cards.enumerated() {
                guard index < companions.count else { continue }  // ✅ Prevent crash

                let companion = companions[index]
                card.fullName = companion.fullName
                card.onFullNameChanged = { [weak self] name in
                    self?.viewModel.updateFullName(for: index + 1, name: name)
                }
            }

//            for (index, card) in self.bookingView.visibleCompanionCards().enumerated() {
//                let companion = companions[index]
//                card.fullName = companion.fullName
//                card.onFullNameChanged = { [weak self] name in
//                    self?.viewModel.updateFullName(for: index + 1, name: name)
//                }
//            }
        }

        
        viewModel.onNumberOfCompanionsChanged = { [weak self] count in
            guard let self = self else { return }
            self.bookingView.updateCompanions(count: count)
            
            // Update companion array inside the viewModel
                self.viewModel.updateCompanionCount(count)
            
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
    
    // when user proceeds to payment success
        func proceedToPaymentConfirmation() {
            let paymentVC = PaymentConfirmationViewController(package: package, viewModel: viewModel)
            navigationController?.pushViewController(paymentVC, animated: true)
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
                    
                    // ✅ Generate a unique file path for the uploaded image
                    let path: String
                    if companionIndex == 0 {
                        path = "certificates/main/\(UUID().uuidString).jpg"
                    } else {
                        path = "certificates/companions/\(UUID().uuidString).jpg"
                    }
                    
                    // ✅ Upload to Firebase Storage
                    StorageService.shared.uploadImage(uiImage, path: path) { result in
                        switch result {
                        case .success(let urlString):
                            DispatchQueue.main.async {
                                if companionIndex == 0 {
                                    // Update main certificate with Firebase URL
                                    self.viewModel.updateMainCertificate(url: urlString)
                                    self.bookingView.uploadCertificateButton.setTitle(
                                        AppConstant.Booking.certificateUploadedTitle,
                                        for: .normal
                                    )
                                    self.bookingView.uploadCertificateButton.setTitleColor(.systemGreen, for: .normal)
                                    self.bookingView.setMainCertificateUploaded(true)
                                } else {
                                    // Update companion certificate with Firebase URL
                                    self.viewModel.updateCertificate(for: companionIndex, url: urlString)
                                    if let card = self.bookingView.companionCard(at: companionIndex) {
                                        card.updateCertificateUploaded()
                                    }
                                }
                            }
                        case .failure(let error):
                            print("❌ Failed to upload image:", error.localizedDescription)
                        }
                    }
                }
            }
    }
    
    private func validateSlots(selectedCompanions: Int) {
        let totalSlots = package.totalSlot
        let bookedSlots = package.bookedSlot
        let remainingSlots = totalSlots - bookedSlots

        let totalPeople = 1 + selectedCompanions  // main user + companions

        if totalPeople > remainingSlots {
            // ❌ Show alert
            let alert = UIAlertController(
                title: "Slot Limit Exceeded",
                message: "Only \(remainingSlots) slots are available. Please reduce the number of companions.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)

            // ❌ Disable Continue button
            bookingView.continueButton.isEnabled = false
            bookingView.continueButton.backgroundColor = .primaryGrayLight
        }
//        else {
//            // ✔ Revalidate normally
//            bookingView.continueButton.isEnabled = true
//            bookingView.continueButton.backgroundColor = .primaryOrange
//        }
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
    
    private func loadUserInfo() {
        guard let user = Auth.auth().currentUser else { return }
        
        let uid = user.uid
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Failed to load user info:", error.localizedDescription)
                return
            }
            
            let data = snapshot?.data() ?? [:]
            
            let firstName = data["firstname"] as? String ?? ""
            let lastName = data["lastname"] as? String ?? ""
            let email = data["email"] as? String ?? user.email ?? ""
            let phone = data["phoneNumber"] as? String ?? ""
            
            let fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
            
            DispatchQueue.main.async {
                self.bookingView.configureUserInfo(name: fullName, email: email, phoneNumber: phone)
                self.viewModel.phoneNumber = phone
            }
        }
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
        
        // ✅ Validate slot availability
            validateSlots(selectedCompanions: selected)
    }
}
