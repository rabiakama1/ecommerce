//
//  FavoriteTableViewCell.swift
//  EterationCase
//
//  Created by rabiakama on 28.07.2025.
//

import UIKit

// MARK: - CartItemCellDelegate
protocol CartItemCellDelegate: AnyObject {
    func didTapIncrease(on cell: CartItemTableViewCell)
    func didTapDecrease(on cell: CartItemTableViewCell)
}

// MARK: - CartItemCell
class CartItemTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UIButton!
    
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    
    
    // MARK: - Properties
    weak var delegate: CartItemCellDelegate?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        decreaseButton.layer.cornerRadius = 8
        increaseButton.layer.cornerRadius = 8
    }

    // MARK: - Configuration
    /// - Parameter item: Hücrede gösterilecek verileri içeren bir model.
    func configure(with item: CartItem) {
        nameLabel.text = item.product.name
        priceLabel.text = item.totalPrice.description
        quantityLabel.titleLabel?.text = item.quantity.description
    }
    
    // MARK: - IBActions
    @IBAction func decreaseButtonTapped(_ sender: UIButton) {
        delegate?.didTapDecrease(on: self)
    }
    
    @IBAction func increaseButtonTapped(_ sender: UIButton) {
        delegate?.didTapIncrease(on: self)
    }
}
