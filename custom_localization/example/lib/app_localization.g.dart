// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_localization.dart';

// **************************************************************************
// CustomLocalizationGenerator
// **************************************************************************

class R {
  static English get string => _getDefaultLocal();

  static String _appLocale;

  static Map<String, English> _supportedLocales = {
    "English": English(),
    "Portugese": Portugese(),
    "Arabic": Arabic(),
  };

  static English _getDefaultLocal() {
    //return default strings if locale is not set

    if (_appLocale == null) return English();

    //throw exception to notify given local is not found or not generated by the generator

    if (!_supportedLocales.containsKey(_appLocale))
      throw Exception(
          "$_appLocale is not found.\n Make sure you have added this locale in JSON file\n Try running flutter pub run build_runner");

    //return locale from map

    return _supportedLocales[_appLocale];
  }

  static void changeLocale(String newLocale) {
    _appLocale = newLocale;
  }
}

class English {
  App app = App();
  Signup signup = Signup();
  AddCard addCard = AddCard();
  static String get languageCode => "English";
  static String get languageName => "English";
}

class App {
  String lblAppName = "Kick Scooter";
}

class Signup {
  String lblFirstName = "First Name";
  String lblLastName = "Last Name";
  String lblSelectDateOfBirth = "Select Date of Birth";
  String lblGender = "Gender";
  String lblEnterPhoneNo = "Enter Phone No";
  String lblEnterPassword = "Enter Password";
  String lblAlreadyHaveAnAccount = "Have an Account ?";
  String lblPhoneNo = "Phone No.";
  String lblMale = "Male";
  String lblFemale = "Female";
  String lblRidersAgreement = "Rider's Agreement";
  String msgAgeInfo =
      "You should be at least 16 to ride the scooter. Accounts of users younger than 16 may get restricted.";
}

class AddCard {
  String lblCreditCard = "Credit Card";
  String lblCardNumber = "Card Number";
  String lblCardHolderName = "Card Holder Name";
  String lblExpiryDate = "Expiry Date";
  String lblCvvCode = "CVV Code";
}

class Portugese extends English {
  @override
  get app => PortugeseApp();
  @override
  get signup => PortugeseSignup();
  @override
  get addCard => PortugeseAddCard();
  static String get languageCode => "Portugese";
  static String get languageName => "Portugese";
}

class PortugeseApp extends App {
  @override
  get lblAppName => "Scooter chute";
}

class PortugeseSignup extends Signup {
  @override
  get lblFirstName => "Nome";
  @override
  get lblLastName => "Sobrenome";
  @override
  get lblSelectDateOfBirth => "Selecione Data de Nascimento";
  @override
  get lblGender => "Gênero";
  @override
  get lblEnterPhoneNo => "Telefone";
  @override
  get lblEnterPassword => "Digite a senha";
  @override
  get lblAlreadyHaveAnAccount => "Ter uma conta ?";
  @override
  get lblPhoneNo => "Telefone não.";
  @override
  get lblMale => "Masculino";
  @override
  get lblFemale => "Fêmea";
  @override
  get lblRidersAgreement => "Acordo de Rider";
  @override
  get msgAgeInfo =>
      "Você deve ter pelo menos 16 para montar o scooter. Contas de usuários com menos de 16 podem ficar restrito.";
}

class PortugeseAddCard extends AddCard {
  @override
  get lblCreditCard => "Cartão de crédito";
  @override
  get lblCardNumber => "Número do cartão";
  @override
  get lblCardHolderName => "Nome do Titular";
  @override
  get lblExpiryDate => "Data de validade";
  @override
  get lblCvvCode => "Código de Valor de Verificação de Cartão";
}

class Arabic extends English {
  @override
  get app => ArabicApp();
  @override
  get signup => ArabicSignup();
  @override
  get addCard => ArabicAddCard();
  static String get languageCode => "Arabic";
  static String get languageName => "Arabic";
}

class ArabicApp extends App {
  @override
  get lblAppName => "ركلة سكوتر";
}

class ArabicSignup extends Signup {
  @override
  get lblFirstName => "الاسم الاول";
  @override
  get lblLastName => "الكنية";
  @override
  get lblSelectDateOfBirth => "حدد تاريخ الميلاد";
  @override
  get lblGender => "جنس";
  @override
  get lblEnterPhoneNo => "أدخل رقم الهاتف";
  @override
  get lblEnterPassword => "أدخل كلمة المرور";
  @override
  get lblAlreadyHaveAnAccount => "هل لديك حساب؟";
  @override
  get lblPhoneNo => "رقم الهاتف.";
  @override
  get lblMale => "الذكر";
  @override
  get lblFemale => "أنثى";
  @override
  get lblRidersAgreement => "اتفاق المتسابق";
  @override
  get msgAgeInfo =>
      "يجب أن تكون على الأقل 16 لركوب دراجة نارية. حسابات المستخدمين الذين تقل أعمارهم عن 16 قد تحصل المحظورة.";
}

class ArabicAddCard extends AddCard {
  @override
  get lblCreditCard => "بطاقة ائتمان";
  @override
  get lblCardNumber => "رقم البطاقة";
  @override
  get lblCardHolderName => "إسم صاحب البطاقة";
  @override
  get lblExpiryDate => "تاريخ الانتهاء";
  @override
  get lblCvvCode => "رقم الكود الموجود على بطاقات الاتمان";
}