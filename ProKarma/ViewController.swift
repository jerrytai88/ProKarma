//
//  ViewController.swift
//  ProKarma
//
//  Created by Yu Tai on 8/13/19.
//  Copyright © 2019 Yu Tai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var controller = PostController()
    
    @IBOutlet var postTable: UITableView! {
        didSet {
            postTable.dataSource = self
            postTable.delegate = self
            // postTable.register(UITableViewCell.self, forCellReuseIdentifier: "basicCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.downloadPosts {
            DispatchQueue.main.async {
                self.postTable.reloadData()
            }
        }
    }
    
    
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.count
    }
    // all customization of a cell is done here
    // all customzable parts NEED to be set
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        let index = indexPath.row
        let prod = controller.data(index)
        controller.image(index) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                cell.postImage.image = UIImage(data: image)
            }
        }
        
        cell.title.text = prod.title
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if indexPath.row == controller.count - 1 {
            controller.downloadMorePosts {
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
        }
    }
    
}
