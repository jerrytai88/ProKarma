//
//  DownloadManager.swift
//  ProKarma
//
//  Created by Yu Tai on 8/13/19.
//  Copyright © 2019 Yu Tai. All rights reserved.
//

import Foundation

enum Resources {
    static let posts = "https://www.reddit.com/.json"
    static let morePosts = "https://www.reddit.com/.json?after="
}

class DownloadManager {
    
    let session: URLSession
    var cache = [URL:Data]()
    let cacheQueue = DispatchQueue.main
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func downloadPosts(_ completion: @escaping (([PostModel], String)?)-> Void) {
        let url = URL(string: Resources.posts)!
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            let decoder = JSONDecoder()
            do {
                //let posts = try decoder.decode([PostModel].self, from: data)
                var posts: [PostModel] = []
                let jsonData = try decoder.decode(datum.self, from: data)
                for childData in jsonData.data.children {
                    posts.append(childData.data)
                }
                let after = jsonData.data.after
                completion((posts, after))
            }
            catch {
                print("Error decoding object: \(error.localizedDescription)")
                print(error)
                completion(nil)
            }
            }.resume()
    }
    
    func downloadImage(_ urlString: String, _ completion: @escaping (Data?)->Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        if let im = cache[url] {
            completion(im)
            return
        }
        session.dataTask(with: url) { (data, response, error) in
            if let dat = data {
                self.cacheQueue.sync(flags: .barrier) {
                    self.cache[url] = dat
                }
            }
            completion(data)
            }.resume()
    }
    
    
    
    func downloadMorePosts(currentPage: String,
                           _ completion: @escaping (([PostModel], String)?)-> Void) {
        let url = URL(string: Resources.morePosts + currentPage)!
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            let decoder = JSONDecoder()
            do {
                //let posts = try decoder.decode([PostModel].self, from: data)
                var posts: [PostModel] = []
                let jsonData = try decoder.decode(datum.self, from: data)
                for childData in jsonData.data.children {
                    posts.append(childData.data)
                }
                let after = jsonData.data.after
                completion((posts, after))
            }
            catch {
                print("Error decoding object: \(error.localizedDescription)")
                print(error)
                completion(nil)
            }
            }.resume()
        
    }
    
}
