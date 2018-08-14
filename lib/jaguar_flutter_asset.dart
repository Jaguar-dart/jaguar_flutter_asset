import 'dart:async';
import 'package:flutter/services.dart';
import 'package:jaguar/jaguar.dart';

/// Jaguar RequestHandler to serve from flutter assets.
///
/// Example:
///
///       final server = Jaguar();
///       server.add(FlutterAssetServer());
///       await server.serve();
class FlutterAssetServer implements RequestHandler {
  /// Prefix used to lookup in flutter assets
  final String prefix;

  /// Should the prefixes be stripped while looking up an asset?
  final bool stripPrefix;

  /// The route template
  final Get routeTemplate;

  FlutterAssetServer(
      {String match: '*',
      this.prefix = '',
      this.stripPrefix: true,
      Map<String, String> headers,
      Map<String, String> pathRegEx})
      : routeTemplate =
            new Get(path: match, headers: headers, pathRegEx: pathRegEx);

  @override
  Future<void> handleRequest(Context ctx) async {
    Route("", handler);
    if (!routeTemplate.match(ctx.path, ctx.method, prefix, ctx.pathParams)) return null;

    final List<String> parts = splitPathToSegments(routeTemplate.path);
    int len = parts.length;
    if (parts.last == '*') len--;
    final List<String> paths =
        stripPrefix ? ctx.uri.pathSegments.sublist(len) : ctx.uri.pathSegments;

    final lookupPath =
        paths.join('/') + (ctx.path.endsWith('/') ? 'index.html' : '');
    final body = (await rootBundle.load('assets/$prefix$lookupPath'))
        .buffer
        .asUint8List();

    String mimeType;
    if (ctx.path.endsWith('/')) {
      mimeType = 'text/html';
    } else {
      if (ctx.pathSegments.length > 0) {
        final String last = ctx.pathSegments.last;
        if (last.contains('.')) {
          mimeType = MimeTypes.fromFileExtension[last.split('.').last];
        }
      }
    }
    if (mimeType == null) mimeType = 'text/plain';

    ctx.response = Response<List<int>>(body, mimeType: mimeType);
  }
}
