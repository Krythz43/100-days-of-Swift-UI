//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nagaraj G on 07/01/25.
//

import SwiftUI

struct ContentView: View {
    var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            VStack (spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .font(.subheadline.weight(.heavy))
                    Text(countries[correctAnswer])
                        .font(.largeTitle.weight(.semibold))
                }
                
                ForEach(0..<3) { number in
                    Button {
                        // flag tapped
                    } label: {
                        Image(countries[number])
                            .clipShape(.capsule)
                            .shadow(radius: 5)
                    }
                }
                .padding(2)
                .background(.white)
                .clipShape(.capsule)
                .shadow(radius: 5)
            }
            LinearGradient(colors: [.blue,.black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .zIndex(-1)
        }
    }
    
}

struct ButtonTesting: View {
    var val = 0.85
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Hey!")
                VStack {
                    Button("Show Alert") {
                        showingAlert =  true
                    }
                    .buttonStyle(.bordered)
                    .alert("Something imp", isPresented: $showingAlert, actions: {
                        Button("OK") {
                            
                        }
                        Button("delete", role: .destructive) {}
                        Button("cancel", role: .cancel) {}
                    }, message: {
                        Text("This converys some extra information to the user")
                    })
                    
                    Button("Button 2", role: .destructive) { }
                        .buttonStyle(.bordered)
                    Button("Button 3") { }
                        .buttonStyle(.borderedProminent)
                        .tint(.mint)
                    Button("Button 4", role: .destructive) { }
                        .buttonStyle(.borderedProminent)
                    
                    Button {
                        print("Button with trailing closure tapped")
                    } label: {
                        Label("Edit Lsbrl", systemImage: "pencil")
                            .padding()
                            .foregroundStyle(.white)
                            .background(.red)
                    }
                }
            }
            .padding(50)
            .foregroundStyle(.white)
            .background(.blue.gradient)
            
            VStack {
                LinearGradient(colors: [Color(red: 1, green: val, blue: val),.orange,.red,.pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                AngularGradient(colors: [.red,.yellow,.green,.blue,.purple], center: .bottom)
            }
            .zIndex(-1)
        }
    }
}

func executeDelete() {
    print("clicked")
}

struct pokeBallView: View {
    var body: some View {
        ZStack {
            VStack {
                Color.red
                Color.blue
            }
            
            Text("Your content")
                .foregroundStyle(.secondary)
                .padding(50)
                .background(.ultraThinMaterial)
        }
    }
}

struct opacityTesterView: View {
    let values = [0.1,0.25,0.5,0.75,1]
    @State var opacityBg = 0.1
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .trailing) {
                Spacer()
                Text("Hello world!")
                Text("This is inside a stack")
                Text("Somethign")
                Spacer()
                Spacer()
            }
            .background(.red)
            
            VStack {
                VStack(alignment: .trailing) {
                    Spacer()
                    Spacer()
                    Text("Hello world!")
                    Text("This is inside a stack")
                    Text("Somethign")
                    Spacer()
                }
                .background(.blue)
                
                VStack(alignment: .trailing) {
                    Spacer()
                    Spacer()
                    Text("Hello world!")
                    Text("This is inside a stack")
                    Text("Somethign")
                    Spacer()
                }
                .background(.blue)
                .opacity(opacityBg)
                
                Picker("Opacity picker", selection: $opacityBg) {
                    ForEach(values, id: \.self) {
                        Text($0, format: .percent)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }
}
