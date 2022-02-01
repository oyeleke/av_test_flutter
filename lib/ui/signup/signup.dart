import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/font_family.dart';
import 'package:boilerplate/stores/form/form_store.dart';
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

class SignUpScreen extends StatefulWidget {
  @override
  State createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  late FocusNode _passwordFocusNode;
  final _store = FormStore();

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      backgroundColor: AppColors.main[50],
      body: _buildBody(),
    );
  }

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
                  "Create your account",
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
              return Visibility(
                  visible: _store.loading,
                  child: CustomProgressIndicatorWidget());
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

  Widget _buildCardContent(){
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(31),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(child: _buildUserFirstNameField()),
                SizedBox(width: 14),
                Expanded(child: _buildUserLastNameField())
              ],
            ),
            SizedBox(height: 19.0),
            _buildUserIdField(),
            SizedBox(height: 5.0),
            _buildPasswordField(),
            SizedBox(height: 19.0),
            _buildSignInButton(),
            SizedBox(height: 19.0),
            _buildLogInInsteadButton()

          ],
        ),
      ),
    );
  }

  Widget _buildUserFirstNameField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: "First Name",
          inputType: TextInputType.name,
          icon: Icons.person,
          textController: _firstNameController,
          inputAction: TextInputAction.next,
          autoFocus: false,
          isIcon: false,
          onChanged: (value) {
            _store.setFirstName(_firstNameController.text);
          },
          onFieldSubmitted: (value) {
            //FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          errorText: _store.formErrorStore.firstName,
        );
      },
    );
  }

  Widget _buildUserLastNameField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: "Last Name",
          inputType: TextInputType.name,
          icon: Icons.person,
          textController: _lastNameController,
          inputAction: TextInputAction.next,
          autoFocus: false,
          isIcon: false,
          onChanged: (value) {
            _store.setFirstName(_lastNameController.text);
          },
          onFieldSubmitted: (value) {
            //FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          errorText: _store.formErrorStore.firstName,
        );
      },
    );
  }

  Widget _buildUserIdField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: "Email",
          inputType: TextInputType.emailAddress,
          icon: Icons.person,
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
          hint: "Password",
          isObscure: true,
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.lock,
          isIcon: false,
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

  Widget _buildSignInButton() {
    return BasicFilledButton(
        text: "Sign In",
        callback: signUp,
        fillColor: AppColors.main[50] ?? Colors.blue,
        textColor: Colors.white);
  }

  signUp() {
    print("clicked");
    if (_store.canRegister) {
      DeviceUtils.hideKeyboard(context);
      _store.login();
    } else {
      _showErrorMessage('Please fill in all fields');
    }
  }

  Widget _buildLogInInsteadButton() {
    return Align(
      alignment: FractionalOffset.center,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(0.0),
        ),
        child: Text(
          "Login Instead",
          style: TextStyle(
              fontSize: 14,
              fontFamily: FontFamily.quickSand,
              fontWeight: FontWeight.bold,
              color: AppColors.main[50]),
        ),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(Routes.login);
        },
      ),
    );
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
    _lastNameController.dispose();
    _firstNameController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
