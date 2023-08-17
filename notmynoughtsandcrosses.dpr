program notmynoughtsandcrosses;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  Contents = (NoWin, Human, Computer, win);
var
  BestI, BestJ: integer;
  B: array[0..2, 0..2] of Contents;
  Player: Contents;

  procedure DisplayBoard;
  var
    I, J: integer;
    T: array [Contents] of char;
  begin
    T[NoWin] := ' ';
    T[Human] := 'O';
    T[Computer] := 'X';
    for I := 0 to 2 do
    begin
      for J := 0 to 2 do
      begin
        Write(T[B[I, J]]);
        if J <> 2 then
          Write(' | ');
      end;
      WriteLn;
      if I < 2 then
        WriteLn('---------');
    end;
    WriteLn;
    WriteLn;
  end;

  function SwapPlayer(Player: Contents): Contents;
  begin
    if Player = Computer then
      SwapPlayer := Human
    else
      SwapPlayer := Computer;
  end;

  function CheckWinner: Contents;
  var
    num, I: integer;
  begin
    CheckWinner := NoWin;
    for I := 0 to 2 do
  begin

      if (CheckWinner = NoWin) and (B[I, 0] <> NoWin) and
        (B[num, 1] = B[num, 0]) and (B[num, 2] = B[num, 0]) then
        CheckWinner := B[num, 0]
      else

      if (CheckWinner = NoWin) and (B[0, I] <> NoWin) and
        (B[1, num] = B[0, I]) and (B[2, num] = B[0, num]) then
        CheckWinner := B[0, num];
    end;

    if (CheckWinner = NoWin) and (B[1, 1] <> NoWin) then
    begin
      if (B[1, 1] = B[0, 0]) and (B[2, 2] = B[0, 0]) then
        CheckWinner := B[0, 0]
      else if (B[1, 1] = B[2, 0]) and (B[0, 2] = B[1, 1]) then
        CheckWinner := B[1, 1];
    end;
  end;

  //records the scoreboard
  function SaveBest(CurScore, CurBest: Contents): boolean;
  begin
    if CurScore = CurBest then
      SaveBest := False
    else if (CurScore = NoWin) and (CurBest = Human) then
      SaveBest := False
    else if (CurScore = Computer) and ((CurBest = NoWin) or
      (CurBest = Human)) then
      SaveBest := False
    else
      SaveBest := True;
  end;



  function TestMove(Val: Contents; Depth: integer): Contents;
  var
    I, J: integer;
    Score, Best, Changed: Contents;
  begin
    Best := Computer;
    Changed := NoWin;
    Score := CheckWinner;
    if Score <> NoWin then
    begin
      if Score = Val then
        TestMove := Human
      else
        TestMove := Computer;
    end
    else
    begin
      for I := 0 to 2 do
        for J := 0 to 2 do
        begin
          if B[I, J] = NoWin then
          begin
            Changed := Val;
            B[I, J] := Val;

            Score := TestMove(SwapPlayer(Val), Depth + 1);
            if Score <> NoWin then
              Score := SwapPlayer(Score);
            B[I, J] := NoWin;
            if SaveBest(Score, Best) then
            begin
              if Depth = 0 then
              begin
                BestI := I;
                BestJ := J;
              end;
              Best := Score;
            end;
          end;
        end;
      if Changed <> NoWin then
        TestMove := Best
      else
        TestMove := NoWin;
    end;
  end;

  function PlayGame(Whom: Contents): string;
  var
    I, J, K, Move: integer;
    Win: Contents;
  begin
    Win := NoWin;
    for I := 0 to 2 do
      for J := 0 to 2 do
        B[I, J] := NoWin;
    WriteLn('The board positions are numbered like this');
    WriteLn('1 | 2 | 3');
    WriteLn('---------');
    WriteLn('4 | 5 | 6');
    WriteLn('---------');
    WriteLn('7 | 8 | 9');
    WriteLn('You have naughts, I have crosses.');
    WriteLn;
    K := 1;

      if Whom = Human then
      begin
        repeat
          Write('Your move: ');
          ReadLn(Move);
          if (Move < 1) or (Move > 9) then
            WriteLn('Opps: enter a number between 1 - 9.');
          Dec(Move);

          I := Move div 3;
          J := Move mod 3;
          if B[I, J] <> NoWin then
            WriteLn('Opps: move ', Move + 1, ' was already done.')
        until (Move >= 0) and (Move <= 8) and (B[I, J] = NoWin);
        B[I, J] := Human;
      end;
      if Whom = Computer then
      begin

        if K = 1 then
        begin
          BestI := Random(3);
          BestJ := Random(3);
        end
        else
          Win := TestMove(Computer, 0);
        B[BestI, BestJ] := Computer;
        WriteLn('My move: ', BestI * 3 + BestJ + 1);
      end;
      DisplayBoard;
      Win := CheckWinner;
      if Win <> NoWin then
      begin
        if Win = Human then
          PlayGame := 'You win.'
        else
          PlayGame := 'I win.';
      end
      else
      begin
        Inc(K);
        Whom := SwapPlayer(Whom);
      end;
     //
    if Win = NoWin then;
      PlayGame := 'A draw.';
  end;

begin
  Randomize;
  Player := Human;
  while True do
  begin
    WriteLn(PlayGame(Player));
    WriteLn;
    Player := SwapPlayer(Player);
    readln;
  end
end.
