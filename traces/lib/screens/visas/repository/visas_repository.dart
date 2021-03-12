
import '../model/entryExit.dart';
import '../model/settings.dart';
import '../model/user_countries.dart';
import '../model/visa.dart';

abstract class VisasRepository {
  Stream<List<Visa>> visas();

  Stream<List<EntryExit>> entryExits(String visaId);

  Future<UserCountries> userCountries();

  Future<VisaSettings> settings();

  Future<EntryExit> addEntryExit(EntryExit entryExit, String visaId);

  Future<void> updateUserCountries(List<String> countries);

  Future<EntryExit> updateEntryExit(EntryExit entryExit, String visaId);

  Future<Visa> addNewVisa(Visa visa);

  Future<Visa> updateVisa(Visa visa);

  Future<void> deleteVisa(String visaId);

  Future<void> deleteEntry(String visaId, String entryId);

  Future<Visa> getVisaById(String id);

  Future<EntryExit> getEntryExitById(String id, String visaId);
}