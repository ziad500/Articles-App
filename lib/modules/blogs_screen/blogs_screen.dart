import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance/models/article_model.dart';
import 'package:freelance/modules/search/search_screen.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../styles/colors.dart';
import 'add_blogs_screen.dart';
import 'blogs_details_screen.dart';

// ignore: must_be_immutable
class BlogsScreen extends StatelessWidget {
  BlogsScreen({Key? key}) : super(key: key);
  var imagesController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Articles"),
            actions: [
              IconButton(
                  onPressed: () {
                    navigateTo(context, const SearchScreen());
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: defaultColor,
            child: const Icon(Icons.edit),
            onPressed: () {
              navigateTo(context, AddBlogsScreen());
            },
          ),
          body: AppCubit.get(context).articles.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 18.0, bottom: 20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'LATEST ARTICLES',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: defaultColor),
                              onPressed: () {
                                navigateTo(context, AddBlogsScreen());
                              },
                              child: const Text('ADD ARTICLE'),
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      const Text(
                        "no articles yet!",
                        style: TextStyle(color: defaultColor),
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 18.0, bottom: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'LATEST ARTICLES',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            reverse: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) => articleItem(
                                AppCubit.get(context).articles[index],
                                index,
                                context),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 15.0,
                                ),
                            itemCount: AppCubit.get(context).articles.length),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget articleItem(ArticlesModel? model, var index, context) => Padding(
        padding: const EdgeInsets.only(right: 18.0),
        child: InkWell(
          onTap: () {
            navigateTo(
                context,
                BlogsDetailsScreen(
                  content: model.content.toString(),
                  location: model.location.toString(),
                  type: model.category.toString(),
                  images: model.images,
                  date: model.time,
                  title: model.title.toString(),
                ));
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 4.5,
            width: double.infinity,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                CarouselSlider(
                    items: model!.images!
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
                        scrollDirection: Axis.horizontal)),
                Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.4),
                        // soften the shadow
                        spreadRadius: 0.0, //extend the shadow
                        offset: const Offset(
                          0, // Move to right 10  horizontally
                          0, // Move to bottom 5 Vertically
                        ),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      model.title.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < model.images!.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _getProperCircle(i, model.images,
                              AppCubit.get(context).currentIndex),
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );

  _getProperCircle(int index, List<String>? images, int currentIndex) {
    if (index == currentIndex) {
      return const Icon(
        Icons.circle_outlined,
        color: defaultColor,
        size: 13,
      ) /* SvgPicture.asset(ImageAssets.hollowCircleIcon) */;
    } else {
      return const Icon(
        Icons.circle,
        color: defaultColor,
        size: 10,
      ) /* SvgPicture.asset(ImageAssets.solidCircleIcon) */;
    }
  }
}
