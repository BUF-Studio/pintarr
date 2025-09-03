import 'package:qr_flutter/qr_flutter.dart';

class QrManager {
  static create(data) {
    return QrImageView(
      version: QrVersions.auto,
      data: data,
      gapless: true,
    );
  }

 
}
