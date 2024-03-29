//
//  AvatarView.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

import UIKit
import SnapKit

final class AvatarView: UIView {

    var bottomInset: CGFloat = 0
    
    // MARK: - Outlets
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Avatar Creation"
        label.font = UIFont(name: "Optima", size: 40)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let avatarBorderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let avatarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(AvatarCollectionViewCell.self, forCellWithReuseIdentifier: AvatarCollectionViewCell.defaultReuseIdentifier)
        collectionView.clipsToBounds = false
        return collectionView
    }()
    
    private let settingContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let ageSettingView: SettingView = {
        let textField = SettingView(type: .age)
        textField.setText("0")
        return textField
    }()
    
    private let heightSettingView: SettingView = {
        let textField = SettingView(type: .height)
        textField.setText("0")
        return textField
    }()
    
    private let weightSettingView: SettingView = {
        let textField = SettingView(type: .weight)
        textField.setText("0")
        return textField
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.setTitleColor(UIColor(named: "Disabled"), for: .disabled)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 2
        button.addTarget(nil, action: Selector(("nextButtonDidTap")), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    func setupCollectionView(dataSource: UICollectionViewDataSource) {
        avatarCollectionView.dataSource = dataSource
    }
    
    func setupCollectionView(delegate: UICollectionViewDelegate) {
        avatarCollectionView.delegate = delegate
    }
    
    func refreshAvatar(with image: AvatarImage?) {
        UIView.transition(with: avatarImageView, duration: 0.5, options: .transitionCrossDissolve) {
            self.avatarImageView.image = image?.value
        }
    }
    
    func showAgeValidationSuccess() {
        ageSettingView.setValidated()
    }
    
    func showAgeValidationError() {
        ageSettingView.showError()
    }
    
    func showHeightValidationSuccess() {
        heightSettingView.setValidated()
    }
    
    func showHeightValidationError() {
        heightSettingView.showError()
    }
    
    func showWeightValidationSuccess() {
        weightSettingView.setValidated()
    }
    
    func showWeightValidationError() {
        weightSettingView.showError()
    }
    
    func refreshStats(age: String?, height: String?, weight: String?) {
        ageSettingView.setText(age)
        heightSettingView.setText(height)
        weightSettingView.setText(weight)
    }
    
    func contentUp(constant: CGFloat) {
        if bottomInset == 0 {
            bottomInset = bounds.height - settingContainer.frame.maxY + constant
            bounds.size.height += bottomInset
        }
    }
    
    func contentDown() {
        bounds.size.height -= bottomInset
        bottomInset = 0
    }
    
    func disabledButton(enable: Bool) {
        continueButton.isEnabled = enable
    }
    
    func setupInputViews(delegate: SettingViewDelegate) {
        ageSettingView.delegate = delegate
        heightSettingView.delegate = delegate
        weightSettingView.delegate = delegate
    }
}

// MARK: - Private setup

private extension AvatarView {
    func configure() {
        configureView()
        addSubviews()
        setupConstraints()
    }
    
    func configureView() {
        backgroundColor = .darkGray
    }
    
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(avatarBorderView)
        avatarBorderView.addSubview(avatarImageView)
        addSubview(avatarCollectionView)
        addSubview(settingContainer)
        settingContainer.addArrangedSubview(ageSettingView)
        settingContainer.addArrangedSubview(heightSettingView)
        settingContainer.addArrangedSubview(weightSettingView)
        addSubview(continueButton)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(layoutMarginsGuide)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        avatarBorderView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.trailing.leading.equalToSuperview().inset(30)
            make.height.equalTo(avatarImageView.snp.width)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }

        avatarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(avatarBorderView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(100)
        }
        
        settingContainer.snp.makeConstraints { make in
            make.top.equalTo(avatarCollectionView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(settingContainer.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.bottom.lessThanOrEqualTo(layoutMarginsGuide)
        }
    }
}
