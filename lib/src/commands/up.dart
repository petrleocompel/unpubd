/// dcli script generated by:
/// dcli create docker_push.dart
///
/// See
/// https://pub.dev/packages/dcli#-installing-tab-
///
/// For details on installing dcli.
///
///
///import 'dart:io';

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import '../global_args.dart';
import '../unpubd_settings.dart';
import '../util/log.dart';

///
class UpCommand extends Command<void> {
  ///
  UpCommand();

  @override
  String get description => 'Starts the unpubd daemon.';

  @override
  String get name => 'up';

  @override
  void run() {
    if (!exists(UnpubdSettings.pathToSettings)) {
      logerr(red('''You must run 'unpubd install' first.'''));
      exit(1);
    }

    if (!ParsedArgs().secureMode) {
      log(orange('Warning: you are running in insecure mode. '
          'Hash files can be modified by any user.'));
    }
    up();
  }

  ///
  void up() {
    /// Create the .env for docker-compose to get its environment from.
    UnpubdSettings.pathToDotEnv
      ..write('MONGO_INITDB_ROOT_USERNAME=root')
      ..append(
          'MONGO_INITDB_ROOT_PASSWORD=${UnpubdSettings().mongoRootPassword}')
      ..append('MONGO_INITDB_DATABASE=${UnpubdSettings().mongoDatabase}')
      ..append('TZ=${DateTime.now().timeZoneName}')
      ..append('UNPUBD_HOST=${UnpubdSettings().unpubHost}')
      ..append('UNPUBD_PORT=${UnpubdSettings().unpubPort}');

    build();
  }

  Future<void> build() async {
    print('Coniguring docker packages');
    'docker-compose up'
        .start(workingDirectory: dirname(UnpubdSettings.pathToDockerCompose));
  }
}