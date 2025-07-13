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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupTableView()
        setupConstraints()
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
    
}
