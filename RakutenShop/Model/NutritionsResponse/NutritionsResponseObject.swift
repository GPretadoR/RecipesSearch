//
//  NutritionsResponseObject.swift
//  Created on February 12, 2020

import Foundation

struct NutritionsResponseObject: Codable {

        let calories: String?
        let carbs: String?
        let fat: String?
        let protein: String?
        let bad: [Bad]?
        let good: [Good]?
       
}
