//
//  UserDefaultsManager.swift
//  Weather
//
//  Created by Don E Wettasinghe on 8/16/23.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private let userDefaults = UserDefaults.standard
    
    private init () {}
    
    func saveString(_ value:String, forKey key:String) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    func getString(forKey key:String) -> String {
        return userDefaults.string(forKey: key) ?? ""
    }
    
    func saveDouble(_ value: Double, forKey key: String) {
            userDefaults.set(value, forKey: key)
            userDefaults.synchronize()
        }
        
    func getDouble(forKey key: String) -> Double {
            return userDefaults.double(forKey: key)
    }
}
