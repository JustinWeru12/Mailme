import 'package:cloud_firestore/cloud_firestore.dart';

class Letter {
  

  final CollectionReference lettersCollection = Firestore.instance.collection('letters');

  Future updateLetterData(String trackingNo,String description, String sBox, String dBox, String status, String userId,) async{
    return await lettersCollection.document(userId).setData({
      'trackingNo': trackingNo,
      'description': description,
      'sBox': sBox,
      'dBox': dBox,
      'status': status,
    });
  }
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