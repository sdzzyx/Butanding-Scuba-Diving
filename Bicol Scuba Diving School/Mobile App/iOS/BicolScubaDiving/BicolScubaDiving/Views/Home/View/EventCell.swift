//
//  EventCell.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/8/25.
//

import UIKit
import SnapKit
import Kingfisher

final class EventCell: UICollectionViewCell {
    static let identifier = "EventCell"
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension EventCell {
    func setupUI() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        titleLabel.font = UIFont.roboto(.bold, size: 13)
        titleLabel.textColor = .primaryBlueColor
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    func layoutUI() {
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.left.right.equalToSuperview().inset(8)
            make.bottom.lessThanOrEqualToSuperview().inset(6)
        }
    }
}

// MARK: - Configure
extension EventCell {
    func configure(with event: EventItem) {
        titleLabel.text = event.title
        if let url = URL(string: event.image) {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "placeholder")
        titleLabel.text = nil
    }
}
