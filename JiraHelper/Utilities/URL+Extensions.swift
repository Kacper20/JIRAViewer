//
//  URLModifier.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 08/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

extension URL {
    func changingPathExtension(to newExtension: String) -> URL {
        var copy = self
        copy.deletePathExtension()
        copy.appendPathExtension(newExtension)
        return copy
    }
}
