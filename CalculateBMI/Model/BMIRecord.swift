//
//  BMIRecord.swift
//  CalculateBMI
//
//  Created by W on 12/10/2023.
//

import Foundation
struct BMIrecord: Codable, Identifiable{
    var id = UUID()
    var date: Date
    var bmiValue: Double
    var changePercentage: Double? = nil
}
