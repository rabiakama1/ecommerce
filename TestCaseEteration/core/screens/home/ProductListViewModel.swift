//
//  ProductListViewModel.swift
//  EterationCase
//
//  Created by rabiakama on 27.07.2025.
//

import Foundation

class ProductListViewModel {
    
    // MARK: - Properties
    private var allProducts: [Product] = []
    private var filteredProducts: [Product] = []
    private var currentPage = 1
    private var isLoading = false
    private var hasMoreData = true
    
    // MARK: - Observers
    var onProductsLoaded: (() -> Void)?
    var onProductsFailed: ((String) -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onSearchResultsUpdated: (() -> Void)?
    
    // MARK: - Computed Properties
    var products: [Product] {
        return filteredProducts.isEmpty ? allProducts : filteredProducts
    }
    
    var isSearching: Bool {
        return !filteredProducts.isEmpty
    }
    
    // MARK: - Public Methods
    
    func loadProducts(isRefresh: Bool = false) {
        if isLoading { return }
        
        if isRefresh {
            currentPage = 1
            allProducts.removeAll()
            filteredProducts.removeAll()
        }
        
        isLoading = true
        onLoadingChanged?(true)
        
        NetworkManager.shared.fetchProductsWithPagination(page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.onLoadingChanged?(false)
                
                switch result {
                case .success(let products):
                    if isRefresh {
                        self?.allProducts = products
                    } else {
                        self?.allProducts.append(contentsOf: products)
                    }
                    
                    self?.currentPage += 1
                    self?.hasMoreData = products.count == 4 // API'den 4'lü sayfalama
                    self?.onProductsLoaded?()
                    
                case .failure(let error):
                    self?.onProductsFailed?(error.localizedDescription)
                }
            }
        }
    }
    
    func searchProducts(query: String) {
        guard !query.isEmpty else {
            filteredProducts.removeAll()
            onSearchResultsUpdated?()
            return
        }
        
        filteredProducts = allProducts.filter { product in
            product.name.lowercased().contains(query.lowercased()) ||
            product.brand.lowercased().contains(query.lowercased()) ||
            product.model.lowercased().contains(query.lowercased())
        }
        
        onSearchResultsUpdated?()
    }
    
    func clearSearch() {
        filteredProducts.removeAll()
        onSearchResultsUpdated?()
    }
    
    func loadMoreProducts() {
        guard !isLoading && hasMoreData && !isSearching else { return }
        loadProducts()
    }
    
    func refreshProducts() {
        loadProducts(isRefresh: true)
    }
    
    func getProduct(at index: Int) -> Product? {
        guard index >= 0 && index < products.count else { return nil }
        return products[index]
    }
    
    func toggleFavorite(for product: Product) {
        if CoreDataManager.shared.isProductInFavorites(productId: product.id) {
            CoreDataManager.shared.removeFromFavorites(productId: product.id)
        } else {
            CoreDataManager.shared.addToFavorites(product: product)
        }
    }
    
    func isProductFavorited(_ product: Product) -> Bool {
        return CoreDataManager.shared.isProductInFavorites(productId: product.id)
    }
    
    func addToCart(product: Product) {
        CoreDataManager.shared.addOrUpdateProductInCart(product: product, quantity: 1)
    }
} 
