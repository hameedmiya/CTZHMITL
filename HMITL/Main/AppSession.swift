//  Created by Hameed Miya on 4/20/20.
//  Copyright © 2020 HMITL. All rights reserved.

import Foundation

public struct AppSession {
    
    let allTrackTypes = ["album"]
    static var favoriteTracks = Set<TrackMetaData>()
    
    static func makeTracksHash(_ tracks: [TrackMetaData]) -> [String: [TrackMetaData]] {
        var trackDictionary = [String: [TrackMetaData]]()
        let allTrackTypes = Set(tracks.compactMap { $0.kind })
        for type in allTrackTypes {
            trackDictionary[type] = tracks.filter {
                return $0.kind == type
            }
        }
        return trackDictionary
    }
}
