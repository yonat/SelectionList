// swift-tools-version:5.3

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
        .target(name: "SelectionList", dependencies: [], path: "Sources", resources: [.copy("PrivacyInfo.xcprivacy")]),
    ],
    swiftLanguageVersions: [.v5]
)
