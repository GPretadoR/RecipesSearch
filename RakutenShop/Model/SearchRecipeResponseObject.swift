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

    #warning("I suppose we don't need this enum and init also")
	enum CodingKeys: String, CodingKey {

		case results
		case baseUri
		case offset
		case number
		case totalResults
		case processingTimeMs
		case expires
		case isStale
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		results = try values.decodeIfPresent([RecipeObject].self, forKey: .results)
		baseUri = try values.decodeIfPresent(String.self, forKey: .baseUri)
		offset = try values.decodeIfPresent(Int.self, forKey: .offset)
		number = try values.decodeIfPresent(Int.self, forKey: .number)
		totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
		processingTimeMs = try values.decodeIfPresent(Int.self, forKey: .processingTimeMs)
		expires = try values.decodeIfPresent(Int.self, forKey: .expires)
		isStale = try values.decodeIfPresent(Bool.self, forKey: .isStale)
	}

}
