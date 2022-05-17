

import UIKit

struct UserDataToDisplay{
    let id: String?
    let name: String?
    let avtarURL: String?
    let isNoteAvailable: Bool?

    
}
struct UserDetail{
    let id: String?
    let name: String?
    let avtarURL: String?
    let note: String?

    
}
// MARK: - UserData
struct UserData: Codable {
    let login: String?
    let id: Int?
    let nodeID: String?
    let avatarURL: String?
    let gravatarID: String?
    let url, htmlURL, followersURL: String?
    let followingURL, gistsURL, starredURL: String?
    let subscriptionsURL, organizationsURL, reposURL: String?
    let eventsURL: String?
    let receivedEventsURL: String?
    let type,company,blog: String?
    let siteAdmin: Bool?
    let  followers, following: Int?
    enum CodingKeys: String, CodingKey {
        case login, id,followers, following,company,blog
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
}



typealias UsersListModel = [UserData]
