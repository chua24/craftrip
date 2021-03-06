import 'dart:core';
import 'package:flutter/material.dart';
import 'package:craftrip_app/models/flightsData.dart';
import 'package:craftrip_app/services/flightsController.dart';

class FlightsPage extends StatefulWidget {    //Flights Page show the flights and prices of the depDate to retDate

  final String depDate;
  final String retDate;
  final String cityID;
  FlightsPage(this.depDate, this.retDate, this.cityID);
  @override
  FlightsUIPage createState() => FlightsUIPage(depDate,retDate, cityID);
}

class FlightsUIPage extends State<FlightsPage> {
//  List<Itineraries> listOfItineraries = [];
  FlightsManager flightsManager = FlightsManager();

  final String depDate;
  final String retDate;
  final String cityID;
  FlightsUIPage(this.depDate, this.retDate, this.cityID);

  bool economyPress = false;
  bool businessPress = false;
  bool firstPress = false;
  String _selectedSort;
  String cabinClass = 'economy';

  List<String> _sortOptions = ['Relevance',
    'Price-Low To High',
    'Price- High To Low',
    'Flight Time - Morning',
    'Flight Time - Afternoon',
    'Flight Time - Evening',
    'Flight Time - Night'];


  void showBusiness() {
    setState(() => businessPress = !businessPress);
    if (firstPress) { // toggle so if business is pressed, first has to disable
      setState(() => firstPress = !firstPress);
    }
    else if (economyPress) {
      setState(() => economyPress = !economyPress);
    }
    cabinClass = 'business';
    print("Business Class!");
  }

  void showEconomy() {
    setState(() => economyPress = !economyPress);

    if (firstPress) {
      setState(() => firstPress = !firstPress);
    }
    else if (businessPress) {
      setState(() => businessPress = !businessPress);
    }
    cabinClass = 'economy';
    print("Economy Class!");
  }

  void showFirst() {
    setState(() => firstPress = !firstPress);
    if (businessPress) {
      setState(() => businessPress = !businessPress);
    }
    else if (economyPress) {
      setState(() => economyPress = !economyPress);
    }
    cabinClass = 'first';
    print("First Class!");
  }


  @override
  void initState() {
    //to insert object into widget tree
    super.initState();
    cabinClass = 'economy';

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize( //App Bar
        preferredSize: Size.fromHeight(65.0),
        child: AppBar(
          backgroundColor: Color(0xff2675eb),
          title: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                      'FLIGHTS PRICES',
                      style: TextStyle(
                          fontSize: 28.0,
                          letterSpacing: 1.5,
                          color: Colors.white,
                          fontWeight: FontWeight.w400
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                      width: 30.0,
                      //height: MediaQuery.of(context).size.height * 0.08,
                      //width: MediaQuery.of(context).size.width * 0.18, // fixed width and height
//                      child: Image.asset('assets/TravelDiaryIcon.png'),
                    ),
                    Text('CrafTrip',
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.white
                        )),
                  ],),
              ],),
          ),
        ),),

      body: Column(

//          mainAxisAlignment:MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(height: 20.0),

            Row(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly ,
              children: <Widget>[

                Text(
                  depDate,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.right,
                ),

                SizedBox(
                    height: 25,
                    width: 30,
                    child: Image.asset('assets/change.png')),

                Text(
                  retDate,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.right,
                ),


              ],

            ),
            SizedBox(height: 20.0),


//
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 150.0, 0  ),
              child: Text( "Select a Cabin Class ",
                style: TextStyle(
                    fontSize: 19.0,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic
                ),

              ),
            )
            ,
            SizedBox(height: 5.0),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    padding: const EdgeInsets.all(5.0),
                    textColor: Colors.white,
                    color: economyPress ? Colors.black12 : Colors.blue,
                    onPressed: () => showEconomy(),
                    child: new Text("Economy"),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.all(5.0),
                    textColor: Colors.white,
                    color: businessPress ? Colors.black12 : Colors.blue,
                    onPressed: showBusiness,
                    child: new Text("Business"),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.all(5.0),
                    textColor: Colors.white,
                    color: firstPress ? Colors.black12 : Colors.blue,
                    onPressed: showFirst,
                    child: new Text("First"),
                  ),
                ]),

            DropdownButton(
              hint: Text('SORT BY: Relevance'), // Not necessary for Option 1
              value: _selectedSort,
              onChanged: (newValue) {
                setState(() {
                  _selectedSort = newValue;
                  print(_selectedSort);
                  flightsManager.sort(_selectedSort);
                });
              },
              items: _sortOptions.map((options) {
                return DropdownMenuItem(
                  child: new Text(options),
                  value: options,
                );
              }).toList(),
            ),
            SizedBox(
              height: 300,
              width: 480,
              child: FutureBuilder(
                  future: flightsManager.makePostRequest(depDate,retDate,cityID,cabinClass),
                  builder: (context, snapshot) {
                    return flightsManager.listOfItineraries != null
                        ? listViewWidget(flightsManager.listOfItineraries)
                        : Center(child: CircularProgressIndicator());
                  }),
            ),
          ]),

      bottomNavigationBar: SizedBox( //Bottom Navigation Bar
        height: 75.0,
        child: Theme(
            data: Theme.of(context)
                .copyWith( // sets the background color of the `BottomNavigationBar`
                canvasColor: Colors.black,
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: Color(0xff2675eb),
                textTheme: Theme
                    .of(context)
                    .textTheme
                    .copyWith(caption: new TextStyle(color: Colors.yellow))),
            // sets the inactive color of the `BottomNavigationBar`
            child: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              //onTap: onTabTapped, // new
              //currentIndex: _currentIndex, // new
              items: [
                new BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 40.0,),
                  title: Text(""),
                ),
                new BottomNavigationBarItem(
                  icon: Icon(Icons.history,
                    size: 45.0,),
                  title: Text(""),
                ),
                new BottomNavigationBarItem(
                  icon: Icon(Icons.beenhere, size: 40.0,),
                  title: Text(""),
                ),
                new BottomNavigationBarItem(
                  icon: Icon(Icons.favorite, size: 40.0,),
                  title: Text(""),
                )
              ],
            )),
      ),
    );
  }
  Widget listViewWidget(List<Itineraries> flightsData) {
    return Container(
        child: ListView.builder(
            itemCount: flightsData.length,
            padding: const EdgeInsets.all(2.0),
            itemBuilder: (context, position) {
              return SizedBox(
                  height: 290,
                  width: 480,
                  child: Card(
                    elevation: 3.5,
                    margin: EdgeInsets.all(10.0),

                    child:
                    Column(
                        children: <Widget>[


                          SizedBox(height: 20),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SizedBox(
                                  width: 75,
                                  height: 42,
                                  child: Center(
                                    child: Text(
                                      '${flightsData[position]
                                          .outbound
                                          .flightAirlines}',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${flightsData[position]
                                      .outbound.departTime
                                  }',
                                  style: TextStyle(
                                      fontSize: 23.0,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.right,
                                ),

                                SizedBox(
                                    height: 25,
                                    width: 30,
                                    child: Image.asset('assets/right.png')),


                                Text(
                                  '${flightsData[position]
                                      .outbound.arrivalTime
                                  }',
                                  style: TextStyle(
                                      fontSize: 23.0,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.right,
                                ),

                                SizedBox(
                                  height: 25,
                                  width: 30,)
                              ]),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SizedBox(
                                  width: 75,
                                  height: 42,
                                ),
                                Text(
                                  '${flightsData[position]
                                      .outbound.originPlace
                                  }',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),

                                SizedBox(
                                  height: 25,
                                  width: 30,
                                ),


                                Text(
                                  '${flightsData[position]
                                      .outbound.destPlace
                                  }',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),

                                SizedBox(
                                  height: 25,
                                  width: 30,)
                              ]),

                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(
                                width: 75,
                                height: 42,
                                child: Center(
                                  child: Text(
                                    '${flightsData[position]
                                        .inbound
                                        .flightAirlines}',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              Text(
                                '${flightsData[position]
                                    .inbound.departTime
                                }',
                                style: TextStyle(
                                    fontSize: 23.0,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.right,
                              ),

                              SizedBox(
                                  height: 25,
                                  width: 30,
                                  child: Image.asset('assets/right.png')),


                              Text(
                                '${flightsData[position]
                                    .inbound.arrivalTime
                                }',
                                style: TextStyle(
                                    fontSize: 23.0,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(
                                height: 25,
                                width: 30,)

                            ],
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SizedBox(
                                  width: 75,
                                  height: 42,
                                ),
                                Text(
                                  '${flightsData[position]
                                      .inbound.originPlace
                                  }',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),

                                SizedBox(
                                  height: 25,
                                  width: 30,
                                ),


                                Text(
                                  '${flightsData[position]
                                      .inbound.destPlace
                                  }',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),

                                SizedBox(
                                  height: 25,
                                  width: 30,)
                              ]),


                          Align(
                            alignment: FractionalOffset.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Container(
                                width: 130,
                                height: 50,
                                color: Colors.blue[100],
                                child: Center(
                                  child: Text(
                                    'SGD ${flightsData[position].price}',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                            ),

                          )]),
                  )
              );
            }
        ));
  }

}