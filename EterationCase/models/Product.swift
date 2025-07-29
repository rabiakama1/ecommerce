//
//  Product.swift
//  EterationCase
//
//  Created by rabiakama on 27.07.2025.
//

import Foundation

struct Product: Codable, Hashable {
    let id: String
    let name: String
    let price: String
    let description: String
    let image: String
    let model: String
    let brand: String
    let createdAt: String
    
    // Computed property for price as Double
    var priceValue: Double {
        return Double(price) ?? 0.0
    }
    
    // Computed property for formatted price
    var formattedPrice: String {
        return "\(price) ₺"
    }
    init(id: String, name: String, price: String, description: String, image: String, model: String, brand: String, createdAt: String) {
        self.id = id
        self.name = name
        self.price = price
        self.description = description
        self.image = image
        self.model = model
        self.brand = brand
        self.createdAt = createdAt
    }
    
    init() {
         self.id = ""
         self.name = ""
         self.price = "0"
         self.description = ""
         self.image = ""
         self.model = ""
         self.brand = ""
         self.createdAt = ""
     }
}


// MARK: - Cart Item
struct CartItem {
    let product: Product
    var quantity: Int
    
    var totalPrice: Double {
        return product.priceValue * Double(quantity)
    }
    
    var formattedTotalPrice: String {
        return "\(Int(totalPrice)) ₺"
    }
}

// MARK: - Favorite Item
struct FavoriteItem {
    let product: Product
    let addedAt: Date
}
