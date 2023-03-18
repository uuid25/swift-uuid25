// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-uuid25",
  products: [.library(name: "Uuid25", targets: ["Uuid25"])],
  dependencies: [],
  targets: [
    .target(name: "Uuid25", dependencies: []),
    .testTarget(name: "Uuid25Tests", dependencies: ["Uuid25"]),
  ]
)
