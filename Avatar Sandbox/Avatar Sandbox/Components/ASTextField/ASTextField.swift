//
//  ASTextField.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

import UIKit

final class ASTextField: UIView {

    // MARK: - Outlets
    
    private let inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        return stackView
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
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
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.textAlignment = .center
        textField.font = UIFont(name: "Optima", size: 17)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Optima Bold", size: 17)
        label.textColor = .systemRed
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    // MARK: - Properties
    
    
    weak var delegate: ASTextFieldDelegate?
    var animationDuration: Double = 0.3
    
    private var type: ASTextFieldType {
        didSet {
            titleLabel.text = type.rawValue
        }
    }
    
    // MARK: - Life cycle
    
    init(type: ASTextFieldType) {
        self.type = type
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func setTitle(_ text: String?) {
        titleLabel.text = text
    }
    
    public func setPlaceholder(_ text: String?) {
        textField.placeholder = text
    }
    
    public func showError(_ text: String?) {
        DispatchQueue.main.async {
            self.errorLabel.text = text
            self.textField.errorAnimation()
            UIView.animate(withDuration: self.animationDuration) {
                self.errorLabel.isHidden = false
                self.layoutIfNeeded()
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
        containerStackView.addArrangedSubview(inputStackView)
        inputStackView.addArrangedSubview(textField)
        inputStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(errorLabel)
    }
    
    private func setupConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
    }
}

// MARK: - UITextFieldDelegate

extension ASTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: animationDuration) {
            self.textField.layer.borderColor = UIColor.black.cgColor
            self.errorLabel.isHidden = true
            self.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didTriggerTextField(of: type, with: textField.text)
    }
}
