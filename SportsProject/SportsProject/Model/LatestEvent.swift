


import Foundation

struct LatestEventData :Decodable {
    
    let strEvent : String
    let strTime : String
    let dateEvent : String
    
}

struct LatestEvent : Decodable{
    
    let events :[LatestEventData]
}
