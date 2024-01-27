//
//  AvatarViewController.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

import UIKit
import WatchConnectivity

final class AvatarViewController: UIViewController, ViewOwner {
    typealias RootView = AvatarView

    // MARK: - Properties
    
    private let models = ASImage.allCases
    private let cellSpacing: CGFloat = 10
    private let cellSize: CGSize = CGSize(width: 100, height: 100)
    private let lineSpacing: CGFloat = 20
    
    private var isAgeValid = true
    private var isHeightValid = true
    private var isWeightValid = true
    
    private let validationService: ASValidationServiceProtocol = ASValidationService()
    
    var lastMessage: CFAbsoluteTime = 0
    
    // MARK: - Life cycle
    
    override func loadView() {
        view = AvatarView()
        rootView.setupCollectionView(dataSource: self)
        rootView.setupCollectionView(delegate: self)
        rootView.setupInputViews(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendWatchMessage()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            rootView.contentUp(constant: keyboardSize.height)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        rootView.contentDown()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - @Objc methods
    
    @objc private func nextButtonDidTap() {
        rootView.animateTransition {
//            self.navigationController?.pushViewController(CharacterViewController(), animated: true)
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
            rootView.refreshAvatar(with: models[safe: indexPath.row])
        }
    }
}

// MARK: - UICollectionViewDelegate

extension AvatarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        rootView.refreshAvatar(with: models[safe: indexPath.row])
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
        
        cell.setup(image: models[safe: indexPath.row])
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

// MARK: - ASInputViewDelegate

extension AvatarViewController: ASInputViewDelegate {
    func didTriggerTextField(of type: ASInputViewType, with text: String?) {
        let isValid = validationService.isValid(text: text)
        rootView.validate(type: type, isValid: isValid)
        
        switch type {
        case .age:
            isAgeValid = isValid
        case .height:
            isHeightValid = isValid
        case .weight:
            isWeightValid = isValid
        }
        
        // if all valid - enable button
    }
}

extension AvatarViewController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("session")
        if let error = error {
            print("Can't active session: ",error.localizedDescription)
        } else {
            print("Can activate session")
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("didBecomeInactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("didDeactivate")
        WCSession.default.activate()
    }
    
    func sendWatchMessage() {
        let currentTime = CFAbsoluteTimeGetCurrent()

        // if less than half a second has passed, bail out
        if lastMessage + 0.5 > currentTime {
            return
        }

        // send a message to the watch if it's reachable
        if (WCSession.default.isReachable) {
            // this is a meaningless message, but it's enough for our purposes
//            let model = CharacterModel(image: ASImage.avatar10.value!, age: 49, height: 14, weight: 29)
            let message = ["age":49, "height":14, "weight":29] as [String : Any]
            WCSession.default.sendMessage(message, replyHandler: nil)
            WCSession.default.sendMessageData(ASImage.avatar10.value!.pngData()!, replyHandler: nil)
//                           UIImage
        }

        // update our rate limiting property
        lastMessage = CFAbsoluteTimeGetCurrent()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        sendWatchMessage()
    }
}
