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
    let dnBaseUrl = "https://www.dn.se"
    let dnNyhetsDygnetUrl = dnBaseUrl + "/nyhetsdygnet/"
    var dnNewsLinksMsg: String = "Dagens senaste nyheter\n\n"
    
    if let url = URL(string: dnNyhetsDygnetUrl) {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let httpResponse = response as! HTTPURLResponse // (Forced) type casting
            if httpResponse.statusCode == 200 {
                let html = String(data: data, encoding: .utf8)!
                let doc: Document = try SwiftSoup.parse(html)
                let aHrefs = try doc.select("a.timeline-teaser")
                
                for link: Element in aHrefs.array()[..<5] {
                    let articleLink: String = try link.attr("href")
                    print("text? \(articleLink), type? \(type(of: articleLink))\n")
                    dnNewsLinksMsg += dnBaseUrl + articleLink + "\n"
                }
                
                dnNewsLinksMsg += "\n\n" + dnNyhetsDygnetUrl + "\n"
                print("dn news links msg: \(dnNewsLinksMsg)")
                return dnNewsLinksMsg
            } else {
                print("Some other http response code: \(httpResponse.statusCode)")
            }
        } catch {
            print("Fetch errrror?")
        }
    }
    
    return "Hej där!"
}
