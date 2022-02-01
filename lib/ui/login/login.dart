import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/font_family.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/utils/device/device_utils.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:boilerplate/widgets/app_icon_widget.dart';
import 'package:boilerplate/widgets/authentication_page_bg.dart';
import 'package:boilerplate/widgets/buttons.dart';
import 'package:boilerplate/widgets/empty_app_bar_widget.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //stores:---------------------------------------------------------------------
  late ThemeStore _themeStore;

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;

  //stores:---------------------------------------------------------------------
  final _store = FormStore();

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeStore = Provider.of<ThemeStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      backgroundColor: AppColors.main[50],
      appBar: EmptyAppBar(),
      body: _buildBody(),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      child: Stack(
        children: <Widget>[
          AuthenticationPageBG(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                SizedBox(height: 130),
                AppIconWidget(image: 'assets/icons/ic_appicon.png'),
                SizedBox(height: 16),
                Text(
                  "Continue to your account",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: FontFamily.quickSand,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )
              ],
            )
          ]),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SizedBox(height: 120), _buildCard()],
            ),
          ),
          Observer(
            builder: (context) {
              return _store.success
                  ? navigate(context)
                  : _showErrorMessage(_store.errorStore.errorMessage);
            },
          ),
          Observer(
            builder: (context) {
              return Visibility(
                visible: _store.loading,
                child: CustomProgressIndicatorWidget(),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildCardContent()],
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 31.0, vertical: 31),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildUserIdField(),
            SizedBox(height: 19.0),
            _buildPasswordField(),
            SizedBox(height: 19.0),
            _buildSignInButton(),
            SizedBox(height: 19.0),
            Row(
              children: [
                _buildSignUpInsteadButton(),
                Spacer(),
                _buildForgotPasswordButton(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUserIdField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: AppLocalizations.of(context).translate('login_et_user_email'),
          inputType: TextInputType.emailAddress,
          icon: Icons.person,
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _userEmailController,
          inputAction: TextInputAction.next,
          autoFocus: false,
          isIcon: false,
          onChanged: (value) {
            _store.setUserId(_userEmailController.text);
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          errorText: _store.formErrorStore.userEmail,
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint:
              AppLocalizations.of(context).translate('login_et_user_password'),
          isObscure: true,
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.lock,
          isIcon: false,
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _passwordController,
          focusNode: _passwordFocusNode,
          errorText: _store.formErrorStore.password,
          onChanged: (value) {
            _store.setPassword(_passwordController.text);
          },
        );
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: FractionalOffset.bottomRight,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(0.0),
        ),
        child: Text(
          "Forgot Password",
          style: TextStyle(
              fontSize: 14,
              fontFamily: FontFamily.quickSand,
              fontWeight: FontWeight.w600,
              color: AppColors.deepBlueColor),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildSignUpInsteadButton() {
    return Align(
      alignment: FractionalOffset.bottomLeft,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(0.0),
        ),
        child: Text(
          "Sign up Instead",
          style: TextStyle(
              fontSize: 14,
              fontFamily: FontFamily.quickSand,
              fontWeight: FontWeight.bold,
              color: AppColors.main[50]),
        ),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(Routes.register);
        },
      ),
    );
  }

  Widget _buildSignInButton() {
    return BasicFilledButton(
        text: "Sign In",
        callback: signIn,
        fillColor: AppColors.main[50] ?? Colors.blue,
        textColor: Colors.white);
  }

  signIn() {
    print("clicked");
    if (_store.canLogin) {
      DeviceUtils.hideKeyboard(context);
      _store.login();
    } else {
      _showErrorMessage('Please fill in all fields');
    }
  }

  Widget navigate(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(Preferences.is_logged_in, true);
    });

    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.home, (Route<dynamic> route) => false);
    });

    return Container();
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    if (message.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 0), () {
        if (message.isNotEmpty) {
          FlushbarHelper.createError(
            message: message,
            title: AppLocalizations.of(context).translate('home_tv_error'),
            duration: Duration(seconds: 3),
          )..show(context);
        }
      });
    }

    return SizedBox.shrink();
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _userEmailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
