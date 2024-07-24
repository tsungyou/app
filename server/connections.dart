import 'dart:io';
import 'package:postgres/postgres.dart';

final connectionUser = PostgreSQLConnection(
    'localhost',
    5432,
    'user_validation',
    username: 'mini',
    password: 'buddyrich134',
);

final connectionStrategy = PostgreSQLConnection(
    'localhost',
    5432,
    'strategy',
    username: 'mini',
    password: 'buddyrich134',
);

final connectionDailyPrice = PostgreSQLConnection(
    'localhost',
    5432,
    'daily',
    username: 'mini',
    password: 'buddyrich134',
);

final connectionFundamentals = PostgreSQLConnection(
    'localhost',
    5432,
    'fundamentals',
    username: 'mini',
    password: 'buddyrich134',
);

void handleCors(HttpRequest request) {
  request.response.headers.add('Access-Control-Allow-Origin', '*');
  request.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  request.response.headers.add('Access-Control-Allow-Headers', 'Origin, Content-Type, X-Auth-Token');
}