//
//  ImageLoader.swift
//  ImageLoader
//
//  Created by Nishit Goenka on 22/04/24.
//

import SwiftUI

class ImageLoader: ObservableObject {
    let localCache = NSCache<NSString, UIImage>()
    @Published var loadedImage: UIImage?
    @Published var isError = false
    private var diskKey = ""
    private var loadingTasks: [URLSessionDataTask] = []
    
    func loadImage(from url: URL, diskKey: String) {
        self.diskKey = diskKey
        
        //check for image in cache
        if let cachedImage = localCache.object(forKey: url.absoluteString as NSString) {
            loadedImage = cachedImage
            return
        }
        
        //else if not found in cache, search in disk, if found load from disk and save in local cache
        if let image = loadImageFromDisk(url: url) {
            localCache.setObject(image, forKey: url.absoluteString as NSString)
            loadedImage = image
            return
        }
        
        //else load image from url, save it in local cache and disk
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard error == nil, let data = data, let image = UIImage(data: data) else {
                    self?.isError = true
                    return
                }
                self?.loadedImage = image
                
                self?.localCache.setObject(image, forKey: url.absoluteString as NSString)
                self?.saveImageToDisk(image: image, url: url)
            }
        }
        task.resume()
        loadingTasks.append(task)
    }
    
    private func saveImageToDisk(image: UIImage, url: URL) {
        let filePath = self.cacheFilePath()
        if let data = image.pngData() {
            do {
                try data.write(to: filePath)
            } catch {
                print("Error saving image to disk: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadImageFromDisk(url: URL) -> UIImage? {
        let filePath = self.cacheFilePath()
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return nil
        }
        if let data = FileManager.default.contents(atPath: filePath.path), let image = UIImage(data: data) {
            localCache.setObject(image, forKey: url.absoluteString as NSString)
            return image
        }
        return nil
    }
    
    private func cacheFilePath() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL.appendingPathComponent(self.diskKey)
    }
    
    func cancelLoading() {
        loadingTasks.forEach { $0.cancel() }
        loadingTasks.removeAll()
    }
}
