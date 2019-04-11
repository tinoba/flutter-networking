class Photo{

  final String title;
  final String url;

  Photo._({this.title, this.url});

  factory Photo.fromJson(Map<String, dynamic> json){
    return new Photo._(
        title: json['title'],
        url: json['thumbnailUrl']
    );
  }
}