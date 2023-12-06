//
//  LocationModel.swift
//  Sk8safe
//
//  Created by Andrew Cen on 11/28/23.
//
//  This is the model for location handling
//

import Foundation
import CoreLocation
import MapKit

class LocationModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    // CL objects
    var locationManager: CLLocationManager?
    var currRegion = MKCoordinateRegion()
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        //locationManager?.distanceFilter = 10 // Use this value if the location points are too close together
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.showsBackgroundLocationIndicator = true
        locationManager?.requestWhenInUseAuthorization()
        requestLocationUpdate()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .notDetermined:
                print("When user did not yet determine")
            case .restricted:
                print("Restricted by parental control")
            case .denied:
                print("When user selects option Don't Allow")
            case .authorizedAlways:
                print("When user select option Change to Always Allow")
            case .authorizedWhenInUse:
                print("When user selects option Allow While Using App or Allow Once")
                locationManager?.requestAlwaysAuthorization()
            default:
                print("default")
        }
    }
    
    // One time location update request
    func requestOnTimeLocation() {
            locationManager?.requestLocation()
    }
    
    // Start keeping location updated in background
    private func requestLocationUpdate() {
        locationManager?.startUpdatingLocation()
    }
    
    // Stop keeping location updated in background
    private func stopLocationUpdate() {
        locationManager?.stopUpdatingLocation()
    }
    
    // We implement method locationManager(_:didUpdateLocations:) in our view controller to get location information, since it's only one-time location, we will get the last item from an array of locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
        // Update LocationModel's own location information
        currRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
    }
    
    // Implemented error handling
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager?.stopUpdatingLocation()

        if let clErr = error as? CLError {
            switch clErr.code {
                case .locationUnknown, .denied, .network:
                    print("Location request failed with error: \(clErr.localizedDescription)")
                case .headingFailure:
                    print("Heading request failed with error: \(clErr.localizedDescription)")
                case .rangingUnavailable, .rangingFailure:
                    print("Ranging request failed with error: \(clErr.localizedDescription)")
                case .regionMonitoringDenied, .regionMonitoringFailure, .regionMonitoringSetupDelayed, .regionMonitoringResponseDelayed:
                    print("Region monitoring request failed with error: \(clErr.localizedDescription)")
                default:
                    print("Unknown location manager error: \(clErr.localizedDescription)")
            }
        } else {
            print("Unknown error occurred while handling location manager error: \(error.localizedDescription)")
        }
    }
}
