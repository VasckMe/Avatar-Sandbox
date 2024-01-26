//
//  AvatarViewController.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

import UIKit

final class AvatarViewController: UIViewController, ViewOwner {
    typealias RootView = AvatarView

    // MARK: - Properties
    
    let models = Avatars.allCases
    let cellSpacing: CGFloat = 10
    let cellSize: CGSize = CGSize(width: 100, height: 100)
    let lineSpacing: CGFloat = 20
    
    // MARK: - Life cycle
    
    override func loadView() {
        view = AvatarView()
        rootView.setupCollectionView(dataSource: self)
        rootView.setupCollectionView(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    // MARK: - @Objc methods
    
    @objc private func nextButtonDidTap() {
        rootView.animateTransition {
            self.navigationController?.pushViewController(CharacterViewController(), animated: true)
        }
    }
    
    // MARK: - Methods
    
    private func selectMiddleCell() {
        let centerPoint = CGPoint(
            x: rootView.avatarCollectionView.contentOffset.x + rootView.avatarCollectionView.bounds.width / 2,
            y: rootView.avatarCollectionView.bounds.height / 2
        )

        if let indexPath = rootView.avatarCollectionView.indexPathForItem(at: centerPoint) {
            rootView.avatarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            rootView.refreshAvatar(with: models[indexPath.row].value)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension AvatarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        rootView.refreshAvatar(with: models[indexPath.row].value)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectMiddleCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            selectMiddleCell()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension AvatarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AvatarCollectionViewCell.defaultReuseIdentifier,
                for: indexPath
            ) as? AvatarCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.setup(model: models[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AvatarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return cellSize
    }
}

protocol AvatarCollectionViewCellDelegate: AnyObject {
    func didSelect(cell: AvatarCollectionViewCell)
}
