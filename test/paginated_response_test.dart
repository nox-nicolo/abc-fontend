import 'package:africa_beuty/core/http/paginated_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reads list responses', () {
    final body = [
      {'id': '1'},
    ];

    expect(listFromPaginatedBody(body), body);
  });

  test('reads paginated items responses', () {
    final body = {
      'items': [
        {'id': '1'},
      ],
      'pagination': {'total': 1},
    };

    expect(listFromPaginatedBody(body), body['items']);
  });

  test('reads nested data responses', () {
    final body = {
      'data': {
        'items': [
          {'id': '1'},
        ],
      },
    };

    expect(listFromPaginatedBody(body), (body['data'] as Map)['items']);
  });
}
