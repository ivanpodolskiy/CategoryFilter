//
//  CategoryCollectionVC.swift
//  FilterCategories
//
//  Created by user on 10.09.2023.
//

import UIKit

class CategoryCollectionVC: UIViewController {
    private var categoryValues: [CategoryValue]?
    weak private var presenter: FilterPresenter!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.register(CategoryCollectionCell.self, forCellWithReuseIdentifier: CategoryCollectionCell.indentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setPresenter(_ presenter: FilterPresenter) {
        self.presenter = presenter
    }
    
    private let collectionView: UICollectionView = {
        let layoutCollectionView = UICollectionViewFlowLayout()
        layoutCollectionView.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutCollectionView)
        collectionView.backgroundColor = UIColor.basic
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
}

extension CategoryCollectionVC: CategoryCollectionDelegate {
    func updateCollectionView(categoryValues: [CategoryValue]) {
        self.categoryValues = categoryValues
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
extension CategoryCollectionVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = categoryValues?.count else { return 0}
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.indentifier, for: indexPath) as! CategoryCollectionCell
        cell.configure(value: categoryValues![indexPath.row], index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let values = categoryValues else { return }
        presenter.selectCategoryValue(value: values[indexPath.row])
    }
}

extension CategoryCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let minimumSpacing: CGFloat = 5.0 
        let maximumSpacing: CGFloat = 8.0
        
        let totalSpacing = minimumSpacing + maximumSpacing // Total spacing
        let availableWidth = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        let spacing = min(maximumSpacing, (availableWidth - totalSpacing) / CGFloat(3 - 1))
        return UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: spacing / 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = categoryValues![indexPath.row].title
        if let font = UIFont(name: "Helvetica", size: 18) {
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = (text as NSString).size(withAttributes: fontAttributes)
            let heigh = CGFloat(30)
            let width = size.width
            return CGSize(width: CGFloat(width), height: heigh)
        }
        return CGSize(width: 0, height: 0)
    }
}
