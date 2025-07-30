//
//  CartViewModel.swift
//  EterationCase
//
//  Created by rabiakama on 27.07.2025.
//

import Foundation

class CartViewModel {
    
    // MARK: - Properties
    private var cartItems: [CartItem] = []
    
    // MARK: - Observers
    var onCartUpdated: (() -> Void)?
    var onCartEmpty: (() -> Void)?
    
    // MARK: - Computed Properties
    var items: [CartItem] = []

    
    var totalPrice: Double {
        return cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var formattedTotalPrice: String {
        let total = cartItems.reduce(0) { $0 + $1.totalPrice }
        return "\(total) ₺"
    }
    
    func increaseQuantity(for item: CartItem) {
        let newQuantity = item.quantity + 1
        updateQuantity(for: item.product.id, newQuantity: newQuantity)
    }
    
    func decreaseQuantity(for item: CartItem) {
        let newQuantity = item.quantity - 1
        updateQuantity(for: item.product.id, newQuantity: newQuantity)
    }
    func updateQuantity(for productId: String, newQuantity: Int) {
        guard let index = cartItems.firstIndex(where: { $0.product.id == productId }) else { return }
        
        if newQuantity <= 0 {
            removeItem(at: index)
        } else {
            cartItems[index].quantity = newQuantity
            CoreDataManager.shared.addOrUpdateProductInCart(product: cartItems[index].product, quantity: newQuantity)
            onCartUpdated?()
        }
    }
    
    func removeItem(at index: Int) {
        guard index >= 0 && index < cartItems.count else { return }
        
        let productId = cartItems[index].product.id
        CoreDataManager.shared.removeProductFromCart(productId: productId)
        cartItems.remove(at: index)
        
        if cartItems.isEmpty {
            onCartEmpty?()
        } else {
            onCartUpdated?()
        }
    }
    
    func loadCartItems() {
        cartItems = CoreDataManager.shared.fetchCartItems()
        if cartItems.isEmpty {
            onCartEmpty?()
        } else {
            onCartUpdated?()
        }
    }
    
    func getItem(at index: Int) -> CartItem? {
        guard index >= 0 && index < items.count else { return nil }
        return items[index]
    }
    
    
    func clearCart() {
        for item in cartItems {
            CoreDataManager.shared.removeProductFromCart(productId: item.product.id)
        }
        cartItems.removeAll()
        onCartUpdated?()
        onCartEmpty?()
    }
    
    func completeOrder() {
        clearCart()
    }
}
