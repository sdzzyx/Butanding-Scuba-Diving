//
//  InstructorView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/20/25.
//
import UIKit
import SnapKit

class InstructorView: UIView {
    
    // MARK: - ViewModel
    var viewModel: InstructorViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - UI Components
    let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AppConstant.Instructor.logo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let headerTitleLabel: UILabel = {
        let label = UILabel()
        
        let highlights = [
            NSAttributedString.HighlightStyle(
                substring: "Instructor",
                font: .roboto(.bold, size: 24),
                color: .primaryBlueColor
            ),
            NSAttributedString.HighlightStyle(
                substring: "Dashboard",
                font: .roboto(.bold, size: 24),
                color: .primaryOrange
            )
        ]
        
        let attrText = NSAttributedString.highlightedString(
            fullText: AppConstant.Instructor.instructorTitle,
            baseFont: .roboto(.bold, size: 24),
            baseColor: .black,
            highlights: highlights
        )
        
        label.attributedText = attrText
        return label
    }()
    
    let greetingLabel = UILabel()
    let assignedBookingTitleLabel = UILabel()
    let bookingCardView = BookingCardView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        greetingLabel.font = .roboto(.bold, size: 22)
        greetingLabel.textColor = .primaryBlueColor
        assignedBookingTitleLabel.font = .roboto(.bold, size: 18)
        assignedBookingTitleLabel.textColor = .primaryBlueColor
        
        addSubview(headerImageView)
        addSubview(headerTitleLabel)
        addSubview(greetingLabel)
        addSubview(assignedBookingTitleLabel)
        addSubview(bookingCardView)
        
        headerImageView.snp.makeConstraints { make in
            //make.top.greaterThanOrEqualTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.top.equalToSuperview().offset(50) // default closer placement
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(100)
        }
        
        headerTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(headerImageView.snp.centerY)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.greaterThanOrEqualTo(headerImageView.snp.trailing).offset(8)
        }
        
        greetingLabel.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        assignedBookingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        bookingCardView.snp.makeConstraints { make in
            make.top.equalTo(assignedBookingTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func bindViewModel() {
        guard let vm = viewModel else { return }
        greetingLabel.text = vm.greetingText
        assignedBookingTitleLabel.text = vm.assignedBookingTitle
        //bookingCardView.viewModel = vm.instructorBookingViewModel
    }
}
