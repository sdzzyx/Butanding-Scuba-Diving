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
    var onUploadTapped: ((Int) -> Void)?
    
    // MARK: - Additional Info
    var uploadCertificateButton: UIButton
    var certificateRow: UIStackView
    var numberOfCompanionsRow: UIStackView
    var numberOfCompanionsTextField: UITextField
    private let companionsDividerView: UIView
    let companionsStack = UIStackView()
    
    // MARK: - Scrollable containers
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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
    
    // MARK: - Terms & Privacy
    private let termsCheckBox: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: AppConstant.Booking.checkBoxUnfilled), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .primaryBlueColor
        return button
    }()

    private let termsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let fullText = AppConstant.Booking.termsAndPrivacyPolicyTitle
        
        let highlights = [
            NSAttributedString.HighlightStyle(
                substring: "I agree to the",
                font: .roboto(.medium, size: 13),
                color: .primaryBlueColor
            ),
            NSAttributedString.HighlightStyle(
                substring: "Terms and Privacy Policy",
                font: .roboto(.bold, size: 13),
                color: .primaryOrange
            )
        ]
        
        let attrText = NSAttributedString.highlightedString(
            fullText: fullText,
            baseFont: .roboto(.medium, size: 13),
            baseColor: .primaryBlueColor,
            highlights: highlights
        )
        
        label.attributedText = attrText
        return label
    }()

    private lazy var termsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [termsCheckBox, termsLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        return stack
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
        
        self.numberOfCompanionsRow = UIStackView()
        self.numberOfCompanionsTextField = UITextField()
        self.companionsDividerView = BookingView.makeDivider()
        
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
        
        let certComponents = BookingView.makeCertificateRowComponents()
        self.certificateRow = certComponents.row
        self.uploadCertificateButton = certComponents.button
        
        super.init(frame: frame)
        
        companionsStack.axis = .vertical
        companionsStack.spacing = 12
        
        let preferredDateStack = makeTextFieldRow(title: AppConstant.Booking.preferreDateTitle,
                                                  placeholder: AppConstant.Booking.preferredDatePlaceholder)
        self.preferredDateRow = preferredDateStack
        self.preferredDateTextField = preferredDateStack.arrangedSubviews.last as! UITextField
        
        let mobileNumberStack = makeTextFieldRow(title: AppConstant.Booking.mobileNumberTitle,
                                                 placeholder: AppConstant.Booking.mobileNumberPlaceholder)
        self.mobileNumberRow = mobileNumberStack
        self.mobileNumberTextField = mobileNumberStack.arrangedSubviews.last as! UITextField
        
        uploadCertificateButton.addTarget(self, action: #selector(handleMainCertificateUpload), for: .touchUpInside)
        
        let numberOfCompanionsStack = makeTextFieldRow(title: AppConstant.Booking.numberOfCompanionTitle,
                                                       placeholder: AppConstant.Booking.numberOfCompanionPlaceHolder)
        self.numberOfCompanionsRow = numberOfCompanionsStack
        self.numberOfCompanionsTextField = numberOfCompanionsStack.arrangedSubviews.last as! UITextField
        
        
        setupUI()
        setupTextFieldDelegates()
        setupGestureRecognizer()
        
        // Continue Button function
        continueButton.addTarget(self, action: #selector(handleContinueTap), for: .touchUpInside)
        termsCheckBox.addTarget(self, action: #selector(handleTermsTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCompanions(count: Int) {
        companionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        guard count > 0 else { return }
        
        for i in 1...count {
            let expandableCard = CompanionCardView(index: i)
            
            expandableCard.onUploadCertificateTapped = { [weak self] in
                self?.onUploadTapped?(i)
            }
            
            companionsStack.addArrangedSubview(expandableCard)
            if i < count {
                let divider = UIView()
                divider.backgroundColor = .primaryGrayLight
                divider.snp.makeConstraints { make in
                    make.height.equalTo(1)
                }
                companionsStack.addArrangedSubview(divider)
            }
        }
        companionsDividerView.isHidden = (count == 0)
    }
    
    
    private static func makeCertificateRowComponents() -> (row: UIStackView, button: UIButton) {
        let titleLabel = UILabel()
        titleLabel.text = AppConstant.Booking.medicalCertificateTitle
        titleLabel.font = UIFont.roboto(.medium, size: 13)
        titleLabel.textColor = .black
        
        let uploadButton = UIButton(type: .system)
        uploadButton.setTitle(AppConstant.Booking.uploadCertificateButtonTitle, for: .normal)
        uploadButton.setTitleColor(.primaryOrange, for: .normal)
        uploadButton.titleLabel?.font = UIFont.roboto(.medium, size: 13)
        
        let spacer = UIView()
        let row = UIStackView(arrangedSubviews: [titleLabel, spacer, uploadButton])
        row.axis = .horizontal
        row.alignment = .center
        
        return (row, uploadButton)
    }


    @objc private func handleMainCertificateUpload(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = .identity
            }
        })
        onUploadTapped?(0)
    }

    private var isMainCertificateUploaded = false
    private var isTermsAccepted = false

    func setMainCertificateUploaded(_ uploaded: Bool) {
        isMainCertificateUploaded = uploaded
        validateFields()
    }

    func companionCard(at index: Int) -> CompanionCardView? {
        let cards = companionsStack.arrangedSubviews.compactMap { $0 as? CompanionCardView }
        guard index > 0, index <= cards.count else { return nil }
        return cards[index - 1]
    }

    
    @objc private func handleContinueTap() {
        onContinueTap?()
    }
    
    @objc private func handleTermsTap() {
        isTermsAccepted.toggle()
        let imageName = isTermsAccepted ? AppConstant.Booking.checkBoxFilled : AppConstant.Booking.checkBoxUnfilled
        termsCheckBox.setImage(UIImage(named: imageName), for: .normal)
        validateFields()
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
    
    // MARK: - Companion Card Builder
    private func makeCompanionCard(index: Int) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 8
        container.layer.cornerRadius = 8
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.primaryGrayLight.cgColor
        container.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        container.isLayoutMarginsRelativeArrangement = true
        
        let title = UILabel()
        title.text = "\(AppConstant.Booking.companionTitle) \(index)"
        title.font = UIFont.roboto(.bold, size: 14)
        title.textColor = .primaryBlueColor
        
        let nameRow = makeTextFieldRow(title: AppConstant.Booking.fullNameTitle,
                                       placeholder: AppConstant.Booking.fullNamePlaceholder)
        let medicalRow = BookingView.makeRow(title: AppConstant.Booking.medicalCertificateTitle,
                                             placeholder: AppConstant.Booking.uploadCertificateButtonTitle)
        
        container.addArrangedSubview(title)
        container.addArrangedSubview(nameRow)
        container.addArrangedSubview(medicalRow)
        
        return container
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
        
        additionalStack.addArrangedSubview(certificateRow)
        
        amountStack.axis = .vertical
        amountStack.spacing = 8
        amountStack.addArrangedSubview(priceRow)
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        
        addSubview(continueButton)
        addSubview(headerImageView)
        addSubview(headerTitleLabel)
        addSubview(activityIndicator)
        
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
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(continueButton.snp.top).offset(-12)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        continueButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(16)
            make.height.equalTo(50)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        contentView.addSubview(packageImageView)
        contentView.addSubview(packageTitleLabel)
        contentView.addSubview(packageDescriptionLabel)
        contentView.addSubview(topDividerView)
        contentView.addSubview(informationTitleLabel)
        contentView.addSubview(infoStack)
        contentView.addSubview(infoDividerView)
        contentView.addSubview(dateReservationTitleLabel)
        contentView.addSubview(dateStack)
        contentView.addSubview(dateDividerView)
        contentView.addSubview(additionalInformationTitleLabel)
        contentView.addSubview(additionalStack)
        contentView.addSubview(additionalDividerView)
        contentView.addSubview(numberOfCompanionsRow)
        contentView.addSubview(companionsDividerView)
        contentView.addSubview(companionsStack)
        companionsStack.axis = .vertical
        companionsStack.spacing = 12
        contentView.addSubview(amountTitleLabel)
        contentView.addSubview(amountStack)
        contentView.addSubview(amountDividerView)
        contentView.addSubview(termsStack)
        
        
        packageImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
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
        
        numberOfCompanionsRow.snp.makeConstraints { make in
            make.top.equalTo(additionalDividerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        companionsStack.snp.makeConstraints { make in
            make.top.equalTo(numberOfCompanionsRow.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        companionsDividerView.snp.makeConstraints { make in
            make.top.equalTo(companionsStack.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        amountTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(companionsDividerView.snp.bottom).offset(16)
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
        
        termsStack.snp.makeConstraints { make in
            make.top.equalTo(amountDividerView.snp.bottom).offset(16)
            make.width.height.equalTo(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
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
        
        let isValid = isDateFilled && isMobileNumberValid && isMainCertificateUploaded && isTermsAccepted
        
        continueButton.isEnabled = isValid
        continueButton.backgroundColor = isValid ? .primaryOrange : .primaryGrayLight
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
