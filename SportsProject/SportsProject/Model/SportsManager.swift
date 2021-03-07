

import Foundation
import Alamofire
import SwiftyJSON

struct SportsManager{
    let url :String = "https://www.thesportsdb.com/api/v1/json/1/"
    var updateProtocol : UpdateDatable?
    
    var updateLeague : UpdateLeagueProtocol?
    
    var teamUpdateProtocol : TeamUpdateProtocol?
    
    var eventUpdateProtocol : EventUpdateProtocol?
    	
    func fitchAllSports(){
        print("fitchAllSports()")
        let urlString : String = "\(url)all_sports.php"

        var ret :[SportsData] = []
        AF.request(urlString,
                   method:.get,
                   parameters: nil,
                   encoding:  URLEncoding.default
            ,headers: nil,interceptor: nil).response{ (responseData) in
                if responseData.data != nil{
                ret = self.parseSportsJsonData(sportsData: responseData.data!)
                ret.shuffle()
                print(ret[0].strSportThumb)
                self.updateProtocol?.updateData(with: ret)
                }
        }
        
        
        
        
    }
    
    func fitchLeagueByName(leagueId:String) {
        
        
              print("fitchLeagueByName()")
              let urlString : String = "\(url)all_leagues.php"
        //print(urlString)
           AF.request(urlString,
                             method:.get,
                             parameters: nil,
                             encoding:  URLEncoding.default
            ,headers: nil,interceptor: nil).response{ (responseData) in
                self.parseLeaguesJsonData(leaguesData: responseData.data!, leagueType: leagueId)
        }
        
    }
    
    func parseSportsJsonData(sportsData:Data)->[SportsData]{
        let jsonDecoder = JSONDecoder()
        var answer: [SportsData] = Array<SportsData>()
        do{
            
            let result   =  try jsonDecoder.decode(Sports.self, from: sportsData)
           
            
            return result.sports
            
        }catch let error{
            
            print("error in decoding sports json ====> \(error)")
            
        }
        return answer
    }
    
    func parseLeaguesJsonData(leaguesData:Data , leagueType:String){
        let jsonDecoder = JSONDecoder()
        var IdArr : [String] = []
        do{
            let result   =  try jsonDecoder.decode(TempLeague.self, from: leaguesData)
            
           // print(result.leagues.count)
            for item in result.leagues{
               // print("leagueid \(item.idLeague)")
                if item.strSport == leagueType{
                    IdArr.append(item.idLeague)
                }
            }
            parseTempData(idArr: IdArr)
            
 
        }catch let error{
            
            print("error in decoding leagues json ====> \(error)")
            
        }
    }
    func parseTempData(idArr: [String]) {
            
        let urlString = "\(url)lookupleague.php?id"
        var globalArr :[LeagueData] = []
        print("idArray size -----> \(idArr.count)")
        
        for id in idArr{
            
            
            AF.request("\(urlString)=\(id)",
                             method:.get,
                             parameters: nil,
                             encoding:  URLEncoding.default
            ,headers: nil,interceptor: nil).response{ (responseData) in
                let jsonDecoder = JSONDecoder()
                do{
                    
                    let result   =  try jsonDecoder.decode(League.self, from: responseData.data!)

                    
                    
                    for item in result.leagues{
                        
                        if item.strBadge != nil &&
                        item.strBadge?.count != 0 && item.strLeague
                        != nil {
                            //print("added \(item)")
                                globalArr.append(item)
                        }
                    }
                    self.updateLeague?.updateLeague(arr: globalArr)
                    
                }catch let error{
                    
                    print("ERROR: \(error)")
                    
                }
            }
        }
    }
    
    func getAllTeamByLeagueId(id :String)  {
        
        print("getAllTeamByLeagueId()")
        let urlString = "\(url)lookup_all_teams.php?id=\(id)"
        print(urlString)
        
           AF.request(urlString).validate().responseJSON {response in
                 
                   switch response.result{
             case .success:
                self.parseTeamData(teamData: response.data!)
            
                   case .failure(_):
                    print(response.error)
            }
            
        }
        
        
    }
    func parseTeamData(teamData:Data)  {
        
        print("parseTeamData()")
        
        var teamArr : [TeamData] = []
        
            let result = try? JSON(data: teamData)
                        
            let event = result!["teams"]
        
                for i in event.arrayValue{
                    
                    var team = TeamData()
                        
                    team.strTeam  = i["strTeam"].stringValue
                    team.strTeamBadge  = i["strTeamBadge"].stringValue
                    team.strTeamJersey  = i["strTeamJersey"].stringValue
                    team.strTeamLogo  = i["strTeamLogo"].stringValue
                    team.strStadiumThumb  = i["strStadiumThumb"].stringValue
                    team.strStadium  = i["strStadium"].stringValue
                    team.strKeywords  = i["strKeywords"].stringValue
                    team.intStadiumCapacity  = i["intStadiumCapacity"].stringValue
                    team.strWebsite  = i["strWebsite"].stringValue
                    team.strFacebook  = i["strFacebook"].stringValue
                    team.strInstagram  = i["strInstagram"].stringValue
                    team.strTwitter  = i["strTwitter"].stringValue
                            
                    teamArr.append(team)
                }
            
            self.teamUpdateProtocol?.updateTeam(arr: teamArr)
            
            
        }
    
    func fitchEvent(by id:String)  {
        print("fitchEvent()")
        
        let urlString = "\(url)eventsseason.php?id=\(id)&s=2020-2021"
        print(urlString)
        

        AF.request(urlString).validate().responseJSON {response in
                       
                switch response.result{
                   case .success:
                    self.parseEvent(data: response.data!)
                  
                         case .failure(_):
                            print(response.error as Any)
                }
        }
        
    }
    
    func parseEvent(data:Data)  {
        
        let jsonDecoder = JSONDecoder()
        var eventArr = [EventData]()
        
        do{
            let result = try jsonDecoder.decode(Event.self, from: data)
            
            eventArr = result.events
            
            self.eventUpdateProtocol?.updateEvents(events: eventArr)
            
            
        }
        catch let error{
            print(error)
        }
        
    }
    
    
    
    func fitchLatestEvent(by id:String)  {
           print("fitchEvent()")
           
           let urlString = "\(url)eventspastleague.php?id=\(id)"
           print(urlString)
           

           AF.request(urlString).validate().responseJSON {response in
                          
                   switch response.result{
                      case .success:
                       self.parseLatestEvent(data: response.data!)
                     
                            case .failure(_):
                               print(response.error as Any)
                   }
           }
           
       }
       
       func parseLatestEvent(data:Data)  {
           
           let jsonDecoder = JSONDecoder()
           var eventArr = [LatestEventData]()
           
           do{
               let result = try jsonDecoder.decode(LatestEvent.self, from: data)
               
               eventArr = result.events
               
               self.eventUpdateProtocol?.updateLatestEvents(latestEvents: eventArr)
               
               
           }
           catch let error{
               print(error)
           }
           
       }
       
        
    
}
