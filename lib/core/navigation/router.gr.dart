// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:custom_supabase_drift_sync/presentation/pages/editor_page/doc_page.dart'
    as _i1;
import 'package:custom_supabase_drift_sync/presentation/pages/home_page/home_page.dart'
    as _i2;
import 'package:custom_supabase_drift_sync/presentation/pages/login_page/login_page.dart'
    as _i3;
import 'package:custom_supabase_drift_sync/presentation/pages/project_page/project_page.dart'
    as _i4;
import 'package:custom_supabase_drift_sync/presentation/pages/sign_up_page/signup_page.dart'
    as _i5;
import 'package:custom_supabase_drift_sync/presentation/pages/task_page/task_page.dart'
    as _i6;
import 'package:flutter/material.dart' as _i8;

/// generated route for
/// [_i1.DocPage]
class DocRoute extends _i7.PageRouteInfo<DocRouteArgs> {
  DocRoute({
    required String taskId,
    _i8.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          DocRoute.name,
          args: DocRouteArgs(
            taskId: taskId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'DocRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DocRouteArgs>();
      return _i1.DocPage(
        taskId: args.taskId,
        key: args.key,
      );
    },
  );
}

class DocRouteArgs {
  const DocRouteArgs({
    required this.taskId,
    this.key,
  });

  final String taskId;

  final _i8.Key? key;

  @override
  String toString() {
    return 'DocRouteArgs{taskId: $taskId, key: $key}';
  }
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.LoginPage]
class LoginRoute extends _i7.PageRouteInfo<void> {
  const LoginRoute({List<_i7.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.LoginPage();
    },
  );
}

/// generated route for
/// [_i4.ProjectPage]
class ProjectRoute extends _i7.PageRouteInfo<ProjectRouteArgs> {
  ProjectRoute({
    _i8.Key? key,
    required String projectId,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          ProjectRoute.name,
          args: ProjectRouteArgs(
            key: key,
            projectId: projectId,
          ),
          initialChildren: children,
        );

  static const String name = 'ProjectRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProjectRouteArgs>();
      return _i4.ProjectPage(
        key: args.key,
        projectId: args.projectId,
      );
    },
  );
}

class ProjectRouteArgs {
  const ProjectRouteArgs({
    this.key,
    required this.projectId,
  });

  final _i8.Key? key;

  final String projectId;

  @override
  String toString() {
    return 'ProjectRouteArgs{key: $key, projectId: $projectId}';
  }
}

/// generated route for
/// [_i5.SignupPage]
class SignupRoute extends _i7.PageRouteInfo<void> {
  const SignupRoute({List<_i7.PageRouteInfo>? children})
      : super(
          SignupRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignupRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.SignupPage();
    },
  );
}

/// generated route for
/// [_i6.TaskPage]
class TaskRoute extends _i7.PageRouteInfo<TaskRouteArgs> {
  TaskRoute({
    _i8.Key? key,
    required String taskId,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          TaskRoute.name,
          args: TaskRouteArgs(
            key: key,
            taskId: taskId,
          ),
          initialChildren: children,
        );

  static const String name = 'TaskRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TaskRouteArgs>();
      return _i6.TaskPage(
        key: args.key,
        taskId: args.taskId,
      );
    },
  );
}

class TaskRouteArgs {
  const TaskRouteArgs({
    this.key,
    required this.taskId,
  });

  final _i8.Key? key;

  final String taskId;

  @override
  String toString() {
    return 'TaskRouteArgs{key: $key, taskId: $taskId}';
  }
}
