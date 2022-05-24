//
//  xkcd.swift
//  
//
//  Created by teddy juhlin-henricson on 2022-05-23.
//

import Foundation

struct XkcdData: Codable {
    let title: String
    let alt: String
    let img: String
}

func xkcd() -> String {
    let urlString = "https://xkcd.com/info.0.json"
    if let url = URL(string: urlString ) {
        let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) -> Void in
            if let error = error {
                print(error)
            }
            
            if let data = data {
                print(data)
                do {
                    let decodedData = try JSONDecoder().decode(XkcdData.self, from: data)
                    print(decodedData.title)
                    print(decodedData.alt)
                    print(decodedData.img)
                    /* var repsonseMessage = """
                        \(decodedData.title)
                        \(decodedData.img)
                        ||\(decodedData.alt)||
                        
                        """ // How do I get this message out??
                     */
                } catch {
                    print("Decoding error lol lol")
                }
            }
        }
        print(urlSession)
        urlSession.resume()
    }
    
    return "help"
    
}
