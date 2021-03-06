import 'package:anime_twist_flut/animations/SlideInAnimation.dart';
import 'package:anime_twist_flut/main.dart';
import 'package:anime_twist_flut/models/FavouritedModel.dart';
import 'package:anime_twist_flut/pages/favourites_page/FavouritedAnimeTile.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:anime_twist_flut/utils/GetUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key key}) : super(key: key);

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage>
    with AutomaticKeepAliveClientMixin {
  TwistApiService twistApiService = Get.find();
  final dummyScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    super.build(context);
    return Consumer(
      builder: (context, watch, child) {
        var prov = watch(favouriteAnimeProvider);
        List<FavouritedModel> favouritedAnimes =
            prov.favouritedAnimes.reversed.toList();

        if (favouritedAnimes.isEmpty) {
          return SlideInAnimation(
            child: Center(
              child: Icon(
                FontAwesomeIcons.heartBroken,
                size: 75,
              ),
            ),
          );
        }
        return Scrollbar(
          thickness: 4,
          controller: dummyScrollController,
          child: CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverPadding(
                padding: EdgeInsets.all(15.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: isPortrait ? 0.65 : 1.4,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var model = twistApiService
                          .getTwistModelFromSlug(favouritedAnimes[index].slug);

                      return FavouritedAnimeTile(
                        favouritedModel: favouritedAnimes.elementAt(index),
                        twistModel: model,
                      );
                    },
                    childCount: favouritedAnimes.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
