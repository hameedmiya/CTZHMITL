//  Created by Hameed Miya on 4/19/20.
//  Copyright © 2020 HMITL. All rights reserved.

import Foundation

enum HTTPError: LocalizedError {
    case statusCode
}

class SearchResultsModel: Codable {
    let resultCount: Int
    let results: [TrackMetaData]?
}

class TrackMetaData: Codable, Hashable {
    let trackId: Int?
    let trackName: String?
    let trackViewUrl: String?
    let kind: String?
    let primaryGenreName: String?
    let artworkUrl100: String?
}

extension TrackMetaData {
    static func == (lhs: TrackMetaData, rhs: TrackMetaData) -> Bool {
        return lhs.trackId == rhs.trackId && lhs.trackName == rhs.trackName
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(trackId)
        hasher.combine(trackName)
    }
}
