//
//  FromWebViewController.swift
//  SKPhotoBrowserExample
//
//  Created by suzuki_keishi on 2015/10/06.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import SDWebImage

class FromWebViewController: UIViewController, SKPhotoBrowserDelegate {
    var images = [SKPhotoProtocol]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKCache.sharedCache.imageCache = CustomImageCache()
    }
    
    @IBAction func pushJpgPngButton(_ sender: AnyObject) {
        let browser = SKPhotoBrowser(photos: createWebPhotos())
        browser.initializePageIndex(0)
        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
    }

    @IBAction func pushGifButton(_ sender: AnyObject) {
        let browser = SKPhotoBrowser(photos: createWebGifPhotos())
        browser.initializePageIndex(0)
        browser.delegate = self

        present(browser, animated: true, completion: nil)
    }
  
    @IBAction func pushSVGButton(_ sender: AnyObject) {
        let browser = SKPhotoBrowser(photos: createWebSVGPhotos())
        browser.initializePageIndex(0)
        browser.delegate = self

        present(browser, animated: true, completion: nil)
    }
}

// MARK: - SKPhotoBrowserDelegate

extension FromWebViewController {
    func didDismissAtPageIndex(_ index: Int) {
    }
    
    func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
    }
    
    func removePhoto(index: Int, reload: (() -> Void)) {
        SKCache.sharedCache.removeImageForKey("somekey")
        reload()
    }
}

// MARK: - private

private extension FromWebViewController {
    func createWebPhotos() -> [SKPhotoProtocol] {
        return (0..<10).map { (i: Int) -> SKPhotoProtocol in
            let photo = SKPhoto.photoWithImageURL("https://placehold.jp/15\(i)x15\(i).png")
            photo.caption = caption[i%10]
            photo.shouldCachePhotoURLImage = true
            return photo
        }
    }

    func createWebGifPhotos() -> [SKPhotoProtocol] {
        let gifs: [String] = [
            "https://media.giphy.com/media/ftdEPX8jF6SvC/giphy.gif",
            "https://media.giphy.com/media/MDrq4Gwd0i4m4mGwCr/giphy.gif",
            "https://media.giphy.com/media/jOOjdVK9i2Qn1alT6a/giphy.gif"
        ]

        var result: [SKPhotoProtocol] = []
        for (i, v) in gifs.enumerated() {
            let photo = SKPhoto.photoWithImageURL(v)
            photo.caption = caption[i]
            result.append(photo)
        }
        return result
    }
  
    func createWebSVGPhotos() -> [SKPhotoProtocol] {
        let gifs: [String] = [
            "https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/raleigh.svg",
            "https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/easypeasy.svg",
            "https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/svg.svg"
        ]

        var result: [SKPhotoProtocol] = []
        for (i, v) in gifs.enumerated() {
            let photo = SKPhoto.photoWithImageURL(v)
            photo.caption = caption[i]
            result.append(photo)
        }
        return result
    }
}

class CustomImageCache: SKImageCacheable {
    var cache: SDImageCache
    
    init() {
        let cache = SDImageCache(namespace: "com.suzuki.custom.cache")
        self.cache = cache!
    }

    func imageForKey(_ key: String) -> UIImage? {
        guard let image = cache.imageFromDiskCache(forKey: key) else { return nil }
        
        return image
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.store(image, forKey: key)
    }

    func removeImageForKey(_ key: String) {}
    
    func removeAllImages() {}
    
}
