//
//  HomeTableViewCell.swift
//  PhotoShareApp
//
//  Created by Leon Grinshpun on 24/07/2021.
//

import UIKit
import SDWebImage


class HomeTableViewCell: UITableViewCell {
    var post: Photo? {
        didSet {
          updateView()
        }
    }

    @IBOutlet weak var nameLAbel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateView() {
        captionLabel.text = post?.description

        if let photoUrlString = post?.photoRef {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)

        }
        
        if let caption = post?.description {
            
            captionLabel.text = caption
        }
        
        
        if let username = post?.username {

            nameLAbel.text = username
        }
        
        if let profileUrlString = post?.userRef {
            let photoUrl = URL(string: profileUrlString)
            profileImageView.sd_setImage(with: photoUrl)

        }

    }

}
