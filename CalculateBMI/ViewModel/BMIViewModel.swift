//
//  BMIViewModel.swift
//  CalculateBMI
//
//  Created by W on 12/10/2023.
//

import Foundation
class BMIViewModel: ObservableObject{
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var selectedDate: Date = Date()
    @Published var bmiRecords: [BMIrecord] = []
    private let userDefaults = UserDefaults.standard
        private let bmiRecordsKey = "BMIRecordsKey"
    
    init(){
        loadStoredBMIRecords()
    }
    
    func updateStoreBMIRecords(){
        print("bmiRecords .. before encoding .. \(bmiRecords)")
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(bmiRecords) {
            //Convert the encoded data to JSON string for debugging
            if let jsonString = String(data: encoded, encoding: .utf8){
                print("JSON String representation of encoded data: \(jsonString)")
            }
            userDefaults.set(encoded, forKey: bmiRecordsKey)
        
        }
    }
    
    func loadStoredBMIRecords(){
        if let data = userDefaults.data(forKey: bmiRecordsKey){
            print("bmiRecords..before decoding...\(data)")
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([BMIrecord].self, from: data){
                bmiRecords = decoded.sorted(by: {$0.date < $1.date})
                print("decoded data ... \(decoded)")
            }
        }
    }
    
    func calculateBMI(){
        if let heightValue = Double(height), let weighValue = Double(weight), heightValue > 0, weighValue > 0 {
            let bmi = weighValue / (heightValue * heightValue)
            
            let record = BMIrecord(date: selectedDate, bmiValue: bmi)
            
            bmiRecords.append(record)
            bmiRecords.sort(by: {$0.date < $1.date})
            
            for index in 1..<bmiRecords.count{
                let previousRecord = bmiRecords[index - 1]
                let changePercentage = ((bmiRecords[index].bmiValue - previousRecord.bmiValue) / previousRecord.bmiValue * 100)
                bmiRecords[index].changePercentage = changePercentage
            }
            updateStoreBMIRecords()
        }
        
        //reset fields
        height = ""
        weight = ""
    }
    
    
    func classifyBMI(_ bmi: Double) ->String{
        if bmi < 18.5 {
            return "Underweight"
        }else if bmi < 24.9 {
            return "Normal weight"
        } else if bmi < 29.9 {
            return "Overweight"
        } else{
            return "Obese"
        }
    }
}
