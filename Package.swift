import PackageDescription

let package = Package(
    name: "VaporTestCharlie",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/OpenKitten/MongoKitten.git", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/vapor/tls.git", majorVersion: 1)
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
        "Tests",
    ]
)

