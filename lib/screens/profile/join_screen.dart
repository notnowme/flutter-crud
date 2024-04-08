// import 'package:crud/models/join_model.dart';
// import 'package:crud/providers/join_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class JoinScreen extends ConsumerWidget {
//   const JoinScreen({super.key});

//   static const String routeName = 'join';
//   static const String routePath = '/join';

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     JoinModel info = JoinModel(
//       id: 'test100',
//       nick: 'test100',
//       password: '1234',
//     );
//     final result = ref.watch(joinProvider(info));
//     return Scaffold(
//       body: Center(
//         child: Container(
//           child: result.when(
//             data: (data) {
//               if (data.isEmpty) {
//                 return const Text('No data');
//               } else {
//                 return Text(data['ok']);
//               }
//             },
//             error: (error, stackTrace) {
//               return const Text('Some Error');
//             },
//             loading: () => const Text('loading...'),
//           ),
//         ),
//       ),
//     );
//   }
// }
