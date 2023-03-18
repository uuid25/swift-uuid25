import XCTest

@testable import Uuid25

final class Uuid25Tests: XCTestCase {
  /// Tests `Equatable` implementation.
  func testEq() throws {
    for e in testCases {
      let x = Uuid25(e.uuid25)!
      let y = Uuid25(e.uuid25)!
      XCTAssertEqual(x, y)
    }
  }

  /// Tests `Hashable` implementation.
  func testHash() throws {
    let a = "e56ib2nq5r4xc5s1m3ra7tgn5"
    let b = "021dqro063u0taj7l442f625s"
    let c = "39yf1dk3bobxkselkuibw01dv"
    let d = "co6p485732iprk9ih1x208hvo"
    let e = "bd5lnb5mncp14mpqhah063zi9"
    let f = "7hoo4kemx18f7628fieegto0l"
    let g = "375850bf-c24a-b932-09e8-bb3e5b3bd303"  // c == g

    let s: Set = [Uuid25(a)!, Uuid25(b)!, Uuid25(c)!]
    XCTAssertEqual(s.count, 3)

    XCTAssertTrue(s.contains(Uuid25(a)!))
    XCTAssertTrue(s.contains(Uuid25(b)!))
    XCTAssertTrue(s.contains(Uuid25(c)!))
    XCTAssertFalse(s.contains(Uuid25(d)!))
    XCTAssertFalse(s.contains(Uuid25(e)!))
    XCTAssertFalse(s.contains(Uuid25(f)!))

    XCTAssertTrue(s.contains(Uuid25(g)!))
  }

  /// Tests conversions from/to byte arrays using manually prepared cases.
  func testFromToPreparedBytes() throws {
    for e in testCases {
      let x = Uuid25(e.uuid25)!
      XCTAssertEqual(x.description, Uuid25(bytes: e.bytes).description)
      XCTAssertEqual(
        x.description,
        Uuid25(
          byteTuple: (
            e.bytes[0], e.bytes[1], e.bytes[2], e.bytes[3],
            e.bytes[4], e.bytes[5], e.bytes[6], e.bytes[7],
            e.bytes[8], e.bytes[9], e.bytes[10], e.bytes[11],
            e.bytes[12], e.bytes[13], e.bytes[14], e.bytes[15]
          )
        ).description)

      XCTAssertEqual(x.bytes, e.bytes)
      let bs = x.byteTuple
      XCTAssertEqual(bs.0, e.bytes[0])
      XCTAssertEqual(bs.1, e.bytes[1])
      XCTAssertEqual(bs.2, e.bytes[2])
      XCTAssertEqual(bs.3, e.bytes[3])
      XCTAssertEqual(bs.4, e.bytes[4])
      XCTAssertEqual(bs.5, e.bytes[5])
      XCTAssertEqual(bs.6, e.bytes[6])
      XCTAssertEqual(bs.7, e.bytes[7])
      XCTAssertEqual(bs.8, e.bytes[8])
      XCTAssertEqual(bs.9, e.bytes[9])
      XCTAssertEqual(bs.10, e.bytes[10])
      XCTAssertEqual(bs.11, e.bytes[11])
      XCTAssertEqual(bs.12, e.bytes[12])
      XCTAssertEqual(bs.13, e.bytes[13])
      XCTAssertEqual(bs.14, e.bytes[14])
      XCTAssertEqual(bs.15, e.bytes[15])
    }
  }

  /// Examines parsing results against manually prepared cases.
  func testParse() throws {
    for e in testCases {
      let x = e.uuid25
      XCTAssertEqual(x, Uuid25(e.uuid25)!.description)
      XCTAssertEqual(x, Uuid25(e.hex)!.description)
      XCTAssertEqual(x, Uuid25(e.hyphenated)!.description)
      XCTAssertEqual(x, Uuid25(e.braced)!.description)
      XCTAssertEqual(x, Uuid25(e.urn)!.description)

      XCTAssertEqual(x, try! Uuid25(parsing: e.uuid25).description)
      XCTAssertEqual(x, try! Uuid25(parsing: e.hex).description)
      XCTAssertEqual(x, try! Uuid25(parsing: e.hyphenated).description)
      XCTAssertEqual(x, try! Uuid25(parsing: e.braced).description)
      XCTAssertEqual(x, try! Uuid25(parsing: e.urn).description)

      XCTAssertEqual(x, try! Uuid25(uuid25: e.uuid25).description)
      XCTAssertEqual(x, try! Uuid25(hex: e.hex).description)
      XCTAssertEqual(x, try! Uuid25(hyphenated: e.hyphenated).description)
      XCTAssertEqual(x, try! Uuid25(braced: e.braced).description)
      XCTAssertEqual(x, try! Uuid25(urn: e.urn).description)

      XCTAssertNil(try? Uuid25(uuid25: e.hex))
      XCTAssertNil(try? Uuid25(uuid25: e.hyphenated))
      XCTAssertNil(try? Uuid25(uuid25: e.braced))
      XCTAssertNil(try? Uuid25(uuid25: e.urn))

      XCTAssertNil(try? Uuid25(hex: e.uuid25))
      XCTAssertNil(try? Uuid25(hex: e.hyphenated))
      XCTAssertNil(try? Uuid25(hex: e.braced))
      XCTAssertNil(try? Uuid25(hex: e.urn))

      XCTAssertNil(try? Uuid25(hyphenated: e.uuid25))
      XCTAssertNil(try? Uuid25(hyphenated: e.hex))
      XCTAssertNil(try? Uuid25(hyphenated: e.braced))
      XCTAssertNil(try? Uuid25(hyphenated: e.urn))

      XCTAssertNil(try? Uuid25(braced: e.uuid25))
      XCTAssertNil(try? Uuid25(braced: e.hex))
      XCTAssertNil(try? Uuid25(braced: e.hyphenated))
      XCTAssertNil(try? Uuid25(braced: e.urn))

      XCTAssertNil(try? Uuid25(urn: e.uuid25))
      XCTAssertNil(try? Uuid25(urn: e.hex))
      XCTAssertNil(try? Uuid25(urn: e.hyphenated))
      XCTAssertNil(try? Uuid25(urn: e.braced))
    }
  }

  /// Examines conversion-to results against manually prepared cases.
  func testToOtherFormats() throws {
    for e in testCases {
      let x = Uuid25(e.uuid25)!
      XCTAssertEqual(x.description, e.uuid25)
      XCTAssertEqual(x.hex, e.hex)
      XCTAssertEqual(x.hyphenated, e.hyphenated)
      XCTAssertEqual(x.braced, e.braced)
      XCTAssertEqual(x.urn, e.urn)
    }
  }

  /// Tests if parsing methods throw error on invalid inputs.
  func testParseError() throws {
    let cases = [
      "",
      "0",
      "f5lxx1zz5pnorynqglhzmsp34",
      "zzzzzzzzzzzzzzzzzzzzzzzzz",
      " 65xe2jcp3zjc704bvftqjzbiw",
      "65xe2jcp3zjc704bvftqjzbiw ",
      " 65xe2jcp3zjc704bvftqjzbiw ",
      "{65xe2jcp3zjc704bvftqjzbiw}",
      "-65xe2jcp3zjc704bvftqjzbiw",
      "65xe2jcp-3zjc704bvftqjzbiw",
      "5xe2jcp3zjc704bvftqjzbiw",
      " 82f1dd3c-de95-075b-93ff-a240f135f8fd",
      "82f1dd3c-de95-075b-93ff-a240f135f8fd ",
      " 82f1dd3c-de95-075b-93ff-a240f135f8fd ",
      "82f1dd3cd-e95-075b-93ff-a240f135f8fd",
      "82f1dd3c-de95075b-93ff-a240f135f8fd",
      "82f1dd3c-de95-075b93ff-a240-f135f8fd",
      "{8273b64c5ed0a88b10dad09a6a2b963c}",
      "urn:uuid:8273b64c5ed0a88b10dad09a6a2b963c",
    ]

    for e in cases {
      XCTAssertNil(Uuid25(e))
      XCTAssertThrowsError(try Uuid25(parsing: e))
      XCTAssertThrowsError(try Uuid25(uuid25: e))
      XCTAssertThrowsError(try Uuid25(hex: e))
      XCTAssertThrowsError(try Uuid25(hyphenated: e))
      XCTAssertThrowsError(try Uuid25(braced: e))
      XCTAssertThrowsError(try Uuid25(urn: e))
    }
  }

  /// Tests `Codable` implementation.
  func testCodable() throws {
    let enc = JSONEncoder()
    let dec = JSONDecoder()

    for e in testCases {
      let x = Uuid25(e.uuid25)!
      XCTAssertEqual(try enc.encode(x), try enc.encode(e.uuid25))

      XCTAssertEqual(x, try dec.decode(Uuid25.self, from: try enc.encode(e.uuid25)))
      XCTAssertEqual(x, try dec.decode(Uuid25.self, from: try enc.encode(e.hex)))
      XCTAssertEqual(x, try dec.decode(Uuid25.self, from: try enc.encode(e.hyphenated)))
      XCTAssertEqual(x, try dec.decode(Uuid25.self, from: try enc.encode(e.braced)))
      XCTAssertEqual(x, try dec.decode(Uuid25.self, from: try enc.encode(e.urn)))

      XCTAssertEqual(x, try dec.decode(Uuid25.self, from: try enc.encode(e.bytes)))

      XCTAssertEqual(x, try dec.decode(Uuid25.self, from: try enc.encode([UInt8](e.uuid25.utf8))))
      XCTAssertEqual(x, try dec.decode(Uuid25.self, from: try enc.encode([UInt8](e.hex.utf8))))
      XCTAssertEqual(
        x, try dec.decode(Uuid25.self, from: try enc.encode([UInt8](e.hyphenated.utf8))))
      XCTAssertEqual(x, try dec.decode(Uuid25.self, from: try enc.encode([UInt8](e.braced.utf8))))
      XCTAssertEqual(x, try dec.decode(Uuid25.self, from: try enc.encode([UInt8](e.urn.utf8))))
    }
  }
}

struct PreparedCase {
  let uuid25: String
  let hex: String
  let hyphenated: String
  let braced: String
  let urn: String
  let bytes: [UInt8]
}

let testCases = [
  PreparedCase(
    uuid25: "0000000000000000000000000",
    hex: "00000000000000000000000000000000",
    hyphenated: "00000000-0000-0000-0000-000000000000",
    braced: "{00000000-0000-0000-0000-000000000000}",
    urn: "urn:uuid:00000000-0000-0000-0000-000000000000",
    bytes: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
  PreparedCase(
    uuid25: "f5lxx1zz5pnorynqglhzmsp33",
    hex: "ffffffffffffffffffffffffffffffff",
    hyphenated: "ffffffff-ffff-ffff-ffff-ffffffffffff",
    braced: "{ffffffff-ffff-ffff-ffff-ffffffffffff}",
    urn: "urn:uuid:ffffffff-ffff-ffff-ffff-ffffffffffff",
    bytes: [255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255]),
  PreparedCase(
    uuid25: "8j7qcpk2yebp9ouobnujfc312",
    hex: "90252ae1bdeeb5e6454983a13e69d556",
    hyphenated: "90252ae1-bdee-b5e6-4549-83a13e69d556",
    braced: "{90252ae1-bdee-b5e6-4549-83a13e69d556}",
    urn: "urn:uuid:90252ae1-bdee-b5e6-4549-83a13e69d556",
    bytes: [144, 37, 42, 225, 189, 238, 181, 230, 69, 73, 131, 161, 62, 105, 213, 86]),
  PreparedCase(
    uuid25: "1ixkdgkqeu8wln1vfrw6csla3",
    hex: "19c63717dd78907f153dc2d12a357ebb",
    hyphenated: "19c63717-dd78-907f-153d-c2d12a357ebb",
    braced: "{19c63717-dd78-907f-153d-c2d12a357ebb}",
    urn: "urn:uuid:19c63717-dd78-907f-153d-c2d12a357ebb",
    bytes: [25, 198, 55, 23, 221, 120, 144, 127, 21, 61, 194, 209, 42, 53, 126, 187]),
  PreparedCase(
    uuid25: "1rt96u8g5mehk7anquaf5v0yd",
    hex: "1df0de923543c9886d446b0ef75df795",
    hyphenated: "1df0de92-3543-c988-6d44-6b0ef75df795",
    braced: "{1df0de92-3543-c988-6d44-6b0ef75df795}",
    urn: "urn:uuid:1df0de92-3543-c988-6d44-6b0ef75df795",
    bytes: [29, 240, 222, 146, 53, 67, 201, 136, 109, 68, 107, 14, 247, 93, 247, 149]),
  PreparedCase(
    uuid25: "18hye57ickp5c2mg8x9w4o1ji",
    hex: "14e0fa5629c70c0d663f5d326e51f1ce",
    hyphenated: "14e0fa56-29c7-0c0d-663f-5d326e51f1ce",
    braced: "{14e0fa56-29c7-0c0d-663f-5d326e51f1ce}",
    urn: "urn:uuid:14e0fa56-29c7-0c0d-663f-5d326e51f1ce",
    bytes: [20, 224, 250, 86, 41, 199, 12, 13, 102, 63, 93, 50, 110, 81, 241, 206]),
  PreparedCase(
    uuid25: "b7b5eir8qxbgpe8ofpfx0jmk4",
    hex: "bd3ba1d1ed924804b9004b6f96124cf4",
    hyphenated: "bd3ba1d1-ed92-4804-b900-4b6f96124cf4",
    braced: "{bd3ba1d1-ed92-4804-b900-4b6f96124cf4}",
    urn: "urn:uuid:bd3ba1d1-ed92-4804-b900-4b6f96124cf4",
    bytes: [189, 59, 161, 209, 237, 146, 72, 4, 185, 0, 75, 111, 150, 18, 76, 244]),
  PreparedCase(
    uuid25: "dsc6tknluzhcyoh0wbdhtfm91",
    hex: "e8e1d087617c3a88e8f4789ab4a7cf65",
    hyphenated: "e8e1d087-617c-3a88-e8f4-789ab4a7cf65",
    braced: "{e8e1d087-617c-3a88-e8f4-789ab4a7cf65}",
    urn: "urn:uuid:e8e1d087-617c-3a88-e8f4-789ab4a7cf65",
    bytes: [232, 225, 208, 135, 97, 124, 58, 136, 232, 244, 120, 154, 180, 167, 207, 101]),
  PreparedCase(
    uuid25: "edzg3t2pm0tzkjolrcmvlyhtx",
    hex: "f309d5b02bf3a736740075948ad1ffc5",
    hyphenated: "f309d5b0-2bf3-a736-7400-75948ad1ffc5",
    braced: "{f309d5b0-2bf3-a736-7400-75948ad1ffc5}",
    urn: "urn:uuid:f309d5b0-2bf3-a736-7400-75948ad1ffc5",
    bytes: [243, 9, 213, 176, 43, 243, 167, 54, 116, 0, 117, 148, 138, 209, 255, 197]),
  PreparedCase(
    uuid25: "1da9001w3ld329fiyf574wuk2",
    hex: "171fd840f315e7322796dea092d372b2",
    hyphenated: "171fd840-f315-e732-2796-dea092d372b2",
    braced: "{171fd840-f315-e732-2796-dea092d372b2}",
    urn: "urn:uuid:171fd840-f315-e732-2796-dea092d372b2",
    bytes: [23, 31, 216, 64, 243, 21, 231, 50, 39, 150, 222, 160, 146, 211, 114, 178]),
  PreparedCase(
    uuid25: "bvdc0zy20yoipgda8sb65tczv",
    hex: "c885af254a61954a1687c08e41f9940b",
    hyphenated: "c885af25-4a61-954a-1687-c08e41f9940b",
    braced: "{c885af25-4a61-954a-1687-c08e41f9940b}",
    urn: "urn:uuid:c885af25-4a61-954a-1687-c08e41f9940b",
    bytes: [200, 133, 175, 37, 74, 97, 149, 74, 22, 135, 192, 142, 65, 249, 148, 11]),
  PreparedCase(
    uuid25: "3mll19wjhi37qe68vtgobt04h",
    hex: "3d46fe7978287d4ff1e57bdf80ab30e1",
    hyphenated: "3d46fe79-7828-7d4f-f1e5-7bdf80ab30e1",
    braced: "{3d46fe79-7828-7d4f-f1e5-7bdf80ab30e1}",
    urn: "urn:uuid:3d46fe79-7828-7d4f-f1e5-7bdf80ab30e1",
    bytes: [61, 70, 254, 121, 120, 40, 125, 79, 241, 229, 123, 223, 128, 171, 48, 225]),
  PreparedCase(
    uuid25: "dlut3j4j5hudfwua508w8h25v",
    hex: "e5d7215d6e2c32991506498b84b32d33",
    hyphenated: "e5d7215d-6e2c-3299-1506-498b84b32d33",
    braced: "{e5d7215d-6e2c-3299-1506-498b84b32d33}",
    urn: "urn:uuid:e5d7215d-6e2c-3299-1506-498b84b32d33",
    bytes: [229, 215, 33, 93, 110, 44, 50, 153, 21, 6, 73, 139, 132, 179, 45, 51]),
  PreparedCase(
    uuid25: "bi0ifb9jmm2tig1hsdb9uol2v",
    hex: "c2416789944cb584e886ac162d9112b7",
    hyphenated: "c2416789-944c-b584-e886-ac162d9112b7",
    braced: "{c2416789-944c-b584-e886-ac162d9112b7}",
    urn: "urn:uuid:c2416789-944c-b584-e886-ac162d9112b7",
    bytes: [194, 65, 103, 137, 148, 76, 181, 132, 232, 134, 172, 22, 45, 145, 18, 183]),
  PreparedCase(
    uuid25: "0js3yf434vbqa069pkebbly89",
    hex: "0947fa843806088a77aa1b1ed69b7789",
    hyphenated: "0947fa84-3806-088a-77aa-1b1ed69b7789",
    braced: "{0947fa84-3806-088a-77aa-1b1ed69b7789}",
    urn: "urn:uuid:0947fa84-3806-088a-77aa-1b1ed69b7789",
    bytes: [9, 71, 250, 132, 56, 6, 8, 138, 119, 170, 27, 30, 214, 155, 119, 137]),
  PreparedCase(
    uuid25: "42ur2gf0i7xgtnlislvutk5fq",
    hex: "44e76ce21f2e77bdbadb64850026fd86",
    hyphenated: "44e76ce2-1f2e-77bd-badb-64850026fd86",
    braced: "{44e76ce2-1f2e-77bd-badb-64850026fd86}",
    urn: "urn:uuid:44e76ce2-1f2e-77bd-badb-64850026fd86",
    bytes: [68, 231, 108, 226, 31, 46, 119, 189, 186, 219, 100, 133, 0, 38, 253, 134]),
  PreparedCase(
    uuid25: "6ry55bbvow6mllk9nvfsd4w5f",
    hex: "7275ea4776280fa82afb0c4b47f148c3",
    hyphenated: "7275ea47-7628-0fa8-2afb-0c4b47f148c3",
    braced: "{7275ea47-7628-0fa8-2afb-0c4b47f148c3}",
    urn: "urn:uuid:7275ea47-7628-0fa8-2afb-0c4b47f148c3",
    bytes: [114, 117, 234, 71, 118, 40, 15, 168, 42, 251, 12, 75, 71, 241, 72, 195]),
  PreparedCase(
    uuid25: "1xl7tld67nekvdlrp0pkvsut5",
    hex: "20a6bddafff4faa14e8fc0eb75a169f9",
    hyphenated: "20a6bdda-fff4-faa1-4e8f-c0eb75a169f9",
    braced: "{20a6bdda-fff4-faa1-4e8f-c0eb75a169f9}",
    urn: "urn:uuid:20a6bdda-fff4-faa1-4e8f-c0eb75a169f9",
    bytes: [32, 166, 189, 218, 255, 244, 250, 161, 78, 143, 192, 235, 117, 161, 105, 249]),
]
