//
//  CategoryPresenter.swift
//  FilterCategories
//
//  Created by user on 13.08.2023.
//

import ObjectiveC

protocol FilterViewDelegate: NSObjectProtocol {
    func updateCategoryView(categoryType: CategoryType)
}

protocol CategoryCollectionDelegate: AnyObject {
    func updateCollectionView(categoryValues: [CategoryValue])
}

class FilterPresenter {
    private let categoryService: CategoryService
    weak private var filterControllerDelegate:  FilterViewDelegate?
    weak private var collectionDelegate: CategoryCollectionDelegate?
    
    init() { self.categoryService = CategoryService() }
    
    func set(mainController: FilterViewDelegate, chlidController: CategoryCollectionDelegate) {
        self.filterControllerDelegate = mainController
        self.collectionDelegate = chlidController
    }
    
    func catagoryTypeSelected(_ type: CategoryType?) {
        categoryService.getCategoryData(categoryType: type) { [weak self] values, type  in
            guard let self = self, let values = values else { return }
            self.filterControllerDelegate?.updateCategoryView(categoryType: type)
            self.collectionDelegate?.updateCollectionView(categoryValues: values)
        }
    }
    func selectCategoryValue(value: CategoryValue) {
        let refreshData =  categoryService.changeStatus(value)
        collectionDelegate?.updateCollectionView(categoryValues: refreshData)
    }
    
    func clear() {
        categoryService.clear()
        catagoryTypeSelected(nil)
    }
    
    func printResult(text: String) {
        let values  = categoryService.getActiveValues()
        let recipeService = APIRecipeService()
        recipeService.searchingRecipe(caregoryValues: values, textRequest: text){ recipeArry in
            guard let recipeArry = recipeArry else {
                print("No recipes were found matching your request.")
                return  }
            print (".............\nRECIPES RESULT\nRequestText: \(text)")
            print("filter: \(values)")
            var i = 1
            for recipe in recipeArry {
                print("\(i).\(recipe.title)\ncalories:\(recipe.calories)\nlink:\(recipe.url)\n")
                i += 1
            }
        }
    }
    
}

