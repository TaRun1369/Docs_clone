import 'dart:convert';

class DocumentModel {
  final String title;
  final String uid;
  final List content;// kuch bhi type ho sakta hai isliye define he nhi kiya type list ka
  final DateTime createdAt;
  final String id;

  DocumentModel({
    required this.title, 
    required this.uid,
    required this.content,
    required this.createdAt,
    required this.id
    });

     Map<String, dynamic> toMap() {
    return {
      'title': title,
      'uid': uid,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'id': id,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      title: map['title'] ?? '',
      uid: map['uid'] ?? '',// user id of document isko banaya he uid ke naam se hai isliye string mein uid likha hai
      content: List.from(map['content']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      id: map['_id'] ?? '',// ye uid se alag ...isko _id se he banaya hai
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) => DocumentModel.fromMap(json.decode(source));
}


