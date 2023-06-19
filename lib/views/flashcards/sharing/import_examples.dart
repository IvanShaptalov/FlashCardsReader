const importExample = """
Supported import formats: text, json

Text format:

FlashCard Collection;English;Ukrainian
question-відповідь
question word-answer word

Json format:
{
  "id": "02794c6b-e16e-49bc-ae19-0f4269ab8f99",
  "title": "FlashCard Collection",
  "flashCardSet": [
    "{\"questionLanguage\":\"English\",
    \"answerLanguage\":\"Ukrainian\",
    \"question\":\"question\",
    \"answer\":\"відповідь\",
    \"lastTested\":\"2023-06-19T11:22:00.438078\",
    \"correctAnswers\":0,
    \"wrongAnswers\":0}"
  ],
  "createdAt": "2023-06-19T11:22:00.437677",
  "isDeleted": false,
  "questionLanguage": "English",
  "answerLanguage": "Ukrainian"
}
""";

const importExampleExtended = """""";
