//
//  CartViewModelTest.swift
//  TestCaseEterationTests
//
//  Created by rabiakama on 31.07.2025.
//

import XCTest
@testable import TestCaseEteration

class CartViewModelTests: XCTestCase {

    var viewModel: CartViewModel!

    override func setUp() {
        super.setUp()
        viewModel = CartViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }


    func testTotalPriceCalculation_WithMultipleItems_ShouldReturnCorrectSum() {
        let product1 = Product(id: "1", name: "Laptop", price: "100", description: "", image: "", model: "", brand: "", createdAt: "")
        let product2 = Product(id: "2", name: "Mouse", price: "50", description: "", image: "", model: "", brand: "", createdAt: "")
        
        let cartItem1 = CartItem(product: product1, quantity: 2)
        let cartItem2 = CartItem(product: product2, quantity: 3)
        
        let testCartItems = [cartItem1, cartItem2]
        
        let expectedTotalPrice = 350.0
        
        viewModel.items = testCartItems
        
        XCTAssertEqual(viewModel.totalPrice, expectedTotalPrice, "Toplam fiyat hesaplaması yanlış.")
    }
}
