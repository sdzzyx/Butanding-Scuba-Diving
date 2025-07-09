//
//  OnBoardingCell.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 7/9/25.
//

import UIKit
import SnapKit

class OnboardingImageCell: UICollectionViewCell {
    static let reuseIdentifier = "OnboardingImageCell"
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
