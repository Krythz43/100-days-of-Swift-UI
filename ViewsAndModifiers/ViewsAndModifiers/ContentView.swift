//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Nagaraj G on 13/01/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack (spacing: 0) {
            List {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                }
                .swipeActions(allowsFullSwipe: false) {
                    Button("type print") {
                        print(type(of: self.body))
                    }
                    
                    // Applies a modifier ModifiedContent <OurThing, OurModifier>
                    // To know the type start from the innermost and work your way out
                    
                }
                .padding()
                .background(.red)
                .padding()
                .background(.blue)
                .padding()
                .background(.yellow)
                .padding()
                .background(.green)
                
            }
            .tint(.blue)
            .background(.red)
            
            List {
                ForEach(1..<5) { _ in
                    Text("Swipe to find out")
                        .swipeActions (allowsFullSwipe: false) {
                            Button("Default", action: {})
                            Button("Cancel", role: .cancel, action: {})
                            Button("Delete", role: .destructive, action: {})
                        }
                }
            }
        }
    }
}
