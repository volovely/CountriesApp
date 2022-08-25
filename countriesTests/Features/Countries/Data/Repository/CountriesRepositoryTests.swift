import XCTest

class CountriesRepositoryTests: XCTestCase {
  private var listOfCountries: [Country]!

  override func setUp() {
    super.setUp()

    listOfCountries = [
      Country(
        name: CountryName(official: "Official name1"),
        capital: [
          "One capital",
          "Second capital"
        ],
        population: 4_000_000_000,
        flags: CountryFlags(png: "https://utl.to.flag")
      ),
      Country(
        name: CountryName(official: "Official name2"),
        capital: [
          "One capital2",
          "Second capital2"
        ],
        population: 4_000_000_000,
        flags: CountryFlags(png: "https://utl.to.flag")
      )
    ]
  }

  func testOnLineBeahaviour() async {
    // Given
    let storageMock = CountriesStorageApiMock()
    let repository = CountriesRepositoryImpl(
      remoteApi: CountriesRemoteApiMock(result: listOfCountries),
      storageApi: storageMock
    )

    let expected = FetchResult.actual(listOfCountries!)

    // When
    let actual = try! await repository.getCountries()

    // Then
    switch actual {
    case .actual(let countries):
      XCTAssertEqual(countries, expected.value)
    case .cached(_):
      XCTFail()
    }
    XCTAssert(storageMock.wasWriteCalled)
  }

  func testOffLineBeahaviour_DataWasCached() async {
    // Given
    let storageMock = CountriesStorageApiMock(resultFromRead: listOfCountries)
    let repository = CountriesRepositoryImpl(
      remoteApi: CountriesRemoteApiMock(error: AppError()),
      storageApi: storageMock
    )

    let expected = FetchResult.cached(listOfCountries!)

    // When
    let actual = try! await repository.getCountries()

    // Then
    switch actual {
    case .actual(_):
      XCTFail()
    case .cached(let countries):
      XCTAssertEqual(countries, expected.value)
    }
  }

  func testOffLineBeahaviour_DataWasNotCached() async {
    // Given
    let expectedError = AppError()
    let storageMock = CountriesStorageApiMock()
    let repository = CountriesRepositoryImpl(
      remoteApi: CountriesRemoteApiMock(error: expectedError),
      storageApi: storageMock
    )

    // When
    do {
      _ = try await repository.getCountries()
    } catch is AppError {
      // Test passed
    } catch {
      XCTFail()
    }
  }
}

private struct CountriesRemoteApiMock: CountriesRemoteApi {
  let result: [Country]?
  let error: Error?

  init(
    result: [Country]? = nil,
    error: Error? = nil
  ) {
    self.result = result
    self.error = error
  }

  func fetch() async throws -> [Country] {
    if let result = result {
      return result
    } else {
      throw error!
    }
  }
}

private class CountriesStorageApiMock: CountriesStorageApi {
  var resultFromRead: [Country]?
  var wasWriteCalled: Bool = false

  init(
    resultFromRead: [Country]? = nil
  ) {
    self.resultFromRead = resultFromRead
  }

  func read() -> [Country]? {
    resultFromRead
  }

  func write(_ countries: [Country]) {
    wasWriteCalled = true
  }
}

