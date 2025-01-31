//
//  SideBarView.swift
//  LocationTrackerNKC
//
//  Created by Tavin Severino on 1/22/25.
//
import SwiftUI

struct TripLogView: View {
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        List(locationManager.trips, id: \.departureTime) { trip in
            VStack(alignment: .leading) {
                Text("From: \(trip.departedFrom)")
                    .font(.headline)
                Text("To: \(trip.arrivedAt)")
                    .font(.subheadline)
                Text("Departure Time: \(formatDate(trip.departureTime))")
                    .font(.subheadline)
                Text("Arrival Time: \(formatDate(trip.arrivalTime))")
                    .font(.subheadline)
            }
        }
        .navigationTitle("Trip Log")
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    TripLogView(locationManager: LocationManager())
}


//For Testing




//import SwiftUI
//
//struct TripLogView: View {
//    @ObservedObject var locationManager: LocationManager
//
//    var body: some View {
//        ScrollView {
//            VStack {
//                Text("Travel Log")
//                    .font(.largeTitle)
//                    .padding(.top)
//
//                // Display trips dynamically
//                ForEach(locationManager.trips, id: \.departedFrom) { trip in
//                    ZStack {
//                        Rectangle()
//                            .frame(width: 350, height: 100)
//                            .cornerRadius(25)
//                            .foregroundColor(Color.blue)
//                        HStack {
//                            Text(trip.departedFrom)
//                            Text(" -> ")
//                            Text(trip.arrivedAt)
//                        }
//                        .foregroundColor(.white)
//                    }
//                    .padding(.top)
//                }
//
//                // Test buttons to simulate trips
//                HStack {
//                    Button("Simulate Trip 1") {
//                        simulateTrip(departedFrom: "Tech Center", arrivedAt: "Winnetonka High School")
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    .padding()
//
//                    Button("Simulate Trip 2") {
//                        simulateTrip(departedFrom: "Winnetonka High School", arrivedAt: "Topping Elementary")
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    .padding()
//                }
//            }
//            .padding()
//        }
//    }
//
//    private func simulateTrip(departedFrom: String, arrivedAt: String) {
//        // Simulate adding a trip to the trip log
//        locationManager.trips.append((departedFrom: departedFrom, arrivedAt: arrivedAt))
//    }
//}
//
//#Preview {
//    TripLogView(locationManager: LocationManager())
//}
