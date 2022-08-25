import Foundation

struct CountriesState {
  let error: AppError?
  let countries: [Country]?
  let isLoading: Bool

  static func success(countries: [Country]) -> CountriesState {
    CountriesState(
      error: nil,
      countries: countries,
      isLoading: false
    )
  }

  static func fail(error: AppError) -> CountriesState {
    CountriesState(
      error: error,
      countries: nil,
      isLoading: false
    )
  }

  static func loading() -> CountriesState {
    CountriesState(
      error: nil,
      countries: nil,
      isLoading: true
    )
  }
}
