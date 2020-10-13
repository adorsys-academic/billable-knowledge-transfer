//
//  VideosTableViewController.swift
//  VideoClient
//
//  Created by Tim Abraham on 11.05.20.
//  Copyright © 2020 Tim Abraham. All rights reserved.
//

import UIKit
import CryptoKit
import AVKit
import AVFoundation


class VideosViewController: UIViewController {
    
    @IBOutlet weak var videosTableView: UITableView!
    @IBOutlet weak var totalTokensLabel: UILabel!
    @IBOutlet weak var walletAddressLabel: UILabel!
    
    // for prototyping force-unwrap to localhost
    let networking = Networking(url: URL(string: "http://localhost:3000/")!)
    let contract = SmartContractCommunication()
    var source = VideosTableViewDatasource()
    var refreshControl = UIRefreshControl()
    
    var counter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videosTableView.dataSource = source
        videosTableView.delegate = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        videosTableView.addSubview(refreshControl) // not required when using UITableViewController
        walletAddressLabel.text = networking.walletAdress
        tokenBalance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tokenBalance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // for debug delete last video
//        networking.deleteFromFile(fileName: "video.mp4")
    }
    
    func tokenBalance(){
        let serialQueue = DispatchQueue(label: "queue")
        serialQueue.async {
            self.contract.balanceOf(walletAdress: self.networking.walletAdress)
        }
        serialQueue.async {
            DispatchQueue.main.async {
                self.totalTokensLabel.text = "Your Tokens: \(self.contract.balance)"
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        source.counter += 1
        videosTableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension VideosViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        totalTokensLabel.text = "Your Tokens: 9499"
        let serialQueue = DispatchQueue(label: "serial.queue")
        serialQueue.async {
            self.networking.download()
        }
        serialQueue.async {
            // change to main thread to present avController
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.playVideo()
            }
        }
    }
    
    func playVideo() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = "\(documentsPath)/video.mp4"
        if URL(fileURLWithPath: filePath).checkFileExist() {
            let player = AVPlayer(url: URL(fileURLWithPath: filePath))
            let playerController = AVPlayerViewController()
            playerController.player = player
            present(playerController, animated: true) {
                player.play()
            }
        }
    }
}
