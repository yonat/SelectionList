// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "SelectionList",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(name: "SelectionList", targets: ["SelectionList"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "SelectionList", dependencies: [], path: "Sources", resources: [.process("PrivacyInfo.xcprivacy")]),
    ],
    swiftLanguageVersions: [.v5]
)
