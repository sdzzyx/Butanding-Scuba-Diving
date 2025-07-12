//
//  ProfileViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 7/9/25.
//

import UIKit
import SnapKit

class ProfileViewController: UITableViewController {
    
    private let viewModel = ProfileViewModel()
    private var itemButtons: [String: UIButton] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.tableFooterView = createFooterView()
        
        setupTableHeader()
    }
    
    private func setupTableHeader() {
        let headerView = UIView()
        let logoImageView = UIImageView(image: viewModel.logoImage)
        logoImageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = AppConstant.Profile.title
        titleLabel.font = UIFont.roboto(.bold, size: 28)
        titleLabel.textColor = UIColor.primaryBlueColor
        
        headerView.addSubview(logoImageView)
        headerView.addSubview(titleLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.trailing.equalToSuperview().inset(20)
        }
        
        let headerHeight: CGFloat = 95
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerHeight)
        tableView.tableHeaderView = headerView
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let container = UIView()
        container.backgroundColor = .white
        
        let label = UILabel()
        label.text = viewModel.sections[section].sectionTitle
        label.font = UIFont.roboto(.medium, size: 16)
        label.textColor = UIColor.primaryBlueColor
        label.textAlignment = .left
        
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }
        
        return container
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.sections[indexPath.section].items[indexPath.row]
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        var config = UIButton.Configuration.filled()
        config.title = item.title
        config.baseBackgroundColor = UIColor.primaryGrayLight
        config.baseForegroundColor = .black
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 16)
        
        let font = UIFont.roboto(.medium, size: 13)
        config.attributedTitle = AttributedString(item.title, attributes: AttributeContainer([.font: font]))
        
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        button.tag = indexPath.section * 100 + indexPath.row
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        itemButtons[item.title] = button
        
        cell.contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(5)
            make.height.equalTo(45)
        }
        
        return cell
    }
    
    // MARK: - Footer
    
    private func createFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 150))
        
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
        
        for icon in viewModel.socialIcons {
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
            make.top.equalToSuperview().offset(70)
            make.centerX.equalToSuperview()
        }
        
        socialStackView.snp.makeConstraints { make in
            make.top.equalTo(followLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        return footerView
    }
    
    // MARK: - Actions
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = itemButtons.first(where: { $0.value == sender })?.key else { return }
        
        switch title {
        case AppConstant.Profile.personalInfo:
            print("Personal Info tapped")
        case AppConstant.Profile.changePassword:
            print("Change Password tapped")
        case AppConstant.Profile.logout:
            print("Logout tapped")
        case AppConstant.Profile.privacyPolicy:
            print("Privacy Policy tapped")
        case AppConstant.Profile.refundPolicy:
            print("Refund Policy tapped")
        case AppConstant.Profile.termsAndConditions:
            print("Terms & Conditions tapped")
        case AppConstant.Profile.emailUs:
            print("Email Us tapped")
        case AppConstant.Profile.callUs:
            print("Call Us tapped")
        default:
            break
        }
    }
}
