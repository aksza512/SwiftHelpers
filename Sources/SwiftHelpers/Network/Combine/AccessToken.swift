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
