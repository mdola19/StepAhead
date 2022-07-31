//
//  ViewController.swift
//  StepAhead
//
//  Created by CoopStudent on 2022-07-30.
//

import UIKit
import MapKit
import CoreLocation

struct Location {
    var locationName = ""
    var category = ""
    var address = ""
    var long = ""
    var lat = ""
    var description = ""
    
    init(raw: [String]) {
        locationName = raw[0]
        category = raw[1]
        address = raw[2]
        long = raw[3]
        lat = raw[4]
        description = raw[5]
    }
    
}

func loadCSV(from csvName: String) -> [Location] {
    
    var csvToStruct = [Location]()
    
    
    // locate csv file
    guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {return []}
    
    // convert the contents of the file into 1 very long string
    var data = ""
    do {
        data = try String(contentsOfFile: filePath)
    } catch {
        print(error)
        return []
    }
    
    // split long string into array of rows of data. Each row is a string
    var rows = data.components(separatedBy: "\n")
    
    // remove title row
    rows.removeFirst()
    
    // now loop through each row and split into columns
    for row in rows {
        let csvColumns = row.components(separatedBy: ",")
        let locationStruct = Location.init(raw: csvColumns)
        csvToStruct.append(locationStruct)
    }
    
    return csvToStruct
}

class ViewController: UIViewController, MKMapViewDelegate {
    
    
    var popups = [UIView]()
    var popup_titles = [UILabel]()
    var popup_subtitles = [UILabel]()
    var popup_descriptions = [UILabel]()
    let bg_tint = UIView()
    var walk = UIButton()
    var bike = UIButton()
    var bus = UIButton()
    var directionsArray = [MKDirections]()
    var etalbl = UILabel()
    public var distance: Double = 0
    var accessBikeRentals = UIButton()
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationAnnotations = [MKPointAnnotation]()
    var annotationViews = [MKAnnotationView]()
    var locationNames = [String]()
    var transportation = MKDirectionsTransportType()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        etalbl.alpha = 0

        mapView.delegate = self
        
        var bramptonLocations = loadCSV(from: "newLocations")

        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .dark
        }
        
        checkLocationServices()
        
        accessBikeRentals.frame = CGRect(x: 30, y: 50, width: 60, height: 60)
        accessBikeRentals.setTitle("$", for: .normal)
        accessBikeRentals.setTitleColor(UIColor.black, for: .normal)
        accessBikeRentals.backgroundColor = UIColor.green
        accessBikeRentals.layer.cornerRadius = 30
        accessBikeRentals.alpha = 0
        mapView.addSubview(accessBikeRentals)
        
        for i in 0 ... bramptonLocations.count - 1 {
            locationAnnotations.append(MKPointAnnotation())
        }
        
        
        for j in 0 ... locationAnnotations.count - 1 {
            let longitudes = Double(bramptonLocations[j].long)
            let latitudes = Double(bramptonLocations[j].lat)
            locationAnnotations[j].coordinate = CLLocationCoordinate2D(latitude: latitudes!, longitude: longitudes!)
            self.mapView.addAnnotation(locationAnnotations[j])
        }
        
        for m in 0 ... locationAnnotations.count - 1 {
            locationNames.append(bramptonLocations[m].locationName)
            popups.append(UIView.init(frame: CGRect(x: 55, y: 300, width: mapView.frame.width - 100, height: mapView.frame.height - 650)))
        }
        
        for popup in 0 ... popups.count - 1 {
            popups[popup].layer.cornerRadius = 15
            popups[popup].backgroundColor = UIColor.white
        }
        
        for name in 0 ... locationNames.count - 1 {
            popup_titles.append(UILabel(frame: CGRect(x: 65, y: popups[name].frame.origin.y + 20, width: popups[name].frame.width - 20, height: 100)))
            popup_titles[name].text = locationNames[name]
            popup_titles[name].font = UIFont(name: "Poppins-Bold", size: 20)
            popup_titles[name].textAlignment = .center
            popup_titles[name].textColor = UIColor.black
            
            popup_subtitles.append(UILabel(frame: CGRect(x: 65, y: popup_titles[name].frame.origin.y + 32, width: popups[name].frame.width - 20, height: 100)))
            popup_subtitles[name].text = bramptonLocations[name].category
            popup_subtitles[name].font = UIFont(name: "Poppins-Semibold", size: 12)
            popup_subtitles[name].textAlignment = .center
            popup_subtitles[name].textColor = UIColor.black
            
        }
        
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.7315, longitude: -79.7624), latitudinalMeters: 16000, longitudinalMeters: 16000), animated: true)
        mapView.delegate = self
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            // Create the view
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let image = UIImage(named: "footsteps2")
        annotationView?.image = image
        
        return annotationView
    }

    var currentAnnotation = CLLocationCoordinate2D()
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        for annotation in 0 ... locationAnnotations.count - 1 {
            if locationAnnotations[annotation].coordinate.latitude == view.annotation?.coordinate.latitude {
                bg_tint.frame = CGRect(x: 0, y: 0, width: mapView.frame.width, height: mapView.frame.height)
                bg_tint.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                
                mapView.addSubview(bg_tint)
                mapView.addSubview(popups[annotation])
                mapView.addSubview(popup_titles[annotation])
                mapView.addSubview(popup_subtitles[annotation])
                
                walk.frame = CGRect(x: 80, y: popup_subtitles[annotation].frame.origin.y + 95, width: 80, height: 50)
                walk.setTitle("Walk", for: .normal)
                walk.setTitleColor(UIColor.black, for: .normal)
                walk.backgroundColor = UIColor.green
                walk.layer.cornerRadius = 15
                mapView.addSubview(walk)
                
                walk.addTarget(self, action: #selector(walking), for: .touchUpInside)
                
                bike.frame = CGRect(x: 170, y: popup_subtitles[annotation].frame.origin.y + 95, width: 80, height: 50)
                bike.setTitle("Bike", for: .normal)
                bike.setTitleColor(UIColor.black, for: .normal)
                bike.backgroundColor = UIColor.green
                bike.layer.cornerRadius = 15
                mapView.addSubview(bike)
                
                bike.addTarget(self, action: #selector(biking), for: .touchUpInside)
                
                bus.frame = CGRect(x: 260, y: popup_subtitles[annotation].frame.origin.y + 95, width: 80, height: 50)
                bus.setTitle("Bus", for: .normal)
                bus.setTitleColor(UIColor.black, for: .normal)
                bus.backgroundColor = UIColor.green
                bus.layer.cornerRadius = 15
                mapView.addSubview(bus)
                
                bus.addTarget(self, action: #selector(busing), for: .touchUpInside)
                
                currentAnnotation = locationAnnotations[annotation].coordinate
            }
            
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeBg_tint))
        bg_tint.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func removeBg_tint () {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity:  1.0, options: .curveEaseInOut, animations: {
            for i in 0 ... self.popups.count - 1 {
                self.popups[i].removeFromSuperview()
                self.popup_titles[i].removeFromSuperview()
                self.popup_subtitles[i].removeFromSuperview()
                self.walk.removeFromSuperview()
                self.bike.removeFromSuperview()
                self.bus.removeFromSuperview()
                self.mapView.addSubview(self.etalbl)
            }
            
            self.bg_tint.removeFromSuperview()
        }, completion: nil)
    }
    
    @objc func walking() {
        accessBikeRentals.alpha = 0
        transportation = .walking
        getDirections()
    }
    
    @objc func busing() {
        accessBikeRentals.alpha = 0
        transportation = .automobile
        getDirections()
    }
    
    @objc func openBikeRentals() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "bikeRental")
//        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @objc func biking() {
        accessBikeRentals.alpha = 1
        
        accessBikeRentals.addTarget(self, action: #selector(openBikeRentals), for: .touchUpInside)

        transportation = .walking
        
        let destination = currentAnnotation
        let startingPoint = CLLocationCoordinate2D(latitude: 43.6849, longitude: -79.7596)
        let startingPointAnn = MKPointAnnotation()
        startingPointAnn.coordinate = CLLocationCoordinate2D(latitude: 43.6849, longitude: -79.7596)
        mapView.addAnnotation(startingPointAnn)
        
        let destination_loc = CLLocation(latitude: currentAnnotation.latitude, longitude: currentAnnotation.longitude)
        let start_loc = CLLocation(latitude: 43.6849, longitude: -79.7596)
        
        let distance = destination_loc.distance(from: start_loc)
        print("\(round(distance/1000)) kilometers")
        
        let sourcePlacemark = MKPlacemark(coordinate: startingPoint)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = transportation
        
        let directions = MKDirections(request: directionRequest)
        resetMapView(withNew: directions)
        
        directions.calculate { [self] (response, error) in
            guard let directionResponse = response else {
                if let error = error {
                    print("Could not get directions==\(error.localizedDescription)")
                }
                
                return
            }
            
            let route = directionResponse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let eta: Int = Int(route.expectedTravelTime / 60 / 5)
            var finalEta = ""

            if eta > 59 {
                finalEta = "ETA: \(eta / 60) hour(s)"
            } else {
               finalEta = "ETA: \(eta) minutes"
            }
            
            etalbl.frame = CGRect(x: 20, y: mapView.frame.height - 250, width: mapView.frame.width - 40, height: 60)
            etalbl.text = finalEta
            etalbl.textColor = UIColor.black
            etalbl.textAlignment = .center
            etalbl.font = UIFont(name: "Poppins-Font-2/Poppins-Semibold", size: 18)
            etalbl.backgroundColor = UIColor.green
            etalbl.alpha = 1.0
            etalbl.layer.cornerRadius = 15
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        self.mapView.delegate = self
        
        func resetMapView(withNew directions: MKDirections) {
            mapView.removeOverlays(mapView.overlays)
            directionsArray.append(directions)
            let _ = directionsArray.map { $0.cancel() }
        }
    }
    
    @objc func getDirections() {
        let destination = currentAnnotation
        let startingPoint = CLLocationCoordinate2D(latitude: 43.6849, longitude: -79.7596)
        
        let destination_loc = CLLocation(latitude: currentAnnotation.latitude, longitude: currentAnnotation.longitude)
        let start_loc = CLLocation(latitude: 43.6849, longitude: -79.7596)
        
        distance = destination_loc.distance(from: start_loc)
        print("\(round(distance/1000)) kilometers")
        
        let sourcePlacemark = MKPlacemark(coordinate: startingPoint)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = transportation
        
        let directions = MKDirections(request: directionRequest)
        resetMapView(withNew: directions)
        
        directions.calculate { [self] (response, error) in
            guard let directionResponse = response else {
                if let error = error {
                    print("Could not get directions==\(error.localizedDescription)")
                }
                
                return
            }
            
            let route = directionResponse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let eta: Int = Int(route.expectedTravelTime / 60)
            var finalEta = ""

            if eta > 59 {
                finalEta = "ETA: \(eta / 60) hour(s)"
            } else {
               finalEta = "ETA: \(eta) minutes"
            }
            
            etalbl.frame = CGRect(x: 20, y: mapView.frame.height - 100, width: mapView.frame.width - 40, height: 60)
            etalbl.text = finalEta
            etalbl.textColor = UIColor.black
            etalbl.textAlignment = .center
            etalbl.font = UIFont(name: "Poppins-Font-2/Poppins-Semibold", size: 18)
            etalbl.backgroundColor = UIColor.green
            etalbl.alpha = 1.0
            etalbl.layer.cornerRadius = 15
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
                
        
        self.mapView.delegate = self
        
        func resetMapView(withNew directions: MKDirections) {
            mapView.removeOverlays(mapView.overlays)
            directionsArray.append(directions)
            let _ = directionsArray.map { $0.cancel() }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor =  UIColor.green
        renderer.lineWidth = 7.0
        
        return renderer
    }
    
    let LocationManager = CLLocationManager()
    
    func setupLocationManager() {
        LocationManager.delegate = self
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }
        
        else {
           // show alert to turn on location services
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            LocationManager.startUpdatingLocation()
            break
        case .denied:
            // show alert to instruct how to permit the app
            break
        case .notDetermined:
            LocationManager.requestWhenInUseAuthorization()
        case .restricted:
            // show alert
            break
        case .authorizedAlways:
            break
        }
    }
    
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         checkLocationAuthorization()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        return
    }
    
    
}

