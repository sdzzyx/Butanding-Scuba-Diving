//
//  HomepageEventsModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/8/25.
//

import Foundation

struct HomepageEvent {
    let id: String
    let events: [EventItem]
}

struct EventItem {
    let image: String
    let title: String
}
