import 'package:get_it/get_it.dart';
import 'package:gstudent/injection.config.dart';
import 'package:injectable/injectable.dart';

//flutter packages pub run build_runner build --delete-conflicting-outputs

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => $initGetIt(getIt);
