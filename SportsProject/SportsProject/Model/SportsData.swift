

import Foundation

struct SportsData : Decodable{
    let idSport : String
    let strSport : String
    let strFormat : String
    let strSportThumb : String
    let strSportThumbGreen : String
    let strSportDescription : String
}

struct Sports : Decodable{
    let sports : [ SportsData ]
}
