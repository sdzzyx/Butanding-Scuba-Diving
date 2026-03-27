//
//  BookingCardView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/14/25.
//

import UIKit
import SnapKit

class BookingCardView: UIView {
    
    // MARK: - UI Components
    private let expandSymbolLabel = UILabel()
    private let titleLabel = UILabel()
    private let detailsStack = UIStackView()
    
    private let packageTitleLabel = UILabel()
    private let packageValueLabel = UILabel()
    
    private let nameTitleLabel = UILabel()
    private let nameValueLabel = UILabel()
    
    private let dateTimeTitleLabel = UILabel()
    private let dateTimeValueLabel = UILabel()
    
    private let participantsTitleLabel = UILabel()
    private let participantsStack = UIStackView()
    
    // MARK: - State
    private var isExpanded = true // changed to true
    
    // MARK: - ViewModel
    var viewModel: InstructorBookingViewModel? {
        didSet { configure() }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = UIColor.white.withAlphaComponent(0.9)
        layer.cornerRadius = 10
        layer.borderWidth = 0
        layer.borderColor = UIColor.lightGray.cgColor
        
        // Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15   // soft shadow, between 0.1–0.25 looks good
        layer.shadowOffset = CGSize(width: 0, height: 4) // subtle downward shadow
        layer.shadowRadius = 8
        layer.masksToBounds = false // Important: allows shadow to show outside the layer
        
        // MARK: Header (Symbol + Title)
        addSubview(expandSymbolLabel)
        addSubview(titleLabel)
        
        expandSymbolLabel.text = AppConstant.Instructor.expandedSymbol
        expandSymbolLabel.font = .systemFont(ofSize: 18, weight: .bold)
        expandSymbolLabel.textColor = .primaryBlueColor
        expandSymbolLabel.isUserInteractionEnabled = true
        
        // Add tap gesture for expand/collapse
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleExpand))
        addGestureRecognizer(tap)
        
        titleLabel.font = .roboto(.bold, size: 16)
        titleLabel.textColor = .primaryBlueColor
        
        // MARK: Details Stack
        detailsStack.axis = .vertical
        detailsStack.spacing = 8
        addSubview(detailsStack)
        
        func makeRow(left: UILabel, right: UILabel) -> UIStackView {
            let row = UIStackView(arrangedSubviews: [left, right])
            row.axis = .horizontal
            row.spacing = 8
            row.alignment = .leading
            left.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            right.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            return row
        }
        
        [packageTitleLabel, nameTitleLabel, dateTimeTitleLabel, participantsTitleLabel].forEach {
            $0.font = .roboto(.medium, size: 14)
            $0.textColor = .black // Titles in black
        }

        [packageValueLabel, nameValueLabel, dateTimeValueLabel].forEach {
            $0.font = .roboto(.bold, size: 14)
            $0.textColor = .primaryOrange // Values in orange
            $0.numberOfLines = 0
            $0.textAlignment = .right
        }
        
        participantsStack.axis = .vertical
        participantsStack.spacing = 4
        participantsStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        participantsStack.isLayoutMarginsRelativeArrangement = true
        
        detailsStack.addArrangedSubview(makeRow(left: packageTitleLabel, right: packageValueLabel))
        detailsStack.addArrangedSubview(makeRow(left: nameTitleLabel, right: nameValueLabel))
        detailsStack.addArrangedSubview(makeRow(left: dateTimeTitleLabel, right: dateTimeValueLabel))
        detailsStack.addArrangedSubview(participantsTitleLabel)
        detailsStack.addArrangedSubview(participantsStack)
        
        // MARK: Constraints
        expandSymbolLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(expandSymbolLabel.snp.centerY)
            make.leading.equalTo(expandSymbolLabel.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview().inset(12)
        }
        
        detailsStack.snp.makeConstraints { make in
            make.top.equalTo(expandSymbolLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        
        detailsStack.isHidden = !isExpanded //true
        expandSymbolLabel.text = AppConstant.Instructor.collapseSymbol
    }
    
    // MARK: - Configure
    private func configure() {
        guard let vm = viewModel else { return }
        
        titleLabel.text = "Booking ID: \(vm.bookingId.prefix(8))"
            
            packageTitleLabel.text = "Package"
            packageValueLabel.text = vm.packageName
            
            nameTitleLabel.text = "Instructor"
        nameValueLabel.text = vm.instructorName //"Gregor Cruz" // or from your booking model later
            
            dateTimeTitleLabel.text = "Reservation Date"
            dateTimeValueLabel.text = vm.reservationDate
            
            participantsTitleLabel.text = "Companions"
            
            participantsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            vm.participants.forEach { name in
                let label = UILabel()
                label.text = name
                label.font = .roboto(.regular, size: 14)
                label.textColor = .primaryOrange
                participantsStack.addArrangedSubview(label)
            }
        
//        titleLabel.text = vm.bookingOneTitle
//        packageTitleLabel.text = vm.packageTitle
//        packageValueLabel.text = vm.packageName
//        nameTitleLabel.text = vm.nameTitle
//        nameValueLabel.text = vm.namePlaceholder
//        dateTimeTitleLabel.text = vm.dateTimeTitle
//        dateTimeValueLabel.text = vm.dateTimePlaceholder
//        participantsTitleLabel.text = vm.participantsTitle
//        
//        // Participants
//        participantsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
//        [
//            vm.participantsPlaceholder,
//            vm.participantsPlaceholderTwo,
//            vm.participantsPlaceholderThree
//        ].forEach { text in
//            let label = UILabel()
//            label.text = text
//            label.font = .roboto(.regular, size: 14)
//            label.textColor = .primaryOrange
//            participantsStack.addArrangedSubview(label)
//        }
        
        updateUI(animated: false)
    }
    
    // MARK: - Expand/Collapse
    @objc private func toggleExpand() {
        isExpanded.toggle()
        viewModel?.isExpanded = isExpanded
        updateUI(animated: true)
    }
    
    private func updateUI(animated: Bool) {
        let symbol = isExpanded ? AppConstant.Instructor.collapseSymbol : AppConstant.Instructor.expandedSymbol
        expandSymbolLabel.text = symbol
        
        let changes = {
            self.detailsStack.isHidden = !self.isExpanded
            self.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: changes)
        } else {
            changes()
        }
    }
}
