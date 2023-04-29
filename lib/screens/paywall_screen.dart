import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PayWall extends StatefulWidget {
  const PayWall({Key? key}) : super(key: key);

  @override
  _PayWallState createState() => _PayWallState();
}

class _PayWallState extends State<PayWall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF03001C),
      appBar: AppBar(
        backgroundColor: Color(0xFF03001C),
        centerTitle: true,
        title: Text(
          "BUY SUBSCRIPTION",
          style: GoogleFonts.comfortaa(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB6EADA),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            // var myProductList = widget.offering.availablePackages;
            return Card(
              color: Colors.purple,
              child: ListTile(
                onTap: () async {
                  try {
                    // CustomerInfo customerInfo =
                    //     await Purchases.purchasePackage(myProductList[index]);
                    // appData.entitlementIsActive =
                    //     customerInfo.entitlements.all[entitlementID].isActive;
                  } catch (e) {
                    print(e);
                  }

                  setState(() {});
                },
                title: Text(
                  "asd",
                ),
                subtitle: Text(
                  "myProductList[",
                ),
                trailing: Text(
                  "myProductList[index",
                ),
              ),
            );
          },
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
        ),
      ),
    );
  }
}
