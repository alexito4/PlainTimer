// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "timer",
    targets: [
        Target(
            name: "timer",
            dependencies: ["TimerCore"]
        ),
        Target(name: "TimerCore"),
    ]
)
