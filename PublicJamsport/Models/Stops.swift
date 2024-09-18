//
//  Stops.swift
//  PublicJamsport
//
//  Created by Quang Minh Nguyen on 16/9/2024.
//

import Foundation
import MapKit
import CoreLocation

struct Stops: Hashable, Identifiable, Codable, Equatable {
    static func == (lhs: Stops, rhs: Stops) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int32
    let stopName: String
    let location: Location
    let mode: String
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "code"
        case stopName, location, mode, isFavourite
    }
    // Custom init(from:) for Decodable
       init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           self.id = try container.decode(Int32.self, forKey: .id)
           self.stopName = try container.decode(String.self, forKey: .stopName)
           self.location = try container.decode(Location.self, forKey: .location)
           self.mode = try container.decode(String.self, forKey: .mode)
           self.isFavorite = false // Default value since it's not included in the JSON
       }
       
       // Custom encode(to:) for Encodable
       func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           try container.encode(id, forKey: .id)
           try container.encode(stopName, forKey: .stopName)
           try container.encode(location, forKey: .location)
           try container.encode(mode, forKey: .mode)
           // Intentionally not encoding isFavorite since it's not part of CodingKeys
       }
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

class StopsAnnotation: NSObject, MKAnnotation, Identifiable {
    var coordinate: CLLocationCoordinate2D
    let id: Int
    let mode: String
    let stop: Stops
    let isFavorite: Bool
    let addTime : Date
    
    
    init(stop: Stops, price: Double) {
        id = Int(stop.id)
        mode = stop.mode
        
        coordinate = CLLocationCoordinate2D(latitude: stop.location.latitude, longitude: stop.location.longitude)
        self.stop = stop
        self.isFavorite = stop.isFavorite
        self.addTime = Date()  // new line

    }
}


typealias FavoriteStops = [Stops]

extension FavoriteStops: @retroactive RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(FavoriteStops.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
