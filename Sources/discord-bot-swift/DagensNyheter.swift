//
//  DagensNyheter.swift
//  
//
//  Created by teddy juhlin-henricson on 2022-05-25.
//

// Bontouch Code Guidelines

import Foundation
import SwiftSoup

enum DagensNyheterUrls {
    static let dnBaseUrl = "https://www.dn.se"
    static let dnNyhetsDygnet = "/nyhetsdygnet/"
}

@available(macOS 12.0, *)
final class DagensNyheter {

    func latestNews() async -> String {
            
        guard let url = URL(string: DagensNyheterUrls.dnBaseUrl + DagensNyheterUrls.dnNyhetsDygnet) else {
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
            
        } catch let error {
            let errorMsg = "Error: \(error)"
            print(errorMsg)
            return errorMsg
        }
    }
    
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
        if links.isEmpty {
            return "I didn't find any article links."
        } else {
            var dnNewsLinksMsg: String = "Dagens seanste 5 nyheter från dn.se\n\n"
            
            for link: Element in links.array()[..<5] {
                let articleLink: String = try link.attr("href")
    //            print("text? \(articleLink), type? \(type(of: articleLink))\n")
                dnNewsLinksMsg += DagensNyheterUrls.dnBaseUrl + articleLink + "\n"
            }
            
            dnNewsLinksMsg += "\n\n" + DagensNyheterUrls.dnBaseUrl + DagensNyheterUrls.dnNyhetsDygnet + "\n"
            return dnNewsLinksMsg
        }
    }
}
