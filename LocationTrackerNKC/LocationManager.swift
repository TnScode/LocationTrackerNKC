//
//  LocationManager.swift
//  LocationTrackerNKC
//
//  Created by Tavin Severino on 9/25/24.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var currentPlaceName: String?
    @Published var trips: [Trip] = []
    
    private let locations: [(name: String, coordinate: CLLocationCoordinate2D)] = [
        //WTHS feeder pattern Group A
        ("Technology Center", CLLocationCoordinate2D(latitude: 39.211511, longitude: -94.546076)),
        ("My Apartment", CLLocationCoordinate2D(latitude: 39.237425, longitude: -94.593758)),
        ("Winnetonka High School", CLLocationCoordinate2D(latitude: 39.179965, longitude: -94.508675)),
        ("Topping Elementary", CLLocationCoordinate2D(latitude: 39.174553, longitude: -94.511544)),
        ("Eastgate Middle School", CLLocationCoordinate2D(latitude: 39.16721078004446, longitude: -94.5257018436461)),
        ("Winnwood Elementary", CLLocationCoordinate2D(latitude: 39.174253, longitude: -94.525643)),
        ("Golden Oaks", CLLocationCoordinate2D(latitude: 39.177669, longitude: -94.542763)),
        //WTHS feeder pattern Group B
        ("Maple Park Middle School", CLLocationCoordinate2D(latitude: 39.19062095283076, longitude: -94.50466599655832)),
        ("Maplewood Elementary", CLLocationCoordinate2D(latitude: 39.18896119942993, longitude: -94.50571840085719)),
        ("Gracemor Elementary", CLLocationCoordinate2D(latitude: 39.18802902087739, longitude: -94.48584136070207)),
        ("Ravenwood Elementary", CLLocationCoordinate2D(latitude: 39.20003624236513, longitude: -94.51935226697785)),
        ("Jacobs Center", CLLocationCoordinate2D(latitude: 39.19778511481334, longitude: -94.50772795337731)),
        ("Pleasant Valley", CLLocationCoordinate2D(latitude: 39.217395595713064, longitude: -94.47976252395783)),
        //NKHS feeder pattern
        ("Northgate Middle School", CLLocationCoordinate2D(latitude: 39.180022804850424, longitude: -94.55495502460856)),
        ("Crestview Elementary School", CLLocationCoordinate2D(latitude: 39.173384855187294, longitude: -94.57063386010941)),
        ("Chouteau Elementary School", CLLocationCoordinate2D(latitude: 39.15921142944222, longitude: -94.52968716741535)),
        ("Davidson Elementary School", CLLocationCoordinate2D(latitude: 39.187648911294374, longitude: -94.55828973659732)),
        ("Central Office", CLLocationCoordinate2D(latitude: 39.17708087987304, longitude: -94.55747407152809))
    ]
    
    private var lastPlaceName: String?
    private var lastDepartureTime: Date?
    private var dwellTimers: [String: DispatchWorkItem] = [:] // Track dwell time for geofences
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        checkCurrentGeofence()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startUpdatingLocation()
            startMonitoringGeofences()
        case .denied, .restricted:
            print("Location access denied or restricted")
        case .notDetermined:
            print("Location access not determined")
        @unknown default:
            break
        }
    }

    private func startMonitoringGeofences() {
        for location in locations {
            if !locationManager.monitoredRegions.contains(where: { $0.identifier == location.name }) {
                let geofenceRegion = CLCircularRegion(center: location.coordinate, radius: 100, identifier: location.name)
                geofenceRegion.notifyOnEntry = true
                geofenceRegion.notifyOnExit = true
                locationManager.startMonitoring(for: geofenceRegion)
            }
        }
    }
    
    func checkCurrentGeofence() {
        guard let location = locationManager.location else { return }
        
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion,
               circularRegion.contains(location.coordinate) {
                lastPlaceName = circularRegion.identifier
                print("Starting inside: \(lastPlaceName ?? "Unknown")")
                break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        currentLocation = newLocation
        
        currentPlaceName = nil
        for location in self.locations {
            let region = CLCircularRegion(center: location.coordinate, radius: 100, identifier: location.name)
            if region.contains(newLocation.coordinate) {
                currentPlaceName = location.name
                break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let geofenceRegion = region as? CLCircularRegion else { return }
        let identifier = geofenceRegion.identifier
        
        // Start a dwell timer
        let dwellWorkItem = DispatchWorkItem {
            self.recordGeofenceEntry(identifier: identifier)
        }
        
        // Store the timer and execute after 5 seconds
        dwellTimers[identifier] = dwellWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 30, execute: dwellWorkItem)
        
        print("Entered \(identifier), waiting 30 seconds to confirm stop...")
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let geofenceRegion = region as? CLCircularRegion else { return }
        let identifier = geofenceRegion.identifier

        // Cancel dwell timer if user exits early
        if let dwellWorkItem = dwellTimers[identifier] {
            dwellWorkItem.cancel()
            dwellTimers.removeValue(forKey: identifier)
            print("Exited \(identifier) before dwell time. Entry not recorded.")
        }

        let departureTime = Date()
        lastDepartureTime = departureTime
        lastPlaceName = geofenceRegion.identifier
        print("Departed from \(geofenceRegion.identifier) at \(departureTime)")
    }

    private func recordGeofenceEntry(identifier: String) {
        let arrivalTime = Date()

        if let lastPlace = lastPlaceName, let departureTime = lastDepartureTime {
            let trip = Trip(
                departedFrom: lastPlace,
                arrivedAt: identifier,
                departureTime: departureTime,
                arrivalTime: arrivalTime,
                currentPlaceName: identifier
            )

            DispatchQueue.main.async {
                self.trips.append(trip)
                print("Trip added: \(trip)")
            }
        }

        lastPlaceName = identifier
        lastDepartureTime = nil
        print("Confirmed stop at \(identifier) after 5 seconds.")
    }
}



