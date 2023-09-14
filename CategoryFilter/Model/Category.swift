//
//  Category.swift
//  FilterCategories
//
//  Created by user on 13.08.2023.
//
enum CategoryType: String {
    case diet
    case health
}

struct CategoryValue {
    var title: String
    var category: CategoryType
    
    private(set) var status: Bool = false
    
    mutating func claer() {
        self.status = false
    }
    
    mutating func select() {
        status = !status
    }
}
