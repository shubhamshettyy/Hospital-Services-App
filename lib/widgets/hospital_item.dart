import 'package:flutter/material.dart';
import 'package:health_service/models/hospital.dart';
import '../screens/hospital_detail_screen.dart';

class HospitalItem extends StatelessWidget {
  final Hospital hospitalItem;

  HospitalItem(this.hospitalItem);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(HospitalDetailScreen.routeName, arguments: hospitalItem);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 6,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    hospitalItem.imageurl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 10,
                  child: Container(
                    width: 300,
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    child: Text(
                      hospitalItem.name,
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Icon(Icons.phone),
                      SizedBox(width: 20),
                      Text(hospitalItem.phoneNo),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(Icons.email),
                      SizedBox(width: 20),
                      Text(hospitalItem.email),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
