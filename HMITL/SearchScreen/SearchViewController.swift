//  Created by Hameed Miya on 4/20/20.
//  Copyright © 2020 HMITL. All rights reserved.

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var trackDictionary = [String: [TrackMetaData]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        searchBar.becomeFirstResponder()
    }
}

extension SearchViewController:  UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchString = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), searchString.count >= 3 else { return }
        
        ApiController.shared.search(term: searchString) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let tracks):
                self.trackDictionary = AppSession.makeTracksHash(tracks)
                debugPrint(self.trackDictionary.keys)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
}
// MARK: - TableView Delegates & DataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return trackDictionary.keys.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !trackDictionary.keys.isEmpty else { return nil }
        return trackDictionary.keys.sorted { $0 < $1 } [section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !trackDictionary.keys.isEmpty else { return 0 }
        let sectionKey = trackDictionary.keys.sorted { $0 < $1 } [section]
        guard let values = trackDictionary[sectionKey] else { return 0 }
        return values.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let key = trackDictionary.keys.sorted { $0 < $1 }[indexPath.section]
        guard let sectionTracks = trackDictionary[key] else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell
        
        let track = sectionTracks[indexPath.row]
        cell?.configure(app: track)
        return cell ?? UITableViewCell()
    }
}
