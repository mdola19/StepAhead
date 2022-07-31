//
//  BikeData.swift
//  StepAhead
//
//  Created by Ishnu Suresh on 2022-07-30.
//

import Foundation


class BikeData{
    
    var image:String!
    var bikeBrand:String!
    var bikePrice:String!
    var location:String!
    var description:String!
    
    public init(image: String, bikeBrand: String, bikePrice:String, location:String, description:String){
        self.image = image
        self.bikeBrand = bikeBrand
        self.bikePrice = bikePrice
        self.location = location
        self.description = description
    }
}

