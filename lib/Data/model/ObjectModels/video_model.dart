class VideoModel {
  final String name;
  final String url;
  final String thumbnail;
  VideoModel({
    required this.name,
    required this.url,
    required this.thumbnail,
  });
}

List<VideoModel> videoList = [
  // sample video links for development and testing with thumbnail
  VideoModel(
      name: 'Test Video 1',
      url:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      thumbnail: 'https://picsum.photos/200'),
  VideoModel(
      name: 'Test Video 2',
      url:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      thumbnail: 'https://picsum.photos/200'),
  VideoModel(
      name: 'Test Video 3',
      url:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      thumbnail: 'https://picsum.photos/200'),
];
