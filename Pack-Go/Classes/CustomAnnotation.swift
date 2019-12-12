//
//  CustomAnnotation.swift
//  Pack-Go
//
//  Created by Xcode User on 2019-10-26.
//  Copyright © 2019 Xcode User. All rights reserved.
//
// Done By Riya Shah

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    
    init(coordinate: CLLocationCoordinate2D, pokemon: Pokemon) {
        
        self.coordinate = coordinate
        self.pokemon = pokemon
    }

}
