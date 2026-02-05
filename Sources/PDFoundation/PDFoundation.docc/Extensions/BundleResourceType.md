# ``PDFoundation/BundleResourceType``

## Overview

Resource types have standard bundle paths and can be interpreted by
consumers by any means necessary. The ``Bundle`` class provides common
implementations for accessing these resource types
(see: <doc:Bundle#Accessing-bundle-resources>).

> Note: Not all bundles require every resource type to be available. The
> ``BundleResourceType`` protocol is designed to ensure as much
> flexibility as possible while providing a predicable API.

### Defining custom resource types

Bundle resources have standard resource types available in PDFoundation
such as ``image``, ``font``, and ``sound``, but there may be cases where
you'd like to store your own resource types in a bundle's resources. To
accomplish this, create a type that conforms to ``BundleResourceType``.
For example, the following creates a resource type that represents binary
data in a custom format and lives within the `Data` directory inside of a
bundle's resources:

```swift
struct MyBinaryDataResourceType: BundleResourceType {
    var requiresFileExtension: Bool { true }
    func subpath(name: String) -> String {
        "/Data/\(name).bindata"
    }
}
```

For convenience, you may also want to extend ``BundleResourceType`` to
provide this type:

```swift
extension BundleResourceType where Self == MyBinaryDataResourceType {
    static var myBinaryData: MyBinaryDataResourceType {
        MyBinaryDataResourceType()
    }
}

// Usage
let bindataPath = Bundle.main.resourcePath(
    forResourceNamed: "Achievements",
    ofType: .myBinaryData)
```

## Topics

### Available resource types

- ``font``
- ``image``
- ``json``
- ``sound``

### Standard resource types

- ``FontResourceType``
- ``ImageResourceType``
- ``JSONResourceType``
- ``SoundResourceType``

### Defining custom resource types

- ``subpath(name:)``
- ``requiresFileExtension``
