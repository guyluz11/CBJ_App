import 'package:auto_route/auto_route.dart';
import 'package:cybear_jinni/application/esphome_auth/esphome_sign_in_form/esphome_sign_in_form_bloc.dart';
import 'package:cybear_jinni/domain/vendors/vendor.dart';
import 'package:cybear_jinni/injection.dart';
import 'package:cybear_jinni/presentation/add_vendors_pages/add_esphome_vendor/widgets/esphome_sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AddEspHomeVendorPage extends StatelessWidget {
  const AddEspHomeVendorPage(this.vendor);

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('EspHome Sign In'),
      ),
      body: BlocProvider(
        create: (context) => getIt<EspHomeSignInFormBloc>(),
        child: EspHomeSignInForm(vendor),
      ),
    );
  }
}
