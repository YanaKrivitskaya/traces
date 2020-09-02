import 'package:traces/auth/userRepository.dart';
import 'package:traces/screens/visas/model/entryExit.dart';
import 'package:traces/screens/visas/model/entryExit_entity.dart';
import 'package:traces/screens/visas/model/settings.dart';
import 'package:traces/screens/visas/model/settings_entity.dart';
import 'package:traces/screens/visas/model/user_countries.dart';
import 'package:traces/screens/visas/model/user_countries_entity.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:traces/screens/visas/model/visa_entity.dart';
import 'package:traces/screens/visas/repository/visas_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseVisasRepository extends VisasRepository{
  final visasCollection = FirebaseFirestore.instance.collection('visas');
  final String userVisas = "userVisas";
  final String visaEntries = "visaEntries";
  final String visaSettings = "settings";

  UserRepository _userRepository;

  FirebaseVisasRepository() {
    _userRepository = new UserRepository();
    //Firestore.instance.settings(persistenceEnabled: true);
  }

  @override
  Stream<List<Visa>> visas() async* {
    String uid = await _userRepository.getUserId();
    yield* visasCollection.doc(uid).collection(userVisas).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Visa.fromEntity(VisaEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Stream<List<EntryExit>> entryExits(String visaId) async* {
    String uid = await _userRepository.getUserId();

    yield* visasCollection.doc(uid).collection(userVisas).doc(visaId).collection(visaEntries).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => EntryExit.fromEntity(EntryExitEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<VisaSettings> settings() async{
    var resultSettings = await visasCollection.doc(visaSettings).get();
    return VisaSettings.fromEntity(VisaSettingsEntity.fromMap(resultSettings.data()));
  }

  @override
  Future<UserCountries> userCountries() async{
    String uid = await _userRepository.getUserId();
    var resultCountries = await visasCollection.doc(uid).get();
    return UserCountries.fromEntity(UserCountriesEntity.fromMap(resultCountries.data()));
  }

  @override
  Future<void> addEntryExit(EntryExit entryExit, String visaId) async {
    String uid = await _userRepository.getUserId();
    await visasCollection.doc(uid).collection(userVisas).doc(visaId).collection(visaEntries).add(entryExit.toEntity().toDocument());
  }

  @override
  Future<Visa> addNewVisa(Visa visa) async {
    String uid = await _userRepository.getUserId();
    final newVisa = await visasCollection.doc(uid).collection(userVisas).add(visa.toEntity().toDocument());
    return await getVisaById(newVisa.id);
  }

  @override
  Future<void> deleteVisa(String visaId) async{
    String uid = await _userRepository.getUserId();
    var data = await visasCollection.doc(uid).collection(userVisas).doc(visaId).collection(visaEntries).get();

    var entriesDocs = data.docs;

    for(var doc in entriesDocs){
      await visasCollection.doc(uid).collection(userVisas).doc(visaId).collection(visaEntries).doc(doc.id).delete();
    }

    await visasCollection.doc(uid).collection(userVisas).doc(visaId).delete();
  }

  @override
  Future<Visa> getVisaById(String id) async{
    String uid = await _userRepository.getUserId();

    var resultNote = await visasCollection.doc(uid).collection(userVisas).doc(id).get();

    return Visa.fromEntity(VisaEntity.fromMap(resultNote.data(), resultNote.id));
  }

  @override
  Future<EntryExit> updateEntryExit(EntryExit entryExit) {
    // TODO: implement updateEntryExit
    return null;
  }

  @override
  Future<Visa> updateVisa(Visa visa) async {
    String uid = await _userRepository.getUserId();
    await visasCollection.doc(uid).collection(userVisas)
        .doc(visa.id)
        .update(visa.toEntity().toDocument());
    return await getVisaById(visa.id);
  }

  @override
  Future<void> updateUserCountries(List<String> countries) async {
    String uid = await _userRepository.getUserId();

    var userCountriesRef = await visasCollection.doc(uid);

    UserCountries userCountries = new UserCountries(countries);

    await visasCollection.doc(uid).set(userCountries.toEntity().toDocument());
    
    //await userCountriesRef.updateData(userCountries.toEntity().toDocument());
  }

}