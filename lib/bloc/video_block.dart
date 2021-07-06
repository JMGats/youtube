import 'dart:async';
import 'dart:ui';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/foundation.dart';
import 'package:youtube/api/api.dart';
import 'package:youtube/models/video.dart';

class VideosBloc implements BlocBase {
  Api api;

  List<Video> videos;
  final StreamController<List<Video>> _videosController =
      StreamController<List<Video>>();

  //puxar os dados do bloc
  Stream get outVideos => _videosController.stream;

  // passar(add) os dados do bloc
  final StreamController<String> _searchController = StreamController<String>();

  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = Api();
    _searchController.stream.listen(_search);
  }

  void _search(String search) async {
    if (search != null) {
      _videosController.sink.add([]);
      videos = await api.search(search);
    } else {
      videos += await api.nextPage();
    }
    //pedindo para api retornar os dados
    //pesquisando video

    // colocou os dados da pesquisa no controller
    _videosController.sink.add(videos);
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }


  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }


  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();


  void notifyListeners() {
    // TODO: implement notifyListeners
  }


  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }
}
