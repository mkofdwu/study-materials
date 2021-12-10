class FoundMaterial {
  String topicName;
  String siteName;
  String title;
  String url;
  String? imageUrl;
  bool selected;

  FoundMaterial({
    required this.topicName,
    required this.siteName,
    required this.title,
    required this.url,
    this.imageUrl,
    this.selected = true,
  });
}
