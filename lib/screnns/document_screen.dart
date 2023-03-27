import 'package:docs_clone_flutter/colors.dart';
import 'package:docs_clone_flutter/common%20widgets/loader.dart';
import 'package:docs_clone_flutter/models/error_model.dart';
import 'package:docs_clone_flutter/repository/auth_repository.dart';
import 'package:docs_clone_flutter/repository/socket_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/document_model.dart';
import '../repository/document_repository.dart';



class DocumentScreen extends ConsumerStatefulWidget {
  final String id; 
  const DocumentScreen({
    Key? key,required this.id
    }) : super(key:key);
  

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  quill.QuillController? _controller;
  ErrorModel? errorModel;// global as used in both quill to save data and fetch data func

  TextEditingController titleController = TextEditingController(
    text : "UNTITLED DOCUMENT"
  );
  SocketRepository socketRepository = SocketRepository();

  @override
  void initState(){
    super.initState();
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();

    socketRepository.changeListener((data){
      _controller?.compose(quill.Delta.fromJson(data['delta']), _controller?.selection??const TextSelection.collapsed(offset: 0), quill.ChangeSource.REMOTE);
    });
  }


  void fetchDocumentData() async {
    errorModel = await ref.read(documentRepositoryProvider).getDocumentById(
      ref.read(userProvider)!.token,
      widget.id,
    );

    if( errorModel!.data != null){
      //_controller.document = quill.Document.fromJson(errorModel!.data!.content);
      titleController.text = (errorModel!.data as DocumentModel).title;
      _controller =quill.QuillController(document: errorModel!.data.content.isEmpty? quill.Document():quill.Document.fromDelta(quill.Delta.fromJson(errorModel!.data.content),),selection: const TextSelection.collapsed(offset: 0));
      setState(() {
        
      });
    }
    _controller!.document.changes.listen((event) {
      // ye 3 kaam karega 
      //entire content of - document
      //changes that are made from the previous part
      //local? ->ve have typed remote? // infinite loop se bahar nikalega as remote save rahega sab 
      if(event.item3 == quill.ChangeSource.LOCAL){
        Map<String,dynamic> map = {
         
          'delta':event.item2,
          'room':widget.id,
        };
        socketRepository.typing(map);
      }
    });
  }
  
  @override
  void dispose(){
    super.dispose();
    titleController.dispose();
  }

  void updateTitle(WidgetRef ref,String title){
    ref.read(documentRepositoryProvider).updateTitle(
      token:ref.read(userProvider)!.token,
      id: widget.id,
      title: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    if(_controller == null){
      return const Scaffold(
        body: Loader()
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(onPressed: (){},
            icon: Icon(Icons.lock,size: 16,),
            label: const Text("Share"),
            style: ElevatedButton.styleFrom(
              backgroundColor: kBlueColor,
            ),
             
            ),
          )
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical:8.0),
          child: Row(
            children: [
              Image.asset('images/docs-logo.png',height: 40,),
              const SizedBox(width: 10),
              SizedBox(
                width: 180,

                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kBlueColor,
                      )
                    ),
                    contentPadding: EdgeInsets.only(left: 10, )

                  ), 
                  onSubmitted: (value){
                    updateTitle(ref, value);
                  }, 
                ),
              )
            ],

          ),
        ),
        bottom: PreferredSize(
          child:Container
          (
            decoration: BoxDecoration(
              border: Border.all(
                color: kGreyColor,
        width: 0.1
              ),
            ),
         ),
         preferredSize: const Size.fromHeight(1),),
      ),
      body: Center(
        child: Column(
        children: [
          const SizedBox(
            height: 10,  
          ),
          quill.QuillToolbar.basic(controller: _controller!),
          Expanded(
        child: SizedBox(
          width: 750,
          child: Card(
            color: kWhiteColor,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: quill.QuillEditor.basic(
                controller: _controller!,
                readOnly: false, // true for view only mode
              ),
            ),
          ),
        ),
          )
        ],
      ),
      ),
    );
  }
  
  
}