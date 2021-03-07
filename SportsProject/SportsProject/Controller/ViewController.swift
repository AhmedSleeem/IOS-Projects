

import UIKit
import SDWebImage


class ViewController: UIViewController {
    
    
    let reachability  = try! Reachability()

    
    @IBOutlet var collectionView :UICollectionView!
    
    var sportsManager : SportsManager?
    var sportsArr :[SportsData] = []
    
    /// <#Description#>
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
               layout.sectionInset = UIEdgeInsets(top: 5   , left: 2, bottom: 3, right: 2)
               
               
               
                   self.collectionView.collectionViewLayout = layout
               
               
               
                   self.collectionView.delegate = self
                   self.collectionView.dataSource = self
               
                   self.collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                   self.view.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.003921568627, blue: 0.2431372549, alpha: 1)
             
                   self.collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: "MyCollectionViewCell")
                   self.sportsManager = SportsManager()
                   self.sportsManager?.updateProtocol = self
        
       reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.showAlert()
            
        }
        
        reachability.whenReachable = {_ in
    
            self.sportsManager?.fitchAllSports()
        }
        
//        sportsManager.fitchLeagueByName(leagueName:"Soccer")
    }
    override func viewWillAppear(_ animated: Bool) {
        do{
            try self.reachability.startNotifier()
        }catch let error{
            print(error)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.reachability.stopNotifier()
    }
    
    func showAlert(){
           
           let alert = UIAlertController(title: "no Internet", message: "This App Requires wifi/internet connection!", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: NSLocalizedString("close App", comment: "Default action"), style: .default, handler: {_ in
            NSLog("The \"OK\" alert occured.");
                exit(0)
           }))
           self.present(alert, animated: true, completion: nil)
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }


}

extension ViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let leagueVC = storyboard?.instantiateViewController(identifier: "LeagueVC") as! LeagueViewController
        leagueVC.leagueId = sportsArr[indexPath.row].strSport
        
        self.reachability.stopNotifier()
        
        self.navigationController?.pushViewController(leagueVC, animated: true)
    }
}

extension ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        
       
        cell.imageView.sd_setImage(with: URL(string: sportsArr[indexPath.row].strSportThumb), placeholderImage: UIImage(named: "sdImage"))
        
        
        cell.textView.text = sportsArr[indexPath.row].strSport
        cell.textView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        	
        
        cell.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.003921568627, blue: 0.2431372549, alpha: 1)
        cell.layer.cornerRadius = 15.0
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sportsArr.count<=0{
                   let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
                   noDataLabel.text          = "oops.... please check your internet connection 💔"
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
        return self.sportsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }

   
    
}

extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.size.height)
        let width = (view.frame.size.width-20)/2
        
        
        return CGSize(width: width, height: width)
    }
}

protocol  UpdateDatable {
    func updateData(with :[SportsData])
}

extension ViewController : UpdateDatable{
    func updateData(with: [SportsData]) {
        self.sportsArr = with
        self.collectionView.reloadData()
    }
    
    
}

