import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docs_clone_flutter/constants.dart';
import 'package:docs_clone_flutter/models/error_model.dart';
import 'package:http/http.dart';

import '../models/document_model.dart';

final documentRepositoryProvider = Provider(
  (ref)=> DocumentRepository(
    client: Client()
    )
);

class DocumentRepository{
  final Client _client;
  DocumentRepository({
    required Client client,
  }) : _client = client;

  Future<ErrorModel> createDocument(String token) async{
    ErrorModel error = ErrorModel(error: 'Some shit', data: null,);
    
    try{
     
          var res = await _client.post(
            Uri.parse('$host/doc/create'),// get request mein no body
            headers:{ 
              'Content-Type' : 'application/json; charset=UTF-8',
              'x-auth-token':token,
            }, body: jsonEncode({
              // idhar bosy bhi passs hogi as it is post request
              'createdAt' : DateTime.now().millisecondsSinceEpoch,
            }),
          );

            switch(res.statusCode){
             case 200:
             error = ErrorModel(
            error: null , 
             data: DocumentModel.fromJson(res.body),// yaha json encode decode ki jarurat nhi kyuki wo pehle karna padega
             );
             break;
             default:
             error = ErrorModel(
            error: res.body , 
             data: null,// yaha json encode decode ki jarurat nhi kyuki wo pehle karna padega
             );
          }
    }
    catch(e){

      //print(e);
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> getDocuments(String token) async{
    ErrorModel error = ErrorModel(error: 'Some shit', data: null,);
    
    try{
     
          var res = await _client.get(
            Uri.parse('$host/docs/me'),// get request mein no body
            headers:{ 
              'Content-Type' : 'application/json; charset=UTF-8',
              'x-auth-token':token,
            }, 
          );

            switch(res.statusCode){
             case 200:
             List<DocumentModel> documents = [];
             for(int i = 0;i<jsonDecode(res.body).length;i++){
                documents.add(DocumentModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
             }
            error = ErrorModel(
            error: null , 
             data: documents,// yaha json encode decode ki jarurat nhi kyuki wo pehle karna padega
             );
             break;
             default:
             error = ErrorModel(
            error: res.body , 
             data: null,// yaha json encode decode ki jarurat nhi kyuki wo pehle karna padega
             );
          }
    }
    catch(e){

      //print(e);
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }



  void updateTitle({
    required String token,
    required String id,
    required String title
    }) async{
            await _client.post(
            Uri.parse('$host/doc/title'),// get request mein no body
            headers:{ 
              'Content-Type' : 'application/json; charset=UTF-8',
              'x-auth-token':token,
            }, body: jsonEncode({
              // idhar bosy bhi passs hogi as it is post request
              'id' : id,
              'title' : title,
              
            }),
          );       
    
  }

 Future<ErrorModel> getDocumentById(String token,String id) async{
    ErrorModel error = ErrorModel(error: 'Some shit', data: null,);
    
    try{
     
          var res = await _client.get(
            Uri.parse('$host/doc/$id'),// get request mein no body
            headers:{ 
              'Content-Type' : 'application/json; charset=UTF-8',
              'x-auth-token':token,
            }, 
          );

            switch(res.statusCode){
             case 200:
            //  DocumentModel document = DocumentModel.fromJson(res.body);
            error = ErrorModel(
            error: null , 
             data: DocumentModel.fromJson(res.body),// yaha json encode decode ki jarurat nhi kyuki wo pehle karna padega
             );
             break;
             default:
             throw 'Error in getting document naya bana';
          }
    }
    catch(e){

      //print(e);
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }


}