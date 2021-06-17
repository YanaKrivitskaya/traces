import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../auth/firebaseUserRepository.dart';
import '../model/entryExit.dart';
import '../model/entryExit_entity.dart';
import '../model/settings.dart';
import '../model/user_countries.dart';
import '../model/visa.dart';
import '../model/visa_entity.dart';
import 'visas_repository.dart';

class FirebaseVisasRepository extends VisasRepository{
  final visasCollection = FirebaseFirestore.instance.collection('visas');
  final String userVisas = "userVisas";
  final String visaEntries = "visaEntries";
  final String visaSettings = "settings";

  FirebaseUserRepository _userRepository;

  FirebaseVisasRepository() {
    _userRepository = new FirebaseUserRepository();    
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
  Future<UserSettings> userSettings() async{
    String uid = await _userRepository.getUserId();
    var resultSettings = await visasCollection.doc(uid).get();
    return UserSettings.fromEntity(UserSettingsEntity.fromMap(resultSettings.data()));
  }

  @override
  Future<EntryExit> addEntryExit(EntryExit entryExit, String visaId) async {
    String uid = await _userRepository.getUserId();
    final newEntry = await visasCollection.doc(uid).collection(userVisas).doc(visaId).collection(visaEntries).add(entryExit.toEntity().toDocument());
    return getEntryExitById(newEntry.id, visaId);
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

    var resultVisa = await visasCollection.doc(uid).collection(userVisas).doc(id).get();

    return Visa.fromEntity(VisaEntity.fromMap(resultVisa.data(), resultVisa.id));
  }

  @override
  Future<EntryExit> getEntryExitById(String id, String visaId) async{
    String uid = await _userRepository.getUserId();

    var resultEntry = await visasCollection.doc(uid).collection(userVisas)
    .doc(visaId).collection(visaEntries).doc(id).get();

    return EntryExit.fromEntity(EntryExitEntity.fromMap(resultEntry.data(), resultEntry.id));
  }

  @override
  Future<EntryExit> updateEntryExit(EntryExit entryExit, String visaId) async {
    String uid = await _userRepository.getUserId();
    await visasCollection.doc(uid).collection(userVisas).doc(visaId)
      .collection(visaEntries).doc(entryExit.id).update(entryExit.toEntity().toDocument());
    return getEntryExitById(entryExit.id, visaId);
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
  Future<void> updateUserSettings(List<String> countries, List<String> cities) async {
    String uid = await _userRepository.getUserId();

    UserSettings userSettings = await this.userSettings();

    if(countries != null){
      countries.forEach((country) { 
          if(userSettings.countries.where((c) => c == country).length ==
            0) userSettings.countries.add(country);
        });
    }

    if(cities != null){
      cities.forEach((city) { 
      if(userSettings.cities.where((c) => c == city).length ==
        0) userSettings.cities.add(city);
      });
    }

    await visasCollection.doc(uid).set(userSettings.toEntity().toDocument());    
  }

  @override
  Future<void> deleteEntry(String visaId, String entryId) async{
    String uid = await _userRepository.getUserId();

    await visasCollection.doc(uid).collection(userVisas)
    .doc(visaId).collection(visaEntries).doc(entryId).get();

    await visasCollection.doc(uid).collection(userVisas)
      .doc(visaId).collection(visaEntries).doc(entryId).delete();
  }

}