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
 //   var items: [CartItem] = []
    var items: [CartItem] {
        return cartItems
    }
    
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
    
    func loadCartItems() {
          cartItems = CoreDataManager.shared.fetchCartItems()
          onCartUpdated?()
      }
      
      func removeItem(at index: Int) {
          cartItems.remove(at: index)
          onCartUpdated?()
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
