//
//  Generated code. Do not modify.
//  source: proto/schema_neko.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use updateStrategyDescriptor instead')
const UpdateStrategy$json = {
  '1': 'UpdateStrategy',
  '2': [
    {'1': 'ALWAYS_UPDATE', '2': 0},
    {'1': 'ONLY_FETCH_ONCE', '2': 1},
  ],
};

/// Descriptor for `UpdateStrategy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List updateStrategyDescriptor =
    $convert.base64Decode('Cg5VcGRhdGVTdHJhdGVneRIRCg1BTFdBWVNfVVBEQVRFEAASEwoPT05MWV9GRVRDSF9PTkNFEA'
        'E=');

@$core.Deprecated('Use preferenceValueDescriptor instead')
const PreferenceValue$json = {
  '1': 'PreferenceValue',
  '2': [
    {'1': 'type', '3': 1, '4': 2, '5': 9, '10': 'type'},
    {'1': 'truevalue', '3': 2, '4': 2, '5': 12, '10': 'truevalue'},
  ],
};

/// Descriptor for `PreferenceValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List preferenceValueDescriptor =
    $convert.base64Decode('Cg9QcmVmZXJlbmNlVmFsdWUSEgoEdHlwZRgBIAIoCVIEdHlwZRIcCgl0cnVldmFsdWUYAiACKA'
        'xSCXRydWV2YWx1ZQ==');

@$core.Deprecated('Use backupDescriptor instead')
const Backup$json = {
  '1': 'Backup',
  '2': [
    {'1': 'backupManga', '3': 1, '4': 3, '5': 11, '6': '.BackupManga', '10': 'backupManga'},
    {'1': 'backupCategories', '3': 2, '4': 3, '5': 11, '6': '.BackupCategory', '10': 'backupCategories'},
  ],
};

/// Descriptor for `Backup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupDescriptor =
    $convert.base64Decode('CgZCYWNrdXASLgoLYmFja3VwTWFuZ2EYASADKAsyDC5CYWNrdXBNYW5nYVILYmFja3VwTWFuZ2'
        'ESOwoQYmFja3VwQ2F0ZWdvcmllcxgCIAMoCzIPLkJhY2t1cENhdGVnb3J5UhBiYWNrdXBDYXRl'
        'Z29yaWVz');

@$core.Deprecated('Use backupCategoryDescriptor instead')
const BackupCategory$json = {
  '1': 'BackupCategory',
  '2': [
    {'1': 'name', '3': 1, '4': 2, '5': 9, '10': 'name'},
    {'1': 'order', '3': 2, '4': 1, '5': 5, '10': 'order'},
    {'1': 'flags', '3': 100, '4': 1, '5': 5, '10': 'flags'},
  ],
};

/// Descriptor for `BackupCategory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupCategoryDescriptor =
    $convert.base64Decode('Cg5CYWNrdXBDYXRlZ29yeRISCgRuYW1lGAEgAigJUgRuYW1lEhQKBW9yZGVyGAIgASgFUgVvcm'
        'RlchIUCgVmbGFncxhkIAEoBVIFZmxhZ3M=');

@$core.Deprecated('Use backupChapterDescriptor instead')
const BackupChapter$json = {
  '1': 'BackupChapter',
  '2': [
    {'1': 'url', '3': 1, '4': 2, '5': 9, '10': 'url'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'scanlator', '3': 3, '4': 1, '5': 9, '10': 'scanlator'},
    {'1': 'read', '3': 4, '4': 1, '5': 8, '10': 'read'},
    {'1': 'bookmark', '3': 5, '4': 1, '5': 8, '10': 'bookmark'},
    {'1': 'lastPageRead', '3': 6, '4': 1, '5': 5, '10': 'lastPageRead'},
    {'1': 'dateFetch', '3': 7, '4': 1, '5': 3, '10': 'dateFetch'},
    {'1': 'dateUpload', '3': 8, '4': 1, '5': 3, '10': 'dateUpload'},
    {'1': 'chapterNumber', '3': 9, '4': 1, '5': 2, '10': 'chapterNumber'},
    {'1': 'sourceOrder', '3': 10, '4': 1, '5': 5, '10': 'sourceOrder'},
    {'1': 'pagesLeft', '3': 800, '4': 1, '5': 5, '10': 'pagesLeft'},
    {'1': 'uploader', '3': 905, '4': 1, '5': 9, '10': 'uploader'},
    {'1': 'isUnavailable', '3': 906, '4': 1, '5': 8, '10': 'isUnavailable'},
  ],
};

/// Descriptor for `BackupChapter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupChapterDescriptor =
    $convert.base64Decode('Cg1CYWNrdXBDaGFwdGVyEhAKA3VybBgBIAIoCVIDdXJsEhIKBG5hbWUYAiACKAlSBG5hbWUSHA'
        'oJc2NhbmxhdG9yGAMgASgJUglzY2FubGF0b3ISEgoEcmVhZBgEIAEoCFIEcmVhZBIaCghib29r'
        'bWFyaxgFIAEoCFIIYm9va21hcmsSIgoMbGFzdFBhZ2VSZWFkGAYgASgFUgxsYXN0UGFnZVJlYW'
        'QSHAoJZGF0ZUZldGNoGAcgASgDUglkYXRlRmV0Y2gSHgoKZGF0ZVVwbG9hZBgIIAEoA1IKZGF0'
        'ZVVwbG9hZBIkCg1jaGFwdGVyTnVtYmVyGAkgASgCUg1jaGFwdGVyTnVtYmVyEiAKC3NvdXJjZU'
        '9yZGVyGAogASgFUgtzb3VyY2VPcmRlchIdCglwYWdlc0xlZnQYoAYgASgFUglwYWdlc0xlZnQS'
        'GwoIdXBsb2FkZXIYiQcgASgJUgh1cGxvYWRlchIlCg1pc1VuYXZhaWxhYmxlGIoHIAEoCFINaX'
        'NVbmF2YWlsYWJsZQ==');

@$core.Deprecated('Use brokenBackupHistoryDescriptor instead')
const BrokenBackupHistory$json = {
  '1': 'BrokenBackupHistory',
  '2': [
    {'1': 'url', '3': 1, '4': 2, '5': 9, '10': 'url'},
    {'1': 'lastRead', '3': 2, '4': 2, '5': 3, '10': 'lastRead'},
    {'1': 'readDuration', '3': 3, '4': 1, '5': 3, '10': 'readDuration'},
  ],
};

/// Descriptor for `BrokenBackupHistory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List brokenBackupHistoryDescriptor =
    $convert.base64Decode('ChNCcm9rZW5CYWNrdXBIaXN0b3J5EhAKA3VybBgBIAIoCVIDdXJsEhoKCGxhc3RSZWFkGAIgAi'
        'gDUghsYXN0UmVhZBIiCgxyZWFkRHVyYXRpb24YAyABKANSDHJlYWREdXJhdGlvbg==');

@$core.Deprecated('Use backupHistoryDescriptor instead')
const BackupHistory$json = {
  '1': 'BackupHistory',
  '2': [
    {'1': 'url', '3': 1, '4': 2, '5': 9, '10': 'url'},
    {'1': 'lastRead', '3': 2, '4': 2, '5': 3, '10': 'lastRead'},
    {'1': 'readDuration', '3': 3, '4': 1, '5': 3, '10': 'readDuration'},
  ],
};

/// Descriptor for `BackupHistory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupHistoryDescriptor =
    $convert.base64Decode('Cg1CYWNrdXBIaXN0b3J5EhAKA3VybBgBIAIoCVIDdXJsEhoKCGxhc3RSZWFkGAIgAigDUghsYX'
        'N0UmVhZBIiCgxyZWFkRHVyYXRpb24YAyABKANSDHJlYWREdXJhdGlvbg==');

@$core.Deprecated('Use backupMangaDescriptor instead')
const BackupManga$json = {
  '1': 'BackupManga',
  '2': [
    {'1': 'source', '3': 1, '4': 2, '5': 3, '10': 'source'},
    {'1': 'url', '3': 2, '4': 2, '5': 9, '10': 'url'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'artist', '3': 4, '4': 1, '5': 9, '10': 'artist'},
    {'1': 'author', '3': 5, '4': 1, '5': 9, '10': 'author'},
    {'1': 'description', '3': 6, '4': 1, '5': 9, '10': 'description'},
    {'1': 'genre', '3': 7, '4': 3, '5': 9, '10': 'genre'},
    {'1': 'status', '3': 8, '4': 1, '5': 5, '10': 'status'},
    {'1': 'thumbnailUrl', '3': 9, '4': 1, '5': 9, '10': 'thumbnailUrl'},
    {'1': 'dateAdded', '3': 13, '4': 1, '5': 3, '10': 'dateAdded'},
    {'1': 'viewer', '3': 14, '4': 1, '5': 5, '10': 'viewer'},
    {'1': 'chapters', '3': 16, '4': 3, '5': 11, '6': '.BackupChapter', '10': 'chapters'},
    {'1': 'categories', '3': 17, '4': 3, '5': 5, '10': 'categories'},
    {'1': 'tracking', '3': 18, '4': 3, '5': 11, '6': '.BackupTracking', '10': 'tracking'},
    {'1': 'favorite', '3': 100, '4': 1, '5': 8, '10': 'favorite'},
    {'1': 'chapterFlags', '3': 101, '4': 1, '5': 5, '10': 'chapterFlags'},
    {'1': 'brokenHistory', '3': 102, '4': 3, '5': 11, '6': '.BrokenBackupHistory', '10': 'brokenHistory'},
    {'1': 'viewer_flags', '3': 103, '4': 1, '5': 5, '10': 'viewerFlags'},
    {'1': 'history', '3': 104, '4': 3, '5': 11, '6': '.BackupHistory', '10': 'history'},
    {'1': 'customTitle', '3': 800, '4': 1, '5': 9, '10': 'customTitle'},
    {'1': 'scanlatorFilter', '3': 901, '4': 1, '5': 9, '10': 'scanlatorFilter'},
    {'1': 'alternativeArtwork', '3': 903, '4': 1, '5': 9, '10': 'alternativeArtwork'},
    {'1': 'mergeMangaList', '3': 904, '4': 3, '5': 11, '6': '.BackupMergeManga', '10': 'mergeMangaList'},
  ],
};

/// Descriptor for `BackupManga`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupMangaDescriptor =
    $convert.base64Decode('CgtCYWNrdXBNYW5nYRIWCgZzb3VyY2UYASACKANSBnNvdXJjZRIQCgN1cmwYAiACKAlSA3VybB'
        'IUCgV0aXRsZRgDIAEoCVIFdGl0bGUSFgoGYXJ0aXN0GAQgASgJUgZhcnRpc3QSFgoGYXV0aG9y'
        'GAUgASgJUgZhdXRob3ISIAoLZGVzY3JpcHRpb24YBiABKAlSC2Rlc2NyaXB0aW9uEhQKBWdlbn'
        'JlGAcgAygJUgVnZW5yZRIWCgZzdGF0dXMYCCABKAVSBnN0YXR1cxIiCgx0aHVtYm5haWxVcmwY'
        'CSABKAlSDHRodW1ibmFpbFVybBIcCglkYXRlQWRkZWQYDSABKANSCWRhdGVBZGRlZBIWCgZ2aW'
        'V3ZXIYDiABKAVSBnZpZXdlchIqCghjaGFwdGVycxgQIAMoCzIOLkJhY2t1cENoYXB0ZXJSCGNo'
        'YXB0ZXJzEh4KCmNhdGVnb3JpZXMYESADKAVSCmNhdGVnb3JpZXMSKwoIdHJhY2tpbmcYEiADKA'
        'syDy5CYWNrdXBUcmFja2luZ1IIdHJhY2tpbmcSGgoIZmF2b3JpdGUYZCABKAhSCGZhdm9yaXRl'
        'EiIKDGNoYXB0ZXJGbGFncxhlIAEoBVIMY2hhcHRlckZsYWdzEjoKDWJyb2tlbkhpc3RvcnkYZi'
        'ADKAsyFC5Ccm9rZW5CYWNrdXBIaXN0b3J5Ug1icm9rZW5IaXN0b3J5EiEKDHZpZXdlcl9mbGFn'
        'cxhnIAEoBVILdmlld2VyRmxhZ3MSKAoHaGlzdG9yeRhoIAMoCzIOLkJhY2t1cEhpc3RvcnlSB2'
        'hpc3RvcnkSIQoLY3VzdG9tVGl0bGUYoAYgASgJUgtjdXN0b21UaXRsZRIpCg9zY2FubGF0b3JG'
        'aWx0ZXIYhQcgASgJUg9zY2FubGF0b3JGaWx0ZXISLwoSYWx0ZXJuYXRpdmVBcnR3b3JrGIcHIA'
        'EoCVISYWx0ZXJuYXRpdmVBcnR3b3JrEjoKDm1lcmdlTWFuZ2FMaXN0GIgHIAMoCzIRLkJhY2t1'
        'cE1lcmdlTWFuZ2FSDm1lcmdlTWFuZ2FMaXN0');

@$core.Deprecated('Use backupMergeMangaDescriptor instead')
const BackupMergeManga$json = {
  '1': 'BackupMergeManga',
  '2': [
    {'1': 'url', '3': 1, '4': 2, '5': 9, '10': 'url'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'coverUrl', '3': 3, '4': 1, '5': 9, '10': 'coverUrl'},
    {'1': 'mergeType', '3': 4, '4': 2, '5': 5, '10': 'mergeType'},
  ],
};

/// Descriptor for `BackupMergeManga`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupMergeMangaDescriptor =
    $convert.base64Decode('ChBCYWNrdXBNZXJnZU1hbmdhEhAKA3VybBgBIAIoCVIDdXJsEhQKBXRpdGxlGAIgASgJUgV0aX'
        'RsZRIaCghjb3ZlclVybBgDIAEoCVIIY292ZXJVcmwSHAoJbWVyZ2VUeXBlGAQgAigFUgltZXJn'
        'ZVR5cGU=');

@$core.Deprecated('Use backupTrackingDescriptor instead')
const BackupTracking$json = {
  '1': 'BackupTracking',
  '2': [
    {'1': 'syncId', '3': 1, '4': 2, '5': 5, '10': 'syncId'},
    {'1': 'libraryId', '3': 2, '4': 2, '5': 3, '10': 'libraryId'},
    {'1': 'mediaIdInt', '3': 3, '4': 1, '5': 5, '10': 'mediaIdInt'},
    {'1': 'trackingUrl', '3': 4, '4': 1, '5': 9, '10': 'trackingUrl'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {'1': 'lastChapterRead', '3': 6, '4': 1, '5': 2, '10': 'lastChapterRead'},
    {'1': 'totalChapters', '3': 7, '4': 1, '5': 5, '10': 'totalChapters'},
    {'1': 'score', '3': 8, '4': 1, '5': 2, '10': 'score'},
    {'1': 'status', '3': 9, '4': 1, '5': 5, '10': 'status'},
    {'1': 'startedReadingDate', '3': 10, '4': 1, '5': 3, '10': 'startedReadingDate'},
    {'1': 'finishedReadingDate', '3': 11, '4': 1, '5': 3, '10': 'finishedReadingDate'},
    {'1': 'mediaId', '3': 100, '4': 1, '5': 3, '10': 'mediaId'},
  ],
};

/// Descriptor for `BackupTracking`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupTrackingDescriptor =
    $convert.base64Decode('Cg5CYWNrdXBUcmFja2luZxIWCgZzeW5jSWQYASACKAVSBnN5bmNJZBIcCglsaWJyYXJ5SWQYAi'
        'ACKANSCWxpYnJhcnlJZBIeCgptZWRpYUlkSW50GAMgASgFUgptZWRpYUlkSW50EiAKC3RyYWNr'
        'aW5nVXJsGAQgASgJUgt0cmFja2luZ1VybBIUCgV0aXRsZRgFIAEoCVIFdGl0bGUSKAoPbGFzdE'
        'NoYXB0ZXJSZWFkGAYgASgCUg9sYXN0Q2hhcHRlclJlYWQSJAoNdG90YWxDaGFwdGVycxgHIAEo'
        'BVINdG90YWxDaGFwdGVycxIUCgVzY29yZRgIIAEoAlIFc2NvcmUSFgoGc3RhdHVzGAkgASgFUg'
        'ZzdGF0dXMSLgoSc3RhcnRlZFJlYWRpbmdEYXRlGAogASgDUhJzdGFydGVkUmVhZGluZ0RhdGUS'
        'MAoTZmluaXNoZWRSZWFkaW5nRGF0ZRgLIAEoA1ITZmluaXNoZWRSZWFkaW5nRGF0ZRIYCgdtZW'
        'RpYUlkGGQgASgDUgdtZWRpYUlk');
