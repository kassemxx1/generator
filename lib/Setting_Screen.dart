import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Setting_Secreen extends StatefulWidget {
  static const String id = 'Setting_Secreen';
  const Setting_Secreen({Key? key}) : super(key: key);

  @override
  _Setting_SecreenState createState() => _Setting_SecreenState();
}

class _Setting_SecreenState extends State<Setting_Secreen> {
  var username='kassem abboud';
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;

  void getDevices() async{
    devices =await printer.getBondedDevices();
    setState(() {

    });

  }
  void getusername() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      username =_prefs.getString('user').toString();
    });
  }
  @override
  void initState() {
    getDevices();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اشتراك الوفا',style: TextStyle(
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),

      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'Information',style: TextStyle(
            ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 20,
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex:5,
                            child: Row(
                          children: [
                            Icon(Icons.how_to_reg_rounded,size: 20,color: Colors.blue,),
                            Text('Name:',style: TextStyle(
                              fontSize: 20,color: Colors.blue
                            ),)



                          ],
                            )
                        ),
                        Expanded(
                          flex: 5,
                          child:Text(
                            'kassem abboud',style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                          ) ,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex:5,
                            child: Row(
                              children: [
                                Icon(Icons.phone,size: 20,color: Colors.blue,),
                                Text('Phone:',style: TextStyle(
                                    fontSize: 20,color: Colors.blue
                                ),)



                              ],
                            )
                        ),
                        Expanded(
                          flex: 5,
                          child:Text(
                            '70385816',style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                          ) ,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      color: Colors.blue,
                        onPressed: (){

                    },
                      child: Text('Change Password',style: TextStyle(
                        fontSize: 20
                      ),),
                    ),
                  ),

                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child:Text('Printer Setup') ,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 20,
              child: Column(
                children: [
                  Center(
                    child: DropdownButton<BluetoothDevice>(
                      hint: const Text('select Thermal Printer',style: TextStyle(
                        color: Colors.black,
                        fontSize: 20

                      ),),

                      value: selectedDevice,
                      items:devices.map((e) => DropdownMenuItem
                        (child: Text(e.name!),
                        value: e,
                      ),
                      ).toList(),
                      onChanged: (device) async {

                        setState(() {
                          selectedDevice = device;
                        });

                      },

                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: () async{
                            if(selectedDevice == null){
                              Fluttertoast.showToast(
                                  msg: "Please Select Printer",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            else{
                              SharedPreferences _prefs = await SharedPreferences.getInstance();
                              printer.connect(selectedDevice!);
                              if(printer.isConnected == true) {
                                Fluttertoast.showToast(
                                    msg: "Connected",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                _prefs.setString('printername', selectedDevice.toString());
                              }
                              else{
                                Fluttertoast.showToast(
                                    msg: "Not Connected",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            }

                          },
                              child: Text("Connect",style: TextStyle(
                                fontSize: 20,
                                color: Colors.black
                              ),)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: () async{
                            if(selectedDevice == null){
                              Fluttertoast.showToast(
                                  msg: "no printer",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            else{
                              await printer.disconnect();
                              if(printer.disconnect() == true){
                                Fluttertoast.showToast(
                                    msg: "Disconnected",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0);

                              }
                            }


                          },
                              child: Text("Disconnect",style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black
                              ),)
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
          ),


        ],
      ),

    );
  }
}
