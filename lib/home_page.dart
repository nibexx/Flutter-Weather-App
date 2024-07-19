import 'package:app/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// String Name  = "";
 final myController = TextEditingController();
final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY); //WE need weather factory to get access to the location
String _cityName = "Kollam";
 
 Weather? _weather; // this variable is going to store the weather data that we are getting from the weather api

@override
  void initState() {
    
    // TODO: implement initState
    super.initState();
    _fetchWeather(_cityName);
    // _wf.currentWeatherByCityName("Chennai").then((w) {
    //   setState(() {
    //     _weather = w;
    //   });
    // });
  }
  void _fetchWeather(String cityName){
         _wf.currentWeatherByCityName(cityName).then((w) {
       setState(() {
         _weather = w;
       });
     }).catchError((error)
     {
      print('the error is : $error');
     });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset : false,
      backgroundColor: const Color.fromARGB(255, 112, 145, 162),
      body: _buildUI(),
    );
}
Widget _buildUI(){
  if(_weather == null){
    return Center(
     child: CircularProgressIndicator(), // loading spinner
    );
      }
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisSize:MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSearch(),
              SizedBox(height: 15),      
           _locationHeader(),
          SizedBox(height: 7),
          _dateTimeInfo(),
            SizedBox(height: 7),
            _weatherIcon(),
            SizedBox(height: 10),
              _currentTemp(),
            SizedBox(height: 15),
            _extraInfo(),
        ],
      ),
    );

}
Widget _buildSearch(){
  
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: TextField(
     controller: myController,
     
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
        border: OutlineInputBorder(
          
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(width: 0.8, color: Colors.black),
          
          
        ),
        hintText: "Search the location",
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: (){
             print(myController.text);
          _fetchWeather(myController.text);
          },
        )
      ),
      onSubmitted: (String value) {
        _cityName = value;
        _fetchWeather(_cityName);
      },
    ),
  );
//   return SearchBar(
//     hintText: "Search Location",
//    actions[],
//     onSubmitted: (value){
//       print("value : " + value);
//       print("value : " + value);
//       print("value : " + value);
// print("value : " + value);
//     },
    
//   );
}

Widget _locationHeader(){
  return
  Text(_weather?.areaName ?? "",
  style: TextStyle(
     fontSize: 25,
    fontWeight: FontWeight.w700
  ),); // to display the area name and instead when "" is not defined
}
Widget _dateTimeInfo(){

  DateTime now = _weather!.date!; //It is used to tell the compiler that you are certain _weather and _weather.date are not null at runtime.
  return Column(
    children: [
  
    SizedBox(height: 8,),
   Row(
    mainAxisSize:MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
        Text(DateFormat('EEEE').format(now),
  
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w300
    ),
    ),
      SizedBox(height: 10,),
    Text(DateFormat('MMM d, HH:mm a').format(now),
  
    style: TextStyle(
      fontSize: 14,
      color: Color.fromARGB(255, 48, 28, 151)
    ),
    ),
    
    ],
   )
    ]
  );

}
Widget _weatherIcon(){
  return Column(
    mainAxisSize:MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png")
            )
        ),
      ),
      Text(_weather?.weatherDescription ?? "",
        style: TextStyle(
      fontSize: 13,
      color: Colors.black
    ),),
    ],
  );
}
Widget _currentTemp(){
  return Text("${_weather?.temperature?.celsius?.toStringAsFixed(0) }° C",
  style: TextStyle(
    fontSize: 70,
    fontWeight: FontWeight.w500
  ),); // we are giving ? because to show that the value is not null
}
Widget _extraInfo(){
  return Container(
    width: 350,
    height: 150,
    decoration: BoxDecoration(
      
      borderRadius: BorderRadius.circular(20),
      color: Colors.white.withOpacity(0.2)
    ),
    padding: EdgeInsets.all(15),
    child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
        Container(
          
          child:  Text("Humidity : ${_weather?.humidity?.toStringAsFixed(0)}",
        
          style: TextStyle(
            
            color: Colors.black,
                      fontSize: 16,
            fontWeight: FontWeight.bold
          ),),
         
        ),
        Container(
          child:  Text("Latitude : ${_weather?.latitude?.toStringAsFixed(0)}",
              style: TextStyle(
            color: Colors.black,
                      fontSize: 16,
            fontWeight: FontWeight.bold
          ),),
        ),
          ]
        ),
        Row(
              crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
               Container(
          child:  Text("Longitude : ${_weather?.longitude?.toStringAsFixed(0)}",
              style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),),
        ),
        Container(
          child:  Text("windSpeed : ${_weather?.windSpeed?.toStringAsFixed(0)}",
              style: TextStyle(
            color: Colors.black,
                      fontSize: 16,
            fontWeight: FontWeight.bold
          ),),
        ),
          ],
        )
           
     
      ]
    ),
  );
}
}