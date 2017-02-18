//
//  Optimizely.swift
//  Cali Gold
//
//  Created by Theodore Roddy on 1/10/17.
//  Copyright © 2017 Ted Roddy. All rights reserved.
//

import Foundation
import OptimizelySDKiOS

class OptimizelyWrapper {
    
    let userId: String
    let projectId: String
    var attributes = [String: String]()
    var user = OPTLYUserProfileDefault()
    var client = OPTLYClient()
    
    init(userId: String, projectId: String) {
        
        self.userId = userId
        self.projectId = projectId
        
        let logger = OPTLYLoggerDefault(logLevel: .debug)
        
        let datafile = try! Data(contentsOf: URL.init(string: "https://cdn.optimizely.com/json/8135665169.json")!)
        
        let optimizelyManager = OPTLYManager.init({(builder) in
            builder!.projectId = self.projectId
            builder!.datafile = datafile
            builder!.eventDispatcher = OPTLYEventDispatcherDefault.init()
            builder!.logger = logger
        })
        
        optimizelyManager?.initialize(callback: { [weak self] (error, optimizelyClient) in
            self?.client = optimizelyClient!
//            NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "OptimizelyStarted")))
            self?.startExperiment()
        })
        
    }
    
    func startExperiment()  -> Void {
        self.set(attributeValue: "test", forKey: "test_attribute")
        if let variation = self.activate(experiment: "Experiment_One") {
            NSLog("[Optimizely JPQUOTE]: Experiment Activated with variation: \(variation.variationKey!)")
            NSLog("[Optimizely JPQUOTE]: \(self.get(stringForKey: "jp_quote"))")
        }
        self.track(event: "app_open")
    }
    
    public func activate(experiment: String) -> OPTLYVariation? {
        let variation = client.activate(experiment, userId: self.userId, attributes: self.attributes)
        return variation
    }
    
    public func getAttributes() -> [String: String] {
        return attributes
    }
    
    public func set(attributeValue value: String, forKey key: String) -> Void {
        self.attributes.updateValue(value, forKey: key)
    }
    
    public func track(event: String) -> Void {
        client.track(event, userId: self.userId, attributes: self.attributes)
    }
    
    public func track(revenueInCents: NSNumber) -> Void {
        client.track("revenue", userId: self.userId, attributes: self.attributes, eventValue: revenueInCents)
    }
    
    public func get(stringForKey key: String) -> String {
        return client.variableString(key, userId: self.userId)!
    }
    
    public func get(boolForKey key: String) -> Bool {
        return client.variableBoolean(key, userId: self.userId)
    }
    
    public func get(doubleForKey key: String) -> Double {
        return client.variableDouble(key, userId: self.userId)
    }
    
    public func get(intForKey key: String) -> Int {
        return client.variableInteger(key, userId: self.userId)
    }
    
}
