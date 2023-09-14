//
//  RecipeService.swift
//  FilterCategories
//
//  Created by user on 09.09.2023.
//

import Foundation
enum RecipeError {
    case noData
    case zeroItems
    case decoderError
    
}
class APIRecipeService {
    private  var currentTask: URLSessionTask?
  
    func searchingRecipe(caregoryValues: [CategoryValue], textRequest: String, completion: @escaping ([RecipeProfile]?) -> Void) {
        let url = getUrl(caregoryValues: caregoryValues, textRequest: textRequest)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let urlConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: urlConfiguration)
        
        currentTask = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return }
            
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode != 200 {
                    print("HTTP error: \(httpResponse.statusCode)")
                    return
                }
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let items = try decoder.decode(Result.self, from: data) 
                
                guard items.count != 0 else {return completion(nil) }
                print ("items.count \(items.count)     items.hits.count \( items.hits.count)")
                var result: [RecipeProfile] = []
                for item in items.hits {
                    guard let recipe =  item.recipe else { return }
                    let calories = recipe.calories
                    let title = recipe.label
                    let url = recipe.url
                    let finalRecipeProfile = RecipeProfile(title: title, url: url, calories: Int(calories ?? 0))
                    result.append(finalRecipeProfile)
                }
                completion(result)
            }
            catch {
                print ("JSON parsing error \(error.localizedDescription)")
            }
        }
        currentTask?.resume()
    }
    
    private func getUrl(caregoryValues: [CategoryValue], textRequest: String) -> URL {
        var URLComponents = URLComponents(string: "https://api.edamam.com/api/recipes/v2")!
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "type", value: "any"),
            URLQueryItem(name: "app_id", value: "71021edf"),
            URLQueryItem(name: "app_key", value: "389c0530b12807d2bd5033fb2694567c"),
            URLQueryItem(name: "q", value: textRequest),
        ]
        caregoryValues.forEach { value in
            queryItems.append(URLQueryItem(name: value.category.rawValue, value: value.title))
        }
        URLComponents.queryItems = queryItems
        guard let url = URLComponents.url else { fatalError("Could not create URL from components")} // Обработка сделать
        return url
    }
}
