// Набор процедур для выполнения преобразований одного типа в другой.
// Версия для Borland Delphi 7 (платформа Win32).
// Автор: Сидоров Д.П.

{$LONGSTRINGS ON}

unit sdpConvert;

interface

uses
  sdpBigint;

type
  TStrBin = String[64];                         // Двоичное представление числа
  TStrHex = String[16];                // Шестнадцатеричное представление числа

// Функция возращает двоичное представление параметра X
function OrdToBin(X: Byte): TStrBin; overload;
function OrdToBin(X: Shortint): TStrBin; overload;
function OrdToBin(X: Word): TStrBin; overload;
function OrdToBin(X: Smallint): TStrBin; overload;
function OrdToBin(X: Cardinal): TStrBin; overload;
function OrdToBin(X: Integer): TStrBin; overload;
function OrdToBin(X: Int64): TStrBin; overload;
function OrdToBin(const X: TBigint): String; overload;

// Функция возращает шестнадцатеричное представление параметра X
function OrdToHex(X: Byte): TStrHex; overload;
function OrdToHex(X: Shortint): TStrHex; overload;
function OrdToHex(X: Word): TStrHex; overload;
function OrdToHex(X: Smallint): TStrHex; overload;
function OrdToHex(X: Cardinal): TStrHex; overload;
function OrdToHex(X: Integer): TStrHex; overload;
function OrdToHex(X: Int64): TStrHex; overload;
function OrdToHex(const X: TBigint): String; overload;

// Преобразование типа TBigint в AnsiString, являющийся его десятичной записью,
// и обратное преобразование.
function BigintToStr(const X: TBigint): AnsiString;
procedure StrToBigint(const S: AnsiString; var X: TBigint);

// Преобразование в сверхбольшое целое. Если X имеет тип String, то эта строка
// должна содержать запись числа в десятичной системе счисления и может
// начинаться со знака '+' или '-'. Проверка на корректность
// аргументов не производится.
procedure IntToBigint(X: Cardinal; var Bigint: TBigint); overload;
procedure IntToBigint(X: Integer; var Bigint: TBigint); overload;
procedure IntToBigint(X: Int64; var Bigint: TBigint); overload;
procedure IntToBigint(const X: String; var Bigint: TBigint); overload;

// Преобразование сверхбольшого целого в стандартные типы. В случае
// преобразования в Cardinal или Integer процедура возвращает в параметр X
// только младший блок числа, а все остальные отбрасываются. В случае
// преобразования в String, результатом является десятичная запись числа.
function BigintToInt(X: TBigint): Cardinal; overload;
procedure BigintToInt(const Bigint: TBigint; var X: Integer); overload;
procedure BigintToInt(const Bigint: TBigint; var X: String); overload;

implementation

uses
  SysUtils;

type
  PCardinal = ^Cardinal;
  PInteger = ^Integer;

//    В ассемблерных подпрограммах необходимо осторожно использовать команду
// std. По всей видимости все стандартные строковые процедуры не устанавливают
// самостоятельно необходимое значение флага направления, а предполагают, что
// по умолчанию значение равно 0, т. е. индексные регистры увеличиваются.
// Поэтому после завершения работы со строками необходимо выполнить cld.
//   В целях получения максимального быстродействия, вопреки принципам
// процедурного программирования, некоторые фрагменты кода повторяются
// несколько раз вместо того, чтобы вызываться как отдельная процедура.
// Например, в нижеследующей процедуре вызов вида
//                       Result := OrdToBin(Сardinal(X));
// порождает генерацию дополнительного кода, по размеру сравнимого с самой
// процедурой.

function OrdToBin(X: Byte): TStrBin;
asm
  push  edi
  mov   edi, @Result                              // Загрузить адрес результата
  movzx edx, X
  bsr   ecx, edx                        // ecx = номер старшего ненулевого бита
  jnz   @NonZero
  mov   byte ptr [edi], 0
  jmp   @Exit
@NonZero:
  inc   ecx                                   // ecx = количество битов в числе
  mov   [edi], cl                                   // Установить размер строки
  add   edi, ecx               // Установить указатель на последний байт строки
  std                                         // Индексные регистры уменьшаются
@NextBit:
  xor   al, al
  shr   edx, 1                                                       // edx = X
  adc   al, $30                                                   // #30h = '0'
  stosb
  loop  @NextBit
  cld
@Exit:
  pop   edi
end;

function OrdToBin(X: Shortint): TStrBin;
asm
  push  edi
  mov   edi, @Result                              // Загрузить адрес результата
  movzx edx, X
  bsr   ecx, edx                        // ecx = номер старшего ненулевого бита
  jnz   @NonZero
  mov   byte ptr [edi], 0
  jmp   @Exit
@NonZero:
  inc   ecx                                   // ecx = количество битов в числе
  mov   [edi], cl                                   // Установить размер строки
  add   edi, ecx               // Установить указатель на последний байт строки
  std                                         // Индексные регистры уменьшаются
@NextBit:
  xor   al, al
  shr   edx, 1                                                       // edx = X
  adc   al, $30                                                   // #30h = '0'
  stosb
  loop  @NextBit
  cld
@Exit:
  pop   edi
end;

function OrdToBin(X: Word): TStrBin;
asm
  push  edi
  mov   edi, @Result                              // Загрузить адрес результата
  movzx edx, X
  bsr   ecx, edx                        // ecx = номер старшего ненулевого бита
  jnz   @NonZero
  mov   byte ptr [edi], 0
  jmp   @Exit
@NonZero:
  inc   ecx                                   // ecx = количество битов в числе
  mov   [edi], cl                                   // Установить размер строки
  add   edi, ecx               // Установить указатель на последний байт строки
  std                                         // Индексные регистры уменьшаются
@NextBit:
  xor   al, al
  shr   edx, 1                                                       // edx = X
  adc   al, $30                                                   // #30h = '0'
  stosb
  loop  @NextBit
  cld
@Exit:
  pop   edi
end;

function OrdToBin(X: Smallint): TStrBin;
asm
  push  edi
  mov   edi, @Result                              // Загрузить адрес результата
  movzx edx, X
  bsr   ecx, edx                        // ecx = номер старшего ненулевого бита
  jnz   @NonZero
  mov   byte ptr [edi], 0
  jmp   @Exit
@NonZero:
  inc   ecx                                   // ecx = количество битов в числе
  mov   [edi], cl                                   // Установить размер строки
  add   edi, ecx               // Установить указатель на последний байт строки
  std                                         // Индексные регистры уменьшаются
@NextBit:
  xor   al, al
  shr   edx, 1                                                       // edx = X
  adc   al, $30                                                   // #30h = '0'
  stosb
  loop  @NextBit
  cld
@Exit:
  pop   edi
end;

function OrdToBin(X: Cardinal): TStrBin;
asm
  push edi
  mov  edi, @Result                               // Загрузить адрес результата
  mov  edx, X
  bsr  ecx, edx                         // ecx = номер старшего ненулевого бита
  jnz  @NonZero
  mov  byte ptr [edi], 0
  jmp  @Exit
@NonZero:
  inc  ecx                                    // ecx = количество битов в числе
  mov  [edi], cl                                    // Установить размер строки
  add  edi, ecx                // Установить указатель на последний байт строки
  std                                         // Индексные регистры уменьшаются
@NextBit:
  xor  al, al
  shr  edx, 1                                                        // edx = X
  adc  al, $30                                                    // #30h = '0'
  stosb
  loop @NextBit
  cld
@Exit:
  pop  edi
end;

function OrdToBin(X: Integer): TStrBin;
asm
  push edi
  mov  edi, @Result                               // Загрузить адрес результата
  mov  edx, X
  bsr  ecx, edx                         // ecx = номер старшего ненулевого бита
  jnz  @NonZero
  mov  byte ptr [edi], 0
  jmp  @Exit
@NonZero:
  inc  ecx                                    // ecx = количество битов в числе
  mov  [edi], cl                                    // Установить размер строки
  add  edi, ecx                // Установить указатель на последний байт строки
  std                                         // Индексные регистры уменьшаются
@NextBit:
  xor  al, al
  shr  edx, 1                                                        // edx = X
  adc  al, $30                                                    // #30h = '0'
  stosb
  loop @NextBit
  cld
@Exit:
  pop  edi
end;

function OrdToBin(X: Int64): TStrBin;
begin
end;

function OrdToBin(const X: TBigint): String;
begin
end;

// ****************************************************************************

function OrdToHex(X: Byte): TStrHex;
begin
end;

function OrdToHex(X: Shortint): TStrHex;
begin
end;

function OrdToHex(X: Word): TStrHex;
begin
end;

function OrdToHex(X: Smallint): TStrHex;
begin
end;

function OrdToHex(X: Cardinal): TStrHex;
begin
end;

function OrdToHex(X: Integer): TStrHex;
begin
end;

function OrdToHex(X: Int64): TStrHex;
begin
end;

function OrdToHex(const X: TBigint): String;
begin
end;

// ****************************************************************************

function BigintToStr(const X: TBigint): AnsiString;
var
  LocX: TBigint;
  D: Cardinal;
  IsZero: Boolean;
  Zeroes, S: String[9];
begin
  if X.Sign = 0 then
  begin
    Result := '0';
    Exit;
  end;
  Result := '';
  CreateBigint(LocX, X.MSB);                     // Временная копия параметра X
  CopyBigint(X, LocX);
  LocX.Sign := 1;                           // Вычисляем |X|; заведомо |X| <> 0
  Zeroes := '000000000';
  repeat
    D := DivBigint(LocX, 1000000000, LocX);
    IsZero := (LocX.Sign = 0);
    S := IntToStr(D);
    if (Length(S) < 9) and (not IsZero) then   // Если это не последнее деление
    begin
      Zeroes[0] := Chr(9-Length(S));
      S := Zeroes + S;
    end;
    Result := S + Result;
  until IsZero;
  if X.Sign < 0 then Result := '-' + Result;  
  DestroyBigint(LocX);
end;

procedure StrToBigint(const S: AnsiString; var X: TBigint);
var
  Len, I: Integer;
  FirstSym, Count: Byte;
  C: Cardinal;
begin
  Len := Length(S);
  // Преобразовываем блоки из 9 цифр, начиная со старших разрядов. Первый блок
  // может быть неполным.
  if S[1] in ['+','-'] then
  begin
    FirstSym := 2;                             // Первый значащий символ строки
    Count := (Len-1) mod 9;                             // Размер первого блока
  end
  else
  begin
    FirstSym := 1;                             // Первый значащий символ строки
    Count := Len mod 9;                                 // Размер первого блока
  end;
  if Count = 0 then Count := 9;    // Длина строки кратна 9; первый блок полный
  C := StrToInt(Copy(S, FirstSym, Count));
  IntToBigint(C, X);
  I := FirstSym + Count;
  while I <= Len do
  begin
    MulBigint(X, Cardinal(1000000000), X);
    C := StrToInt(Copy(S, I, 9));
    AddBigint(X, C, X);
    I := I + 9;
  end;
  if S[1] = '-' then X.Sign := -1;
end;

// ****************************************************************************

procedure IntToBigint(X: Cardinal; var Bigint: TBigint);
begin
  with Bigint do
  begin
    MSB := 1;
    if X = 0 then Sign := 0 else Sign := 1;
    PCardinal(PtrDigits)^ := X;
  end;
end;

procedure IntToBigint(X: Integer; var Bigint: TBigint);
begin
  with Bigint do
  begin
    MSB := 1;
    if X < 0 then
    begin
      Sign := -1;
      X := -X;
    end
    else
      if X = 0 then Sign := 0 else Sign := 1;
    PInteger(PtrDigits)^ := X;
  end;
end;

procedure IntToBigint(X: Int64; var Bigint: TBigint);
begin
end;

procedure IntToBigint(const X: String; var Bigint: TBigint);
var
  Len: Word;
  ResSign: Shortint;
  FirstSym: Byte;
  Count: Byte;
  C: Cardinal;
  I: Word;
begin
  Len := Length(X);
  if X[1] in ['+','-'] then
  begin
    case X[1] of
      '-': ResSign := -1;
      '+': ResSign := 1;
    end;
    FirstSym := 2;
    Count := (Len-1) mod 9;
  end
  else
  begin
    ResSign := 1;
    FirstSym := 1;
    Count := Len mod 9;
  end;
  // Преобразовываем блоки из 9 цифр, начиная со старших разрядов. Первый блок
  // может быть неполным.
  if Count = 0 then Count := 9;                        // Длина строки кратна 9
  C := StrToInt(Copy(X, FirstSym, Count));
  IntToBigint(C, Bigint);
  I := FirstSym + Count;
  while I <= Len do
  begin
    MulBigint(Bigint, Cardinal(1000000000), Bigint);
    C := StrToInt(Copy(X, I, 9));
    AddBigint(Bigint, C, Bigint);                
    I := I + 9;
  end;
  Bigint.Sign := ResSign;
end;

// ****************************************************************************

function BigintToInt(X: TBigint): Cardinal;
asm
  mov eax, X.PtrDigits
  mov eax, [eax]
end;

procedure BigintToInt(const Bigint: TBigint; var X: Integer);
begin
end;

procedure BigintToInt(const Bigint: TBigint; var X: String);
var
  A: TBigint;
  D: Cardinal;
  IsZero: Boolean;
  S, Zeroes: String[9];
begin
  case Bigint.Sign of
    -1: X := '';
    1: X := '';
  else
    X := '0';
    Exit;
  end;
  Zeroes := '000000000';
  CreateBigint(A);                          // Временная копия параметра Bigint
  CopyBigint(Bigint, A);
  if A.Sign < 0 then A.Sign := 1;
  repeat
    D := DivBigint(A, 1000000000, A);
    IsZero := (A.Sign = 0);
    S := IntToStr(D);
    if (Length(S) < 9) and (not IsZero) then   // Если это не последнее деление
    begin
      Zeroes[0] := Chr(9-Length(S));
      S := Zeroes + S;
    end;
    X := S + X;
  until IsZero;
  if Bigint.Sign < 0 then X := '-' + X;
  DestroyBigint(A);
end;

end.