# CatalystNet
Universal AppleOS Apps Networking kit

## Installation:

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate CatalystNet into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'CatalystNet'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding CatalystNet as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/hellc/CatalystNet.git")
]
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate CatalystNet into your project manually.

## Usage:

### Rest client:

#### Import package

```swift
import CatalystNet
```

#### Define a Custom Rest Api Client:

```swift
class TestApiClient: RestClient {
    static let shared = RestClient(baseUrl: "https://jsonplaceholder.typicode.com")
}
```

#### Define a requested resource:

```swift
struct Post: Decodable {
    var id: UInt
    var userId: UInt
    var title: String
    var body: String
}
```

#### Define a Custom Api class:

```swift
class TestApi: Api {
    static let shared = TestApi()
    
    override func load<T>(_ resource: Resource<T, CustomError>,
                          _ client: RestClient = TestApiClient.shared,
                          multitasking: Bool = false,
                          completion: @escaping (Result<Any, CustomError>) -> Void) {
        super.load(resource, client, multitasking: multitasking, completion: completion)
    }
    
    func post(with id: String, completion: @escaping (Post?, RestError<CustomError>?) -> Void) {
        var resource = Resource<Post, CustomError>(path: Api.resource(TestApi.posts, with: id))
        
        resource.method = .get
        
        self.load(resource) { response in
            if let post = response.value as? Post {
                completion(post, nil)
            } else if let error = response.error {
                completion(nil, error)
            }
        }
    }
}
```

#### Define a Custom Api Endpoints as an extension of the Custom Api class:

```swift
extension TestApi {
    static let posts = "/posts"
}
```

#### Try it:

```swift
func testExample() {
    let id = "42"
    TestApi.shared.post(with: id) { (post, error) in
        if let post = post, error == nil {
            print(post)
        }
    }
}
```

Output:
```
Post(id: 42, userId: 5, title: "commodi ullam sint et excepturi error explicabo praesentium voluptas", body: "odio fugit voluptatum ducimus earum autem est incidunt voluptatem\nodit reiciendis aliquam sunt sequi nulla dolorem\nnon facere repellendus voluptates quia\nratione harum vitae ut")
```
