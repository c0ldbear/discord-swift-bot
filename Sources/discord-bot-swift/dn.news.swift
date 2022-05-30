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
    let dnUrl = "https://www.dn.se/nyhetsdygnet/"
    
    if let url = URL(string: dnUrl) {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let httpResponse = response as! HTTPURLResponse // Type casting
            if httpResponse.statusCode == 200 {
                let html = String(data: data, encoding: .utf8)!
                let doc: Document = try SwiftSoup.parse(html)
//                let sections = try doc.select("section.section__column-main")
                let aHrefs = try doc.select("a.timeline-teaser")
//                let links: Elements = try doc.select("a[href]")
//                print("Number of sections: \(sections.count)")
//                let mainSection = try sections.attr("class")
                print("How many main section? \(aHrefs.count)")
                
//                for stuff: Element in mainSection.array() {
//                    print(stuff)
//                }
                
                for link: Element in aHrefs.array()[..<5] {
                    print("text? \(try link.attr("href"))\n")
                }
                
            } else {
                print("Some other http response code: \(httpResponse.statusCode)")
            }
        } catch {
            print("Fetch errrror?")
        }
    }
    
    return "Hej där!"
}
