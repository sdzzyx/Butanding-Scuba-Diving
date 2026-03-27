//
//  InstructorScheduleView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/15/25.
//

import UIKit
import SnapKit

class InstructorScheduleView: UIView {
    // MARK: - Properties
        var viewModel: InstructorScheduleViewModel?
        
        // MARK: - UI Components
        let headerImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        let headerTitleLabel: UILabel = {
            let label = UILabel()
            label.font = .roboto(.bold, size: 28)
            label.textAlignment = .right
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
        tableView.estimatedRowHeight = 160
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

        
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
        
        // MARK: - Setup UI
        private func setupUI() {
            backgroundColor = .systemBackground
            
            addSubview(headerImageView)
            addSubview(headerTitleLabel)
            addSubview(tabsStackView)
            addSubview(indicatorView)
            addSubview(tableView)
            
            headerImageView.snp.makeConstraints { make in
                make.top.equalTo(snp.top).offset(50)
                make.leading.equalToSuperview().offset(16)
                make.width.height.equalTo(100)
            }
            
            headerTitleLabel.snp.makeConstraints { make in
                make.centerY.equalTo(headerImageView)
                make.leading.equalTo(headerImageView.snp.trailing).offset(12)
                make.trailing.equalToSuperview().inset(16)
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
                make.top.equalTo(indicatorView.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            }
        }
        
        // MARK: - Configure View
        func configure(with viewModel: InstructorScheduleViewModel) {
            self.viewModel = viewModel
                    headerImageView.image = viewModel.logoImage
                    
                    // ✅ Style “Booking” and “Schedules” with different colors
                    let highlights = [
                        NSAttributedString.HighlightStyle(
                            substring: "Booking",
                            font: .roboto(.bold, size: 28),
                            color: .primaryBlueColor
                        ),
                        NSAttributedString.HighlightStyle(
                            substring: "Schedules",
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
                    
                    setupTabs(with: viewModel.tabTitles, selectedIndex: viewModel.selectedTabIndex)
        }
        
        private func setupTabs(with titles: [String], selectedIndex: Int) {
            // Clear previous tabs
            tabsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            for (index, title) in titles.enumerated() {
                let label = UILabel()
                label.text = title
                label.textAlignment = .center
                label.isUserInteractionEnabled = true
                label.tag = index
                
                if index == selectedIndex {
                    label.font = .roboto(.bold, size: 16)
                    label.textColor = .primaryBlueColor
                } else {
                    label.font = .roboto(.regular, size: 16)
                    label.textColor = .primaryGrayDisableText
                }
                
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
        guard let label = tabsStackView.arrangedSubviews[index] as? UILabel else { return }
        
        // Calculate text width based on the label's font and text
//        let text = label.text ?? ""
        let textWidth: CGFloat = 150
        
        // Deactivate old constraints
        indicatorLeadingConstraint?.deactivate()
        indicatorWidthConstraint?.deactivate()
        
        // Create new constraints — indicator centered under text, width = text width
        indicatorView.snp.remakeConstraints { make in
            make.top.equalTo(tabsStackView.snp.bottom)
            make.height.equalTo(2)
            make.centerX.equalTo(label.snp.centerX)
            make.width.equalTo(textWidth)
        }
        
        let updates = {
            for (i, view) in self.tabsStackView.arrangedSubviews.enumerated() {
                if let lbl = view as? UILabel {
                    if i == index {
                        lbl.font = .roboto(.bold, size: 16)
                        lbl.textColor = .primaryBlueColor
                    } else {
                        lbl.font = .roboto(.regular, size: 16)
                        lbl.textColor = .primaryGrayDisableText
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
