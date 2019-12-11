//
//  PackLads.swift
//  Pack-Go
//
//  Created by Lorraine Chong on 2019-12-09.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import UIKit

class PackLads: NSObject, NSCoding {
    var pokemonName : String?
    var imageName : String?
    
    func initWithData( pokemonName:String,
                       imageName:String)
    {
        
        self.pokemonName = pokemonName
        self.imageName = imageName
    }
    
    // step 3c -> create these two methods to handle serialization of data between
    // phone and watch.
    required convenience init?(coder decoder: NSCoder) {
        
        guard let pokemonName = decoder.decodeObject(forKey: "pokemonName") as? String,
            let imageName = decoder.decodeObject(forKey: "imageName") as? String
            else { return nil }
        
        
        // note this will cause crash if its not in here exactly as is
        self.init()
        self.initWithData(
            pokemonName: pokemonName as String,
            imageName: imageName as String
        )
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.pokemonName, forKey: "pokemonName")
        coder.encode(self.imageName, forKey: "imageName")
    }
}

