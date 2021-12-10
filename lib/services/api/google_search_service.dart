import 'dart:convert';

import 'package:hackathon_study_materials/datamodels/found_material.dart';
import 'package:hackathon_study_materials/datamodels/resource_site.dart';
import 'package:http/http.dart' as http;

class GoogleSearchService {
  Future<List<FoundMaterial>> findMaterials(
      String query, List<ResourceSite> resourceSites, int numResults) async {
    final formattedQuery = query.replaceAll(' ', '+'); // TODO:
    final foundMaterials = <FoundMaterial>[];
    for (final resourceSite in resourceSites) {
      final response = await http.get(Uri.parse(
          'https://customsearch.googleapis.com/customsearch/v1?q=$formattedQuery+site%3A${resourceSite.siteUrl}&num=$numResults&cx=f275893cab2f143cb&key=AIzaSyAyJkpSEZbvOHeM_k2cNfHKmdWs6G7amvA'));
      if (response.statusCode == 200) {
        final searchResults = jsonDecode(response.body)['items'];
        foundMaterials.add(searchResults.map((item) => FoundMaterial(
              siteName: resourceSite.title,
              title: item['title'],
              url: item['link'],
              imageUrl: item['pagemap']['cse_thumbnail']['src'],
            )));
      }
    }
    return foundMaterials;
  }
}
