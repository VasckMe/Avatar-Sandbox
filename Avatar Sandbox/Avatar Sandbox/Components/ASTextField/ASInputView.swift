//
//  ASInputView.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

import UIKit
import SwiftUI

final class ASInputView: UIView {

    // MARK: - Outlets
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Optima", size: 17)
        label.textColor = .black
        label.textAlignment = .left
        label.text = type.rawValue
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
    
    // MARK: - Properties
    
    weak var delegate: ASInputViewDelegate?
    var animationDuration: Double = 0.3
    
    private var type: ASInputViewType {
        didSet {
            titleLabel.text = type.rawValue
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 30)
    }
    
    // MARK: - Life cycle
    
    init(type: ASInputViewType) {
        self.type = type
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @Objc methods
    
    @objc func sliderDidChange() {
        let formattedValue = Int(slider.value * 100)
        textField.text = String(formattedValue)
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
    
    public func validate(isValid: Bool) {
        if isValid {
            UIView.animate(withDuration: 0.1) {
                self.textField.layer.borderColor = UIColor.white.cgColor
            }
        } else {
            DispatchQueue.main.async {
                self.textField.errorAnimation()
                UIView.animate(withDuration: self.animationDuration) {
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    private func configure() {
        configureTextField()
        addSubviews()
        setupConstraints()
    }
    
    private func configureTextField() {
        textField.delegate = self
    }
    
    private func addSubviews() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(slider)
        containerStackView.addArrangedSubview(textField)
        containerStackView.addArrangedSubview(titleLabel)
    }
    
    private func setupConstraints() {
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

// MARK: - UITextFieldDelegate

extension ASInputView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let value = (Float(textField.text!) ?? 0) / 100
        slider.setValue(value, animated: true)
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

// MARK: - Preview

struct ASTextField_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer  {
            let view = ASInputView(type: .age)
            return view
        }
        .previewLayout(.sizeThatFits)
    }
}
