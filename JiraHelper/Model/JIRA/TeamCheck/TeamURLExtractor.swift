//
//  TeamURLExtractor.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 24.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct TeamURLExtractor {

    private let hostSuffix = ".atlassian.net"

    func extractTeamName(from urlString: String) -> String? {
        guard let url = URL(string: urlString), let host = url.host, host.hasSuffix(hostSuffix) else { return nil }
        let lengthDiff = host.length - hostSuffix.length
        guard lengthDiff > 0 else { return nil }
        return String(host.characters.prefix(lengthDiff))
    }
}
