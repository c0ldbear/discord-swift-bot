//
//  dn.news.swift
//  
//
//  Created by teddy juhlin-henricson on 2022-05-25.
//

// TODO:
//  [] Rewrite as a Class
//  [x] Refactor to seperate functions/method

import Foundation
import SwiftSoup

private let dnBaseUrl = "https://www.dn.se"
private let dnNyhetsDygnetUrl = dnBaseUrl + "/nyhetsdygnet/"

@available(macOS 12.0, *)
func dn() async -> String {
    
    // Properties
//    var dnNewsLinksMsg: String = "Dagens senaste nyheter\n\n"
    
    if let url = URL(string: dnNyhetsDygnetUrl) {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let httpResponse = response as! HTTPURLResponse // (Forced) type casting
            if httpResponse.statusCode == 200 {
                let html = String(data: data, encoding: .utf8)!
                
                let newsArticleLinks = try findNewsArticleLinks(html: html)
                
                let dnNewsLinksMsg = try createBotMsg(newsArticleLinks)
                
                return dnNewsLinksMsg
            } else {
                print("Some other http response code: \(httpResponse.statusCode)")
            }
        } catch {
            print("Fetch errrror?")
        }
    }
    
    return "Hej där! Funktionen är inte helt implementerad."
}

private func findNewsArticleLinks(html: String) throws -> Elements {
    let doc: Document = try SwiftSoup.parse(html)
    let newsArticleHtmlTagAndCssClass = "a.timeline-teaser" // format: "HtmlTag.CSSClass"
    let newsArticleLinks: Elements = try doc.select(newsArticleHtmlTagAndCssClass)
    return newsArticleLinks
}

private func createBotMsg(_ links: Elements) throws -> String {
    if !links.isEmpty {
        var dnNewsLinksMsg: String = "Dagens seanste nyheter\n\n"
        
        for link: Element in links.array()[..<5] {
            let articleLink: String = try link.attr("href")
//            print("text? \(articleLink), type? \(type(of: articleLink))\n")
            dnNewsLinksMsg += dnBaseUrl + articleLink + "\n"
        }
        
        dnNewsLinksMsg += "\n\n" + dnNyhetsDygnetUrl + "\n"
        return dnNewsLinksMsg
    }
    return "Something something something lol"
}
