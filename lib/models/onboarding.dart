class OnboardingModel {
  final String lottieFile;
  final String title;
  final String subtitle;

  OnboardingModel(this.lottieFile, this.title, this.subtitle);
}

List<OnboardingModel> tabs = [
  OnboardingModel(
    'assets/images/ballai.json',
    'Your AI Assitant',
    'Your personal AI assistant , \nit\'ll Give response to your \nqueries.',
  ),
  OnboardingModel(
    'assets/images/ai.json',
    'Generate Anything',
    'Formal letter, Poem Writing, Passage Writing \nAnything you want. Enter your \nquery and enjoy',
  ),
  OnboardingModel(
    'assets/images/image.json',
    'AI Image Generation',
    'Write Query And Generate Image ,\n simple and easy - download and share \nimage',
  ),
];
