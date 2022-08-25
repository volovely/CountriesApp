import Foundation

class CountriesViewModel {
  weak var view: CountriesView?
  var state: CountriesState?

  private let getCountriesUseCase: GetCountriesUseCase

  init(getCountriesUseCase: GetCountriesUseCase) {
    self.getCountriesUseCase = getCountriesUseCase
  }

  func enterScreen() {
    fetchCountries()
  }

  func tryAagain() {
    fetchCountries()
  }

  private func fetchCountries() {
    updateState(CountriesState.loading())
    Task {
      do {
        let countries = try await getCountriesUseCase.getCountries().value
        updateState(CountriesState.success(countries: countries))
      } catch let error as AppError  {
        updateState(CountriesState.fail(error: error))
      }
    }
  }

  private func updateState(_ state: CountriesState) {
    self.state = state
    view?.notifyUpdateRequired()
  }
}
