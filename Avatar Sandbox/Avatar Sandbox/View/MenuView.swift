//
//  MenuView.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

import UIKit
import SnapKit

final class MenuView: UIView {

    // MARK: - Outlets
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Avatar Creation"
        label.font = UIFont(name: "Optima", size: 40)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let characterView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let ageTextField: ASTextField = {
        let textField = ASTextField(type: .age)
        return textField
    }()
    
    private let heightTextField: ASTextField = {
        let textField = ASTextField(type: .height)
        return textField
    }()
    
    private let weidghtTextField: ASTextField = {
        let textField = ASTextField(type: .weight)
        return textField
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .orange
        return imageView
    }()
    
//    private let avatarCollectionView: UICollectionView = {
//        let collectionView = UICollectionView(
//            frame: .zero,
//            collectionViewLayout: UICollectionViewFlowLayout()
//        )
//        collectionView.register(AvatarCollectionViewCell, forCellWithReuseIdentifier: <#T##String#>)
//        return collectionView
//    }()
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    private func configure() {
        configureView()
        addSubviews()
        setupConstraints()
    }
    
    private func configureView() {
        backgroundColor = .white
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(characterView)
        characterView.addSubview(avatarImageView)
        characterView.addSubview(ageTextField)
        characterView.addSubview(heightTextField)
        characterView.addSubview(weidghtTextField)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.layoutMarginsGuide)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        characterView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(30)
            make.height.width.equalTo(120)
            make.bottom.lessThanOrEqualTo(characterView.snp.bottom).inset(30)
        }
        
        ageTextField.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(30)
            make.trailing.lessThanOrEqualTo(avatarImageView.snp.leading).offset(30)
        }
        
        heightTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.top.equalTo(ageTextField.snp.bottom).offset(10)
            make.trailing.equalTo(ageTextField)
        }
        
        weidghtTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.top.equalTo(heightTextField.snp.bottom).offset(10)
            make.bottom.lessThanOrEqualTo(characterView.snp.bottom).inset(30)
            make.trailing.equalTo(ageTextField)
        }
    }
}
