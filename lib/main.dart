import 'package:crowdin_sdk/crowdin_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/crowdin_localizations.dart';

Future<void> main() async {
  try {
    await Crowdin.init(
      distributionHash: const String.fromEnvironment('CROWDINHASH'),
      connectionType: InternetConnectionType.any,
      updatesInterval: const Duration(hours: 1),
    );
  } catch (e) {
    print(e);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void _changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crowdin Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: CrowdinLocalization.localizationsDelegates,
      home: MyHomePage(onLocaleChange: _changeLocale),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Function(Locale) onLocaleChange;

  const MyHomePage({required this.onLocaleChange, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    final contextLocale = Localizations.localeOf(context);
    print('APP locale: $contextLocale');
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.homepage),
        actions: [
          DropdownButton<Locale>(
            value: contextLocale,
            icon: const Icon(Icons.language, color: Colors.white),
            onChanged: (Locale? newValue) async {
              if (newValue != null) {
                print('APP locale selected: $newValue');
                Crowdin.loadTranslations(newValue).then((_){
                  onLocaleChange(newValue);
                });
                // await Crowdin.loadTranslations(Locale('fr'));
              }
            },
            items: const [
              DropdownMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: Locale('fr'),
                child: Text('Français'),
              ),
              DropdownMenuItem(
                value: Locale('es'),
                child: Text('Español'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localization.configuration),
            const SizedBox(height: 16),
            Text(localization.open),
            const SizedBox(height: 16),
            Text(localization.information),
            const SizedBox(height: 16),
            Text(localization.tryAgain),
            const SizedBox(height: 16),
            Text(localization.receiptSentTo('john.doe@example.com')),
          ],
        ),
      ),
    );
  }
}
