import 'package:postgres/postgres.dart';

class DatabaseService {
  final String host;
  final int port;
  final String databaseName;
  final String username;
  final String password;

  PostgreSQLConnection? _connection;

  DatabaseService({
    required this.host,
    required this.port,
    required this.databaseName,
    required this.username,
    required this.password,
  });

  Future<void> connect() async {
    if (_connection != null && !_connection!.isClosed) return; // Already connected

    _connection = PostgreSQLConnection(
      host,
      port,
      databaseName,
      username: username,
      password: password,
    );

    try {
      await _connection!.open();
      print("Connected to $databaseName database");
    } catch (e) {
      print("Error connecting to the database: $e");
      rethrow;
    }
  }

  Future<void> insertUser(String username, String email, String password, String phoneNumber) async {
    await connect(); // Ensure the connection is open

    try {
      await _connection!.query(
        'INSERT INTO users (username, user_email, user_password, user_phone_number) VALUES (@username, @userEmail, @password, @phoneNumber)',
        substitutionValues: {
          'username': username,
          'password': password,
          'phoneNumber': phoneNumber,
          'userEmail': email,
        },
      );
      print('User inserted successfully');
    } catch (e) {
      print("Error inserting user: $e");
      rethrow;
    }
  }

  Future<void> closeConnection() async {
    if (_connection != null) {
      await _connection!.close();
      print('Connection closed');
    }
  }
}
