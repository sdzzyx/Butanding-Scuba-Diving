//
//  ReservationView.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 7/9/25.
//

import UIKit
import SnapKit

class ReservationView: UIView {
    
    
    // MARK: - Properties
    var viewModel: ReservationViewModel?
    
    // MARK: - UI Components
    let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let headerTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let tabsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryOrange
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .primaryOrange
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Configure with ViewModel
    func configure(with viewModel: ReservationViewModel) {
        self.viewModel = viewModel
        headerImageView.image = viewModel.logoImage
        
        
        let highlights = [
            NSAttributedString.HighlightStyle(
                substring: "My",
                font: .roboto(.bold, size: 28),
                color: .primaryBlueColor
            ),
            NSAttributedString.HighlightStyle(
                substring: "Booking",
                font: .roboto(.bold, size: 28),
                color: .primaryOrange
            )
        ]
        
        let attrText = NSAttributedString.highlightedString(
            fullText: viewModel.titleText,
            baseFont: .roboto(.bold, size: 28),
            baseColor: .black,
            highlights: highlights
        )
        headerTitleLabel.attributedText = attrText
        
        // Setup Tabs
        setupTabs(with: viewModel.tabTitles, selectedIndex: viewModel.selectedTabIndex)
    }
    
    // MARK: - Constraints for Indicator
    private var indicatorLeadingConstraint: Constraint?
    private var indicatorWidthConstraint: Constraint?
    
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
        
        addSubview(headerImageView)
        addSubview(headerTitleLabel)
        addSubview(tabsStackView)
        addSubview(indicatorView)
        addSubview(tableView)
        addSubview(activityIndicator)

        headerImageView.snp.makeConstraints { make in
            //make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.top.equalTo(snp.top).offset(50)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(100)
        }
        
        headerTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(headerImageView.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
            make.leading.greaterThanOrEqualTo(headerImageView.snp.trailing).offset(8)
        }
        
        tabsStackView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(tabsStackView.snp.bottom)
            make.height.equalTo(2)
            indicatorLeadingConstraint = make.leading.equalToSuperview().constraint
            indicatorWidthConstraint = make.width.equalTo(0).constraint
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(indicatorView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(8)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupTabs(with titles: [String], selectedIndex: Int) {
        // Clear old tabs
        tabsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            label.tag = index
            
            // Apply style depends on selection
            if index == selectedIndex {
                label.font = .roboto(.bold, size: 16)
                label.textColor = .primaryBlueColor
            } else {
                label.font = .roboto(.regular, size: 16)
                label.textColor = .primaryGrayDisableText
            }
            
            // Add tap gesture
            let tap = UITapGestureRecognizer(target: self, action: #selector(tabTapped(_:)))
            label.addGestureRecognizer(tap)
            
            tabsStackView.addArrangedSubview(label)
        }
        
        layoutIfNeeded()
        updateIndicator(for: selectedIndex, animated: false)
    }
    
    @objc private func tabTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        updateIndicator(for: index, animated: true)
        viewModel?.selectTab(at: index)
    }
    
    private func updateIndicator(for index: Int, animated: Bool) {
        guard index < tabsStackView.arrangedSubviews.count else { return }
        let tab = tabsStackView.arrangedSubviews[index]
        
        // Update indicator constraints
        indicatorLeadingConstraint?.deactivate()
        indicatorWidthConstraint?.deactivate()
        
        indicatorView.snp.makeConstraints { make in
            indicatorLeadingConstraint = make.leading.equalTo(tab.snp.leading).constraint
            indicatorWidthConstraint = make.width.equalTo(tab.snp.width).constraint
        }
        
        // Animate indicator and label style changes
        let updates = {
            for (i, view) in self.tabsStackView.arrangedSubviews.enumerated() {
                if let label = view as? UILabel {
                    if i == index {
                        label.font = .roboto(.bold, size: 16)
                        label.textColor = .primaryBlueColor
                    } else {
                        label.font = .roboto(.regular, size: 16)
                        label.textColor = .primaryGrayDisableText
                    }
                }
            }
            self.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: updates)
        } else {
            updates()
        }
    }
}
