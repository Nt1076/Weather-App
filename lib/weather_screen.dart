import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/secrets.dart';


import 'package:weather_app/aditional_info_item.dart';
import 'package:weather_app/hourly_forcast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String,dynamic>> weather;








  Future<Map<String,dynamic>> getCurrentWeather()async{
    try{

    String cityName ="London";
      final res = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApi')
    );

    final data=    jsonDecode(res.body);

    if(data['cod']!= '200'){
      throw 'an unexpected error';
    }

    return data;

      
      
    
    
    
    }
    catch(e){
      throw e.toString();
    }
    
    
  
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     weather=getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:const Text("Weather App",
        style:TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold
        )
         ,),
         centerTitle: true
          ,
         actions: [
         IconButton(onPressed:(){
          setState(() {
            weather= getCurrentWeather();
            
          });
         }, 
         icon:const Icon(Icons.refresh))
         ],
      ),
      body: FutureBuilder(
        future: weather,
       builder:(context, snapshot) {
        
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator()
            );
        }

        if(snapshot.hasError){
          return Center(child: Text(snapshot.error.toString()
          )
          );
        }
          final data =snapshot.data!;
          final weatherData =data['list'][0];

          final currentTemp=  weatherData['main']['temp'];

          final currentSky = weatherData['weather'][0]['main'];
          final currentPressure = weatherData['main']['pressure'];
          final currentHumidity = weatherData['main']['humidity'];
          final currentWindSpeed = weatherData['wind']['speed'];

        /*  final  hourlyData1= data ['list'][1];
          final  hourluTemp = hourlyData1['main']['temp'];
          final hourlyIcon = hourlyData1['weather'][0]['main'];

          final  hourlyData2= data ['list'][2];



           final  hourlyData3= data ['list'][3];


          final  hourlyData4= data ['list'][4];


          final  hourlyData5= data ['list'][5];*/



        
         return Padding(
             
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             SizedBox(
              width: double.infinity,
               child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX:10,sigmaY: 10 ),
                    child:  Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children:[
                          Text('$currentTemp k',
                          style: TextStyle(
                            fontSize: 32
                         , fontWeight: FontWeight.bold),
                          ),SizedBox(
                            height: 16,
                          ),
                          Icon( currentSky=='Clouds'||currentSky=='Rain'?Icons.cloud:   Icons.cloud,size: 65,),
                          SizedBox(
                            height: 16,
                          ),
                          Text('$currentSky',
                          style: TextStyle(
                            fontSize: 20
                          ),),
                          
                        ],
                      ),
                    ),
                  ),
                ),
             
               ),
             ),
             
            const SizedBox(height: 20,),
             const Text('Hourly Forcast ',
              style: TextStyle(
               fontSize: 24,
               fontWeight: FontWeight.bold 
              ),
              ),
              const SizedBox(height: 20,)
              /* SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:[
                    for(int i=0;i<5;i++)
                     
                 HourlyForcastItem(
                  icon:data['list'][i+1]['weather'][0]['main']=='Clouds'||data['list'][i+1]['weather'][0]['main']=='Rain'?Icons.cloud :Icons.sunny,
                  time: data['list'][i+1]['dt_txt'],
                  temp: data['list'][i+1]['main']['temp'].toString(),),
               
                  ],
                ),
              )*/

             ,SizedBox(
              height: 120,
               child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((context, index) {
                  final hourlyForcast =data['list'][index+1];
                  final time= DateTime.parse(hourlyForcast['dt_txt']);
                  return HourlyForcastItem(
                    icon: hourlyForcast['weather'][0]['main']=='Clouds'||data['list'][index+1]['weather'][0]['main']=='Rain'?Icons.cloud :Icons.sunny, 
                    temp:DateFormat.j().format(time), 
                    time: hourlyForcast['main']['temp'].toString());
             
             
                })),
             )
              
              ,const SizedBox(height: 20,),
             const  Text('Additional Information ',
              style: TextStyle(
               fontSize: 24,
               fontWeight: FontWeight.bold 
              ),
              ),
            const  SizedBox(height: 8,),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                
                children:[
                   AditionalInfoItem(icon: Icons.water_drop,label: 'Humidity',value: currentHumidity.toString()),
                   AditionalInfoItem(icon: Icons.air,label: 'Wind Speed',value: currentWindSpeed.toString()),
                   AditionalInfoItem(icon: Icons.beach_access,label: 'Pressure',value: currentPressure.toString(),),
                  
                  
                   
                ],
              )
              
            ],
          ),
        );
       },
      ),
    );
  }
}

