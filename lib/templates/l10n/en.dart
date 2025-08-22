class EnGenerator {
  static gen() {
    return '''
      {
        "@@locale": "en",
        "loginTitle": "Login",
        "loginDescription": "Please enter your username and password to log in.",
        "loginUsername": "Username",
        "loginPassword": "Password",
        "loginButton": "Login",
        "loginForgotPassword": "Forgot password?",

        "languageScreenTitle": "Select Language",
        "languageScreenEnglish": "English",
        "languageScreenJapanese": "Japanese",
        "languageScreenVietnamese": "Vietnamese",
        "languageScreenButton": "Change Language",

        "dashboardTitle": "Dashboard",
        "dashboardWelcome": "Welcome to our app!",

        "navigatorHome": "Home",
        "navigatorSettings": "Settings",
        "navigatorCalendar": "Calendar",
        "navigatorChart": "Chart",
        "navigatorTime": "Time",

        "settingsTitle": "Settings",
        "settingsInformationPersonal": "Personal information",
        "settingsBirthday": "Birthday",
        "settingsEmail": "Email",
        "settingsPhone": "Phone",
        "settingsGeneralInformation": "General information",
        "settingsBiometricAuthentication": "Biometric authentication",
        "settingsChangePassword": "Change password",
        "settingsLanguage": "Language",
        "settingsLogout": "Logout"
      }

    ''';
  }
}
