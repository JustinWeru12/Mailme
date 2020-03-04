import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailman/models/letterdetails.dart';
import 'package:mailman/models/user.dart';

class Letter {
  final String userId;
  Letter({this.userId});

  final CollectionReference lettersCollection =
      Firestore.instance.collection('letters');

  get key => null;

  Future updateLetterData(
    String trackingNo,
    String description,
    String sBox,
    String dBox,
    String status,
    String userId,
    String sDate,
    String dPostalCode,
    String sPostalCode,
  ) async {
    return await lettersCollection.document(userId).setData({
      'trackingNo': trackingNo,
      'description': description,
      'sBox': sBox,
      'dBox': dBox,
      'status': status,
      'sDate': sDate,
      'dPostalCode' : dPostalCode,
      'sPostalCode' : sPostalCode,
    });
  }

  List<LetterDetails> _letterListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return LetterDetails(
          trackingNo: doc.data["trackingNo"] ?? '',
          description: doc.data["description"] ?? '',
          sBox: doc.data["sBox"] ?? '',
          dBox: doc.data["dBox"] ?? '',
          status: doc.data["status"] ?? '',
          sDate: doc.data["sDate"] ?? '',
          dPostalCode: doc.data["dPostalCode"] ?? '',
          sPostalCode: doc.data["sPostalCode"] ?? '');
    }).toList();
  }

  Stream<List<LetterDetails>> get letters {
    return lettersCollection
        .snapshots()
        .map(_letterListFromSnapshot);
  }

  // LetterDetails fromSnapshot(DataSnapshot snapshot) {}
  // Letter(this.trackingNo,this.description, this.sBox, this.userId, this.dBox);

  // Letter.fromSnapshot( snapshot) :
  // userId = snapshot.value["userId"],
  //   trackingNo = snapshot.value["trackingNo"],
  //   description=snapshot.value["description"],
  //   sBox = snapshot.value["sBox"],
  //   dBox = snapshot.value["dBox"],
  //   status=snapshot.value["status"];

  // toJson() {
  //   return {
  //     "userId": userId,
  //     "sBox": sBox,
  //     "dBox": dBox,
  //   };
  // }
}
