//
//  CartViewModel.swift
//  EterationCase
//
//  Created by rabiakama on 27.07.2025.
//

import Foundation
import UIKit

class CartItemViewModel {

    // MARK: - Properties
    private var cartItems: [CartItem] = []

    // MARK: - Observers
    var onCartItemsLoaded: (() -> Void)?
    var onCartItemsFailed: ((String) -> Void)?
    var onCartUpdated: (() -> Void)?

    // MARK: - Computed Properties
    var totalPrice: Double {
        return cartItems.reduce(0) { $0 + $1.totalPrice }
    }

    var formattedTotalPrice: String {
        return "\(Int(totalPrice)) ₺"
    }

    var itemCount: Int {
        return cartItems.count
    }

    // MARK: - Public Methods

    func loadCartItems() {
        cartItems = CoreDataManager.shared.fetchCartItems()
        onCartItemsLoaded?()
    }

    func updateQuantity(for productId: String, newQuantity: Int) {
        guard let cartItem = cartItems.first(where: { $0.product.id == productId }) else { return }

        if newQuantity <= 0 {
            removeItem(productId: productId)
        } else {
            CoreDataManager.shared.addOrUpdateProductInCart(product: cartItem.product, quantity: newQuantity)
            loadCartItems()
        }
    }

    func removeItem(productId: String) {
        CoreDataManager.shared.removeProductFromCart(productId: productId)
        loadCartItems()
    }

    func clearCart() {
        CoreDataManager.shared.clearCart()
        loadCartItems()
    }

    func getItem(at index: Int) -> CartItem? {
        guard index >= 0 && index < cartItems.count else { return nil }
        return cartItems[index]
    }

    func completeOrder() {
        // Order completion logic would go here
        // For now, just clear the cart
        clearCart()
    }

    // MARK: - Helper Methods

    func getCartItems() -> [CartItem] {
        return cartItems
    }

    func isEmpty() -> Bool {
        return cartItems.isEmpty
    }
} 
