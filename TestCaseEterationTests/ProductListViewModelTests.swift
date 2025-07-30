//
//  ProductListViewModelTests.swift
//  TestCaseEterationTests
//
//  Created by rabiakama on 31.07.2025.
//

import XCTest

import XCTest
@testable import TestCaseEteration

class ProductListViewModelTests: XCTestCase {

    var viewModel: ProductListViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ProductListViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testSearchProducts_WithMatchingQuery_ShouldReturnFilteredResults() {
        let product1 = Product(id: "1", name: "Apple iPhone 15", price: "6700", description: "", image: "", model: "Apple", brand: "", createdAt: "")
        let product2 = Product(id: "2", name: "Samsung Galaxy S24", price: "9700", description: "", image: "", model: "Samsung", brand: "", createdAt: "")
        let product3 = Product(id: "3", name: "Samsung Galaxy S25", price: "8700", description: "", image: "", model: "Samsung", brand: "", createdAt: "")
        viewModel.allProducts = [product1, product2, product3]
        viewModel.searchProducts(query: "Apple")
        
        XCTAssertEqual(viewModel.products.count, 2, "viewModel.products'ın arama sonucunu döndürmesi gerekiyordu.")
 
        viewModel.clearSearch()
        
        XCTAssertEqual(viewModel.products.count, 3, "Arama temizlendiğinde viewModel.products'ın tüm ürünleri döndürmesi gerekiyordu.")
    }
}
