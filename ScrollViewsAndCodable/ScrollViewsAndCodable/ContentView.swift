//
//  ContentView.swift
//  ScrollViewsAndCodable
//
//  Created by Nagaraj G on 14/01/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            
        }
    }
}

struct Address: Codable {
    var street: String
    var city: String
}

struct Queen: Codable {
    var name: String
    var address: Address
}

struct GridAndJSONDecoding: View {
    @State var queeName: String = "to find"
    
    let layout = [
        GridItem(.adaptive(minimum: 80, maximum: 120))
    ]
    var body: some View {
        Button("Decode JSON") {
            let input = """
            {
                "name": "Taylor Swift",
                "address": {
                    "street": "555, Taylor Swift Avenue",
                    "city": "Nashville"
                }
            }
            """

            let data = Data(input.utf8)
            if let user = try? JSONDecoder().decode(Queen.self, from: data) {
                print(user.address.city)
                queeName = user.name
            }
        }
        Text("Queen name is: \(queeName)")
        
        ScrollView(.horizontal) {
            LazyHGrid(rows: layout) {
                ForEach(1..<100) { number in
                    Text("Somethign \(number)")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct NavigationLinkPractice: View {
    var body: some View {
        NavigationStack {
            NavigationLink {
                Text("Hey there!")
            } label: {
                VStack {
                    Text("This is the label")
                    Text("So is this")
                    Image(systemName: "face.smiling")
                }
            }
            
            List(0..<100) { row in
                    NavigationLink("Row \(row)") {
                        Text("Detail \(row)")
                    }
                }
            
            .navigationTitle("Something new")
        }
    }
}

struct LazyStackPracitve: View {
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack {
                Image("cover")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                
                Image("cover")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300)
                
                Image("cover")
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { size, axis in
                        size * 0.8
                    }
                LazyHStack(spacing: 10) {
                    ForEach(0..<100) {
                        CustomText("Item \($0)")
                            .font(.title)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct CustomText: View {
    let text: String

    var body: some View {
        Text(text)
    }

    init(_ text: String) {
        print("Creating a new CustomText")
        self.text = text
    }
}
