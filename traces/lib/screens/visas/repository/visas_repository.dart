
import 'package:traces/screens/visas/model/entryExit.dart';
import 'package:traces/screens/visas/model/settings.dart';
import 'package:traces/screens/visas/model/user_countries.dart';
import 'package:traces/screens/visas/model/visa.dart';

abstract class VisasRepository {
  Stream<List<Visa>> visas();

  Stream<List<EntryExit>> entryExits(String visaId);

  Future<UserCountries> userCountries();

  Future<Settings> settings();

  Future<void> addEntryExit(EntryExit entryExit, String visaId);

  Future<EntryExit> updateEntryExit(EntryExit entryExit);

  Future<Visa> addNewVisa(Visa visa);

  Future<Visa> updateVisa(Visa visa);

  Future<void> deleteVisa(Visa visa);

  Future<Visa> getVisaById(String id);
}