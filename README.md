# Ragnarok GRF

A Swift package for reading GRF archive files used in Ragnarok Online.

GRF is the proprietary archive format used by Gravity's Ragnarok Online client to store game assets — textures, sounds, maps, scripts, and more. This library parses GRF archives, handles DES decryption for older formats, and decompresses entries on demand.

## Requirements

- Swift 6.0+
- macOS 12+ / iOS 15+

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/arkadeleon/ragnarok-grf", branch: "master"),
]
```

Then add `RagnarokGRF` as a dependency of your target:

```swift
.target(
    name: "MyTarget",
    dependencies: [
        .product(name: "RagnarokGRF", package: "ragnarok-grf"),
    ]
)
```

## Usage

### Open an archive

`GRFArchive` is a Swift `actor`, so all access is automatically safe for concurrent use.

```swift
import RagnarokGRF

let url = URL(fileURLWithPath: "/path/to/data.grf")
let archive = GRFArchive(url: url)
```

### Browse directories

```swift
// List the top-level "data" directory
let root = GRFPath(components: ["data"])

let children = await archive.childrenOfDirectoryNode(at: root)
for node in children {
    if node.isDirectory {
        print("[DIR]  \(node.path.lastComponent)")
    } else {
        print("[FILE] \(node.path.lastComponent)")
    }
}
```

### Read a file

```swift
let path = GRFPath(components: ["data", "texture", "À¯ÀúÀÎÅÍÆäÀÌ½º", "bgi_temp.bmp"])

do {
    let data = try await archive.contentsOfEntryNode(at: path)
    // use data ...
} catch {
    print("Failed to read entry: \(error)")
}
```

## Supported formats

| Version | Description |
|---------|-------------|
| 0x102   | GRF 1.02 — DES-encrypted entries |
| 0x103   | GRF 1.03 — DES-encrypted entries |
| 0x200   | GRF 2.00 — gzip-compressed table, 32-bit offsets |
| 0x300   | GRF 3.00 — gzip-compressed table, 64-bit offsets |

LZMA-compressed archives (magic byte `0x00` in the compressed stream) are not supported.

## Error handling

All errors are typed as `GRFError`:

```swift
public enum GRFError: Error {
    case invalidURL(URL)
    case invalidHeader([UInt8])
    case invalidVersion(UInt32)
    case invalidEntryPath(String)
    case dataCorrupted(Data)
    case lzmaCompressionIsNotSupported
}
```

## License

Ragnarok GRF is released under the GNU General Public License v3.0. See [LICENSE](LICENSE) for details.
