//
//  CategoryService.swift
//  FilterCategories
//
//  Created by user on 13.08.2023.
//

class CategoryService {
    private var type: CategoryType = .diet
    
    private var dietValues: [CategoryValue] = [CategoryValue(title: "balanced", category: .diet), CategoryValue(title: "high-fiber",  category: .diet), CategoryValue(title: "keto-friendly", category: .health), CategoryValue(title: "kosher", category: .health), CategoryValue(title: "low-fat", category: .diet), CategoryValue(title: "high-protein", category: .diet), CategoryValue(title: "low-carb", category: .diet), CategoryValue(title: "low-sodium", category: .diet), CategoryValue(title: "low-sugar", category: .health), CategoryValue(title: "pescatarian", category: .health), CategoryValue(title: "red-meat-free", category: .health), CategoryValue(title: "vegan", category: .health), CategoryValue(title: "vegetarian", category: .health) ]
    
    private var allergyValues: [CategoryValue] = [CategoryValue(title: "alcohol-free",  category: .health), CategoryValue(title: "celery-free", category: .health), CategoryValue(title: "crustacean-free", category: .health), CategoryValue(title: "dairy-free", category: .health),  CategoryValue(title: "egg-free",  category: .health), CategoryValue(title: "fish-free", category: .health), CategoryValue(title: "soy-free", category: .health), CategoryValue(title: "shellfish-free", category: .health), CategoryValue(title: "peanut-free", category: .health), CategoryValue(title: "mustard-free", category: .health)]
    
    func getCategoryData(categoryType: CategoryType?, callBack:  ([CategoryValue]?, _ type: CategoryType) -> Void) {
        switch categoryType {
        case .diet:
            self.type = .diet
            callBack(dietValues, type)
        case .health :
            self.type = .health
            callBack(allergyValues, type)
        case nil:
            if type == .diet {
                callBack(dietValues, type)
            } else {
                callBack(allergyValues, type)
            }
        }
    }
    
    func getActiveValues() -> [CategoryValue] {
        var filteredValues = [CategoryValue]()
        let sumValues = dietValues + allergyValues
        for value in sumValues { if value.status == true { filteredValues.append(value)} }
        return filteredValues
    }
    
    func changeStatus(_ selectedValue: CategoryValue) -> [CategoryValue] {
        var updatedValues = [CategoryValue]()
        updatedValues = type == .diet ? dietValues : allergyValues
        for i in 0..<updatedValues.count {
            if updatedValues[i].title == selectedValue.title { updatedValues[i].select() }
        }
        switch type {
        case .diet: dietValues = updatedValues
        case .health: allergyValues = updatedValues
        }
        return  updatedValues
    }
    
    func clear() {
        func setStatusFalse(type: inout [CategoryValue]) {
            for i in 0..<type.count { type[i].claer() }
        }
        setStatusFalse(type: &dietValues)
        setStatusFalse(type: &allergyValues)
    }
}
