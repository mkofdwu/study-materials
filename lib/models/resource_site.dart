class ResourceSite {
  String title;
  String siteUrl;
  String? queryUrl;

  ResourceSite({required this.title, required this.siteUrl, this.queryUrl});

  factory ResourceSite.fromMap(Map<String, dynamic> map) {
    return ResourceSite(
      title: map['title'],
      siteUrl: map['siteUrl'],
      queryUrl: map['queryUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'siteUrl': siteUrl,
        'queryUrl': queryUrl,
      };
}
