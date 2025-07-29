//
//  FavoritesViewController.swift
//  EterationCase
//
//  Created by rabiakama on 27.07.2025.
//

import UIKit

class FavoritesViewController: UIViewController {

    // MARK: - UI Components
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var emptyStateImageView: UIImageView!
    
    // MARK: - Properties
    private var favoriteItems: [FavoriteItem] = []
    private let cellIdentifier = "FavoriteProductCell"
    
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
        setupCollectionView()
        loadFavorites()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }

    // MARK: - Setup Methods
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavoriteProductCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }

    // MARK: - Helper Methods
    private func loadFavorites() {
        favoriteItems = CoreDataManager.shared.fetchFavoriteItems()
        updateUI()
    }

    private func updateUI() {
        collectionView.reloadData()

        if favoriteItems.isEmpty {
            showEmptyState()
        } else {
            hideEmptyState()
        }
    }

    private func showEmptyState() {
        collectionView.isHidden = true
        emptyStateView.isHidden = false
    }

    private func hideEmptyState() {
        collectionView.isHidden = false
        emptyStateView.isHidden = true
    }
}

// MARK: - UICollectionViewDataSource
extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FavoriteProductCell

        let favoriteItem = favoriteItems[indexPath.item]
        cell.configure(with: favoriteItem.product)
        cell.delegate = self

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 15
        let spacing: CGFloat = 10
        let availableWidth = collectionView.bounds.width - (padding * 2) - spacing
        let itemWidth = availableWidth / 2
        return CGSize(width: itemWidth, height: 280)
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let favoriteItem = favoriteItems[indexPath.item]
        let detailVC = ProductDetailViewController(product: favoriteItem.product)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - FavoriteProductCellDelegate
extension FavoritesViewController: FavoriteProductCellDelegate {
    func didTapRemoveFavorite(_ cell: FavoriteProductCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }

        let favoriteItem = favoriteItems[indexPath.item]
        CoreDataManager.shared.removeFromFavorites(productId: favoriteItem.product.id)
        loadFavorites()
    }

    func didTapAddToCart(_ cell: FavoriteProductCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }

        let favoriteItem = favoriteItems[indexPath.item]
        CoreDataManager.shared.addOrUpdateProductInCart(product: favoriteItem.product, quantity: 1)

        let alert = UIAlertController(title: "Success", message: "\(favoriteItem.product.name) added to cart!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
} 
