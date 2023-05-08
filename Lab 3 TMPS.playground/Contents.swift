protocol WeatherData {
    func getCurrentTemperature() -> Double
    func getCurrentHumidity() -> Double
    func getCurrentWeatherConditions() -> String
}

class WeatherAPIAdapter: WeatherData {
    private let weatherAPI: WeatherAPI
    
    init(weatherAPI: WeatherAPI) {
        self.weatherAPI = weatherAPI
    }
    
    func getCurrentTemperature() -> Double {
        return weatherAPI.getTemperature()
    }
    
    func getCurrentHumidity() -> Double {
        return weatherAPI.getHumidity()
    }
    
    func getCurrentWeatherConditions() -> String {
        return weatherAPI.getConditions()
    }
}

protocol WeatherDisplay {
    func displayTemperature(_ temperature: Double)
    func displayHumidity(_ humidity: Double)
    func displayWeatherConditions(_ conditions: String)
}

class WeatherDisplayBridge {
    private let weatherDisplay: WeatherDisplay
    
    init(weatherDisplay: WeatherDisplay) {
        self.weatherDisplay = weatherDisplay
    }
    
    func displayWeatherData(_ weatherData: WeatherData) {
        weatherDisplay.displayTemperature(weatherData.getCurrentTemperature())
        weatherDisplay.displayHumidity(weatherData.getCurrentHumidity())
        weatherDisplay.displayWeatherConditions(weatherData.getCurrentWeatherConditions())
    }
}

class WeatherDataDecorator: WeatherData {
    private let baseWeatherData: WeatherData
    
    init(baseWeatherData: WeatherData) {
        self.baseWeatherData = baseWeatherData
    }
    
    func getCurrentTemperature() -> Double {
        return baseWeatherData.getCurrentTemperature()
    }
    
    func getCurrentHumidity() -> Double {
        return baseWeatherData.getCurrentHumidity()
    }
    
    func getCurrentWeatherConditions() -> String {
        return baseWeatherData.getCurrentWeatherConditions()
    }
    
    func getCurrentWindSpeed() -> Double {
        return 10.0 // Assume a constant wind speed of 10 mph
    }
    
    func getCurrentPressure() -> Double {
        return 1013.25 // Assume a constant pressure of 1013.25 hPa
    }
    
    func getCurrentUVIndex() -> Double {
        return 5.0 // Assume a constant UV index of 5
    }
}

class WeatherDataProxy: WeatherData {
    private let baseWeatherData: WeatherData
    private var cachedTemperature: Double?
    private var cachedHumidity: Double?
    private var cachedConditions: String?
    private var lastUpdated: Date?
    
    init(baseWeatherData: WeatherData) {
        self.baseWeatherData = baseWeatherData
    }
    
    func getCurrentTemperature() -> Double {
        if let temperature = cachedTemperature, let lastUpdated = lastUpdated, Date().timeIntervalSince(lastUpdated) < 60 {
            return temperature
        } else {
            let temperature = baseWeatherData.getCurrentTemperature()
            cachedTemperature = temperature
            lastUpdated = Date()
            return temperature
        }
    }
    
    func getCurrentHumidity() -> Double {
        if let humidity = cachedHumidity, let lastUpdated = lastUpdated, Date().timeIntervalSince(lastUpdated) < 60 {
            return humidity
        } else {
            let humidity = baseWeatherData.getCurrentHumidity()
            cachedHumidity = humidity
            lastUpdated = Date()
            return humidity
        }
    }
    
    func getCurrentWeatherConditions() -> String {
        if let conditions = cachedConditions, let lastUpdated = lastUpdated, Date().timeIntervalSince(lastUpdated) < 60 {
            return conditions
        } else {
            let conditions = baseWeatherData.getCurrentWeatherConditions()
            cachedConditions = conditions
            lastUpdated = Date()
            return conditions
        }
    }
}
