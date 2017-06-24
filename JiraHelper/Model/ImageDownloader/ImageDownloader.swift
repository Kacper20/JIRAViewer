//
//  ImageDownloader.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 24/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift
import Kingfisher

//TODO: Error descriptions
enum ImageDownloaderError: Error {
    case invalidUrl
    case downloadingError(Error)
    case unknown
}

final class ImageDownloader {
    private struct ImageResource: Resource {
        let cacheKey: String
        let downloadURL: URL
    }
    func getImage(from url: String) -> Observable<NSImage> {
        return Observable.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(ImageDownloaderError.invalidUrl)
                return Disposables.create()
            }
            let resource = ImageResource(cacheKey: url.absoluteString, downloadURL: url)
            let task = KingfisherManager.shared.retrieveImage(
                with: resource,
                options: nil,
                progressBlock: nil,
                completionHandler: { (image, error, _, _) in
                    if let image = image {
                        observer.onNext(image)
                        observer.onCompleted()
                    } else if let error = error {
                        observer.onError(ImageDownloaderError.downloadingError(error))
                    } else {
                        observer.onError(ImageDownloaderError.unknown)
                    }
            })
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
