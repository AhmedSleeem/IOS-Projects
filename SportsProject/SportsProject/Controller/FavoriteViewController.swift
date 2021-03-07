

import UIKit
import  CoreData

class FavoriteViewController: UIViewController {
    
  let coreDataManager = CoreDataModel()
    
    let reachability =  try! Reachability()
    
    var favArr = [LeagueCoreData]()
    
    var sendedLeagueId = 0
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Favorite";
        
        favoriteTableView.backgroundColor = #colorLiteral(red: 0, green: 0.9294911623, blue: 0.5812290311, alpha: 1)
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0.9294911623, blue: 0.5812290311, alpha: 1)
        
        favArr = coreDataManager.fitchAllLeague()
        DispatchQueue.main.async {
                   self.favoriteTableView.reloadData()
               }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        favArr = coreDataManager.fitchAllLeague()
        
        DispatchQueue.main.async {
            self.favoriteTableView.reloadData()
        }
    }
    
    
    
    
    
    
    
    
}

extension FavoriteViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.showAlert()
            
        }
        do{
           try self.reachability.startNotifier()
        }catch let error{
            print(error)
        }
        
        
            self.sendedLeagueId = indexPath.row
               
               var destinationVC = self.storyboard?.instantiateViewController(identifier: "LeagueDetailsViewController")as! LeagueDetailsViewController
               
            destinationVC.leagueId = self.favArr[self.sendedLeagueId].id!
        
        
               
               
            destinationVC.leagueData?.idLeague = self.favArr[self.sendedLeagueId].id
        
            destinationVC.leagueData?.strLeague = self.favArr[self.sendedLeagueId].name
        
            destinationVC.leagueData?.strBadge = self.favArr[self.sendedLeagueId].bagde
        
        
               self.present(destinationVC, animated: true, completion: nil)
        
    }
    
    func showAlert(){
              
              let alert = UIAlertController(title: "no Internet", message: "internet connection is required to continue", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: NSLocalizedString("close", comment: "Default action"), style: .default, handler: {_ in
               NSLog("The \"OK\" alert occured.");
                   
              }))
              self.present(alert, animated: true, completion: nil)
          }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "delete"){(action,view,completionHandler) in
            
            
            let leagueItem = self.favArr[indexPath.row]
           // self.deleteLeague(league: leagueItem)
            self.coreDataManager.deletePureLeague(league: leagueItem)
            
            self.favArr.remove(at: indexPath.row)
            
            
            
            DispatchQueue.main.async {
                self.favoriteTableView.reloadData()
            }
        }
        
        
        return UISwipeActionsConfiguration(actions:[action])
    }
    
    
}
extension FavoriteViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if favArr.count<=0{
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "You Didn't Add Any League To Favorite,Yet 💔"
            noDataLabel.textColor     =  #colorLiteral(red: 0.2235294118, green: 0.003921568627, blue: 0.2431372549, alpha: 1)
            
            noDataLabel.adjustsFontSizeToFitWidth = true

            noDataLabel.numberOfLines=0
            noDataLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        else{
            tableView.backgroundView  = nil

        }
        return self.favArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableCell") as! FavoriteTableCell
        
        let leagueItem = favArr[indexPath.row]
        
        cell.favoriteImage.sd_setImage(with: URL(string:leagueItem.bagde!),placeholderImage:UIImage(named: "sdImage"))
        
        cell.favoriteLeagueName.text = leagueItem.name
        
        cell.favoriteLeagueName.textColor = #colorLiteral(red: 0.2235294118, green: 0.003921568627, blue: 0.2431372549, alpha: 1)
        
        cell.backgroundColor = #colorLiteral(red: 0, green: 0.9294911623, blue: 0.5812290311, alpha: 1)
        
        
        return cell
    }
    
    
    
    
}



