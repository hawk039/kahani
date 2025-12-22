import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kahani_app/data/models/story.dart';
import 'package:kahani_app/data/repositories/home_repository.dart';
import 'package:kahani_app/presentation /home/home_view_model.dart';
import 'package:hive/hive.dart';

// Import the generated mocks
import 'home_provider_test.mocks.dart';

@GenerateMocks([HomeRepository, Box])
void main() {
  // Declare variables for our provider and its mock dependencies
  late HomeProvider homeProvider;
  late MockHomeRepository mockHomeRepository;
  late MockBox<Story> mockStoriesBox;

  // This setup runs before each test
  setUp(() {
    mockHomeRepository = MockHomeRepository();
    mockStoriesBox = MockBox<Story>();

    // Default behavior for the mock box
    when(mockStoriesBox.values).thenReturn([]);

    // Initialize the provider with our mock dependencies
    homeProvider = HomeProvider(
      repo: mockHomeRepository,
      storiesBox: mockStoriesBox,
    );
  });

  tearDown(() {
    // It's good practice to close the box after each test
    homeProvider.dispose();
  });

  test('Initial state is correct after loading from empty box', () {
    // Assert
    expect(homeProvider.selectedGenre, isNull);
    expect(homeProvider.stories, isEmpty);
    expect(homeProvider.isGeneratingStory, isFalse);
  });

  test('setSelectedGenre updates the genre and notifies listeners', () {
    // Arrange
    const testGenre = "Fantasy";
    bool listenerWasCalled = false;
    homeProvider.addListener(() {
      listenerWasCalled = true;
    });

    // Act
    homeProvider.setSelectedGenre(testGenre);

    // Assert
    expect(homeProvider.selectedGenre, testGenre);
    expect(listenerWasCalled, isTrue);
  });

  // TODO: Add more tests for generateStory, loadStories with data, etc.
}
