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
    var items: [CartItem] {
        return cartItems
    }
    
    var totalPrice: Double {
        return cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var formattedTotalPrice: String {
        return "\(Int(totalPrice)) ₺"
    }
    
    var itemCount: Int {
        return cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    // MARK: - Public Methods
    
    func loadCartItems() {
        cartItems = CoreDataManager.shared.fetchCartItems()
        onCartUpdated?()
        
        if cartItems.isEmpty {
            onCartEmpty?()
        }
    }
    
    func updateQuantity(for productId: String, quantity: Int) {
        guard let index = cartItems.firstIndex(where: { $0.product.id == productId }) else { return }
        
        if quantity <= 0 {
            removeItem(at: index)
        } else {
            cartItems[index].quantity = quantity
            CoreDataManager.shared.addOrUpdateProductInCart(product: cartItems[index].product, quantity: quantity)
        }
        
        onCartUpdated?()
    }
    
    func removeItem(at index: Int) {
        guard index >= 0 && index < cartItems.count else { return }
        
        let productId = cartItems[index].product.id
        CoreDataManager.shared.removeProductFromCart(productId: productId)
        cartItems.remove(at: index)
        
        onCartUpdated?()
        
        if cartItems.isEmpty {
            onCartEmpty?()
        }
    }
    
    func clearCart() {
        for item in cartItems {
            CoreDataManager.shared.removeProductFromCart(productId: item.product.id)
        }
        cartItems.removeAll()
        onCartUpdated?()
        onCartEmpty?()
    }
    
    func getItem(at index: Int) -> CartItem? {
        guard index >= 0 && index < cartItems.count else { return nil }
        return cartItems[index]
    }
    
    func completeOrder() {
        // Here you would typically send the order to a server
        // For now, we'll just clear the cart
        clearCart()
    }
} 
