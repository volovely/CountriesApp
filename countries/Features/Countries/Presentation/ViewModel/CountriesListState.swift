import Foundation

struct CountriesListState {
  let error: AppError?
  let countries: [Country]?
  let isLoading: Bool

  static func success(countries: [Country]) -> CountriesListState {
    CountriesListState(
      error: nil,
      countries: countries,
      isLoading: false
    )
  }

  static func fail(error: AppError) -> CountriesListState {
    CountriesListState(
      error: error,
      countries: nil,
      isLoading: false
    )
  }

  static func loading() -> CountriesListState {
    CountriesListState(
      error: nil,
      countries: nil,
      isLoading: true
    )
  }
}
