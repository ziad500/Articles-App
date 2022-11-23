import 'package:cloud_firestore/cloud_firestore.dart';

class ArticlesModel {
  String? title;
  String? category;
  String? content;
  String? location;
  List<String>? images;
  Timestamp? time;

  ArticlesModel(
      {this.category,
      this.content,
      this.location,
      this.title,
      this.time,
      this.images});

  ArticlesModel.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    category = json["category"];
    content = json["content"];
    location = json["location"];
    images = json["images"] != null
        ? List.from(json["images"]).map((e) => e.toString()).toList()
        : [];
    time = json["time"];
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "category": category,
      "content": content,
      "location": location,
      "time": time,
      "images": images?.map((e) => e.toString()).toList()
    };
  }
}
