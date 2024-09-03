import 'package:objectbox/objectbox.dart';

@Entity()
class VideoFile {
  @Id()
  int id;

  @Index()
  String title;

  String path;

  int duration; // Duration of the video in seconds

  int size; // Size of the video file in bytes

  String format; // File format, e.g., mp4, avi
  // Genre of the video

  bool isFavorite; // Mark as favorite

  String networkUrl; // URL to download the video

  List<String> searchTags; // Tags for searching

  // Constructor
  VideoFile({
    this.id = 0,
    required this.title,
    required this.path,
    required this.duration,
    required this.size,
    this.format = "",
    this.isFavorite = false,
    this.searchTags = const [],
    required this.networkUrl,
  });
}
