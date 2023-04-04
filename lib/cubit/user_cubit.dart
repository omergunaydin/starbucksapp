import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/user_api_client.dart';
import '../models/user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  StarUser? user;
  StreamSubscription? streamUser;
  StreamSubscription? streamUserData;

  UserCubit({this.user}) : super(UserInitial()) {
    debugPrint('UserCubit started!');
    streamUser = FirebaseAuth.instance.authStateChanges().listen((user) async {
      debugPrint('usercubit ${user.toString()}');

      if (user != null) {
        debugPrint('user signed in');
        StarUser? myUser = await UserApiClient().fetchUserData(user.uid);
        if (myUser != null) {
          emit(UserSignIn(user: myUser));
        }

        streamUserData = FirebaseFirestore.instance.collection('starusers').doc(user.uid).snapshots().listen((event) async {
          if (event.data() != null) {
            StarUser? myUser = StarUser.fromJson(event.data() as Map<String, dynamic>);
            print('DATA DEĞİŞTİ!!!!');
            //emit(UserDataChanged(user: myUser));
            emit(UserSignIn(user: myUser));
          }
        });
      } else if (user == null) {
        debugPrint('user signed out');
        emit(UserSignOut());
      }
    });
  }
}
