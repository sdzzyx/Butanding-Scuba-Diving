//
//  PersonalInformationViewController.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 7/18/25.
//

import UIKit

class PersonalInformationViewController: UIViewController {
    
    private let mainView = PersonalInformationView()
    private let viewModel = PersonalInformationViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        bindViewModel()
        setupActions()
        updateView()
    }
    
    private func bindViewModel() {
        viewModel.infoUpdated = { [weak self] in
            self?.updateView()
        }
    }
    
    private func updateView() {
        let data = PersonalInformationViewData(
            backLogoImage: UIImage(named: "back-logo"),
            title: AppConstant.PersonalInformation.title,
            firstNameTitle: viewModel.personalInfomation.firstname,
            lastNameTitle: viewModel.personalInfomation.lastname,
            emailTitle: viewModel.personalInfomation.email,
            phoneTitle: viewModel.personalInfomation.phoneNumber,
            updateButtonTitle: AppConstant.PersonalInformation.updateButtonTitle
        )
        mainView.configure(with: data)
    }
    
    private func setupActions() {
        mainView.firstNameButton.addTarget(self, action: #selector(firstNameButtonTapped), for: .touchUpInside)
        mainView.lastNameButton.addTarget(self, action: #selector(lastNameButtonTapped), for: .touchUpInside)
        mainView.emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        mainView.phoneButton.addTarget(self, action: #selector(phoneButtonTapped), for: .touchUpInside)
        mainView.updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        mainView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        tapGesture.cancelsTouchesInView = false // allow button taps to still work
        mainView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func firstNameButtonTapped() {
        mainView.highlightButton(mainView.firstNameButton)
        mainView.activateUpdateButton()
    }
    
    @objc private func lastNameButtonTapped() {
        mainView.highlightButton(mainView.lastNameButton)
        mainView.activateUpdateButton()
    }
    
    @objc private func emailButtonTapped() {
        mainView.highlightButton(mainView.emailButton)
        mainView.activateUpdateButton()
    }
    
    @objc private func phoneButtonTapped() {
        mainView.highlightButton(mainView.phoneButton)
        mainView.activateUpdateButton()
    }
    
    @objc private func updateButtonTapped() {
        viewModel.saveChanges()
        let alert = UIAlertController(title: "Updated", message: "Your information has been updated.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    @objc private func handleBackgroundTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: mainView)
        
        // Check if the tap is inside any button
        if mainView.firstNameButton.frame.contains(location)
            || mainView.lastNameButton.frame.contains(location)
            || mainView.emailButton.frame.contains(location)
            || mainView.phoneButton.frame.contains(location) {
            return // Do nothing, let button handle it
        }
        
        // Else reset
        mainView.resetAllButtonHighlights()
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
