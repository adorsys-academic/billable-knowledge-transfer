//
//  VideosTableViewDatasource.swift
//  VideoClient
//
//  Created by Tim Abraham on 10.05.20.
//  Copyright © 2020 Tim Abraham. All rights reserved.
//

import UIKit

class VideosTableViewDatasource: NSObject, UITableViewDataSource {
    var videos: [VideosMetaData] = []
    var counter: Int = 0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // for this thesis test with 10 normally use ->
        // return videos.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // for presentation case load example data in tableview
        if counter >= 1 && (indexPath.row == 0) {
        let cell: VideosTableViewCell = (tableView
            .dequeueCell(withIdentifier: "VideosTableViewCell", for: indexPath) as? VideosTableViewCell)!
            cell.configure(image: UIImage(named: "PicturePasscode")!, title: "Picture Passcode", description: "Picture Passcode is awesome!")
            return cell
        } else {
            let cell: VideosTableViewCell = (tableView
                .dequeueCell(withIdentifier: "VideosTableViewCell", for: indexPath) as? VideosTableViewCell)!
            cell.configureWithMockData()
            return cell
        }
    }
}

extension UITableView {
    func dequeueCell<T: UITableViewCell>(withIdentifier identifier: String, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }

    func dequeueCell<T: UITableViewCell>(withIdentifier identifier: String) -> T {
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
