// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'api/Authentication/authentication_api.dart' as _i4;
import 'api/base/HeaderProvider.dart' as _i7;
import 'api/Character/character_api.dart' as _i5;
import 'api/Clan/clan_api.dart' as _i6;
import 'api/Home/home_api.dart' as _i8;
import 'api/Home/route_api.dart' as _i14;
import 'api/Learning/trial_lesson_api.dart' as _i22;
import 'api/Mission/mission_api.dart' as _i10;
import 'api/notification/notification_api.dart' as _i12;
import 'api/Special/special_api.dart' as _i16;
import 'api/Test/test_api.dart' as _i18;
import 'api/TestInput/testinput_api.dart' as _i19;
import 'api/Training/vocab_api.dart' as _i24;
import 'authentication/services/authentication_services.dart' as _i26;
import 'authentication/services/trial_class_service.dart' as _i23;
import 'character/services/character_services.dart' as _i27;
import 'clan/services/clan_services.dart' as _i28;
import 'home/services/home_services.dart' as _i9;
import 'home/services/notification_service.dart' as _i13;
import 'home/services/route_services.dart' as _i15;
import 'mission/services/MissionService.dart' as _i11;
import 'settings/helper/ApplicationSettings.dart' as _i3;
import 'special/services/special_service.dart' as _i17;
import 'test/services/TestServices.dart' as _i21;
import 'testinput/services/testinput_services.dart' as _i20;
import 'training/services/vocab_services.dart'
    as _i25; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.ApplicationSettings>(() => _i3.ApplicationSettings());
  gh.factory<_i4.AuthenticationApi>(() => _i4.AuthenticationApi());
  gh.factory<_i5.CharacterApi>(() => _i5.CharacterApi());
  gh.factory<_i6.ClanApi>(() => _i6.ClanApi());
  gh.factory<_i7.HeaderProvider>(() => _i7.HeaderProvider());
  gh.factory<_i8.HomeApi>(() => _i8.HomeApi());
  gh.factory<_i9.HomeService>(() => _i9.HomeService(
      homeApi: get<_i8.HomeApi>(),
      headerProvider: get<_i7.HeaderProvider>(),
      applicationSettings: get<_i3.ApplicationSettings>()));
  gh.factory<_i10.MissionApi>(() => _i10.MissionApi());
  gh.factory<_i11.MissionService>(() => _i11.MissionService(
      api: get<_i10.MissionApi>(),
      headerProvider: get<_i7.HeaderProvider>(),
      applicationSettings: get<_i3.ApplicationSettings>()));
  gh.factory<_i12.NotificationApi>(() => _i12.NotificationApi());
  gh.factory<_i13.NotificationService>(() => _i13.NotificationService(
      api: get<_i12.NotificationApi>(),
      headerProvider: get<_i7.HeaderProvider>()));
  gh.factory<_i14.RouteApi>(() => _i14.RouteApi());
  gh.factory<_i15.RouteService>(() => _i15.RouteService(
      api: get<_i14.RouteApi>(),
      headerProvider: get<_i7.HeaderProvider>(),
      applicationSettings: get<_i3.ApplicationSettings>()));
  gh.factory<_i16.SpecialApi>(() => _i16.SpecialApi());
  gh.factory<_i17.SpecialService>(() => _i17.SpecialService(
      settings: get<_i3.ApplicationSettings>(),
      api: get<_i16.SpecialApi>(),
      headerProvider: get<_i7.HeaderProvider>()));
  gh.factory<_i18.TestApi>(() => _i18.TestApi());
  gh.factory<_i19.TestInputApi>(() => _i19.TestInputApi());
  gh.factory<_i20.TestInputService>(() => _i20.TestInputService(
      api: get<_i19.TestInputApi>(),
      headerProvider: get<_i7.HeaderProvider>(),
      applicationSettings: get<_i3.ApplicationSettings>()));
  gh.factory<_i21.TestService>(() => _i21.TestService(
      api: get<_i18.TestApi>(),
      headerProvider: get<_i7.HeaderProvider>(),
      applicationSettings: get<_i3.ApplicationSettings>()));
  gh.factory<_i22.TrialApi>(() => _i22.TrialApi());
  gh.factory<_i23.TrialService>(() => _i23.TrialService(
      api: get<_i22.TrialApi>(),
      headerProvider: get<_i7.HeaderProvider>(),
      applicationSettings: get<_i3.ApplicationSettings>()));
  gh.factory<_i24.VocabApi>(() => _i24.VocabApi());
  gh.factory<_i25.VocabService>(() => _i25.VocabService(
      api: get<_i24.VocabApi>(),
      headerProvider: get<_i7.HeaderProvider>(),
      applicationSettings: get<_i3.ApplicationSettings>()));
  gh.factory<_i26.AuthenticationService>(() => _i26.AuthenticationService(
      authenticationApi: get<_i4.AuthenticationApi>(),
      headerProvider: get<_i7.HeaderProvider>(),
      applicationSettings: get<_i3.ApplicationSettings>()));
  gh.factory<_i27.CharacterService>(() => _i27.CharacterService(
      api: get<_i5.CharacterApi>(),
      headerProvider: get<_i7.HeaderProvider>(),
      applicationSettings: get<_i3.ApplicationSettings>()));
  gh.factory<_i28.ClanService>(() => _i28.ClanService(
      api: get<_i6.ClanApi>(),
      headerProvider: get<_i7.HeaderProvider>(),
      applicationSettings: get<_i3.ApplicationSettings>()));
  return get;
}
