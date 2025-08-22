class JaGenerator {
  static gen() {
    return '''
      {
        "@@locale": "ja",
        "loginTitle": "ログイン",
        "loginDescription": "ログインするには、ユーザー名とパスワードを入力してください。",
        "loginUsername": "ユーザー名",
        "loginPassword": "パスワード",
        "loginButton": "ログイン",
        "loginForgotPassword": "パスワードをお忘れですか？",

        "languageScreenTitle": "言語を選択",
        "languageScreenEnglish": "英語",
        "languageScreenJapanese": "日本語",
        "languageScreenVietnamese": "ベトナム語",
        "languageScreenButton": "言語を変更",

        "dashboardTitle": "ダッシュボード",
        "dashboardWelcome": "当社のアプリケーションへようこそ！",

        "navigatorHome": "ホーム",
        "navigatorSettings": "設定",
        "navigatorCalendar": "カレンダー",
        "navigatorChart": "チャート",
        "navigatorTime": "時間",

        "settingsTitle": "設定",
        "settingsInformationPersonal": "個人情報",
        "settingsBirthday": "生年月日",
        "settingsEmail": "Eメール",
        "settingsPhone": "電話番号",
        "settingsGeneralInformation": "一般情報",
        "settingsBiometricAuthentication": "生体認証",
        "settingsChangePassword": "パスワードを変更",
        "settingsLanguage": "言語",
        "settingsLogout": "ログアウト"
      }


    ''';
  }
}
