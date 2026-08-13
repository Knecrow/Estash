// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionCategoryAdapter extends TypeAdapter<TransactionCategory> {
  @override
  final int typeId = 1;

  @override
  TransactionCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionCategory.food;
      case 1:
        return TransactionCategory.outing;
      case 2:
        return TransactionCategory.bills;
      case 3:
        return TransactionCategory.shopping;
      case 4:
        return TransactionCategory.donations;
      case 5:
        return TransactionCategory.other;
      default:
        return TransactionCategory.food;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionCategory obj) {
    switch (obj) {
      case TransactionCategory.food:
        writer.writeByte(0);
        break;
      case TransactionCategory.outing:
        writer.writeByte(1);
        break;
      case TransactionCategory.bills:
        writer.writeByte(2);
        break;
      case TransactionCategory.shopping:
        writer.writeByte(3);
        break;
      case TransactionCategory.donations:
        writer.writeByte(4);
        break;
      case TransactionCategory.other:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
