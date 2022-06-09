import Foundation

struct Request: Decodable {
    let area: String
    let date: Date
}

struct Response: Codable, Equatable {
    let weatherCondition: String
    let maxTemperature: Int
    let minTemperature: Int
    let date: Date
}

enum WeatherCondition: String, CaseIterable {
    case sunny
    case cloudy
    case rainy
}

public enum YumemiWeatherError: Swift.Error {
    case invalidParameterError
    case unknownError
}

final public class YumemiWeather {

    static let apiDuration: TimeInterval = 2

    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()

    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()

    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }()

    /// 引数の値でResponse構造体を作成する。引数がnilの場合はランダムに値を作成する。
    /// - Parameters:
    ///   - weatherCondition: 天気状況を表すenum
    ///   - maxTemperature: 最高気温
    ///   - minTemperature: 最低気温
    ///   - date: 日付
    ///   - seed: シード値
    /// - Returns: Response構造体

    static func makeRandomResponse(weatherCondition: WeatherCondition? = nil, maxTemperature: Int? = nil, minTemperature: Int? = nil, date: Date? = nil, seed: Int? = nil) -> Response {
        return makeRandomResponse(weatherCondition: weatherCondition, maxTemperature: maxTemperature, minTemperature: minTemperature, date: date, seed: seed ?? Int.random(in: Int.min...Int.max))
    }

    private static func makeRandomResponse(weatherCondition: WeatherCondition?, maxTemperature: Int?, minTemperature: Int?, date: Date?, seed seedValue: Int) -> Response {
        var seed = SeedRandomNumberGenerator(seed: seedValue)
        let weatherCondition = weatherCondition ?? WeatherCondition.allCases.randomElement(using: &seed)!
        let maxTemperature = maxTemperature ?? Int.random(in: 10...40, using: &seed)
        let minTemperature = minTemperature ?? Int.random(in: -40..<maxTemperature, using: &seed)
        let date = date ?? Date()

        return Response(
            weatherCondition: weatherCondition.rawValue,
            maxTemperature: maxTemperature,
            minTemperature: minTemperature,
            date: date
        )
    }

    /// 擬似 天気予報API Simple ver
    /// - Returns: 天気状況を表す文字列 "sunny" or "cloudy" or "rainy"
    public static func fetchWeatherCondition() -> String {
        return self.makeRandomResponse().weatherCondition
    }

    /// 擬似 天気予報API Throws ver
    /// - Parameters:
    ///   - area: 天気予報を取得する対象地域 example: "tokyo"
    /// - Throws: YumemiWeatherError
    /// - Returns: 天気状況を表す文字列 "sunny" or "cloudy" or "rainy"
    public static func fetchWeatherCondition(at area: String) throws -> String {
        if Int.random(in: 0...4) == 4 {
            throw YumemiWeatherError.unknownError
        }

        return self.makeRandomResponse().weatherCondition
    }

    /// 擬似 天気予報API Json ver
    /// - Parameter jsonString: 地域と日付を含むJson文字列
    /// example:
    /// {
    ///   "area": "tokyo",
    ///   "date": "2020-04-01T12:00:00+09:00"
    /// }
    /// - Throws: YumemiWeatherError パラメータが正常でもランダムにエラーが発生する
    /// - Returns: Json文字列
    /// example: {"max_temp":25,"date":"2020-04-01T12:00:00+09:00","min_temp":7,"weather":"cloudy"}
    public static func fetchWeather(_ jsonString: String) throws -> String {
        guard let requestData = jsonString.data(using: .utf8),
              let request = try? decoder.decode(Request.self, from: requestData) else {
            throw YumemiWeatherError.invalidParameterError
        }

        let response = makeRandomResponse(date: request.date)
        let responseData = try encoder.encode(response)

        if Int.random(in: 0...4) == 4 {
            throw YumemiWeatherError.unknownError
        }

        return String(data: responseData, encoding: .utf8)!
    }

    /// 擬似 天気予報API Sync ver
    /// - Parameter jsonString: 地域と日付を含むJson文字列
    /// example:
    /// {
    ///   "area": "tokyo",
    ///   "date": "2020-04-01T12:00:00+09:00"
    /// }
    /// - Throws: YumemiWeatherError パラメータが正常でもランダムにエラーが発生する
    /// - Returns: Json文字列
    public static func syncFetchWeather(_ jsonString: String) throws -> String {
        Thread.sleep(forTimeInterval: apiDuration)
        return try self.fetchWeather(jsonString)
    }

    /// 擬似 天気予報API Callback ver
    /// - Parameters:
    ///   - jsonString: 地域と日付を含むJson文字列
    /// example:
    /// {
    ///   "area": "tokyo",
    ///   "date": "2020-04-01T12:00:00+09:00"
    /// }
    ///   - completion: 完了コールバック
    public static func callbackFetchWeather(_ jsonString: String, completion: @escaping (Result<String, YumemiWeatherError>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + apiDuration) {
            do {
                let response = try fetchWeather(jsonString)
                completion(Result.success(response))
            }
            catch let error where error is YumemiWeatherError {
                completion(Result.failure(error as! YumemiWeatherError))
            }
            catch {
                fatalError()
            }
        }
    }

    /// 擬似 天気予報API Async ver
    /// - Parameter jsonString: 地域と日付を含むJson文字列
    /// example:
    /// {
    ///   "area": "tokyo",
    ///   "date": "2020-04-01T12:00:00+09:00"
    /// }
    /// - Throws: YumemiWeatherError パラメータが正常でもランダムにエラーが発生する
    /// - Returns: Json文字列
    @available(iOS 13, macOS 10.15, *)
    public static func asyncFetchWeather(_ jsonString: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            callbackFetchWeather(jsonString) { result in
                continuation.resume(with: result)
            }
        }
    }
}
