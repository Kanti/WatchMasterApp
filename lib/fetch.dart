import 'dart:ffi';

import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class Series {
  String _title;
  String _link;
  String _genre;

  Series(this._title, this._link, this._genre);

  factory Series.fromJson(dom.Element element, String genre) {
    return Series(element.text, element.attributes['href'] ?? '', genre);
  }

  String get title {
    return _title;
  }

  String get link {
    return _link;
  }

  Uri get uri {
    return Uri(scheme: 'https', host: 'bs.to', path: _link);
  }

  String get genre {
    return _genre;
  }
}

Future<List<Series>> fetchAll() async {
  final httpPackageUrl = Uri.parse('https://bs.to/andere-serien');
  final httpPackageInfo = await http.read(httpPackageUrl);

  final document = html.parse(httpPackageInfo);
  final menu = document.getElementById('seriesContainer');
  if (menu == null) {
    throw Exception('could not find seriesContainer on bs.to');
  }
  final List<Series> seriesList = [];
  String genreString;
  for (dom.Element genre in menu.getElementsByClassName('genre')) {
    genreString = genre.getElementsByTagName('strong')[0].text;
    seriesList.addAll(genre
        .getElementsByTagName('a')
        .map((e) => Series.fromJson(e, genreString))
        .toList());
  }
  return seriesList;
}

class Season {
  Series? series;
  Int? number;
}

Future<void> fetchSeason(Series series, Int number) async {

}

Future<void> fetchStreamUrl(Uri uri) async {
  // final html = await http.read(uri);
  final html = await http.post(Uri.parse('https://bs.to/ajax/embed.php'),
      body: {'LID': '6244094'});
  print(html);
}

void main() async {
  fetchOne(Uri.parse(
      'https://bs.to/serie/Star-Trek-Lower-Decks/1/10-No-Small-Parts/de/UPStream'));

  return;

  final star = (await fetchAll()).firstWhere(
          (element) => element.title.contains('Star Trek: Lower Decks'));

  print(star);
}
