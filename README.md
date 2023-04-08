# Uuid25: 25-digit case-insensitive UUID encoding

[![GitHub tag](https://img.shields.io/github/v/tag/uuid25/swift-uuid25)](https://github.com/uuid25/swift-uuid25)
[![License](https://img.shields.io/github/license/uuid25/swift-uuid25)](https://github.com/uuid25/swift-uuid25/blob/main/LICENSE)
[![Swift Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fuuid25%2Fswift-uuid25%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/uuid25/swift-uuid25)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fuuid25%2Fswift-uuid25%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/uuid25/swift-uuid25)

Uuid25 is an alternative UUID representation that shortens a UUID string to just
25 digits using the case-insensitive Base36 encoding. This library provides
functionality to convert from the conventional UUID formats to Uuid25 and vice
versa.

```swift
import Uuid25

// convert from/to string
let a = Uuid25("8da942a4-1fbe-4ca6-852c-95c473229c7d")!
assert(a.description == "8dx554y5rzerz1syhqsvsdw8t")
assert(a.hyphenated == "8da942a4-1fbe-4ca6-852c-95c473229c7d")

// convert from/to 128-bit byte array
let b = Uuid25(bytes: [UInt8](repeating: 0xff, count: 16))
assert(b.description == "f5lxx1zz5pnorynqglhzmsp33")
assert(b.bytes.allSatisfy { $0 == 0xff })

// convert from/to other popular textual representations
let c = [
  Uuid25("e7a1d63b711744238988afcf12161878")!,
  Uuid25("e7a1d63b-7117-4423-8988-afcf12161878")!,
  Uuid25("{e7a1d63b-7117-4423-8988-afcf12161878}")!,
  Uuid25("urn:uuid:e7a1d63b-7117-4423-8988-afcf12161878")!,
]
assert(c.allSatisfy { $0.description == "dpoadk8izg9y4tte7vy1xt94o" })

let d = Uuid25("dpoadk8izg9y4tte7vy1xt94o")!
assert(d.hex == "e7a1d63b711744238988afcf12161878")
assert(d.hyphenated == "e7a1d63b-7117-4423-8988-afcf12161878")
assert(d.braced == "{e7a1d63b-7117-4423-8988-afcf12161878}")
assert(d.urn == "urn:uuid:e7a1d63b-7117-4423-8988-afcf12161878")
```

## Add swift-uuid25 as a package dependency

To add this library to your Xcode project as a dependency, select **File** >
**Add Packages** and enter the package URL:
https://github.com/uuid25/swift-uuid25

To use this library in a SwiftPM project, add the following line to the
dependencies in your Package.swift file:

```swift
.package(url: "https://github.com/uuid25/swift-uuid25", from: "<version>"),
```

And, include `Uuid25` as a dependency for your target:

```swift
.target(
  name: "<target>",
  dependencies: [.product(name: "Uuid25", package: "swift-uuid25")]
)
```

## License

Licensed under the Apache License, Version 2.0.

## See also

- [swift-uuid25 - Swift Package Index](https://swiftpackageindex.com/uuid25/swift-uuid25)
