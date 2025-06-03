```swift
import BaseKit
import UIKit

public enum ExampleViewModelOutput: Equatable {
    case selectedSongChanged
    case updateFavorite
    case showCard
}

struct ExampleEndpoint: EndpointProtocol {
    var path: String { "posts" }
    var method: HTTPMethod { .post }
    var headers: [String : String]? {["Content-type" : "application/json; charset=UTF-8"]}
}

struct ExampleRequest: RequestProtocol {
    struct Body: Encodable {
        var title: String?
        var body: String?
        var userId: Int?
    }
    
    struct Response: Decodable {
        var id: Int?
        var title: String?
        var body: String?
        var userId: Int?
    }
    
    var endpoint: any EndpointProtocol {
        ExampleEndpoint()
    }
    
    var body: Body?
    
    init(title: String?, body: String?, userId: Int?) {
        self.body = .init(title: title, body: body, userId: userId)
    }
}

final class ExampleViewModel: MVVM<ExampleViewModelOutput> {
    var locations: [String] = []
    
    override func baseURL() -> URL {
        URL(string: "https://jsonplaceholder.typicode.com/")!
    }
    
    override func onViewDidLoad() {
        let req = ExampleRequest(title: "testTitle", body: "test body", userId: 2)
        
        client.send(req) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

final class ExampleController: BaseVC<ExampleViewModel> {
    override func bindViewModel() {
        viewModel.output = { output in
            switch output {
            case .selectedSongChanged:
                print("selected song")
            default:
                break
            }
        }
    }
}

```
