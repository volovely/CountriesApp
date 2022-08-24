//
//  ViewController.swift
//  countries
//
//  Created by roman on 24.08.2022.
//

import UIKit

class CountriesViewController: UIViewController {

  @IBAction func fetchCountriesTap(_ sender: UIButton) {
    let errorMapper = WebErrorMapper()
    let remoteApi = URLSessionCountriesRemoteApi(errorMapper: errorMapper)

    let storageApi = UserDefaultsCountriesStorage()

    let repository = CountriesRepository(remoteApi: remoteApi, storageApi: storageApi)
    Task {
      do {
        let countries = try await repository.getCountries()
        print(countries)
      } catch {
        print(error)
      }
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }


}

