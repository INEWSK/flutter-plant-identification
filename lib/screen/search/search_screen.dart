import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/screen/detail/detail_sample_screen.dart';
import 'package:flutter_hotelapp/screen/widgets/error_page.dart';
import 'package:flutter_hotelapp/screen/widgets/search_bar.dart';
import 'package:flutter_hotelapp/screen/widgets/shimmer_effect.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'components/plant_card.dart';
import 'provider/tree_data_provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  @override
  bool get wantKeepAlive => true;

  final provider = TreeDataProvider();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Filter',
            icon: SvgPicture.asset('assets/icons/filter.svg'),
            onPressed: () {
              showSearch(context: context, delegate: SearchBar());
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return ChangeNotifierProvider(
      create: (_) => provider,
      child: Consumer<TreeDataProvider>(
        builder: (_, data, __) {
          switch (data.status) {
            case Status.Error:
              return ErrorPage(press: data.fetchTreeData);
              break;
            case Status.Loaded:
              return _buildTreeCard(data);
              break;
            // TODO: 視情況修改loading effect, 有點唐突
            case Status.Loading:
              return ShimmerEffect();
              break;
            default:
              data.fetchTreeData();
              return ShimmerEffect();
          }
        },
      ),
    );
  }

  Widget _buildTreeCard(TreeDataProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.fetchTreeData(),
      child: ListView.builder(
        // shrinkWrap: true,
        itemCount: provider.treeData.length,
        itemBuilder: (BuildContext context, int index) {
          return PlantCard(
            title: provider.treeData[index].commonName,
            imgSrc: 'assets/images/bauhinia_blakeana.jpg',
            sname: provider.treeData[index].scientificName,
            intro: provider.treeData[index].introduction,
            press: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailSampleScreen(),
              ),
            ),
          );
        },
      ),
    );
  }
}
