//
//  Generated code. Do not modify.
//  source: proto/schema_neko.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class UpdateStrategy extends $pb.ProtobufEnum {
  static const UpdateStrategy ALWAYS_UPDATE =
      UpdateStrategy._(0, _omitEnumNames ? '' : 'ALWAYS_UPDATE');
  static const UpdateStrategy ONLY_FETCH_ONCE =
      UpdateStrategy._(1, _omitEnumNames ? '' : 'ONLY_FETCH_ONCE');

  static const $core.List<UpdateStrategy> values = <UpdateStrategy>[
    ALWAYS_UPDATE,
    ONLY_FETCH_ONCE,
  ];

  static final $core.Map<$core.int, UpdateStrategy> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static UpdateStrategy? valueOf($core.int value) => _byValue[value];

  const UpdateStrategy._(super.v, super.n);
}

const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
