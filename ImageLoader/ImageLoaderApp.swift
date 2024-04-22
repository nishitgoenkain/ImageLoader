//
//  ImageLoaderApp.swift
//  ImageLoader
//
//  Created by Nishit Goenka on 20/04/24.
//

import SwiftUI

@main
struct ImageLoaderApp: App {
    var body: some Scene {
        WindowGroup {
            ImageListView(viewModel: ImageListViewModel(nwMgr: NetworkManager()))
        }
    }
}
