//  Created by Hameed Miya on 4/20/20.
//  Copyright © 2020 HMITL. All rights reserved.
import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var favorites = [String: [TrackMetaData]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        favorites = AppSession.makeTracksHash(Array(AppSession.favoriteTracks))
    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        favorites = AppSession.makeTracksHash(Array(AppSession.favoriteTracks))
        tableView.reloadData()
    }
}

// MARK: - TableView Delegates & DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return favorites.keys.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !favorites.keys.isEmpty else { return nil }
        return favorites.keys.sorted { $0 < $1 } [section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !favorites.keys.isEmpty else { return 0 }
        let sectionKey = favorites.keys.sorted { $0 < $1 } [section]
        guard let values = favorites[sectionKey] else { return 0 }
        return values.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let key = favorites.keys.sorted { $0 < $1 }[indexPath.section]
        guard let sectionTracks = favorites[key] else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell
        
        let track = sectionTracks[indexPath.row]
        cell?.configure(app: track)
        return cell ?? UITableViewCell()
    }
}
