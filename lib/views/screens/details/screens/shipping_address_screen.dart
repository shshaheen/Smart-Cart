import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_cart/controllers/auth_controller.dart';
import 'package:smart_cart/providers/user_provider.dart';

class ShippingAddressScreen extends ConsumerStatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  ConsumerState<ShippingAddressScreen> createState() =>
      _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends ConsumerState<ShippingAddressScreen> {
  final AuthController _authController = AuthController();
  late String state;
  late String city;
  late String locality;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Show Loading Dialog
  _showLoadingDialog() {
    showDialog(context: context, builder: (context){
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator()
                ,SizedBox(width: 20,),
                Text("Updating...",
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),)
            ],
          ),),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final updateUser = ref.read(userProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(233),
      appBar: AppBar(
        backgroundColor: Colors.white.withAlpha(233),
        title: Text(
          "Delivery",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Where will your order \n be shipped',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextFormField(
                  onChanged: (value) {
                    state = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter State";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "State",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onChanged: (value) {
                    city = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter City";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "City",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onChanged: (value) {
                    locality = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Locality";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Locality",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(9.0),
        child: InkWell(
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              _showLoadingDialog();
              await _authController
                  .updateUserLocation(
                      context: context,
                      id: ref.read(userProvider)!.id,
                      state: state,
                      city: city,
                      locality: locality)
                  .whenComplete(() {
                updateUser.recreateUserState(
                    state: state, city: city, locality: locality);
                    
              });
              // print("Valid");
              Navigator.pop(context);// this will close the dialog
              Navigator.pop(context);// this will close the shipping screen meaning it will take us back to the formal which is the checkout
            } else {
              print("Not Valid");
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF3854EE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "Save",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
