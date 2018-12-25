import 'package:dio/dio.dart';
import '../bus.dart';

postArticle() async {
  Dio dio = new Dio();
  print('post analysis');
  var response =
      await dio.post("http://192.168.1.102:3004/api/analysis", data: {
    "content": """
      The official symbol of seven South American nations, the Andean condor has played an important role in the history and folklore of the Andean region for centuries. The Andean condor represents power and health to many Andean cultures and has even been associated with the sun deity who was believed to be the ruler of the upper world. In recent years, this revered species has come under threat due to habitat loss, retaliation from farmers who view the bird as a danger to livestock, and collisions with power lines. Since the early 1990s, @thewcs has worked with local Bolivian communities on sustainable natural resource management in the country's Madidi ­Tambopata landscape, a stronghold for condors. I am honored that images like this one will be featured in Nat Geo’s new multimedia, orchestral live experience, Symphony for Our World, touring now. Photo taken @tracyaviary.

A ScrollView that creates custom scroll effects using slivers.

A CustomScrollView lets you supply slivers directly to create various scrolling effects, such as lists, grids, and expanding headers. For example, to create a scroll view that contains an expanding app bar followed by a list and a grid, use a list of three slivers: SliverAppBar, SliverList, and SliverGrid.

Widgets in these slivers must produce RenderSliver objects.

To control the initial scroll offset of the scroll view, provide a controller with its ScrollController.initialScrollOffset property set.

      """
  });
  bus.emit('analysis_done', response.data);
}
