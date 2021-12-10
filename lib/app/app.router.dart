// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../datamodels/module.dart';
import '../datamodels/topic.dart';
import '../ui/views/flexible_form_page/flexible_form_page.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/module/module_view.dart';
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
  static const all = <String>{
    startupView,
    homeView,
    signInOrUpView,
    welcomeView,
    flexibleFormPage,
    moduleView,
    topicView,
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
        ),
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
  final void Function(Map<String, dynamic>,
      dynamic Function(Map<String, String>), dynamic Function()) onSubmit;
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
  TopicViewArguments({this.key, required this.topic});
}
