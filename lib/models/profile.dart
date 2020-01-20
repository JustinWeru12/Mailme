import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailman/models/profiledetails.dart';
import 'package:mailman/models/user.dart';

class Profile {
  final String userId;
  Profile({this.userId});

  final CollectionReference profileCollection =
      Firestore.instance.collection('profile');

  get key => null;

  Future updateProfileData(
    String fullNames,
    String email,
    String phone,
    String age,
    String address,
    String userId,
  ) async {
    return await profileCollection.document(userId).setData({
      'fullNames': fullNames,
      'email': email,
      'phone': phone,
      'age': age,
      'address': address,
    });
  }

  List<ProfileDetails> _profileListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return ProfileDetails(
          fullNames: doc.data["fullNames"] ?? '',
          email: doc.data["email"] ?? '',
          phone: doc.data["phone"] ?? '',
          age: doc.data["age"] ?? '',
          address: doc.data["address"] ?? '');
    }).toList();
  }

  Stream<List<ProfileDetails>> get profile {
    return profileCollection.snapshots().map(_profileListFromSnapshot);
  }

 
  // ProfileDetails fromSnapshot(DataSnapshot snapshot) {}
  // Profile(this.fullNames,this.email, this.phone, this.userId, this.age);

  // Profile.fromSnapshot( snapshot) :
  // userId = snapshot.value["userId"],
  //   fullNames = snapshot.value["fullNames"],
  //   email=snapshot.value["email"],
  //   phone = snapshot.value["phone"],
  //   age = snapshot.value["age"],
  //   address=snapshot.value["address"];

  // toJson() {
  //   return {
  //     "userId": userId,
  //     "phone": phone,
  //     "age": age,
  //   };
  // }
}
