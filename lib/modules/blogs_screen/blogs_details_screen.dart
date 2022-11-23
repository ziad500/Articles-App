import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance/shared/cubit/cubit.dart';
import 'package:freelance/shared/cubit/states.dart';
import 'package:intl/intl.dart';

import '../../styles/colors.dart';

class BlogsDetailsScreen extends StatelessWidget {
  final String title;
  final List<String>? images;
  final String content;
  final Timestamp? date;
  final String location;
  final String type;
  final carouselController = CarouselController();

  BlogsDetailsScreen(
      {Key? key,
      required this.title,
      required this.images,
      required this.date,
      required this.content,
      required this.location,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 6.0,
            centerTitle: true,
            title: const Text('Details'),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                carouselSlider(context),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < images!.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _getProperCircle(
                            i, images, AppCubit.get(context).currentIndex),
                      )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22.0, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 22,
                                color: const Color(0xff333333),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                              "$location , ${DateFormat('yyyy-MM-dd  kk:mm').format(DateTime.parse(date!.toDate().toString()))}")
                        ],
                      ),
                      Text(type),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Text(
                    content,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 35,
                      color: const Color.fromARGB(255, 59, 59, 59),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget carouselSlider(context) => CarouselSlider(
      carouselController: carouselController,
      items: images!
          .map((e) => Image(
                image: NetworkImage(e),
                fit: BoxFit.cover,
                width: double.infinity,
              ))
          .toList(),
      options: CarouselOptions(
          height: 250.0,
          initialPage: 0,
          enableInfiniteScroll: true,
          onPageChanged: (index, reason) {
            AppCubit.get(context).changeIndex(index);
          },
          reverse: false,
          viewportFraction: 1.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(seconds: 1),
          autoPlayCurve: Curves.fastOutSlowIn,
          scrollDirection: Axis.horizontal));

  _getProperCircle(int index, List<String>? images, int currentIndex) {
    if (index == currentIndex) {
      return const Icon(
        Icons.circle_outlined,
        color: defaultColor,
        size: 13,
      );
    } else {
      return const Icon(
        Icons.circle,
        color: defaultColor,
        size: 10,
      );
    }
  }
}
