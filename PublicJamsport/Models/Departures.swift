//
//  Departures.swift
//  PublicJamsport
//
//  Created by Quang Minh Nguyen on 16/9/2024.
//

import Foundation

struct Departures: Codable {
    let stops: [Departure]
    let now: Int
}

struct Departure: Identifiable, Codable {
    let id = UUID()
    let destination: String?
    let serviceType: ServiceType?
    let hasActualDeparture: Bool?
    let actualDeparture: Int
    let line: String?
    let platform: String?

    private enum CodingKeys: String, CodingKey {
        case destination
        case serviceType
        case hasActualDeparture
        case actualDeparture
        case line
        case platform
    }
}

// swiftlint:disable identifier_name
enum ServiceType: String, Codable {
    case bus = "BUS"
    case tram = "TRAM"
    case train = "TRAIN"
    case ferry = "FERRY"
}
