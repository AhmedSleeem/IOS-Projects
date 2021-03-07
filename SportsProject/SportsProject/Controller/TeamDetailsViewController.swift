
import UIKit

class TeamDetailsViewController: UIViewController {
    
    @IBOutlet weak var teamImageView: UIImageView!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    
    
    
    
    
    @IBOutlet weak var stadiumNameLabel: UILabel!
    
    
    @IBOutlet weak var teamTshirt: UIImageView!
    
    @IBOutlet weak var studiumName: UILabel!
    
    
    
    
    var teamData : TeamData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamNameLabel.text = teamData?.strTeam
        stadiumNameLabel.text = teamData?.strStadium ?? "Unknown"
        
        teamNameLabel.textColor = #colorLiteral(red: 0.2235294118, green: 0.003921568627, blue: 0.2431372549, alpha: 1)
        stadiumNameLabel.textColor = #colorLiteral(red: 0.2235294118, green: 0.003921568627, blue: 0.2431372549, alpha: 1)
        
        view.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.9333333333, blue: 0.5098039216, alpha: 1)
            
        studiumName.textColor = #colorLiteral(red: 0.2235294118, green: 0.003921568627, blue: 0.2431372549, alpha: 1)
        teamImageView.sd_setImage(with: URL(string:teamData!.strTeamBadge),placeholderImage:UIImage(named: "sdImage"))
        
        teamTshirt.sd_setImage(with: URL(string:teamData!.strTeamJersey),placeholderImage:UIImage(named: "sdImage"))
        
        print(teamData	)
        
        
        
        
    }
    
    
    
    @IBAction func onLinkPressed(_ sender: UIButton) {
        var link = teamData?.strFacebook
        switch sender.currentTitle! {
        case "f":
            link = teamData?.strFacebook
            
        case "t":
            link = teamData?.strTwitter
            
        case "y":
            link = teamData?.strWebsite
            
            
            
        default:
             link = teamData?.strInstagram
            
        }
        
        if link != nil && !(link?.starts(with: "www."))! && link!.count != 0 {
            link = "www.\(link!)"
            
        }
        if link != nil && !((link?.starts(with:"https://"))!) && link!.count != 0 {
            link = "https://\(link!)"
        }
        if link != nil && link!.count > 0{
            print(link); UIApplication.shared.open(URL(string:link!)!)
        }
        
    }
    
    
    
}
