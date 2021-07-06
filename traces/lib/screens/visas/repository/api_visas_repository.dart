import 'package:traces/screens/visas/model/api_visa.model.dart';
import 'package:traces/screens/visas/model/visa.model.dart';
import 'package:traces/screens/visas/model/visa_entry.model.dart';

import '../../../utils/services/api_service.dart';

class ApiVisasRepository{
  ApiService apiProvider = ApiService();
  String visasUrl = 'visas/';

  Future<List<Visa>?> getVisas( )async{
    print("getVisas");
    final response = await apiProvider.getSecure(visasUrl);
      
    var visas = response["visas"] != null ? 
      response['visas'].map<Visa>((map) => Visa.fromMap(map)).toList() : null;
    return visas;
  }

  Future<Visa?> getVisaById(int visaId)async{
    print("getVisaById");
    final response = await apiProvider.getSecure("$visasUrl$visaId");
      
    var visa = response["visa"] != null ? 
      Visa.fromMap(response['visa']) : null;
    return visa;
    }

  Future<Visa> createVisa(Visa visa, int userId)async{
    print("createVisa");

    ApiVisaModel apiModel = ApiVisaModel(userId: userId, visa: visa);

    final response = await apiProvider.postSecure(visasUrl, apiModel.toJson());
      
    var visaResponse = Visa.fromMap(response['visa']);
    return visaResponse;
  }

  Future<Visa> updateVisa(Visa visa, int userId)async{
    print("updateVisa");
    
    ApiVisaModel apiModel = ApiVisaModel(userId: userId, visa: visa);

    final response = await apiProvider.putSecure("$visasUrl${visa.id}", apiModel.toJson());
      
    var visaResponse = Visa.fromMap(response['visa']);
    return visaResponse;
  }

  Future<String?> deleteVisa(int visaId)async{
    print("deleteVisa");   

    final response = await apiProvider.deleteSecure("$visasUrl$visaId}");     
    
    return response["response"];
  } 

  Future<VisaEntry> createVisaEntry(int visaId, VisaEntry visaEntry)async{
    print("createVisaEntry");   

    final response = await apiProvider.postSecure("$visasUrl$visaId/entry", visaEntry.toJson());
      
    var entryResponse = VisaEntry.fromMap(response['entry']);
    return entryResponse;
  }

  Future<VisaEntry> updateVisaEntry(int visaId, VisaEntry visaEntry)async{
    print("updateVisaEntry");   

    final response = await apiProvider.putSecure("$visasUrl$visaId/entry/${visaEntry.id}", visaEntry.toJson());
      
    var entryResponse = VisaEntry.fromMap(response['entry']);
    return entryResponse;
  }

  Future<String?> deleteVisaEntry(int visaId, int entryId)async{
    print("deleteVisaEntry");   

    final response = await apiProvider.deleteSecure("$visasUrl$visaId}/entry/$entryId");     
    
    return response["response"];
  } 

}

  
