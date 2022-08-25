import Foundation

struct CountriesModule {
  let viewModel: CountriesViewModel

  init() {
    let errorMapper = WebErrorMapper()
    let remoteApi = URLSessionCountriesRemoteApi(errorMapper: errorMapper)
    let storageApi = UserDefaultsCountriesStorageApi()
    let repository = CountriesRepositoryImpl(remoteApi: remoteApi, storageApi: storageApi)
    let getUseCase = GetCountriesUseCaseImpl(countriesRepository: repository)
    viewModel = CountriesViewModel(getCountriesUseCase: getUseCase)
  }
}
