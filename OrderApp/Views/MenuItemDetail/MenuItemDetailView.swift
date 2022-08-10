//
//  MenuItemDetailView.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 05/08/22.
//

import UIKit

class MenuItemDetailView: UIView {
    
    let imageView = UIImageView()
    let hStackView = UIStackView()
    let vStackView = UIStackView()
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let detailLabel = UILabel()
    let view = UIView()
    let addButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imageView.image = UIImage(systemName: "photo.on.rectangle")
        imageView.contentMode = .scaleAspectFit
        
        vStackView.axis = .vertical
        vStackView.spacing = 20
        vStackView.distribution = .fill
        vStackView.alignment = .fill
        
        hStackView.axis = .horizontal
        hStackView.spacing = 20
        hStackView.distribution = .fill
        hStackView.alignment = .fill
        
        nameLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        nameLabel.numberOfLines = 0
        
        priceLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        priceLabel.textAlignment = .right
        
        detailLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        detailLabel.numberOfLines = 0
        
        addButton.setTitle("Add To Order", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 5.0
        
        addSubview(vStackView)
        addSubview(addButton)
        
        vStackView.addArrangedSubview(imageView)
        vStackView.addArrangedSubview(hStackView)
        vStackView.addArrangedSubview(detailLabel)
        vStackView.addArrangedSubview(view)

        hStackView.addArrangedSubview(nameLabel)
        hStackView.addArrangedSubview(priceLabel)
    }
    
    private func setupLayout() {
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.setContentHuggingPriority(UILayoutPriority.init(rawValue: 250), for: .horizontal)
        priceLabel.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 1000), for: .horizontal)
        
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            vStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            vStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            vStackView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20),
            
            imageView.heightAnchor.constraint(equalTo: imageView.superview!.heightAnchor, multiplier: 0.25),
            
            addButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func setup(with item: MenuItem, image: UIImage?) {
        nameLabel.text = item.name
        priceLabel.text = item.price.currency
        detailLabel.text = item.detailText
        imageView.image = image ?? UIImage(systemName: "photo.on.rectangle")
    }
    
    func setupImage(_ image: UIImage?) {
        imageView.image = image
    }
}
