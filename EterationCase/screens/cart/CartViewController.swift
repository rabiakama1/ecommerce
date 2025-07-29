//
//  CartViewController.swift
//  EterationCase
//
//  Created by rabiakama on 28.07.2025.
//

import UIKit

class CartViewController: UIViewController {
    
    // MARK: - UI Components
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var emptyStateImageView: UIImageView!
    
    // MARK: - Properties
    private let viewModel = CartViewModel()
    private let cellIdentifier = "CartItemTableViewCell"
    
    // MARK: - Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupViewModel()
        loadCartItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCartItems()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    

    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartItemTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setupViewModel() {
        viewModel.onCartUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        viewModel.onCartEmpty = { [weak self] in
            DispatchQueue.main.async {
                self?.showEmptyState()
            }
        }
    }
    
    // MARK: - Actions
    @objc private func completeButtonTapped() {
        let alert = UIAlertController(title: "Complete Order", message: "Are you sure you want to complete this order?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Complete", style: .default) { [weak self] _ in
            self?.viewModel.completeOrder()
            self?.showAlert(title: "Success", message: "Order completed successfully!")
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - Helper Methods
    private func loadCartItems() {
        viewModel.loadCartItems()
    }
    
    private func updateUI() {
        tableView.reloadData()
        totalPriceLabel.text = viewModel.formattedTotalPrice
        completeButton.isEnabled = !viewModel.items.isEmpty
        completeButton.alpha = viewModel.items.isEmpty ? 0.5 : 1.0
    }
    
    private func showEmptyState() {
        tableView.isHidden = true
        totalView.isHidden = true
        emptyStateView.isHidden = false
    }
    
    private func hideEmptyState() {
        tableView.isHidden = false
        totalView.isHidden = false
        emptyStateView.isHidden = true
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CartItemTableViewCell
        
        if let item = viewModel.getItem(at: indexPath.row) {
            cell.configure(with: item)
            cell.delegate = self
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeItem(at: indexPath.row)
        }
    }
}

// MARK: - CartItemCellDelegate
extension CartViewController: CartItemCellDelegate {
    func didTapIncrease(on cell: CartItemTableViewCell) {
        
    }
    
    func didTapDecrease(on cell: CartItemTableViewCell) {
        
    }
}
