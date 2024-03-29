//
//  AvatarCollectionViewCell.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

import UIKit

final class AvatarCollectionViewCell: UICollectionViewCell, ReusableView {
    
    // MARK: - Outlets
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.layer.borderColor = UIColor.gray.cgColor
                contentView.layer.borderWidth = 2
            } else {
                contentView.layer.borderColor = UIColor.clear.cgColor
                contentView.layer.borderWidth = 0
            }
        }
    }
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setup(image: AvatarImage?) {
        avatarImageView.image = image?.value
    }
}

// MARK: - Private setup

private extension AvatarCollectionViewCell {
    func configure() {
        configureView()
        addSubviews()
        setupConstraints()
    }
    
    func configureView() {
        contentView.layer.cornerRadius = 20
    }
    
    func addSubviews() {
        contentView.addSubview(avatarImageView)
    }
    
    func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}
