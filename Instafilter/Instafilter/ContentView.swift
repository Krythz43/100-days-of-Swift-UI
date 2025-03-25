//
//  ContentView.swift
//  Instafilter
//
//  Created by Nagaraj G on 25/03/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

import PhotosUI
import SwiftUI
import StoreKit

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingFilters = false
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Import a photo to get started"))
                    }
                }
                .onChange(of: selectedItem, loadImage)

                Spacer()

                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity, applyProcessing)
                }
                .padding(.vertical)

                HStack {
                    Button("Change Filter") {
                        showingFilters = true
                    }

                    Spacer()

                    // share the picture
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }

            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }

        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}


struct ZoomableImageView: UIViewRepresentable {
    let image: UIImage
    let aspectRatio: CGSize // e.g., CGSize(width: 4, height: 3)
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.maximumZoomScale = 5
        scrollView.minimumZoomScale = 1
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(origin: .zero, size: image.size)
        scrollView.addSubview(imageView)
        
        // Set aspect ratio constraints
        let screenSize = UIScreen.main.bounds.size
        let targetSize = calculateTargetSize(for: image.size, aspectRatio: aspectRatio)
        scrollView.contentSize = targetSize
        scrollView.contentInset = UIEdgeInsets(
            top: (screenSize.height - targetSize.height) / 2,
            left: (screenSize.width - targetSize.width) / 2,
            bottom: (screenSize.height - targetSize.height) / 2,
            right: (screenSize.width - targetSize.width) / 2
        )
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return scrollView.subviews.first
        }
    }
    
    // Calculate target size for aspect ratio
    private func calculateTargetSize(for imageSize: CGSize, aspectRatio: CGSize) -> CGSize {
        let imageAspect = imageSize.width / imageSize.height
        let targetAspect = aspectRatio.width / aspectRatio.height
        
        if imageAspect > targetAspect {
            return CGSize(width: imageSize.width, height: imageSize.width / targetAspect)
        } else {
            return CGSize(width: imageSize.height * targetAspect, height: imageSize.height)
        }
    }
}

struct CropView: View {
    let image: UIImage
    let aspectRatio: CGSize
    
    var body: some View {
        ZoomableImageView(image: image, aspectRatio: aspectRatio)
            .overlay(
                Rectangle()
                    .stroke(Color.white, lineWidth: 2)
                    .aspectRatio(aspectRatio.width / aspectRatio.height, contentMode: .fit)
            )
    }
}

struct gtmNecessities: View {
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    @State private var pickerItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        VStack {
            PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
            
            selectedImage?
                .resizable()
                .scaledToFit()
            
            PhotosPicker(selection: $pickerItems, 
                         maxSelectionCount: 3,
                         matching: .any(of: [.images, .not(.screenshots)])) {
                Label("Select a picture", systemImage: "photo")
            }
            
            Button("Leave a review") {
                requestReview()
            }
            
            let example = Image(.example)

            ShareLink(item: example, preview: SharePreview("Singapore Airport", image: example)) {
                Label("Click to share", systemImage: "airplane")
            }
            
            ScrollView {
                ForEach(0..<selectedImages.count, id: \.self) { i in
                    selectedImages[i]
                        .resizable()
                        .scaledToFit()
                }
            }
            
        }
        .onChange(of: pickerItem) {
            Task {
                selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
            }
        }
        .onChange(of: pickerItems) {
            Task {
                selectedImages.removeAll()

                for item in pickerItems {
                    if let loadedImage = try await item.loadTransferable(type: Image.self) {
                        selectedImages.append(loadedImage)
                    }
                }
            }
        }
    }
}

struct filterTesting: View {
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

