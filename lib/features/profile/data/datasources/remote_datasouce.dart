
import 'package:graphql_flutter/graphql_flutter.dart';

class RemoteDataSource {
  final GraphQLClient client;

  RemoteDataSource()
      : client = GraphQLClient(
          link: HttpLink("https://graphqlzero.almansi.me/api"),
          cache: GraphQLCache(),
        );

  Future<Map<String, dynamic>> fetchUser(int id) async {
    final String query = '''
    query {
      user(id: $id) {
        id
        name
        email
        phone
      }
    }
    ''';

    final result = await client.query(
      QueryOptions(document: gql(query)),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data!['user'];
  }
}
