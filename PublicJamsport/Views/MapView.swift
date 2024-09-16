//
//  MapView.swift
//  PublicJamsport
//
//  Created by Quang Minh Nguyen on 16/9/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var camera: MapCameraPosition = .automatic
    let cir = CLLocationCoordinate2D(latitude: -33.86132358, longitude: 151.2103898)
    
    let gal = CLLocationCoordinate2D(latitude: -33.873882, longitude: 151.208552)
    
    var body: some View {
        Map(position: $camera) {
            Annotation("Circular Quay", coordinate: cir) {
                Image("Train")
                    .resizable()
                    .frame(maxWidth: 40, maxHeight: 40)
                    .padding()
                
                
            }
            Annotation("Gadigal", coordinate: gal) {
                Image("Metro")
                    .resizable()
                    .frame(maxWidth: 40, maxHeight: 40)
                    .padding()
                
            }
        }
        .safeAreaInset(edge: .top) {
            HStack{
                Spacer()
                Button{
                    camera = .region(MKCoordinateRegion(center: cir, latitudinalMeters: 200, longitudinalMeters: 200))
                }label: {
                    Image(systemName:"location.fill")
                }
                .buttonStyle(.borderedProminent)
                .padding()
                //Spacer()
                    
            }
            .padding(.top)
            //.background(.ultraThinMaterial)
        }
        //.mapStyle(.)
    }
}

#Preview {
    MapView()
}
