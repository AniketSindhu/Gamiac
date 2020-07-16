class GameSearch {
  final String name;
  final String image;
  final String slug;
  final String metacritic;
GameSearch._({this.name, this.image,this.slug,this.metacritic});
factory GameSearch.fromJson(Map<String, dynamic> json) {
    return new GameSearch._(
      name: json['name'].toString(),
      image: json['background_image'].toString(),
      slug:json['slug'].toString(),
      metacritic:json['metacritic'].toString()
    );
  }
}