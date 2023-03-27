import 'package:docs_clone_flutter/repository/auth_repository.dart';
import 'package:docs_clone_flutter/screnns/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../colors.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void signInWithGoogle(WidgetRef ref, BuildContext context) async{
    final sMessanger = ScaffoldMessenger.of(context);// ye sirf isliye kyu async mein builderContext nhi use karte
    final navigator = Routemaster.of(context);
    final errorModel =  await ref.read(authRepositoryProvider).signInWithGoogle();
    if(errorModel.error == null){
      ref.read(userProvider.notifier).update((
        state) => errorModel.data
        );// aagar notifier nhi lagate toh dot ke baad alag show karega options
        navigator.replace('/');
    } else{
        sMessanger.showSnackBar(
        SnackBar(content: Text(errorModel.error!),),);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // wo authRepositoryprovider call ke liye widgetref lagega

    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(onPressed: ()=>signInWithGoogle(ref,context),
          icon:Image.asset("assets/docs-logo.png",height: 20 ,) ,
          label: const Text("Sign in with google",style: TextStyle(color: kBlackColor ),),style: ElevatedButton.styleFrom(
          backgroundColor: kWhiteColor,
          minimumSize: const Size(150,50),
        ),),

      ),
    );
  }
}
