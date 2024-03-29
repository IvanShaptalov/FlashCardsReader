final Map<String, String> supportedLangs = {
  'auto': 'Automatic',
  'af': 'Afrikaans',
  'sq': 'Albanian',
  'am': 'Amharic',
  'ar': 'Arabic',
  'hy': 'Armenian',
  'az': 'Azerbaijani',
  'eu': 'Basque',
  'be': 'Belarusian',
  'bn': 'Bengali',
  'bs': 'Bosnian',
  'bg': 'Bulgarian',
  'ca': 'Catalan',
  'ceb': 'Cebuano',
  'ny': 'Chichewa',
  'zh-cn': 'Chinese Simplified',
  'zh-tw': 'Chinese Traditional',
  'co': 'Corsican',
  'hr': 'Croatian',
  'cs': 'Czech',
  'da': 'Danish',
  'nl': 'Dutch',
  'en': 'English',
  'eo': 'Esperanto',
  'et': 'Estonian',
  'tl': 'Filipino',
  'fi': 'Finnish',
  'fr': 'French',
  'fy': 'Frisian',
  'gl': 'Galician',
  'ka': 'Georgian',
  'de': 'German',
  'el': 'Greek',
  'gu': 'Gujarati',
  'ht': 'Haitian Creole',
  'ha': 'Hausa',
  'haw': 'Hawaiian',
  'iw': 'Hebrew',
  'hi': 'Hindi',
  'hmn': 'Hmong',
  'hu': 'Hungarian',
  'is': 'Icelandic',
  'ig': 'Igbo',
  'id': 'Indonesian',
  'ga': 'Irish',
  'it': 'Italian',
  'ja': 'Japanese',
  'jw': 'Javanese',
  'kn': 'Kannada',
  'kk': 'Kazakh',
  'km': 'Khmer',
  'ko': 'Korean',
  'ku': 'Kurdish (Kurmanji)',
  'ky': 'Kyrgyz',
  'lo': 'Lao',
  'la': 'Latin',
  'lv': 'Latvian',
  'lt': 'Lithuanian',
  'lb': 'Luxembourgish',
  'mk': 'Macedonian',
  'mg': 'Malagasy',
  'ms': 'Malay',
  'ml': 'Malayalam',
  'mt': 'Maltese',
  'mi': 'Maori',
  'mr': 'Marathi',
  'mn': 'Mongolian',
  'my': 'Myanmar (Burmese)',
  'ne': 'Nepali',
  'no': 'Norwegian',
  'ps': 'Pashto',
  'fa': 'Persian',
  'pl': 'Polish',
  'pt': 'Portuguese',
  'pa': 'Punjabi',
  'ro': 'Romanian',
  'ru': 'Russian',
  'sm': 'Samoan',
  'gd': 'Scots Gaelic',
  'sr': 'Serbian',
  'st': 'Sesotho',
  'sn': 'Shona',
  'sd': 'Sindhi',
  'si': 'Sinhala',
  'sk': 'Slovak',
  'sl': 'Slovenian',
  'so': 'Somali',
  'es': 'Spanish',
  'su': 'Sundanese',
  'sw': 'Swahili',
  'sv': 'Swedish',
  'tg': 'Tajik',
  'ta': 'Tamil',
  'te': 'Telugu',
  'th': 'Thai',
  'tr': 'Turkish',
  'uk': 'Ukrainian',
  'ur': 'Urdu',
  'uz': 'Uzbek',
  'ug': 'Uyghur',
  'vi': 'Vietnamese',
  'cy': 'Welsh',
  'xh': 'Xhosa',
  'yi': 'Yiddish',
  'yo': 'Yoruba',
  'zu': 'Zulu'
};

final Map<String, String> supportedTtsLangs = {
  "ko-KR": "Korean",
  "mr-IN": "Marathi",
  "ru-RU": "Russian",
  "zh-TW": "Chinese Traditional",
  "hu-HU": "Hungarian",
  "th-TH": "Thai",
  "ur-PK": "Urdu",
  "nb-NO": "Norwegian",
  "da-DK": "Danish",
  "tr-TR": "Turkish",
  "et-EE": "Estonian",
  "bs": "Bosnian",
  "sw": "Swahili",
  "pt-PT": "Portuguese",
  "vi-VN": "Vietnamese",
  "en-US": "English",
  "sv-SE": "Swedish",
  "ar": "Arabic",
  "su-ID": "Sundanese",
  "bn-BD": "Bengali",
  "gu-IN": "Gujarati",
  "kn-IN": "Kannada",
  "el-GR": "Greek",
  "hi-IN": "Hindi",
  "fi-FI": "Finnish",
  "km-KH": "Khmer",
  "bn-IN": "Bengali",
  "fr-FR": "French",
  "uk-UA": "Ukrainian",
  "pa-IN": "Punjabi",
  "lv-LV": "Latvian",
  "nl-NL": "Dutch",
  "fr-CA": "French",
  "sr": "Serbian",
  "pt-BR": "Portuguese",
  "ml-IN": "Malayalam",
  "si-LK": "Sinhala",
  "de-DE": "German",
  "ku": "Kurdish",
  "cs-CZ": "Czech",
  "pl-PL": "Polish",
  "sk-SK": "Slovak",
  "fil-PH": "Filipino",
  "it-IT": "Italian",
  "ne-NP": "Nepali",
  "ms-MY": "Malay",
  "hr": "Croatian",
  "en-NG": "English",
  "nl-BE": "Dutch",
  "zh-CN": "Chinese Simplified",
  "es-ES": "Spanish",
  "cy": "Welsh",
  "ta-IN": "Tamil",
  "ja-JP": "Japanese",
  "bg-BG": "Bulgarian",
  "sq": "Albanian",
  "yue-HK": "Cantonese",
  "es-US": "Spanish",
  "jv-ID": "Javanese",
  "la": "Latin",
  "id-ID": "Indonesian",
  "te-IN": "Telugu",
  "ro-RO": "Romanian",
  "ca": "Catalan",
};

String getLangCode(String value) {
  var code = supportedLangs.keys
      .firstWhere((k) => supportedLangs[k] == value, orElse: () => 'en');
  return code;
}

String getTtsCode(String language) {
  var code = supportedTtsLangs.keys.firstWhere(
      (k) => supportedTtsLangs[k] == language,
      orElse: () => 'en-US');
  return code;
}

String convertLangToTextToSpeechCode(String lang) {
  // en-US is the default language
  String code = getTtsCode(lang);

  return code;
}

const String langUnsupported = 'Language not supported : ';
const String checkInternetConnection = '';
const String googlePlayLink = '';

const int ttsMaxLength = 400;

const double pitch = 1.0;
const double rate = 0.4;
const double volume = 1.0;

const String quizAction = 'quiz';
const String addWordAction = 'add word';
const String books = 'books';

const String textExt = '.txt';
const String jsonExt = '.js';

RegExp textBookRegex = RegExp(
  r"(?<!\n)\n(?!\n)",
  caseSensitive: false,
);

const List<String> allowedExtensions = [textExt, jsonExt];

List<String> allowedBookExtensions = [
  '.txt',
  '.epub',
  '.pdf',
];

const String androidBasePath = '/storage/emulated/0/';

const String fontRoboto = 'Roboto';
const String fontGideonRoman = 'Gideon_Roman';
const String fontNotoSerif = 'Noto_Serif';
const String fontRedressed = 'Redressed';
const String devLink =
    'https://play.google.com/store/apps/dev?id=8126792309483961458';

const List<String> fonts = [
  'Roboto',
  'Gideon_Roman',
  'Noto_Serif',
  'Redressed'
];
