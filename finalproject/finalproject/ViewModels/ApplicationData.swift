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
            
            Event(image: "imagine", name: "Imagine Dragon Fest", price: "Free", Date: "02-3-2025", Location: "60158 Orn Oval, Hectormouth, KY 30851"),
            Event(image: "festival", name: "Festival", price: "$20.99", Date: "2-3-2026", Location: "239 Ayanna Wall, West Hilarioberg, TN 50761"),
            Event(image: "Carnival", name: "Carnival", price: "$18.99", Date: "10-10-2025", Location: "Suite 155 24958 Lindy Path, Nerytown, TX 41169"),
            Event(image: "6flags", name: "Six Flags", price: "$25.00", Date: "1-9-2025", Location: "43995 Cummings Tunnel, Ernserville, VT 21413-9683"),
            Event(image: "Breezy Bowl", name: "Breezy Bowl", price: "$30.55", Date: "12-9-2025", Location: "573 Brekke Estate, West Cleo, MO 14398-2026"),
        ]
    }
}
