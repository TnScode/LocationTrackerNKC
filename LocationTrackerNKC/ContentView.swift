//
//  ContentView.swift
//  LocationTrackerNKC
//
//  Created by Tavin Severino on 9/25/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var isTripLogVisible = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink { TripLogView(locationManager: locationManager) } label: {
                        Image(systemName: "car.rear.and.tire.marks")
                            .font(.title)
                            .padding(.trailing, 50)
                            .accentColor(.primary)
                    }
                    
                    Text("Tracker App")
                        .font(.title)
                        .padding(.leading, 20)
                        .padding(.trailing, 110)
                }
                
                Spacer()
                
                VStack(spacing: 10) {
                    Text("Student: N/A")
                    Text("Current Location: \(locationManager.currentPlaceName ?? "N/A")")
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Departure Time")
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 300, height: 150)
                            .foregroundColor(.black)
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 290, height: 140)
                            .foregroundColor(.white)
                        
                        if let latestTrip = locationManager.trips.last {
                            Text("Departed at: \(formattedDate(latestTrip.departureTime))")
                                .foregroundColor(.black)
                        } else {
                            Text("No departure recorded.")
                                .foregroundColor(.gray)
                        }
                    }
                    Text("Arrival Time")
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 300, height: 150)
                            .foregroundColor(.black)
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 290, height: 140)
                            .foregroundColor(.white)
                        
                        if let latestTrip = locationManager.trips.last {
                            Text("Arrived at: \(formattedDate(latestTrip.arrivalTime))")
                                .foregroundColor(.black)
                        } else {
                            Text("No arrival recorded.")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.bottom, 125)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 120, height: 40)
                        .foregroundColor(.green)
                    NavigationLink(destination: MapView()) {
                        Text("Map")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
