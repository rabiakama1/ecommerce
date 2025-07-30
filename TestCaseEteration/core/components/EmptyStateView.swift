//
//  EmptyStateView.swift
//  TestCaseEteration
//
//  Created by rabiakama on 30.07.2025.
//
import UIKit

class EmptyStateView: UIView {
    
    // MARK: - UI Components
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray4
        imageView.image = UIImage(systemName: "basket")
        return imageView
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    /// Bu component'i dışarıdan gelen veriyle yapılandırır.
    /// - Parameters:
    ///   - message: Ekranda gösterilecek metin.
    ///   - icon: Metnin üzerinde gösterilecek ikon (opsiyonel).
    public func configure(with message: String, icon: UIImage? = UIImage(systemName: "basket")) {
        messageLabel.text = message
        iconImageView.image = icon
        // Eğer ikon nil ise, image view'i gizle
        iconImageView.isHidden = (icon == nil)
    }
    
    // MARK: - Private Setup
    
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, messageLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        // Auto Layout ile konumlandırma
        NSLayoutConstraint.activate([
            // İkonun boyutunu sabitleyelim
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            
            // StackView'i ortalayalım
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            // StackView'in kenarlara çok yapışmamasını sağlayalım
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40)
        ])
    }
}
