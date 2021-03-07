

import UIKit
import SDWebImage

class LeagueViewController: UIViewController {
    var leagueArr:[LeagueData] = []
    var leagueId : String = ""
    
    @IBOutlet weak var mytableView: UITableView!
    
    var sendedLeagueId = 0
    
    var sportManager : SportsManager = SportsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.2588235294, blue: 0.3215686275, alpha: 1)
       
        
        
        mytableView.delegate = self
        mytableView.dataSource = self
        
        sportManager.updateLeague = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sportManager.fitchLeagueByName(leagueId: leagueId)
    }
    
    
    
    
}



protocol UpdateLeagueProtocol {
    func updateLeague(arr: [LeagueData])
}

extension LeagueViewController : UpdateLeagueProtocol{
    func updateLeague(arr: [LeagueData]) {
        self.leagueArr = arr
        
        
        self.mytableView.reloadData()
        
    }
    
    
}

extension LeagueViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if leagueArr.count<=0{
            mytableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                   let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                   noDataLabel.text          = "You Didn't have Any League ,Yet 💔"
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
        mytableView.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.2588235294, blue: 0.3215686275, alpha: 1)
        return self.leagueArr.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        sendedLeagueId = indexPath.row
        
        let destinationVC = self.storyboard?.instantiateViewController(identifier: "LeagueDetailsViewController")as! LeagueDetailsViewController
        
        destinationVC.leagueId = leagueArr[sendedLeagueId].idLeague!
        
        
        destinationVC.leagueData = leagueArr[sendedLeagueId]
        
        self.present(destinationVC, animated: true, completion: nil)
        
    }
   
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let league = self.leagueArr[indexPath.row].strYoutube
        if league != nil  {
            
            let url = URL(string: "https://\(league!)");
            print("url \(url)")
            
            if let uu = url {
                UIApplication.shared.open(uu)
            }
            
        }
        
        
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueTableViewCell") as! LeagueTableViewCell
        // print(leagueArr[indexPath.row].strBadge!)
        //        print(cell.leagueNameLabel == nil)
        //        print("photo \(cell.photoImageView == nil)")
        
        cell.accessoryType = UITableViewCell.AccessoryType.detailButton
        
        
        cell.photoImageView.sd_setImage(with: URL(string: leagueArr[indexPath.row].strBadge! ), placeholderImage: UIImage(named: "sdImage"))
        
       
        
        cell.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.003921568627, blue: 0.2431372549, alpha: 1)
        cell.leagueNameLabel.text = leagueArr[indexPath.row].strLeague!
        
        cell.leagueNameLabel.textColor = #colorLiteral(red: 0.9529411765, green: 0.8941176471, blue: 0.8745098039, alpha: 1)
        cell.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        cell.layer.borderWidth = 1
               cell.layer.cornerRadius = 8
               cell.clipsToBounds = true
        
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109.0
    }
    
    
    
    
    
}
