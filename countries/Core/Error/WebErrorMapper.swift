import Foundation

class WebErrorMapper {
  func map(_ error: Error) -> WebError {

    // here should be mapping web errors to app errors, but for the sake of simplicity it's only one `WebError`
    return WebError()
  }
}
