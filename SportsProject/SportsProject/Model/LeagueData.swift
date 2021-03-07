

import Foundation

struct LeagueData : Decodable{
    
    var idLeague : String?
    var strLeague : String?
    var strBadge : String?
    var strYoutube : String?
    
}

struct League : Decodable {
    let leagues : [ LeagueData ]
}

struct TempLeagueData :Decodable {
    let idLeague :String
    let strSport : String
}

struct TempLeague : Decodable{
    let leagues : [TempLeagueData]
}
