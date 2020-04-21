//  Created by Hameed Miya on 4/20/20.
//  Copyright © 2020 HMITL. All rights reserved.

import UIKit
import Toaster

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    private var track: TrackMetaData!
    
    func setButtonTitle() {
        if AppSession.favoriteTracks.contains(track) {
            self.addButton.setTitle("♥️",for: .normal)
        } else {
            self.addButton.setTitle("♡",for: .normal)
        }
    }
    
    private func getImage(_ urlString: String?) {
        guard let urlString = urlString else { return }
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: urlString),
                let imageData = try? Data(contentsOf: imageUrl) else {
                    return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.iconImageView?.image = UIImage(data: imageData)
            }
        }
    }
    
    func configure(app: TrackMetaData) {
        self.track = app
        self.nameLabel.text = app.trackName
        self.genreLabel.text = app.primaryGenreName
        self.getImage(app.artworkUrl100)
        
        setButtonTitle()
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        guard let app = self.track else { return }
        
        ToastCenter.default.cancelAll()
        if AppSession.favoriteTracks.contains(app) {
            AppSession.favoriteTracks.remove(app)
            Toast(text: "Removed from Favorites").show()
        } else {
            AppSession.favoriteTracks.insert(app)
            Toast(text: "Added to Favorites").show()
        }
        setButtonTitle()
    }
    
    @IBAction func viewiTunesAction(_ sender: UIButton) {
        guard let app = self.track,
            let urlString = app.trackViewUrl else { return }
        
        guard let url = URL(string: urlString) else { return }
        
        //let ret = UIApplication.shared.canOpenURL(url)
        UIApplication.shared.open(url, options: [:]) { result in
            ToastCenter.default.cancelAll()
            Toast(text: result ? "Opened" : "Couldn't Open").show()
        }
    }
}
