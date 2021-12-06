
const String dbName = "places.db";

const String places = "places";



const String userPlaces = "user_places";
const String placesId = "id";
const String placesTitle = "title";
const String placesImage = "image";

const String sqlPlaces = """
        CREATE TABLE 
          $userPlaces(
            $placesId TEXT PRIMARY KEY, 
            $placesTitle TEXT, 
            $placesImage TEXT
          )
      """;


