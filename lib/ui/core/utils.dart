import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_discover/domain/models/city.dart';
import 'package:re_discover/domain/models/poi.dart';
import 'package:re_discover/ui/MAP/view_model/map_view_model.dart';
import 'package:re_discover/ui/MAP/widgets/POI_modal_bottom_sheet.dart';
import 'package:re_discover/ui/MAP/widgets/city_modal_bottom_sheet.dart';

void onShowModalMap({
  required BuildContext context,
  required ValueNotifier<double> distanceNotifier,
  required POI poi,
  required MapViewModel mapViewModel,
}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (ctx) => ChangeNotifierProvider.value(
      value: mapViewModel,
      child: PoiModalBottomSheet(distanceNotifier: distanceNotifier, poi: poi),
    ),
  );
}

void onShowModalCity({
  required BuildContext context,
  required City city,
}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (ctx) => CityModalBottomSheet(city: city),
  );
}
