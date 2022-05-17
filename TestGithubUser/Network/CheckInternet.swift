

import UIKit
import Network

protocol PROTOCOL_CHECK_INTERNET {
    func isInternetAvailable(status:Bool)
}
class CheckInternet: NSObject {
    static let shared = CheckInternet()
    var delegate : PROTOCOL_CHECK_INTERNET?
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
   
    // Observe Internet status
    func isRechable(){
        
        monitor.pathUpdateHandler = { [self] path in
            if path.status == .satisfied {
                delegate?.isInternetAvailable(status: true)
            } else {
                delegate?.isInternetAvailable(status: false)
            }
        }
        monitor.start(queue: queue)
    }
    
}
class APIManager{
   class func getUserListJSON_Model<T: Decodable>(userName:String,numSince : Int, requestType: T.Type, completion: @escaping (Bool, _ result: T?) -> Void) {
    let endpoint = userName.count>0 ? "/\(userName)" : "?since=\(numSince)"
    let url = URL(string: "https://api.github.com/users\(endpoint)")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with fetching List: \(error)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
            return
          }

          if let data = data,
             let filmSummary = try? JSONDecoder().decode(requestType , from: data) {
            
            
            
            completion(false, filmSummary)
          }
        })
        task.resume()
    }
}
