//
//  ContentView.swift
//  CalculateBMI
//
//  Created by W on 09/10/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = BMIViewModel() // creates an instance(Object) of type BMIviewmodel
    
    
    //create an alert pop-up when non numeric data has been entered telling the user
    @State var showAlert: Bool = false
    
    @StateObject private var ViewModel = BMIViewModel()
    @FocusState private var fieldIsFocused: Bool

    
    var body: some View {
        ZStack{
            VStack {
                Text("BMI Calculator Version 1.0")
                //styling the title
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .padding(.all)
                
                //creating text fields
                HStack{
                    Text(" Height in (m) ")
                    Rectangle()
                        .frame(width: 1, height: 60)
                    TextField("Enter Height (m): ", text: $viewModel.height)
                        .focused($fieldIsFocused)
                        .keyboardType(.decimalPad)
                        .padding()
                    
                }
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
                
                
                HStack{
                    Text(" Weight in (kg)")
                    Rectangle()
                        .frame(width: 1, height: 60)
                    TextField("Enter weight (kg): ", text: $viewModel.weight)
                        .focused($fieldIsFocused)
                        .keyboardType(.decimalPad)
                        .padding()
                    
                }
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
                
                //data picker component
                DatePicker("Select Date", selection: $viewModel.selectedDate,in: ...Date(),displayedComponents: .date)
                
                
                Button(action:{
                    viewModel.calculateBMI()
                    fieldIsFocused = false
                }){
                    Text("Calculate BMI")
                        .padding()
                        .foregroundColor((viewModel.height.isEmpty || viewModel.weight.isEmpty) ? .gray : .blue)
                        .cornerRadius(10)
                }
                .disabled(viewModel.height.isEmpty || viewModel.weight.isEmpty)
                
                
                Text("BMI Records")
                    .font(.headline)
                
                
                
                if let lastRecord = viewModel.bmiRecords.last{
                
                    HStack(spacing: 10){
                        Text("BMI: \(String(format: "%.2f", lastRecord.bmiValue))")
                            .font(.headline)
                            .padding()
                        
                        
                        Text("Date: \(lastRecord.date )")
                            .font(.subheadline)
                            .padding()
                        
                        if let changePercentage = lastRecord.changePercentage{
                            Text("Change: \(String(format: "%.2f", changePercentage))%")
                                .foregroundStyle(changePercentage >= 0 ? .white : .black)
                                .font(.subheadline)
                                .padding()
                        }
                    }
                }
                
                ScrollView{
                    List(viewModel.bmiRecords){ record in
                        
                        HStack(spacing: 10){
                            Text("\(record.date)")
                            
                            Text("BMI \(String(format: "%.2f", record.bmiValue))")
                            
                            if let changePercentage = record.changePercentage {
                                Text("Change: \(String(format: "%.2f", changePercentage))%")
                                    .foregroundColor(changePercentage >= 0 ? .red : .green)
                            }else { Text(" N/A ")}
                        }
                        Text(viewModel.classifyBMI(record.bmiValue))
                            .font(.subheadline)
                            .foregroundColor(Color.blue)
                    }
                    .frame(height: 400)
                    .scrollContentBackground(.hidden)
                }
                
            }
            .padding()
            
        }
        .background(Color.mint)
        
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Invalid Data"), message: Text("Non-numberic data"), dismissButton: .default(
                Text("try Again")))
        }
    }
    
}

#Preview {
    ContentView()
}
