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
    final newVisa = await visasCollection.document(uid).collection(userVisas).add(visa.toEntity().toDocument());
    return await getVisaById(newVisa.documentID);
  }

  @override
  Future<void> deleteVisa(Visa visa) {
    // TODO: implement deleteVisa
    return null;
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
  Future<Visa> updateVisa(Visa visa) {
    // TODO: implement updateVisa
    return null;
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