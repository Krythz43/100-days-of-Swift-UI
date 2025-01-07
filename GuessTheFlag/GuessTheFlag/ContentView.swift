//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nagaraj G on 07/01/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            
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
