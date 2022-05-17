
import UIKit

class UserDetailVC: UIViewController {
    var userName : String?
    var userData : UserData?
    
    @IBOutlet weak var imgViewAvtar: ImageLoader!
    
    @IBOutlet weak var lblFollower: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblBlog: UILabel!
    @IBOutlet weak var textViewNote: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view.
    }
    // Save Note To Local
    @IBAction func onClickSaveNote(){
        CoreManager.shared.updateDataByName(entityName: "Users", noteText: "",searchText: userName!, note: true, lastName: "") { succes in
            self.showToast(message: "Note Saved")
        }
        CoreManager.shared.updateDataByName(entityName: "UserProfile", noteText: textViewNote.text,searchText: userName!, note: true, lastName: "") { succes in

        }
    }

    func getData(){
      
        
        CoreManager.shared.searchRecord(entityName: "UserProfile", searchText: userName!) { [self] success, managedObj in
            let lastId =  managedObj.map({$0!.value(forKey: "id") as! Int})
            let note =  managedObj.map({$0!.value(forKey: "note") as? String})
            let names =  managedObj.map({$0!.value(forKey: "name") as? String})
           
            
            if lastId.count == 0 || !names.contains(userName)
            {
                getDateFromServer(cnt: lastId.count)

            }
            else{
                
                for obj in managedObj{
                    lblFollower.text = "followers: \(obj!.value(forKey: "follower") ?? "")"
                    lblFollowing.text = "following: \(obj!.value(forKey: "following") ?? "")"
                    lblCompany.text = "Company: \(obj!.value(forKey: "company") ?? "")"
                    lblName.text = "name: \(obj!.value(forKey: "name") ?? "")"
                    lblBlog.text = "blog: \(obj!.value(forKey: "blog") ?? "")"
                    imgViewAvtar.loadImageWithUrl(URL.init(string: (obj!.value(forKey: "avtarURL") ?? "")! as! String)!)
                    textViewNote.text = obj!.value(forKey: "note") as? String

                }
            }
        }
    }
    func getDateFromServer(cnt:Int){
        APIManager.getUserListJSON_Model(userName:userName!,numSince: cnt, requestType: UserData.self) { [self] success, model in
            
            userData = model
            DispatchQueue.main.async {
                self.title = model?.login
                lblFollower.text = "followers: \(model!.followers!)"
                lblFollowing.text = "following: \(model!.following!)"
                lblCompany.text = "Company: \(model!.company ?? "")"
                lblName.text = "name: \(model!.login ?? "")"
                lblBlog.text = "blog: \(model!.blog ?? "")"
                imgViewAvtar.loadImageWithUrl(URL.init(string: (model?.avatarURL!)!)!)

            }
            CoreManager.shared.saveUserData(isSaveDetail:true,company: model?.company,follower: "\(model?.followers ?? 0)",following: "\(model?.following ?? 0)",blog: model?.blog,id: model!.id!, name: model!.login!, avtarURL: model!.avatarURL!, avtar: nil, entityName: "UserProfile") {  success in
            }
            
        }
    }

}
