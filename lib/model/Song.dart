class Song {
  String name;
  String imgUrl;

  Song({required this.name, required this.imgUrl});

  factory Song.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];
    final name = volumeInfo['title'] ?? '';
    final imageLinks = volumeInfo['imageLinks'] ?? '';
    final imageUrl = imageLinks['thumbnail'] ?? '';
    print("imgUrl $imageUrl");
    return Song(name: name, imgUrl: imageUrl);
  }

  static fromMap(Map<dynamic, dynamic> songValue) {
    var name = songValue["name"] ?? '';
    var imgUrl = songValue["imgUrl"] ?? '';

    return Song(
      name: name,
      imgUrl: imgUrl,
    );
  }
}
