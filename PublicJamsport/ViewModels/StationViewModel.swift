//
//  StationViewModel.swift
//  PublicJamsport
//
//  Created by Quang Minh Nguyen on 18/9/2024.
//

import Foundation
import CoreData
import SwiftUI
import MapKit

class StationViewModel: ObservableObject {
    @Published var defaultSyd: MKCoordinateRegion = MKCoordinateRegion(center: .init(latitude: -33.8837, longitude: 151.2006), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @Published var stations: [Station] = []
    @Published var savedStations: [SavedStation] = []

    // Fetch data from Core Data once
    init(context: NSManagedObjectContext) {
        loadSavedStations(context: context)
    }
    
    // Function to unsave a station
    func unsaveStation(_ station: Station, context: NSManagedObjectContext) {
        if let savedStation = savedStations.first(where: { $0.id == station.id }) {
            savedStation.isSaved = false
            do {
                try context.save()
                loadSavedStations(context: context) // Refresh the saved stations list
            } catch {
                print("Error saving context after unsaving: \(error.localizedDescription)")
            }
        }
    }

    // Method to load saved stations from Core Data
    func loadSavedStations(context: NSManagedObjectContext) {
        guard savedStations.isEmpty else { return }
        
        let fetchRequest: NSFetchRequest<SavedStation> = SavedStation.fetchRequest()
        do {
            savedStations = try context.fetch(fetchRequest)
            print("Loaded stations: \(savedStations.count)")
        } catch {
            print("Failed to fetch saved stations: \(error.localizedDescription)")
        }
    }
    
    // Computed property to convert SavedStation to Station
    var convertedSavedStations: [Station] {
        return savedStations.map { Station(from: $0) }
    }

    private let context = PersistenceController.shared.container.viewContext

    init() {
        loadStations()
        fetchSavedStations()
    }

    // Decode JSON to load stations
    private func loadStations() {
        guard let url = Bundle.main.url(forResource: "stationsStops", withExtension: "json") else {
            print("JSON file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)

            // Decode JSON assuming the root is a dictionary containing "records"
            let rawJson = try JSONSerialization.jsonObject(with: data, options: [])
            
            // Parse the records
            if let jsonDict = rawJson as? [String: Any],
               let records = jsonDict["records"] as? [[Any]] {
                
                // Map the records to Station objects
                let stations = records.map { Station(from: $0) }
                self.stations = stations
                print("Loaded stations: \(stations.count)")
            } else {
                print("Could not find 'records' key in JSON dictionary")
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }



    // Fetch saved stations from Core Data
    private func fetchSavedStations() {
        let request: NSFetchRequest<SavedStation> = SavedStation.fetchRequest()
        
        do {
            savedStations = try context.fetch(request)
        } catch {
            print("Error fetching saved stations: \(error)")
        }
    }

    // Check if station is saved
    func isStationSaved(_ station: Station) -> Bool {
        return savedStations.contains(where: { $0.id == station.id })
    }

    // Save or unsave station
    func toggleSaveStation(_ station: Station) {
        if isStationSaved(station) {
            removeStation(station)
        } else {
            saveStation(station)
        }
    }

    // Save station to Core Data
    private func saveStation(_ station: Station) {
        let savedStation = SavedStation(context: context)
        savedStation.id = Int64(station.id)
        savedStation.name = station.name
        savedStation.latitude = station.latitude
        savedStation.longitude = station.longitude

        do {
            try context.save()
            fetchSavedStations()
        } catch {
            print("Error saving station: \(error)")
        }
    }

    // Remove station from Core Data
    private func removeStation(_ station: Station) {
        if let savedStation = savedStations.first(where: { $0.id == station.id }) {
            context.delete(savedStation)
            
            do {
                try context.save()
                fetchSavedStations()
            } catch {
                print("Error removing station: \(error)")
            }
        }
    }
}

