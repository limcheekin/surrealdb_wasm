@JS()
library lib.es5.d.ts;

// ignore_for_file: non_constant_identifier_names, private_optional_parameter, unused_element
import 'package:js/js.dart';
import "dart:typed_data";
import "lib.es5.d.dart";

@JS(r'NaN')
external num JNaN;
@JS(r'Infinity')
external num JInfinity;
@JS(r'eval')
external dynamic eval(String x);
@JS(r'parseInt')
external num parseInt(String string, num radix);
@JS(r'parseFloat')
external num parseFloat(String string);
@JS(r'isNaN')
external bool isNaN(num number);
@JS(r'isFinite')
external bool isFinite(num number);
@JS(r'decodeURI')
external String decodeURI(String encodedURI);
@JS(r'decodeURIComponent')
external String decodeURIComponent(String encodedURIComponent);
@JS(r'encodeURI')
external String encodeURI(String uri);
@JS(r'encodeURIComponent')
external String encodeURIComponent(dynamic uriComponent);
@JS(r'escape')
external String escape(String string);
@JS(r'unescape')
external String unescape(String string);

@JS()
@anonymous
class Symbol {
  @override
  external String toString();
  external dynamic valueOf();
  external factory Symbol();
}

/// String | num | dynamic
typedef PropertyKey = dynamic;

@JS()
@anonymous
class PropertyDescriptor {
  external bool? configurable;
  external bool? enumerable;
  external dynamic value;
  external bool? writable;
  external dynamic get();
  external void set(dynamic v);
  external factory PropertyDescriptor({
    bool? configurable,
    bool? enumerable,
    dynamic value,
    bool? writable,
  });
}

@JS()
@anonymous
class PropertyDescriptorMap {
  external factory PropertyDescriptorMap();
}

@JS()
@anonymous
class Object {
  external Function constructor;
  @override
  external String toString();
  external String toLocaleString();
  external Object valueOf();
  external bool hasOwnProperty(PropertyKey v);
  external bool isPrototypeOf(Object v);
  external bool propertyIsEnumerable(PropertyKey v);
  external factory Object({
    Function constructor,
  });
}

@JS()
class ObjectConstructor {
  external factory ObjectConstructor({dynamic value});
  external dynamic call();
  external Object get prototype;
  external dynamic getPrototypeOf(dynamic o);
  external PropertyDescriptor? getOwnPropertyDescriptor(dynamic o, PropertyKey p);
  external List<String> getOwnPropertyNames(dynamic o);
  external dynamic create(dynamic o);
  external T defineProperty<T>(T o, PropertyKey p, dynamic attributes);
  external T defineProperties<T>(T o, dynamic properties);
  external T seal<T>(T o);
  external List<T> freeze<T>(List<T> a);
  external T preventExtensions<T>(T o);
  external bool isSealed(dynamic o);
  external bool isFrozen(dynamic o);
  external bool isExtensible(dynamic o);
  external List<String> keys(dynamic o);
}

@JS(r'Object')
external ObjectConstructor JObject;

@JS()
@anonymous
class Function {
  external dynamic apply(dynamic thisArg, dynamic argArray);
  external dynamic call(
    dynamic thisArg, [
    dynamic argArray1,
    dynamic argArray2,
    dynamic argArray3,
    dynamic argArray4,
    dynamic argArray5,
    dynamic argArray6,
    dynamic argArray7,
    dynamic argArray8,
    dynamic argArray9,
  ]);
  external dynamic bind(
    dynamic thisArg, [
    dynamic argArray1,
    dynamic argArray2,
    dynamic argArray3,
    dynamic argArray4,
    dynamic argArray5,
    dynamic argArray6,
    dynamic argArray7,
    dynamic argArray8,
    dynamic argArray9,
  ]);
  @override
  external String toString();
  external dynamic prototype;
  external num get length;
  external dynamic arguments;
  external Function caller;
  external factory Function({
    dynamic prototype,
    num length,
    dynamic arguments,
    Function caller,
  });
}

@JS()
class FunctionConstructor {
  external factory FunctionConstructor([
    String? args1,
    String? args2,
    String? args3,
    String? args4,
    String? args5,
    String? args6,
    String? args7,
    String? args8,
    String? args9,
  ]);
  external Function call([
    String? args1,
    String? args2,
    String? args3,
    String? args4,
    String? args5,
    String? args6,
    String? args7,
    String? args8,
    String? args9,
  ]);
  external Function get prototype;
}

@JS(r'Function')
external FunctionConstructor JFunction;

/// dynamic | null
typedef ThisParameterType<T> = dynamic;
typedef OmitThisParameter<T> = dynamic;

@JS()
@anonymous
class CallableFunction extends Function {
  external R apply<T, R>(T thisArg);
  external R call<T, A extends List<dynamic>, R>(
    T thisArg, [
    A? args1,
    A? args2,
    A? args3,
    A? args4,
    A? args5,
    A? args6,
    A? args7,
    A? args8,
    A? args9,
  ]);
  external OmitThisParameter<T> bind<T>(ThisParameterType<T> thisArg);
  external factory CallableFunction();
}

@JS()
@anonymous
class NewableFunction extends Function {
  external void apply<T>(T thisArg);
  external void call<T, A extends List<dynamic>>(
    T thisArg, [
    A? args1,
    A? args2,
    A? args3,
    A? args4,
    A? args5,
    A? args6,
    A? args7,
    A? args8,
    A? args9,
  ]);
  external T bind<T>(dynamic thisArg);
  external factory NewableFunction();
}

@JS()
@anonymous
class IArguments {
  external num length;
  external Function callee;
  external factory IArguments({
    num length,
    Function callee,
  });
}

@JS()
class StringConstructor {
  external factory StringConstructor({dynamic value});
  external String call(dynamic value);
  external String get prototype;
  external String fromCharCode([
    num? codes1,
    num? codes2,
    num? codes3,
    num? codes4,
    num? codes5,
    num? codes6,
    num? codes7,
    num? codes8,
    num? codes9,
  ]);
}

@JS(r'String')
external StringConstructor JString;

@JS()
@anonymous
class Boolean {
  external bool valueOf();
  external factory Boolean();
}

@JS()
class BooleanConstructor {
  external factory BooleanConstructor({dynamic value});
  external bool call<T>(T value);
  external bool get prototype;
}

@JS(r'Boolean')
external BooleanConstructor JBoolean;

@JS()
@anonymous
class Number {
  @override
  external String toString(num radix);
  external String toFixed(num fractionDigits);
  external String toExponential(num fractionDigits);
  external String toPrecision(num precision);
  external num valueOf();
  external factory Number();
}

@JS()
class NumberConstructor {
  external factory NumberConstructor({dynamic value});
  external num call(dynamic value);
  external num get prototype;
  external num get MAX_VALUE;
  external num get MIN_VALUE;
  external num get NaN;
  external num get NEGATIVE_INFINITY;
  external num get POSITIVE_INFINITY;
}

@JS(r'Number')
external NumberConstructor JNumber;

@JS()
@anonymous
class TemplateStringsArray extends List<String> {
  external List<String> get raw;
  external factory TemplateStringsArray({
    List<String> raw,
  });
}

@JS()
@anonymous
class ImportMeta {
  external factory ImportMeta();
}

@JS()
@anonymous
class Math {
  external num get E;
  external num get LN10;
  external num get LN2;
  external num get LOG2E;
  external num get LOG10E;
  external num get PI;
  external num get SQRT1_2;
  external num get SQRT2;
  external num abs(num x);
  external num acos(num x);
  external num asin(num x);
  external num atan(num x);
  external num atan2(num y, num x);
  external num ceil(num x);
  external num cos(num x);
  external num exp(num x);
  external num floor(num x);
  external num log(num x);
  external num max([
    num? values1,
    num? values2,
    num? values3,
    num? values4,
    num? values5,
    num? values6,
    num? values7,
    num? values8,
    num? values9,
  ]);
  external num min([
    num? values1,
    num? values2,
    num? values3,
    num? values4,
    num? values5,
    num? values6,
    num? values7,
    num? values8,
    num? values9,
  ]);
  external num pow(num x, num y);
  external num random();
  external num round(num x);
  external num sin(num x);
  external num sqrt(num x);
  external num tan(num x);
  external factory Math({
    num E,
    num LN10,
    num LN2,
    num LOG2E,
    num LOG10E,
    num PI,
    num SQRT1_2,
    num SQRT2,
  });
}

@JS(r'Math')
external Math JMath;

@JS()
@anonymous
class Date {
  @override
  external String toString();
  external String toDateString();
  external String toTimeString();
  external String toLocaleString();
  external String toLocaleDateString();
  external String toLocaleTimeString();
  external num valueOf();
  external num getTime();
  external num getFullYear();
  external num getUTCFullYear();
  external num getMonth();
  external num getUTCMonth();
  external num getDate();
  external num getUTCDate();
  external num getDay();
  external num getUTCDay();
  external num getHours();
  external num getUTCHours();
  external num getMinutes();
  external num getUTCMinutes();
  external num getSeconds();
  external num getUTCSeconds();
  external num getMilliseconds();
  external num getUTCMilliseconds();
  external num getTimezoneOffset();
  external num setTime(num time);
  external num setMilliseconds(num ms);
  external num setUTCMilliseconds(num ms);
  external num setSeconds(num sec, num ms);
  external num setUTCSeconds(num sec, num ms);
  external num setMinutes(num min, num sec, num ms);
  external num setUTCMinutes(num min, num sec, num ms);
  external num setHours(num hours, num min, num sec, num ms);
  external num setUTCHours(num hours, num min, num sec, num ms);
  external num setDate(num date);
  external num setUTCDate(num date);
  external num setMonth(num month, num date);
  external num setUTCMonth(num month, num date);
  external num setFullYear(num year, num month, num date);
  external num setUTCFullYear(num year, num month, num date);
  external String toUTCString();
  external String toISOString();
  external String toJSON(dynamic key);
  external factory Date();
}

@JS()
class DateConstructor {
  external factory DateConstructor();
  external String call();
  external DateTime get prototype;
  external num parse(String s);
  external num UTC(num year, num month, num date, num hours, num minutes, num seconds, num ms);
  external num now();
}

@JS(r'Date')
external DateConstructor JDate;

@JS()
@anonymous
class RegExpMatchArray extends List<String> {
  external num? index;
  external String? input;
  external factory RegExpMatchArray({
    num? index,
    String? input,
  });
}

@JS()
@anonymous
class RegExpExecArray extends List<String> {
  external num index;
  external String input;
  external factory RegExpExecArray({
    num index,
    String input,
  });
}

@JS()
@anonymous
class RegExp {
  external RegExpExecArray? exec(String string);
  external bool test(String string);
  external String get source;
  external bool get global;
  external bool get ignoreCase;
  external bool get multiline;
  external num lastIndex;
  external RegExp compile();
  external factory RegExp({
    String source,
    bool global,
    bool ignoreCase,
    bool multiline,
    num lastIndex,
  });
}

@JS()
class RegExpConstructor {
  external factory RegExpConstructor({dynamic pattern});
  external RegExp call(dynamic pattern);
  external RegExp get prototype;
  external String $1;
  external String $2;
  external String $3;
  external String $4;
  external String $5;
  external String $6;
  external String $7;
  external String $8;
  external String $9;
  external String lastMatch;
}

@JS(r'RegExp')
external RegExpConstructor JRegExp;

@JS()
@anonymous
class Error {
  external String name;
  external String message;
  external String? stack;
  external factory Error({
    String name,
    String message,
    String? stack,
  });
}

@JS()
class ErrorConstructor {
  external factory ErrorConstructor({String message});
  external Error call(String message);
  external Error get prototype;
}

@JS(r'Error')
external ErrorConstructor JError;

@JS()
@anonymous
class EvalError extends Error {
  external factory EvalError();
}

@JS()
class EvalErrorConstructor extends ErrorConstructor {
  external factory EvalErrorConstructor({String message});
  external EvalError call(String message);
  external EvalError get prototype;
}

@JS(r'EvalError')
external EvalErrorConstructor JEvalError;

@JS()
@anonymous
class RangeError extends Error {
  external factory RangeError();
}

@JS()
class RangeErrorConstructor extends ErrorConstructor {
  external factory RangeErrorConstructor({String message});
  external RangeError call(String message);
  external RangeError get prototype;
}

@JS(r'RangeError')
external RangeErrorConstructor JRangeError;

@JS()
@anonymous
class ReferenceError extends Error {
  external factory ReferenceError();
}

@JS()
class ReferenceErrorConstructor extends ErrorConstructor {
  external factory ReferenceErrorConstructor({String message});
  external ReferenceError call(String message);
  external ReferenceError get prototype;
}

@JS(r'ReferenceError')
external ReferenceErrorConstructor JReferenceError;

@JS()
@anonymous
class SyntaxError extends Error {
  external factory SyntaxError();
}

@JS()
class SyntaxErrorConstructor extends ErrorConstructor {
  external factory SyntaxErrorConstructor({String message});
  external SyntaxError call(String message);
  external SyntaxError get prototype;
}

@JS(r'SyntaxError')
external SyntaxErrorConstructor JSyntaxError;

@JS()
@anonymous
class TypeError extends Error {
  external factory TypeError();
}

@JS()
class TypeErrorConstructor extends ErrorConstructor {
  external factory TypeErrorConstructor({String message});
  external TypeError call(String message);
  external TypeError get prototype;
}

@JS(r'TypeError')
external TypeErrorConstructor JTypeError;

@JS()
@anonymous
class URIError extends Error {
  external factory URIError();
}

@JS()
class URIErrorConstructor extends ErrorConstructor {
  external factory URIErrorConstructor({String message});
  external URIError call(String message);
  external URIError get prototype;
}

@JS(r'URIError')
external URIErrorConstructor JURIError;

@JS()
@anonymous
class JSON {
  external dynamic parse(String text, dynamic Function(String key, dynamic value) reviver);
  external String stringify(dynamic value, dynamic Function(String key, dynamic value) replacer, dynamic space);
  external factory JSON();
}

@JS(r'JSON')
external JSON JJSON;

@JS()
@anonymous
class ReadonlyArray<T> {
  external num get length;
  @override
  external String toString();
  external String toLocaleString();
  external List<T> concat([
    ConcatArray<T>? items1,
    ConcatArray<T>? items2,
    ConcatArray<T>? items3,
    ConcatArray<T>? items4,
    ConcatArray<T>? items5,
    ConcatArray<T>? items6,
    ConcatArray<T>? items7,
    ConcatArray<T>? items8,
    ConcatArray<T>? items9,
  ]);
  external String join(String separator);
  external List<T> slice(num start, num end);
  external num indexOf(T searchElement, num fromIndex);
  external num lastIndexOf(T searchElement, num fromIndex);
  external bool every<S extends T>(bool Function(T value, num index, List<T> array) predicate, dynamic thisArg);
  external bool some(dynamic Function(T value, num index, List<T> array) predicate, dynamic thisArg);
  external void forEach(void Function(T value, num index, List<T> array) callbackfn, dynamic thisArg);
  external List<U> map<U>(U Function(T value, num index, List<T> array) callbackfn, dynamic thisArg);
  external List<S> filter<S extends T>(bool Function(T value, num index, List<T> array) predicate, dynamic thisArg);
  external T reduce(T Function(T previousValue, T currentValue, num currentIndex, List<T> array) callbackfn);
  external T reduceRight(T Function(T previousValue, T currentValue, num currentIndex, List<T> array) callbackfn);
  external factory ReadonlyArray({
    num length,
  });
}

@JS()
@anonymous
class ConcatArray<T> {
  external num get length;
  external String join(String separator);
  external List<T> slice(num start, num end);
  external factory ConcatArray({
    num length,
  });
}

@JS()
@anonymous
class Array<T> {
  external num length;
  @override
  external String toString();
  external String toLocaleString();
  external T? pop();
  external num push([
    T? items1,
    T? items2,
    T? items3,
    T? items4,
    T? items5,
    T? items6,
    T? items7,
    T? items8,
    T? items9,
  ]);
  external List<T> concat([
    ConcatArray<T>? items1,
    ConcatArray<T>? items2,
    ConcatArray<T>? items3,
    ConcatArray<T>? items4,
    ConcatArray<T>? items5,
    ConcatArray<T>? items6,
    ConcatArray<T>? items7,
    ConcatArray<T>? items8,
    ConcatArray<T>? items9,
  ]);
  external String join(String separator);
  external List<T> reverse();
  external T? shift();
  external List<T> slice(num start, num end);
  external Array sort(num Function(T a, T b) compareFn);
  external List<T> splice(num start, num deleteCount);
  external num unshift([
    T? items1,
    T? items2,
    T? items3,
    T? items4,
    T? items5,
    T? items6,
    T? items7,
    T? items8,
    T? items9,
  ]);
  external num indexOf(T searchElement, num fromIndex);
  external num lastIndexOf(T searchElement, num fromIndex);
  external bool every<S extends T>(bool Function(T value, num index, List<T> array) predicate, dynamic thisArg);
  external bool some(dynamic Function(T value, num index, List<T> array) predicate, dynamic thisArg);
  external void forEach(void Function(T value, num index, List<T> array) callbackfn, dynamic thisArg);
  external List<U> map<U>(U Function(T value, num index, List<T> array) callbackfn, dynamic thisArg);
  external List<S> filter<S extends T>(bool Function(T value, num index, List<T> array) predicate, dynamic thisArg);
  external T reduce(T Function(T previousValue, T currentValue, num currentIndex, List<T> array) callbackfn);
  external T reduceRight(T Function(T previousValue, T currentValue, num currentIndex, List<T> array) callbackfn);
  external factory Array({
    num length,
  });
}

@JS()
class ArrayConstructor {
  external factory ArrayConstructor({num arrayLength});
  external List<dynamic> call(num arrayLength);
  external bool isArray(dynamic arg);
  external List<dynamic> get prototype;
}

@JS(r'Array')
external ArrayConstructor JArray;

@JS()
@anonymous
class TypedPropertyDescriptor<T> {
  external bool? enumerable;
  external bool? configurable;
  external bool? writable;
  external T? value;
  external T Function()? get;
  external void Function(T value)? set;
  external factory TypedPropertyDescriptor({
    bool? enumerable,
    bool? configurable,
    bool? writable,
    T? value,
    T Function()? get,
    void Function(T value)? set,
  });
}

/// TFunction | void
typedef ClassDecorator = dynamic Function<TFunction extends Function>(TFunction target);

/// String | dynamic
typedef PropertyDecorator = void Function(Object target, dynamic propertyKey);

/// String | dynamic
typedef MethodDecorator = dynamic Function<T>(
    Object target, dynamic propertyKey, TypedPropertyDescriptor<T> descriptor);

/// String | dynamic
typedef ParameterDecorator = void Function(Object target, dynamic propertyKey, num parameterIndex);
typedef PromiseConstructorLike = dynamic Function();

@JS()
@anonymous
class PromiseLike<T> {
  external PromiseLike<dynamic> then<TResult1, TResult2>(
      dynamic Function(T value)? onfulfilled, dynamic Function(dynamic reason)? onrejected);
  external factory PromiseLike();
}

@JS()
@anonymous
class Promise<T> {
  external Promise<dynamic> then<TResult1, TResult2>(
      dynamic Function(T value)? onfulfilled, dynamic Function(dynamic reason)? onrejected);
  external factory Promise();
}

@JS()
@anonymous
class ArrayLike<T> {
  external num get length;
  external factory ArrayLike({
    num length,
  });
}

/// TResult2 | PromiseLike<TResult2>
typedef Partial<T> = dynamic;
typedef Required<T> = dynamic;
typedef Readonly<T> = dynamic;
typedef Pick<T, K extends String> = dynamic;
typedef Record<K extends String, T> = dynamic;
typedef Exclude<T, U> = dynamic;
typedef Extract<T, U> = dynamic;
typedef Omit<T, K extends String> = Pick<T, Exclude<String, K>>;
typedef NonNullable<T> = dynamic;
typedef Parameters<
        T extends dynamic Function([
          dynamic args1,
          dynamic args2,
          dynamic args3,
          dynamic args4,
          dynamic args5,
          dynamic args6,
          dynamic args7,
          dynamic args8,
          dynamic args9,
        ])>
    = dynamic;
typedef ConstructorParameters<T extends dynamic Function()> = dynamic;
typedef ReturnType<
        T extends dynamic Function([
          dynamic args1,
          dynamic args2,
          dynamic args3,
          dynamic args4,
          dynamic args5,
          dynamic args6,
          dynamic args7,
          dynamic args8,
          dynamic args9,
        ])>
    = dynamic;
typedef InstanceType<T extends dynamic Function()> = dynamic;
typedef Uppercase<S extends String> = dynamic;
typedef Lowercase<S extends String> = dynamic;
typedef Capitalize<S extends String> = dynamic;
typedef Uncapitalize<S extends String> = dynamic;

@JS()
@anonymous
class ThisType<T> {
  external factory ThisType();
}

@JS()
@anonymous
class ArrayBuffer {
  external num get byteLength;
  external ByteBuffer slice(num begin, num end);
  external factory ArrayBuffer({
    num byteLength,
  });
}

@JS()
@anonymous
class ArrayBufferTypes {
  external ByteBuffer ArrayBuffer;
  external factory ArrayBufferTypes({
    ByteBuffer ArrayBuffer,
  });
}

typedef ArrayBufferLike = dynamic;

@JS()
class ArrayBufferConstructor {
  external ByteBuffer get prototype;
  external factory ArrayBufferConstructor({num byteLength});
  external bool isView(dynamic arg);
}

@JS(r'ArrayBuffer')
external ArrayBufferConstructor JArrayBuffer;

@JS()
@anonymous
class ArrayBufferView {
  external ArrayBufferLike buffer;
  external num byteLength;
  external num byteOffset;
  external factory ArrayBufferView({
    ArrayBufferLike buffer,
    num byteLength,
    num byteOffset,
  });
}

@JS()
@anonymous
class DataView {
  external ByteBuffer get buffer;
  external num get byteLength;
  external num get byteOffset;
  external num getFloat32(num byteOffset, bool littleEndian);
  external num getFloat64(num byteOffset, bool littleEndian);
  external num getInt8(num byteOffset);
  external num getInt16(num byteOffset, bool littleEndian);
  external num getInt32(num byteOffset, bool littleEndian);
  external num getUint8(num byteOffset);
  external num getUint16(num byteOffset, bool littleEndian);
  external num getUint32(num byteOffset, bool littleEndian);
  external void setFloat32(num byteOffset, num value, bool littleEndian);
  external void setFloat64(num byteOffset, num value, bool littleEndian);
  external void setInt8(num byteOffset, num value);
  external void setInt16(num byteOffset, num value, bool littleEndian);
  external void setInt32(num byteOffset, num value, bool littleEndian);
  external void setUint8(num byteOffset, num value);
  external void setUint16(num byteOffset, num value, bool littleEndian);
  external void setUint32(num byteOffset, num value, bool littleEndian);
  external factory DataView({
    ByteBuffer buffer,
    num byteLength,
    num byteOffset,
  });
}

@JS()
class DataViewConstructor {
  external ByteData get prototype;
  external factory DataViewConstructor({ArrayBufferLike buffer, num byteOffset, num byteLength});
}

@JS(r'DataView')
external DataViewConstructor JDataView;

@JS()
@anonymous
class Int8Array {
  external num get BYTES_PER_ELEMENT;
  external ArrayBufferLike get buffer;
  external num get byteLength;
  external num get byteOffset;
  external Int8Array copyWithin(num target, num start, num end);
  external bool every(dynamic Function(num value, num index, Int8List array) predicate, dynamic thisArg);
  external Int8Array fill(num value, num start, num end);
  external Int8List filter(dynamic Function(num value, num index, Int8List array) predicate, dynamic thisArg);
  external num? find(bool Function(num value, num index, Int8List obj) predicate, dynamic thisArg);
  external num findIndex(bool Function(num value, num index, Int8List obj) predicate, dynamic thisArg);
  external void forEach(void Function(num value, num index, Int8List array) callbackfn, dynamic thisArg);
  external num indexOf(num searchElement, num fromIndex);
  external String join(String separator);
  external num lastIndexOf(num searchElement, num fromIndex);
  external num get length;
  external Int8List map(num Function(num value, num index, Int8List array) callbackfn, dynamic thisArg);
  external num reduce(num Function(num previousValue, num currentValue, num currentIndex, Int8List array) callbackfn);
  external num reduceRight(
      num Function(num previousValue, num currentValue, num currentIndex, Int8List array) callbackfn);
  external Int8List reverse();
  external void set(ArrayLike<num> array, num offset);
  external Int8List slice(num start, num end);
  external bool some(dynamic Function(num value, num index, Int8List array) predicate, dynamic thisArg);
  external Int8Array sort(num Function(num a, num b) compareFn);
  external Int8List subarray(num begin, num end);
  external String toLocaleString();
  @override
  external String toString();
  external Int8List valueOf();
  external factory Int8Array({
    num BYTES_PER_ELEMENT,
    ArrayBufferLike buffer,
    num byteLength,
    num byteOffset,
    num length,
  });
}

@JS()
class Int8ArrayConstructor {
  external Int8List get prototype;
  external factory Int8ArrayConstructor({num length});
  external num get BYTES_PER_ELEMENT;
  external Int8List of([
    num? items1,
    num? items2,
    num? items3,
    num? items4,
    num? items5,
    num? items6,
    num? items7,
    num? items8,
    num? items9,
  ]);
  external Int8List from(ArrayLike<num> arrayLike);
}

@JS(r'Int8Array')
external Int8ArrayConstructor JInt8Array;

@JS()
@anonymous
class Uint8Array {
  external num get BYTES_PER_ELEMENT;
  external ArrayBufferLike get buffer;
  external num get byteLength;
  external num get byteOffset;
  external Uint8Array copyWithin(num target, num start, num end);
  external bool every(dynamic Function(num value, num index, Uint8List array) predicate, dynamic thisArg);
  external Uint8Array fill(num value, num start, num end);
  external Uint8List filter(dynamic Function(num value, num index, Uint8List array) predicate, dynamic thisArg);
  external num? find(bool Function(num value, num index, Uint8List obj) predicate, dynamic thisArg);
  external num findIndex(bool Function(num value, num index, Uint8List obj) predicate, dynamic thisArg);
  external void forEach(void Function(num value, num index, Uint8List array) callbackfn, dynamic thisArg);
  external num indexOf(num searchElement, num fromIndex);
  external String join(String separator);
  external num lastIndexOf(num searchElement, num fromIndex);
  external num get length;
  external Uint8List map(num Function(num value, num index, Uint8List array) callbackfn, dynamic thisArg);
  external num reduce(num Function(num previousValue, num currentValue, num currentIndex, Uint8List array) callbackfn);
  external num reduceRight(
      num Function(num previousValue, num currentValue, num currentIndex, Uint8List array) callbackfn);
  external Uint8List reverse();
  external void set(ArrayLike<num> array, num offset);
  external Uint8List slice(num start, num end);
  external bool some(dynamic Function(num value, num index, Uint8List array) predicate, dynamic thisArg);
  external Uint8Array sort(num Function(num a, num b) compareFn);
  external Uint8List subarray(num begin, num end);
  external String toLocaleString();
  @override
  external String toString();
  external Uint8List valueOf();
  external factory Uint8Array({
    num BYTES_PER_ELEMENT,
    ArrayBufferLike buffer,
    num byteLength,
    num byteOffset,
    num length,
  });
}

@JS()
class Uint8ArrayConstructor {
  external Uint8List get prototype;
  external factory Uint8ArrayConstructor({num length});
  external num get BYTES_PER_ELEMENT;
  external Uint8List of([
    num? items1,
    num? items2,
    num? items3,
    num? items4,
    num? items5,
    num? items6,
    num? items7,
    num? items8,
    num? items9,
  ]);
  external Uint8List from(ArrayLike<num> arrayLike);
}

@JS(r'Uint8Array')
external Uint8ArrayConstructor JUint8Array;

@JS()
@anonymous
class Uint8ClampedArray {
  external num get BYTES_PER_ELEMENT;
  external ArrayBufferLike get buffer;
  external num get byteLength;
  external num get byteOffset;
  external Uint8ClampedArray copyWithin(num target, num start, num end);
  external bool every(dynamic Function(num value, num index, Uint8ClampedList array) predicate, dynamic thisArg);
  external Uint8ClampedArray fill(num value, num start, num end);
  external Uint8ClampedList filter(
      dynamic Function(num value, num index, Uint8ClampedList array) predicate, dynamic thisArg);
  external num? find(bool Function(num value, num index, Uint8ClampedList obj) predicate, dynamic thisArg);
  external num findIndex(bool Function(num value, num index, Uint8ClampedList obj) predicate, dynamic thisArg);
  external void forEach(void Function(num value, num index, Uint8ClampedList array) callbackfn, dynamic thisArg);
  external num indexOf(num searchElement, num fromIndex);
  external String join(String separator);
  external num lastIndexOf(num searchElement, num fromIndex);
  external num get length;
  external Uint8ClampedList map(num Function(num value, num index, Uint8ClampedList array) callbackfn, dynamic thisArg);
  external num reduce(
      num Function(num previousValue, num currentValue, num currentIndex, Uint8ClampedList array) callbackfn);
  external num reduceRight(
      num Function(num previousValue, num currentValue, num currentIndex, Uint8ClampedList array) callbackfn);
  external Uint8ClampedList reverse();
  external void set(ArrayLike<num> array, num offset);
  external Uint8ClampedList slice(num start, num end);
  external bool some(dynamic Function(num value, num index, Uint8ClampedList array) predicate, dynamic thisArg);
  external Uint8ClampedArray sort(num Function(num a, num b) compareFn);
  external Uint8ClampedList subarray(num begin, num end);
  external String toLocaleString();
  @override
  external String toString();
  external Uint8ClampedList valueOf();
  external factory Uint8ClampedArray({
    num BYTES_PER_ELEMENT,
    ArrayBufferLike buffer,
    num byteLength,
    num byteOffset,
    num length,
  });
}

@JS()
class Uint8ClampedArrayConstructor {
  external Uint8ClampedList get prototype;
  external factory Uint8ClampedArrayConstructor({num length});
  external num get BYTES_PER_ELEMENT;
  external Uint8ClampedList of([
    num? items1,
    num? items2,
    num? items3,
    num? items4,
    num? items5,
    num? items6,
    num? items7,
    num? items8,
    num? items9,
  ]);
  external Uint8ClampedList from(ArrayLike<num> arrayLike);
}

@JS(r'Uint8ClampedArray')
external Uint8ClampedArrayConstructor JUint8ClampedArray;

@JS()
@anonymous
class Int16Array {
  external num get BYTES_PER_ELEMENT;
  external ArrayBufferLike get buffer;
  external num get byteLength;
  external num get byteOffset;
  external Int16Array copyWithin(num target, num start, num end);
  external bool every(dynamic Function(num value, num index, Int16List array) predicate, dynamic thisArg);
  external Int16Array fill(num value, num start, num end);
  external Int16List filter(dynamic Function(num value, num index, Int16List array) predicate, dynamic thisArg);
  external num? find(bool Function(num value, num index, Int16List obj) predicate, dynamic thisArg);
  external num findIndex(bool Function(num value, num index, Int16List obj) predicate, dynamic thisArg);
  external void forEach(void Function(num value, num index, Int16List array) callbackfn, dynamic thisArg);
  external num indexOf(num searchElement, num fromIndex);
  external String join(String separator);
  external num lastIndexOf(num searchElement, num fromIndex);
  external num get length;
  external Int16List map(num Function(num value, num index, Int16List array) callbackfn, dynamic thisArg);
  external num reduce(num Function(num previousValue, num currentValue, num currentIndex, Int16List array) callbackfn);
  external num reduceRight(
      num Function(num previousValue, num currentValue, num currentIndex, Int16List array) callbackfn);
  external Int16List reverse();
  external void set(ArrayLike<num> array, num offset);
  external Int16List slice(num start, num end);
  external bool some(dynamic Function(num value, num index, Int16List array) predicate, dynamic thisArg);
  external Int16Array sort(num Function(num a, num b) compareFn);
  external Int16List subarray(num begin, num end);
  external String toLocaleString();
  @override
  external String toString();
  external Int16List valueOf();
  external factory Int16Array({
    num BYTES_PER_ELEMENT,
    ArrayBufferLike buffer,
    num byteLength,
    num byteOffset,
    num length,
  });
}

@JS()
class Int16ArrayConstructor {
  external Int16List get prototype;
  external factory Int16ArrayConstructor({num length});
  external num get BYTES_PER_ELEMENT;
  external Int16List of([
    num? items1,
    num? items2,
    num? items3,
    num? items4,
    num? items5,
    num? items6,
    num? items7,
    num? items8,
    num? items9,
  ]);
  external Int16List from(ArrayLike<num> arrayLike);
}

@JS(r'Int16Array')
external Int16ArrayConstructor JInt16Array;

@JS()
@anonymous
class Uint16Array {
  external num get BYTES_PER_ELEMENT;
  external ArrayBufferLike get buffer;
  external num get byteLength;
  external num get byteOffset;
  external Uint16Array copyWithin(num target, num start, num end);
  external bool every(dynamic Function(num value, num index, Uint16List array) predicate, dynamic thisArg);
  external Uint16Array fill(num value, num start, num end);
  external Uint16List filter(dynamic Function(num value, num index, Uint16List array) predicate, dynamic thisArg);
  external num? find(bool Function(num value, num index, Uint16List obj) predicate, dynamic thisArg);
  external num findIndex(bool Function(num value, num index, Uint16List obj) predicate, dynamic thisArg);
  external void forEach(void Function(num value, num index, Uint16List array) callbackfn, dynamic thisArg);
  external num indexOf(num searchElement, num fromIndex);
  external String join(String separator);
  external num lastIndexOf(num searchElement, num fromIndex);
  external num get length;
  external Uint16List map(num Function(num value, num index, Uint16List array) callbackfn, dynamic thisArg);
  external num reduce(num Function(num previousValue, num currentValue, num currentIndex, Uint16List array) callbackfn);
  external num reduceRight(
      num Function(num previousValue, num currentValue, num currentIndex, Uint16List array) callbackfn);
  external Uint16List reverse();
  external void set(ArrayLike<num> array, num offset);
  external Uint16List slice(num start, num end);
  external bool some(dynamic Function(num value, num index, Uint16List array) predicate, dynamic thisArg);
  external Uint16Array sort(num Function(num a, num b) compareFn);
  external Uint16List subarray(num begin, num end);
  external String toLocaleString();
  @override
  external String toString();
  external Uint16List valueOf();
  external factory Uint16Array({
    num BYTES_PER_ELEMENT,
    ArrayBufferLike buffer,
    num byteLength,
    num byteOffset,
    num length,
  });
}

@JS()
class Uint16ArrayConstructor {
  external Uint16List get prototype;
  external factory Uint16ArrayConstructor({num length});
  external num get BYTES_PER_ELEMENT;
  external Uint16List of([
    num? items1,
    num? items2,
    num? items3,
    num? items4,
    num? items5,
    num? items6,
    num? items7,
    num? items8,
    num? items9,
  ]);
  external Uint16List from(ArrayLike<num> arrayLike);
}

@JS(r'Uint16Array')
external Uint16ArrayConstructor JUint16Array;

@JS()
@anonymous
class Int32Array {
  external num get BYTES_PER_ELEMENT;
  external ArrayBufferLike get buffer;
  external num get byteLength;
  external num get byteOffset;
  external Int32Array copyWithin(num target, num start, num end);
  external bool every(dynamic Function(num value, num index, Int32List array) predicate, dynamic thisArg);
  external Int32Array fill(num value, num start, num end);
  external Int32List filter(dynamic Function(num value, num index, Int32List array) predicate, dynamic thisArg);
  external num? find(bool Function(num value, num index, Int32List obj) predicate, dynamic thisArg);
  external num findIndex(bool Function(num value, num index, Int32List obj) predicate, dynamic thisArg);
  external void forEach(void Function(num value, num index, Int32List array) callbackfn, dynamic thisArg);
  external num indexOf(num searchElement, num fromIndex);
  external String join(String separator);
  external num lastIndexOf(num searchElement, num fromIndex);
  external num get length;
  external Int32List map(num Function(num value, num index, Int32List array) callbackfn, dynamic thisArg);
  external num reduce(num Function(num previousValue, num currentValue, num currentIndex, Int32List array) callbackfn);
  external num reduceRight(
      num Function(num previousValue, num currentValue, num currentIndex, Int32List array) callbackfn);
  external Int32List reverse();
  external void set(ArrayLike<num> array, num offset);
  external Int32List slice(num start, num end);
  external bool some(dynamic Function(num value, num index, Int32List array) predicate, dynamic thisArg);
  external Int32Array sort(num Function(num a, num b) compareFn);
  external Int32List subarray(num begin, num end);
  external String toLocaleString();
  @override
  external String toString();
  external Int32List valueOf();
  external factory Int32Array({
    num BYTES_PER_ELEMENT,
    ArrayBufferLike buffer,
    num byteLength,
    num byteOffset,
    num length,
  });
}

@JS()
class Int32ArrayConstructor {
  external Int32List get prototype;
  external factory Int32ArrayConstructor({num length});
  external num get BYTES_PER_ELEMENT;
  external Int32List of([
    num? items1,
    num? items2,
    num? items3,
    num? items4,
    num? items5,
    num? items6,
    num? items7,
    num? items8,
    num? items9,
  ]);
  external Int32List from(ArrayLike<num> arrayLike);
}

@JS(r'Int32Array')
external Int32ArrayConstructor JInt32Array;

@JS()
@anonymous
class Uint32Array {
  external num get BYTES_PER_ELEMENT;
  external ArrayBufferLike get buffer;
  external num get byteLength;
  external num get byteOffset;
  external Uint32Array copyWithin(num target, num start, num end);
  external bool every(dynamic Function(num value, num index, Uint32List array) predicate, dynamic thisArg);
  external Uint32Array fill(num value, num start, num end);
  external Uint32List filter(dynamic Function(num value, num index, Uint32List array) predicate, dynamic thisArg);
  external num? find(bool Function(num value, num index, Uint32List obj) predicate, dynamic thisArg);
  external num findIndex(bool Function(num value, num index, Uint32List obj) predicate, dynamic thisArg);
  external void forEach(void Function(num value, num index, Uint32List array) callbackfn, dynamic thisArg);
  external num indexOf(num searchElement, num fromIndex);
  external String join(String separator);
  external num lastIndexOf(num searchElement, num fromIndex);
  external num get length;
  external Uint32List map(num Function(num value, num index, Uint32List array) callbackfn, dynamic thisArg);
  external num reduce(num Function(num previousValue, num currentValue, num currentIndex, Uint32List array) callbackfn);
  external num reduceRight(
      num Function(num previousValue, num currentValue, num currentIndex, Uint32List array) callbackfn);
  external Uint32List reverse();
  external void set(ArrayLike<num> array, num offset);
  external Uint32List slice(num start, num end);
  external bool some(dynamic Function(num value, num index, Uint32List array) predicate, dynamic thisArg);
  external Uint32Array sort(num Function(num a, num b) compareFn);
  external Uint32List subarray(num begin, num end);
  external String toLocaleString();
  @override
  external String toString();
  external Uint32List valueOf();
  external factory Uint32Array({
    num BYTES_PER_ELEMENT,
    ArrayBufferLike buffer,
    num byteLength,
    num byteOffset,
    num length,
  });
}

@JS()
class Uint32ArrayConstructor {
  external Uint32List get prototype;
  external factory Uint32ArrayConstructor({num length});
  external num get BYTES_PER_ELEMENT;
  external Uint32List of([
    num? items1,
    num? items2,
    num? items3,
    num? items4,
    num? items5,
    num? items6,
    num? items7,
    num? items8,
    num? items9,
  ]);
  external Uint32List from(ArrayLike<num> arrayLike);
}

@JS(r'Uint32Array')
external Uint32ArrayConstructor JUint32Array;

@JS()
@anonymous
class Float32Array {
  external num get BYTES_PER_ELEMENT;
  external ArrayBufferLike get buffer;
  external num get byteLength;
  external num get byteOffset;
  external Float32Array copyWithin(num target, num start, num end);
  external bool every(dynamic Function(num value, num index, Float32List array) predicate, dynamic thisArg);
  external Float32Array fill(num value, num start, num end);
  external Float32List filter(dynamic Function(num value, num index, Float32List array) predicate, dynamic thisArg);
  external num? find(bool Function(num value, num index, Float32List obj) predicate, dynamic thisArg);
  external num findIndex(bool Function(num value, num index, Float32List obj) predicate, dynamic thisArg);
  external void forEach(void Function(num value, num index, Float32List array) callbackfn, dynamic thisArg);
  external num indexOf(num searchElement, num fromIndex);
  external String join(String separator);
  external num lastIndexOf(num searchElement, num fromIndex);
  external num get length;
  external Float32List map(num Function(num value, num index, Float32List array) callbackfn, dynamic thisArg);
  external num reduce(
      num Function(num previousValue, num currentValue, num currentIndex, Float32List array) callbackfn);
  external num reduceRight(
      num Function(num previousValue, num currentValue, num currentIndex, Float32List array) callbackfn);
  external Float32List reverse();
  external void set(ArrayLike<num> array, num offset);
  external Float32List slice(num start, num end);
  external bool some(dynamic Function(num value, num index, Float32List array) predicate, dynamic thisArg);
  external Float32Array sort(num Function(num a, num b) compareFn);
  external Float32List subarray(num begin, num end);
  external String toLocaleString();
  @override
  external String toString();
  external Float32List valueOf();
  external factory Float32Array({
    num BYTES_PER_ELEMENT,
    ArrayBufferLike buffer,
    num byteLength,
    num byteOffset,
    num length,
  });
}

@JS()
class Float32ArrayConstructor {
  external Float32List get prototype;
  external factory Float32ArrayConstructor({num length});
  external num get BYTES_PER_ELEMENT;
  external Float32List of([
    num? items1,
    num? items2,
    num? items3,
    num? items4,
    num? items5,
    num? items6,
    num? items7,
    num? items8,
    num? items9,
  ]);
  external Float32List from(ArrayLike<num> arrayLike);
}

@JS(r'Float32Array')
external Float32ArrayConstructor JFloat32Array;

@JS()
@anonymous
class Float64Array {
  external num get BYTES_PER_ELEMENT;
  external ArrayBufferLike get buffer;
  external num get byteLength;
  external num get byteOffset;
  external Float64Array copyWithin(num target, num start, num end);
  external bool every(dynamic Function(num value, num index, Float64List array) predicate, dynamic thisArg);
  external Float64Array fill(num value, num start, num end);
  external Float64List filter(dynamic Function(num value, num index, Float64List array) predicate, dynamic thisArg);
  external num? find(bool Function(num value, num index, Float64List obj) predicate, dynamic thisArg);
  external num findIndex(bool Function(num value, num index, Float64List obj) predicate, dynamic thisArg);
  external void forEach(void Function(num value, num index, Float64List array) callbackfn, dynamic thisArg);
  external num indexOf(num searchElement, num fromIndex);
  external String join(String separator);
  external num lastIndexOf(num searchElement, num fromIndex);
  external num get length;
  external Float64List map(num Function(num value, num index, Float64List array) callbackfn, dynamic thisArg);
  external num reduce(
      num Function(num previousValue, num currentValue, num currentIndex, Float64List array) callbackfn);
  external num reduceRight(
      num Function(num previousValue, num currentValue, num currentIndex, Float64List array) callbackfn);
  external Float64List reverse();
  external void set(ArrayLike<num> array, num offset);
  external Float64List slice(num start, num end);
  external bool some(dynamic Function(num value, num index, Float64List array) predicate, dynamic thisArg);
  external Float64Array sort(num Function(num a, num b) compareFn);
  external Float64List subarray(num begin, num end);
  @override
  external String toString();
  external Float64List valueOf();
  external factory Float64Array({
    num BYTES_PER_ELEMENT,
    ArrayBufferLike buffer,
    num byteLength,
    num byteOffset,
    num length,
  });
}

@JS()
class Float64ArrayConstructor {
  external Float64List get prototype;
  external factory Float64ArrayConstructor({num length});
  external num get BYTES_PER_ELEMENT;
  external Float64List of([
    num? items1,
    num? items2,
    num? items3,
    num? items4,
    num? items5,
    num? items6,
    num? items7,
    num? items8,
    num? items9,
  ]);
  external Float64List from(ArrayLike<num> arrayLike);
}

@JS(r'Float64Array')
external Float64ArrayConstructor JFloat64Array;

@JS()
@anonymous
class CollatorOptions {
  external String? usage;
  external String? localeMatcher;
  external bool? numeric;
  external String? caseFirst;
  external String? sensitivity;
  external bool? ignorePunctuation;
  external factory CollatorOptions({
    String? usage,
    String? localeMatcher,
    bool? numeric,
    String? caseFirst,
    String? sensitivity,
    bool? ignorePunctuation,
  });
}

@JS()
@anonymous
class ResolvedCollatorOptions {
  external String locale;
  external String usage;
  external String sensitivity;
  external bool ignorePunctuation;
  external String collation;
  external String caseFirst;
  external bool numeric;
  external factory ResolvedCollatorOptions({
    String locale,
    String usage,
    String sensitivity,
    bool ignorePunctuation,
    String collation,
    String caseFirst,
    bool numeric,
  });
}

@JS()
@anonymous
class Collator {
  external num compare(String x, String y);
  external ResolvedCollatorOptions resolvedOptions();
  external factory Collator();
}

@JS(r'Intl.Collator')
external ICollator JCollator;

@JS()
@anonymous
class NumberFormatOptions {
  external String? localeMatcher;
  external String? style;
  external String? currency;
  external String? currencyDisplay;
  external String? currencySign;
  external bool? useGrouping;
  external num? minimumIntegerDigits;
  external num? minimumFractionDigits;
  external num? maximumFractionDigits;
  external num? minimumSignificantDigits;
  external num? maximumSignificantDigits;
  external factory NumberFormatOptions({
    String? localeMatcher,
    String? style,
    String? currency,
    String? currencyDisplay,
    String? currencySign,
    bool? useGrouping,
    num? minimumIntegerDigits,
    num? minimumFractionDigits,
    num? maximumFractionDigits,
    num? minimumSignificantDigits,
    num? maximumSignificantDigits,
  });
}

@JS()
@anonymous
class ResolvedNumberFormatOptions {
  external String locale;
  external String numberingSystem;
  external String style;
  external String? currency;
  external String? currencyDisplay;
  external num minimumIntegerDigits;
  external num minimumFractionDigits;
  external num maximumFractionDigits;
  external num? minimumSignificantDigits;
  external num? maximumSignificantDigits;
  external bool useGrouping;
  external factory ResolvedNumberFormatOptions({
    String locale,
    String numberingSystem,
    String style,
    String? currency,
    String? currencyDisplay,
    num minimumIntegerDigits,
    num minimumFractionDigits,
    num maximumFractionDigits,
    num? minimumSignificantDigits,
    num? maximumSignificantDigits,
    bool useGrouping,
  });
}

@JS()
@anonymous
class NumberFormat {
  external String format(num value);
  external ResolvedNumberFormatOptions resolvedOptions();
  external factory NumberFormat();
}

@JS(r'Intl.NumberFormat')
external INumberFormat JNumberFormat;

@JS()
@anonymous
class DateTimeFormatOptions {
  external String? localeMatcher;
  external String? weekday;
  external String? era;
  external String? year;
  external String? month;
  external String? day;
  external String? hour;
  external String? minute;
  external String? second;
  external String? timeZoneName;
  external String? formatMatcher;
  external bool? hour12;
  external String? timeZone;
  external factory DateTimeFormatOptions({
    String? localeMatcher,
    String? weekday,
    String? era,
    String? year,
    String? month,
    String? day,
    String? hour,
    String? minute,
    String? second,
    String? timeZoneName,
    String? formatMatcher,
    bool? hour12,
    String? timeZone,
  });
}

@JS()
@anonymous
class ResolvedDateTimeFormatOptions {
  external String locale;
  external String calendar;
  external String numberingSystem;
  external String timeZone;
  external bool? hour12;
  external String? weekday;
  external String? era;
  external String? year;
  external String? month;
  external String? day;
  external String? hour;
  external String? minute;
  external String? second;
  external String? timeZoneName;
  external factory ResolvedDateTimeFormatOptions({
    String locale,
    String calendar,
    String numberingSystem,
    String timeZone,
    bool? hour12,
    String? weekday,
    String? era,
    String? year,
    String? month,
    String? day,
    String? hour,
    String? minute,
    String? second,
    String? timeZoneName,
  });
}

@JS()
@anonymous
class DateTimeFormat {
  external String format(dynamic date);
  external ResolvedDateTimeFormatOptions resolvedOptions();
  external factory DateTimeFormat();
}

@JS(r'Intl.DateTimeFormat')
external IDateTimeFormat JDateTimeFormat;

@JS()
@anonymous
class Number {
  external String toLocaleString(dynamic locales, NumberFormatOptions options);
  external factory Number();
}

@JS()
@anonymous
class Date {
  external String toLocaleString(dynamic locales, DateTimeFormatOptions options);
  external String toLocaleDateString(dynamic locales, DateTimeFormatOptions options);
  external String toLocaleTimeString(dynamic locales, DateTimeFormatOptions options);
  external factory Date();
}

@JS()
@anonymous
class ICollator {
  external factory ICollator({dynamic locales, CollatorOptions options});
  external Collator call(dynamic locales, CollatorOptions options);
  external List<String> supportedLocalesOf(dynamic locales, CollatorOptions options);
}

@JS()
@anonymous
class IDateTimeFormat {
  external factory IDateTimeFormat({dynamic locales, DateTimeFormatOptions options});
  external DateTimeFormat call(dynamic locales, DateTimeFormatOptions options);
  external List<String> supportedLocalesOf(dynamic locales, DateTimeFormatOptions options);
}

@JS()
@anonymous
class INumberFormat {
  external factory INumberFormat({dynamic locales, NumberFormatOptions options});
  external NumberFormat call(dynamic locales, NumberFormatOptions options);
  external List<String> supportedLocalesOf(dynamic locales, NumberFormatOptions options);
}
