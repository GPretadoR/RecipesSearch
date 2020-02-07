import Foundation
struct RecipeObject: Codable {
	let id: Int?
	let title: String?
	let readyInMinutes: Int?
	let servings: Int?
	let image: String?
	let imageUrls: [String]?

	enum CodingKeys: String, CodingKey {

		case id
		case title
		case readyInMinutes
		case servings
		case image
		case imageUrls
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		readyInMinutes = try values.decodeIfPresent(Int.self, forKey: .readyInMinutes)
		servings = try values.decodeIfPresent(Int.self, forKey: .servings)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		imageUrls = try values.decodeIfPresent([String].self, forKey: .imageUrls)
	}

}
