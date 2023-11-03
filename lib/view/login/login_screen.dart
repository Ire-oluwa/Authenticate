import 'package:authentikate/model/google_sign_in/res_google_sign_in.dart';
import 'package:authentikate/utils/constants.dart';
import 'package:authentikate/utils/strings.dart';
import 'package:authentikate/view/components/alert_dialog.dart';
import 'package:authentikate/view/components/custom_text.dart';
import 'package:authentikate/view/components/custom_text_field.dart';
import 'package:authentikate/view/login/bloc/login_bloc.dart';
import 'package:authentikate/view/main_screen/main_screen.dart';
import 'package:authentikate/view/registration/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return SafeArea(
      child: Scaffold(
        body: kUnfocus(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: Strings.welcomeBack,
                  colour: kBlack,
                  weight: FontWeight.bold,
                  size: 32.sp,
                ),
                SizedBox(height: 15.h),
                CustomText(
                  text: Strings.continueSignIn,
                  colour: kGrey,
                  weight: FontWeight.bold,
                  size: 12.sp,
                ),
                SizedBox(height: 30.h),
                _buildEmail(),
                SizedBox(height: 15.h),
                _buildPassword(),
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: Strings.forgotPassword,
                    colour: kBlack,
                    weight: FontWeight.w500,
                    size: 14.sp,
                  ),
                ),
                SizedBox(height: 20.h),

                /// SIGN-UP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: Strings.createAccount,
                      size: 14.sp,
                      weight: FontWeight.w400,
                      colour: kGrey,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: CustomText(
                        text: Strings.signUp,
                        size: 14.sp,
                        weight: FontWeight.bold,
                        colour: kBlue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                ///SOCIAL MEDIA SIGN-IN
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _googleSignIn(context: context),
                      child: Image.asset(
                        "assets/images/google_logo.png",
                        width: 40.w,
                        height: 40.h,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Image.asset(
                      "assets/images/Facebook_logo.png",
                      width: 40.w,
                      height: 40.h,
                    ),
                  ],
                ),
                SizedBox(height: 260.h),

                /// SIGN-IN
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (BuildContext context, LoginState state) {
                    if (state is LoginLoaded &&
                        state.loginResponse.success.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => CustomAlertDialog(
                          title: Strings.welcome,
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(),
                                ),
                              ),
                              child: const Text("Ok"),
                            ),
                          ],
                        ),
                      );
                    } else if (state is LoginError) {
                      final message = state.error;
                      showDialog(
                        context: context,
                        builder: (context) => CustomAlertDialog(
                          title: Strings.regError,
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                "$message",
                                textAlign: TextAlign.justify,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      Future.delayed(const Duration(seconds: 3));
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Future.delayed(const Duration(seconds: 3));
                            loginBloc.add(GetLogin(
                                email: _email.text, password: _password.text));
                            print(loginBloc.loginResponse?.success.toString());
                          },
                          child: Container(
                            height: 40.h,
                            width: 320.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: kBlue,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: BlocBuilder<LoginBloc, LoginState>(
                              bloc: loginBloc,
                              builder:
                                  (BuildContext context, LoginState state) {
                                if (state is LoginLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return CustomText(
                                  text: Strings.signIn,
                                  colour: kWhite,
                                  weight: FontWeight.w500,
                                  size: 16.sp,
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmail() {
    return CustomTextField(
      hint: Strings.email,
      inputType: kEmailType,
      formatter: kEmailFormatter,
      onChanged: (value) {},
      controller: _email,
    );
  }

  Widget _buildPassword() {
    return CustomTextField(
      hint: Strings.password,
      controller: _password,
      onChanged: (value) {},
      inputType: kPasswordType,
      formatter: kPasswordFormatter,
    );
  }

  //Google SignIn Process
  void _googleSignIn({required BuildContext context}) async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      String? token = googleAuth.idToken;

      ResGoogleSignInModel socialMediaUser = ResGoogleSignInModel(
        googleUser.displayName,
        googleUser.email,
        googleUser.photoUrl,
        googleUser.id,
        token,
      );

      Fluttertoast.showToast(
        msg: googleUser.email,
        backgroundColor: kBlue,
        textColor: kWhite,
      );
      () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
    } catch (error) {
      print("Google Sign-In Error: $error");

      Fluttertoast.showToast(
        msg: Strings.googleSignInError,
        backgroundColor: kRed,
        textColor: kWhite,
      );
    }
  }

  //Facebook SignIn Process
  // void _facebookSignInProcess(BuildContext context) async {
  //   LoginResult result = await FacebookAuth.instance.login();
  //   ProgressDialogUtils.showProgressDialog(context);
  //   if (result.status == LoginStatus.success) {
  //     AccessToken accessToken = result.accessToken!;
  //     Map<String, dynamic> userData = await FacebookAuth.i.getUserData(
  //       fields: KeyConstants.facebookUserDataFields,
  //     );
  //     ProgressDialogUtils.dismissProgressDialog();
  //     Fluttertoast.showToast(
  //         msg: userData[KeyConstants.emailKey],
  //         backgroundColor: Colors.blue,
  //         textColor: Colors.white);
  //     LogUtils.showLog("${accessToken.userId}");
  //     LogUtils.showLog("$userData");
  //   } else {
  //     ProgressDialogUtils.dismissProgressDialog();
  //   }
  // }
}
