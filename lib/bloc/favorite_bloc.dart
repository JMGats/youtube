import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import "package:bloc_pattern/bloc_pattern.dart";
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube/models/video.dart';

class FavoriteBloc implements BlocBase {
  Map<String, Video> _favorites = {};
  final _favController = BehaviorSubject<Map<String, Video>>.seeded({});

  //saida de acesso, a altera o numero de favoritos
  Stream<Map<String, Video>> get outFav => _favController.stream;

  // salvar permanentimento os favoritos
  FavoriteBloc() {
    //sharepreference so permite salvar String
    SharedPreferences.getInstance().then(
      (prefs) {
        if (prefs.getKeys().contains("favorites")) {
          // esse if pergunta se tem favoritos salvos
          _favorites = jsonDecode(prefs.getString("favorites")).map((key, v) {
            return MapEntry(key, Video.fromJson(v));
          }).cast<String,
              Video>(); //salvadondo o _favorites no json como String dps convertendo para o map String video
          _favController.add(_favorites); //
        }
      },
    );
  }

  void toggleFavorite(Video video) {
    //tirando o video dos favoritos
    if (_favorites.containsKey(video.id))
      _favorites.remove(video.id);
    //colocando os videos no favoritos
    else
      _favorites[video.id] = video;

    //enviando a lista atualizada de favoritos para o controller
    _favController.sink.add(_favorites);

    _saveFav();
  }

  void _saveFav() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("favorites", json.encode(_favorites));
    });
  }

  @override
  void dispose() {
    _favController.close();
  }

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }
}
