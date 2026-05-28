//
//  RagnarokGRFTests.swift
//  RagnarokGRFTests
//
//  Created by Leon Li on 2020/5/4.
//

import Foundation
import Testing
@testable import RagnarokGRF

// Test data source: https://github.com/arminherling/GRF
@Test(arguments: [
    "test102.grf",
    "test103.grf",
    "test200.grf",
])
func grf(path: String) async throws {
    let resourceURL = Bundle.module.resourceURL!
    let grfURL = resourceURL.appendingPathComponent(path)
    let grf = try GRF(url: grfURL)

    #expect(grf.table.entries.count == 9)
    #expect(grf.table.entries[0].path.string == "data\\0_Tex1.bmp")
    #expect(grf.table.entries[1].path.string == "data\\11001.txt")
    #expect(grf.table.entries[2].path.string == "data\\balls.wav")
    #expect(grf.table.entries[3].path.string == "data\\idnum2itemdesctable.txt")
    #expect(grf.table.entries[4].path.string == "data\\idnum2itemdisplaynametable.txt")
    #expect(grf.table.entries[5].path.string == "data\\loading00.jpg")
    #expect(grf.table.entries[6].path.string == "data\\monstertalktable.xml")
    #expect(grf.table.entries[7].path.string == "data\\resnametable.txt")
    #expect(grf.table.entries[8].path.string == "data\\t2_¹è°æ1-1.bmp")

    let dataURL = resourceURL.appendingPathComponent("data")
    let files = [
        dataURL.appendingPathComponent("0_Tex1.bmp"),
        dataURL.appendingPathComponent("11001.txt"),
        dataURL.appendingPathComponent("balls.wav"),
        dataURL.appendingPathComponent("idnum2itemdesctable.txt"),
        dataURL.appendingPathComponent("idnum2itemdisplaynametable.txt"),
        dataURL.appendingPathComponent("loading00.jpg"),
        dataURL.appendingPathComponent("monstertalktable.xml"),
        dataURL.appendingPathComponent("resnametable.txt"),
        dataURL.appendingPathComponent("t2_¹è°æ1-1.bmp"),
    ]

    let stream = GRFStream(forReadingFrom: grfURL)!
    defer {
        stream.close()
    }

    for (i, entry) in grf.table.entries.enumerated() {
        let entryData = try entry.data(from: stream)
        let fileData = try Data(contentsOf: files[i])
        #expect(entryData == fileData)
    }
}
