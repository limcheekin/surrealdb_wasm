@JS()
library index.d.ts;

// ignore_for_file: non_constant_identifier_names, private_optional_parameter, unused_element
import 'package:js/js.dart';
import "lib.dom.d.dart";
import "lib.es5.d.dart";

@JS(r'setup')
external void setup();

@JS()
class IntoUnderlyingByteSource {
  external void free();
  external void start(dynamic controller);
  external Promise<dynamic> pull(dynamic controller);
  external void cancel();
  external num autoAllocateChunkSize;
  external String type;
}

@JS()
class IntoUnderlyingSink {
  external void free();
  external Promise<dynamic> write(dynamic chunk);
  external Promise<dynamic> close();
  external Promise<dynamic> abort(dynamic reason);
}

@JS()
class IntoUnderlyingSource {
  external void free();
  external Promise<dynamic> pull(dynamic controller);
  external void cancel();
}

@JS()
class PipeOptions {
  external void free();
  external bool preventAbort;
  external bool preventCancel;
  external bool preventClose;
  external AbortSignal? signal;
}

@JS()
class QueuingStrategy {
  external void free();
  external num highWaterMark;
}

@JS()
class ReadableStreamGetReaderOptions {
  external void free();
  external dynamic mode;
}

@JS()
class Surreal {
  external void free();
  external factory Surreal();
  external Promise<void> connect(String endpoint, dynamic opts);
  external Promise<void> use(dynamic value);
  external Promise<void> set(String key, dynamic value);
  external Promise<void> unset(String key);
  external Promise<dynamic> signup(dynamic credentials);
  external Promise<dynamic> signin(dynamic credentials);
  external Promise<void> invalidate();
  external Promise<void> authenticate(String token);
  external Promise<dynamic> query(String sql, dynamic bindings);
  external Promise<dynamic> select(String resource);
  external Promise<dynamic> create(String resource, dynamic data);
  external Promise<dynamic> update(String resource, dynamic data);
  external Promise<dynamic> merge(String resource, dynamic data);
  external Promise<dynamic> patch(String resource, dynamic data);
  external Promise<dynamic> delete(String resource);
  external Promise<dynamic> version();
  external Promise<void> health();
}

/// RequestInfo | Url | Response | BufferSource | Module
typedef InitInput = dynamic;

@JS()
@anonymous
class InitOutput {
  external Memory get memory;
  external void Function() get setup;
  external num Function() get surreal_init;
  external num Function(num a, num b, num c, num d) get surreal_connect;
  external num Function(num a, num b) get surreal_use;
  external num Function(num a, num b, num c, num d) get surreal_set;
  external num Function(num a, num b, num c) get surreal_unset;
  external num Function(num a, num b) get surreal_signup;
  external num Function(num a, num b) get surreal_signin;
  external num Function(num a) get surreal_invalidate;
  external num Function(num a, num b, num c) get surreal_authenticate;
  external num Function(num a, num b, num c, num d) get surreal_query;
  external num Function(num a, num b, num c) get surreal_select;
  external num Function(num a, num b, num c, num d) get surreal_create;
  external num Function(num a, num b, num c, num d) get surreal_update;
  external num Function(num a, num b, num c, num d) get surreal_merge;
  external num Function(num a, num b, num c, num d) get surreal_patch;
  external num Function(num a, num b, num c) get surreal_delete;
  external num Function(num a) get surreal_version;
  external num Function(num a) get surreal_health;
  external num Function(num a) get queuingstrategy_highWaterMark;
  external void Function(num a, num b) get intounderlyingbytesource_type;
  external num Function(num a)
      get intounderlyingbytesource_autoAllocateChunkSize;
  external void Function(num a, num b) get intounderlyingbytesource_start;
  external num Function(num a, num b) get intounderlyingbytesource_pull;
  external num Function(num a, num b) get intounderlyingsource_pull;
  external void Function(num a) get intounderlyingsource_cancel;
  external num Function(num a) get readablestreamgetreaderoptions_mode;
  external num Function(num a) get pipeoptions_preventClose;
  external num Function(num a) get pipeoptions_preventCancel;
  external num Function(num a) get pipeoptions_preventAbort;
  external num Function(num a) get pipeoptions_signal;
  external num Function(num a, num b) get intounderlyingsink_write;
  external num Function(num a) get intounderlyingsink_close;
  external num Function(num a, num b) get intounderlyingsink_abort;
  external void Function(num a) get intounderlyingbytesource_cancel;
  external factory InitOutput({
    Memory memory,
    void Function() setup,
    num Function() surreal_init,
    num Function(num a, num b, num c, num d) surreal_connect,
    num Function(num a, num b) surreal_use,
    num Function(num a, num b, num c, num d) surreal_set,
    num Function(num a, num b, num c) surreal_unset,
    num Function(num a, num b) surreal_signup,
    num Function(num a, num b) surreal_signin,
    num Function(num a) surreal_invalidate,
    num Function(num a, num b, num c) surreal_authenticate,
    num Function(num a, num b, num c, num d) surreal_query,
    num Function(num a, num b, num c) surreal_select,
    num Function(num a, num b, num c, num d) surreal_create,
    num Function(num a, num b, num c, num d) surreal_update,
    num Function(num a, num b, num c, num d) surreal_merge,
    num Function(num a, num b, num c, num d) surreal_patch,
    num Function(num a, num b, num c) surreal_delete,
    num Function(num a) surreal_version,
    num Function(num a) surreal_health,
    num Function(num a) queuingstrategy_highWaterMark,
    void Function(num a, num b) intounderlyingbytesource_type,
    num Function(num a) intounderlyingbytesource_autoAllocateChunkSize,
    void Function(num a, num b) intounderlyingbytesource_start,
    num Function(num a, num b) intounderlyingbytesource_pull,
    num Function(num a, num b) intounderlyingsource_pull,
    void Function(num a) intounderlyingsource_cancel,
    num Function(num a) readablestreamgetreaderoptions_mode,
    num Function(num a) pipeoptions_preventClose,
    num Function(num a) pipeoptions_preventCancel,
    num Function(num a) pipeoptions_preventAbort,
    num Function(num a) pipeoptions_signal,
    num Function(num a, num b) intounderlyingsink_write,
    num Function(num a) intounderlyingsink_close,
    num Function(num a, num b) intounderlyingsink_abort,
    void Function(num a) intounderlyingbytesource_cancel,
  });
}

/// BufferSource | Module
typedef SyncInitInput = dynamic;
@JS(r'initSync')
external InitOutput initSync(SyncInitInput module);
typedef AbortSignal = dynamic;
typedef BufferSource = dynamic;
typedef Module = dynamic;
typedef RequestInfo = dynamic;
