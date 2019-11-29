# SwiftHelpers

A description of this package.

public enum Country: String {
    case hu = "hu"
}

struct ResultArray<T: Codable>: Codable {
    let data: T
}

public struct NameDay: Codable {
    let day: Int
    let month: Int
	let name_hu: String
}

public enum NameDayApi {
    case today(country: Country)
}

extension NameDayApi: EndPoint {
    public var baseURL: URL { URL(string: "https://api.abalin.net/get")! }
    public var path: String {
        switch self {
        case .today(_): return "today"
        }
    }
    public var httpMethod: HTTPMethod { .get }
    public var requestType: RequestType {
        switch self {
		case .today(let country): return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: ["country": country.rawValue])
        }
    }
}
