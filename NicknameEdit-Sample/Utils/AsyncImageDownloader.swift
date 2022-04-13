//
//  AsyncImageDownloader.swift
//  NicknameEdit-Sample
//
//  Created by Hiroaki-Hirabayashi on 2022/04/13.
//

import SDWebImageSwiftUI
import SwiftUI

/// url: 画像URL, type: AssetsかSFSymbol, placeholderImage: placeholder画像
struct AsyncImageDownloader: View {
    /// 画像URL
    let url: String
    /// placeholderの画像タイプ
    let type: ImageType
    /// placeholder画像のパス
    let placeholderImage: String
    /// resizableの設定
    let resizableType: ResizableType
    
    /// WebImageへ設定するためのblock
    private var configurations: [(WebImage) -> WebImage] = []
    
    var body: some View {
        configuredWebImage()
        // インジケーターの種類
            .indicator(.activity)
        // フェードイン時間
            .transition(.fade(duration: 0.5))
    }
    
    private func configuredWebImage() -> WebImage {
        var image = WebImage(url: URL(string: url))
        image = configureResizable(image, resizableType)
        image = configurePlaceholder(image, type: type, placeholderImage: placeholderImage)
        
        return configurations.reduce(image) { previous, configuration in
            configuration(previous)
        }
    }
    
    private func configure(_ block: @escaping (WebImage) -> WebImage) -> AsyncImageDownloader {
        var result = self
        result.configurations.append(block)
        return result
    }
}

// MARK: - initialize
extension AsyncImageDownloader {
    init(
        url: String,
        type: ImageType,
        placeholderImage: String,
        resizableType: ResizableType = .on
    ) {
        self.url = url
        self.type = type
        self.placeholderImage = placeholderImage
        self.resizableType = resizableType
    }
}

// MARK: - placeholder
extension AsyncImageDownloader {
    enum ImageType {
        case assets
        case sfSymbol
        case empty
    }
    
    /// Placeholderを設定する
    private func configurePlaceholder(
        _ image: WebImage,
        type: ImageType,
        placeholderImage: String
    ) -> WebImage {
        var result = image
        switch type {
            case .assets:
                result = image.placeholder {
                    Image(placeholderImage)
                        .resizable()
                        .scaledToFit()
                }
            case .sfSymbol:
                result = image.placeholder {
                    Image(systemName: placeholderImage)
                        .resizable()
                        .scaledToFit()
                }
            case .empty:
                break
        }
        return result
    }
}

// MARK: - Layout
extension AsyncImageDownloader {
    enum ResizableType {
        /// resizable()
        case on
        case off
        case custom(capInsets: EdgeInsets, resizingMode: Image.ResizingMode)
    }
    
    private func configureResizable(
        _ image: WebImage,
        _ config: ResizableType
    ) -> WebImage {
        var result = image
        switch config {
            case .on:
                result = image.resizable()
            case let .custom(capInsets, resizingMode):
                result = image.resizable(capInsets: capInsets, resizingMode: resizingMode)
            case .off:
                break
        }
        return result
    }
}

// MARK: - Handler
extension AsyncImageDownloader {
    func onSuccess(
        perform action: ((PlatformImage, Data?, SDImageCacheType) -> Void)? = nil
    ) -> AsyncImageDownloader {
        configure { $0.onSuccess(perform: action) }
    }
}

// MARK: - Preview
struct AsyncImageDownloader_Previews: PreviewProvider {
    static var previews: some View {
        let url = "https://unsplash.it/g/360/240/"
        
        // resizable()
        AsyncImageDownloader(url: url, type: .empty, placeholderImage: "")
            .previewLayout(.fixed(width: 100, height: 100))
        
        // resizable なし
        AsyncImageDownloader(
            url: url,
            type: .sfSymbol,
            placeholderImage: "swift",
            resizableType: .off
        )
            .previewLayout(.fixed(width: 100, height: 100))
        
        // asset placeholder
        AsyncImageDownloader(
            url: "",
            type: .assets,
            placeholderImage: "mypage_avatar_notfound",
            resizableType: .off
        )
            .previewLayout(.fixed(width: 100, height: 100))
        
        // sfSymbol placeholder
        AsyncImageDownloader(
            url: "",
            type: .sfSymbol,
            placeholderImage: "swift",
            resizableType: .off
        )
            .previewLayout(.fixed(width: 100, height: 100))
        
        // tile
        AsyncImageDownloader(
            url: "https://unsplash.it/g/50/50/",
            type: .empty,
            placeholderImage: "",
            resizableType: .custom(
                capInsets: EdgeInsets(), resizingMode: .tile
            )
        )
            .previewLayout(.fixed(width: 100, height: 100))
        
        // empty placeholder
        AsyncImageDownloader(
            url: "",
            type: .empty,
            placeholderImage: "",
            resizableType: .off
        )
        // 画像取得成功時に処理させたい処理があれば追記(フォトライブラリに保存等)
            .onSuccess { image, data, cacheType in
                print(
                    "image:\(image), date:\(String(describing: data)), cacheType:\(cacheType)"
                )
            }
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
