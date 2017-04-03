program BigintTest;

{$APPTYPE CONSOLE}

uses
  SysUtils, sdpBigint, sdpStopwatch, sdpConvert;

var
  A, B, C, D: TBigint;
  Stopwatch: TStopwatch;
  I: Cardinal;
begin
  CreateBigint(A);
  CreateBigint(B);
  CreateBigint(C);
  CreateBigint(D);
  Stopwatch := TStopwatch.Create;
  StrToBigint('9234723675048923895723654382715636725648723404568992347236750489238957236543827156367256487234045689', A);
  IntToBigint('2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222', B);
  StopWatch.Start;
  for I := 1 to 10000000 do AddBigint(A, B, C);
  Stopwatch.Stop;
  Writeln('Time: ', (Stopwatch.GetValueMSec/1000):7:3);
  Readln;
  Stopwatch.Free;
  DestroyBigint(A);
  DestroyBigint(B);
  DestroyBigint(C);
  DestroyBigint(D);
end.
