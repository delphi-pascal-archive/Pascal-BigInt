// Набор процедур для выполнения логических операций над порядковыми типами.
// Версия для Delphi 5 и 32-х разрядных процессоров.
// Автор: Сидоров Д.П.

unit sdpLogic;

interface

uses
  sdpBigint;

// Возвращает номер старшего ненулевого бита (нумерация начинается с 0).
// Если X = 0, то возвращает -1.
function HighestBit(X: Byte): Integer; overload;
function HighestBit(X: Shortint): Integer; overload;
function HighestBit(X: Word): Integer; overload;
function HighestBit(X: Smallint): Integer; overload;
function HighestBit(X: Cardinal): Integer; overload;
function HighestBit(X: Integer): Integer; overload;
function HighestBit(X: Int64): Integer; overload;
function HighestBit(const X: TBigint): Integer; overload;

// Возвращает номер младшего ненулевого бита (нумерация начинается с 0).
// Если X = 0, то возвращает -1.
function LowestBit(X: Shortint): Integer; overload;
function LowestBit(X: Byte): Integer; overload;
function LowestBit(X: Smallint): Integer; overload;
function LowestBit(X: Word): Integer; overload;
function LowestBit(X: Integer): Integer; overload;
function LowestBit(X: Cardinal): Integer; overload;
function LowestBit(X: Int64): Integer; overload;
function LowestBit(const X: TBigint): Integer; overload;

procedure ShiftLeft(var X: TBigint; N: Byte);

// Сравнение аргументов по абсолютной величине. Результат равен 1 если A>B,
// 0 - A=B, -1 - A<B.
function CompareAbs(A, B: Shortint): Shortint; overload;
function CompareAbs(A, B: Smallint): Shortint; overload;
function CompareAbs(A, B: Integer): Shortint; overload;
function CompareAbs(A, B: Int64): Shortint; overload;
function CompareAbs(const A, B: TBigint): Shortint; overload;
function CompareAbs(const A: TBigint; B: Cardinal): Shortint; overload;

// Сравнение аргументов. Результат равен 1 если A>B, 0 - A=B, -1 - A<B.
function Compare(A, B: Byte): Shortint; overload;
function Compare(A, B: Shortint): Shortint; overload;
function Compare(A, B: Word): Shortint; overload;
function Compare(A, B: Smallint): Shortint; overload;
function Compare(A, B: Cardinal): Shortint; overload;
function Compare(A, B: Integer): Shortint; overload;
function Compare(A, B: Int64): Shortint; overload;
function Compare(const A, B: TBigint): Shortint; overload;

implementation

const
  BytesInWord     = SizeOf(Word);
  BytesInSmallint = SizeOf(Smallint);
  BytesInCardinal = SizeOf(Cardinal);
  BytesInInteger  = SizeOf(Integer);
  BytesInInt64    = SizeOf(Int64);

  BitsInByte     = 8;
  BitsInShortint = SizeOf(Shortint)*BitsInByte;
  BitsInWord     = BytesInWord*BitsInByte;
  BitsInSmallint = BytesInSmallint*BitsInByte;
  BitsInCardinal = BytesInCardinal*BitsInByte;
  BitsInInteger  = BytesInInteger*BitsInByte;
  BitsInInt64    = BytesInInt64*BitsInByte;

type
  PCardinal = ^Cardinal;

//    В целях получения максимального быстродействия, вопреки принципам
// процедурного программирования, некоторые фрагменты кода повторяются
// несколько раз вместо того, чтобы вызываться как отдельная процедура.

function HighestBit(X: Byte): Integer;
asm
  movzx ecx, X
  mov   eax, -1
  bsr   eax, ecx
end;

function HighestBit(X: Shortint): Integer;
asm
  movzx ecx, X
  mov   eax, -1
  bsr   eax, ecx
end;

function HighestBit(X: Word): Integer;
asm
  movzx ecx, X
  mov   eax, -1
  bsr   eax, ecx
end;

function HighestBit(X: Smallint): Integer;
asm
  movzx ecx, X
  mov   eax, -1
  bsr   eax, ecx
end;

function HighestBit(X: Cardinal): Integer;
asm
  mov ecx, X
  mov eax, -1
  bsr eax, ecx
end;

function HighestBit(X: Integer): Integer;
asm
  mov ecx, X
  mov eax, -1
  bsr eax, ecx
end;

function HighestBit(X: Int64): Integer;
asm
  push esi
  lea  esi, X+BytesInCardinal               // esi = указатель на старшую часть
  mov  eax, -1
  bsr  eax, [esi]
  jz   @ZeroDWord                                          // Старшая часть = 0
  add  eax, BitsInCardinal
  jmp  @Exit
@ZeroDWord:
  sub  esi, BytesInCardinal                 // esi = указатель на младшую часть
  bsr  eax, [esi]
@Exit:
  pop  esi
end;

function HighestBit(const X: TBigint): Integer;
asm
  push  esi
  mov   esi, X+ofPtrDigits                   // esi = указатель на младший блок
  movzx ecx, byte ptr (X+ofMSB)              // ecx = количество блоков в числе
  dec   ecx
  shl   ecx, 2              // ecx := ecx*4 - количество байт до старшего блока
  add   esi, ecx                             // esi = указатель на старший блок
  mov   eax, -1
  bsr   eax, [esi]
  jz    @Exit                                     // Старший блок = 0, то X = 0
  shl   ecx, 3               // ecx := ecx*8 - количество бит до старшего блока
  add   eax, ecx
@Exit:
  pop esi
end;

// ****************************************************************************

function LowestBit(X: Shortint): Integer;
asm
  movzx ecx, X
  mov   eax, -1
  bsf   eax, ecx
end;

function LowestBit(X: Byte): Integer;
asm
  movzx ecx, X
  mov   eax, -1
  bsf   eax, ecx
end;

function LowestBit(X: Smallint): Integer;
asm
  movzx ecx, X
  mov   eax, -1
  bsf   eax, ecx
end;

function LowestBit(X: Word): Integer;
asm
  movzx ecx, X
  mov   eax, -1
  bsf   eax, ecx
end;

function LowestBit(X: Integer): Integer;
asm
  mov ecx, X
  mov eax, -1
  bsf eax, ecx
end;

function LowestBit(X: Cardinal): Integer;
asm
  mov ecx, X
  mov eax, -1
  bsf eax, ecx
end;

function LowestBit(X: Int64): Integer;
asm
  push esi
  lea  esi, X                               // esi = указатель на младшую часть
  mov  eax, -1
  bsf  eax, dword ptr [esi]
  jnz  @Exit                                              // Младшая часть <> 0
  add  esi, BytesInCardinal                 // esi = указатель на старшую часть
  bsf  eax, dword ptr [esi]
  jz   @Exit                                               // Старшая часть = 0
  add  eax, BitsInCardinal
@Exit:
  pop  esi
end;

function LowestBit(const X: TBigint): Integer;
asm
  push  esi
  mov   esi, X+ofPtrDigits                   // esi = указатель на младший блок
  movzx ecx, byte ptr (X+ofMSB)              // ecx = количество блоков в числе
  mov   eax, -1
  xor   edx, edx                                  // Счетчик обработанных битов
@NextBlock:
  bsf   eax, [esi]
  jnz   @BreakLoop                                       // Найден ненулой блок
  add   esi, BytesInCardinal
  add   edx, BitsInCardinal
  loop  @NextBlock
  cmp   eax, -1                                                       // X = 0?
  je    @Exit
@BreakLoop:
  add   eax, edx
@Exit:
  pop   esi
end;

// ****************************************************************************

procedure ShiftLeft(var X: TBigint; N: Byte);
begin
//  HighestBit(TDigits(X.PtrDigits^)[X.MSB]);
end;

// ****************************************************************************

function CompareAbs(A, B: Shortint): Shortint;
begin
  A := Abs(A);
  B := Abs(B);
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function CompareAbs(A, B: Smallint): Shortint;
begin
  A := Abs(A);
  B := Abs(B);
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function CompareAbs(A, B: Integer): Shortint;
begin
  A := Abs(A);
  B := Abs(B);
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function CompareAbs(A, B: Int64): Shortint;
begin
  A := Abs(A);
  B := Abs(B);
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function CompareAbs(const A, B: TBigint): Shortint;
var
  PtrFirst, PtrSecond: PCardinal;
  Count: Byte;
begin
  // Знаки нас не интересуют, поэтому проверяем длину
  if A.MSB = B.MSB then                                // Аргументы одной длины
  begin
    PtrFirst := A.PtrDigits;
    PtrSecond := B.PtrDigits;
    Count := A.MSB;
    // Устанавливаем указатель на старший значащий блок
    Inc(PtrFirst, Count-1);
    Inc(PtrSecond, Count-1);
    // Производим поблочное сравнение
    while (PtrFirst^ = PtrSecond^) and (Count > 0) do
    begin
      Dec(PtrFirst);
      Dec(PtrSecond);
      Count := Count - 1;
    end;
    if Count = 0 then                           // Совпали значения всех блоков
      Result := 0
    else                                        // Аргументы уже точно не равны
      if PtrFirst^ > PtrSecond^ then Result := 1 else Result := -1;
  end
  else                     // Аргументы разной длины, поэтому заведомо не равны
    if A.MSB > B.MSB then Result := 1 else Result := -1;
end;

function CompareAbs(const A: TBigint; B: Cardinal): Shortint;
begin
  // Знак нас не интересует, проверяем длину
  if A.MSB = 1 then                                    // Аргументы одной длины
  begin
    if PCardinal(A.PtrDigits)^ > B then
      Result := 1
    else
      if PCardinal(A.PtrDigits)^ = B then Result := 0 else Result := -1;
  end
  else                    // Аргументы разной длины, поэтому заведомо |A| > |B|
    Result := 1;
end;

// ****************************************************************************

function Compare(A, B: Byte): Shortint;
begin
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function Compare(A, B: Shortint): Shortint;
begin
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function Compare(A, B: Word): Shortint;
begin
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function Compare(A, B: Smallint): Shortint;
begin
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function Compare(A, B: Cardinal): Shortint;
begin
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function Compare(A, B: Integer): Shortint;
begin
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function Compare(A, B: Int64): Shortint;
begin
  if A > B then
    Result := 1
  else
    if A = B then Result := 0 else Result := -1;
end;

function Compare(const A, B: TBigint): Shortint;
begin
  // Проверяем знаки аргументов
  if A.Sign > B.Sign then
  begin
    Result := 1;
    Exit;
  end;
  if A.Sign < B.Sign then
  begin
    Result := -1;
    Exit;
  end;
  // Аргументы одного знака, проверяем длину
  if A.MSB = B.MSB then                                // Аргументы одной длины
  begin
    if A.Sign = -1 then                                         // A < 0, B < 0
      Result := -CompareAbs(A, B)
    else                                     // A = 0, B = 0 иначе A > 0, B > 0
      if A.Sign = 0 then Result := 0 else Result := CompareAbs(A, B);
  end
  else                                                // Аргументы разной длины
  begin
    // Заведомо A.Sign <> 0, иначе бы совпали и длины аргументов
    if A.Sign = -1 then                                         // A < 0, B < 0
      if A.MSB < B.MSB then Result := 1 else Result := -1
    else                                                        // A > 0, B > 0
      if A.MSB > B.MSB then Result := 1 else Result := -1;
  end;
end;

end.
