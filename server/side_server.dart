import 'dart:convert';
import 'dart:io';
import 'connections.dart';

// 1. 登入連資料庫驗證
// 2. 不同使用者不同tabview數量
// 3. 從strategyDatabase抓stocklist => 再用stocklist抓股價畫圖
// 4. 因為手機模擬開不了+web不能直接連postgre 所以用server side串資料 client side寫api

void main() async {
  // Connection to several databases

  await connectionUser.open();
  print('Database connectionUser opened...');
  
  await connectionStrategy.open();
  print('Database connectionStrategy opened...');

  await connectionDailyPrice.open();
  print('Database connectionDailyPrice opened...');

  await connectionFundamentals.open();
  print('Database connectionFundamentals opened...');

  HttpServer? server;

  try {
    server = await HttpServer.bind('localhost', 8080);
    print('Server running on localhost:8080');

    await for (var request in server) {
      handleCors(request);

      try {
        if (request.method == 'GET' && request.uri.path == '/login') {
          var email = request.uri.queryParameters['email'];
          var password = request.uri.queryParameters['password'];

          if (email != null && password != null) {
            var query = 'SELECT * FROM user_information WHERE user_email = @email AND user_password = @password limit 2;';
            var results = await connectionUser.mappedResultsQuery(query, substitutionValues: {
              'email': email,
              'password': password,
            });

            if (results.isNotEmpty) {
              request.response
                ..statusCode = HttpStatus.ok
                ..write('Login successful');
                print("Login successfully for email $email and password $password");
            } else {
              request.response
                ..statusCode = HttpStatus.unauthorized
                ..write('Invalid credentials');
            }
          } else {
            request.response
              ..statusCode = HttpStatus.badRequest
              ..write('Email and password parameters are required');
          }
        } else if (request.method == 'POST' && request.uri.path == '/register') {
          var content = await utf8.decoder.bind(request).join();
          var data = Uri.splitQueryString(content);

          var username = data['username'] ?? '';
          var email = data['user_email'] ?? '';
          var password = data['user_password'] ?? '';
          var phoneNumber = data['user_phone_number'] ?? '';

          if (username.isEmpty || email.isEmpty || password.isEmpty || phoneNumber.isEmpty) {
            request.response
              ..statusCode = HttpStatus.badRequest
              ..write('All fields are required');
          } else {
            var query = 'INSERT INTO user_information (username, user_email, user_password, user_phone_number) '
                        'VALUES (@username, @email, @password, @phoneNumber);';
            await connectionUser.query(query, substitutionValues: {
              'username': username,
              'email': email,
              'password': password,
              'phoneNumber': phoneNumber,
            });
          }
        } else if (request.method == 'GET' && request.uri.path == '/trend') {
          // var today = '2024-01-01';
          var query = '''SELECT * FROM trend WHERE da='2024-01-01' AND strategy = 'trend' ORDER BY rank ASC limit 10;''';
          var result = await connectionStrategy.query(query);
          List<Map<String, dynamic>> trendData = [];
          for (var row in result) {
            trendData.add({
              'da': row[0].toString().substring(0, 10),
              'codename': row[1],
              'strategy': row[2],
              'rank': row[3],
            });
          }
          request.response
            ..statusCode = HttpStatus.ok
            ..write(jsonEncode(trendData));
        } else if (request.method == 'GET' && request.uri.path == '/price') {
          var start = request.uri.queryParameters['start'];
          var stockList = request.uri.queryParameters['symbols'] as String;
          List<String> symbols = stockList.split(',');

          List<String> quotedSymbols = symbols.map((symbol) => "'$symbol'").toList();
          String sqlInClause = quotedSymbols.join(', ');
          print(sqlInClause);
          var query = '''
            SELECT * FROM daily_price 
            WHERE da >= '$start' AND
            symbol IN ($sqlInClause)
            LIMIT 10000;''';
          var result = await connectionDailyPrice.query(query);
          List<Map<String, dynamic>> trendStockPrice = [];
          for (var row in result) {
            trendStockPrice.add({
              'da': row[0].toString().substring(0, 10),
              'codename': row[1],
              'symbol': row[2],
              'industry': row[3],
              'op':row[4],
              'hi':row[5],
              'lo':row[6],
              'cl':row[7],
            });
          }
          request.response
            ..statusCode = HttpStatus.ok
            ..write(jsonEncode(trendStockPrice));
        } else if (request.method == 'GET' && request.uri.path == "/fundamentals") {
          var stockList = request.uri.queryParameters['symbols'] as String;
          List<String> symbols = stockList.split(',');

          List<String> quotedSymbols = symbols.map((symbol) => "'$symbol'").toList();
          String sqlInClause = quotedSymbols.join(', ');
          print(sqlInClause);
          var query = '''
            SELECT * FROM tw WHERE
            symbol IN ($sqlInClause);
            ''';
          var result = await connectionStrategy.query(query);
          List<Map<String, dynamic>> trendStockFundamentals = [];
          for (var row in result) {
            trendStockFundamentals.add({
              'symbol': row[0],
              'codename': row[1],
              'industry': row[2],
            });
          }
          request.response
            ..statusCode = HttpStatus.ok
            ..write(jsonEncode(trendStockFundamentals));
        } else {
          request.response
            ..statusCode = HttpStatus.notFound
            ..write('Not Found');
        }
      } catch (e) {
        request.response
          ..statusCode = HttpStatus.internalServerError
          ..write('Exception during request: $e');
      } finally {
        await request.response.close();
      }
    }
  } catch (e) {
    print('Error starting server: $e');
  } finally {
    // Ensure connectionUser is closed when server stops
    await server?.close(force: true);
    await connectionUser.close();
    print('Server stopped, database connectionUser closed');
  }
}
