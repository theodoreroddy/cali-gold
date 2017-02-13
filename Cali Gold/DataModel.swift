//
//  EpisodeData.swift
//  Cali Gold iOS
//
//  Created by Theodore Roddy on 8/22/16.
//  Copyright © 2016 Ted Roddy. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataModel {
    
    public let Episodes: [Episode]
    
    init() {
        
        var _Episodes = [Episode]()
        
        let path = Bundle.main.path(forResource:"Episodes", ofType: "json")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        let json = JSON(data: data)
        
        for episode in json {
            let ep = episode.1
            
            let _season = ep["season"].int
            let _episode = ep["episode"].int
            let _code = ep["code"].string
            let _title = ep["title"].string
            let _description = ep["description"].string
            let _url = ep["url"].string
            let _source = ep["source"].string
            let _airdate = ep["air_date"].string
            
            let _ep = Episode(season: _season!,
                              episode: _episode!,
                              code: _code!,
                              title: _title!,
                              description: _description!,
                              url: _url!,
                              source: _source!,
                              airdate: _airdate!)
            
            _Episodes.append(_ep)
            
        }
        
        self.Episodes = _Episodes
        
    }
    
    public func getEpisodes(bySeason season: Int) -> [Episode]? {
        var _episodes = [Episode]()
        for ep in self.Episodes {
            if ep.season == season {
                _episodes.append(ep)
            }
        }
        if _episodes.count == 0 {
            return nil
        }
        _episodes.sort(by: { $0.episode < $1.episode })
        return _episodes
    }
    
}

class Episode {
    
    public let season: Int
    public let episode: Int
    public let code: String
    public let title: String
    public let description: String
    public let url: String
    public let source: String
    public let airdate: Date?
    
    init(season: Int, episode: Int, code: String, title: String, description: String, url: String, source: String, airdate: String) {
        
        self.season = season
        self.episode = episode
        self.code = code
        self.title = title
        self.url = url
        self.source = source
        
        if description != "" {
            self.description = description
        } else {
            self.description = "No description available."
        }
        
        if airdate != "" {
            let _date = DateFormatter()
            _date.dateFormat = "yyyy-MM-dd"
            
            self.airdate = _date.date(from: airdate)
        } else {
            self.airdate = nil
        }
        
    }
    
    
}
