//
//  ProductCollectionViewCell.swift
//  TestCaseEteration
//
//  Created by rabiakama on 30.07.2025.
//

import UIKit

protocol ProductCellDelegate: AnyObject {
    func didTapFavorite(_ product: Product,cell: ProductCollectionViewCell)
    func didTapAddToCart(_ product: Product)
}

class ProductCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    private var currentImageURL: URL?

    // MARK: - Properties
    weak var delegate: ProductCellDelegate?
    private var product: Product?
    
    // MARK: - Initialization
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        // Product image
        productImageView.backgroundColor = .systemGray5
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 10
        
        // Favorite button
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.tintColor = .systemYellow
        favoriteButton.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        favoriteButton.layer.cornerRadius = 15
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
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
    }
    
    // MARK: - Configuration
    func configure(with product: Product, isFavorited: Bool) {
        self.product = product
        
        nameLabel.text = product.name
        priceLabel.text = product.formattedPrice
        dataLabel.text = product.model
        // Load image (placeholder for now)
        productImageView.image = UIImage(systemName: "photo")
        productImageView.tintColor = .systemGray3
        
        updateFavoriteButton(isFavorited: isFavorited)
        
        guard let imageURL = URL(string: product.image) else {
            print("Hata: Geçersiz URL string'i - \(product.image)")
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: imageURL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        if self?.currentImageURL == imageURL {
                            self?.productImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    func updateFavoriteButton(isFavorited: Bool) {
        let imageName = isFavorited ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = isFavorited ? .systemYellow : .systemGray
    }
    
    // MARK: - Actions
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        delegate?.didTapFavorite(product!,cell: self)
    }
    
    @IBAction func addToCartButtonTapped(_ sender: Any) {
        delegate?.didTapAddToCart(product!)
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.tintColor = .systemYellow
        product = nil
    }
}
