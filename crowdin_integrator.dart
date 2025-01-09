import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print('Error: distribution_hash value must be provided as a parameter.');
    return;
  }

  final distributionHash = args[0];
  final manifestUrl = 'https://distributions.crowdin.net/$distributionHash/manifest.json'; // URL to the manifest JSON
  final distributionBaseUrl = 'https://distributions.crowdin.net/$distributionHash';
  final outputDirectory = 'l10n';

  try {
    final manifestJson = await downloadJson(manifestUrl);
    final urls = generateUrls(manifestJson, distributionBaseUrl);

    for (final url in urls) {
      print('Downloading file from: $url');
      final content = await downloadFile(url);
      final processedContent = processFileContent(content);
      final fileName = extractFileName(url);
      await writeFile(outputDirectory, fileName, processedContent);
      print('File written: $outputDirectory/$fileName');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<Map<String, dynamic>> downloadJson(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return json.decode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception('Failed to load JSON from $url');
  }
}

List<String> generateUrls(Map<String, dynamic> manifestJson, String baseUrl) {
  final List<String> urls = [];
  final int timestamp = manifestJson['timestamp'];
  final Map<String, dynamic> content = manifestJson['content'];

  for (final paths in content.values) {
    for (final path in paths) {
      final url = '$baseUrl$path?timestamp=$timestamp';
      urls.add(url);
    }
  }

  return urls;
}

Future<String> downloadFile(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to download file from $url');
  }
}

String processFileContent(String content) {
  final jsonData = json.decode(content) as Map<String, dynamic>;
  jsonData.remove('@@locale');
  return const JsonEncoder.withIndent('  ').convert(jsonData);
}

String extractFileName(String url) {
  final uri = Uri.parse(url);
  final pathSegments = uri.pathSegments;
  return pathSegments.isNotEmpty ? pathSegments.last.split('?').first : 'unknown_file';
}

Future<void> writeFile(String directory, String fileName, String content) async {
  final dir = Directory(directory);
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }

  final file = File('${dir.path}/$fileName');
  await file.writeAsString(content, mode: FileMode.write);
}
