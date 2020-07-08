class GameSearch {
  final String name;
  final String image;
  final String slug;
GameSearch._({this.name, this.image,this.slug,});
factory GameSearch.fromJson(Map<String, dynamic> json) {
    return new GameSearch._(
      name: json['name'].toString(),
      image: json['background_image'].toString(),
      slug:json['slug'].toString(),
    );
  }
}