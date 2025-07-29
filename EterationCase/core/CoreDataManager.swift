//
//  CoreDataManager.swift
//  EterationCase
//
//  Created by rabiakama on 28.07.2025.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "E_Market")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Cart Operations
    
    // Sepete Ürün Ekleme/Güncelleme
    func addOrUpdateProductInCart(product: Product, quantity: Int) {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %@", product.id)
        
        do {
            let existingItems = try context.fetch(fetchRequest)
            
            if let existingItem = existingItems.first {
                // Update existing item
                existingItem.quantity = Int32(quantity)
                existingItem.updatedAt = Date()
            } else {
                // Create new item
                let newItem = CartItemEntity(context: context)
                newItem.productId = product.id
                newItem.productName = product.name
                newItem.productPrice = product.price
                newItem.productImage = product.image
                newItem.productDescription = product.description
                newItem.productModel = product.model
                newItem.productBrand = product.brand
                newItem.quantity = Int32(quantity)
                newItem.createdAt = Date()
                newItem.updatedAt = Date()
            }
            
            saveContext()
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        } catch {
            print("Error adding/updating cart item: \(error)")
        }
    }

    // Sepetten Ürün Silme
    func removeProductFromCart(productId: String) {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %@", productId)
        
        do {
            let items = try context.fetch(fetchRequest)
            for item in items {
                context.delete(item)
            }
            saveContext()
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        } catch {
            print("Error removing cart item: \(error)")
        }
    }

    // Sepetteki Tüm Ürünleri Getirme
    func fetchCartItems() -> [CartItem] {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.compactMap { entity in
                guard let productId = entity.productId,
                      let productName = entity.productName,
                      let productPrice = entity.productPrice,
                      let productImage = entity.productImage,
                      let productDescription = entity.productDescription,
                      let productModel = entity.productModel,
                      let productBrand = entity.productBrand,
                      let createdAt = entity.createdAt else {
                    return nil
                }
                let isoFormatter = ISO8601DateFormatter()
                let dateString = isoFormatter.string(from: createdAt)
                let product = Product(
                    id: productId,
                    name: productName,
                    price: productPrice,
                    description: productDescription,
                    image: productImage,
                    model: productModel,
                    brand: productBrand,
                    createdAt: dateString
                )
                
                return CartItem(product: product, quantity: Int(entity.quantity))
            }
        } catch {
            print("Error fetching cart items: \(error)")
            return []
        }
    }
    
    // Sepetteki toplam ürün sayısını getirme
    func getCartItemCount() -> Int {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.reduce(0) { $0 + Int($1.quantity) }
        } catch {
            print("Error getting cart count: \(error)")
            return 0
        }
    }
    
    // MARK: - Favorites Operations
    
    // Favorilere Ürün Ekleme
    func addToFavorites(product: Product) {
        let fetchRequest: NSFetchRequest<FavoriteItemEntity> = FavoriteItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %@", product.id)
        
        do {
            let existingItems = try context.fetch(fetchRequest)
            
            if existingItems.isEmpty {
                let newItem = FavoriteItemEntity(context: context)
                newItem.productId = product.id
                newItem.productName = product.name
                newItem.productPrice = product.price
                newItem.productImage = product.image
                newItem.productDescription = product.description
                newItem.productModel = product.model
                newItem.productBrand = product.brand
                newItem.addedAt = Date()
                
                saveContext()
                NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
            }
        } catch {
            print("Error adding to favorites: \(error)")
        }
    }
    
    // Favorilerden Ürün Silme
    func removeFromFavorites(productId: String) {
        let fetchRequest: NSFetchRequest<FavoriteItemEntity> = FavoriteItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %@", productId)
        
        do {
            let items = try context.fetch(fetchRequest)
            for item in items {
                context.delete(item)
            }
            saveContext()
            NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
        } catch {
            print("Error removing from favorites: \(error)")
        }
    }
    
    // Favorilerdeki Tüm Ürünleri Getirme
    func fetchFavoriteItems() -> [FavoriteItem] {
        let fetchRequest: NSFetchRequest<FavoriteItemEntity> = FavoriteItemEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.compactMap { entity in
                guard let productId = entity.productId,
                      let productName = entity.productName,
                      let productPrice = entity.productPrice,
                      let productImage = entity.productImage,
                      let productDescription = entity.productDescription,
                      let productModel = entity.productModel,
                      let productBrand = entity.productBrand,
                      let addedAt = entity.addedAt else {
                    return nil
                }
                
                let product = Product(
                    id: productId,
                    name: productName,
                    price: productPrice,
                    description: productDescription,
                    image: productImage,
                    model: productModel,
                    brand: productBrand,
                    createdAt: addedAt.description
                )
                
                return FavoriteItem(product: product, addedAt: addedAt)
            }
        } catch {
            print("Error fetching favorite items: \(error)")
            return []
        }
    }
    
    // Ürünün favorilerde olup olmadığını kontrol etme
    func isProductInFavorites(productId: String) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteItemEntity> = FavoriteItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %@", productId)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking favorites: \(error)")
            return false
        }
    }
    
    // Sepeti temizleme
    func clearCart() {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        
        do {
            let items = try context.fetch(fetchRequest)
            for item in items {
                context.delete(item)
            }
            saveContext()
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        } catch {
            print("Error clearing cart: \(error)")
        }
    }
    
    // Değişiklikleri Kaydetme
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

import Foundation

extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
    static let favoritesUpdated = Notification.Name("favoritesUpdated")
}
