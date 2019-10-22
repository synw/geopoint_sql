/// An exception for a database query
class DatabaseQueryError implements Exception {
  DatabaseQueryError(this.message);

  /// The error message
  final String message;
}
