//
//  FavoriteProductCell.swift
//  EterationCase
//
//  Created by rabiakama on 27.07.2025.
//

import UIKit

protocol FavoriteProductCellDelegate: AnyObject {
    func didTapRemoveFavorite(_ cell: FavoriteProductCell)
    func didTapAddToCart(_ cell: FavoriteProductCell)
}

class FavoriteProductCell: UICollectionViewCell {

    // MARK: - UI Components
    private let containerView = UIView()
    private let productImageView = UIImageView()
    private let removeFavoriteButton = UIButton(type: .system)
    private let priceLabel = UILabel()
    private let nameLabel = UILabel()
    private let addToCartButton = UIButton(type: .system)

    // MARK: - Properties
    weak var delegate: FavoriteProductCellDelegate?
    private var product: Product?

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupUI() {
        backgroundColor = .clear

        // Container view
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4

        // Product image
        productImageView.backgroundColor = .systemGray5
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 8

        // Remove favorite button
        removeFavoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        removeFavoriteButton.tintColor = .systemYellow
        removeFavoriteButton.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        removeFavoriteButton.layer.cornerRadius = 15
        removeFavoriteButton.addTarget(self, action: #selector(removeFavoriteButtonTapped), for: .touchUpInside)

        // Price label
        priceLabel.font = UIFont.boldSystemFont(ofSize: 16)
        priceLabel.textColor = .systemBlue
        priceLabel.textAlignment = .left

        // Name label
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .left

        // Add to cart button
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.backgroundColor = .systemBlue
        addToCartButton.layer.cornerRadius = 8
        addToCartButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)

        // Add subviews
        contentView.addSubview(containerView)
        containerView.addSubview(productImageView)
        containerView.addSubview(removeFavoriteButton)
        containerView.addSubview(priceLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(addToCartButton)
    }

    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        removeFavoriteButton.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            // Product image
            productImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            productImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            productImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: 0.8),

            // Remove favorite button
            removeFavoriteButton.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 8),
            removeFavoriteButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -8),
            removeFavoriteButton.widthAnchor.constraint(equalToConstant: 30),
            removeFavoriteButton.heightAnchor.constraint(equalToConstant: 30),

            // Price label
            priceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),

            // Name label
            nameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),

            // Add to cart button
            addToCartButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            addToCartButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            addToCartButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            addToCartButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            addToCartButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    // MARK: - Configuration
    func configure(with product: Product) {
        self.product = product

        nameLabel.text = product.name
        priceLabel.text = product.formattedPrice

        // Load image (placeholder for now)
        productImageView.image = UIImage(systemName: "photo")
        productImageView.tintColor = .systemGray3
    }

    // MARK: - Actions
    @objc private func removeFavoriteButtonTapped() {
        delegate?.didTapRemoveFavorite(self)
    }

    @objc private func addToCartButtonTapped() {
        delegate?.didTapAddToCart(self)
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        product = nil
    }
} 
