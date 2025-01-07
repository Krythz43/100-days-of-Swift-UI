//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nagaraj G on 07/01/25.
//

import SwiftUI

struct ContentView: View {
    var val = 0.85
    var body: some View {
        ZStack {
            VStack {
                Text("Hey!")
                Button("Delete Selection", action: executeDelete)
            }
            .padding(50)
            .foregroundStyle(.white)
            .background(.red.gradient)
            
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
