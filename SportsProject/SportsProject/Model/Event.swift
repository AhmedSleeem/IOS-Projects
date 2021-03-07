

import Foundation

struct EventData :Decodable{
    
    let strHomeTeam : String
    let strAwayTeam : String
    let intHomeScore : String
    let intAwayScore : String
    let dateEvent : String
    let strVideo : String
    let strTime : String
}


struct Event : Decodable {
    let events : [EventData]
}
