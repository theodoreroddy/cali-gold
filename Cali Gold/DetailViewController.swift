//
//  DetailViewController.swift
//  Cali Gold
//
//  Created by Theodore Roddy on 1/13/17.
//  Copyright © 2017 Ted Roddy. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class DetailViewController: UIViewController {
    
    @IBOutlet var episodeTitleLabel: UILabel!
    @IBOutlet var seasonEpisodeLabel: UILabel!
//    @IBOutlet var playerView: AVPlayerViewController!
    @IBOutlet var synopsisView: UITextView!
    @IBOutlet var airDateLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    let playerViewController = AVPlayerViewController()
    
    override func viewDidLoad() {
//        let episode = appDelegate.currentEpisode
//        let videoURL = URL(string: episode!.source)
//        let player = AVPlayer(url: videoURL! as URL)
//        player.allowsExternalPlayback = true
//        playerViewController.updatesNowPlayingInfoCenter = true
//        playerViewController.allowsPictureInPicturePlayback = true
//        playerViewController.showsPlaybackControls = true
//        playerViewController.player = player
    }
    
}
