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
## Handle authorization error
```swift

class TestRouterConfig {
	static let instance = TestRouterConfig()
	let routerConfig = RouterConfig.instance
	var refreshTask: URLSessionTask?
	
	init() {
		routerConfig.routerConfigDelegate = self
		// Ha van már elmentett token akkor beállíthatjuk extra headernek
		let extraHeaders = ["Authorization": UserDefaults.standard.value(forKey: "auth") as! String,
							"channel": "IOS",
							"deviceId": "asdfasfasdf",
							"apiLevel": "111",
							"buildNumber": "1234243"]
		routerConfig.extraHeaders = extraHeaders
	}
}

extension TestRouterConfig: RouterConfigDelegate {
	// Itt elvégezhetjük a token refresht, utána pedig lefut az eredeti hívás az új tokennel
	func handleAuthorizationError() {
		if refreshTask == nil {
			let router = Router<LoginApi>()
			routerConfig.extraHeaders?["Authorization"] = UserDefaults.standard.value(forKey: "ref") as? String
			refreshTask = router.requestRefresh(.refresh(userId: "210809472")) { [weak self] (result: Result<NetworkResponse<Token>, NetworkError>) in
				self?.refreshTask = nil
				switch result {
				case .success(let response):
					UserDefaults.standard.set(response.data.Authorization, forKey: "auth")
					UserDefaults.standard.set(response.data.Refresh, forKey: "ref")
					self?.routerConfig.extraHeaders?["Authorization"] = UserDefaults.standard.value(forKey: "auth") as? String
					self?.routerConfig.callRefreshCompletions(success: true)
				case .failure(_):
					self?.routerConfig.callRefreshCompletions(success: false)
				}
			}
		}
	}
}
```

