//
//  ImageListViewModel.swift
//  ImageLoader
//
//  Created by Nishit Goenka on 20/04/24.
//

import SwiftUI

class ImageListViewModel: ObservableObject {
    @Published var feedData: [FeedData] = []
    @Published var isError = false
    private let nwMgr: NetworkManager
    
    init(nwMgr: NetworkManager = NetworkManager()) {
        self.nwMgr = nwMgr
    }
    
    func fetchData() {
        nwMgr.fetchImages { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let feedData):
                    self.feedData = feedData
                case .failure(let error):
                    self.isError = true
                    print("Error loading images: \(error.localizedDescription)")
                }
            }
        }
    }
}
