import 'package:objectbox/objectbox.dart';

@Entity() // Marks this class as an entity for ObjectBox
class AudioFile {
  @Id() // Auto-incremented ID
  int id;

  // Name of the audio file
  @Index() // Creates an index for faster lookup
  String name;

  // File path or URL to access the audio file
  String path;
  String networkUrl;

  // Duration of the audio file in seconds
  int duration;

  // Size of the audio file in bytes
  int size;

  // Format or extension of the audio file (e.g., mp3, wav)
  String format;

  // Artist associated with the audio file
  @Index() // Indexing the artist for better search performance
  String artist;

  // Album associated with the audio file
  String album;

  // Genre of the audio file
  String genre;

  // Whether the audio file is marked as favorite
  bool isFavorite;

  // Cover art or thumbnail image URL
  String coverArtUrl;

  // Description or additional notes about the audio file
  String description;

  // List of search tags associated with the audio file
  List<String> searchTags;

  // Constructor
  AudioFile({
    this.id = 0, // Default value for ObjectBox auto-increment
    required this.name,
    required this.path,
    required this.networkUrl,
    required this.duration,
    required this.size,
    required this.format,
    this.artist = '',
    this.album = '',
    this.genre = '',
    this.isFavorite = false,
    this.coverArtUrl = '',
    this.description = '',
    this.searchTags = const [], // Default to an empty list
  });
}
