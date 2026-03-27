//
//  HomepageDestinationModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/6/25.
//

import Foundation

struct HomepageDestination {
    let id: String
    let destinations: [DestinationItem]
}

struct DestinationItem {
    let image: String
    let title: String
}
