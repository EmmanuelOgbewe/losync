//
//  Localizer.swift
//  navigator
//
//  Created by Emmanuel  Ogbewe on 5/15/20.
//  Copyright © 2020 Emmanuel  Ogbewe. All rights reserved.
//

import Foundation
import CoreLocation


enum Direction : Hashable {
    case left(String)
    case right(String)
    case down(String)
    case up(String)
    case invalid(String)

}

struct TrackerLocation : Hashable, Identifiable{
    var id: String
    var location : CLLocation
    var meta : NSDictionary

}

struct TrackItem : Hashable, Identifiable {
    var itemName : String
    var id : String
    var dir : Direction
    var location : TrackerLocation
    var meta : NSDictionary
}

class Localizer : NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var terminalData = [TrackerLocation]()
    @Published var query : String?
    @Published var currentlocation : CLLocation?
    @Published var itemsInRange = []
    @Published var liveOutput = [TrackItem]()
    
    private var currentLocation : CLLocation?
    
    private var locationManager : CLLocationManager?
        
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    func formatTime(date : Date) -> String{
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "hh:mm:ss"

        return dateFormatter.string(from: date)
    }
    
    
    func insertItem(items : String){
        if let cl = currentLocation {
            var itemsAsArr = items.split(separator: ",")
            var dir : Direction = .invalid("invalid")
            switch itemsAsArr.remove(at: 0).lowercased(){
            case "left" :
                dir = .left("left")
            case "right":
                dir = .right("right")
            case "up":
                dir = .up("up")
            default:
                dir = .invalid("invalid")
            }
            for it in itemsAsArr {
                let id = UUID().uuidString
                let trackedLocation = TrackerLocation(id: id, location: cl, meta: [:])
                let newItem  = TrackItem(itemName: String(it), id: id , dir: dir, location: trackedLocation, meta: [:])
                self.liveOutput.append(newItem)
            }
        }
    }
    
    func filterAndSortOutput(){
    
        if !liveOutput.isEmpty {
            // filter out items not within 3.048 meters (10 ft)
            if let cl = currentLocation {
               
                self.liveOutput =  self.liveOutput.filter({ (it) -> Bool in
                    print(it)
                    print( cl.distance(from: it.location.location ))
                    return cl.distance(from: it.location.location ) <= 3.048
                })
                 //sort based on distance from current location
                self.liveOutput.sort { item1, item2 in
                    return cl.distance(from: item1.location.location) < cl.distance(from: item2.location.location)
                }
            }
        }
        print(self.liveOutput)
        
    }
    
    func performQuery(itemName : String) {

    }
    
    // --- Database --- //

    
    // --- Locations Methods ---- //
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lastLoc = locations.last!
        currentLocation = lastLoc
        filterAndSortOutput()
        if let cl = self.currentLocation {
            let loc = TrackerLocation(id : UUID().uuidString , location: cl, meta : [:])
            terminalData.insert(loc, at: 0)
        }
        terminalData.sort { $0.location.timestamp > $1.location.timestamp}
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
               if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                   if CLLocationManager.isRangingAvailable() {
                       // do stuff
                    locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager?.startUpdatingLocation()
                   }
               }
           }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
           // Location updates are not authorized.
            print(error)
            locationManager?.stopUpdatingLocation()
            return
        }
    }
    
    
    deinit {
        print("de-initializing localizer")
        // clean up if needed
        locationManager?.stopUpdatingLocation()
        locationManager?.stopUpdatingHeading()
    }
    
}
