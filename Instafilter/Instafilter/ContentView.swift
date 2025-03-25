//
//  ContentView.swift
//  Instafilter
//
//  Created by Nagaraj G on 25/03/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var blurAmount = 0.0
    @State private var showingConfirmation = false
    @State private var backgroundColor = Color.white
    @State private var firstImage: Image?
    @State private var image: Image?

    var body: some View {
        VStack {
            Text("Hello, World!")
                .blur(radius: blurAmount)

            Slider(value: $blurAmount, in: 0...20)
                .onChange(of: blurAmount) { oldValue, newValue in
                    print("New value is \(newValue)")
                }
            
            Button("Random Blur") {
                blurAmount = Double.random(in: 0...20)
            }
            
            Button("Hello, World!") {
                showingConfirmation = true
            }
            .frame(width: 300, height: 300)
            .background(backgroundColor)
            .confirmationDialog("Change background", isPresented: $showingConfirmation) {
                Button("Red") { backgroundColor = .red }
                Button("Green") { backgroundColor = .green }
                Button("Blue") { backgroundColor = .blue }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Select a new color")
            }
            
            VStack {
                firstImage?
                    .resizable()
                    .scaledToFit()
                
                image?
                    .resizable()
                    .scaledToFit()
            }
            .onAppear(perform: loadImage)
        }
    }
    func loadImage() {
        firstImage = Image("example")
        let inputImage = UIImage(resource: .example)
        let secondImage = CIImage(image: inputImage)
        
        // sepia filter
        
        let currentFilter = CIFilter.twirlDistortion()
        currentFilter.inputImage = secondImage

        let amount = 1.0

        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey) }
        
        
        let context = CIContext()
//        let currentFilter = CIFilter.twirlDistortion()
//        
//        currentFilter.inputImage = secondImage
//        currentFilter.radius = 200
//        currentFilter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
        
//        let currentFilter = CIFilter.pixellate()
//        
//        currentFilter.inputImage = secondImage
//        currentFilter.scale = 100
        
        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }

        // attempt to get a CGImage from our CIImage
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

        // convert that to a UIImage
        let uiImage = UIImage(cgImage: cgImage)

        // and convert that to a SwiftUI image
        image = Image(uiImage: uiImage)
    }
    
}
