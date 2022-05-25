//
//  xkcd.swift
//  
//
//  Created by teddy juhlin-henricson on 2022-05-23.
//

import Foundation

struct XkcdData: Codable {
    // Important
    let title: String
    let safe_title: String
    let alt: String
    let img: String
    // Extras
    let num: Int
    let day: String
    let month: String
    let year: String
}

func xkcd(completion: @escaping (String) -> Void) {
    let urlString = "https://xkcd.com/info.0.json"
    
    loadJson(fromURLString: urlString) { (result) in
        switch result {
        case .success(let data):
            let msg = parseJson(data: data)
            completion(msg)
        case .failure(let error):
            print("JSON ERROR: \(error)")
        }
    }
}

private func parseJson(data: Data) -> String {
    do {
        let decodedData = try JSONDecoder().decode(XkcdData.self, from: data)
        let repsonseMessage = """
            \(decodedData.title)
            <spoilers>||\(decodedData.alt)||</spoilers>
            \(decodedData.img)
            
            """
        return repsonseMessage
    } catch {
        print("Decoding JSON error: \(error)")
    }
    return "JSON Parse Error"
}

// This function is run "too fast" - how do we force it to wait for a success? Or something... I don't know what it's called but it jumps to the last return faster than expected.........
private func loadJson(fromURLString urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
    if let url = URL(string: urlString) { // handling an optional (?)
        let urlSession = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        urlSession.resume()
    }
}
