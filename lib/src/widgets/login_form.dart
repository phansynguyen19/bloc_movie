// import 'package:bloc_movie_my/src/blocs/login_blocs/login_bloc.dart';
// import 'package:bloc_movie_my/src/ui/movies_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:formz/formz.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginForm extends StatefulWidget {
//   const LoginForm({Key? key}) : super(key: key);

//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: const Alignment(0, -1 / 3),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
//             child: TextField(
//               controller: usernameController,
//               autocorrect: false,
//               autofocus: true,
//               // onChanged: (text) {
//               //   _searchBloc.add(
//               //     TextChanged(text: text),
//               //   );
//               // },
//               decoration: InputDecoration(
//                 prefixIcon: Padding(
//                   padding: const EdgeInsets.only(right: 20),
//                   child: new IconButton(
//                     icon: new Icon(Icons.arrow_back, size: 25),
//                     onPressed: () {
//                       // editingController.text = '';
//                       // _searchBloc.add(const TextChanged(text: ''));
//                       // Navigator.pop(context);
//                     },
//                   ),
//                 ),
//                 border: InputBorder.none,
//                 hintText: 'Enter username',
//               ),
//             ),
//           ),
//           const Padding(padding: EdgeInsets.all(12)),
//           Padding(
//             padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
//             child: TextField(
//               controller: passwordController,
//               autocorrect: false,
//               autofocus: true,
//               // onChanged: (text) {
//               //   _searchBloc.add(
//               //     TextChanged(text: text),
//               //   );
//               // },
//               decoration: InputDecoration(
//                 prefixIcon: Padding(
//                   padding: const EdgeInsets.only(right: 20),
//                   child: new IconButton(
//                     icon: new Icon(Icons.arrow_back, size: 25),
//                     onPressed: () {
//                       // editingController.text = '';
//                       // _searchBloc.add(const TextChanged(text: ''));
//                       // Navigator.pop(context);
//                     },
//                   ),
//                 ),
//                 border: InputBorder.none,
//                 hintText: 'Enter password',
//               ),
//             ),
//           ),
//           const Padding(padding: EdgeInsets.all(12)),
//           ElevatedButton(
//             child: Text('Login'),
//             onPressed: () {},
//           )
//         ],
//       ),
//     );
//   }
// }
