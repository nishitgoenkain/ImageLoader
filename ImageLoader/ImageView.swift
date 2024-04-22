//
//  ImageView.swift
//  ImageLoader
//
//  Created by Nishit Goenka on 21/04/24.
//

import SwiftUI

struct ImageView: View {
    @StateObject private var imageLoader: ImageLoader

    private let url: URL
    private let diskKey: String

    init(url: URL, diskKey: String, imageLoader: ImageLoader = ImageLoader()) {
        self.url = url
        self.diskKey = diskKey
        _imageLoader = StateObject(wrappedValue: imageLoader)
    }
    
    var body: some View {
        Group {
            if let image = imageLoader.localCache.object(forKey: url.absoluteString as NSString) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                if ($imageLoader.isError.wrappedValue) {
                    Image(systemName: "exclamationmark.triangle.fill")
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
        }
        .onAppear {
            imageLoader.loadImage(from: url, diskKey: diskKey)
        }
        .onDisappear {
            imageLoader.cancelLoading()
        }
    }
}
