import 'package:auto_route/auto_route.dart';
import 'package:cybear_jinni/application/ewelink_auth/ewelink_sign_in_form/ewelink_sign_in_form_bloc.dart';
import 'package:cybear_jinni/domain/vendors/vendor.dart';
import 'package:cybear_jinni/injection.dart';
import 'package:cybear_jinni/presentation/add_vendors_pages/add_ewelink_vendor/widgets/ewelink_sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AddEwelinkVendorPage extends StatelessWidget {
  const AddEwelinkVendorPage(this.vendor);

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('eWeLink Sign In'),
      ),
      body: BlocProvider(
        create: (context) => getIt<EwelinkSignInFormBloc>(),
        child: EwelinkSignInForm(vendor),
      ),
    );
  }
}
