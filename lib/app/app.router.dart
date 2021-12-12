// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../datamodels/module.dart';
import '../datamodels/topic.dart';
import '../ui/views/about_view.dart';
import '../ui/views/flexible_form_page/flexible_form_page.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/module/module_view.dart';
import '../ui/views/note/note_view.dart';
import '../ui/views/search/search_view.dart';
import '../ui/views/sign_in_or_up/sign_in_or_up_view.dart';
import '../ui/views/startup/startup_view.dart';
import '../ui/views/topic/topic_view.dart';
import '../ui/views/welcome_view.dart';

class Routes {
  static const String startupView = '/';
  static const String homeView = '/home-view';
  static const String signInOrUpView = '/sign-in-or-up-view';
  static const String welcomeView = '/welcome-view';
  static const String flexibleFormPage = '/flexible-form-page';
  static const String moduleView = '/module-view';
  static const String topicView = '/topic-view';
  static const String noteView = '/note-view';
  static const String searchView = '/search-view';
  static const String aboutView = '/about-view';
  static const all = <String>{
    startupView,
    homeView,
    signInOrUpView,
    welcomeView,
    flexibleFormPage,
    moduleView,
    topicView,
    noteView,
    searchView,
    aboutView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startupView, page: StartupView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.signInOrUpView, page: SignInOrUpView),
    RouteDef(Routes.welcomeView, page: WelcomeView),
    RouteDef(Routes.flexibleFormPage, page: FlexibleFormPage),
    RouteDef(Routes.moduleView, page: ModuleView),
    RouteDef(Routes.topicView, page: TopicView),
    RouteDef(Routes.noteView, page: NoteView),
    RouteDef(Routes.searchView, page: SearchView),
    RouteDef(Routes.aboutView, page: AboutView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartupView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const StartupView(),
        settings: data,
      );
    },
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const HomeView(),
        settings: data,
      );
    },
    SignInOrUpView: (data) {
      var args = data.getArgs<SignInOrUpViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SignInOrUpView(
          key: args.key,
          signUp: args.signUp,
        ),
        settings: data,
      );
    },
    WelcomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const WelcomeView(),
        settings: data,
      );
    },
    FlexibleFormPage: (data) {
      var args = data.getArgs<FlexibleFormPageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => FlexibleFormPage(
          key: args.key,
          title: args.title,
          subtitle: args.subtitle,
          fieldsToWidgets: args.fieldsToWidgets,
          onSubmit: args.onSubmit,
          textDefaultValues: args.textDefaultValues,
        ),
        settings: data,
      );
    },
    ModuleView: (data) {
      var args = data.getArgs<ModuleViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ModuleView(
          key: args.key,
          module: args.module,
        ),
        settings: data,
      );
    },
    TopicView: (data) {
      var args = data.getArgs<TopicViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => TopicView(
          key: args.key,
          topic: args.topic,
          parentModule: args.parentModule,
        ),
        settings: data,
      );
    },
    NoteView: (data) {
      var args = data.getArgs<NoteViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => NoteView(
          key: args.key,
          title: args.title,
          content: args.content,
          saveNote: args.saveNote,
        ),
        settings: data,
      );
    },
    SearchView: (data) {
      var args = data.getArgs<SearchViewArguments>(
        orElse: () => SearchViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => SearchView(
          key: args.key,
          module: args.module,
          topic: args.topic,
        ),
        settings: data,
      );
    },
    AboutView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AboutView(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// SignInOrUpView arguments holder class
class SignInOrUpViewArguments {
  final Key? key;
  final bool signUp;
  SignInOrUpViewArguments({this.key, required this.signUp});
}

/// FlexibleFormPage arguments holder class
class FlexibleFormPageArguments {
  final Key? key;
  final String title;
  final String? subtitle;
  final Map<String, dynamic> fieldsToWidgets;
  final void Function(
      Map<String, dynamic>, dynamic Function(Map<String, String>)) onSubmit;
  final Map<String, String>? textDefaultValues;
  FlexibleFormPageArguments(
      {this.key,
      required this.title,
      this.subtitle,
      required this.fieldsToWidgets,
      required this.onSubmit,
      this.textDefaultValues});
}

/// ModuleView arguments holder class
class ModuleViewArguments {
  final Key? key;
  final Module module;
  ModuleViewArguments({this.key, required this.module});
}

/// TopicView arguments holder class
class TopicViewArguments {
  final Key? key;
  final Topic topic;
  final Module parentModule;
  TopicViewArguments(
      {this.key, required this.topic, required this.parentModule});
}

/// NoteView arguments holder class
class NoteViewArguments {
  final Key? key;
  final String title;
  final String content;
  final Future<dynamic> Function(String, String) saveNote;
  NoteViewArguments(
      {this.key,
      required this.title,
      required this.content,
      required this.saveNote});
}

/// SearchView arguments holder class
class SearchViewArguments {
  final Key? key;
  final Module? module;
  final Topic? topic;
  SearchViewArguments({this.key, this.module, this.topic});
}
