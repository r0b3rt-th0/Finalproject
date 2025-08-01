//
//  ApplicationData.swift
//  finalproject
//
//  Created by Robert Thomas on 7/24/25.
//

import Foundation
import Observation

@Observable class ApplicationData : @unchecked Sendable {
    //Proerties
     var userData: [Event] = []
     static let shared: ApplicationData = ApplicationData()

    private init(){  //Initialize your own data as if you are fetching from an API
        
        //Make as many Car objects you like within this array
        userData = [
            
            Event(image: "imagine", name: "Imagine Dragon Fest", price: 0.0, Date: "02-3-2025"),
            Event(image: "imagine", name: "world", price: 0.0, Date: "02-3-2025"),
            
        ]
    }
}
