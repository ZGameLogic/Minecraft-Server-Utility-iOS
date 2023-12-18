//
//  URLImage.swift
//  Minecraft Server Utility
//
//  Created by Benjamin Shabowski on 12/18/23.
//

import SwiftUI

struct URLImage: View {
    let width: Double
    let height: Double
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)){ phase in
            switch phase {
            case .empty:
                ProgressView().frame(width: width, height: height)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
            case .failure:
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
            @unknown default:
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
            }
        }
    }
}
