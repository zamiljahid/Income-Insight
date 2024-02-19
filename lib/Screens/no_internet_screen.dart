import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../internet_check_provider.dart';

class NoInternetScreen extends ConsumerWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noInternetNotifier = ref.watch(noInternetProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('animation/noInternet.json', height: 250),
          const SizedBox(height: 5),
          Text(
            'No Internet Connection',
            style: TextStyle(
                color: Colors.red,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            child: MaterialButton(
                color: Colors.red,
                child: noInternetNotifier.isLoading
                    ?  Center(
                  child: CircularProgressIndicator(
                      color: Colors.white,
                  ),
                )
                    :  Text(
                  'Try Again',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
                onPressed: noInternetNotifier.isLoading
                    ? null
                    : () async {
                  noInternetNotifier.setLoadingTrue();
                  await Future.delayed(
                    const Duration(milliseconds: 2000),
                  );
                  noInternetNotifier.setLoadingFalse();
                }),
          ),
        ],
      ),
    );
  }
}