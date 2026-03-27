//
//  ProfileView.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 7/9/25.
//

import UIKit
import SnapKit

class ProfileView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    private let logoImage: UIImage?
    private let socialIcons: [UIImage]
    
    // MARK: - Init
    
    init(logoImage: UIImage?, socialIcons: [UIImage]) {
        self.logoImage = logoImage
        self.socialIcons = socialIcons
        super.init(frame: .zero)
        backgroundColor = .white
        setupTableView()
        setupConstraints()
        setupHeaderAndFooter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
    }
    
    private func setupConstraints() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupHeaderAndFooter() {
        tableView.tableHeaderView = createHeaderView()
        tableView.tableFooterView = createFooterView()
    }
    
    // MARK: - Header & Footer
    
    private func createHeaderView() -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .white
//        let logoImageView = UIImageView(image: logoImage)
//        logoImageView.contentMode = .scaleAspectFit
        
        // Rounded profile image view
        let profileImageView = RoundedImageView()
        profileImageView.image = UIImage(named: "placeholder-profile") // fallback
        profileImageView.cornerRadiusValue = 0 // make circular
        profileImageView.tag = 999 // so we can update it later from VC
        
        let titleLabel = UILabel()
        titleLabel.text = AppConstant.Profile.title
        titleLabel.font = UIFont.roboto(.bold, size: 28)
        titleLabel.textColor = UIColor.primaryBlueColor
        
        //headerView.addSubview(logoImageView)
        headerView.addSubview(profileImageView)
        headerView.addSubview(titleLabel)
        
//        logoImageView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(10)
//            make.leading.equalToSuperview().offset(20)
//            make.width.height.equalTo(80)
//        }
        
        profileImageView.snp.makeConstraints { make in
                //make.top.equalToSuperview().offset(10)
                make.leading.equalToSuperview().offset(20)
                make.width.height.equalTo(80)
            }
        
        titleLabel.snp.makeConstraints { make in
            //make.centerY.equalTo(logoImageView)
            make.centerY.equalTo(profileImageView)
            make.trailing.equalToSuperview().inset(20)
        }
        
        let headerHeight: CGFloat = 95
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight)
        return headerView
    }
    
    private func createFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150))
        
        let followLabel = UILabel()
        followLabel.text = AppConstant.Profile.followUs
        followLabel.font = UIFont.roboto(.regular, size: 12)
        followLabel.textColor = .gray
        footerView.addSubview(followLabel)
        
        let socialStackView = UIStackView()
        socialStackView.axis = .horizontal
        socialStackView.spacing = 20
        socialStackView.alignment = .center
        footerView.addSubview(socialStackView)
        
        for icon in socialIcons {
            let button = UIButton()
            button.setImage(icon, for: .normal)
            button.layer.cornerRadius = 20
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.primaryOrange.cgColor
            button.clipsToBounds = true
            button.snp.makeConstraints { make in
                make.width.height.equalTo(40)
            }
            socialStackView.addArrangedSubview(button)
        }
        
        followLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(95)
            make.centerX.equalToSuperview()
        }
        
        socialStackView.snp.makeConstraints { make in
            make.top.equalTo(followLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        return footerView
    }
}
