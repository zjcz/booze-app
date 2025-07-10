import 'package:booze_app/policy_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'unknown',
    packageName: 'unknown',
    version: 'unknown',
    buildNumber: 'unknown',
  );

  final applWebSiteUrl = Uri(
    scheme: 'https',
    host: 'github.com',
    path: 'zjcz/booze-app',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SafeArea(
        minimum: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20.0,
              children: [
                Image.asset('assets/images/icon-256x256.png'),
                Text(
                  'Booze App',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Version: ${_packageInfo.version}, build: ${_packageInfo.buildNumber}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                ElevatedButton(
                  child: const Text('Visit Website'),
                  onPressed: () => _launchInBrowser(applWebSiteUrl),
                ),
                ElevatedButton(
                  child: const Text('Terms and Conditions'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PolicyViewerScreen(
                          policyType: PolicyType.termsAndConditions,
                        ),
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  child: const Text('Privacy Policy'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PolicyViewerScreen(
                          policyType: PolicyType.privacyPolicy,
                        ),
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  child: const Text('3rd Party Licenses'),
                  onPressed: () {
                    showLicensePage(context: context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unable to launch website')));
    }
  }
}
