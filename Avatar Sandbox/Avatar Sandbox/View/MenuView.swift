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
    
    func refreshAvatar(with image: UIImage?) {
        UIView.transition(with: avatarImageView, duration: 0.5, options: .transitionCrossDissolve) {
            self.avatarImageView.image = image
        }
    }
    
    private func configure() {
        configureView()
        addSubviews()
        setupConstraints()
    }
    
    private func configureView() {
        backgroundColor = .darkGray
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(avatarBorderView)
        avatarBorderView.addSubview(avatarImageView)
        addSubview(avatarCollectionView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.layoutMarginsGuide)
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
    }
}
