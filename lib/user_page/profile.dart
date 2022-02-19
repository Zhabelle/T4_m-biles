import 'dart:io';

import 'package:fakebacc/bloc/cuenta_bloc.dart';
import 'package:fakebacc/bloc/picture_bloc.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

import 'circular_button.dart';
import 'cuenta_item.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final screenSCont = ScreenshotController();

  Future _captureAndShare() async {
    screenSCont.capture().then((value) async {
      if(value == null) return;
      final dir = await getTemporaryDirectory();

      Share.shareFiles(['${dir.path}/capture.png'], subject: "mis cuentas");
    });
  }

  @override
  void initState() {
   /* WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      print("A");
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenSCont,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            DescribedFeatureOverlay(
              featureId: "f3", tapTarget: const Icon(Icons.share),
              title: Text("Botón para tomar captura de pantalla y compartirla"),
              description: Text(""),
              overflowMode: OverflowMode.extendBackground,
              backgroundOpacity: 0.5,
              targetColor: Colors.white,
              backgroundColor: Colors.indigo,
              child: IconButton(
                tooltip: "Compartir pantalla",
                onPressed: () async {
                  await _captureAndShare();
                },
                icon: Icon(Icons.share),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BlocConsumer<PictureBloc, PictureState>(
                  listener: (context, state) {
                    if (state is PictureError)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${state.err}"),
                          backgroundColor: Colors.red,
                        ),
                      );
                  },
                  builder: (context, state) {
                    if (state is PictureSelected)
                      return CircleAvatar(
                        backgroundImage: FileImage(state.pic),
                        minRadius: 40,
                        maxRadius: 80,
                      );
                    return CircleAvatar(
                      backgroundColor: Colors.grey,
                      minRadius: 40,
                      maxRadius: 80,
                    );
                  },
                ),
                SizedBox(height: 16),
                Text(
                  "Bienvenido",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.black),
                ),
                SizedBox(height: 8),
                Text("Usuario${UniqueKey()}"),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DescribedFeatureOverlay(
                      featureId: "f2", tapTarget: const Icon(Icons.credit_card),
                      title: Text("Botón para ver tarjeta"),
                      description: Text(""),
                      overflowMode: OverflowMode.extendBackground,
                      backgroundOpacity: 0.5,
                      targetColor: Colors.white,
                      backgroundColor: Colors.indigo,
                      child: CircularButton(
                        textAction: "Ver tarjeta",
                        iconData: Icons.credit_card,
                        bgColor: Color(0xff123b5e),
                        action: null,
                      ),
                    ),
                    DescribedFeatureOverlay(
                      featureId: "f1", tapTarget: const Icon(Icons.camera_alt),
                      title: Text("Cambiar foto de perfil tomada con la cámara"),
                      description: Text(""),
                      overflowMode: OverflowMode.extendBackground,
                      backgroundOpacity: 0.5,
                      targetColor: Colors.white,
                      backgroundColor: Colors.indigo,
                      child: CircularButton(
                        textAction: "Cambiar foto",
                        iconData: Icons.camera_alt,
                        bgColor: Colors.orange,
                        action: () {
                          BlocProvider.of<PictureBloc>(context)
                              .add(ImageChangedEvent());
                        },
                      ),
                    ),
                    DescribedFeatureOverlay(
                      featureId: "f0", tapTarget: const Icon(Icons.play_arrow),
                      title: Text("Ver tutorial para usar la app"),
                      description: Text(""),
                      overflowMode: OverflowMode.extendBackground,
                      backgroundOpacity: 0.5,
                      targetColor: Colors.white,
                      backgroundColor: Colors.indigo,
                      child: CircularButton(
                        textAction: "Ver tutorial",
                        iconData: Icons.play_arrow,
                        bgColor: Colors.green,
                        action: ()=>FeatureDiscovery.discoverFeatures(context, Iterable.generate(4, (i)=>'f${i}')),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48),
                BlocConsumer<CuentaBloc, CuentaState>(
                  listener: (context, state) {
                    if (state is CuentaError)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${state.err}"),
                          backgroundColor: Colors.red,
                        ),
                      );
                  },
                  builder: (context, state) {
                    if(state is CuentaSelected)
                      return Expanded(
                        child: ListView.builder(
                          itemCount: state.cuentas["cuentas"].length,
                          itemBuilder: (BuildContext context, int index) {
                            final cuenta = state.cuentas["cuentas"][index];
                            return CuentaItem(
                              saldoDisponible: cuenta["dinero"].toString(),
                              terminacion: (cuenta["tarjeta"]%10000).toString(),
                              tipoCuenta: cuenta["cuenta"].toString(),
                            );
                          },
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                        ),
                      );
                    if(state is CuentaInitial)
                      return Center(child: CircularProgressIndicator());
                    return Center(child: Text("No hay datos disponibles"));
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }
}
