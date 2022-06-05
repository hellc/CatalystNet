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
pod 'CatalystNet', '~> 1.1.0'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding CatalystNet as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/hellc/CatalystNet.git", .upToNextMajor(from: "1.1.0"))
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

#### Defining model:

```swift
struct Photo: Decodable {
    let albumId: Int
    let id: Int
    let title: String?
    let url: String?
    let thumbnailUrl: String?
}

struct CustomError: Decodable {
    let message: String?
    let code: Int?
}
```

#### Defining base Api class:

```swift
class ExampleApi: Api {
    private let client: HttpClient!
    
    init(baseUrl: String = "https://jsonplaceholder.typicode.com") {
        self.client = HttpClient(baseUrl: baseUrl)
    }
    
    func load<T, E>(_ resource: Resource<T, E>,
                    multitasking: Bool = false,
                    completion: @escaping (Result<T, E>) -> Void) {
        // Setup auth policy if needed
        // Also you could extend "Resource" model with authentication method for simply calling "resource.authenticate()" when needed
        super.load(resource, self.client, multitasking: multitasking, completion: completion)
    }
}
```

##### Defining Asynchronous Functions (iOS >= 13.0.0)
```swift
@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
extension ExampleApi {
    func load<T, E>(_ resource: Resource<T, E>) async throws -> T {
        // Setup auth policy here if needed
        return try await super.load(resource, self.client)
    }
}

```

#### Defining Api class methods:
```swift
class PhotosApi: ExampleApi {
    private struct Endpoints {
        static let photos: String = "/photos"
    }

    func photo(with id: Int, completion: @escaping (Photo?, CatalystError<CustomError>?) -> Void) {
        var resource = Resource<Photo, CustomError>(path: Api.resource(Endpoints.photos, with: id))
        
        resource.method = .get
        
        // resource.authenticate() // if needed
        
        self.load(resource) { response in
            switch response {
            case .success(let photo):
                completion(photo, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

##### Defining Asynchronous Functions (iOS >= 13.0.0)
@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
extension PhotosApi {
    func photo(with id: Int) async throws -> Photo {
        var resource = Resource<Photo, CustomError>(path: Api.resource(Endpoints.photos, with: id))
        
        resource.method = .get
        
        // resource.authenticate() // if needed
        
        return try await self.load(resource)
    }
}
```

#### Try it:

```swift
let photosApi = PhotosApi()

let photoId: Int = 42
self.photosApi.photo(with: photoId) { (photo, error) in
    print(photo)
}
```
##### Try it asynchronously:

```swift
let photoId: Int = 42
do {
    let photo = try await self.photosApi.photo(with: photoId)
    print(photo)
} catch {
    print(error)
    // TODO: Proceed "error" object
}
```
Output:
```
Photo(
    albumId: 1,
    id: 42,
    title: Optional("voluptatibus a autem molestias voluptas architecto culpa"),
    url: Optional("https://via.placeholder.com/600/ca50ac"),
    thumbnailUrl: Optional("https://via.placeholder.com/150/ca50ac")
)
```

Please follow Tests/ExampleTests.swift file for more usage examples <3
