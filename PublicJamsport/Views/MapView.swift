//
//  MapView.swift
//  PublicJamsport
//
//  Created by Quang Minh Nguyen on 16/9/2024.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var stations: [Station]
    var viewModel: StationViewModel
    @Binding var region: MKCoordinateRegion // Add a binding for the map's region

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true) // Set the default region
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Check if the annotations are already correct
        let currentAnnotations = uiView.annotations.compactMap { $0 as? MKPointAnnotation }
        let currentTitles = Set(currentAnnotations.compactMap { $0.title ?? "" })
        let newTitles = Set(stations.map { $0.name })
        
        if currentTitles != newTitles {
            // Only update annotations if there are changes
            uiView.removeAnnotations(currentAnnotations)

            let annotations = stations.map { station in
                let annotation = MKPointAnnotation()
                annotation.coordinate = station.coordinate
                annotation.title = station.name
                return annotation
            }
            uiView.addAnnotations(annotations)
        }
        
        // Set the map's region only if it has changed
        if uiView.region.center.latitude != region.center.latitude ||
           uiView.region.center.longitude != region.center.longitude {
            uiView.setRegion(region, animated: true)
        }
    }



    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel: viewModel)
    }


    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var viewModel: StationViewModel

        init(_ parent: MapView, viewModel: StationViewModel) {
            self.parent = parent
            self.viewModel = viewModel
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Station"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true

                // Custom callout accessory view
                let button = UIButton(type: .custom)
                button.frame = CGRect(origin: .zero, size: CGSize(width: 30, height: 30))
                button.setImage(UIImage(systemName: "star"), for: .normal) // default icon
                annotationView?.rightCalloutAccessoryView = button
            } else {
                annotationView?.annotation = annotation
            }

            // Set up the annotation view based on the station's transport modes
            if let station = parent.stations.first(where: { $0.name == annotation.title }) {
                // Set the image based on the transport mode and resize it
                let transportMode = station.transportModes.first ?? ""
                if let image = imageForTransportMode(transportMode) {
                    let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 30, height: 30))
                    annotationView?.image = resizedImage
                }
                
                // Update the image based on whether the station is saved
                if viewModel.isStationSaved(station) {
                    (annotationView?.rightCalloutAccessoryView as? UIButton)?.setImage(UIImage(systemName: "star.fill"), for: .normal)
                }
            }
            
            return annotationView
        }

        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let title = view.annotation?.title,
                  let station = parent.stations.first(where: { $0.name == title }) else { return }
            
            // Toggle the saved state of the station
            viewModel.toggleSaveStation(station)
            
            // Update the annotation view's image
            if let button = view.rightCalloutAccessoryView as? UIButton {
                let imageName = viewModel.isStationSaved(station) ? "star.fill" : "star"
                button.setImage(UIImage(systemName: imageName), for: .normal)
            }
        }
        
        // Helper function to get the image for a transport mode
        private func imageForTransportMode(_ mode: String) -> UIImage? {
            switch mode.lowercased() {
            case "bus":
                return UIImage(named: "Bus")
            case "ferry":
                return UIImage(named: "Ferry")
            case "metro":
                return UIImage(named: "Metro")
            case "train":
                return UIImage(named: "Train")
            case "light rail":
                return UIImage(named: "Tram")
            case "coach":
                return UIImage(named: "Coach")
            case "regional coach":
                return UIImage(named: "Coach")
            case "regional train":
                return UIImage(named: "Train")
            default:
                return UIImage(systemName: "questionmark")
            }
        }
        
        // Helper function to resize the image
        private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            let size = image.size
            
            let widthRatio  = targetSize.width  / size.width
            let heightRatio = targetSize.height / size.height
            
            // Determine the scale factor that preserves aspect ratio
            let scaleFactor = min(widthRatio, heightRatio)
            
            // Compute the new image size that preserves aspect ratio
            let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
            
            // Draw the resized image
            UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
            image.draw(in: CGRect(origin: .zero, size: scaledSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return resizedImage!
        }
    }
}



