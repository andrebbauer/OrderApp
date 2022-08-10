//
//  OrderConfirmationView.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 06/08/22.
//

import UIKit

class OrderConfirmationView: UIView {
    
    let stackView = UIStackView()
    let confirmationLabel = UILabel()
    let submitButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        
        confirmationLabel.numberOfLines = 0
        confirmationLabel.textAlignment = .center
        confirmationLabel.text = "Hello you've been serveed"
        
        submitButton.setTitle("Dismiss", for: .normal)
        submitButton.setTitleColor(.systemBlue, for: .normal)
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(confirmationLabel)
        stackView.addArrangedSubview(submitButton)
    }
    
    func setupLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            submitButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
        ])
    }
}
