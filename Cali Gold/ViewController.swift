//
//  ViewController.swift
//  Cali Gold
//
//  Created by Theodore Roddy on 1/8/17.
//  Copyright © 2017 Ted Roddy. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import NotificationCenter

class ViewController: UITableViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let caliGold = (UIApplication.shared.delegate as! AppDelegate).caliGold
    var shouldAutoPlay = false
    
    @IBOutlet var variationText: UILabel!
    let playerViewController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background playback
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
    
        self.title = "California's Gold"
        
        // handle 3d touch quick actions should go somewhere else
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.searchQuickAction), name: NSNotification.Name(rawValue: "net.tedroddy.Cali-Gold.search"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.randomQuickAction), name: NSNotification.Name(rawValue: "net.tedroddy.Cali-Gold.watchnow"), object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func play(season: Int, episode: Int) -> Void {
        let episode = caliGold.getEpisodes(bySeason: season)?[episode]
        appDelegate.currentEpisode = episode
        let videoURL = URL(string: episode!.source)
        let player = AVPlayer(url: videoURL! as URL)
        player.allowsExternalPlayback = true
        playerViewController.updatesNowPlayingInfoCenter = true
        playerViewController.allowsPictureInPicturePlayback = true
        playerViewController.showsPlaybackControls = true
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            self.playerViewController.player!.play()
            NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
    }
    
    func playRandom() {
        let season = Int(arc4random_uniform(23)) + 1
        let episodes = caliGold.getEpisodes(bySeason: season)
        let episode = Int(arc4random_uniform(UInt32(episodes!.count)))
        play(season: season, episode: episode)
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        self.appDelegate.currentEpisode = nil
        playerViewController.dismiss(animated: true, completion: { () in
            if self.shouldAutoPlay  {
                self.playRandom()
            }
        })
    }
    
    // MARK: Quick Actions
    
    func searchQuickAction() -> Void {
        
    }
    
    func randomQuickAction() -> Void {
        shouldAutoPlay = true
        playRandom()
    }
    
    // MARK: tableview delegation
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (caliGold.getEpisodes(bySeason: (section+1))?.count)!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 24 // rip
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var array = [String]()
        var i = 1
        while i <= 24 {
            array.append(i.description)
            i = i + 1
        }
        return array
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episode_cell")
        let episode = caliGold.getEpisodes(bySeason: indexPath.section + 1)?[indexPath.row]
        if let airdate = episode?.airdate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            let dateString = formatter.string(from: airdate)
            cell?.detailTextLabel?.text = "Episode \(episode!.episode) — \(dateString)"
        } else {
            cell?.detailTextLabel?.text = "Episode \(episode!.episode)"
        }
        cell?.textLabel?.text = episode?.title
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Season \(section + 1)"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.currentEpisode = caliGold.getEpisodes(bySeason: indexPath.section + 1)?[indexPath.row]
        self.play(season: indexPath.section + 1, episode: indexPath.row)
    }
    
}
