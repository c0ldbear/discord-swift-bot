//
//  xkcd.async.swift
//  
//
//  Created by teddy juhlin-henricson on 2022-05-24.
//

import Foundation
import Sword

// Will use XkcdData struct from xkcd.swift

struct XkcdData: Codable {
    // Important
    var title: String = ""
    var alt: String = ""
    var img: String = ""
    // Extras
    var safe_title: String = ""
    var num: Int = 0
    var day: String = ""
    var month: String = ""
    var year: String = ""
}

final class XKCD {
    
    @available(macOS 12.0, *)
    func msg() async -> Embed {
        let xkcdUrl = "https://xkcd.com/info.0.json"
        return await self.loadJson(fromURLString: xkcdUrl)
    }
    
    func msg(_ completion: @escaping (String) -> Void) {
        let urlString = "https://xkcd.com/info.0.json"
        
        self.loadJson(fromURLString: urlString) { (result) in
            switch result {
            case .success(let data):
                let msg = self.parseJson(json: data)
                completion(msg)
            case .failure(let error):
                print("JSON ERROR: \(error)")
            }
        }
    }
    
    @available(macOS 12.0, *)
    private func loadJson(fromURLString urlString: String) async -> String {
        
        if let url = URL(string: urlString) {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    let botMsg = self.createBotMessage(xkcdJson: self.parseJson(data: data))
                    return botMsg
                } else {
                    return "No response from \(urlString)"
                }
            } catch {
                print("Fetch error? \(error)")
            }
        }
        
        return urlString
    }
    
    @available(macOS 12.0, *)
    private func loadJson(fromURLString urlString: String) async -> Embed {
        if let url = URL(string: urlString) {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    let botMsg = self.createBotEmbedMessage(xkcdJson: self.parseJson(data: data))
                    return botMsg
                } else {
                    return Embed() //"No response from \(urlString)"
                }
            } catch {
                print("Fetch error? \(error)")
                
            }
        }
        return Embed()
    }
    
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
    
    private func parseJson(data: Data) -> XkcdData {
        var decodedJsonData = XkcdData()
        do {
            decodedJsonData = try JSONDecoder().decode(XkcdData.self, from: data)
            return decodedJsonData
        } catch {
            print("Decoding JSON error: \(error)")
        }
        return decodedJsonData
    }
    
    private func parseJson(json: Data) -> String {
        do {
            let decodedData = try JSONDecoder().decode(XkcdData.self, from: json)
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
    
    private func createBotMessage(xkcdJson decodedJson: XkcdData) -> String {
        if !decodedJson.img.isEmpty {
            let repsonseMessage = """
            \(decodedJson.title)
            ||\(decodedJson.alt)||
            \(decodedJson.img)
            
            """
            return repsonseMessage
        }
        return "Sorry, no comic available :("
    }
    
    private func createBotEmbedMessage(xkcdJson decodedJson: XkcdData) -> Embed {
        let title = decodedJson.title
        let imageUrl = decodedJson.img
        let description = decodedJson.alt
        let testImg: Embed.Image = Embed.Image(height: 0, proxyUrl: "", url: imageUrl, width: 0)
        var testEm: Embed = Embed()
        testEm.image = testImg
        testEm.title = title + " (xkcd.com)"
        testEm.url = "https://www.xkcd.com/\(decodedJson.num)"
        testEm.description = "<spoiler>\n||" + description + "||\n</spoiler>"
        return testEm
    }

}
