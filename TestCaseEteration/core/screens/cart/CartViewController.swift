//
//  CartViewController.swift
//  EterationCase
//
//  Created by rabiakama on 28.07.2025.
//

import UIKit

class CartViewController: UIViewController {
    
    // MARK: - UI Components
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var totalView: UIView!
    // MARK: - Properties
    private let viewModel = CartViewModel()
    private let cellIdentifier = "CartItemTableViewCell"
    
    private let emptyStateView = EmptyStateView()
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
        setupEmptyStateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCartItems()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        self.title = "Basket"
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "CartItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    
    private func setupViewModel() {
        viewModel.onCartUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
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
        let isCartEmpty = viewModel.items.isEmpty
        tableView.isHidden = isCartEmpty
        totalView.isHidden = isCartEmpty
        emptyStateView.isHidden = !isCartEmpty
        if !isCartEmpty {
            tableView.reloadData()
            totalLabel.text = viewModel.formattedTotalPrice
        }
        completeButton.isEnabled = !isCartEmpty
        completeButton.alpha = isCartEmpty ? 0.5 : 1.0
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
    
    private func setupEmptyStateView() {
          view.addSubview(emptyStateView)
          emptyStateView.translatesAutoresizingMaskIntoConstraints = false
          emptyStateView.configure(with: "Sepetiniz boş.", icon: UIImage(systemName: "basket.fill"))
          NSLayoutConstraint.activate([
              emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
              emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
              emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
          ])
    }

    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - CartItemCellDelegate
extension CartViewController: CartItemCellDelegate {
    func didTapIncrease(on cell: CartItemTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let item = viewModel.getItem(at: indexPath.row) else { return }
        
        viewModel.increaseQuantity(for: item)
    }
    
    func didTapDecrease(on cell: CartItemTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let item = viewModel.getItem(at: indexPath.row) else { return }
        
        viewModel.decreaseQuantity(for: item)
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeItem(at: indexPath.row)
        }
    }
}
