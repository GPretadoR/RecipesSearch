import Foundation
struct Steps: Codable {
	let number: Int?
	let step: String?
	let ingredients: [Entity]?
	let equipment: [Entity]?
}
