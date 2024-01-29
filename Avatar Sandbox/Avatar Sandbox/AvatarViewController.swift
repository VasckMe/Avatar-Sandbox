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
    
    private let models = AvatarImage.allCases
    private let cellSpacing: CGFloat = 10
    private let cellSize: CGSize = CGSize(width: 100, height: 100)
    private let lineSpacing: CGFloat = 20
    
    private var isAgeValid = false
    private var isHeightValid = false
    private var isWeightValid = false
    
    private var ageText: String = ""
    private var heightText: String = ""
    private var weightText: String = ""
    private var selectedImage: String = ""
    
    private var avatar: AvatarModel?
    
    private let validationService: ValidationServiceProtocol = ValidationService()
    
    private var lastMessage: CFAbsoluteTime = 0
    
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - Actions
    
    @objc private func nextButtonDidTap() {
        guard
            let age = Int(ageText),
            let height = Float(heightText),
            let weight = Float(weightText)
        else {
            showAlert(title: "Enter stats")
            return
        }
        
        guard
            !selectedImage.isEmpty,
            let uiImage = UIImage(named: selectedImage),
            let imageData = uiImage.pngData()
        else {
            showAlert(title: "Choose avatar")
            return
        }
        
        let stats = AvatarStats(age: age, height: height, weight: weight)
        let avatar = AvatarModel(stats: stats, imageData: imageData)
        self.avatar = avatar
        
        sendWatchMessage(avatarStats: avatar.stats, imageData: avatar.imageData)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            rootView.contentUp(constant: keyboardSize.height)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        rootView.contentDown()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension AvatarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        selectedImage = models[safe: indexPath.row]?.stringValue ?? ""
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

// MARK: - SettingViewDelegate

extension AvatarViewController: SettingViewDelegate {
    func didTriggerTextField(of type: SettingViewType, with text: String?) {
        guard let text = text else {
            return
        }
        
        switch type {
        case .age:
            validateAge(text)
        case .height:
            validateHeight(text)
        case .weight:
            validateWeight(text)
        }
        
        rootView.disabledButton(enable: isAgeValid && isWeightValid && isHeightValid)
    }
}

// MARK: - WCSessionDelegate

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
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            guard
                let age = message["age"] as? Int,
                let height = message["height"] as? Float,
                let weight = message["weight"] as? Float
            else {
                print("There was an error with decoding")
                return
            }
            
            self.syncStats(age: age, height: height, weight: weight)
        }
    }
}

// MARK: - Private

private extension AvatarViewController {
    func validateAge(_ text: String) {
        isAgeValid = validationService.isValidAge(text: text)
        
        if isAgeValid {
            ageText = text
            rootView.showAgeValidationSuccess()
        } else {
            rootView.showAgeValidationError()
        }
    }
    
    func validateHeight(_ text: String) {
        isHeightValid = validationService.isValidHeight(text: text)
        
        if isHeightValid {
            heightText = text
            rootView.showHeightValidationSuccess()
        } else {
            rootView.showHeightValidationError()
        }
    }
    
    func validateWeight(_ text: String) {
        isWeightValid = validationService.isValidWeight(text: text)
        
        if isWeightValid {
            weightText = text
            rootView.showWeightValidationSuccess()
        } else {
            rootView.showWeightValidationError()
        }
    }
    
    func syncStats(age: Int, height: Float, weight: Float) {
        rootView.refreshStats(age: String(age), height: String(height), weight: String(weight))
    }
    
    private func selectMiddleCell() {
        let centerPoint = CGPoint(
            x: rootView.avatarCollectionView.contentOffset.x + rootView.avatarCollectionView.bounds.width / 2,
            y: rootView.avatarCollectionView.bounds.height / 2
        )

        if let indexPath = rootView.avatarCollectionView.indexPathForItem(at: centerPoint) {
            rootView.avatarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            selectedImage = models[safe: indexPath.row]?.stringValue ?? ""
            rootView.refreshAvatar(with: models[safe: indexPath.row])
        }
    }
    
    private func sendWatchMessage(avatarStats: AvatarStats, imageData: Data) {
        let currentTime = CFAbsoluteTimeGetCurrent()

        if lastMessage + 0.5 > currentTime {
            return
        }

        if (WCSession.default.isReachable) {
            let message = [
                "age": avatarStats.age,
                "height": avatarStats.height,
                "weight": avatarStats.weight
            ] as [String : Any]
            
            WCSession.default.sendMessage(message, replyHandler: nil)
            WCSession.default.sendMessageData(imageData, replyHandler: nil)
        } else {
            showAlert(title: "Error", message: "Apple Watch is not reachable")
        }

        lastMessage = CFAbsoluteTimeGetCurrent()
    }
}
