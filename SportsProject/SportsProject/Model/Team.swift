

import Foundation



struct TeamData : Decodable {
    var strTeam : String = ""
    var strTeamBadge : String = ""
    var strTeamJersey : String = ""
    var strTeamLogo : String = ""
    var strStadiumThumb : String = ""
    var strStadium : String = ""
    var strKeywords : String = ""
    var intStadiumCapacity : String = ""
    var strWebsite : String = ""
    var strFacebook :String = ""
    var strTwitter:String = ""
    var strInstagram :String = ""
   
}
struct Team :Decodable{
    
    var teams : [TeamData]
    
}
