

import 'dart:math';

import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/utils/Format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:function_tree/function_tree.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';

class Finger extends StatefulWidget{
  @override
  _FingerState createState() => _FingerState();
}

class _FingerState extends State<Finger>{
 
    final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String? _authorized;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }


  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
            'Para acceder a las cuentas de Ptt, se necesita que verifique su identidad',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 't' : 'f';
    setState(() {
      _authorized = message;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor().getPrimary(true),
        borderRadius: BorderRadius.circular(20)
      ),
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Text("Presione sobre la huella para validar",textAlign: TextAlign.center,style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15)),
          ),
        Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(color: AppColor().getPrimary(true), borderRadius: BorderRadius.circular(100)),
                child: IconButton(icon: Icon(Icons.fingerprint, color: Colors.white), iconSize: 80, padding: EdgeInsets.zero, onPressed: ()async{
                  await _authenticateWithBiometrics();
                  if(_authorized=="t"){
                    Navigator.of(context).pop(true);
                  }
                }),
        ),
        _authorized=="f"?Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Text("Algo salio mal, vuelve a intentarlo",textAlign: TextAlign.center,style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15)),
          ):Container()
      ])
      );
        
}}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}