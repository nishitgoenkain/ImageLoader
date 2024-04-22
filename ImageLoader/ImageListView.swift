//
//  ImageListView.swift
//  ImageLoader
//
//  Created by Nishit Goenka on 20/04/24.
//

import SwiftUI

struct ImageListView: View {
    @ObservedObject var viewModel: ImageListViewModel
    var body: some View {
        VStack {
            if viewModel.feedData.isEmpty {
                Spacer()
                if ($viewModel.isError.wrappedValue) {
                    Text("Some error occured.\nPlease try Later")
                } else {
                    ProgressView("Loading...")
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 10) {
                        ForEach($viewModel.feedData.indices, id: \.self) { i in
                            let thumbnail = viewModel.feedData[i].thumbnail
                            if let url = URL(string: thumbnail.getImageUrl()) {
                                ImageView(url: url, diskKey: thumbnail.getDiskKey())
                            }
                        }
                    }
                }.padding()
            }
        }.onAppear {
            viewModel.fetchData()
        }
    }
}
