import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
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
            onChanged: (Locale? newValue) async {
              if (newValue != null) {
                print('APP locale selected: $newValue');
                  onLocaleChange(newValue);
              }
            },
            items: const [
              DropdownMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: Locale('fr', 'FR'),
                child: Text('Français'),
              ),
              DropdownMenuItem(
                value: Locale('es', 'ES'),
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
