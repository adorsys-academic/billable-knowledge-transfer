//
//  VideosTableViewCell.swift
//  VideoClient
//
//  Created by Tim Abraham on 10.05.20.
//  Copyright © 2020 Tim Abraham. All rights reserved.
//

import UIKit

class VideosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconVideoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(image: UIImage, title: String, description: String) {
        iconVideoImageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    func configure(with videosMetaData: VideosMetaData) {
        iconVideoImageView.image = UIImage(data: videosMetaData.image)
        titleLabel.text = videosMetaData.title
        descriptionLabel.text = videosMetaData.description
    }
  
    func configureWithMockData(){
        iconVideoImageView.image = UIImage(systemName: "video.circle")
        titleLabel.text = "This is cool!"
        descriptionLabel.text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. "
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
