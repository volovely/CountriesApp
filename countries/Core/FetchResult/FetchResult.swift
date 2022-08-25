import Foundation

/// `FetchResult` is a data wrapper, that allows to understand in which way this data was collected
///  This could be especially useful if the user needs to be aware about the fact that data is *cached*
enum FetchResult<ResultType> {
  case actual(ResultType)
  case cached(ResultType)
}

extension FetchResult {
  /// The `value` could be used as a shortcut for `FetchResult` in the case you don't care about the data orign
  var value: ResultType {
    var res: ResultType
    switch self {
    case .actual(let result):
      res = result
    case .cached(let result):
      res = result
    }

    return res
  }
}
