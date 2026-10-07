import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yodoctor/modules/patient/widgets/custom_sliver_app_bar.dart';
import 'package:yodoctor/modules/patient/widgets/qr_scanner.dart';
import 'models/services_model.dart';
import 'widgets/service_card.dart';
import 'widgets/services_header.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {

  void _openQRScanner() {
    QrScannerSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            CustomSliverAppBar(
              titleText: 'Services',
              expandedHeight: 220,
              background: ServicesHeader(
                servicesCount: medicalServicesList.length,
              ),
            ),
          ];
        },
        body: MasonryGridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          physics: const BouncingScrollPhysics(),
          itemCount: medicalServicesList.length,
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          itemBuilder: (context, index) {
            final service = medicalServicesList[index];
            return ServiceCard(service: service, onQrTap: _openQRScanner);
          },
        ),
      ),
    );
  }
}
