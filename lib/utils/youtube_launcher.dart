import 'package:url_launcher/url_launcher.dart';

Future<void> launchYoutubeVideo(String youtubeUrl) async {
  var url = Uri.parse(youtubeUrl);
  if (youtubeUrl.isNotEmpty) {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
      );
    }
  }
}
