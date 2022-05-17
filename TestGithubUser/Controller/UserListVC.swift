

import UIKit
import CoreData
class UserListVC: UIViewController, UISearchBarDelegate {
   
    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width-38, height: 20))

    @IBOutlet var tableView : UITableView!
    var fetchRecord = [UserDataToDisplay]()
    var tableRefreshControl:UIRefreshControl = UIRefreshControl()
    var dummyArrayToSearch = [UserDataToDisplay]()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if isInternetAvailableStatus{
            fetchRecord = dummyArrayToSearch.filter({($0.name?.lowercased().contains(searchBar.text!.lowercased()))!})
                if fetchRecord.count == 0{
                    fetchRecord = dummyArrayToSearch
                }
        }

        tableView.reloadData()
       
        return true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        tableView.delegate = self
        CheckInternet.shared.delegate = self
        CheckInternet.shared.isRechable()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchRecord.removeAll()
        dummyArrayToSearch.removeAll()
        CoreManager.shared.fetchData(entityName: "Users") { [self] managedObj in
            let lastId =  managedObj.map({$0.value(forKey: "id") as! Int})
            if lastId.count == 0{
                getData()
            }
            else{
                fetchData()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height{
            getData()
            let spinner = UIActivityIndicatorView(style: .medium)
                    spinner.startAnimating()
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

                    self.tableView.tableFooterView = spinner
                    self.tableView.tableFooterView?.isHidden = false
        }
    }
    func getData(isPagination:Bool = false){
        CoreManager.shared.fetchData(entityName: "Users") { [self] managedObj in
            let lastId =  managedObj.map({$0.value(forKey: "id") as! Int})

        APIManager.getUserListJSON_Model(userName:"",numSince: lastId.count, requestType: UsersListModel.self) { success, model in

                for i in model!{
                    CoreManager.shared.saveUserData(id: i.id!, name: i.login!, avtarURL: i.avatarURL!, avtar: nil, entityName: "Users") {  success in
                        fetchRecord.append(UserDataToDisplay(id: "\(i.id!)", name: i.login!, avtarURL: i.avatarURL!, isNoteAvailable: false))
                    }
                }
                if isInternetAvailableStatus{
                    dummyArrayToSearch = fetchRecord
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
    }
  
}
extension UserListVC:PROTOCOL_CHECK_INTERNET{
    func isInternetAvailable(status: Bool) {
        switch status {
        
            case true:
                print("AVAILABLE")
                if fetchRecord.count == 0{
                    getData()
                }
                isInternetAvailableStatus = true
            case false:
                print("NOT AVAILABLE")
                isInternetAvailableStatus = false
                self.showToast(message: "No Internet")

                
        }
    }
}
// Table Delegate
extension UserListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchRecord.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
       // cell.dataArray = fetchRecord[indexPath.row]
        cell.userAvtar.image = nil
        cell.userName.text = fetchRecord[indexPath.row].name
        cell.userAvtar.imageURL = URL.init(string: fetchRecord[indexPath.row].avtarURL!)
        cell.userAvtar.loadImageWithUrl(URL.init(string: fetchRecord[indexPath.row].avtarURL!)!)
        
        cell.imgViewNote.isHidden = true

        if let isNote = fetchRecord[indexPath.row].isNoteAvailable,isNote{
            cell.imgViewNote.isHidden = false

        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "UserDetailVC", sender:  fetchRecord[indexPath.row].name)
    }
    func fetchDataLastId() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! UserDetailVC
        dest.userName = sender as? String
    }
    // Fetch Data From User Entity
    func fetchData() {
        CoreManager.shared.fetchData(entityName: "Users") { [self] managedObj in

            for obj in managedObj {
                let id = obj.value(forKey: "id") as! Int
                let name = obj.value(forKey: "name") as! String
                let note = obj.value(forKey: "isNoteAvailable") as? Bool
                var imageData = obj.value(forKey: "avtar") as? Data
                let avtarURL = obj.value(forKey: "avtarURL") as? String

                if imageData == nil {
                    imageData = UIImage(named: "avatar")?.pngData()
                }
                
                fetchRecord.append(UserDataToDisplay(id: "\(id)", name: name, avtarURL: avtarURL!, isNoteAvailable: note))
            }
            if isInternetAvailableStatus{
                dummyArrayToSearch = fetchRecord
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
}

