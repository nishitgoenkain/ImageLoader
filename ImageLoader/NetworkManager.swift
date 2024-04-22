//
//  NetworkManager.swift
//  ImageLoader
//
//  Created by Nishit Goenka on 20/04/24.
//

import SwiftUI

struct FeedData: Decodable {
    let id: String
    let title: String
    let language: String
    let thumbnail: Thumbnail
}

struct Thumbnail: Decodable {
    let id: String
    let domain: String
    let basePath: String
    let key: String
    

    func getImageUrl() -> String {
        return domain + "/" + basePath + "/0/" + key
    }
    
    func getDiskKey() -> String {
        let pathString = basePath + key
        let diskKey = pathString.components(separatedBy: "/").last ?? pathString
        return diskKey
    }
}

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
}

class NetworkManager {
    private let apiUrl = "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100"

    func fetchImages(completion: @escaping (Result<[FeedData], NetworkError>) -> Void) {
        guard let url = URL(string: apiUrl) else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let data = data,
                  let imagesData = try? JSONDecoder().decode([FeedData].self, from: data) else {
                completion(.failure(.invalidResponse))
                return
            }

            completion(.success(imagesData))
        }.resume()
    }

    func cacheImagePath(for key: String) -> URL {
        guard let uniqueKey = key.components(separatedBy: "/").last else { return URL(string: "")! }
        let url = URL.documentsDirectory.appendingPathComponent(uniqueKey)
        return url
    }
}
