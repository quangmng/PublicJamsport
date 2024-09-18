//
//  StopsViewModel.swift
//  PublicJamsport
//
//  Created by Quang Minh Nguyen on 16/9/2024.
//

import Foundation
import MapKit
import CoreData

class StopsViewModel: ObservableObject {
//    @Published var defaultSyd: MKCoordinateRegion = MKCoordinateRegion(center: .init(latitude: -33.8837, longitude: 151.2006), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
    private var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    @Published var favoriteStops = Set<Stops>()
    let sections = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
       @Published var annotations = [StopsAnnotation]()
    
    init(){
        
    }
    
}
