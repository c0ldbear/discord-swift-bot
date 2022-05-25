//
//  xkcd.async.swift
//  
//
//  Created by teddy juhlin-henricson on 2022-05-24.
//

import Foundation

// Will use XkcdData struct from xkcd.swift

@available(macOS 12.0, *)
func xkcd() async -> String {
    let xkcdUrl = "https://xkcd.com/info.0.json"
    return await loadJson(fromURLString: xkcdUrl)
}

@available(macOS 12.0, *)
private func loadJson(fromURLString urlString: String) async -> String {
    
    if let url = URL(string: urlString) {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 200 {
                let botMsg = parseJson(data: data)
                return botMsg
            } else {
                return "No response from\(urlString)"
            }
        } catch {
            print("Fetch error? \(error)")
        }
    }
    
    return urlString
}

private func parseJson(data: Data) -> String {
    do {
        let decodedData: XkcdData = try JSONDecoder().decode(XkcdData.self, from: data)
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
