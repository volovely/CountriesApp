import XCTest
@testable import countries

class CountryModelTests: XCTestCase {

  func testSerialization() {
    // Given
    let country = Country(
      name: CountryName(official: "Official name"),
      capital: [
        "One capital",
        "Second capital"
      ],
      population: 4_000_000_000,
      flags: CountryFlags(png: "https://url.to.flag")
    )

    let expectedSting = """
    {
      "flags" : {
        "png" : "https:\\/\\/url.to.flag"
      },
      "capital" : [
        "One capital",
        "Second capital"
      ],
      "name" : {
        "official" : "Official name"
      },
      "population" : 4000000000
    }
    """

    // When
    let actualData = try! Json.encoder.encode(country);
    let actualString = String(data: actualData, encoding: .utf8)!

    // Then
    XCTAssertEqual(actualString, expectedSting)
  }

  func testDeserialization() {
    // Given
    let countryString = """
    {
      "flags" : {
        "png" : "https:\\/\\/url.to.flag"
      },
      "capital" : [
        "One capital",
        "Second capital"
      ],
      "name" : {
        "official" : "Official name"
      },
      "population" : 4000000000
    }
    """
    let coundtryData = countryString.data(using: .utf8)!

    let expected = Country(
      name: CountryName(official: "Official name"),
      capital: [
        "One capital",
        "Second capital"
      ],
      population: 4_000_000_000,
      flags: CountryFlags(png: "https://url.to.flag")
    )

    // When
    let actual = try! Json.decoder.decode(Country.self, from: coundtryData);

    // Then
    XCTAssertEqual(actual, expected)
  }
}
