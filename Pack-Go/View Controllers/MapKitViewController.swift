//
//  MapKitViewController.swift
//  Pack-Go
//
//  Created by Xcode User on 2019-10-25.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    @IBOutlet var mapView : MKMapView!
    
    var locationManager = CLLocationManager()
    var pokemons : [Pokemon] = []
    var stopUpdate = 0

    //Compass Button
    @IBAction func compassLocationUpdate(_ sender: Any) {
        
        let region = MKCoordinateRegion(center: self.locationManager.location!.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
        
        self.mapView.setRegion(region, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.locationManager.delegate = self
        pokemons = showPokemons()
        
        //Location Authorization Status
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            self.mapView.delegate = self
            self.mapView.showsUserLocation = true
            self.locationManager.startUpdatingLocation()
            
            //Placing pokemon
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
                
                if let coordinates = self.locationManager.location?.coordinate{
                    
                    let randomPokemon = Int(arc4random_uniform(UInt32(self.pokemons.count)))
                    let pokemon = self.pokemons[randomPokemon]
                    
                    let annotation = CustomAnnotation(coordinate: coordinates, pokemon: pokemon)
                    annotation.coordinate.latitude += (Double(arc4random_uniform(1000)) - 500) / 200000.0
                     annotation.coordinate.longitude += (Double(arc4random_uniform(1000)) - 500) / 200000.0
                    
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
        else{
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)

        if annotation is MKUserLocation {
            annotationView.image = UIImage(named: "player")
        } else {
            let pokemon =  (annotation as! CustomAnnotation).pokemon
            annotationView.image = UIImage(named: pokemon.imageName!)

        }

        var frame = annotationView.frame
        frame.size.height = 50
        frame.size.width = 50
        annotationView.frame = frame
        return annotationView

    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        if view.annotation! is MKUserLocation{
            return
        }
        
        let region = MKCoordinateRegion(center: view.annotation!.coordinate, latitudinalMeters: 150, longitudinalMeters: 150)
        self.mapView.setRegion(region, animated: false)
        
        if let coordinates = self.locationManager.location?.coordinate{
            
            if self.mapView.visibleMapRect.contains(MKMapPoint(coordinates)){
                let battle = BattleViewController()
                
                let pokemon = (view.annotation as! CustomAnnotation).pokemon
                
                battle.pokemon = pokemon
                
                self.present(battle, animated: true, completion: nil)
            }
            else{
                print("tooo far to capture")
            }
        }
        
        
    }
    
   
    
    //Current Location 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if stopUpdate < 4{
            let location = locations.last! as CLLocation
            
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
            
            stopUpdate += 1
        }
        else{
            self.locationManager.stopUpdatingLocation()
        }
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
