# CatalystNet
Universal AppleOS Apps Networking kit

![badge](https://action-badges.now.sh/hellc/CatalystNet)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CatalystNet.svg)](https://img.shields.io/cocoapods/v/CatalystNet.svg)
![iOS](https://img.shields.io/badge/Swift-5.0-orange)
![iOS](https://img.shields.io/badge/iOS-11.0-green)
![macOS](https://img.shields.io/badge/macOS-10.15-green)
![macOS](https://img.shields.io/badge/watchOS-4.0-green)
![MIT](https://cocoapod-badges.herokuapp.com/l/NSStringMask/badge.png)

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

### Http client:

#### Import package

```swift
import CatalystNet
```

#### Define a requested resource:

```swift
struct Post: Decodable {
    let id: UInt
    let userId: UInt
    let title: String?
    let body: String?
}
```

#### Define Api class base:

```swift
class TestApi: Api {
    private let client: HttpClient!
    
    init(baseUrl: String) {
        self.client = HttpClient(baseUrl: baseUrl)
    }
    
    func load<T, E>(_ resource: Resource<T, E>,
                    multitasking: Bool = false,
                    completion: @escaping (Result<Any, E>) -> Void) {
        super.load(resource, self.client, multitasking: multitasking, completion: completion)
    }
}
```

#### Define Api class methods:

```swift
extension TestApi {
    private struct Endpoints {
        static let posts = "/posts"
    }
    
    func post(with id: String, completion: @escaping (Post?, HttpError<String>?) -> Void) {
        var resource = Resource<Post, String>(path: Api.resource(Endpoints.posts, with: id))
        
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

#### Try it:

```swift
let testApi = TestApi(baseUrl: "https://jsonplaceholder.typicode.com")
let id = "42"

self.testApi.post(with: id) { (post, error) in
    if let post = post, error == nil {
        print(post)
    }
}
```

Output:
```
Post(id: 42, userId: 5, title: "commodi ullam sint et excepturi error explicabo praesentium voluptas", body: "odio fugit voluptatum ducimus earum autem est incidunt voluptatem\nodit reiciendis aliquam sunt sequi nulla dolorem\nnon facere repellendus voluptates quia\nratione harum vitae ut")
```
