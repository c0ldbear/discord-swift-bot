//
//  dn.news.swift
//  
//
//  Created by teddy juhlin-henricson on 2022-05-25.
//

// TODO:
//  [x] Rewrite as a Class

// Bontouch Code Guidelines

import Foundation
import SwiftSoup

final class DagensNyheter {
    private let dnBaseUrl: String
    private let dnNyhetsDygnetUrl: String

    init() {
        self.dnBaseUrl = "https://www.dn.se"
        self.dnNyhetsDygnetUrl = self.dnBaseUrl + "/nyhetsdygnet/"
    }
    
    @available(macOS 12.0, *)
    func latestNews() async -> String {
            
        guard let url = URL(string: dnNyhetsDygnetUrl) else {
            return "No URL."
        }
        
        do {
            
            let (html, httpResponse) = try await fetchDagensNyheterHTML(url: url)
            
            if (httpResponse.statusCode != 200) {
                return html
            }
            
            let newsArticleLinks = try findNewsArticleLinks(html: html)
            
            let dnNewsLinksMsg = try createBotMsg(newsArticleLinks)
            
            return dnNewsLinksMsg
        } catch {
            print("Fetch errrror?")
        }
        
        return "Hej där! Funktionen är inte helt implementerad."
    }
    
    @available(macOS 12.0, *)
    private func fetchDagensNyheterHTML(url: URL) async throws -> (html: String, httpResponse: HTTPURLResponse) {
        var html: String = "No HTML found."
        
        let (data, response) = try await URLSession.shared.data(from: url)
        let httpResponse = response as! HTTPURLResponse // (Forced) type casting
        
        if httpResponse.statusCode == 200 {
            html = String(data: data, encoding: .utf8)!
        } else {
            html += " Status code: \(httpResponse.statusCode)."
        }
        
        return (html, httpResponse)
    }

    private func findNewsArticleLinks(html: String) throws -> Elements {
        let doc: Document = try SwiftSoup.parse(html)
        let newsArticleHtmlTagAndCssClass = "a.timeline-teaser" // format: "HtmlTag.CSSClass"
        let newsArticleLinks: Elements = try doc.select(newsArticleHtmlTagAndCssClass)
        return newsArticleLinks
    }

    private func createBotMsg(_ links: Elements) throws -> String {
        if !links.isEmpty {
            var dnNewsLinksMsg: String = "Dagens seanste 5 nyheter från dn.se\n\n"
            
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
}
