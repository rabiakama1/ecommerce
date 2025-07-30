//
//  CartItemTableViewCell.swift
//  EterationCase
//
//  Created by rabiakama on 28.07.2025.
//

import UIKit

protocol CartItemCellDelegate: AnyObject {
    func didTapIncrease(on cell: CartItemTableViewCell)
    func didTapDecrease(on cell: CartItemTableViewCell)
}

class CartItemTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    
    weak var delegate: CartItemCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        // Bu kısımlar XIB'de de ayarlanabilir.
        decreaseButton.layer.cornerRadius = 8
        increaseButton.layer.cornerRadius = 8
    }

    func configure(with item: CartItem) {
        nameLabel.text = item.product.name
        priceLabel.text = item.product.formattedPrice
        quantityLabel.text = "\(item.quantity)"
    }
    
    @IBAction func decreaseButtonTapped(_ sender: UIButton) {
        delegate?.didTapDecrease(on: self)
    }
    
    @IBAction func increaseButtonTapped(_ sender: UIButton) {
        delegate?.didTapIncrease(on: self)
    }
}
