import Foundation
struct SearchRecipeResponseObject: Codable {
	let results: [RecipeObject]?
	let baseUri: String?
	let offset: Int?
	let number: Int?
	let totalResults: Int?
	let processingTimeMs: Int?
	let expires: Int?
	let isStale: Bool?
}
