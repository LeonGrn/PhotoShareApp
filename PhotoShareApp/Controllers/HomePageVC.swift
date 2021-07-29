//
//  ViewController.swift
//  PhotoShareApp
//
//  Created by Leon Grinshpun on 11/07/2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class HomePageVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var photos = [Photo]()

    var databaseRef: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        //loadPosts()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.photos = []
        loadPosts()

        //check auth status
    }
    
    func loadPosts(){
        Database.database().reference().child("Posts").observe(.childAdded) { snapshot in
            for _ in snapshot.children {
                if let dict = snapshot.value as? [String : Any]{
                    let captionText = dict["photoCaption"] as? String
                    let photoUrlString = dict["photoImageUrl"] as? String
                    let username = dict["username"] as? String
                    let userImgPath = dict["userImgPath"] as? String

                    let post = Photo(description: captionText!, photoRef: photoUrlString! , username: username! , userRef:userImgPath!)
                    if !self.photos.contains(post) {
                        self.photos.append(post)
                        
                    }
                    
                   // self.photos.append(post)
                    
                    
                }
            }
            self.tableView.reloadData()

        }
    }
}

extension HomePageVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell" , for: indexPath) as! HomeTableViewCell
        //cell.textLabel?.text = photos[indexPath.row].description
        print("index \(indexPath.row)")
        print("array size: \(photos.count)")

        let post = photos[indexPath.row]
        cell.post = post
    
        return cell
        
    }
}
