//
//  AccessToken.swift
//  axaWodio
//
//  Created by Márk József Alexa on 2021. 12. 17..
//

import Foundation

public struct AuthToken: Codable {
    public let accessToken: String
    public let refreshToken: String
}

extension AuthToken {
    public init(_ accessToken: String, _ refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
