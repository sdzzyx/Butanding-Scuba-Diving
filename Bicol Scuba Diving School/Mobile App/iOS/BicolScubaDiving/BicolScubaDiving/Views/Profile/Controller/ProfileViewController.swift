//
//  ProfileViewController.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 7/9/25.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let mainView = ProfileView()
    private let viewModel = ProfileViewModel()
    private var itemButtons: [String: UIButton] = [:]
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.tableFooterView = createFooterView()
        mainView.tableView.tableHeaderView = createHeaderView()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func createHeaderView() -> UIView {
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
        headerView.frame = CGRect(x: 0, y: 0, width: mainView.tableView.bounds.width, height: headerHeight)
        return headerView
    }
    
    private func createFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: mainView.tableView.bounds.width, height: 150))
        
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
    
    // MARK: - TableView DataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.sections[indexPath.section].items[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        
        var config = UIButton.Configuration.filled()
        config.title = item.title
        config.baseBackgroundColor = UIColor.primaryGrayLight
        config.baseForegroundColor = .black
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 16)
        
        let font = UIFont.roboto(.medium, size: 13)
        config.attributedTitle = AttributedString(item.title, attributes: AttributeContainer([.font: font]))
        
        let button = cell.button
        button.configuration = config
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.contentHorizontalAlignment = .leading
        button.tag = indexPath.section * 100 + indexPath.row
        
        itemButtons[item.title] = button
        
        return cell
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
