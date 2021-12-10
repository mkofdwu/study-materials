class FoundMaterial {
  String siteName;
  String title;
  String url;
  String? imageUrl;

  FoundMaterial({
    required this.siteName,
    required this.title,
    required this.url,
    this.imageUrl,
  });
}
