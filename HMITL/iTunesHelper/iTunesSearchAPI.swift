//  Created by Hameed Miya on 4/20/20.
//  Copyright © 2020 HMITL. All rights reserved.

import Foundation

class ApiController {
    
    public static var shared = ApiController()
    
    private let searchUrlStr1 = "https://itunes.ap"
    private let searchUrlStr2 = "ple.com/search?term=%@"
    
    /// The URL string
    private func searchUrl(searchText: String) -> URL? {
        let searchUrlStr = searchUrlStr1+searchUrlStr2
        let encodedText = searchText
            .replacingOccurrences(of: " ", with: "+")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!// else { return nil }
        let urlString = String(format:searchUrlStr, encodedText)
        
        return URL(string: urlString)
    }
    
    func search(term: String, completion: @escaping (Result<[TrackMetaData], Error>) -> Void) {
        guard let url = searchUrl(searchText: term) else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data else { return completion(.failure(error!)) }
            do {
                let searchResults = try JSONDecoder().decode(SearchResultsModel.self, from: data)
                guard let results = searchResults.results else { return }
                debugPrint(searchResults.resultCount)
                completion(.success(results))
            } catch {
                return completion(.failure(error))
            }
        }.resume()
    }
}
