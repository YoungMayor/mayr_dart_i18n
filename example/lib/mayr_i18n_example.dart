import 'package:mayr_i18n/mayr_i18n.dart';

Future<void> main() async {
  // Load translations from default location (assets/i18n)
  await MayrI18n.instance.load();

  print('\n🌍 MayrI18n Example\n');

  // Basic translation
  print('English:');
  print('  ${MayrI18n.instance.tr('app.welcome', args: {'name': 'Mayor'})}');
  print('  ${MayrI18n.instance.tr('auth.login')}');
  print('  ${MayrI18n.instance.tr('auth.errors.invalid')}');

  // Switch to French
  print('\nFrançais:');
  MayrI18n.instance.changeLanguage('fr');
  print('  ${MayrI18n.instance.tr('app.welcome', args: {'name': 'Mayor'})}');
  print('  ${MayrI18n.instance.tr('auth.login')}');
  print('  ${MayrI18n.instance.tr('auth.errors.invalid')}');

  // Switch to GenZ
  print('\nGenZ:');
  MayrI18n.instance.changeLanguage('genz');
  print('  ${MayrI18n.instance.tr('app.welcome', args: {'name': 'Mayor'})}');
  print('  ${MayrI18n.instance.tr('auth.login')}');
  print('  ${MayrI18n.instance.tr('auth.errors.invalid')}');

  // Using string extension
  print('\n🧩 Using String Extension (.tr()):');
  print('  ${'app.logout'.tr()}');
  print('  ${'profile.title'.tr()}');

  // Show available locales
  print('\n📋 Available locales:');
  print('  ${MayrI18n.instance.getAvailableLocales().join(', ')}');

  print('\n✅ Example complete!\n');
}
