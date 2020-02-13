
import Foundation
struct Steps: Codable {
	let number: Int?
	let step: String?
	let ingredients: [Entity]?
	let equipment: [Entity]?

	enum CodingKeys: String, CodingKey {

		case number = "number"
		case step = "step"
		case ingredients = "ingredients"
		case equipment = "equipment"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		number = try values.decodeIfPresent(Int.self, forKey: .number)
		step = try values.decodeIfPresent(String.self, forKey: .step)
		ingredients = try values.decodeIfPresent([Entity].self, forKey: .ingredients)
		equipment = try values.decodeIfPresent([Entity].self, forKey: .equipment)
	}

}
