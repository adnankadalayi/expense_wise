// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetInvestmentCollection on Isar {
  IsarCollection<Investment> get investments => this.collection();
}

const InvestmentSchema = CollectionSchema(
  name: r'Investment',
  id: 7879499270061128774,
  properties: {
    r'currentPrice': PropertySchema(
      id: 0,
      name: r'currentPrice',
      type: IsarType.double,
    ),
    r'currentValue': PropertySchema(
      id: 1,
      name: r'currentValue',
      type: IsarType.double,
    ),
    r'isProfitable': PropertySchema(
      id: 2,
      name: r'isProfitable',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(id: 3, name: r'name', type: IsarType.string),
    r'notes': PropertySchema(id: 4, name: r'notes', type: IsarType.string),
    r'profitLoss': PropertySchema(
      id: 5,
      name: r'profitLoss',
      type: IsarType.double,
    ),
    r'purchaseDate': PropertySchema(
      id: 6,
      name: r'purchaseDate',
      type: IsarType.dateTime,
    ),
    r'purchasePrice': PropertySchema(
      id: 7,
      name: r'purchasePrice',
      type: IsarType.double,
    ),
    r'quantity': PropertySchema(
      id: 8,
      name: r'quantity',
      type: IsarType.double,
    ),
    r'returnPercentage': PropertySchema(
      id: 9,
      name: r'returnPercentage',
      type: IsarType.double,
    ),
    r'symbol': PropertySchema(id: 10, name: r'symbol', type: IsarType.string),
    r'totalInvested': PropertySchema(
      id: 11,
      name: r'totalInvested',
      type: IsarType.double,
    ),
    r'type': PropertySchema(
      id: 12,
      name: r'type',
      type: IsarType.byte,
      enumMap: _InvestmenttypeEnumValueMap,
    ),
  },

  estimateSize: _investmentEstimateSize,
  serialize: _investmentSerialize,
  deserialize: _investmentDeserialize,
  deserializeProp: _investmentDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _investmentGetId,
  getLinks: _investmentGetLinks,
  attach: _investmentAttach,
  version: '3.3.0',
);

int _investmentEstimateSize(
  Investment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.symbol.length * 3;
  return bytesCount;
}

void _investmentSerialize(
  Investment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.currentPrice);
  writer.writeDouble(offsets[1], object.currentValue);
  writer.writeBool(offsets[2], object.isProfitable);
  writer.writeString(offsets[3], object.name);
  writer.writeString(offsets[4], object.notes);
  writer.writeDouble(offsets[5], object.profitLoss);
  writer.writeDateTime(offsets[6], object.purchaseDate);
  writer.writeDouble(offsets[7], object.purchasePrice);
  writer.writeDouble(offsets[8], object.quantity);
  writer.writeDouble(offsets[9], object.returnPercentage);
  writer.writeString(offsets[10], object.symbol);
  writer.writeDouble(offsets[11], object.totalInvested);
  writer.writeByte(offsets[12], object.type.index);
}

Investment _investmentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Investment();
  object.currentPrice = reader.readDouble(offsets[0]);
  object.id = id;
  object.name = reader.readString(offsets[3]);
  object.notes = reader.readStringOrNull(offsets[4]);
  object.purchaseDate = reader.readDateTime(offsets[6]);
  object.purchasePrice = reader.readDouble(offsets[7]);
  object.quantity = reader.readDouble(offsets[8]);
  object.symbol = reader.readString(offsets[10]);
  object.type =
      _InvestmenttypeValueEnumMap[reader.readByteOrNull(offsets[12])] ??
      InvestmentType.stock;
  return object;
}

P _investmentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (_InvestmenttypeValueEnumMap[reader.readByteOrNull(offset)] ??
              InvestmentType.stock)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _InvestmenttypeEnumValueMap = {
  'stock': 0,
  'crypto': 1,
  'mutualFund': 2,
  'bond': 3,
  'etf': 4,
  'realEstate': 5,
  'other': 6,
};
const _InvestmenttypeValueEnumMap = {
  0: InvestmentType.stock,
  1: InvestmentType.crypto,
  2: InvestmentType.mutualFund,
  3: InvestmentType.bond,
  4: InvestmentType.etf,
  5: InvestmentType.realEstate,
  6: InvestmentType.other,
};

Id _investmentGetId(Investment object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _investmentGetLinks(Investment object) {
  return [];
}

void _investmentAttach(IsarCollection<dynamic> col, Id id, Investment object) {
  object.id = id;
}

extension InvestmentQueryWhereSort
    on QueryBuilder<Investment, Investment, QWhere> {
  QueryBuilder<Investment, Investment, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension InvestmentQueryWhere
    on QueryBuilder<Investment, Investment, QWhereClause> {
  QueryBuilder<Investment, Investment, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Investment, Investment, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Investment, Investment, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension InvestmentQueryFilter
    on QueryBuilder<Investment, Investment, QFilterCondition> {
  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  currentPriceEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'currentPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  currentPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  currentPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  currentPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentPrice',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  currentValueEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'currentValue',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  currentValueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentValue',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  currentValueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentValue',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  currentValueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentValue',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  isProfitableEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isProfitable', value: value),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'notes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> notesContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> notesMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'notes',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> profitLossEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'profitLoss',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  profitLossGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'profitLoss',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  profitLossLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'profitLoss',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> profitLossBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'profitLoss',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  purchaseDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'purchaseDate', value: value),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  purchaseDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'purchaseDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  purchaseDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'purchaseDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  purchaseDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'purchaseDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  purchasePriceEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'purchasePrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  purchasePriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'purchasePrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  purchasePriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'purchasePrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  purchasePriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'purchasePrice',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> quantityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'quantity',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  quantityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'quantity',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> quantityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'quantity',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> quantityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'quantity',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  returnPercentageEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'returnPercentage',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  returnPercentageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'returnPercentage',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  returnPercentageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'returnPercentage',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  returnPercentageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'returnPercentage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> symbolEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'symbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> symbolGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'symbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> symbolLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'symbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> symbolBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'symbol',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> symbolStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'symbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> symbolEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'symbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> symbolContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'symbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> symbolMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'symbol',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> symbolIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'symbol', value: ''),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  symbolIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'symbol', value: ''),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  totalInvestedEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'totalInvested',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  totalInvestedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalInvested',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  totalInvestedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalInvested',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
  totalInvestedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalInvested',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> typeEqualTo(
    InvestmentType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> typeGreaterThan(
    InvestmentType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> typeLessThan(
    InvestmentType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> typeBetween(
    InvestmentType lower,
    InvestmentType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension InvestmentQueryObject
    on QueryBuilder<Investment, Investment, QFilterCondition> {}

extension InvestmentQueryLinks
    on QueryBuilder<Investment, Investment, QFilterCondition> {}

extension InvestmentQuerySortBy
    on QueryBuilder<Investment, Investment, QSortBy> {
  QueryBuilder<Investment, Investment, QAfterSortBy> sortByCurrentPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPrice', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByCurrentPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPrice', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByCurrentValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentValue', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByCurrentValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentValue', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByIsProfitable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProfitable', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByIsProfitableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProfitable', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByProfitLoss() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profitLoss', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByProfitLossDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profitLoss', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByPurchaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByPurchasePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByPurchasePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByReturnPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnPercentage', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy>
  sortByReturnPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnPercentage', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortBySymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbol', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortBySymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbol', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByTotalInvested() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalInvested', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByTotalInvestedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalInvested', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension InvestmentQuerySortThenBy
    on QueryBuilder<Investment, Investment, QSortThenBy> {
  QueryBuilder<Investment, Investment, QAfterSortBy> thenByCurrentPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPrice', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByCurrentPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPrice', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByCurrentValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentValue', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByCurrentValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentValue', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByIsProfitable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProfitable', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByIsProfitableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProfitable', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByProfitLoss() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profitLoss', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByProfitLossDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profitLoss', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByPurchaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByPurchasePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByPurchasePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByReturnPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnPercentage', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy>
  thenByReturnPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnPercentage', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenBySymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbol', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenBySymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbol', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByTotalInvested() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalInvested', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByTotalInvestedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalInvested', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension InvestmentQueryWhereDistinct
    on QueryBuilder<Investment, Investment, QDistinct> {
  QueryBuilder<Investment, Investment, QDistinct> distinctByCurrentPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentPrice');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByCurrentValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentValue');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByIsProfitable() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isProfitable');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByProfitLoss() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profitLoss');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaseDate');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByPurchasePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchasePrice');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quantity');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByReturnPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'returnPercentage');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctBySymbol({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'symbol', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByTotalInvested() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalInvested');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension InvestmentQueryProperty
    on QueryBuilder<Investment, Investment, QQueryProperty> {
  QueryBuilder<Investment, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Investment, double, QQueryOperations> currentPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentPrice');
    });
  }

  QueryBuilder<Investment, double, QQueryOperations> currentValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentValue');
    });
  }

  QueryBuilder<Investment, bool, QQueryOperations> isProfitableProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isProfitable');
    });
  }

  QueryBuilder<Investment, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Investment, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<Investment, double, QQueryOperations> profitLossProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profitLoss');
    });
  }

  QueryBuilder<Investment, DateTime, QQueryOperations> purchaseDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaseDate');
    });
  }

  QueryBuilder<Investment, double, QQueryOperations> purchasePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchasePrice');
    });
  }

  QueryBuilder<Investment, double, QQueryOperations> quantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quantity');
    });
  }

  QueryBuilder<Investment, double, QQueryOperations>
  returnPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'returnPercentage');
    });
  }

  QueryBuilder<Investment, String, QQueryOperations> symbolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'symbol');
    });
  }

  QueryBuilder<Investment, double, QQueryOperations> totalInvestedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalInvested');
    });
  }

  QueryBuilder<Investment, InvestmentType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
