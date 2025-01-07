//
//  ContentView.swift
//  WeSplit
//
//  Created by Nagaraj G on 07/01/25.
//

import SwiftUI

struct ContentView: View {
    @State var tapCount = 0
    
    let students = ["Harry", "Hermoine", "Ron"]
    @State private var selectedStudent = "Harry"
    
    @FocusState private var amountIsFocused: Bool
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount

        return amountPerPerson
    }
    
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0 // picker starts from 2
    @State private var tipPercentage = 20
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Select your student", selection: $selectedStudent) {
                    ForEach(students,id: \.self) {
                        Text($0)
                    }
                }
                
                oneRandomView()
                
                Section {
                    Section {
                        Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    }
                    
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                    
                } header: {
                    Text("Yea the actual bill splitting app starts here")
                }
                
                Section("How much tip would youw ant to leave?") {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.inline)

            if amountIsFocused {
                Button("Done") {
                    amountIsFocused = false
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 12, trailing: 0))
            }
        }
    }
}

struct oneRandomView: View {
    @State var name = ""
    @State var tapCount = 0
    var body: some View {
        Section {
            Text("Hello World!")
            Text("Hello World!")
            Text("Hello World!")
            Text("Hello World!")
            
            TextField("Enter your name", text: $name)
            Text("Hello world \(name)")
        } header: {
            Text("Random af view")
        } footer: {
            HStack {
                Text("One random af text")
                Spacer()
                Text("Another random af text")
            }
        }
        
        Section {
            ForEach(0..<10) {
                Text("Hello World! \($0)")
            }
        }
        
        Button("Tap Count \(tapCount)") {
            tapCount += 1
        }
    }
}
