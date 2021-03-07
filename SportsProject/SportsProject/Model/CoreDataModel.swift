

import UIKit
import CoreData



struct CoreDataModel  {
    
    //Reference to managed Object Context
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func deleteLeague(league: LeagueData) {
        
        
      	let tmp = fitchAllLeague()
        
        for item in tmp{
            if item.id == league.idLeague && item.name == league.strLeague{
                 self.context.delete(item)
                break
            }
        			}
       
        
        do{
            try self.context.save()
        }catch let error{
            print(error)
        }
        
       
    }
    
    func deletePureLeague(league: LeagueCoreData) {
        
        
        
        self.context.delete(league)
        
        do{
            try self.context.save()
        }catch let error{
            print(error)
        }
        
        
       
    }
    
    func fitchAllLeague()-> [LeagueCoreData] {
        //Fitch All Data from Core Data
        var allSavedLeagues = [LeagueCoreData]()
        do{
            
            allSavedLeagues =  try context.fetch(LeagueCoreData.fetchRequest())
            
           
            	
        }catch let error{
            print(error)
        }
        return allSavedLeagues
    }
    
    func addLeague(league: LeagueData) {
        let lea = LeagueCoreData(context: self.context)
        lea.id = league.idLeague
        lea.name = league.strLeague
        lea.bagde = league.strBadge
        
        
        do{
            
            try self.context.save()
            
        }catch let error{
            print(error)
        }
        
      
        
    }
    
}
