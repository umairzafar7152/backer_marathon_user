import 'dart:async';

import 'package:backer_marathon/Providers/price_table_provider.dart';
import 'package:backer_marathon/reusable_widgets/custom_dialog.dart';
import 'package:backer_marathon/reusable_widgets/custom_loading_dialog.dart';
import 'package:backer_marathon/reusable_widgets/custom_text_field.dart';
import 'package:backer_marathon/reusable_widgets/price_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static final TextEditingController _diameterController =
      TextEditingController();
  static final TextEditingController _lengthController =
      TextEditingController();
  static final TextEditingController _partNumberController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 13),
                  child: Center(
                      child: Hero(
                          tag: 'logo1',
                          child: Image.asset('assets/fcs_logo.png',
                              height: 62, width: 110)))),
              const Text('Catridge Heaters',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(30, 27, 8, 19),
                        child: Text('Enter Dimensions',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.fromLTRB(30, 8, 8, 8),
                            child: Text('Diameter',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                          SizedBox(
                              width: 60,
                              height: 32,
                              child: CustomTextField(
                                  controller: _diameterController,
                                  inputType: TextInputType.text)),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Length',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                          SizedBox(
                              width: 60,
                              height: 32,
                              child: CustomTextField(
                                  controller: _lengthController,
                                  inputType: TextInputType.text)),
                        ],
                      ),
                      const Padding(
                          padding: EdgeInsets.fromLTRB(30, 5, 5, 5),
                          child: Text('OR',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.fromLTRB(30, 8, 8, 8),
                            child: Text('part number',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                          SizedBox(
                              width: 180,
                              height: 32,
                              child: CustomTextField(
                                  controller: _partNumberController,
                                  inputType: TextInputType.text)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 8, 32),
                        child: Center(
                          child: SizedBox(
                            height: 41,
                            width: 123,
                            child: TextButton(
                                onPressed: () {
                                  if (_partNumberController.text.isNotEmpty &&
                                      _diameterController.text.isNotEmpty &&
                                      _lengthController.text.isNotEmpty) {
                                    displayDialog(context, "Error",
                                        "Please enter diameter and length OR part number!");
                                  } else if (_partNumberController
                                      .text.isNotEmpty) {
                                    displayLoadingDialog(context);
                                    Provider.of<PriceTableProvider>(context,
                                            listen: false)
                                        .updatePriceUsingPart(
                                            _partNumberController.text,
                                            context);
                                  } else if (_diameterController
                                          .text.isNotEmpty &&
                                      _lengthController.text.isNotEmpty) {
                                    displayLoadingDialog(context);
                                    Provider.of<PriceTableProvider>(context,
                                            listen: false)
                                        .updatePriceUsingDia(
                                            _diameterController.text,
                                            _lengthController.text,
                                            context);
                                  } else {
                                    displayDialog(context, "Error",
                                        "Please enter valid values");
                                  }
                                  Future.delayed(const Duration(seconds: 3),
                                      () {
                                    _partNumberController.text = '';
                                    _lengthController.text = '';
                                    _diameterController.text = '';
                                  });
                                },
                                child: const Text('Search',
                                    style: TextStyle(color: Colors.white)),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0))),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xBD221A1A)))),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('FCS stock & Price Search',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
              Consumer<PriceTableProvider>(builder: (context, provider, child) {
                return provider.unitsList.isNotEmpty
                    ? const PriceTable()
                    : Image.asset('assets/fcs_image.png');
              })
            ],
          ),
        ),
      ),
    );
  }
}
