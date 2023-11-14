# App Design Notes
### Views
- HomeView
  - App title
  - Device ON/OFF status
  - View data button (DataView)
  - Settings button (DebugView)
- DataView
  - Show map with user's location by using MapKit library
  - Use getUserLocation()
- DebugView
### Models
- AppModel
  - Everything(?)
  - Will need to record and store data in the form of (CLLocation,int) pairs in a HashMap
- LocationHandler
  - CoreLocation library framework
  - getUserLocation(completion: @escaping ((CLLocation) -> void))

Need to add "Privacy - Location When In Usage Description (maybe a different one if we want background tracking while app is open?)

Links:
- https://www.youtube.com/watch?v=MNF13IEn6vI
- https://developer.apple.com/documentation/corelocation/cllocation
- https://realm.io/best-ios-database/
- https://www.mongodb.com/databases/what-is-an-object-oriented-database?_ga=2.49260454.1682316564.1699321288-1476251518.1699321288
- https://gis.stackexchange.com/questions/90/choosing-database-for-storing-spatial-data#:~:text=PostGIS%20is%20certainly%20the%20best,topology%2C%20I%20would%20advice%20Gothic.&text=The%20most%20popular%20in%20the,most%20advanced%20opensource%20Spatial%20DB.
