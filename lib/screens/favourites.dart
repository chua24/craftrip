import 'package:flutter/material.dart';
import 'destination_card.dart'; 
import 'package:craftrip_app/models/destination.dart';
import 'package:craftrip_app/services/collections.dart';


class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();

}

class _FavouriteState extends State<Favourite> {
  
  // Querying Destination objects from Firestore. 
  List<Destination> travelDestinations = Collections().getFavouritesData(); 
  // [
  //   Destination(city:'HAVANA', country:'CUBA', favourite: true, temperature: 36.42, exchangeRate: 2.62, currency: "PHP", imageURL: "https://i.pinimg.com/originals/38/ec/37/38ec376b794073fee036d897346f7de2.jpg"),
  // ];
 
  @override  
  Widget build(BuildContext context) {

  return Scaffold(
  
       body: 
       Column(
         children: <Widget> [

           SizedBox(height: 15.0), 

           Text("FAVOURTIES (" + travelDestinations.length.toString() + ")", 
           textAlign: TextAlign.center,
           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0), 
           
           ), 
           
           Expanded(

              child: ListView.builder(
              scrollDirection: Axis.vertical, 

              itemBuilder: (context, index){
                
                return DestinationCard(d: travelDestinations[index]);
                
              },
              itemCount: travelDestinations.length,),
          ),
        ] 
      )
    ); 
  }
}