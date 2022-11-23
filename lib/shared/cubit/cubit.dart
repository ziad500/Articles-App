import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'package:freelance/models/article_model.dart';
import 'package:freelance/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  void changeIndex(index) {
    currentIndex = index;
    emit(ChangeIndexState());
  }

  List<XFile>? images = [];
  final ImagePicker picker = ImagePicker();

  Future getGalleryImage() async {
    final List<XFile> selectedImages = await picker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      images!.addAll(selectedImages);
    }
    emit(ImagePickerCoverArticleSuccess());
  }

  getcameraImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return;
    }
    images!.add(image);
    emit(ImagePickerCoverArticleSuccess());
  }

  var titleController = TextEditingController();
  var contentController = TextEditingController();
  var locationController = TextEditingController();

  String categoryArticlevalue = 'Category';
  void changeCategoryArticleValue(value) {
    categoryArticlevalue = value;
    emit(CategoryArticlevalueSuccessState());
  }

  void createArticle(
      {String? category,
      String? content,
      String? location,
      String? title,
      List<String>? images}) {
    FirebaseFirestore.instance
        .collection("articles")
        .doc()
        .set(ArticlesModel(
                category: category,
                content: content,
                location: location,
                title: title,
                time: Timestamp.now(),
                images: images)
            .toMap())
        .then((value) {
      getArticles();
      emit(AppSuccessAddArticleState());
    }).catchError((error) {
      emit(AppErrorAddArticleState());
    });
  }

  List<ArticlesModel> articles = [];

  List<String> urls = [];
  firebase_storage.Reference? ref;
  void uploadFile(
      {String? category,
      String? content,
      String? location,
      String? title}) async {
    urls = [];
    emit(AppLoadingAddArticleState());

    for (var image in images!) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("images/${path.basename(image.path)}");
      ref!.putFile(File(image.path)).then((value) {
        value.ref.getDownloadURL().then((value) {
          urls.add(value);
          if (urls.length == images!.length) {
            createArticle(
                category: category,
                content: content,
                location: location,
                title: title,
                images: urls);
          }
        });
      });
    }
  }

  void getArticles() {
    articles = [];
    emit(AppLoadingGetArticleState());
    FirebaseFirestore.instance.collection('articles').get().then((value) {
      for (var element in value.docs) {
        articles.add(ArticlesModel.fromJson(element.data()));
      }
      emit(AppSuccessGetArticleState());
    }).catchError((error) {
      emit(AppErrorGetArticleState());
    });
  }

  List<ArticlesModel> searchList = [];

  void search(String name) {
    emit(AppLoadingSearchArticleState());
    List<ArticlesModel> searchList2 = [];

    searchList2 = articles
        .where((element) =>
            element.title!.toLowerCase().contains(name.toLowerCase()))
        .toList();
    searchList = searchList2;
    if (searchList.isNotEmpty) {
      emit(AppSuccessSearchArticleState());
    } else {
      emit(AppErrorSearchArticleState());
    }
  }
}
