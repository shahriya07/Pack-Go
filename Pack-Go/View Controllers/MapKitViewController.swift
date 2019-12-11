//
//  MapKitViewController.swift
//  Pack-Go
//
//  Created by Xcode User on 2019-10-25.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class MapKitViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    @IBOutlet var mapView : MKMapView!
    
    var audioPlayer = AVAudioPlayer()
    
    var locationManager = CLLocationManager()
    var pokemons : [Pokemon] = []
    var stopUpdate = 0

    //Compass Button
    @IBAction func compassLocationUpdate(_ sender: Any) {
        
        if let coordinates = self.locationManager.location?.coordinate{
        
            let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 400, longitudinalMeters: 400)
            self.mapView.setRegion(region, animated: true)
        }
        
    }
    
    @IBAction func logout(sender: Any){
        UserDefaults.standard.set("", forKey: "loggedUser")
        performSegue(withIdentifier: "unwindSegueToLoginViewController", sender: nil)
        audioPlayer.stop()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playSound(file: "map", ext: "mp3")

        // Do any additional setup after loading the view.
        self.locationManager.delegate = self
        pokemons = showPokemons()
        
        //Location Authorization Status
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            setUpMap()
        }
        else{
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func playSound(file:String, ext:String) -> Void {
        do {
            let url = URL.init(fileURLWithPath: Bundle.main.path(forResource: file, ofType: ext)!)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch let error {
            NSLog(error.localizedDescription)
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
    
    func setUpMap(){
        
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
                self.mapView.removeAnnotation(view.annotation!)
                self.present(battle, animated: true, completion: nil)
            }
            else{
                let alertController = UIAlertController(title: "Too Far!!!", message: "Pokemon is too far!!!", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            setUpMap()
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
