
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
  final visasCollection = Firestore.instance.collection('visas');
  final String userVisas = "userVisas";
  final String visaEntries = "visaEntries";
  final String visaSettings = "settings";

  UserRepository _userRepository;

  FirebaseVisasRepository() {
    _userRepository = new UserRepository();
    Firestore.instance.settings(persistenceEnabled: true);
  }

  @override
  Stream<List<Visa>> visas() async* {
    String uid = await _userRepository.getUserId();
    yield* visasCollection.document(uid).collection(userVisas).snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Visa.fromEntity(VisaEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Stream<List<EntryExit>> entryExits(String visaId) async* {
    String uid = await _userRepository.getUserId();

    yield* visasCollection.document(uid).collection(userVisas).document(visaId).collection(visaEntries).snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => EntryExit.fromEntity(EntryExitEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<Settings> settings() async{
    var resultSettings = await visasCollection.document(visaSettings).get();
    return Settings.fromEntity(SettingsEntity.fromMap(resultSettings.data));
  }

  @override
  Future<UserCountries> userCountries() async{
    String uid = await _userRepository.getUserId();
    var resultCountries = await visasCollection.document(uid).get();
    return UserCountries.fromEntity(UserCountriesEntity.fromMap(resultCountries.data));
  }

  @override
  Future<void> addEntryExit(EntryExit entryExit, String visaId) async {
    String uid = await _userRepository.getUserId();
    await visasCollection.document(uid).collection(userVisas).document(visaId).collection(visaEntries).add(entryExit.toEntity().toDocument());
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

    var resultNote = await visasCollection.document(uid).collection(userVisas).document(id).get();

    return Visa.fromEntity(VisaEntity.fromMap(resultNote.data, resultNote.documentID));
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

}