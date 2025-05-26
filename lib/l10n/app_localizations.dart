import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_my.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('my'),
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @preferLanguage.
  ///
  /// In en, this message translates to:
  /// **'Please select your prefer language to continue.'**
  String get preferLanguage;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @movies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get movies;

  /// No description provided for @series.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get series;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @promotion.
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get promotion;

  /// No description provided for @watchlist.
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get watchlist;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @term.
  ///
  /// In en, this message translates to:
  /// **'Terms & Condition'**
  String get term;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccount2.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccount2;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @checkProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get checkProfile;

  /// No description provided for @deleteAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account permanently?'**
  String get deleteAccountQuestion;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @continueForPayment.
  ///
  /// In en, this message translates to:
  /// **'Continue for Payment'**
  String get continueForPayment;

  /// No description provided for @specialPromotion.
  ///
  /// In en, this message translates to:
  /// **'Special Promotion'**
  String get specialPromotion;

  /// No description provided for @unlockPromotion.
  ///
  /// In en, this message translates to:
  /// **'Unlock exclusive benefits with our limited-time promotion package!'**
  String get unlockPromotion;

  /// No description provided for @searchSeriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Search by series title'**
  String get searchSeriesTitle;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Types'**
  String get type;

  /// No description provided for @genre.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get genre;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @searchMovieTitle.
  ///
  /// In en, this message translates to:
  /// **'Search by movie title'**
  String get searchMovieTitle;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @program.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get program;

  /// No description provided for @newRelease.
  ///
  /// In en, this message translates to:
  /// **'New Releases'**
  String get newRelease;

  /// No description provided for @freeMovieSeries.
  ///
  /// In en, this message translates to:
  /// **'Free Movie & Series'**
  String get freeMovieSeries;

  /// No description provided for @allMovieSeries.
  ///
  /// In en, this message translates to:
  /// **'All Movies & Series'**
  String get allMovieSeries;

  /// No description provided for @watchNow.
  ///
  /// In en, this message translates to:
  /// **'Watch Now'**
  String get watchNow;

  /// No description provided for @director.
  ///
  /// In en, this message translates to:
  /// **'Director :'**
  String get director;

  /// No description provided for @scriptWriter.
  ///
  /// In en, this message translates to:
  /// **'Script Writer :'**
  String get scriptWriter;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @watchTrailer.
  ///
  /// In en, this message translates to:
  /// **'Watch Trailer'**
  String get watchTrailer;

  /// No description provided for @seasons.
  ///
  /// In en, this message translates to:
  /// **'Seasons'**
  String get seasons;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number. \nWe\'ll send you a verification code'**
  String get enterPhoneNumber;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'verification'**
  String get verification;

  /// No description provided for @sendOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Send OTP Code to'**
  String get sendOtpCode;

  /// No description provided for @enterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter your OTP Code here.'**
  String get enterOTP;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @discoverLabel.
  ///
  /// In en, this message translates to:
  /// **'Discover, stream, and enjoy your favorite movies and shows anytime, anywhere.'**
  String get discoverLabel;

  /// No description provided for @searchByMovieSeries.
  ///
  /// In en, this message translates to:
  /// **'Search by movies & series'**
  String get searchByMovieSeries;

  /// No description provided for @yourHistory.
  ///
  /// In en, this message translates to:
  /// **'Your History'**
  String get yourHistory;

  /// No description provided for @yourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'သင့်ဖုန်းနံပါတ်'**
  String get yourPhoneNumber;

  /// No description provided for @willSend.
  ///
  /// In en, this message translates to:
  /// **'သို့ OTP Code ပို့ပေးပါမည်။ ကျေးဇူးပြု၍ အောက်တွင်ထည့်ပါ။'**
  String get willSend;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to logout?'**
  String get logoutQuestion;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'my'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'my':
      return AppLocalizationsMy();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
