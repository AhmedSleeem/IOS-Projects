

import UIKit
import YoutubePlayer_in_WKWebView
import SDWebImage

class LeagueDetailsViewController: UIViewController {

//    @IBOutlet weak var myYoutubePlayer: WKYTPlayerView!
    @IBOutlet weak var TopCollectionView: UICollectionView!
    
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    
    @IBOutlet weak var middleCollectionView: UICollectionView!

    @IBOutlet weak var loveBtn: UIBarButtonItem!
    
    var teamArr : [TeamData] = []
    
    var coreDataManager = CoreDataModel()
    
    var eventArr = [EventData]()
    var latestEventArr = [LatestEventData]()
    
    var leagueData : LeagueData?
    
    var leagueId : String = ""
    
    var sportsManager : SportsManager = SportsManager ()
    
    var teamId  = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//            //Youtube Player
//        myYoutubePlayer.load(withVideoId: "uIzTE7hTfl8")
        
//        myYoutubePlayer.delegate = self
        
       let coreData =  coreDataManager.fitchAllLeague()
        
        let result =  checkIfLeagueInFavoriteList(arr: coreData)
        
        if result {
            loveBtn.tag = 15
            self.loveBtn.setBackgroundImage(#imageLiteral(resourceName: "marked"), for: .normal, style: .plain, barMetrics: .default)
        }else{
            loveBtn.tag = 13
             self.loveBtn.setBackgroundImage(#imageLiteral(resourceName: "bookmark"), for: .normal, style: .plain, barMetrics: .default)
        }
        
       
        
        //set Delegation
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        
        middleCollectionView.delegate = self
        middleCollectionView.dataSource = self
        
        sportsManager.teamUpdateProtocol = self
        sportsManager.eventUpdateProtocol = self
        
        TopCollectionView.dataSource = self
        TopCollectionView.delegate = self
        
        view.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.003921568627, blue: 0.2431372549, alpha: 1)
        
        self.title = leagueData?.strLeague
        
        
        

        
    }
    
    func checkIfLeagueInFavoriteList(arr : [LeagueCoreData]) -> Bool {
        var state = false
        
        for league in arr{
            if league.id == leagueId{
                state = true
                break
            }
        }
        
        return state
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return CGFloat(10)
      }
    
    override func viewWillAppear(_ animated: Bool) {
        print(leagueId)
        sportsManager.getAllTeamByLeagueId(id: leagueId)
        
        
        sportsManager.fitchLatestEvent(by: leagueId)
        
    }
//    override func viewDidAppear(_ animated: Bool) {
//        myYoutubePlayer.stopVideo()
//    }
    

  
    
    @IBAction func loveButtonClicked(_ sender: UIBarButtonItem) {
        //mean not in favorite list
        
        if sender.tag == 13{
            loveBtn.tag = 15
            self.loveBtn.setBackgroundImage(#imageLiteral(resourceName: "marked"), for: .normal, style: .plain, barMetrics: .default)
            
            //add to coreDataList
            
            coreDataManager.addLeague(league: leagueData!)
            
        }else{
            loveBtn.tag = 13
            self.loveBtn.setBackgroundImage(#imageLiteral(resourceName: "bookmark"), for: .normal, style: .plain, barMetrics: .default)
            
            //deleteFrom CoreData List
            if leagueData != nil {
              coreDataManager.deleteLeague(league: leagueData!)
            }
        }
                   
        
    }
    

}

//extension LeagueDetailsViewController :WKYTPlayerViewDelegate{
//    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
//       // playerView.playVideo()
//    }
//}


extension LeagueDetailsViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //when select team
        if collectionView == bottomCollectionView {

            print("going to team details")
            
            teamId = indexPath.row
            self.performSegue(withIdentifier: "toteamDetailsSegue", sender: self)
           
            
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let teamDetailsVC =  segue.destination
                   as! TeamDetailsViewController
                   
                   teamDetailsVC.teamData = teamArr[teamId]
                   
        
    }
    
    
}

extension LeagueDetailsViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bottomCollectionView
        {
            return teamArr.count
        }
        else if collectionView == middleCollectionView{
            
            if eventArr.count<=0{
                    let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
                    noDataLabel.text          = "You Didn't have Any event right now ,Yet 💔"
                    noDataLabel.textColor     =  #colorLiteral(red: 0.2235294118, green: 0.003921568627, blue: 0.2431372549, alpha: 1)
                    
                    noDataLabel.adjustsFontSizeToFitWidth = true

                    noDataLabel.numberOfLines=0
                    noDataLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
                    noDataLabel.textAlignment = .center
                    collectionView.backgroundView  = noDataLabel
                  
                }
                else{
                    collectionView.backgroundView  = nil

                }
            
            return eventArr.count
        }
        
        return latestEventArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.003921568627, blue: 0.2431372549, alpha: 1)
       
        
        if collectionView == bottomCollectionView {
            
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamFlagCell", for: indexPath) as! TeamFlagCell
        
                cell.teamFlagImage.sd_setImage(with: URL(string:teamArr[indexPath.row].strTeamBadge),placeholderImage:UIImage(named: "sdImage"))
            

//            cell.layer.shadowColor = UIColor.lightGray.cgColor
//            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//            cell.layer.shadowRadius = 5.0
//            cell.layer.shadowOpacity = 1.0
//            cell.layer.masksToBounds = false
//            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
           // cell.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

            cell.contentView.layer.masksToBounds = true
            cell.layer.cornerRadius = 10
            return cell
        }
        else if collectionView == middleCollectionView{
           
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "eventCell", for: indexPath) as! EventCollectionViewCell
            let tempIndecPath = eventArr[indexPath.row]
            cell.awayTeamName.text = tempIndecPath.strAwayTeam
            cell.homeTeamName.text = tempIndecPath.strHomeTeam
            cell.homeScore.text = tempIndecPath.intHomeScore
            cell.awayScore.text = tempIndecPath.intAwayScore
            cell.matchTime.text = tempIndecPath.dateEvent
            cell.matchTime.text?.append("    held in     \(tempIndecPath.strTime)")
            
            cell.awayScore.textColor = #colorLiteral(red: 0.2235294118, green: 0.003921568627, blue: 0.2431372549, alpha: 1)
            cell.homeScore.textColor = #colorLiteral(red: 0.2235294118, green: 0.003921568627, blue: 0.2431372549, alpha: 1)
            cell.matchTime.textColor = #colorLiteral(red: 0.2235294118, green: 0.003921568627, blue: 0.2431372549, alpha: 1)
            cell.awayTeamName.textColor = #colorLiteral(red: 0.2235294118, green: 0.003921568627, blue: 0.2431372549, alpha: 1)
            cell.homeTeamName.textColor = #colorLiteral(red: 0.2235294118, green: 0.003921568627, blue: 0.2431372549, alpha: 1)
            
            
            
            
            cell.layer.shadowColor = UIColor.lightGray.cgColor
                   cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                   cell.layer.shadowRadius = 5.0
                   cell.layer.shadowOpacity = 1.0
                   cell.layer.masksToBounds = false
                   cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
                   cell.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

                   cell.contentView.layer.masksToBounds = true
                   cell.layer.cornerRadius = 20
            
            var cnt = 0
            for team in teamArr {
                if team.strTeam == tempIndecPath.strAwayTeam{
                    cell.awayImageView.sd_setImage(with: URL(string: team.strTeamBadge),placeholderImage:UIImage(named: "sdImage"))
                    cnt+=1
                }
                if team.strTeam == tempIndecPath.strHomeTeam{
                    cell.homeImageView.sd_setImage(with: URL(string: team.strTeamBadge),placeholderImage:UIImage(named: "sdImage"))
                    cnt+=1
                }
                if cnt >= 2 { break }
            }
            
            return cell
        }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "laaaateEventCell", for: indexPath)as! LatestEventCollectionViewCell
        let late = latestEventArr[indexPath.row]
        cell.eventName.text = late.strEvent
        cell.eventDate.text = late.dateEvent
        cell.matchTime.text = late.strTime
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        cell.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        cell.contentView.layer.masksToBounds = true
        cell.layer.cornerRadius = 20
       
         
       
            return cell
        
   
    }
    
    
    
}

protocol TeamUpdateProtocol {
    func updateTeam(arr:[TeamData])
}


protocol EventUpdateProtocol {
    func updateEvents(events :[EventData])
    func updateLatestEvents(latestEvents:[LatestEventData])
}


extension LeagueDetailsViewController : TeamUpdateProtocol{
    func updateTeam(arr: [TeamData]) {
        self.teamArr = arr
        print("count \(teamArr.count)")
        
        self.bottomCollectionView.reloadData()
        
        
        sportsManager.fitchEvent(by: leagueId)
    }
    
    
}

extension LeagueDetailsViewController:EventUpdateProtocol{
    func updateLatestEvents(latestEvents: [LatestEventData]) {
        self.latestEventArr = latestEvents
        
        self.TopCollectionView.reloadData()
    }
    
    func updateEvents(events: [EventData]) {
        eventArr = events
        
        //reload Middle collectionView Data
        self.middleCollectionView.reloadData()
        
        
    }
    
    
}


