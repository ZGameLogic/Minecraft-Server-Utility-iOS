//
//  CachedImage.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 1/4/24.
//

import SwiftUI

struct CachedImage: View {
    private var cache: NSCache<NSURL, UIImage>
    
    var url: String
    
    @State var image: Image?
    
    init(url: String) {
        self.cache = NSCache<NSURL, UIImage>()
        self.url = url
        if let cached = cache.object(forKey: URL(string: url)! as NSURL) {
            image = Image(uiImage: cached)
        }
    }
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }.onAppear(perform: updateImage)
    }
    
    func updateImage() {
        Task {
            let(data, response) = try await URLSession.shared.data(from: URL(string: url)!)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("invalid response code fetching image from url: \(url)")
                return
            }
            let newImage = UIImage(data: data)
            cache.setObject(newImage!, forKey: URL(string: url)! as NSURL)
            image = Image(uiImage: newImage!)
        }
    }
}
