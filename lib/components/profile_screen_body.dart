import 'package:flutter/material.dart';
import 'package:notes_on_map/constants.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:notes_on_map/components/whoop_card.dart';
import 'package:notes_on_map/components/flutter_map_widget.dart';
import 'package:notes_on_map/components/circle_avatar_component.dart';

import 'package:provider/provider.dart';
import 'package:notes_on_map/services/user_service.dart';
import 'package:notes_on_map/providers/auth_token_provider.dart';

import 'package:notes_on_map/models/user_model.dart';
import 'package:notes_on_map/models/whoop_model.dart';
import 'package:notes_on_map/models/address_model.dart';

import "package:latlong/latlong.dart" as latLng;

class ProfileScreenBody extends StatefulWidget {
  @override
  _ProfileScreenBodyState createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  bool _pinned = false;
  bool _snap = false;
  bool _floating = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthTokenProvider>(
      builder: (context, tokenData, child) {
        return FutureBuilder(
          future: UserService.getMyProfileUser(tokenData.accessToken),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                User user = snapshot.data;

                return CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: kPrimaryWhiteColor,
                      pinned: _pinned,
                      snap: _snap,
                      floating: _floating,
                      expandedHeight: 350.0,
                      flexibleSpace: _buildFlexibleSpaceBar(user.whoops),
                    ),
                    _buildSliverList(user.whoops),
                  ],
                );
              }
            }

            return Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  //Flexible component for CustomScrollView
  Widget _buildFlexibleSpaceBar(List<Whoop> whoops) {
    String lastLocation = '';
    List<Marker> markers = [];

    if (whoops.length != 0) {
      Address addres = whoops[whoops.length - 1].address;
      lastLocation = '${addres.province}, ${addres.countryCode.toUpperCase()}';

      for (Whoop whoop in whoops) {
        double latitude = whoop.latitude;
        double longitude = whoop.longitude;

        Marker marker = Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 40.0,
          width: 200.0,
          point: latLng.LatLng(latitude, longitude),
          builder: (context) => Icon(
            Icons.pin_drop,
            size: 30.0,
          ),
        );

        markers.add(marker);
      }
    }

    return FlexibleSpaceBar(
      background: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Map Stack
          _ProfileMapComponent(markers: markers),
          SizedBox(height: 10),
          //Info column
          _ProfileInfoComponent(
            whoopsCount: whoops.length,
            lastLocation: lastLocation,
          ),
        ],
      ),
    );
  }

  String getLocation(Address address) {
    String location = '', country;
    if (address.county != null)
      location = address.county;
    else if (address.town != null)
      location = address.town;
    else if (address.village != null) location = address.village;

    country = address.countryCode != null || address.countryCode != ''
        ? address.countryCode.toUpperCase()
        : address.country;

    if (location == '')
      location += '${address.province}, $country';
    else
      location += ', ${address.province}, $country';

    return location;
  }

  //List of Whoop Cards
  Widget _buildSliverList(List<Whoop> whoops) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (whoops.length == 0)
            return Container(
              color: kPrimaryWhiteColor,
              child: Center(
                child: Text('Daha önce hiç whoop\'lamadınız :/'),
              ),
            );

          Address address = whoops[index].address;
          String location = getLocation(address);

          return Container(
            color: kPrimaryWhiteColor,
            child: Center(
              child: WhoopCard(
                title: whoops[index].title,
                location: location,
                date: whoops[index].dateCreated,
                time: whoops[index].time.toString(),
                tags: List<String>.from(whoops[index].tags),
                haveProfilePicture: false,
              ),
            ),
          );
        },
        childCount: whoops.length,
      ),
    );
  }
}

//Texts and social media info icons
class _ProfileInfoComponent extends StatelessWidget {
  final int whoopsCount;
  final String lastLocation;

  _ProfileInfoComponent({this.whoopsCount, this.lastLocation});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Row for texts
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '${whoopsCount.toString()} Whoops',
              style: TextStyle(color: kPrimaryDarkColor),
            ),
            SizedBox(),
            Text(lastLocation, style: TextStyle(color: kPrimaryDarkColor)),
          ],
        ),
        SizedBox(height: 15),
        //Row for icons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(),
            SizedBox(width: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Image.asset('assets/icons/twitter.png'),
                  iconSize: 30,
                  onPressed: () {},
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Image.asset('assets/icons/instagram.png'),
                  iconSize: 30,
                  onPressed: () {},
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Image.asset('assets/icons/facebook.png'),
                  iconSize: 26,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 25),
        Text(
          whoopsCount != 0
              ? 'Whoop\'larım'
              : 'Şimdiye kadar hiç whoop\'lamadınız :/',
          style: TextStyle(
            color: kPrimaryDarkColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

//Map and Profile Picture
class _ProfileMapComponent extends StatelessWidget {
  final List<Marker> markers;

  _ProfileMapComponent({this.markers});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.bottomCenter,
        children: [
          //Map
          SizedBox(
            height: 250,
            child: FlutterMapWidget(
              markers: markers,
              mapZoom: 4.8,
            ),
          ),
          Positioned(
            bottom: -60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Profile Picture
                CircleAvatarComponent(
                  radius: 40,
                  borderSize: 3,
                ),
                SizedBox(height: 5),
                Text(
                  '@asligamze',
                  style: TextStyle(
                    color: kPrimaryDarkColor,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
