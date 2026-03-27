//
//  PackageView.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 7/9/25.
//

import UIKit
import SnapKit

class PackageView: UIView {
    
    // MARK: - UI Components
    let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AppConstant.Packages.logo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let headerTitleLabel: UILabel = {
        let label = UILabel()
        
        let highlights = [
            NSAttributedString.HighlightStyle(
                substring: "Diving",
                font: .roboto(.bold, size: 28),
                color: .primaryBlueColor
            ),
            NSAttributedString.HighlightStyle(
                substring: "Packages",
                font: .roboto(.bold, size: 28),
                color: .primaryOrange
            )
        ]
        
        let attrText = NSAttributedString.highlightedString(
            fullText: AppConstant.Packages.packageTitle,
            baseFont: .roboto(.bold, size: 28),
            baseColor: .black,
            highlights: highlights
        )
        
        label.attributedText = attrText
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .primaryOrange
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
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
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(8)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
