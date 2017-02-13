//
//  ViewController.swift
//  Cali Gold TV
//
//  Created by Theodore Roddy on 1/11/17.
//  Copyright © 2017 Ted Roddy. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: AVPlayerViewController {
    
    let caliGold = (UIApplication.shared.delegate as! AppDelegate).caliGold
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        playRandom()
    }
    
    func play(season: Int, episode: Int) -> Void {
        let episode = caliGold.getEpisodes(bySeason: season)?[episode]
        let videoURL = URL(string: episode!.source)
        let player = AVPlayer(url: videoURL! as URL)
        self.showsPlaybackControls = true
        
        // no meta data display yet
        
        let mediaItem = AVPlayerItem(url: videoURL!)
        
        let titleMetadataItem = AVMutableMetadataItem()
        titleMetadataItem.locale = Locale.current
        titleMetadataItem.key = AVMetadataCommonKeyTitle as (NSCopying & NSObjectProtocol)?
        titleMetadataItem.keySpace = AVMetadataKeySpaceCommon
        titleMetadataItem.value = "The Title" as (NSCopying & NSObjectProtocol)?
        
        let descriptionMetadataItem = AVMutableMetadataItem()
        descriptionMetadataItem.locale = Locale.current
        descriptionMetadataItem.key = AVMetadataCommonKeyDescription as (NSCopying & NSObjectProtocol)?
        descriptionMetadataItem.keySpace = AVMetadataKeySpaceCommon
        descriptionMetadataItem.value = "This is the description" as (NSCopying & NSObjectProtocol)?
        
        mediaItem.externalMetadata.append(titleMetadataItem)
        mediaItem.externalMetadata.append(descriptionMetadataItem)
        
        self.player = player
        self.player!.play()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    func playRandom() {
        let season = Int(arc4random_uniform(23)) + 1
        let episodes = caliGold.getEpisodes(bySeason: season)
        let episode = Int(arc4random_uniform(UInt32(episodes!.count)))
        play(season: season, episode: episode)
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        self.playRandom()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

