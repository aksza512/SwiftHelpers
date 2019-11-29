# Network Example


```swift
HTTPRequest:
	https://api.abalin.net/get/today?country=hu
HTTPResponse: 
	{"data":{"day":29,"month":11,"name_hu":"Taksony"}}


public enum Country: String {
    case hu
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
```
## Create request
```swift
let router = Router<NameDayApi>() 
router.request(.today(country: .hu)) { (result: Result<ResultArray<NameDay>, Error>) in
	switch result {
		case .success(let result): ...
		case .failure(let error): ...
	}
}
```

