import 'package:mayr_i18n/mayr_i18n.dart';

/// Comprehensive example showing all features of mayr_i18n
Future<void> main() async {
  print("auth.register".tr());
  print('🌍 Comprehensive mayr_i18n Example\n');
  print('=' * 60);

  // 1. Initialize and load translations
  print('\n1️⃣  Initializing...');
  await MayrI18n.instance.load();
  print('✅ Loaded ${MayrI18n.instance.getAvailableLocales().length} locales');

  // 2. Basic translation
  print('\n2️⃣  Basic Translation:');
  print('   Key: "app.title"');
  print('   Result: "${MayrI18n.instance.tr('app.title')}"\n');

  // 3. Translation with placeholders
  print('3️⃣  Translation with Placeholders:');
  print('   Key: "app.welcome"');
  print('   Args: {name: "Developer"}');
  print(
    '   Result: "${MayrI18n.instance.tr('app.welcome', args: {'name': 'Developer'})}"\n',
  );

  // 4. Nested keys
  print('4️⃣  Nested Keys:');
  print('   Key: "auth.errors.invalid"');
  print('   Result: "${MayrI18n.instance.tr('auth.errors.invalid')}"\n');

  // 5. String extension usage
  print('5️⃣  Using String Extension:');
  print('   Code: "profile.title".tr()');
  print('   Result: "${'profile.title'.tr()}"\n');

  // 6. Language switching
  print('6️⃣  Language Switching:');
  final testKey = 'app.logout';
  print('   Current: ${MayrI18n.instance.currentLocale}');
  print('   "$testKey" = "${testKey.tr()}"');

  MayrI18n.instance.changeLanguage('fr');
  print('   Switched to: ${MayrI18n.instance.currentLocale}');
  print('   "$testKey" = "${testKey.tr()}"');

  MayrI18n.instance.changeLanguage('genz');
  print('   Switched to: ${MayrI18n.instance.currentLocale}');
  print('   "$testKey" = "${testKey.tr()}"\n');

  // 7. Key existence check
  print('7️⃣  Checking Key Existence:');
  print(
    '   "app.welcome" exists: ${MayrI18n.instance.keyExists('app.welcome')}',
  );
  print(
    '   "non.existent" exists: ${MayrI18n.instance.keyExists('non.existent')}\n',
  );

  // 8. Missing key behavior
  print('8️⃣  Missing Key Behavior:');
  print('   Key: "does.not.exist"');
  print(
    '   Result: "${MayrI18n.instance.tr('does.not.exist')}" (returns key)\n',
  );

  // 9. List all locales
  print('9️⃣  Available Locales:');
  for (final locale in MayrI18n.instance.getAvailableLocales()) {
    print('   - $locale');
  }

  // 10. Show all keys for current locale
  print(
    '\n🔟 All Keys in Current Locale (${MayrI18n.instance.currentLocale}):',
  );
  final keys = MayrI18n.instance.getAllKeys().toList()..sort();
  for (final key in keys) {
    print('   - $key');
  }

  print('\n${'=' * 60}');
  print('✅ Example complete!\n');

  // Best practices summary
  print('📚 Best Practices:');
  print('   1. Always call load() before using translations');
  print('   2. Use .tr() extension for cleaner code');
  print('   3. Check keyExists() for optional translations');
  print('   4. Organize keys with dot notation (app.section.key)');
  print('   5. Use CLI tools (verify, sync, audit) in development');
  print('');
}
