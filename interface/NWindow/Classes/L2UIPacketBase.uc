//================================================================================
// L2UIPacketBase.
//================================================================================

class L2UIPacketBase extends Object
	native
	export;

// Export UL2UIPacketBase::execEncodeBool(FFrame&, void* const)
native static function bool EncodeBool(out array<byte> o_Stream, byte a_Value);

// Export UL2UIPacketBase::execEncodeByte(FFrame&, void* const)
native static function bool EncodeByte(out array<byte> o_Stream, byte a_Value);

// Export UL2UIPacketBase::execEncodeChar(FFrame&, void* const)
native static function bool EncodeChar(out array<byte> o_Stream, int a_Value);

// Export UL2UIPacketBase::execEncodeWChar_t(FFrame&, void* const)
native static function bool EncodeWChar_t(out array<byte> o_Stream, string a_Value, optional int a_ArraySize);

// Export UL2UIPacketBase::execEncodeShort(FFrame&, void* const)
native static function bool EncodeShort(out array<byte> o_Stream, int a_Value);

// Export UL2UIPacketBase::execEncodeUInt16(FFrame&, void* const)
native static function bool EncodeUInt16(out array<byte> o_Stream, int a_Value);

// Export UL2UIPacketBase::execEncodeInt(FFrame&, void* const)
native static function bool EncodeInt(out array<byte> o_Stream, int a_Value);

// Export UL2UIPacketBase::execEncodeUInt32(FFrame&, void* const)
native static function bool EncodeUInt32(out array<byte> o_Stream, INT64 a_Value);

// Export UL2UIPacketBase::execEncodeInt64(FFrame&, void* const)
native static function bool EncodeInt64(out array<byte> o_Stream, INT64 a_Value);

// Export UL2UIPacketBase::execEncodeFloat(FFrame&, void* const)
native static function bool EncodeFloat(out array<byte> o_Stream, float a_Value);

// Export UL2UIPacketBase::execEncodeDouble(FFrame&, void* const)
native static function bool EncodeDouble(out array<byte> o_Stream, INT64 a_Value);

// Export UL2UIPacketBase::execEncodeString(FFrame&, void* const)
native static function bool EncodeString(out array<byte> o_Stream, string a_Value, optional bool bIsMorpheus);

// Export UL2UIPacketBase::execEncodeWString(FFrame&, void* const)
native static function bool EncodeWString(out array<byte> o_Stream, string a_Value, optional bool bIsMorpheus);

// Export UL2UIPacketBase::execSetShort(FFrame&, void* const)
native static function bool SetShort(out array<byte> o_Stream, int a_Index, int a_Value);

// Export UL2UIPacketBase::execDecodeBool(FFrame&, void* const)
native static function bool DecodeBool(out byte a_Value);

// Export UL2UIPacketBase::execDecodeByte(FFrame&, void* const)
native static function bool DecodeByte(out byte a_Value);

// Export UL2UIPacketBase::execDecodeChar(FFrame&, void* const)
native static function bool DecodeChar(out int a_Value);

// Export UL2UIPacketBase::execDecodeWChar_t(FFrame&, void* const)
native static function bool DecodeWChar_t(out string a_Value, optional int a_ArraySize);

// Export UL2UIPacketBase::execDecodeShort(FFrame&, void* const)
native static function bool DecodeShort(out int a_Value);

// Export UL2UIPacketBase::execDecodeUInt16(FFrame&, void* const)
native static function bool DecodeUInt16(out int a_Value);

// Export UL2UIPacketBase::execDecodeInt(FFrame&, void* const)
native static function bool DecodeInt(out int a_Value);

// Export UL2UIPacketBase::execDecodeUInt32(FFrame&, void* const)
native static function bool DecodeUInt32(out INT64 a_Value);

// Export UL2UIPacketBase::execDecodeInt64(FFrame&, void* const)
native static function bool DecodeInt64(out INT64 a_Value);

// Export UL2UIPacketBase::execDecodeFloat(FFrame&, void* const)
native static function bool DecodeFloat(out float a_Value);

// Export UL2UIPacketBase::execDecodeDouble(FFrame&, void* const)
native static function bool DecodeDouble(out INT64 a_Value);

// Export UL2UIPacketBase::execDecodeString(FFrame&, void* const)
native static function bool DecodeString(out string a_Value, optional bool bIsMorpheus);

// Export UL2UIPacketBase::execDecodeWString(FFrame&, void* const)
native static function bool DecodeWString(out string a_Value, optional bool bIsMorpheus);

// Export UL2UIPacketBase::execGetCurDecodePos(FFrame&, void* const)
native static function int GetCurDecodePos();

// Export UL2UIPacketBase::execRequestUIPacket(FFrame&, void* const)
native static function RequestUIPacket(int a_UIProtocol, optional array<byte> a_stream);

defaultproperties
{
}
