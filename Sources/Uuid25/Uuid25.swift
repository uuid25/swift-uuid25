/// Primary value type containing the Uuid25 representation of a UUID.
public struct Uuid25: Hashable, LosslessStringConvertible {
  /// The 25-digit Uuid25 representation of `self`: `3ud3gtvgolimgu9lah6aie99o`.
  public let description: String

  /// Creates an instance from an array of Base36 digit values.
  init(digitValues: [UInt8]) throws {
    precondition(digitValues.count == 25, "invalid length of digit value array")
    description = String(
      cString: try [UInt8](unsafeUninitializedCapacity: 26) { buffer, initializedCount in
        buffer.initialize(repeating: 0)
        initializedCount = buffer.count
        for (i, e) in digitValues.enumerated() {
          if e >= digits.count {
            throw ParseError(debugMessage: "invalid digit value")
          }
          buffer[i] = digits[Int(e)]
        }
      }
    )
    if description > "f5lxx1zz5pnorynqglhzmsp33" {  // 2^128 - 1
      throw ParseError(debugMessage: "128-bit overflow")
    }
  }

  /// Creates an instance from a 16-byte UUID binary representation.
  public init(bytes: [UInt8]) {
    precondition(bytes.count == 16, "the length of byte array must be 16")
    try! self.init(digitValues: convertBase(src: bytes, srcBase: 256, dstBase: 36, dstSize: 25))
  }

  /// Converts `self` into the 16-byte binary representation of a UUID.
  public var bytes: [UInt8] {
    let src = try! decodeDigitChars(description, 36)
    return try! convertBase(src: src, srcBase: 36, dstBase: 256, dstSize: 16)
  }

  /// Creates an instance from a 16-byte UUID binary representation.
  public init(
    byteTuple: (
      UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
      UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8
    )
  ) {
    self.init(bytes: [
      byteTuple.0, byteTuple.1, byteTuple.2, byteTuple.3,
      byteTuple.4, byteTuple.5, byteTuple.6, byteTuple.7,
      byteTuple.8, byteTuple.9, byteTuple.10, byteTuple.11,
      byteTuple.12, byteTuple.13, byteTuple.14, byteTuple.15,
    ])
  }

  /// Converts `self` into the 16-byte binary representation of a UUID.
  public var byteTuple:
    (
      UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
      UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8
    )
  {
    let bs = bytes
    return (
      bs[0], bs[1], bs[2], bs[3], bs[4], bs[5], bs[6], bs[7],
      bs[8], bs[9], bs[10], bs[11], bs[12], bs[13], bs[14], bs[15]
    )
  }

  /// Creates an instance from a UUID string representation.
  ///
  /// This initializer accepts the following formats:
  ///
  /// - 25-digit Base36 Uuid25 format: `3ud3gtvgolimgu9lah6aie99o`
  /// - 32-digit hexadecimal format without hyphens: `40eb9860cf3e45e2a90eb82236ac806c`
  /// - 8-4-4-4-12 hyphenated format: `40eb9860-cf3e-45e2-a90e-b82236ac806c`
  /// - Hyphenated format with surrounding braces: `{40eb9860-cf3e-45e2-a90e-b82236ac806c}`
  /// - RFC 4122 URN format: `urn:uuid:40eb9860-cf3e-45e2-a90e-b82236ac806c`
  public init?(_ description: String) {
    try? self.init(parsing: description)
  }

  /// Equivalent to ``init(_:)``, but throws ``ParseError`` on failure.
  ///
  /// - Throws: ``ParseError`` if the argument is not a valid UUID string.
  public init(parsing uuidString: String) throws {
    switch uuidString.utf8.count {
    case 25:
      try self.init(uuid25: uuidString)
    case 32:
      try self.init(hex: uuidString)
    case 36:
      try self.init(hyphenated: uuidString)
    case 38:
      try self.init(braced: uuidString)
    case 45:
      try self.init(urn: uuidString)
    default:
      throw ParseError(debugMessage: "invalid length")
    }
  }

  /// Creates an instance from the 25-digit Base36 Uuid25 format: `3ud3gtvgolimgu9lah6aie99o`.
  ///
  /// - Throws: ``ParseError`` if the argument is not in the specified format.
  public init(uuid25 uuidString: String) throws {
    if uuidString.utf8.count != 25 {
      throw ParseError(debugMessage: "invalid length")
    }
    try self.init(digitValues: try decodeDigitChars(uuidString, 36))
  }

  /// Creates an instance from the 32-digit hexadecimal format without hyphens:
  /// `40eb9860cf3e45e2a90eb82236ac806c`.
  ///
  /// - Throws: ``ParseError`` if the argument is not in the specified format.
  public init(hex uuidString: String) throws {
    if uuidString.utf8.count != 32 {
      throw ParseError(debugMessage: "invalid length")
    }
    let src = try decodeDigitChars(uuidString, 16)
    try self.init(digitValues: try convertBase(src: src, srcBase: 16, dstBase: 36, dstSize: 25))
  }

  /// Creates an instance from the 8-4-4-4-12 hyphenated format:
  /// `40eb9860-cf3e-45e2-a90e-b82236ac806c`.
  ///
  /// - Throws: ``ParseError`` if the argument is not in the specified format.
  public init(hyphenated uuidString: String) throws {
    if uuidString.utf8.count != 36 {
      throw ParseError(debugMessage: "invalid length")
    }

    var buffer = [UInt8]()
    buffer.reserveCapacity(33)
    for (i, e) in uuidString.utf8.enumerated() {
      if i == 8 || i == 13 || i == 18 || i == 23 {
        if e != UInt8(ascii: "-") {
          throw ParseError(debugMessage: "invalid hyphenated format")
        }
      } else if e > 0x7f {
        throw ParseError(debugMessage: "non-ASCII digit")
      } else {
        buffer.append(e)
      }
    }
    buffer.append(0)
    try self.init(hex: String(cString: buffer))
  }

  /// Creates an instance from the hyphenated format with surrounding braces:
  /// `{40eb9860-cf3e-45e2-a90e-b82236ac806c}`.
  ///
  /// - Throws: ``ParseError`` if the argument is not in the specified format.
  public init(braced uuidString: String) throws {
    if uuidString.count != 38 || !uuidString.hasPrefix("{") || !uuidString.hasSuffix("}") {
      throw ParseError(debugMessage: "invalid braced format")
    }

    try self.init(hyphenated: String(uuidString.dropFirst(1).dropLast(1)))
  }

  /// Creates an instance from the RFC 4122 URN format:
  /// `urn:uuid:40eb9860-cf3e-45e2-a90e-b82236ac806c`.
  ///
  /// - Throws: ``ParseError`` if the argument is not in the specified format.
  public init(urn uuidString: String) throws {
    if uuidString.count != 45 || uuidString.prefix(9).lowercased() != "urn:uuid:" {
      throw ParseError(debugMessage: "invalid urn format")
    }

    try self.init(hyphenated: String(uuidString.dropFirst(9)))
  }

  /// Formats `self` in the 32-digit hexadecimal format without hyphens:
  /// `40eb9860cf3e45e2a90eb82236ac806c`.
  public var hex: String {
    var buffer = ""
    buffer.reserveCapacity(36)  // over-allocate (with toHyphenated() in mind)
    for e in bytes {
      if e < 0x10 {
        buffer.append("0")
      }
      buffer.append(String(e, radix: 16))
    }
    return buffer
  }

  /// Formats `self` in the 8-4-4-4-12 hyphenated format: `40eb9860-cf3e-45e2-a90e-b82236ac806c`.
  public var hyphenated: String {
    var s = hex
    s.insert("-", at: s.index(s.startIndex, offsetBy: 8))
    s.insert("-", at: s.index(s.startIndex, offsetBy: 13))
    s.insert("-", at: s.index(s.startIndex, offsetBy: 18))
    s.insert("-", at: s.index(s.startIndex, offsetBy: 23))
    return s
  }

  /// Formats `self` in the hyphenated format with surrounding braces:
  /// `{40eb9860-cf3e-45e2-a90e-b82236ac806c}`.
  public var braced: String {
    return "{" + hyphenated + "}"
  }

  /// Formats `self` in the RFC 4122 URN format: `urn:uuid:40eb9860-cf3e-45e2-a90e-b82236ac806c`.
  public var urn: String {
    return "urn:uuid:" + hyphenated
  }
}

extension Uuid25: Comparable {
  public static func < (lhs: Uuid25, rhs: Uuid25) -> Bool {
    return lhs.description < rhs.description
  }
}

extension Uuid25: Codable {
  /// Encodes the object as a 12-digit canonical string representation.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(description)
  }

  /// Decodes the object from a string representation or  a 16-byte big-endian byte array.
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let strValue = try? container.decode(String.self) {
      do {
        try self.init(parsing: strValue)
      } catch is ParseError {
        throw DecodingError.dataCorruptedError(
          in: container, debugDescription: "could not parse string as UUID")
      }
    } else if let byteArray = try? container.decode([UInt8].self) {
      if byteArray.count == 16 {
        self.init(bytes: byteArray)
      } else if byteArray.allSatisfy({ $0 < 0x80 }) {
        let strValue = String(cString: byteArray + [0])
        do {
          try self.init(parsing: strValue)
        } catch is ParseError {
          throw DecodingError.dataCorruptedError(
            in: container, debugDescription: "could not parse byte array as UUID")
        }
      } else {
        throw DecodingError.dataCorruptedError(
          in: container, debugDescription: "could not parse byte array as UUID")
      }
    } else {
      throw DecodingError.dataCorruptedError(
        in: container, debugDescription: "expected string or byte array but found neither")
    }
  }
}

/// Error parsing a UUID string representation.
public struct ParseError: Error {
  let debugMessage: String
}

/// Digit characters used in the Base36 notation.
let digits = [UInt8]("0123456789abcdefghijklmnopqrstuvwxyz".utf8)

/// Converts a digit value array in `srcBase` to that in `dstBase`.
func convertBase(src: [UInt8], srcBase: UInt, dstBase: UInt, dstSize: Int) throws -> [UInt8] {
  precondition(2 <= srcBase && srcBase <= 256 && 2 <= dstBase && dstBase <= 256, "invalid base")

  // determine the number of `src` digits to read for each outer loop
  var wordLen = 1
  var wordBase = srcBase
  while wordBase <= UInt.max / (srcBase * dstBase) {
    wordLen += 1
    wordBase *= srcBase
  }

  var dst = [UInt8](repeating: 0, count: dstSize)

  let srcSize = src.count
  if srcSize == 0 {
    return dst
  } else if dstSize == 0 {
    throw ParseError(debugMessage: "too small dst")
  }

  var dstUsed = dstSize - 1  // storage to memorize range of `dst` filled

  // read `wordLen` digits from `src` for each outer loop
  var wordHead = srcSize % wordLen
  if wordHead > 0 {
    wordHead -= wordLen
  }
  while wordHead < srcSize {
    var carry: UInt = 0
    for i in max(0, wordHead)..<(wordHead + wordLen) {
      precondition(src[i] < srcBase, "invalid src digit")
      carry = carry * srcBase + UInt(src[i])
    }

    // fill in `dst` from right to left, while carrying up prior result to left
    for i in (0..<dstSize).reversed() {
      carry += UInt(dst[i]) * wordBase
      let (quo, rem) = carry.quotientAndRemainder(dividingBy: dstBase)
      dst[i] = UInt8(truncatingIfNeeded: rem)
      carry = quo

      // break inner loop when `carry` and remaining `dst` digits are all zero
      if carry == 0 && i <= dstUsed {
        dstUsed = i
        break
      }
    }
    if carry > 0 {
      throw ParseError(debugMessage: "too small dst")
    }

    wordHead += wordLen
  }

  return dst
}

/// O(1) map from ASCII code points to Base36 digit values.
let decodeMap: [UInt8] = [
  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
  0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
  0xff, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
  0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x20, 0x21, 0x22, 0x23, 0xff, 0xff, 0xff, 0xff, 0xff,
  0xff, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
  0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x20, 0x21, 0x22, 0x23, 0xff, 0xff, 0xff, 0xff, 0xff,
  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
]

/// Converts from a string of digit characters to an array of digit values.
func decodeDigitChars(_ digitChars: String, _ base: UInt8) throws -> [UInt8] {
  precondition(2 <= base && base <= 36, "invalid base")
  return try digitChars.utf8.map {
    let e = decodeMap[Int($0)]
    if e >= base {
      throw ParseError(debugMessage: "invalid digit character")
    }
    return e
  }
}
