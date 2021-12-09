import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_study_materials/datamodels/resource_site.dart';

class User {
  String id;
  String email;
  List<String> moduleIds; // ids of modules
  // settings
  List<ResourceSite> resourceSites; // name: url
  int numResults;

  User({
    required this.id,
    required this.email,
    required this.moduleIds,
    required this.resourceSites,
    required this.numResults,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    final data = doc.data()!;
    return User(
      id: doc.id,
      email: data['email'],
      moduleIds: List<String>.from(data['modules']),
      resourceSites: List<ResourceSite>.from(data['resourceSites']
          .map((siteDoc) => ResourceSite.fromMap(siteDoc))),
      numResults: data['numResults'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'modules': moduleIds,
      'resourceSites':
          resourceSites.map((resourceSite) => resourceSite.toMap()).toList(),
      'numResults': numResults,
    };
  }

  @override
  bool operator ==(Object other) => other is User && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
