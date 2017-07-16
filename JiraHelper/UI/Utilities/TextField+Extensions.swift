//
//  TextField+Extensions.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 16/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

extension NSTextField {

    func setHtml(_ html: String, fontSize: CGFloat) {
        let modifiedFontHtml = NSString(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(fontSize)\">%@</span>" as NSString, html) as String
        guard let data = modifiedFontHtml.data(using: .utf16) else { return }
        let attributedString = try? NSAttributedString(
            data: data,
            options: [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType
            ],
            documentAttributes: nil
        )
        if let attrString = attributedString {
            attributedStringValue = attrString
        }
    }
}
