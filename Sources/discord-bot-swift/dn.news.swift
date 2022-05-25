//
//  dn.news.swift
//  
//
//  Created by teddy juhlin-henricson on 2022-05-25.
//

import Foundation
import SwiftSoup

@available(macOS 12.0, *)
func dn() async -> String {
    let dnUrl = "https://www.dn.se/"
    
    if let url = URL(string: dnUrl) {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let httpResponse = response as! HTTPURLResponse // Type casting
            if httpResponse.statusCode == 200 {
                let html = String(data: data, encoding: .utf8)!
                let doc: Document = try SwiftSoup.parse(html)
                let links = try doc.select("a")
                print("Number of links: \(links.count)")
                var count: Int = 0
                for link in links {
                    print(link)
                    count += 1
                    if count > Int(links.count / 10) {
                        break
                    }
                }
                // Add code to scrap website and find the content of interest
                
            } else {
                print("Some other http response code: \(httpResponse.statusCode)")
            }
        } catch {
            print("Fetch errrror?")
        }
    }
    
    return "Hej där!"
}
