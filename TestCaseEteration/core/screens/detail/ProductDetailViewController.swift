//
//  ProductDetailViewController.swift
//  EterationCase
//
//  Created by rabiakama on 28.07.2025.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    // MARK: - UI Components
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addProductToCartButton: UIButton!
    
    // MARK: - Properties
    private let product: Product
    
    // MARK: - Initialization
    init(product: Product) {
        self.product = product
        super.init(nibName: "ProductDetailViewController", bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithProduct()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        // Navigation bar setup
        navigationItem.title = product.name
        navigationItem.largeTitleDisplayMode = .never
        
        // Product image
        productImageView.backgroundColor = .systemGray5
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 12
        
        // Favorite button
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.tintColor = .systemYellow
        favoriteButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        favoriteButton.layer.cornerRadius = 20
        favoriteButton.layer.shadowColor = UIColor.black.cgColor
        favoriteButton.layer.shadowOpacity = 0.2
        favoriteButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        favoriteButton.layer.shadowRadius = 4
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        // Name label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        
        // Description label
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        // Price label
        priceLabel.font = UIFont.boldSystemFont(ofSize: 20)
        priceLabel.textColor = .systemBlue
        priceLabel.textAlignment = .left
        
        // Add to cart button
        addProductToCartButton.setTitle("Add to Cart", for: .normal)
        addProductToCartButton.setTitleColor(.white, for: .normal)
        addProductToCartButton.backgroundColor = .systemBlue
        addProductToCartButton.layer.cornerRadius = 12
        addProductToCartButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        addProductToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
    }
    

    
    private func configureWithProduct() {
        nameLabel.text = product.name
        descriptionLabel.text = product.description
        priceLabel.text = "Price: \(product.formattedPrice)"
        
        // Load image (placeholder for now)
        productImageView.image = UIImage(systemName: "photo")
        productImageView.tintColor = .systemGray3
        
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        let isFavorited = CoreDataManager.shared.isProductInFavorites(productId: product.id)
        let imageName = isFavorited ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = isFavorited ? .systemYellow : .systemGray
    }
    
    // MARK: - Actions
    @objc private func favoriteButtonTapped() {
        if CoreDataManager.shared.isProductInFavorites(productId: product.id) {
            CoreDataManager.shared.removeFromFavorites(productId: product.id)
        } else {
            CoreDataManager.shared.addToFavorites(product: product)
        }
        updateFavoriteButton()
    }
    
    @objc private func addToCartButtonTapped() {
        CoreDataManager.shared.addOrUpdateProductInCart(product: product, quantity: 1)
        
        let alert = UIAlertController(title: "Success", message: "\(product.name) added to cart!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

