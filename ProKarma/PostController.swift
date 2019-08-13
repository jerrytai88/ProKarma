//
//  PostController.swift
//  ProKarma
//
//  Created by Yu Tai on 8/13/19.
//  Copyright © 2019 Yu Tai. All rights reserved.
//

import Foundation

class PostController {
    
    let manager = DownloadManager()
    var posts: [PostModel] = []
    var currPage: String = ""
    var isDownloading: Bool = false
    
    var count: Int {
        return posts.count
    }
    
    init() {}
    
    func downloadPosts(_ completion: (()->Void)? = nil) {
        if isDownloading { return }
        isDownloading.toggle()
        manager.downloadPosts { result in
            if let result = result {
                self.posts.append(contentsOf: result.0)
                self.currPage = result.1
            }
            self.isDownloading.toggle()
            completion?()
        }
    }
    
    
    func downloadMorePosts(_ completion: (()->Void)? = nil) {
        if isDownloading { return }
        isDownloading.toggle()
        manager.downloadMorePosts(currentPage: currPage) { result in
            if let result = result {
                self.posts.append(contentsOf: result.0)
                self.currPage = result.1
            }
            self.isDownloading.toggle()
            completion?()
        }
    }
    
    func image(_ index: Int, _ completion: @escaping (Data?)->Void) {
        manager.downloadImage(posts[index].imageUrl) { (im) in
            completion(im)
        }
    }
    
    func data(_ index: Int) -> PostModel {
        return posts[index]
    }
    
}
