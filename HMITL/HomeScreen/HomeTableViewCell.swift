//  Created by Hameed Miya on 4/20/20.
//  Copyright © 2020 HMITL. All rights reserved.

import UIKit
import Toaster

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    private var track: TrackMetaData!
    
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
