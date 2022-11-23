import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance/shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../styles/colors.dart';

// ignore: must_be_immutable
class AddBlogsScreen extends StatelessWidget {
  AddBlogsScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppSuccessAddArticleState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Add Article'),
            ),
            body: bodyWidget(context, state));
      },
    );
  }

  Widget bodyWidget(context, state) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Article',
                  style: TextStyle(
                      color: const Color(0xff000000),
                      fontSize: MediaQuery.of(context).size.height / 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                defaultFormField(context,
                    controller: AppCubit.get(context).titleController,
                    hint: 'Title of the Article',
                    type: TextInputType.text, validate: (value) {
                  if (value!.isEmpty) {
                    return "title must not be Empty";
                  }
                  return null;
                }),
                const SizedBox(
                  height: 15,
                ),
                dropDownWidget(context),
                const SizedBox(
                  height: 15,
                ),
                defaultFormField(context,
                    controller: AppCubit.get(context).locationController,
                    hint: 'Location',
                    type: TextInputType.text, validate: (value) {
                  if (value!.isEmpty) {
                    return "content must not be Empty";
                  }
                  return null;
                }),
                const SizedBox(
                  height: 15,
                ),
                defaultFormField(context,
                    controller: AppCubit.get(context).contentController,
                    hint: 'Article Content',
                    maxlines: 5,
                    height: 7,
                    type: TextInputType.text, validate: (value) {
                  if (value!.isEmpty) {
                    return "content must not be Empty";
                  }
                  return null;
                }),
                const SizedBox(
                  height: 15,
                ),
                pickImageWidget(context),
                const SizedBox(
                  height: 15,
                ),
                button(context, state)
              ],
            ),
          ),
        ),
      );

  Widget dropDownWidget(context) => InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) => Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffE8E8EE),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Column(
                    children: [
                      buildRadioBig('Therapy', context),
                      buildRadioBig('Yoga', context),
                      buildRadioBig('Life Coach', context),
                      buildRadioBig('Nutrition', context),
                    ],
                  ),
                ));
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 12,
        decoration: const BoxDecoration(
          color: Color(0xffE8E8EE),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: ListTile(
            title: Text(AppCubit.get(context).categoryArticlevalue),
            trailing: const Icon(
              Icons.arrow_drop_down,
              color: defaultColor,
              size: 40,
            )),
      ));

  Widget button(context, state) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          state is AppLoadingAddArticleState
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : defaultButton(
                  function: () {
                    if (formKey.currentState!.validate() &&
                        AppCubit.get(context).categoryArticlevalue !=
                            'Category' &&
                        AppCubit.get(context).images != null) {
                      AppCubit.get(context).uploadFile(
                          title: AppCubit.get(context).titleController.text,
                          content: AppCubit.get(context).contentController.text,
                          category: AppCubit.get(context).categoryArticlevalue,
                          location:
                              AppCubit.get(context).locationController.text);
                    } else {
                      showToast(
                          text: 'Please Fill All Fields',
                          state: ToastStates.error);
                    }
                  },
                  text: 'submit'),
        ],
      );

  Widget pickImageWidget(context) => InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => bottomSheet(
              text: 'Your',
              camera: () => AppCubit.get(context).getcameraImage(),
              gallery: () => AppCubit.get(context).getGalleryImage(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: AppCubit.get(context).images!.isEmpty
              ? Container(
                  width: double.infinity,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xffE8E8EE),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.image,
                          color: defaultColor,
                          size: 35,
                        ),
                        Text(
                          'Upload Your Photo / Video',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ))
              : Container(
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xffE8E8EE),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: GridView.builder(
                      itemCount: AppCubit.get(context).images!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5),
                      itemBuilder: (context, index) {
                        return Image.file(
                          File(AppCubit.get(context).images![index].path),
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
        ),
      );

  Widget buildRadioBig(String value, context) {
    return Row(
      children: [
        Radio(
            value: value,
            groupValue: AppCubit.get(context).categoryArticlevalue,
            onChanged: (value) {
              AppCubit.get(context).changeCategoryArticleValue(value);
            }),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        )
      ],
    );
  }
}
