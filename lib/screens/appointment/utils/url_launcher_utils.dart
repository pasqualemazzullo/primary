import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtils {
  static Future<void> openMapsByAddress(String name, String address) async {
    final String searchQuery = Uri.encodeComponent('$name, $address');
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$searchQuery',
    );

    try {
      if (!await launchUrl(
        googleMapsUrl,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch Google Maps';
      }
    } catch (e) {
      // Non succede niente.
    }
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      // Non succede niente.
    }
  }

  static Future<void> sendEmail(String email) async {
    final url = 'mailto:$email?subject=Inviata da Primary';
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      // Non succede niente.
    }
  }
}
