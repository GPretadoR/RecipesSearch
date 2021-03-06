//  Created on February 12, 2020

import Foundation
struct RecipeObject: Codable {
	let id: Int?
	let title: String?
	let readyInMinutes: Int?
	let servings: Int?
	let image: String?
	let imageUrls: [String]?
}
