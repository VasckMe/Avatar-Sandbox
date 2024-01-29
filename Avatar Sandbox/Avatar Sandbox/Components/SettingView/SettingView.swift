//
//  ASInputView.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

import UIKit
import SwiftUI

protocol SettingViewDelegate: AnyObject {
    func didTriggerTextField(of type: SettingViewType, with text: String?)
}

final class SettingView: UIView {
    private let animationDuration: Double = 0.3
    
    weak var delegate: SettingViewDelegate?
    
    private var type: SettingViewType
    
    // MARK: - Outlets
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Optima", size: 17)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.addTarget(self, action: #selector(selectAndStopEditing), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderDidChange), for: .valueChanged)
        slider.addTarget(self, action: #selector(deselectTextField), for: .touchUpInside)
        slider.addTarget(self, action: #selector(deselectTextField), for: .touchUpOutside)

        return slider
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .lightGray
        textField.textAlignment = .center
        textField.font = UIFont(name: "Optima", size: 17)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 10
        textField.keyboardType = .numberPad
        return textField
    }()
    
    // MARK: - Life cycle
    
    init(type: SettingViewType) {
        self.type = type
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func sliderDidChange() {
        if type == .age {
            let formattedValue = Int(slider.value * 100)
            textField.text = String(formattedValue)
        } else {
            let formattedValue = (slider.value * 1000).rounded() / 10
            textField.text = String(formattedValue)
        }
        
        delegate?.didTriggerTextField(of: type, with: textField.text)
    }
    
    @objc func selectAndStopEditing() {
        if textField.isEditing {
            textField.resignFirstResponder()
        }
        
        UIView.animate(withDuration: 0.1) {
            self.textField.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @objc func deselectTextField() {
        textField.layer.borderColor = UIColor.gray.cgColor
    }
    
    // MARK: - Methods
    
    public func setTitle(_ text: String?) {
        titleLabel.text = text
    }
    
    public func setText(_ text: String?) {
        textField.text = text
        slider.value = (Float(text ?? "0") ?? 0) / 100
    }
    
    public func setPlaceholder(_ text: String?) {
        textField.placeholder = text
    }
    
    public func setValidated() {
        UIView.animate(withDuration: 0.1) {
            self.textField.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    public func showError() {
        DispatchQueue.main.async {
            self.textField.errorAnimation()
            UIView.animate(withDuration: self.animationDuration) {
                self.layoutIfNeeded()
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension SettingView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        let value = (Float(text) ?? 0) / 100
        slider.setValue(value, animated: true)
        delegate?.didTriggerTextField(of: type, with: textField.text)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: animationDuration) {
            self.textField.layer.borderColor = UIColor.white.cgColor
            self.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didTriggerTextField(of: type, with: textField.text)
        UIView.animate(withDuration: 0.1) {
            textField.layer.borderColor = UIColor.gray.cgColor
        }
    }
}

// MARK: - Private setup

private extension SettingView {
    func configure() {
        configureTextField()
        configureTitleLabel()
        addSubviews()
        setupConstraints()
    }
    
    func configureTextField() {
        textField.delegate = self
    }
    
    func configureTitleLabel() {
        titleLabel.text = type.typeTitle
    }
    
    func addSubviews() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(slider)
        containerStackView.addArrangedSubview(textField)
        containerStackView.addArrangedSubview(titleLabel)
    }
    
    func setupConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        slider.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        slider.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        textField.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
        
        slider.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
    }
}

// MARK: - Preview

struct ASTextField_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer  {
            let view = SettingView(type: .age)
            return view
        }
        .previewLayout(.sizeThatFits)
        .frame(width: 200, height: 30)
    }
}
