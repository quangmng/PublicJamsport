//
//  Station.swift
//  PublicJamsport
//
//  Created by Quang Minh Nguyen on 17/9/2024.
//

import Foundation
import CoreLocation

struct Station: Identifiable {
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    var transportModes: [String]
    
    // Computed property to return the coordinate
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // Initialization with proper data mapping
    init(from record: [Any]) {
        self.id = record[0] as? Int ?? 0
        self.name = record[1] as? String ?? "Unknown"
        self.latitude = record[3] as? Double ?? 0.0
        self.longitude = record[4] as? Double ?? 0.0
        let transportModesString = record[10] as? String ?? ""
        self.transportModes = transportModesString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    }
    init(id: Int, name: String, latitude: Double, longitude: Double, transportModes: [String]) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.transportModes = transportModes
    }
}
// Extend Station to include an initializer for SavedStation
extension Station {
    // Initialize a Station from a SavedStation
    init(from savedStation: SavedStation) {
        self.id = Int(savedStation.id)
        self.name = savedStation.name ?? "Unknown"
        self.latitude = savedStation.latitude
        self.longitude = savedStation.longitude
        self.transportModes = [] // Assuming transport modes are not saved in Core Data
    }
}

