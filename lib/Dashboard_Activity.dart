import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_notebook/Bottom_navigation_bar.dart';
import 'package:my_notebook/MyDataList.dart';
import 'package:my_notebook/Side_NavigationBar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Dashboard extends StatefulWidget{
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _locationName = 'Fetching...';
  String _locatonDetails = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLocation();
  }

  void openDrawer(){
    _scaffoldkey.currentState?.openEndDrawer();
  }

  void fetchLocation() async {
    try{
      if(!kIsWeb) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          permission = await Geolocator.requestPermission();

          if (permission != LocationPermission.always &&
              permission != LocationPermission.whileInUse) {
            setState(() {
              _locationName = 'Location Denied';
            });
            return;
          }
        }

        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high
        );

        List<Placemark> placemark = await placemarkFromCoordinates(
            position.latitude,
            position.longitude);

        if (placemark.isNotEmpty) {
          final place = placemark[0];
          setState(() {
            _locationName = "${place.locality}, ${place.administrativeArea}";
            _locatonDetails =
            "${place.street},${place.subLocality},${place.postalCode}";
          });
        } else {
          setState(() {
            _locationName = 'Unknown';
          });
        }
      }else {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low
        );
        setState(() {
          _locationName = "Lat: ${position.latitude.toStringAsFixed(2)}, Long: ${position.longitude.toStringAsFixed(2)}";
          _locatonDetails = 'Web location obtained';
        });
      }

    }catch(e){
      print('Error fetching location: $e');
      setState(() {
        _locationName = "Error getting location";
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      endDrawer: SideNavigationBar(),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Row(
          children: [
            Icon(Icons.location_on,color: Colors.white,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(_locationName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(_locatonDetails,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                    ),),
                )

              ],
            ),
          ],
        ),
        
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.notifications,color: Colors.white,),
          )
        ],
      ),

      bottomNavigationBar: BottomNavBar(onDrawerOpen: openDrawer,),

      body: SafeArea(
        child: LayoutBuilder(
          builder:  (context,constraints){
            bool isWeb = constraints.maxWidth > 800;
            return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 1200 : double.infinity
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.count(
                        crossAxisCount: isWeb ? 6 : 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          BuildMenuItems(() => Navigator.push(context, MaterialPageRoute(builder: (context) => MyDataList())), 'assets/icons/electrician_sharp.png',"Electrician"),
                          BuildMenuItems(() => Navigator.push(context, MaterialPageRoute(builder: (context) => MyDataList())), 'assets/icons/plumber.png',"Plumber"),
                          BuildMenuItems(() => Navigator.push(context, MaterialPageRoute(builder: (context) => MyDataList())), 'assets/icons/carpenter.png',"Carpenter"),
                          BuildMenuItems(() => Navigator.push(context, MaterialPageRoute(builder: (context) => MyDataList())), 'assets/icons/painter.png',"Painter"),
                          BuildMenuItems(() => Navigator.push(context, MaterialPageRoute(builder: (context) => MyDataList())), 'assets/icons/mechanic.png',"Mechanic"),
                          BuildMenuItems(() => Navigator.push(context, MaterialPageRoute(builder: (context) => MyDataList())), 'assets/icons/maid.png',"Maid"),
                          BuildMenuItems(() => Navigator.push(context, MaterialPageRoute(builder: (context) => MyDataList())), 'assets/icons/driver.png',"Driver"),
                          BuildMenuItems(() => Navigator.push(context, MaterialPageRoute(builder: (context) => MyDataList())), 'assets/icons/labour.png',"Labour"),
                          BuildMenuItems(() => Navigator.push(context, MaterialPageRoute(builder: (context) => MyDataList())), 'assets/icons/makeup.png',"Makeup Artist"),


                        ],
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [

                                BuildImageItems('assets/images/plumbing_services.jpg'),
                                SizedBox(width: 10,),

                                BuildImageItems('assets/images/painter_image.jpg'),
                                SizedBox(width: 10,),

                                BuildImageItems('assets/images/makeup_artist.jpg'),

                                SizedBox(width: 10,),
                                BuildImageItems("assets/images/electrician_image.jpg"),


                                SizedBox(width: 10,),
                                BuildImageItems('assets/images/garden_planning.jpg'),


                              ],
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  color: Colors.deepPurple.withOpacity(0.2),
                                  width: 0.5
                              ),
                              bottom: BorderSide(
                                  color: Colors.deepPurple.withOpacity(0.2),
                                  width: 0.5
                              ),
                            )
                        ),
                      ),
                      SizedBox(height: 20,),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('New Tranding',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                      ),

                      Container(
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                BuildImageItemsVertical('assets/images/garden_landscape.jpg'),

                                SizedBox(width: 20,),
                                BuildImageItemsVertical("assets/images/electrician_image.jpg"),

                                SizedBox(width: 20,),

                                BuildImageItemsVertical('assets/images/makeup_artist.jpg'),

                                SizedBox(width: 20,),
                                BuildImageItemsVertical('assets/images/painter_image.jpg'),

                                SizedBox(width: 20,),

                                BuildImageItemsVertical('assets/images/plumbing_services.jpg')
                              ],
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  color: Colors.deepPurple.withOpacity(0.2),
                                  width: 0.5
                              ),
                              bottom: BorderSide(
                                  color: Colors.deepPurple.withOpacity(0.2),
                                  width: 0.5
                              ),
                            )
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10,top: 20,right: 10),
                        child: Text('Are you Planning for a garden, here a best deal for you.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                          ),
                      ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 300,
                      child: ClipRRect(
                          child: Image.asset(
                            'assets/images/garden_planning2.jpg',
                            width: double.infinity,
                            height: isWeb ? 400 : 300,
                            fit: BoxFit.cover,),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  )


                    ],
                  ),
                ),
              ),
            ),
          );
          }
        )
      ),
    );
  }

}



Widget BuildImageItems(String Images){
  return SizedBox(
    height: 150,
    width: 250,
    child: ClipRRect(
        child: Image.asset(
          Images,
          fit: BoxFit.cover,),
        borderRadius: BorderRadius.circular(10)),
  );
}

Widget BuildImageItemsVertical(String Images){
  return SizedBox(
    height: 300,
    width: 150,
    child: ClipRRect(
        child: Image.asset(
          Images,
          fit: BoxFit.cover,),
        borderRadius: BorderRadius.circular(10)),
  );
}

Widget BuildMenuItems(VoidCallback onPressItems, String ImagePath, String title){
  return GestureDetector(
    onTap: onPressItems,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.deepPurple.withOpacity(0.2),

          ),
          child: Center(
            child: Image.asset(
              ImagePath,
              height: 50,
              width: 50,
              fit: BoxFit.contain,

            ),
          ),
        ),

        Text(title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}