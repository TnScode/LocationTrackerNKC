//
//  MapView.swift
//  LocationTrackerNKC
//
//  Created by Tavin Severino on 9/26/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.211511, longitude: -94.546076),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    private let locations: [(name: String, coordinate: CLLocationCoordinate2D)] = [
        ("Technology Center", CLLocationCoordinate2D(latitude: 39.211511, longitude: -94.546076)),
        ("My Apartment", CLLocationCoordinate2D(latitude: 39.237425, longitude: -94.593758)),
        ("Winnetonka High School", CLLocationCoordinate2D(latitude: 39.179965, longitude: -94.508675)),
        ("Topping Elementary", CLLocationCoordinate2D(latitude: 39.174553, longitude: -94.511544)),
        ("Eastgate Middle School", CLLocationCoordinate2D(latitude: 39.16721078004446, longitude: -94.5257018436461)),
        ("Winnwood Elementary", CLLocationCoordinate2D(latitude: 39.174253, longitude: -94.525643)),
        ("Golden Oaks", CLLocationCoordinate2D(latitude: 39.177669, longitude: -94.542763)),
        ("Maple Park Middle School", CLLocationCoordinate2D(latitude: 39.19062095283076, longitude: -94.50466599655832)),
        ("Maplewood Elementary", CLLocationCoordinate2D(latitude: 39.18896119942993, longitude: -94.50571840085719)),
        ("Gracemor Elementary", CLLocationCoordinate2D(latitude: 39.188029, longitude: -94.485841)),
        ("Ravenwood Elementary", CLLocationCoordinate2D(latitude: 39.20003624236513, longitude: -94.51935226697785)),
        ("Jacobs Center", CLLocationCoordinate2D(latitude: 39.197785, longitude: -94.507727)),
        ("Pleasant Valley", CLLocationCoordinate2D(latitude: 39.217395, longitude: -94.479762)),
        ("Northgate Middle School", CLLocationCoordinate2D(latitude: 39.180022804850424, longitude: -94.55495502460856)),
        ("Crestview Elementary School", CLLocationCoordinate2D(latitude: 39.173384, longitude: -94.570633)),
        ("Chouteau Elementary School", CLLocationCoordinate2D(latitude: 39.159211, longitude: -94.529687)),
        ("Davidson Elementary School", CLLocationCoordinate2D(latitude: 39.187648, longitude: -94.558289)),
        ("Central Office", CLLocationCoordinate2D(latitude: 39.177080, longitude: -94.557474))
    ]

    var body: some View {
        Map() {
            // Add Markers
            ForEach(locations, id: \.name) { location in
                Marker(location.name, coordinate: location.coordinate)
            }

            // Add Circles (Geofences)
            ForEach(locations, id: \.name) { location in
                MapCircle(center: location.coordinate, radius: 100) // 100m radius
                    .foregroundStyle(.blue.opacity(0.3)) // Translucent blue circle
                    .stroke(.blue, lineWidth: 2) // Blue border
            }
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
    }
}

#Preview {
    MapView()
}


