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
  ) async {
    return await lettersCollection.document(userId).setData({
      'trackingNo': trackingNo,
      'description': description,
      'sBox': sBox,
      'dBox': dBox,
      'status': status,
      'sDate': sDate,
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
          sDate: doc.data["sDate"] ?? '');
    }).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        userId: userId,
        trackingNo: snapshot.data['trackingNo'],
        description: snapshot.data["description"],
        sBox: snapshot.data["sBox"],
        dBox: snapshot.data["dBox"],
        status: snapshot.data["status"],
        sDate: snapshot.data["sDate"]);
  }

  Stream<List<LetterDetails>> get letters {
    return lettersCollection.where("sBox", isEqualTo: "gf").snapshots().map(_letterListFromSnapshot);
  }

  Stream<UserData> get userData{
    return lettersCollection.document(userId).snapshots().map(_userDataFromSnapshot);
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
