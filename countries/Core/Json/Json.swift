import Foundation

/// This class is responsible for stroring `JSONEncoder` and `JSONDecoder`
/// to make sure they have the same config all around the app
class Json {
  static var encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    return encoder
  }()

  static let decoder = JSONDecoder()
}
