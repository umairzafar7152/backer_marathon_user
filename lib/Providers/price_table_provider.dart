import 'package:backer_marathon/reusable_widgets/custom_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:backer_marathon/models/single_unit.dart';
import 'package:flutter/cupertino.dart';

class PriceTableProvider extends ChangeNotifier {
  final CollectionReference requestsRef =
      FirebaseFirestore.instance.collection('prices_list');

  List<SingleUnit> _unitsList = [];
  List<SingleUnit> get unitsList => _unitsList;

  Future<void> updatePriceUsingPart(
      String partNumber, BuildContext context) async {
    var listSnapshot =
        await requestsRef.where("voltage", isEqualTo: partNumber).get();
    var listDocs = listSnapshot.docs;
    if (listDocs.isNotEmpty) {
      List<SingleUnit> unitsList = [];
      try {
        listDocs.map((document) {
          SingleUnit req = SingleUnit.fromDocument(document);
          unitsList.add(req);
        }).toList();
        Navigator.of(context).pop();
        _unitsList = unitsList;
      } catch (e) {
        print("Exception $e");
      }
    } else {
      Navigator.of(context).pop();
      displayDialog(context, "Error", "Please enter valid values!");
    }
    notifyListeners();
  }

  Future<void> updatePriceUsingDia(
      String diameter, String length, BuildContext context) async {
    var listSnapshot = await requestsRef
        .where("diameter", isEqualTo: diameter)
        .where("length", isEqualTo: length)
        .get();
    var listDocs = listSnapshot.docs;
    if (listDocs.isNotEmpty) {
      List<SingleUnit> unitsList = [];
      try {
        listDocs.map((document) {
          SingleUnit req = SingleUnit.fromDocument(document);
          unitsList.add(req);
        }).toList();
        Navigator.of(context).pop();
        _unitsList = unitsList;
      } catch (e) {
        print("Exception $e");
      }
    } else {
      Navigator.of(context).pop();
      displayDialog(context, "Error", "Please enter valid values!");
    }
    notifyListeners();
  }
}
