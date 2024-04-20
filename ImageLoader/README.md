# SwiftUI Image Loader

This is a SwiftUI application for iOS to efficiently load and display images in a scrollable grid. It shows a 3-column square image grid. The images are center cropped and are lazily loaded using disk and memory caching mechanisms to ensure smooth scrolling performance

## Features
- Image Grid: Show a 3-column square image grid. The images should be centercropped.
- Image Loading: Asynchronous image loading.
- Display: Ability to scroll through at least 100 images.
- Caching: Caching mechanism to store images retrieved from the API in both memory and disk cache for efficient retrieval.
 - Error Handling: Handling of network errors and image loading failures gracefully, providing informative error messages and placeholders for failed image loads.

## Installation

1. Clone the repository to your local machine using:
git clone https://github.com/nishitgoenkain/ImageLoader.git

2. Open the project in Xcode.

3. Build and run the project on a simulator or device.

## Usage

- The app will initially load a grid of images from the API.
- Scroll through the grid to load more images lazily.
- Any errors encountered during image loading will be handled gracefully, with placeholders displayed for failed image loads.

## Dependencies

- None
