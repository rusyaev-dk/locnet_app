// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ConversationTilesTableTable extends ConversationTilesTable
    with TableInfo<$ConversationTilesTableTable, ConversationTilesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationTilesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companionIdMeta = const VerificationMeta(
    'companionId',
  );
  @override
  late final GeneratedColumn<String> companionId = GeneratedColumn<String>(
    'companion_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companionUsernameMeta = const VerificationMeta(
    'companionUsername',
  );
  @override
  late final GeneratedColumn<String> companionUsername =
      GeneratedColumn<String>(
        'companion_username',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _companionFirstNameMeta =
      const VerificationMeta('companionFirstName');
  @override
  late final GeneratedColumn<String> companionFirstName =
      GeneratedColumn<String>(
        'companion_first_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _companionLastNameMeta = const VerificationMeta(
    'companionLastName',
  );
  @override
  late final GeneratedColumn<String> companionLastName =
      GeneratedColumn<String>(
        'companion_last_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _companionAvatarIdMeta = const VerificationMeta(
    'companionAvatarId',
  );
  @override
  late final GeneratedColumn<String> companionAvatarId =
      GeneratedColumn<String>(
        'companion_avatar_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastMessageTextMeta = const VerificationMeta(
    'lastMessageText',
  );
  @override
  late final GeneratedColumn<String> lastMessageText = GeneratedColumn<String>(
    'last_message_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastMessageSenderIdMeta =
      const VerificationMeta('lastMessageSenderId');
  @override
  late final GeneratedColumn<String> lastMessageSenderId =
      GeneratedColumn<String>(
        'last_message_sender_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastMessageAtMsMeta = const VerificationMeta(
    'lastMessageAtMs',
  );
  @override
  late final GeneratedColumn<int> lastMessageAtMs = GeneratedColumn<int>(
    'last_message_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMsMeta = const VerificationMeta(
    'cachedAtMs',
  );
  @override
  late final GeneratedColumn<int> cachedAtMs = GeneratedColumn<int>(
    'cached_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    title,
    description,
    companionId,
    companionUsername,
    companionFirstName,
    companionLastName,
    companionAvatarId,
    lastMessageText,
    lastMessageSenderId,
    lastMessageAtMs,
    updatedAtMs,
    cachedAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversation_tiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConversationTilesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('companion_id')) {
      context.handle(
        _companionIdMeta,
        companionId.isAcceptableOrUnknown(
          data['companion_id']!,
          _companionIdMeta,
        ),
      );
    }
    if (data.containsKey('companion_username')) {
      context.handle(
        _companionUsernameMeta,
        companionUsername.isAcceptableOrUnknown(
          data['companion_username']!,
          _companionUsernameMeta,
        ),
      );
    }
    if (data.containsKey('companion_first_name')) {
      context.handle(
        _companionFirstNameMeta,
        companionFirstName.isAcceptableOrUnknown(
          data['companion_first_name']!,
          _companionFirstNameMeta,
        ),
      );
    }
    if (data.containsKey('companion_last_name')) {
      context.handle(
        _companionLastNameMeta,
        companionLastName.isAcceptableOrUnknown(
          data['companion_last_name']!,
          _companionLastNameMeta,
        ),
      );
    }
    if (data.containsKey('companion_avatar_id')) {
      context.handle(
        _companionAvatarIdMeta,
        companionAvatarId.isAcceptableOrUnknown(
          data['companion_avatar_id']!,
          _companionAvatarIdMeta,
        ),
      );
    }
    if (data.containsKey('last_message_text')) {
      context.handle(
        _lastMessageTextMeta,
        lastMessageText.isAcceptableOrUnknown(
          data['last_message_text']!,
          _lastMessageTextMeta,
        ),
      );
    }
    if (data.containsKey('last_message_sender_id')) {
      context.handle(
        _lastMessageSenderIdMeta,
        lastMessageSenderId.isAcceptableOrUnknown(
          data['last_message_sender_id']!,
          _lastMessageSenderIdMeta,
        ),
      );
    }
    if (data.containsKey('last_message_at_ms')) {
      context.handle(
        _lastMessageAtMsMeta,
        lastMessageAtMs.isAcceptableOrUnknown(
          data['last_message_at_ms']!,
          _lastMessageAtMsMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMsMeta);
    }
    if (data.containsKey('cached_at_ms')) {
      context.handle(
        _cachedAtMsMeta,
        cachedAtMs.isAcceptableOrUnknown(
          data['cached_at_ms']!,
          _cachedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConversationTilesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversationTilesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      companionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}companion_id'],
      ),
      companionUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}companion_username'],
      ),
      companionFirstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}companion_first_name'],
      ),
      companionLastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}companion_last_name'],
      ),
      companionAvatarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}companion_avatar_id'],
      ),
      lastMessageText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_message_text'],
      ),
      lastMessageSenderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_message_sender_id'],
      ),
      lastMessageAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_message_at_ms'],
      ),
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
      )!,
      cachedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cached_at_ms'],
      )!,
    );
  }

  @override
  $ConversationTilesTableTable createAlias(String alias) {
    return $ConversationTilesTableTable(attachedDatabase, alias);
  }
}

class ConversationTilesTableData extends DataClass
    implements Insertable<ConversationTilesTableData> {
  final String id;
  final String type;
  final String title;
  final String? description;
  final String? companionId;
  final String? companionUsername;
  final String? companionFirstName;
  final String? companionLastName;
  final String? companionAvatarId;
  final String? lastMessageText;
  final String? lastMessageSenderId;
  final int? lastMessageAtMs;
  final int updatedAtMs;
  final int cachedAtMs;
  const ConversationTilesTableData({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    this.companionId,
    this.companionUsername,
    this.companionFirstName,
    this.companionLastName,
    this.companionAvatarId,
    this.lastMessageText,
    this.lastMessageSenderId,
    this.lastMessageAtMs,
    required this.updatedAtMs,
    required this.cachedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || companionId != null) {
      map['companion_id'] = Variable<String>(companionId);
    }
    if (!nullToAbsent || companionUsername != null) {
      map['companion_username'] = Variable<String>(companionUsername);
    }
    if (!nullToAbsent || companionFirstName != null) {
      map['companion_first_name'] = Variable<String>(companionFirstName);
    }
    if (!nullToAbsent || companionLastName != null) {
      map['companion_last_name'] = Variable<String>(companionLastName);
    }
    if (!nullToAbsent || companionAvatarId != null) {
      map['companion_avatar_id'] = Variable<String>(companionAvatarId);
    }
    if (!nullToAbsent || lastMessageText != null) {
      map['last_message_text'] = Variable<String>(lastMessageText);
    }
    if (!nullToAbsent || lastMessageSenderId != null) {
      map['last_message_sender_id'] = Variable<String>(lastMessageSenderId);
    }
    if (!nullToAbsent || lastMessageAtMs != null) {
      map['last_message_at_ms'] = Variable<int>(lastMessageAtMs);
    }
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    map['cached_at_ms'] = Variable<int>(cachedAtMs);
    return map;
  }

  ConversationTilesTableCompanion toCompanion(bool nullToAbsent) {
    return ConversationTilesTableCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      companionId: companionId == null && nullToAbsent
          ? const Value.absent()
          : Value(companionId),
      companionUsername: companionUsername == null && nullToAbsent
          ? const Value.absent()
          : Value(companionUsername),
      companionFirstName: companionFirstName == null && nullToAbsent
          ? const Value.absent()
          : Value(companionFirstName),
      companionLastName: companionLastName == null && nullToAbsent
          ? const Value.absent()
          : Value(companionLastName),
      companionAvatarId: companionAvatarId == null && nullToAbsent
          ? const Value.absent()
          : Value(companionAvatarId),
      lastMessageText: lastMessageText == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageText),
      lastMessageSenderId: lastMessageSenderId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageSenderId),
      lastMessageAtMs: lastMessageAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageAtMs),
      updatedAtMs: Value(updatedAtMs),
      cachedAtMs: Value(cachedAtMs),
    );
  }

  factory ConversationTilesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationTilesTableData(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      companionId: serializer.fromJson<String?>(json['companionId']),
      companionUsername: serializer.fromJson<String?>(
        json['companionUsername'],
      ),
      companionFirstName: serializer.fromJson<String?>(
        json['companionFirstName'],
      ),
      companionLastName: serializer.fromJson<String?>(
        json['companionLastName'],
      ),
      companionAvatarId: serializer.fromJson<String?>(
        json['companionAvatarId'],
      ),
      lastMessageText: serializer.fromJson<String?>(json['lastMessageText']),
      lastMessageSenderId: serializer.fromJson<String?>(
        json['lastMessageSenderId'],
      ),
      lastMessageAtMs: serializer.fromJson<int?>(json['lastMessageAtMs']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
      cachedAtMs: serializer.fromJson<int>(json['cachedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'companionId': serializer.toJson<String?>(companionId),
      'companionUsername': serializer.toJson<String?>(companionUsername),
      'companionFirstName': serializer.toJson<String?>(companionFirstName),
      'companionLastName': serializer.toJson<String?>(companionLastName),
      'companionAvatarId': serializer.toJson<String?>(companionAvatarId),
      'lastMessageText': serializer.toJson<String?>(lastMessageText),
      'lastMessageSenderId': serializer.toJson<String?>(lastMessageSenderId),
      'lastMessageAtMs': serializer.toJson<int?>(lastMessageAtMs),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
      'cachedAtMs': serializer.toJson<int>(cachedAtMs),
    };
  }

  ConversationTilesTableData copyWith({
    String? id,
    String? type,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> companionId = const Value.absent(),
    Value<String?> companionUsername = const Value.absent(),
    Value<String?> companionFirstName = const Value.absent(),
    Value<String?> companionLastName = const Value.absent(),
    Value<String?> companionAvatarId = const Value.absent(),
    Value<String?> lastMessageText = const Value.absent(),
    Value<String?> lastMessageSenderId = const Value.absent(),
    Value<int?> lastMessageAtMs = const Value.absent(),
    int? updatedAtMs,
    int? cachedAtMs,
  }) => ConversationTilesTableData(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    companionId: companionId.present ? companionId.value : this.companionId,
    companionUsername: companionUsername.present
        ? companionUsername.value
        : this.companionUsername,
    companionFirstName: companionFirstName.present
        ? companionFirstName.value
        : this.companionFirstName,
    companionLastName: companionLastName.present
        ? companionLastName.value
        : this.companionLastName,
    companionAvatarId: companionAvatarId.present
        ? companionAvatarId.value
        : this.companionAvatarId,
    lastMessageText: lastMessageText.present
        ? lastMessageText.value
        : this.lastMessageText,
    lastMessageSenderId: lastMessageSenderId.present
        ? lastMessageSenderId.value
        : this.lastMessageSenderId,
    lastMessageAtMs: lastMessageAtMs.present
        ? lastMessageAtMs.value
        : this.lastMessageAtMs,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
    cachedAtMs: cachedAtMs ?? this.cachedAtMs,
  );
  ConversationTilesTableData copyWithCompanion(
    ConversationTilesTableCompanion data,
  ) {
    return ConversationTilesTableData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      companionId: data.companionId.present
          ? data.companionId.value
          : this.companionId,
      companionUsername: data.companionUsername.present
          ? data.companionUsername.value
          : this.companionUsername,
      companionFirstName: data.companionFirstName.present
          ? data.companionFirstName.value
          : this.companionFirstName,
      companionLastName: data.companionLastName.present
          ? data.companionLastName.value
          : this.companionLastName,
      companionAvatarId: data.companionAvatarId.present
          ? data.companionAvatarId.value
          : this.companionAvatarId,
      lastMessageText: data.lastMessageText.present
          ? data.lastMessageText.value
          : this.lastMessageText,
      lastMessageSenderId: data.lastMessageSenderId.present
          ? data.lastMessageSenderId.value
          : this.lastMessageSenderId,
      lastMessageAtMs: data.lastMessageAtMs.present
          ? data.lastMessageAtMs.value
          : this.lastMessageAtMs,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
      cachedAtMs: data.cachedAtMs.present
          ? data.cachedAtMs.value
          : this.cachedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationTilesTableData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('companionId: $companionId, ')
          ..write('companionUsername: $companionUsername, ')
          ..write('companionFirstName: $companionFirstName, ')
          ..write('companionLastName: $companionLastName, ')
          ..write('companionAvatarId: $companionAvatarId, ')
          ..write('lastMessageText: $lastMessageText, ')
          ..write('lastMessageSenderId: $lastMessageSenderId, ')
          ..write('lastMessageAtMs: $lastMessageAtMs, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('cachedAtMs: $cachedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    title,
    description,
    companionId,
    companionUsername,
    companionFirstName,
    companionLastName,
    companionAvatarId,
    lastMessageText,
    lastMessageSenderId,
    lastMessageAtMs,
    updatedAtMs,
    cachedAtMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationTilesTableData &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.description == this.description &&
          other.companionId == this.companionId &&
          other.companionUsername == this.companionUsername &&
          other.companionFirstName == this.companionFirstName &&
          other.companionLastName == this.companionLastName &&
          other.companionAvatarId == this.companionAvatarId &&
          other.lastMessageText == this.lastMessageText &&
          other.lastMessageSenderId == this.lastMessageSenderId &&
          other.lastMessageAtMs == this.lastMessageAtMs &&
          other.updatedAtMs == this.updatedAtMs &&
          other.cachedAtMs == this.cachedAtMs);
}

class ConversationTilesTableCompanion
    extends UpdateCompanion<ConversationTilesTableData> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> companionId;
  final Value<String?> companionUsername;
  final Value<String?> companionFirstName;
  final Value<String?> companionLastName;
  final Value<String?> companionAvatarId;
  final Value<String?> lastMessageText;
  final Value<String?> lastMessageSenderId;
  final Value<int?> lastMessageAtMs;
  final Value<int> updatedAtMs;
  final Value<int> cachedAtMs;
  final Value<int> rowid;
  const ConversationTilesTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.companionId = const Value.absent(),
    this.companionUsername = const Value.absent(),
    this.companionFirstName = const Value.absent(),
    this.companionLastName = const Value.absent(),
    this.companionAvatarId = const Value.absent(),
    this.lastMessageText = const Value.absent(),
    this.lastMessageSenderId = const Value.absent(),
    this.lastMessageAtMs = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.cachedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationTilesTableCompanion.insert({
    required String id,
    required String type,
    required String title,
    this.description = const Value.absent(),
    this.companionId = const Value.absent(),
    this.companionUsername = const Value.absent(),
    this.companionFirstName = const Value.absent(),
    this.companionLastName = const Value.absent(),
    this.companionAvatarId = const Value.absent(),
    this.lastMessageText = const Value.absent(),
    this.lastMessageSenderId = const Value.absent(),
    this.lastMessageAtMs = const Value.absent(),
    required int updatedAtMs,
    required int cachedAtMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       title = Value(title),
       updatedAtMs = Value(updatedAtMs),
       cachedAtMs = Value(cachedAtMs);
  static Insertable<ConversationTilesTableData> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? companionId,
    Expression<String>? companionUsername,
    Expression<String>? companionFirstName,
    Expression<String>? companionLastName,
    Expression<String>? companionAvatarId,
    Expression<String>? lastMessageText,
    Expression<String>? lastMessageSenderId,
    Expression<int>? lastMessageAtMs,
    Expression<int>? updatedAtMs,
    Expression<int>? cachedAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (companionId != null) 'companion_id': companionId,
      if (companionUsername != null) 'companion_username': companionUsername,
      if (companionFirstName != null)
        'companion_first_name': companionFirstName,
      if (companionLastName != null) 'companion_last_name': companionLastName,
      if (companionAvatarId != null) 'companion_avatar_id': companionAvatarId,
      if (lastMessageText != null) 'last_message_text': lastMessageText,
      if (lastMessageSenderId != null)
        'last_message_sender_id': lastMessageSenderId,
      if (lastMessageAtMs != null) 'last_message_at_ms': lastMessageAtMs,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (cachedAtMs != null) 'cached_at_ms': cachedAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationTilesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? companionId,
    Value<String?>? companionUsername,
    Value<String?>? companionFirstName,
    Value<String?>? companionLastName,
    Value<String?>? companionAvatarId,
    Value<String?>? lastMessageText,
    Value<String?>? lastMessageSenderId,
    Value<int?>? lastMessageAtMs,
    Value<int>? updatedAtMs,
    Value<int>? cachedAtMs,
    Value<int>? rowid,
  }) {
    return ConversationTilesTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      companionId: companionId ?? this.companionId,
      companionUsername: companionUsername ?? this.companionUsername,
      companionFirstName: companionFirstName ?? this.companionFirstName,
      companionLastName: companionLastName ?? this.companionLastName,
      companionAvatarId: companionAvatarId ?? this.companionAvatarId,
      lastMessageText: lastMessageText ?? this.lastMessageText,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      lastMessageAtMs: lastMessageAtMs ?? this.lastMessageAtMs,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      cachedAtMs: cachedAtMs ?? this.cachedAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (companionId.present) {
      map['companion_id'] = Variable<String>(companionId.value);
    }
    if (companionUsername.present) {
      map['companion_username'] = Variable<String>(companionUsername.value);
    }
    if (companionFirstName.present) {
      map['companion_first_name'] = Variable<String>(companionFirstName.value);
    }
    if (companionLastName.present) {
      map['companion_last_name'] = Variable<String>(companionLastName.value);
    }
    if (companionAvatarId.present) {
      map['companion_avatar_id'] = Variable<String>(companionAvatarId.value);
    }
    if (lastMessageText.present) {
      map['last_message_text'] = Variable<String>(lastMessageText.value);
    }
    if (lastMessageSenderId.present) {
      map['last_message_sender_id'] = Variable<String>(
        lastMessageSenderId.value,
      );
    }
    if (lastMessageAtMs.present) {
      map['last_message_at_ms'] = Variable<int>(lastMessageAtMs.value);
    }
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
    }
    if (cachedAtMs.present) {
      map['cached_at_ms'] = Variable<int>(cachedAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationTilesTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('companionId: $companionId, ')
          ..write('companionUsername: $companionUsername, ')
          ..write('companionFirstName: $companionFirstName, ')
          ..write('companionLastName: $companionLastName, ')
          ..write('companionAvatarId: $companionAvatarId, ')
          ..write('lastMessageText: $lastMessageText, ')
          ..write('lastMessageSenderId: $lastMessageSenderId, ')
          ..write('lastMessageAtMs: $lastMessageAtMs, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('cachedAtMs: $cachedAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrivateMessagesTableTable extends PrivateMessagesTable
    with TableInfo<$PrivateMessagesTableTable, PrivateMessagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrivateMessagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientMessageIdMeta = const VerificationMeta(
    'clientMessageId',
  );
  @override
  late final GeneratedColumn<String> clientMessageId = GeneratedColumn<String>(
    'client_message_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderIdMeta = const VerificationMeta(
    'senderId',
  );
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
    'sender_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageTextMeta = const VerificationMeta(
    'messageText',
  );
  @override
  late final GeneratedColumn<String> messageText = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deliveryStatusMeta = const VerificationMeta(
    'deliveryStatus',
  );
  @override
  late final GeneratedColumn<String> deliveryStatus = GeneratedColumn<String>(
    'delivery_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _replyToMessageIdMeta = const VerificationMeta(
    'replyToMessageId',
  );
  @override
  late final GeneratedColumn<String> replyToMessageId = GeneratedColumn<String>(
    'reply_to_message_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedByIdMeta = const VerificationMeta(
    'deletedById',
  );
  @override
  late final GeneratedColumn<String> deletedById = GeneratedColumn<String>(
    'deleted_by_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMsMeta = const VerificationMeta(
    'createdAtMs',
  );
  @override
  late final GeneratedColumn<int> createdAtMs = GeneratedColumn<int>(
    'created_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _editedAtMsMeta = const VerificationMeta(
    'editedAtMs',
  );
  @override
  late final GeneratedColumn<int> editedAtMs = GeneratedColumn<int>(
    'edited_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readAtMsMeta = const VerificationMeta(
    'readAtMs',
  );
  @override
  late final GeneratedColumn<int> readAtMs = GeneratedColumn<int>(
    'read_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMsMeta = const VerificationMeta(
    'cachedAtMs',
  );
  @override
  late final GeneratedColumn<int> cachedAtMs = GeneratedColumn<int>(
    'cached_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientMessageId,
    conversationId,
    senderId,
    messageText,
    deliveryStatus,
    replyToMessageId,
    isDeleted,
    deletedById,
    isPinned,
    createdAtMs,
    updatedAtMs,
    editedAtMs,
    readAtMs,
    cachedAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'private_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrivateMessagesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_message_id')) {
      context.handle(
        _clientMessageIdMeta,
        clientMessageId.isAcceptableOrUnknown(
          data['client_message_id']!,
          _clientMessageIdMeta,
        ),
      );
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(
        _senderIdMeta,
        senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _messageTextMeta,
        messageText.isAcceptableOrUnknown(data['text']!, _messageTextMeta),
      );
    } else if (isInserting) {
      context.missing(_messageTextMeta);
    }
    if (data.containsKey('delivery_status')) {
      context.handle(
        _deliveryStatusMeta,
        deliveryStatus.isAcceptableOrUnknown(
          data['delivery_status']!,
          _deliveryStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deliveryStatusMeta);
    }
    if (data.containsKey('reply_to_message_id')) {
      context.handle(
        _replyToMessageIdMeta,
        replyToMessageId.isAcceptableOrUnknown(
          data['reply_to_message_id']!,
          _replyToMessageIdMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_by_id')) {
      context.handle(
        _deletedByIdMeta,
        deletedById.isAcceptableOrUnknown(
          data['deleted_by_id']!,
          _deletedByIdMeta,
        ),
      );
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    if (data.containsKey('created_at_ms')) {
      context.handle(
        _createdAtMsMeta,
        createdAtMs.isAcceptableOrUnknown(
          data['created_at_ms']!,
          _createdAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMsMeta);
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMsMeta);
    }
    if (data.containsKey('edited_at_ms')) {
      context.handle(
        _editedAtMsMeta,
        editedAtMs.isAcceptableOrUnknown(
          data['edited_at_ms']!,
          _editedAtMsMeta,
        ),
      );
    }
    if (data.containsKey('read_at_ms')) {
      context.handle(
        _readAtMsMeta,
        readAtMs.isAcceptableOrUnknown(data['read_at_ms']!, _readAtMsMeta),
      );
    }
    if (data.containsKey('cached_at_ms')) {
      context.handle(
        _cachedAtMsMeta,
        cachedAtMs.isAcceptableOrUnknown(
          data['cached_at_ms']!,
          _cachedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrivateMessagesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrivateMessagesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_message_id'],
      ),
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_id'],
      )!,
      messageText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      deliveryStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delivery_status'],
      )!,
      replyToMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_to_message_id'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedById: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_by_id'],
      ),
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
      createdAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_ms'],
      )!,
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
      )!,
      editedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}edited_at_ms'],
      ),
      readAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}read_at_ms'],
      ),
      cachedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cached_at_ms'],
      )!,
    );
  }

  @override
  $PrivateMessagesTableTable createAlias(String alias) {
    return $PrivateMessagesTableTable(attachedDatabase, alias);
  }
}

class PrivateMessagesTableData extends DataClass
    implements Insertable<PrivateMessagesTableData> {
  final String id;
  final String? clientMessageId;
  final String conversationId;
  final String senderId;
  final String messageText;
  final String deliveryStatus;
  final String? replyToMessageId;
  final bool isDeleted;
  final String? deletedById;
  final bool isPinned;
  final int createdAtMs;
  final int updatedAtMs;
  final int? editedAtMs;
  final int? readAtMs;
  final int cachedAtMs;
  const PrivateMessagesTableData({
    required this.id,
    this.clientMessageId,
    required this.conversationId,
    required this.senderId,
    required this.messageText,
    required this.deliveryStatus,
    this.replyToMessageId,
    required this.isDeleted,
    this.deletedById,
    required this.isPinned,
    required this.createdAtMs,
    required this.updatedAtMs,
    this.editedAtMs,
    this.readAtMs,
    required this.cachedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || clientMessageId != null) {
      map['client_message_id'] = Variable<String>(clientMessageId);
    }
    map['conversation_id'] = Variable<String>(conversationId);
    map['sender_id'] = Variable<String>(senderId);
    map['text'] = Variable<String>(messageText);
    map['delivery_status'] = Variable<String>(deliveryStatus);
    if (!nullToAbsent || replyToMessageId != null) {
      map['reply_to_message_id'] = Variable<String>(replyToMessageId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedById != null) {
      map['deleted_by_id'] = Variable<String>(deletedById);
    }
    map['is_pinned'] = Variable<bool>(isPinned);
    map['created_at_ms'] = Variable<int>(createdAtMs);
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    if (!nullToAbsent || editedAtMs != null) {
      map['edited_at_ms'] = Variable<int>(editedAtMs);
    }
    if (!nullToAbsent || readAtMs != null) {
      map['read_at_ms'] = Variable<int>(readAtMs);
    }
    map['cached_at_ms'] = Variable<int>(cachedAtMs);
    return map;
  }

  PrivateMessagesTableCompanion toCompanion(bool nullToAbsent) {
    return PrivateMessagesTableCompanion(
      id: Value(id),
      clientMessageId: clientMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientMessageId),
      conversationId: Value(conversationId),
      senderId: Value(senderId),
      messageText: Value(messageText),
      deliveryStatus: Value(deliveryStatus),
      replyToMessageId: replyToMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(replyToMessageId),
      isDeleted: Value(isDeleted),
      deletedById: deletedById == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedById),
      isPinned: Value(isPinned),
      createdAtMs: Value(createdAtMs),
      updatedAtMs: Value(updatedAtMs),
      editedAtMs: editedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(editedAtMs),
      readAtMs: readAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(readAtMs),
      cachedAtMs: Value(cachedAtMs),
    );
  }

  factory PrivateMessagesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrivateMessagesTableData(
      id: serializer.fromJson<String>(json['id']),
      clientMessageId: serializer.fromJson<String?>(json['clientMessageId']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      messageText: serializer.fromJson<String>(json['messageText']),
      deliveryStatus: serializer.fromJson<String>(json['deliveryStatus']),
      replyToMessageId: serializer.fromJson<String?>(json['replyToMessageId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedById: serializer.fromJson<String?>(json['deletedById']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      createdAtMs: serializer.fromJson<int>(json['createdAtMs']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
      editedAtMs: serializer.fromJson<int?>(json['editedAtMs']),
      readAtMs: serializer.fromJson<int?>(json['readAtMs']),
      cachedAtMs: serializer.fromJson<int>(json['cachedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientMessageId': serializer.toJson<String?>(clientMessageId),
      'conversationId': serializer.toJson<String>(conversationId),
      'senderId': serializer.toJson<String>(senderId),
      'messageText': serializer.toJson<String>(messageText),
      'deliveryStatus': serializer.toJson<String>(deliveryStatus),
      'replyToMessageId': serializer.toJson<String?>(replyToMessageId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedById': serializer.toJson<String?>(deletedById),
      'isPinned': serializer.toJson<bool>(isPinned),
      'createdAtMs': serializer.toJson<int>(createdAtMs),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
      'editedAtMs': serializer.toJson<int?>(editedAtMs),
      'readAtMs': serializer.toJson<int?>(readAtMs),
      'cachedAtMs': serializer.toJson<int>(cachedAtMs),
    };
  }

  PrivateMessagesTableData copyWith({
    String? id,
    Value<String?> clientMessageId = const Value.absent(),
    String? conversationId,
    String? senderId,
    String? messageText,
    String? deliveryStatus,
    Value<String?> replyToMessageId = const Value.absent(),
    bool? isDeleted,
    Value<String?> deletedById = const Value.absent(),
    bool? isPinned,
    int? createdAtMs,
    int? updatedAtMs,
    Value<int?> editedAtMs = const Value.absent(),
    Value<int?> readAtMs = const Value.absent(),
    int? cachedAtMs,
  }) => PrivateMessagesTableData(
    id: id ?? this.id,
    clientMessageId: clientMessageId.present
        ? clientMessageId.value
        : this.clientMessageId,
    conversationId: conversationId ?? this.conversationId,
    senderId: senderId ?? this.senderId,
    messageText: messageText ?? this.messageText,
    deliveryStatus: deliveryStatus ?? this.deliveryStatus,
    replyToMessageId: replyToMessageId.present
        ? replyToMessageId.value
        : this.replyToMessageId,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedById: deletedById.present ? deletedById.value : this.deletedById,
    isPinned: isPinned ?? this.isPinned,
    createdAtMs: createdAtMs ?? this.createdAtMs,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
    editedAtMs: editedAtMs.present ? editedAtMs.value : this.editedAtMs,
    readAtMs: readAtMs.present ? readAtMs.value : this.readAtMs,
    cachedAtMs: cachedAtMs ?? this.cachedAtMs,
  );
  PrivateMessagesTableData copyWithCompanion(
    PrivateMessagesTableCompanion data,
  ) {
    return PrivateMessagesTableData(
      id: data.id.present ? data.id.value : this.id,
      clientMessageId: data.clientMessageId.present
          ? data.clientMessageId.value
          : this.clientMessageId,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      messageText: data.messageText.present
          ? data.messageText.value
          : this.messageText,
      deliveryStatus: data.deliveryStatus.present
          ? data.deliveryStatus.value
          : this.deliveryStatus,
      replyToMessageId: data.replyToMessageId.present
          ? data.replyToMessageId.value
          : this.replyToMessageId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedById: data.deletedById.present
          ? data.deletedById.value
          : this.deletedById,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      createdAtMs: data.createdAtMs.present
          ? data.createdAtMs.value
          : this.createdAtMs,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
      editedAtMs: data.editedAtMs.present
          ? data.editedAtMs.value
          : this.editedAtMs,
      readAtMs: data.readAtMs.present ? data.readAtMs.value : this.readAtMs,
      cachedAtMs: data.cachedAtMs.present
          ? data.cachedAtMs.value
          : this.cachedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrivateMessagesTableData(')
          ..write('id: $id, ')
          ..write('clientMessageId: $clientMessageId, ')
          ..write('conversationId: $conversationId, ')
          ..write('senderId: $senderId, ')
          ..write('messageText: $messageText, ')
          ..write('deliveryStatus: $deliveryStatus, ')
          ..write('replyToMessageId: $replyToMessageId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedById: $deletedById, ')
          ..write('isPinned: $isPinned, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('editedAtMs: $editedAtMs, ')
          ..write('readAtMs: $readAtMs, ')
          ..write('cachedAtMs: $cachedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientMessageId,
    conversationId,
    senderId,
    messageText,
    deliveryStatus,
    replyToMessageId,
    isDeleted,
    deletedById,
    isPinned,
    createdAtMs,
    updatedAtMs,
    editedAtMs,
    readAtMs,
    cachedAtMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrivateMessagesTableData &&
          other.id == this.id &&
          other.clientMessageId == this.clientMessageId &&
          other.conversationId == this.conversationId &&
          other.senderId == this.senderId &&
          other.messageText == this.messageText &&
          other.deliveryStatus == this.deliveryStatus &&
          other.replyToMessageId == this.replyToMessageId &&
          other.isDeleted == this.isDeleted &&
          other.deletedById == this.deletedById &&
          other.isPinned == this.isPinned &&
          other.createdAtMs == this.createdAtMs &&
          other.updatedAtMs == this.updatedAtMs &&
          other.editedAtMs == this.editedAtMs &&
          other.readAtMs == this.readAtMs &&
          other.cachedAtMs == this.cachedAtMs);
}

class PrivateMessagesTableCompanion
    extends UpdateCompanion<PrivateMessagesTableData> {
  final Value<String> id;
  final Value<String?> clientMessageId;
  final Value<String> conversationId;
  final Value<String> senderId;
  final Value<String> messageText;
  final Value<String> deliveryStatus;
  final Value<String?> replyToMessageId;
  final Value<bool> isDeleted;
  final Value<String?> deletedById;
  final Value<bool> isPinned;
  final Value<int> createdAtMs;
  final Value<int> updatedAtMs;
  final Value<int?> editedAtMs;
  final Value<int?> readAtMs;
  final Value<int> cachedAtMs;
  final Value<int> rowid;
  const PrivateMessagesTableCompanion({
    this.id = const Value.absent(),
    this.clientMessageId = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.messageText = const Value.absent(),
    this.deliveryStatus = const Value.absent(),
    this.replyToMessageId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedById = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.editedAtMs = const Value.absent(),
    this.readAtMs = const Value.absent(),
    this.cachedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrivateMessagesTableCompanion.insert({
    required String id,
    this.clientMessageId = const Value.absent(),
    required String conversationId,
    required String senderId,
    required String messageText,
    required String deliveryStatus,
    this.replyToMessageId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedById = const Value.absent(),
    this.isPinned = const Value.absent(),
    required int createdAtMs,
    required int updatedAtMs,
    this.editedAtMs = const Value.absent(),
    this.readAtMs = const Value.absent(),
    required int cachedAtMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       conversationId = Value(conversationId),
       senderId = Value(senderId),
       messageText = Value(messageText),
       deliveryStatus = Value(deliveryStatus),
       createdAtMs = Value(createdAtMs),
       updatedAtMs = Value(updatedAtMs),
       cachedAtMs = Value(cachedAtMs);
  static Insertable<PrivateMessagesTableData> custom({
    Expression<String>? id,
    Expression<String>? clientMessageId,
    Expression<String>? conversationId,
    Expression<String>? senderId,
    Expression<String>? messageText,
    Expression<String>? deliveryStatus,
    Expression<String>? replyToMessageId,
    Expression<bool>? isDeleted,
    Expression<String>? deletedById,
    Expression<bool>? isPinned,
    Expression<int>? createdAtMs,
    Expression<int>? updatedAtMs,
    Expression<int>? editedAtMs,
    Expression<int>? readAtMs,
    Expression<int>? cachedAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientMessageId != null) 'client_message_id': clientMessageId,
      if (conversationId != null) 'conversation_id': conversationId,
      if (senderId != null) 'sender_id': senderId,
      if (messageText != null) 'text': messageText,
      if (deliveryStatus != null) 'delivery_status': deliveryStatus,
      if (replyToMessageId != null) 'reply_to_message_id': replyToMessageId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedById != null) 'deleted_by_id': deletedById,
      if (isPinned != null) 'is_pinned': isPinned,
      if (createdAtMs != null) 'created_at_ms': createdAtMs,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (editedAtMs != null) 'edited_at_ms': editedAtMs,
      if (readAtMs != null) 'read_at_ms': readAtMs,
      if (cachedAtMs != null) 'cached_at_ms': cachedAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrivateMessagesTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? clientMessageId,
    Value<String>? conversationId,
    Value<String>? senderId,
    Value<String>? messageText,
    Value<String>? deliveryStatus,
    Value<String?>? replyToMessageId,
    Value<bool>? isDeleted,
    Value<String?>? deletedById,
    Value<bool>? isPinned,
    Value<int>? createdAtMs,
    Value<int>? updatedAtMs,
    Value<int?>? editedAtMs,
    Value<int?>? readAtMs,
    Value<int>? cachedAtMs,
    Value<int>? rowid,
  }) {
    return PrivateMessagesTableCompanion(
      id: id ?? this.id,
      clientMessageId: clientMessageId ?? this.clientMessageId,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      messageText: messageText ?? this.messageText,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedById: deletedById ?? this.deletedById,
      isPinned: isPinned ?? this.isPinned,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      editedAtMs: editedAtMs ?? this.editedAtMs,
      readAtMs: readAtMs ?? this.readAtMs,
      cachedAtMs: cachedAtMs ?? this.cachedAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientMessageId.present) {
      map['client_message_id'] = Variable<String>(clientMessageId.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (messageText.present) {
      map['text'] = Variable<String>(messageText.value);
    }
    if (deliveryStatus.present) {
      map['delivery_status'] = Variable<String>(deliveryStatus.value);
    }
    if (replyToMessageId.present) {
      map['reply_to_message_id'] = Variable<String>(replyToMessageId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedById.present) {
      map['deleted_by_id'] = Variable<String>(deletedById.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (createdAtMs.present) {
      map['created_at_ms'] = Variable<int>(createdAtMs.value);
    }
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
    }
    if (editedAtMs.present) {
      map['edited_at_ms'] = Variable<int>(editedAtMs.value);
    }
    if (readAtMs.present) {
      map['read_at_ms'] = Variable<int>(readAtMs.value);
    }
    if (cachedAtMs.present) {
      map['cached_at_ms'] = Variable<int>(cachedAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrivateMessagesTableCompanion(')
          ..write('id: $id, ')
          ..write('clientMessageId: $clientMessageId, ')
          ..write('conversationId: $conversationId, ')
          ..write('senderId: $senderId, ')
          ..write('messageText: $messageText, ')
          ..write('deliveryStatus: $deliveryStatus, ')
          ..write('replyToMessageId: $replyToMessageId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedById: $deletedById, ')
          ..write('isPinned: $isPinned, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('editedAtMs: $editedAtMs, ')
          ..write('readAtMs: $readAtMs, ')
          ..write('cachedAtMs: $cachedAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrivateMessageAttachmentsTableTable
    extends PrivateMessageAttachmentsTable
    with
        TableInfo<
          $PrivateMessageAttachmentsTableTable,
          PrivateMessageAttachmentsTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrivateMessageAttachmentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileIdMeta = const VerificationMeta('fileId');
  @override
  late final GeneratedColumn<String> fileId = GeneratedColumn<String>(
    'file_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileTypeMeta = const VerificationMeta(
    'fileType',
  );
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
    'file_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMsMeta = const VerificationMeta(
    'createdAtMs',
  );
  @override
  late final GeneratedColumn<int> createdAtMs = GeneratedColumn<int>(
    'created_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    messageId,
    fileId,
    fileType,
    order,
    createdAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'private_message_attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrivateMessageAttachmentsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('file_id')) {
      context.handle(
        _fileIdMeta,
        fileId.isAcceptableOrUnknown(data['file_id']!, _fileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fileIdMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(
        _fileTypeMeta,
        fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta),
      );
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('created_at_ms')) {
      context.handle(
        _createdAtMsMeta,
        createdAtMs.isAcceptableOrUnknown(
          data['created_at_ms']!,
          _createdAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrivateMessageAttachmentsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrivateMessageAttachmentsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      )!,
      fileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_id'],
      )!,
      fileType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_type'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      createdAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_ms'],
      )!,
    );
  }

  @override
  $PrivateMessageAttachmentsTableTable createAlias(String alias) {
    return $PrivateMessageAttachmentsTableTable(attachedDatabase, alias);
  }
}

class PrivateMessageAttachmentsTableData extends DataClass
    implements Insertable<PrivateMessageAttachmentsTableData> {
  final String id;
  final String messageId;
  final String fileId;
  final String? fileType;
  final int order;
  final int createdAtMs;
  const PrivateMessageAttachmentsTableData({
    required this.id,
    required this.messageId,
    required this.fileId,
    this.fileType,
    required this.order,
    required this.createdAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['message_id'] = Variable<String>(messageId);
    map['file_id'] = Variable<String>(fileId);
    if (!nullToAbsent || fileType != null) {
      map['file_type'] = Variable<String>(fileType);
    }
    map['order'] = Variable<int>(order);
    map['created_at_ms'] = Variable<int>(createdAtMs);
    return map;
  }

  PrivateMessageAttachmentsTableCompanion toCompanion(bool nullToAbsent) {
    return PrivateMessageAttachmentsTableCompanion(
      id: Value(id),
      messageId: Value(messageId),
      fileId: Value(fileId),
      fileType: fileType == null && nullToAbsent
          ? const Value.absent()
          : Value(fileType),
      order: Value(order),
      createdAtMs: Value(createdAtMs),
    );
  }

  factory PrivateMessageAttachmentsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrivateMessageAttachmentsTableData(
      id: serializer.fromJson<String>(json['id']),
      messageId: serializer.fromJson<String>(json['messageId']),
      fileId: serializer.fromJson<String>(json['fileId']),
      fileType: serializer.fromJson<String?>(json['fileType']),
      order: serializer.fromJson<int>(json['order']),
      createdAtMs: serializer.fromJson<int>(json['createdAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageId': serializer.toJson<String>(messageId),
      'fileId': serializer.toJson<String>(fileId),
      'fileType': serializer.toJson<String?>(fileType),
      'order': serializer.toJson<int>(order),
      'createdAtMs': serializer.toJson<int>(createdAtMs),
    };
  }

  PrivateMessageAttachmentsTableData copyWith({
    String? id,
    String? messageId,
    String? fileId,
    Value<String?> fileType = const Value.absent(),
    int? order,
    int? createdAtMs,
  }) => PrivateMessageAttachmentsTableData(
    id: id ?? this.id,
    messageId: messageId ?? this.messageId,
    fileId: fileId ?? this.fileId,
    fileType: fileType.present ? fileType.value : this.fileType,
    order: order ?? this.order,
    createdAtMs: createdAtMs ?? this.createdAtMs,
  );
  PrivateMessageAttachmentsTableData copyWithCompanion(
    PrivateMessageAttachmentsTableCompanion data,
  ) {
    return PrivateMessageAttachmentsTableData(
      id: data.id.present ? data.id.value : this.id,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      fileId: data.fileId.present ? data.fileId.value : this.fileId,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      order: data.order.present ? data.order.value : this.order,
      createdAtMs: data.createdAtMs.present
          ? data.createdAtMs.value
          : this.createdAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrivateMessageAttachmentsTableData(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('fileId: $fileId, ')
          ..write('fileType: $fileType, ')
          ..write('order: $order, ')
          ..write('createdAtMs: $createdAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, messageId, fileId, fileType, order, createdAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrivateMessageAttachmentsTableData &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.fileId == this.fileId &&
          other.fileType == this.fileType &&
          other.order == this.order &&
          other.createdAtMs == this.createdAtMs);
}

class PrivateMessageAttachmentsTableCompanion
    extends UpdateCompanion<PrivateMessageAttachmentsTableData> {
  final Value<String> id;
  final Value<String> messageId;
  final Value<String> fileId;
  final Value<String?> fileType;
  final Value<int> order;
  final Value<int> createdAtMs;
  final Value<int> rowid;
  const PrivateMessageAttachmentsTableCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.fileId = const Value.absent(),
    this.fileType = const Value.absent(),
    this.order = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrivateMessageAttachmentsTableCompanion.insert({
    required String id,
    required String messageId,
    required String fileId,
    this.fileType = const Value.absent(),
    required int order,
    required int createdAtMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       messageId = Value(messageId),
       fileId = Value(fileId),
       order = Value(order),
       createdAtMs = Value(createdAtMs);
  static Insertable<PrivateMessageAttachmentsTableData> custom({
    Expression<String>? id,
    Expression<String>? messageId,
    Expression<String>? fileId,
    Expression<String>? fileType,
    Expression<int>? order,
    Expression<int>? createdAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (fileId != null) 'file_id': fileId,
      if (fileType != null) 'file_type': fileType,
      if (order != null) 'order': order,
      if (createdAtMs != null) 'created_at_ms': createdAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrivateMessageAttachmentsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? messageId,
    Value<String>? fileId,
    Value<String?>? fileType,
    Value<int>? order,
    Value<int>? createdAtMs,
    Value<int>? rowid,
  }) {
    return PrivateMessageAttachmentsTableCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      fileId: fileId ?? this.fileId,
      fileType: fileType ?? this.fileType,
      order: order ?? this.order,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (fileId.present) {
      map['file_id'] = Variable<String>(fileId.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (createdAtMs.present) {
      map['created_at_ms'] = Variable<int>(createdAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrivateMessageAttachmentsTableCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('fileId: $fileId, ')
          ..write('fileType: $fileType, ')
          ..write('order: $order, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaDownloadCacheTableTable extends MediaDownloadCacheTable
    with TableInfo<$MediaDownloadCacheTableTable, MediaDownloadCacheTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaDownloadCacheTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<String> mediaId = GeneratedColumn<String>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _downloadUrlMeta = const VerificationMeta(
    'downloadUrl',
  );
  @override
  late final GeneratedColumn<String> downloadUrl = GeneratedColumn<String>(
    'download_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeIdMeta = const VerificationMeta(
    'scopeId',
  );
  @override
  late final GeneratedColumn<String> scopeId = GeneratedColumn<String>(
    'scope_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<String> ownerUserId = GeneratedColumn<String>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMsMeta = const VerificationMeta(
    'expiresAtMs',
  );
  @override
  late final GeneratedColumn<int> expiresAtMs = GeneratedColumn<int>(
    'expires_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMsMeta = const VerificationMeta(
    'cachedAtMs',
  );
  @override
  late final GeneratedColumn<int> cachedAtMs = GeneratedColumn<int>(
    'cached_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    mediaId,
    downloadUrl,
    mimeType,
    sizeBytes,
    status,
    scope,
    scopeId,
    ownerUserId,
    expiresAtMs,
    cachedAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_download_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaDownloadCacheTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('download_url')) {
      context.handle(
        _downloadUrlMeta,
        downloadUrl.isAcceptableOrUnknown(
          data['download_url']!,
          _downloadUrlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downloadUrlMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('scope_id')) {
      context.handle(
        _scopeIdMeta,
        scopeId.isAcceptableOrUnknown(data['scope_id']!, _scopeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeIdMeta);
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('expires_at_ms')) {
      context.handle(
        _expiresAtMsMeta,
        expiresAtMs.isAcceptableOrUnknown(
          data['expires_at_ms']!,
          _expiresAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMsMeta);
    }
    if (data.containsKey('cached_at_ms')) {
      context.handle(
        _cachedAtMsMeta,
        cachedAtMs.isAcceptableOrUnknown(
          data['cached_at_ms']!,
          _cachedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mediaId};
  @override
  MediaDownloadCacheTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaDownloadCacheTableData(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_id'],
      )!,
      downloadUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}download_url'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      )!,
      scopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope_id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_user_id'],
      )!,
      expiresAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expires_at_ms'],
      )!,
      cachedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cached_at_ms'],
      )!,
    );
  }

  @override
  $MediaDownloadCacheTableTable createAlias(String alias) {
    return $MediaDownloadCacheTableTable(attachedDatabase, alias);
  }
}

class MediaDownloadCacheTableData extends DataClass
    implements Insertable<MediaDownloadCacheTableData> {
  final String mediaId;
  final String downloadUrl;
  final String mimeType;
  final int sizeBytes;
  final String status;
  final String scope;
  final String scopeId;
  final String ownerUserId;
  final int expiresAtMs;
  final int cachedAtMs;
  const MediaDownloadCacheTableData({
    required this.mediaId,
    required this.downloadUrl,
    required this.mimeType,
    required this.sizeBytes,
    required this.status,
    required this.scope,
    required this.scopeId,
    required this.ownerUserId,
    required this.expiresAtMs,
    required this.cachedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<String>(mediaId);
    map['download_url'] = Variable<String>(downloadUrl);
    map['mime_type'] = Variable<String>(mimeType);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['status'] = Variable<String>(status);
    map['scope'] = Variable<String>(scope);
    map['scope_id'] = Variable<String>(scopeId);
    map['owner_user_id'] = Variable<String>(ownerUserId);
    map['expires_at_ms'] = Variable<int>(expiresAtMs);
    map['cached_at_ms'] = Variable<int>(cachedAtMs);
    return map;
  }

  MediaDownloadCacheTableCompanion toCompanion(bool nullToAbsent) {
    return MediaDownloadCacheTableCompanion(
      mediaId: Value(mediaId),
      downloadUrl: Value(downloadUrl),
      mimeType: Value(mimeType),
      sizeBytes: Value(sizeBytes),
      status: Value(status),
      scope: Value(scope),
      scopeId: Value(scopeId),
      ownerUserId: Value(ownerUserId),
      expiresAtMs: Value(expiresAtMs),
      cachedAtMs: Value(cachedAtMs),
    );
  }

  factory MediaDownloadCacheTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaDownloadCacheTableData(
      mediaId: serializer.fromJson<String>(json['mediaId']),
      downloadUrl: serializer.fromJson<String>(json['downloadUrl']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      status: serializer.fromJson<String>(json['status']),
      scope: serializer.fromJson<String>(json['scope']),
      scopeId: serializer.fromJson<String>(json['scopeId']),
      ownerUserId: serializer.fromJson<String>(json['ownerUserId']),
      expiresAtMs: serializer.fromJson<int>(json['expiresAtMs']),
      cachedAtMs: serializer.fromJson<int>(json['cachedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<String>(mediaId),
      'downloadUrl': serializer.toJson<String>(downloadUrl),
      'mimeType': serializer.toJson<String>(mimeType),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'status': serializer.toJson<String>(status),
      'scope': serializer.toJson<String>(scope),
      'scopeId': serializer.toJson<String>(scopeId),
      'ownerUserId': serializer.toJson<String>(ownerUserId),
      'expiresAtMs': serializer.toJson<int>(expiresAtMs),
      'cachedAtMs': serializer.toJson<int>(cachedAtMs),
    };
  }

  MediaDownloadCacheTableData copyWith({
    String? mediaId,
    String? downloadUrl,
    String? mimeType,
    int? sizeBytes,
    String? status,
    String? scope,
    String? scopeId,
    String? ownerUserId,
    int? expiresAtMs,
    int? cachedAtMs,
  }) => MediaDownloadCacheTableData(
    mediaId: mediaId ?? this.mediaId,
    downloadUrl: downloadUrl ?? this.downloadUrl,
    mimeType: mimeType ?? this.mimeType,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    status: status ?? this.status,
    scope: scope ?? this.scope,
    scopeId: scopeId ?? this.scopeId,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    expiresAtMs: expiresAtMs ?? this.expiresAtMs,
    cachedAtMs: cachedAtMs ?? this.cachedAtMs,
  );
  MediaDownloadCacheTableData copyWithCompanion(
    MediaDownloadCacheTableCompanion data,
  ) {
    return MediaDownloadCacheTableData(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      downloadUrl: data.downloadUrl.present
          ? data.downloadUrl.value
          : this.downloadUrl,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      status: data.status.present ? data.status.value : this.status,
      scope: data.scope.present ? data.scope.value : this.scope,
      scopeId: data.scopeId.present ? data.scopeId.value : this.scopeId,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      expiresAtMs: data.expiresAtMs.present
          ? data.expiresAtMs.value
          : this.expiresAtMs,
      cachedAtMs: data.cachedAtMs.present
          ? data.cachedAtMs.value
          : this.cachedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaDownloadCacheTableData(')
          ..write('mediaId: $mediaId, ')
          ..write('downloadUrl: $downloadUrl, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('status: $status, ')
          ..write('scope: $scope, ')
          ..write('scopeId: $scopeId, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('expiresAtMs: $expiresAtMs, ')
          ..write('cachedAtMs: $cachedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    mediaId,
    downloadUrl,
    mimeType,
    sizeBytes,
    status,
    scope,
    scopeId,
    ownerUserId,
    expiresAtMs,
    cachedAtMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaDownloadCacheTableData &&
          other.mediaId == this.mediaId &&
          other.downloadUrl == this.downloadUrl &&
          other.mimeType == this.mimeType &&
          other.sizeBytes == this.sizeBytes &&
          other.status == this.status &&
          other.scope == this.scope &&
          other.scopeId == this.scopeId &&
          other.ownerUserId == this.ownerUserId &&
          other.expiresAtMs == this.expiresAtMs &&
          other.cachedAtMs == this.cachedAtMs);
}

class MediaDownloadCacheTableCompanion
    extends UpdateCompanion<MediaDownloadCacheTableData> {
  final Value<String> mediaId;
  final Value<String> downloadUrl;
  final Value<String> mimeType;
  final Value<int> sizeBytes;
  final Value<String> status;
  final Value<String> scope;
  final Value<String> scopeId;
  final Value<String> ownerUserId;
  final Value<int> expiresAtMs;
  final Value<int> cachedAtMs;
  final Value<int> rowid;
  const MediaDownloadCacheTableCompanion({
    this.mediaId = const Value.absent(),
    this.downloadUrl = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.status = const Value.absent(),
    this.scope = const Value.absent(),
    this.scopeId = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.expiresAtMs = const Value.absent(),
    this.cachedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaDownloadCacheTableCompanion.insert({
    required String mediaId,
    required String downloadUrl,
    required String mimeType,
    required int sizeBytes,
    required String status,
    required String scope,
    required String scopeId,
    required String ownerUserId,
    required int expiresAtMs,
    required int cachedAtMs,
    this.rowid = const Value.absent(),
  }) : mediaId = Value(mediaId),
       downloadUrl = Value(downloadUrl),
       mimeType = Value(mimeType),
       sizeBytes = Value(sizeBytes),
       status = Value(status),
       scope = Value(scope),
       scopeId = Value(scopeId),
       ownerUserId = Value(ownerUserId),
       expiresAtMs = Value(expiresAtMs),
       cachedAtMs = Value(cachedAtMs);
  static Insertable<MediaDownloadCacheTableData> custom({
    Expression<String>? mediaId,
    Expression<String>? downloadUrl,
    Expression<String>? mimeType,
    Expression<int>? sizeBytes,
    Expression<String>? status,
    Expression<String>? scope,
    Expression<String>? scopeId,
    Expression<String>? ownerUserId,
    Expression<int>? expiresAtMs,
    Expression<int>? cachedAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (downloadUrl != null) 'download_url': downloadUrl,
      if (mimeType != null) 'mime_type': mimeType,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (status != null) 'status': status,
      if (scope != null) 'scope': scope,
      if (scopeId != null) 'scope_id': scopeId,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (expiresAtMs != null) 'expires_at_ms': expiresAtMs,
      if (cachedAtMs != null) 'cached_at_ms': cachedAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaDownloadCacheTableCompanion copyWith({
    Value<String>? mediaId,
    Value<String>? downloadUrl,
    Value<String>? mimeType,
    Value<int>? sizeBytes,
    Value<String>? status,
    Value<String>? scope,
    Value<String>? scopeId,
    Value<String>? ownerUserId,
    Value<int>? expiresAtMs,
    Value<int>? cachedAtMs,
    Value<int>? rowid,
  }) {
    return MediaDownloadCacheTableCompanion(
      mediaId: mediaId ?? this.mediaId,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      status: status ?? this.status,
      scope: scope ?? this.scope,
      scopeId: scopeId ?? this.scopeId,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      expiresAtMs: expiresAtMs ?? this.expiresAtMs,
      cachedAtMs: cachedAtMs ?? this.cachedAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<String>(mediaId.value);
    }
    if (downloadUrl.present) {
      map['download_url'] = Variable<String>(downloadUrl.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (scopeId.present) {
      map['scope_id'] = Variable<String>(scopeId.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<String>(ownerUserId.value);
    }
    if (expiresAtMs.present) {
      map['expires_at_ms'] = Variable<int>(expiresAtMs.value);
    }
    if (cachedAtMs.present) {
      map['cached_at_ms'] = Variable<int>(cachedAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaDownloadCacheTableCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('downloadUrl: $downloadUrl, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('status: $status, ')
          ..write('scope: $scope, ')
          ..write('scopeId: $scopeId, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('expiresAtMs: $expiresAtMs, ')
          ..write('cachedAtMs: $cachedAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ConversationTilesTableTable conversationTilesTable =
      $ConversationTilesTableTable(this);
  late final $PrivateMessagesTableTable privateMessagesTable =
      $PrivateMessagesTableTable(this);
  late final $PrivateMessageAttachmentsTableTable
  privateMessageAttachmentsTable = $PrivateMessageAttachmentsTableTable(this);
  late final $MediaDownloadCacheTableTable mediaDownloadCacheTable =
      $MediaDownloadCacheTableTable(this);
  late final ConversationTilesDao conversationTilesDao = ConversationTilesDao(
    this as AppDatabase,
  );
  late final PrivateMessagesDao privateMessagesDao = PrivateMessagesDao(
    this as AppDatabase,
  );
  late final MediaDownloadCacheDao mediaDownloadCacheDao =
      MediaDownloadCacheDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    conversationTilesTable,
    privateMessagesTable,
    privateMessageAttachmentsTable,
    mediaDownloadCacheTable,
  ];
}

typedef $$ConversationTilesTableTableCreateCompanionBuilder =
    ConversationTilesTableCompanion Function({
      required String id,
      required String type,
      required String title,
      Value<String?> description,
      Value<String?> companionId,
      Value<String?> companionUsername,
      Value<String?> companionFirstName,
      Value<String?> companionLastName,
      Value<String?> companionAvatarId,
      Value<String?> lastMessageText,
      Value<String?> lastMessageSenderId,
      Value<int?> lastMessageAtMs,
      required int updatedAtMs,
      required int cachedAtMs,
      Value<int> rowid,
    });
typedef $$ConversationTilesTableTableUpdateCompanionBuilder =
    ConversationTilesTableCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> title,
      Value<String?> description,
      Value<String?> companionId,
      Value<String?> companionUsername,
      Value<String?> companionFirstName,
      Value<String?> companionLastName,
      Value<String?> companionAvatarId,
      Value<String?> lastMessageText,
      Value<String?> lastMessageSenderId,
      Value<int?> lastMessageAtMs,
      Value<int> updatedAtMs,
      Value<int> cachedAtMs,
      Value<int> rowid,
    });

class $$ConversationTilesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ConversationTilesTableTable> {
  $$ConversationTilesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companionId => $composableBuilder(
    column: $table.companionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companionUsername => $composableBuilder(
    column: $table.companionUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companionFirstName => $composableBuilder(
    column: $table.companionFirstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companionLastName => $composableBuilder(
    column: $table.companionLastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companionAvatarId => $composableBuilder(
    column: $table.companionAvatarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastMessageText => $composableBuilder(
    column: $table.lastMessageText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastMessageSenderId => $composableBuilder(
    column: $table.lastMessageSenderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastMessageAtMs => $composableBuilder(
    column: $table.lastMessageAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cachedAtMs => $composableBuilder(
    column: $table.cachedAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConversationTilesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ConversationTilesTableTable> {
  $$ConversationTilesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companionId => $composableBuilder(
    column: $table.companionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companionUsername => $composableBuilder(
    column: $table.companionUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companionFirstName => $composableBuilder(
    column: $table.companionFirstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companionLastName => $composableBuilder(
    column: $table.companionLastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companionAvatarId => $composableBuilder(
    column: $table.companionAvatarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastMessageText => $composableBuilder(
    column: $table.lastMessageText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastMessageSenderId => $composableBuilder(
    column: $table.lastMessageSenderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastMessageAtMs => $composableBuilder(
    column: $table.lastMessageAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cachedAtMs => $composableBuilder(
    column: $table.cachedAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConversationTilesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConversationTilesTableTable> {
  $$ConversationTilesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companionId => $composableBuilder(
    column: $table.companionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companionUsername => $composableBuilder(
    column: $table.companionUsername,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companionFirstName => $composableBuilder(
    column: $table.companionFirstName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companionLastName => $composableBuilder(
    column: $table.companionLastName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companionAvatarId => $composableBuilder(
    column: $table.companionAvatarId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastMessageText => $composableBuilder(
    column: $table.lastMessageText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastMessageSenderId => $composableBuilder(
    column: $table.lastMessageSenderId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastMessageAtMs => $composableBuilder(
    column: $table.lastMessageAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cachedAtMs => $composableBuilder(
    column: $table.cachedAtMs,
    builder: (column) => column,
  );
}

class $$ConversationTilesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConversationTilesTableTable,
          ConversationTilesTableData,
          $$ConversationTilesTableTableFilterComposer,
          $$ConversationTilesTableTableOrderingComposer,
          $$ConversationTilesTableTableAnnotationComposer,
          $$ConversationTilesTableTableCreateCompanionBuilder,
          $$ConversationTilesTableTableUpdateCompanionBuilder,
          (
            ConversationTilesTableData,
            BaseReferences<
              _$AppDatabase,
              $ConversationTilesTableTable,
              ConversationTilesTableData
            >,
          ),
          ConversationTilesTableData,
          PrefetchHooks Function()
        > {
  $$ConversationTilesTableTableTableManager(
    _$AppDatabase db,
    $ConversationTilesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversationTilesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ConversationTilesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ConversationTilesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> companionId = const Value.absent(),
                Value<String?> companionUsername = const Value.absent(),
                Value<String?> companionFirstName = const Value.absent(),
                Value<String?> companionLastName = const Value.absent(),
                Value<String?> companionAvatarId = const Value.absent(),
                Value<String?> lastMessageText = const Value.absent(),
                Value<String?> lastMessageSenderId = const Value.absent(),
                Value<int?> lastMessageAtMs = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<int> cachedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversationTilesTableCompanion(
                id: id,
                type: type,
                title: title,
                description: description,
                companionId: companionId,
                companionUsername: companionUsername,
                companionFirstName: companionFirstName,
                companionLastName: companionLastName,
                companionAvatarId: companionAvatarId,
                lastMessageText: lastMessageText,
                lastMessageSenderId: lastMessageSenderId,
                lastMessageAtMs: lastMessageAtMs,
                updatedAtMs: updatedAtMs,
                cachedAtMs: cachedAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> companionId = const Value.absent(),
                Value<String?> companionUsername = const Value.absent(),
                Value<String?> companionFirstName = const Value.absent(),
                Value<String?> companionLastName = const Value.absent(),
                Value<String?> companionAvatarId = const Value.absent(),
                Value<String?> lastMessageText = const Value.absent(),
                Value<String?> lastMessageSenderId = const Value.absent(),
                Value<int?> lastMessageAtMs = const Value.absent(),
                required int updatedAtMs,
                required int cachedAtMs,
                Value<int> rowid = const Value.absent(),
              }) => ConversationTilesTableCompanion.insert(
                id: id,
                type: type,
                title: title,
                description: description,
                companionId: companionId,
                companionUsername: companionUsername,
                companionFirstName: companionFirstName,
                companionLastName: companionLastName,
                companionAvatarId: companionAvatarId,
                lastMessageText: lastMessageText,
                lastMessageSenderId: lastMessageSenderId,
                lastMessageAtMs: lastMessageAtMs,
                updatedAtMs: updatedAtMs,
                cachedAtMs: cachedAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConversationTilesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConversationTilesTableTable,
      ConversationTilesTableData,
      $$ConversationTilesTableTableFilterComposer,
      $$ConversationTilesTableTableOrderingComposer,
      $$ConversationTilesTableTableAnnotationComposer,
      $$ConversationTilesTableTableCreateCompanionBuilder,
      $$ConversationTilesTableTableUpdateCompanionBuilder,
      (
        ConversationTilesTableData,
        BaseReferences<
          _$AppDatabase,
          $ConversationTilesTableTable,
          ConversationTilesTableData
        >,
      ),
      ConversationTilesTableData,
      PrefetchHooks Function()
    >;
typedef $$PrivateMessagesTableTableCreateCompanionBuilder =
    PrivateMessagesTableCompanion Function({
      required String id,
      Value<String?> clientMessageId,
      required String conversationId,
      required String senderId,
      required String messageText,
      required String deliveryStatus,
      Value<String?> replyToMessageId,
      Value<bool> isDeleted,
      Value<String?> deletedById,
      Value<bool> isPinned,
      required int createdAtMs,
      required int updatedAtMs,
      Value<int?> editedAtMs,
      Value<int?> readAtMs,
      required int cachedAtMs,
      Value<int> rowid,
    });
typedef $$PrivateMessagesTableTableUpdateCompanionBuilder =
    PrivateMessagesTableCompanion Function({
      Value<String> id,
      Value<String?> clientMessageId,
      Value<String> conversationId,
      Value<String> senderId,
      Value<String> messageText,
      Value<String> deliveryStatus,
      Value<String?> replyToMessageId,
      Value<bool> isDeleted,
      Value<String?> deletedById,
      Value<bool> isPinned,
      Value<int> createdAtMs,
      Value<int> updatedAtMs,
      Value<int?> editedAtMs,
      Value<int?> readAtMs,
      Value<int> cachedAtMs,
      Value<int> rowid,
    });

class $$PrivateMessagesTableTableFilterComposer
    extends Composer<_$AppDatabase, $PrivateMessagesTableTable> {
  $$PrivateMessagesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientMessageId => $composableBuilder(
    column: $table.clientMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageText => $composableBuilder(
    column: $table.messageText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deliveryStatus => $composableBuilder(
    column: $table.deliveryStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get replyToMessageId => $composableBuilder(
    column: $table.replyToMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedById => $composableBuilder(
    column: $table.deletedById,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get editedAtMs => $composableBuilder(
    column: $table.editedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get readAtMs => $composableBuilder(
    column: $table.readAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cachedAtMs => $composableBuilder(
    column: $table.cachedAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrivateMessagesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PrivateMessagesTableTable> {
  $$PrivateMessagesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientMessageId => $composableBuilder(
    column: $table.clientMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageText => $composableBuilder(
    column: $table.messageText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deliveryStatus => $composableBuilder(
    column: $table.deliveryStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get replyToMessageId => $composableBuilder(
    column: $table.replyToMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedById => $composableBuilder(
    column: $table.deletedById,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get editedAtMs => $composableBuilder(
    column: $table.editedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get readAtMs => $composableBuilder(
    column: $table.readAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cachedAtMs => $composableBuilder(
    column: $table.cachedAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrivateMessagesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrivateMessagesTableTable> {
  $$PrivateMessagesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientMessageId => $composableBuilder(
    column: $table.clientMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get messageText => $composableBuilder(
    column: $table.messageText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deliveryStatus => $composableBuilder(
    column: $table.deliveryStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get replyToMessageId => $composableBuilder(
    column: $table.replyToMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get deletedById => $composableBuilder(
    column: $table.deletedById,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get editedAtMs => $composableBuilder(
    column: $table.editedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get readAtMs =>
      $composableBuilder(column: $table.readAtMs, builder: (column) => column);

  GeneratedColumn<int> get cachedAtMs => $composableBuilder(
    column: $table.cachedAtMs,
    builder: (column) => column,
  );
}

class $$PrivateMessagesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrivateMessagesTableTable,
          PrivateMessagesTableData,
          $$PrivateMessagesTableTableFilterComposer,
          $$PrivateMessagesTableTableOrderingComposer,
          $$PrivateMessagesTableTableAnnotationComposer,
          $$PrivateMessagesTableTableCreateCompanionBuilder,
          $$PrivateMessagesTableTableUpdateCompanionBuilder,
          (
            PrivateMessagesTableData,
            BaseReferences<
              _$AppDatabase,
              $PrivateMessagesTableTable,
              PrivateMessagesTableData
            >,
          ),
          PrivateMessagesTableData,
          PrefetchHooks Function()
        > {
  $$PrivateMessagesTableTableTableManager(
    _$AppDatabase db,
    $PrivateMessagesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrivateMessagesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrivateMessagesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PrivateMessagesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> clientMessageId = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> senderId = const Value.absent(),
                Value<String> messageText = const Value.absent(),
                Value<String> deliveryStatus = const Value.absent(),
                Value<String?> replyToMessageId = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String?> deletedById = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<int> createdAtMs = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<int?> editedAtMs = const Value.absent(),
                Value<int?> readAtMs = const Value.absent(),
                Value<int> cachedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrivateMessagesTableCompanion(
                id: id,
                clientMessageId: clientMessageId,
                conversationId: conversationId,
                senderId: senderId,
                messageText: messageText,
                deliveryStatus: deliveryStatus,
                replyToMessageId: replyToMessageId,
                isDeleted: isDeleted,
                deletedById: deletedById,
                isPinned: isPinned,
                createdAtMs: createdAtMs,
                updatedAtMs: updatedAtMs,
                editedAtMs: editedAtMs,
                readAtMs: readAtMs,
                cachedAtMs: cachedAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> clientMessageId = const Value.absent(),
                required String conversationId,
                required String senderId,
                required String messageText,
                required String deliveryStatus,
                Value<String?> replyToMessageId = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String?> deletedById = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                required int createdAtMs,
                required int updatedAtMs,
                Value<int?> editedAtMs = const Value.absent(),
                Value<int?> readAtMs = const Value.absent(),
                required int cachedAtMs,
                Value<int> rowid = const Value.absent(),
              }) => PrivateMessagesTableCompanion.insert(
                id: id,
                clientMessageId: clientMessageId,
                conversationId: conversationId,
                senderId: senderId,
                messageText: messageText,
                deliveryStatus: deliveryStatus,
                replyToMessageId: replyToMessageId,
                isDeleted: isDeleted,
                deletedById: deletedById,
                isPinned: isPinned,
                createdAtMs: createdAtMs,
                updatedAtMs: updatedAtMs,
                editedAtMs: editedAtMs,
                readAtMs: readAtMs,
                cachedAtMs: cachedAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrivateMessagesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrivateMessagesTableTable,
      PrivateMessagesTableData,
      $$PrivateMessagesTableTableFilterComposer,
      $$PrivateMessagesTableTableOrderingComposer,
      $$PrivateMessagesTableTableAnnotationComposer,
      $$PrivateMessagesTableTableCreateCompanionBuilder,
      $$PrivateMessagesTableTableUpdateCompanionBuilder,
      (
        PrivateMessagesTableData,
        BaseReferences<
          _$AppDatabase,
          $PrivateMessagesTableTable,
          PrivateMessagesTableData
        >,
      ),
      PrivateMessagesTableData,
      PrefetchHooks Function()
    >;
typedef $$PrivateMessageAttachmentsTableTableCreateCompanionBuilder =
    PrivateMessageAttachmentsTableCompanion Function({
      required String id,
      required String messageId,
      required String fileId,
      Value<String?> fileType,
      required int order,
      required int createdAtMs,
      Value<int> rowid,
    });
typedef $$PrivateMessageAttachmentsTableTableUpdateCompanionBuilder =
    PrivateMessageAttachmentsTableCompanion Function({
      Value<String> id,
      Value<String> messageId,
      Value<String> fileId,
      Value<String?> fileType,
      Value<int> order,
      Value<int> createdAtMs,
      Value<int> rowid,
    });

class $$PrivateMessageAttachmentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PrivateMessageAttachmentsTableTable> {
  $$PrivateMessageAttachmentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrivateMessageAttachmentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PrivateMessageAttachmentsTableTable> {
  $$PrivateMessageAttachmentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrivateMessageAttachmentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrivateMessageAttachmentsTableTable> {
  $$PrivateMessageAttachmentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get fileId =>
      $composableBuilder(column: $table.fileId, builder: (column) => column);

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => column,
  );
}

class $$PrivateMessageAttachmentsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrivateMessageAttachmentsTableTable,
          PrivateMessageAttachmentsTableData,
          $$PrivateMessageAttachmentsTableTableFilterComposer,
          $$PrivateMessageAttachmentsTableTableOrderingComposer,
          $$PrivateMessageAttachmentsTableTableAnnotationComposer,
          $$PrivateMessageAttachmentsTableTableCreateCompanionBuilder,
          $$PrivateMessageAttachmentsTableTableUpdateCompanionBuilder,
          (
            PrivateMessageAttachmentsTableData,
            BaseReferences<
              _$AppDatabase,
              $PrivateMessageAttachmentsTableTable,
              PrivateMessageAttachmentsTableData
            >,
          ),
          PrivateMessageAttachmentsTableData,
          PrefetchHooks Function()
        > {
  $$PrivateMessageAttachmentsTableTableTableManager(
    _$AppDatabase db,
    $PrivateMessageAttachmentsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrivateMessageAttachmentsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PrivateMessageAttachmentsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PrivateMessageAttachmentsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> messageId = const Value.absent(),
                Value<String> fileId = const Value.absent(),
                Value<String?> fileType = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> createdAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrivateMessageAttachmentsTableCompanion(
                id: id,
                messageId: messageId,
                fileId: fileId,
                fileType: fileType,
                order: order,
                createdAtMs: createdAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String messageId,
                required String fileId,
                Value<String?> fileType = const Value.absent(),
                required int order,
                required int createdAtMs,
                Value<int> rowid = const Value.absent(),
              }) => PrivateMessageAttachmentsTableCompanion.insert(
                id: id,
                messageId: messageId,
                fileId: fileId,
                fileType: fileType,
                order: order,
                createdAtMs: createdAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrivateMessageAttachmentsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrivateMessageAttachmentsTableTable,
      PrivateMessageAttachmentsTableData,
      $$PrivateMessageAttachmentsTableTableFilterComposer,
      $$PrivateMessageAttachmentsTableTableOrderingComposer,
      $$PrivateMessageAttachmentsTableTableAnnotationComposer,
      $$PrivateMessageAttachmentsTableTableCreateCompanionBuilder,
      $$PrivateMessageAttachmentsTableTableUpdateCompanionBuilder,
      (
        PrivateMessageAttachmentsTableData,
        BaseReferences<
          _$AppDatabase,
          $PrivateMessageAttachmentsTableTable,
          PrivateMessageAttachmentsTableData
        >,
      ),
      PrivateMessageAttachmentsTableData,
      PrefetchHooks Function()
    >;
typedef $$MediaDownloadCacheTableTableCreateCompanionBuilder =
    MediaDownloadCacheTableCompanion Function({
      required String mediaId,
      required String downloadUrl,
      required String mimeType,
      required int sizeBytes,
      required String status,
      required String scope,
      required String scopeId,
      required String ownerUserId,
      required int expiresAtMs,
      required int cachedAtMs,
      Value<int> rowid,
    });
typedef $$MediaDownloadCacheTableTableUpdateCompanionBuilder =
    MediaDownloadCacheTableCompanion Function({
      Value<String> mediaId,
      Value<String> downloadUrl,
      Value<String> mimeType,
      Value<int> sizeBytes,
      Value<String> status,
      Value<String> scope,
      Value<String> scopeId,
      Value<String> ownerUserId,
      Value<int> expiresAtMs,
      Value<int> cachedAtMs,
      Value<int> rowid,
    });

class $$MediaDownloadCacheTableTableFilterComposer
    extends Composer<_$AppDatabase, $MediaDownloadCacheTableTable> {
  $$MediaDownloadCacheTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mediaId => $composableBuilder(
    column: $table.mediaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get downloadUrl => $composableBuilder(
    column: $table.downloadUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scopeId => $composableBuilder(
    column: $table.scopeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expiresAtMs => $composableBuilder(
    column: $table.expiresAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cachedAtMs => $composableBuilder(
    column: $table.cachedAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MediaDownloadCacheTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaDownloadCacheTableTable> {
  $$MediaDownloadCacheTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mediaId => $composableBuilder(
    column: $table.mediaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get downloadUrl => $composableBuilder(
    column: $table.downloadUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scopeId => $composableBuilder(
    column: $table.scopeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expiresAtMs => $composableBuilder(
    column: $table.expiresAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cachedAtMs => $composableBuilder(
    column: $table.cachedAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaDownloadCacheTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaDownloadCacheTableTable> {
  $$MediaDownloadCacheTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mediaId =>
      $composableBuilder(column: $table.mediaId, builder: (column) => column);

  GeneratedColumn<String> get downloadUrl => $composableBuilder(
    column: $table.downloadUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<String> get scopeId =>
      $composableBuilder(column: $table.scopeId, builder: (column) => column);

  GeneratedColumn<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expiresAtMs => $composableBuilder(
    column: $table.expiresAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cachedAtMs => $composableBuilder(
    column: $table.cachedAtMs,
    builder: (column) => column,
  );
}

class $$MediaDownloadCacheTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaDownloadCacheTableTable,
          MediaDownloadCacheTableData,
          $$MediaDownloadCacheTableTableFilterComposer,
          $$MediaDownloadCacheTableTableOrderingComposer,
          $$MediaDownloadCacheTableTableAnnotationComposer,
          $$MediaDownloadCacheTableTableCreateCompanionBuilder,
          $$MediaDownloadCacheTableTableUpdateCompanionBuilder,
          (
            MediaDownloadCacheTableData,
            BaseReferences<
              _$AppDatabase,
              $MediaDownloadCacheTableTable,
              MediaDownloadCacheTableData
            >,
          ),
          MediaDownloadCacheTableData,
          PrefetchHooks Function()
        > {
  $$MediaDownloadCacheTableTableTableManager(
    _$AppDatabase db,
    $MediaDownloadCacheTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaDownloadCacheTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MediaDownloadCacheTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MediaDownloadCacheTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> mediaId = const Value.absent(),
                Value<String> downloadUrl = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> scope = const Value.absent(),
                Value<String> scopeId = const Value.absent(),
                Value<String> ownerUserId = const Value.absent(),
                Value<int> expiresAtMs = const Value.absent(),
                Value<int> cachedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaDownloadCacheTableCompanion(
                mediaId: mediaId,
                downloadUrl: downloadUrl,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                status: status,
                scope: scope,
                scopeId: scopeId,
                ownerUserId: ownerUserId,
                expiresAtMs: expiresAtMs,
                cachedAtMs: cachedAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String mediaId,
                required String downloadUrl,
                required String mimeType,
                required int sizeBytes,
                required String status,
                required String scope,
                required String scopeId,
                required String ownerUserId,
                required int expiresAtMs,
                required int cachedAtMs,
                Value<int> rowid = const Value.absent(),
              }) => MediaDownloadCacheTableCompanion.insert(
                mediaId: mediaId,
                downloadUrl: downloadUrl,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                status: status,
                scope: scope,
                scopeId: scopeId,
                ownerUserId: ownerUserId,
                expiresAtMs: expiresAtMs,
                cachedAtMs: cachedAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MediaDownloadCacheTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaDownloadCacheTableTable,
      MediaDownloadCacheTableData,
      $$MediaDownloadCacheTableTableFilterComposer,
      $$MediaDownloadCacheTableTableOrderingComposer,
      $$MediaDownloadCacheTableTableAnnotationComposer,
      $$MediaDownloadCacheTableTableCreateCompanionBuilder,
      $$MediaDownloadCacheTableTableUpdateCompanionBuilder,
      (
        MediaDownloadCacheTableData,
        BaseReferences<
          _$AppDatabase,
          $MediaDownloadCacheTableTable,
          MediaDownloadCacheTableData
        >,
      ),
      MediaDownloadCacheTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ConversationTilesTableTableTableManager get conversationTilesTable =>
      $$ConversationTilesTableTableTableManager(
        _db,
        _db.conversationTilesTable,
      );
  $$PrivateMessagesTableTableTableManager get privateMessagesTable =>
      $$PrivateMessagesTableTableTableManager(_db, _db.privateMessagesTable);
  $$PrivateMessageAttachmentsTableTableTableManager
  get privateMessageAttachmentsTable =>
      $$PrivateMessageAttachmentsTableTableTableManager(
        _db,
        _db.privateMessageAttachmentsTable,
      );
  $$MediaDownloadCacheTableTableTableManager get mediaDownloadCacheTable =>
      $$MediaDownloadCacheTableTableTableManager(
        _db,
        _db.mediaDownloadCacheTable,
      );
}
