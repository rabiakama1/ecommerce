//
//  FilterViewController.swift
//  EterationCase
//
//  Created by rabiakama on 27.07.2025.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didApplyFilter(_ filter: ProductFilter)
    func didResetFilters()
}

struct ProductFilter {
    var minPrice: Double?
    var maxPrice: Double?
    var brands: [String] = []
    var models: [String] = []
    var sortBy: SortOption = .name
    
    enum SortOption: String, CaseIterable {
        case name = "Name"
        case priceLowToHigh = "Price (Low to High)"
        case priceHighToLow = "Price (High to Low)"
        case brand = "Brand"
    }
}

class FilterViewController: UIViewController {
    
    // MARK: - UI Components
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Price range
    private let priceRangeLabel = UILabel()
    private let minPriceTextField = UITextField()
    private let maxPriceTextField = UITextField()
    
    // Sort options
    private let sortLabel = UILabel()
    private let sortSegmentedControl = UISegmentedControl()
    
    // Apply button
    private let applyButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    
    // MARK: - Properties
    weak var delegate: FilterViewControllerDelegate?
    var currentFilter = ProductFilter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        populateUIFromCurrentFilter()
    }
    
    private func populateUIFromCurrentFilter() {
        if let minPrice = currentFilter.minPrice {
            minPriceTextField.text = "\(Int(minPrice))"
        }
        if let maxPrice = currentFilter.maxPrice {
            maxPriceTextField.text = "\(Int(maxPrice))"
        }
        if let selectedIndex = ProductFilter.SortOption.allCases.firstIndex(of: currentFilter.sortBy) {
            sortSegmentedControl.selectedSegmentIndex = selectedIndex
        }
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Header
        headerView.backgroundColor = UIColor.systemBlue
        
        titleLabel.text = "Filters"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        
        closeButton.setTitle("✕", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        // Scroll view
        scrollView.showsVerticalScrollIndicator = false
        
        // Price range
        priceRangeLabel.text = "Price Range"
        priceRangeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        priceRangeLabel.textColor = .label
        
        minPriceTextField.placeholder = "Min Price"
        minPriceTextField.borderStyle = .roundedRect
        minPriceTextField.keyboardType = .decimalPad
        
        maxPriceTextField.placeholder = "Max Price"
        maxPriceTextField.borderStyle = .roundedRect
        maxPriceTextField.keyboardType = .decimalPad
        
        // Sort options
        sortLabel.text = "Sort By"
        sortLabel.font = UIFont.boldSystemFont(ofSize: 16)
        sortLabel.textColor = .label
        
        let sortOptions = ProductFilter.SortOption.allCases.map { $0.rawValue }
        sortSegmentedControl.insertSegment(withTitle: sortOptions[0], at: 0, animated: false)
        sortSegmentedControl.insertSegment(withTitle: sortOptions[1], at: 1, animated: false)
        sortSegmentedControl.insertSegment(withTitle: sortOptions[2], at: 2, animated: false)
        sortSegmentedControl.insertSegment(withTitle: sortOptions[3], at: 3, animated: false)
        sortSegmentedControl.selectedSegmentIndex = 0
        
        // Buttons
        applyButton.setTitle("Apply Filter", for: .normal)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.backgroundColor = .systemBlue
        applyButton.layer.cornerRadius = 8
        applyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(.systemBlue, for: .normal)
        resetButton.backgroundColor = .clear
        resetButton.layer.cornerRadius = 8
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = UIColor.systemBlue.cgColor
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        // Add subviews
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(closeButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(priceRangeLabel)
        contentView.addSubview(minPriceTextField)
        contentView.addSubview(maxPriceTextField)
        contentView.addSubview(sortLabel)
        contentView.addSubview(sortSegmentedControl)
        contentView.addSubview(applyButton)
        contentView.addSubview(resetButton)
    }
    
    private func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        priceRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        minPriceTextField.translatesAutoresizingMaskIntoConstraints = false
        maxPriceTextField.translatesAutoresizingMaskIntoConstraints = false
        sortLabel.translatesAutoresizingMaskIntoConstraints = false
        sortSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Header
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            // Title
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            // Close button
            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Price range label
            priceRangeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            priceRangeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            priceRangeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Min price text field
            minPriceTextField.topAnchor.constraint(equalTo: priceRangeLabel.bottomAnchor, constant: 10),
            minPriceTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            minPriceTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            minPriceTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Max price text field
            maxPriceTextField.topAnchor.constraint(equalTo: minPriceTextField.bottomAnchor, constant: 10),
            maxPriceTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            maxPriceTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            maxPriceTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Sort label
            sortLabel.topAnchor.constraint(equalTo: maxPriceTextField.bottomAnchor, constant: 30),
            sortLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sortLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Sort segmented control
            sortSegmentedControl.topAnchor.constraint(equalTo: sortLabel.bottomAnchor, constant: 10),
            sortSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sortSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            sortSegmentedControl.heightAnchor.constraint(equalToConstant: 44),
            
            // Apply button
            applyButton.topAnchor.constraint(equalTo: sortSegmentedControl.bottomAnchor, constant: 30),
            applyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            applyButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Reset button
            resetButton.topAnchor.constraint(equalTo: applyButton.bottomAnchor, constant: 15),
            resetButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resetButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            resetButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        // Add any additional setup actions here
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func applyButtonTapped() {
        // Apply filter logic
        let filter = ProductFilter(
            minPrice: Double(minPriceTextField.text ?? ""),
            maxPrice: Double(maxPriceTextField.text ?? ""),
            sortBy: ProductFilter.SortOption.allCases[sortSegmentedControl.selectedSegmentIndex]
        )
        
        delegate?.didApplyFilter(filter)
        dismiss(animated: true)
    }
    
    @objc private func resetButtonTapped() {
        delegate?.didResetFilters()
        dismiss(animated: true)
    }
} 
