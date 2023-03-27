import 'package:docs_clone_flutter/colors.dart';
import 'package:docs_clone_flutter/models/error_model.dart';
import 'package:docs_clone_flutter/router.dart';
import 'package:docs_clone_flutter/screnns/home_screen.dart';
import 'package:docs_clone_flutter/screnns/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docs_clone_flutter/repository/auth_repository.dart';
import 'package:routemaster/routemaster.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // consumerstate store karega widget ka reference in widget ref
  ErrorModel? errorModel;

  @override
  void initState() {
    
    super.initState();
    getUserData();
  }


  void getUserData() async{
    errorModel = await ref.read(authRepositoryProvider).getUserData();

    if(errorModel!= null && errorModel!.data != null){
      ref.read(userProvider.notifier).update((state) => errorModel!.data);
    }
  }
  @override
  Widget build(BuildContext context) {  
    // This widget is the root of your application.
    
    return MaterialApp.router(
      title: 'Flutter Demo $kBlackColor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context){
        final user = ref.watch(userProvider);
        if(user!=null && user.token.isNotEmpty){
          return loggedInRoute;
        }
        return loggedOutRoute;
      }),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
