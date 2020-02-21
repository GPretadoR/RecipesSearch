//  Created on February 12, 2020

import Foundation
struct RecipeObject: Codable {
	let id: Int?
	let title: String?
	let readyInMinutes: Int?
	let servings: Int?
	let image: String?
	let imageUrls: [String]?
    
    static func recipeObject(recipe: Recipe) -> RecipeObject {
        return RecipeObject(id: Int(recipe.id),
                            title: recipe.title,
                            readyInMinutes: Int(recipe.readyInMinutes),
                            servings: Int(recipe.servings),
                            image: recipe.image,
                            imageUrls: recipe.imageUrls)
    }
}
