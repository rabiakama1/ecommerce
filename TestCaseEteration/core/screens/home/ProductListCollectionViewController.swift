//
//  ProductListCollectionViewController.swift
//  EterationCase
//
//  Created by rabiakama on 28.07.2025.
//

import UIKit

class ProductListCollectionViewController: UIViewController {
    
    
    // MARK: - UI Components
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Properties
    private let viewModel = ProductListViewModel()
    private let cellIdentifier = "ProductCollectionViewCell"
    
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
        setupCollectionView()
        setupViewModel()
        loadProducts()
    }

    private func setupUI() {
        self.title = "Products"
        searchBar.delegate = self
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        filterButton.setTitle("Select Filter", for: .normal)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func setupViewModel() {
        viewModel.onProductsLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
        
        viewModel.onProductsFailed = { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(title: "Error", message: error)
                self?.refreshControl.endRefreshing()
            }
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.onSearchResultsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    @IBAction func filterButtonTapped(_ sender: Any) {
        let filterVC = FilterViewController()
        filterVC.delegate = self
        let navController = UINavigationController(rootViewController: filterVC)
        present(navController, animated: true)
    }

    @objc private func refreshData() {
        viewModel.refreshProducts()
    }
    
    // MARK: - Helper Methods
    private func loadProducts() {
        viewModel.loadProducts()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension ProductListCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProductCollectionViewCell
        cell.delegate = self
        if let product = viewModel.getProduct(at: indexPath.item) {
            cell.configure(with: product, isFavorited: viewModel.isProductFavorited(product))
            cell.delegate = self
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductListCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 15
        let spacing: CGFloat = 10
        let availableWidth = collectionView.bounds.width - (padding * 2) - spacing
        let itemWidth = availableWidth / 2
        return CGSize(width: itemWidth, height: 280)
    }
}

// MARK: - UICollectionViewDelegate
extension ProductListCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = viewModel.getProduct(at: indexPath.item) {
            let detailVC = ProductDetailViewController(product: product)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height * 1.5 {
            viewModel.loadMoreProducts()
        }
    }
}

// MARK: - UISearchBarDelegate
extension ProductListCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchProducts(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.clearSearch()
        searchBar.resignFirstResponder()
    }
}

// MARK: - ProductCellDelegate
extension ProductListCollectionViewController: ProductCellDelegate {
    func didTapFavorite(_ product: Product,cell: ProductCollectionViewCell) {
        viewModel.toggleFavorite(for: product)
        cell.updateFavoriteButton(isFavorited: viewModel.isProductFavorited(product))
    }
    
    func didTapAddToCart(_ product: Product) {
        viewModel.addToCart(product: product)
        showAlert(title: "Success", message: "\(product.name) added to cart!")
    }
}

// MARK: - FilterViewControllerDelegate
extension ProductListCollectionViewController: FilterViewControllerDelegate {
    func didApplyFilter(_ filter: ProductFilter) {
        // Filter implementation will be added later
        print("Filter applied: \(filter)")
    }
}
