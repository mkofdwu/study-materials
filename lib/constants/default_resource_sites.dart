import 'package:hackathon_study_materials/datamodels/resource_site.dart';

final defaultResourceSites = [
  ResourceSite(
    title: 'Books',
    siteUrl: 'books.google.com',
  ),
  ResourceSite(
    title: 'Academic papers',
    siteUrl: 'scholar.google.com',
    queryUrl: 'https://scholar.google.com/scholar?q=%URL%',
  ),
  ResourceSite(
    title: 'Youtube videos',
    siteUrl: 'youtube.com',
  ),
  ResourceSite(title: 'Open source projects', siteUrl: 'github.com'),
  ResourceSite(title: 'Khan academy', siteUrl: 'khanacademy.org'),
  ResourceSite(title: 'Wikipedia', siteUrl: 'en.wikipedia.com')
];
