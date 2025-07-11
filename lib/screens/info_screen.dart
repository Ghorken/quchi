import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:quchi/lang/strings.dart';
import 'package:quchi/themes/themes.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<StatefulWidget> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String _markdownContent = '';

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.backgroundColor,
      appBar: AppBar(
        title: Text(strings.info),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        backgroundColor: Themes.appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(strings.bugRequest, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text(strings.join, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse(strings.discord);
                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  throw '${strings.urlError} $url';
                }
              },
              child: Image.asset('assets/icons/discord.png', height: 150),
            ),
            Text(strings.sendEmail, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            GestureDetector(
              onTap: () async {
                final Uri emailUri = Uri(scheme: 'mailto', path: strings.email, queryParameters: {'subject': strings.support});
                if (!await launchUrl(emailUri)) {
                  throw '${strings.urlError} ${strings.email}';
                }
              },
              child: Text(strings.email, style: TextStyle(fontSize: 25.0, color: Colors.blue, decoration: TextDecoration.underline)),
            ),
            const SizedBox(height: 50),
            Expanded(child: MarkdownWidget(data: _markdownContent)),
          ],
        ),
      ),
    );
  }

  Future<void> _loadMarkdown() async {
    final String policyPath = Platform.localeName.contains('it') ? 'assets/privacy/privacy_it.md' : 'assets/privacy/privacy_en.md';
    final String content = await rootBundle.loadString(policyPath);
    setState(() {
      _markdownContent = content;
    });
  }
}
