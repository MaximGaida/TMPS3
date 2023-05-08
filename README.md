
## Ideea de a crea o aplicație meteo care să primească date de la un API meteo și să afișeze vremea curentă pentru o anumită locație este o idee bună din mai multe motive:
#### 1.Util pentru viața de zi cu zi: informațiile despre vreme sunt o parte esențială a rutinei noastre zilnice, iar o aplicație simplă care oferă informații exacte despre vreme poate fi extrem de utilă.

#### 2.Bază largă de utilizatori: aplicațiile meteo au o bază largă de utilizatori, deoarece sunt folosite de oameni din întreaga lume. Acest lucru îl face un proiect excelent pentru a lucra, deoarece poate ajunge la un număr mare de utilizatori.

#### 3.Integrare cu API-uri: integrarea cu un API meteo face aplicația mai fiabilă, deoarece API-ul oferă date meteo actualizate și precise. Acest lucru scutește dezvoltatorul de problemele de a colecta și procesa manual datele meteo.

#### 4.Oportunitate de învățare: Dezvoltarea unei aplicații meteo poate fi o oportunitate excelentă de învățare pentru dezvoltatorii care doresc să-și îmbunătățească abilitățile în domenii precum integrarea API-ului, analiza datelor și proiectarea interfeței cu utilizatorul.

## 1.Adapter Pattern:
Pentru a prelua date meteo din API, putem folosi un model de adaptor pentru a converti interfața API-ului în propria noastră interfață. Putem crea o interfață numită „WeatherData” care definește metode pentru obținerea temperaturii, umidității și condițiilor meteo curente. Apoi, putem crea o clasă de adaptor care preia datele API-ului meteo și le adaptează la interfața noastră WeatherData.

      // Definiți un protocol numit WeatherData care are trei metode pentru a obține temperatura curentă, 
        umiditatea actuală și condițiile meteorologice curente
        
            protocol WeatherData {
                func getCurrentTemperature() -> Double
                func getCurrentHumidity() -> Double
                func getCurrentWeatherConditions() -> String
            }
        
       // Definiți o clasă numită WeatherAPIAdapter care este conformă cu protocolul WeatherData
       // Are o proprietate privată numită weatherAPI de tip WeatherAPI
        
            class WeatherAPIAdapter: WeatherData {
                private let weatherAPI: WeatherAPI
            
       // Definiți un inițializator care ia o instanță a WeatherAPI ca parametru
       // Acest inițializator setează proprietatea weatherAPI la valoarea parametrului
       
                init(weatherAPI: WeatherAPI) {
                    self.weatherAPI = weatherAPI
                }
            
      // Implementează metoda getCurrentTemperature a protocolului WeatherData
      // Această metodă returnează temperatura apelând metoda getTemperature a proprietății weatherAPI
      
                func getCurrentTemperature() -> Double {
                    return weatherAPI.getTemperature()
                }
            
      // Implementați metoda getCurrentHumidity a protocolului WeatherData
      // Această metodă returnează umiditatea apelând metoda getHumidity a proprietății weatherAPI
      
                func getCurrentHumidity() -> Double {
                    return weatherAPI.getHumidity()
                }

      // Implementați metoda getCurrentWeatherConditions a protocolului WeatherData
      // Această metodă returnează condițiile meteo prin apelarea metodei getConditions a proprietății weatherAPI

                func getCurrentWeatherConditions() -> String {
                    return weatherAPI.getConditions()
                }
            }
        
## 2.Bridge Pattern:
Pentru a afișa datele meteo, putem folosi un model de punte pentru a separa abstracția de implementare. Putem crea o interfață numită „WeatherDisplay” care definește metode de afișare a temperaturii, umidității și condițiilor meteo curente. Apoi, putem crea diferite clase pentru fiecare tip de afișaj (de exemplu, iPhoneDisplay, AppleWatchDisplay etc.) care implementează propriile metode de afișare. În cele din urmă, putem crea o clasă bridge care preia oricare dintre clasele de afișare a vremii și le adaptează la interfața WeatherDisplay.

      // Declarație de protocol pentru afișarea vremii
              protocol WeatherDisplay {
                  func displayTemperature(_ temperature: Double)
                  func displayHumidity(_ humidity: Double)
                  func displayWeatherConditions(_ conditions: String)
              }
      // Clasa de afișare a vremii
              class WeatherDisplayBridge {
                  private let weatherDisplay: WeatherDisplay

                  init(weatherDisplay: WeatherDisplay) {
                      self.weatherDisplay = weatherDisplay
                  }
      // Metodă de afișare a datelor meteo folosind obiectul de afișare a vremii
              func displayWeatherData(_ weatherData: WeatherData) {
                      weatherDisplay.displayTemperature(weatherData.getCurrentTemperature())
                      weatherDisplay.displayHumidity(weatherData.getCurrentHumidity())
                      weatherDisplay.displayWeatherConditions(weatherData.getCurrentWeatherConditions())
                  }
              }

## 3.Decorator Pattern: 
Pentru a adăuga funcționalități suplimentare aplicației meteo, putem folosi un model de decorator pentru a adăuga în mod dinamic funcții noi. Putem crea o clasă de decorator numită „WeatherDataDecorator” care preia un obiect WeatherData și adaugă noi metode pentru a obține viteza curentă a vântului, presiunea și indicele UV.

      // Definiți o nouă clasă numită WeatherDataDecorator care extinde WeatherData
      
              class WeatherDataDecorator: WeatherData {
                  private let baseWeatherData: WeatherData
                  
      // Definiți un inițializator care acceptă un parametru numit baseWeatherData de tip WeatherData
      
                  init(baseWeatherData: WeatherData) {
                      self.baseWeatherData = baseWeatherData
                  }
                  
      // Definiți o funcțiile de baza a functionalului 
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

## 4.Proxy Pattern:
Pentru a accelera aplicația meteo, putem folosi un model proxy pentru a stoca în cache datele meteo care au fost deja preluate. Putem crea o clasă proxy numită „WeatherDataProxy” care preia un obiect WeatherData și memorează în cache datele pentru o anumită perioadă de timp. Dacă datele au fost deja stocate în cache, proxy-ul returnează datele din cache în loc să facă un alt apel API.

    // Acest cod definește o clasă numită WeatherDataProxy, care este o subclasă a clasei WeatherData.
    
              class WeatherDataProxy: WeatherData {
                  private let baseWeatherData: WeatherData
                  private var cachedTemperature: Double?
                  private var cachedHumidity: Double?
                  private var cachedConditions: String?
                  private var lastUpdated: Date?

                  init(baseWeatherData: WeatherData) {
                      self.baseWeatherData = baseWeatherData
                  }
                  
    // Clasa WeatherDataProxy acționează ca un proxy între clasa WeatherData și client, 
    // oferind un mecanism de stocare în cache pentru a minimiza numărul de solicitări API făcute de client.
    
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
