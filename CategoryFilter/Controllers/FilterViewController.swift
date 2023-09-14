//
//  ViewController.swift
//  FilterCategories
//
//  Created by user on 21.07.2023.
//

import UIKit
class FilterViewController: UIViewController {

    private  var presenter: FilterPresenter!
    private var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        isHiddenFilter = true
        searchBar.delegate = self

        presenter = FilterPresenter()
        presenter.set(mainController: self, chlidController: collectionViewController)
        collectionViewController.setPresenter(presenter)
        
        setupSearchBar()
        setupCategoryTypeBoard()
        setupCategoryValueCollection()
        for button in [dietsButton, allergiesButton] {
            button.addTarget(self, action: #selector(tapOnCategoryType), for: .touchUpInside)
        }
        launchButton.addTarget(self, action: #selector(launchSearching), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearAllSelectedValues), for: .touchUpInside)
    }
    
    private var dietConstraint: NSLayoutConstraint?
    private var allergyConstraint: NSLayoutConstraint?
    
    private func updateInterface(categoryType: CategoryType) {
        
        if dietConstraint == nil, allergyConstraint == nil {
            dietConstraint = backgroundViewForCollection.heightAnchor.constraint(equalToConstant: 210)
            allergyConstraint = backgroundViewForCollection.heightAnchor.constraint(equalToConstant: 170)
        }
        guard let dietSize = dietConstraint, let allergiesSize = allergyConstraint else { return }
        
        UIView.animate(withDuration: 0.7) {
            switch categoryType {
            case .health:
                dietSize.isActive = false
                allergiesSize.isActive = true
                self.dietsButton.setTitleColor(UIColor.notSelected, for: .normal)
                self.allergiesButton.setTitleColor(UIColor.selected, for: .normal)
            case .diet:
                allergiesSize.isActive = false
                dietSize.isActive = true
                self.allergiesButton.setTitleColor(UIColor.notSelected, for: .normal)
                self.dietsButton.setTitleColor(UIColor.selected, for: .normal)
            }
            self.lineView.lineStartPosition = categoryType
        }
        backgroundViewForCollection.layoutIfNeeded()
        backgroundViewForCollection.setNeedsDisplay()
    }
    //MARK: - Outlets
    private let collectionViewController = CategoryCollectionVC()
    private let backgroundViewForCollection = BackgroundView()
    private let lineView =  LineView()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsBookmarkButton = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.tintColor = UIColor.basic
        searchBar.barTintColor = .white
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()

    private let dietsButton: UIButton =  {
        let button = UIButton()
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Diet", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(UIColor.notSelected, for: .normal)
        return button
    }()
    private let allergiesButton: UIButton =  {
        let button = UIButton()
        button.tag = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Allergies", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(UIColor.notSelected, for: .normal)
        return button
    }()
    
    private let launchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Launch", for: .normal)
        button.backgroundColor = .selected
        button.layer.cornerRadius = 10
        return button
    }()
    private let clearButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Clear", for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        return button
    }()
    private var isHiddenFilter: Bool  = true {
        willSet { UIView.animate(withDuration: 0.7) { [weak self] in
            guard let self = self else { return }
            collectionViewController.view.isHidden = newValue
            for view in [lineView, dietsButton, allergiesButton, backgroundViewForCollection, launchButton, clearButton] {
                view.isHidden = newValue
                }
            }
        }
    }
    //MARK: - Layout
    private func setupSearchBar() {
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
        ])
    }
    
    private func setupCategoryTypeBoard() {
        view.addSubview(backgroundViewForCollection)
        for subview in [dietsButton, allergiesButton, lineView] { backgroundViewForCollection.addSubview(subview) }
        NSLayoutConstraint.activate([
            backgroundViewForCollection.topAnchor.constraint(equalTo: searchBar.searchTextField.bottomAnchor),
            backgroundViewForCollection.leftAnchor.constraint(equalTo: searchBar.leftAnchor, constant: 16),
            backgroundViewForCollection.rightAnchor.constraint(equalTo: searchBar.rightAnchor,constant:  -16),
            
            dietsButton.topAnchor.constraint(equalTo: backgroundViewForCollection.topAnchor, constant: 5),
            dietsButton.leftAnchor.constraint(equalTo: backgroundViewForCollection.leftAnchor, constant: 50),
            dietsButton.heightAnchor.constraint(equalToConstant: 35),
            
            allergiesButton.topAnchor.constraint(equalTo: backgroundViewForCollection.topAnchor, constant: 5),
            allergiesButton.rightAnchor.constraint(equalTo: backgroundViewForCollection.rightAnchor, constant: -50),
            allergiesButton.heightAnchor.constraint(equalToConstant: 35),
            
            lineView.topAnchor.constraint(equalTo: dietsButton.bottomAnchor, constant: 2),
            lineView.leftAnchor.constraint(equalTo: backgroundViewForCollection.leftAnchor),
            lineView.rightAnchor.constraint(equalTo: backgroundViewForCollection.rightAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
    
    private func setupCategoryValueCollection(){
        addChild(collectionViewController)
        backgroundViewForCollection.addSubview(collectionViewController.view)
        for subview in [clearButton, launchButton] { view.addSubview(subview) }
        NSLayoutConstraint.activate([
            collectionViewController.view.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 3),
            collectionViewController.view.leftAnchor.constraint(equalTo: backgroundViewForCollection.leftAnchor, constant: 5),
            collectionViewController.view.rightAnchor.constraint(equalTo: backgroundViewForCollection.rightAnchor, constant: -5),
            collectionViewController.view.bottomAnchor.constraint(equalTo: backgroundViewForCollection.bottomAnchor),
            
            launchButton.topAnchor.constraint(equalTo: backgroundViewForCollection.bottomAnchor, constant: 5),
            launchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            clearButton.topAnchor.constraint(equalTo: launchButton.bottomAnchor, constant: 5),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        collectionViewController.didMove(toParent: self)
    }
    //MARK: - Actions
    @objc func tapOnCategoryType(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case  "Diet":
            presenter.catagoryTypeSelected(.diet)
        case "Allergies":
            presenter.catagoryTypeSelected(.health)
        default: break
        }
    }
    
    @objc func launchSearching(_ sender: UIButton)  {
        presenter.printResult(text: searchText)
    }
    
    @objc func clearAllSelectedValues(_ sender: UIButton) {
        presenter.clear()
    }
}

//MARK: - UISearchBarDelegate
extension FilterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            self.searchText = searchText
        }
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        switch isHiddenFilter {
        case false:
            searchBar.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .bookmark, state: .normal)
            isHiddenFilter = true
        case true:
            searchBar.setImage(UIImage(systemName: "xmark"), for: .bookmark, state: .normal)
            isHiddenFilter = false
            presenter.catagoryTypeSelected(nil)
        }
    }
}

extension FilterViewController: FilterViewDelegate {
    func updateCategoryView(categoryType: CategoryType) {
        updateInterface(categoryType: categoryType)
    }
}
