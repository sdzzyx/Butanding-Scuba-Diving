//
//  ProfileViewController.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 7/9/25.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin
import FacebookCore
import AuthenticationServices

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var mainView: ProfileView!
    private let viewModel = ProfileViewModel()
    private var itemButtons: [String: UIButton] = [:]
    
    override func loadView() {
        
        self.mainView = ProfileView(logoImage: viewModel.logoImage, socialIcons: viewModel.socialIcons)
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        loadUserProfileImage()
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let container = UIView()
        container.backgroundColor = .white
        
        let label = UILabel()
        label.text = viewModel.sections[section].sectionTitle
        label.font = UIFont.roboto(.bold, size: 16)
        label.textColor = UIColor.primaryBlueColor
        label.textAlignment = .left
        
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        return container
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.sections[indexPath.section].items[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        
        // Configured label
        cell.titleLabel.text = item.title
        
        
        return cell
    }
    
    // MARK: - Actions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Handle taps
        let item = viewModel.sections[indexPath.section].items[indexPath.row]
            
            switch item.title {
            case AppConstant.Profile.personalInfo:
                let personalVC = PersonalInformationViewController()
                navigationController?.pushViewController(personalVC, animated: true)
                
            case AppConstant.Profile.changePassword:
                let changePasswordVC = ChangePasswordViewController()
                navigationController?.pushViewController(changePasswordVC, animated: true)
                break
                
            case AppConstant.Profile.logout:
                let alert = UIAlertController(
                    title: "Log Out",
                    message: "Are you sure you want to log out?",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
                    self?.handleLogout()
                }))
                
                present(alert, animated: true)
                break
                
            default:
                break
            }
        
    }
    
    private func handleLogout() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            
            // Create a fresh Login screen
            let loginVC = LoginViewController() // Replace with your actual login VC
            let navController = UINavigationController(rootViewController: loginVC)
            navController.modalPresentationStyle = .fullScreen
            
            // Replace the rootViewController (clears entire stack)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = navController
                window.makeKeyAndVisible()
            }
            
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
            
            let errorAlert = UIAlertController(
                title: "Error",
                message: "Could not log out. Please try again.",
                preferredStyle: .alert
            )
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
            present(errorAlert, animated: true)
        }
    }
    
    
    private func loadUserProfileImage() {
        guard let headerView = mainView.tableView.tableHeaderView,
              let profileImageView = headerView.viewWithTag(999) as? UIImageView else { return }

        let user = Auth.auth().currentUser
        let providerID = user?.providerData.first?.providerID ?? "password"
        
        // Default image
        profileImageView.image = UIImage(named: "placeholder-profile")

        switch providerID {
        case "google.com":
            if let url = user?.photoURL {
                loadImage(from: url, into: profileImageView)
            }
        case "facebook.com":
            if let facebookID = user?.providerData.first?.uid {
                let urlString = "https://graph.facebook.com/\(facebookID)/picture?type=large"
                if let url = URL(string: urlString) {
                    loadImage(from: url, into: profileImageView)
                }
            }
        case "apple.com":
            // Apple does not provide photo — use placeholder or custom avatar
            profileImageView.image = UIImage(named: "apple-placeholder")

        case "password":
            // Email/Password users - if you store a custom photoURL in Firestore, fetch it here
            if let url = user?.photoURL {
                loadImage(from: url, into: profileImageView)
            } else {
                profileImageView.image = UIImage(named: "placeholder-profile")
            }
        default:
            profileImageView.image = UIImage(named: "placeholder-profile")
        }
    }

    private func loadImage(from url: URL, into imageView: UIImageView) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }

    
}
