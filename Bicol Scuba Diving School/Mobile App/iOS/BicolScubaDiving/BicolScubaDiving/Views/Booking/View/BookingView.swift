//
//  BookingView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/3/25.
//

import UIKit
import SnapKit
import Kingfisher

class BookingView: UIView {
    
    var onContinueTap: (() -> Void)?
    
    // MARK: - UI Components
    let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AppConstant.Booking.logo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstant.Booking.bookingTitle
        label.font = UIFont.roboto(.bold, size: 28)
        label.textColor = .primaryBlueColor
        return label
    }()
    
    let packageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let packageTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.roboto(.bold, size: 18)
        label.textColor = .primaryBlueColor
        label.numberOfLines = 2
        return label
    }()
    
    let packageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.roboto(.regular, size: 14)
        label.textColor = .primaryGrayTextColor
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let continueButton: CustomButton = {
        let button = CustomButton()
        button.setTitle(AppConstant.Booking.continueButtonTitle, for: .normal)
        button.isEnabled = false
        button.backgroundColor = .primaryGrayLight
        return button
    }()
    
    private static func makeSectionTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.roboto(.bold, size: 15)
        label.textColor = .primaryBlueColor
        return label
    }
    
    private func makeTextFieldRow(title: String, placeholder: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.roboto(.medium, size: 13)
        titleLabel.textColor = .black
        
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.textAlignment = .right
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.italicSystemFont(ofSize: 13),
            .foregroundColor: UIColor.primaryGrayDisableText
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        
        textField.font = UIFont.italicSystemFont(ofSize: 13)
        textField.textColor = .primaryGrayDisableText
        
        let rowStack = UIStackView(arrangedSubviews: [titleLabel, textField])
        rowStack.axis = .horizontal
        rowStack.distribution = .fillProportionally
        
        return rowStack
    }
    
    let informationTitleLabel: UILabel
    let nameRow: UIStackView
    let emailRow: UIStackView
    let infoStack = UIStackView()
    
    let dateReservationTitleLabel: UILabel
    var preferredDateRow: UIStackView
    var preferredDateTextField: UITextField
    let dateStack = UIStackView()
    
    let additionalInformationTitleLabel: UILabel
    var mobileNumberRow: UIStackView
    var mobileNumberTextField: UITextField
    let additionalStack = UIStackView()
    
    let amountTitleLabel: UILabel
    let priceRow: UIStackView
    let amountStack = UIStackView()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .primaryOrange
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let topDividerView: UIView
    private let infoDividerView: UIView
    private let dateDividerView: UIView
    private let additionalDividerView: UIView
    private let amountDividerView: UIView
    
    // MARK: - Init
    override init(frame: CGRect) {
        
        self.topDividerView = BookingView.makeDivider()
        self.infoDividerView = BookingView.makeDivider()
        self.dateDividerView = BookingView.makeDivider()
        self.additionalDividerView = BookingView.makeDivider()
        self.amountDividerView = BookingView.makeDivider()
        
        self.informationTitleLabel = BookingView.makeSectionTitle(AppConstant.Booking.informationTitle)
        self.dateReservationTitleLabel = BookingView.makeSectionTitle(AppConstant.Booking.dateReservationTitle)
        self.additionalInformationTitleLabel = BookingView.makeSectionTitle(AppConstant.Booking.additionalInformationTitle)
        self.amountTitleLabel = BookingView.makeSectionTitle(AppConstant.Booking.amountTitle)
        
        self.nameRow = BookingView.makeRow(title: AppConstant.Booking.nameTitle,
                                           placeholder: AppConstant.Booking.namePlaceholder)
        self.emailRow = BookingView.makeRow(title: AppConstant.Booking.emailTitle,
                                            placeholder: AppConstant.Booking.emailPlaceholder)
        self.priceRow = BookingView.makeRow(title: AppConstant.Booking.priceTitle,
                                            placeholder: "₱ 0.00")
        
        self.preferredDateRow = UIStackView()
        self.preferredDateTextField = UITextField()
        self.mobileNumberRow = UIStackView()
        self.mobileNumberTextField = UITextField()
        
        super.init(frame: frame)
        
        let preferredDateStack = makeTextFieldRow(title: AppConstant.Booking.preferreDateTitle,
                                                  placeholder: AppConstant.Booking.preferredDatePlaceholder)
        self.preferredDateRow = preferredDateStack
        self.preferredDateTextField = preferredDateStack.arrangedSubviews.last as! UITextField
        
        let mobileNumberStack = makeTextFieldRow(title: AppConstant.Booking.mobileNumberTitle,
                                                 placeholder: AppConstant.Booking.mobileNumberPlaceholder)
        self.mobileNumberRow = mobileNumberStack
        self.mobileNumberTextField = mobileNumberStack.arrangedSubviews.last as! UITextField
        
        setupUI()
        setupTextFieldDelegates()
        setupGestureRecognizer()
        
        // Continue Button function
        continueButton.addTarget(self, action: #selector(handleContinueTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleContinueTap() {
        onContinueTap?()
    }
    
    private static func makeDivider() -> UIView {
        let view = UIView()
        view.backgroundColor = .primaryGrayLight
        return view
    }
    
    private static func makeRow(title: String, placeholder: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.roboto(.medium, size: 13)
        titleLabel.textColor = .black
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = UIFont.roboto(.regular, size: 13)
        placeholderLabel.textColor = .primaryOrange
        placeholderLabel.textAlignment = .right
        
        let rowStack = UIStackView(arrangedSubviews: [titleLabel, placeholderLabel])
        rowStack.axis = .horizontal
        rowStack.distribution = .fillEqually
        return rowStack
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        // Setup stacks
        infoStack.axis = .vertical
        infoStack.spacing = 8
        infoStack.addArrangedSubview(nameRow)
        infoStack.addArrangedSubview(emailRow)
        
        dateStack.axis = .vertical
        dateStack.spacing = 8
        dateStack.addArrangedSubview(preferredDateRow)
        
        additionalStack.axis = .vertical
        additionalStack.spacing = 8
        additionalStack.addArrangedSubview(mobileNumberRow)
        
        amountStack.axis = .vertical
        amountStack.spacing = 8
        amountStack.addArrangedSubview(priceRow)
        
        // Add subviews
        addSubview(headerImageView)
        addSubview(headerTitleLabel)
        addSubview(packageImageView)
        addSubview(packageTitleLabel)
        addSubview(packageDescriptionLabel)
        addSubview(activityIndicator)
        
        addSubview(topDividerView)
        
        addSubview(informationTitleLabel)
        addSubview(infoStack)
        addSubview(infoDividerView)
        
        addSubview(dateReservationTitleLabel)
        addSubview(dateStack)
        addSubview(dateDividerView)
        
        addSubview(additionalInformationTitleLabel)
        addSubview(additionalStack)
        addSubview(additionalDividerView)
        
        addSubview(amountTitleLabel)
        addSubview(amountStack)
        addSubview(amountDividerView)
        addSubview(continueButton)
        
        headerImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(100)
        }
        
        headerTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(headerImageView.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
            make.leading.greaterThanOrEqualTo(headerImageView.snp.trailing).offset(8)
        }
        
        packageImageView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(120)
            make.height.equalTo(80)
        }
        
        packageTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(packageImageView.snp.top)
            make.leading.equalTo(packageImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
        }
        
        packageDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(packageTitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(packageTitleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(16)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        topDividerView.snp.makeConstraints { make in
            make.top.equalTo(packageImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        informationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(topDividerView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        infoStack.snp.makeConstraints { make in
            make.top.equalTo(informationTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        infoDividerView.snp.makeConstraints { make in
            make.top.equalTo(infoStack.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        dateReservationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(infoDividerView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        dateStack.snp.makeConstraints { make in
            make.top.equalTo(dateReservationTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        dateDividerView.snp.makeConstraints { make in
            make.top.equalTo(dateStack.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        additionalInformationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateDividerView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        additionalStack.snp.makeConstraints { make in
            make.top.equalTo(additionalInformationTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        additionalDividerView.snp.makeConstraints { make in
            make.top.equalTo(additionalStack.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        amountTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(additionalDividerView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        amountStack.snp.makeConstraints { make in
            make.top.equalTo(amountTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        amountDividerView.snp.makeConstraints { make in
            make.top.equalTo(amountStack.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(amountDividerView.snp.bottom).offset(135)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
    
    // Method to set up delegates for the text fields
    private func setupTextFieldDelegates() {
        preferredDateTextField.delegate = self
        mobileNumberTextField.delegate = self
        
        mobileNumberTextField.keyboardType = .numberPad
    }
    
    // Method to set up the gesture recognizer for dismissing the keyboard
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
    
    // MARK: - Configure Package Details
    func configureHeader(with package: PackageDetailViewModel) {
        packageImageView.kf.setImage(with: URL(string: package.imageUrl))
        packageTitleLabel.text = package.title
        packageDescriptionLabel.text = package.description
        
        if let priceLabel = (priceRow.arrangedSubviews.last as? UILabel) {
            priceLabel.text = "\(package.price)"
            priceLabel.font = UIFont.roboto(.bold, size: 13)
        }
    }
    
    // Validation method
    private func validateFields() {
        let isDateFilled = !(preferredDateTextField.text?.isEmpty ?? true)
        let isMobileNumberValid = (mobileNumberTextField.text?.count == 11)
        
        if isDateFilled && isMobileNumberValid {
            continueButton.isEnabled = true
            continueButton.backgroundColor = .primaryOrange
        } else {
            continueButton.isEnabled = false
            continueButton.backgroundColor = .primaryGrayLight
        }
    }
}

// MARK: - UITextFieldDelegate
extension BookingView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == mobileNumberTextField {
            if let text = textField.text, text.count == 11 {
                textField.font = UIFont.roboto(.bold, size: 13)
                textField.textColor = .primaryOrange
            } else {
                textField.font = UIFont.italicSystemFont(ofSize: 13)
                textField.textColor = .primaryGrayDisableText
            }
        }
        
        if textField == preferredDateTextField {
            if textField.text?.isEmpty ?? true {
                textField.font = UIFont.italicSystemFont(ofSize: 13)
                textField.textColor = .primaryGrayDisableText
            } else {
                textField.font = UIFont.roboto(.bold, size: 13)
                textField.textColor = .primaryOrange
            }
        }
        
        validateFields()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let rangeOfTextToReplace = Range(range, in: currentText) else {
            return false
        }
        let newText = currentText.replacingCharacters(in: rangeOfTextToReplace, with: string)
        
        if textField == mobileNumberTextField {
            // Ensure only digits are entered
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            
            // Limit the number count to 11 digits
            if newText.count > 11 {
                return false
            }
            
            if !newText.isEmpty {
                textField.font = UIFont.roboto(.bold, size: 13)
                textField.textColor = .primaryOrange
            } else {
                
                textField.font = UIFont.italicSystemFont(ofSize: 13)
                textField.textColor = .primaryGrayDisableText
            }
            
            textField.text = newText
            self.validateFields()
            
            return false
        }
        
        if textField == preferredDateTextField {
            return true
        }
        
        return true
    }
}
