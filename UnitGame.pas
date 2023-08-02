unit UnitGame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Imaging.jpeg, System.UITypes,
  UnitField, UnitMainMenu, UnitSettings, Vcl.Menus;

const
    BACKGROUND_IMAGE_PATH = 'sea.bmp';
    EMPTY_CELL_IMAGE_PATH = 'empty.bmp';
    SHIP_CELL_IMAGE_PATH = 'ship.bmp';
    HIT_CELL_IMAGE_PATH = 'hit.bmp';
    MISS_CELL_IMAGE_PATH = 'miss.bmp';
    GAME_FILE_PATH = 'save.txt';
    OFFSET_X = 75;
    OFFSET_Y = 100;

type
  TGameForm = class(TForm)
    MoveTimer: TTimer;
    AutoButton: TButton;
    StartButton: TButton;
    BotTimer: TTimer;
    Image: TImage;
    FirstPlayerShipsLabel: TLabel;
    SecondPlayerShipsLabel: TLabel;
    InfoLabel: TLabel;
    MainMenu: TMainMenu;
    HelpMenu: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MoveTimerTimer(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AutoButtonClick(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure BotTimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure HelpMenuClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GameForm: TGameForm;
  FirstField, SecondField: TField;
  FirstShipListHead, SecondShipListHead, SelectedShip: PListElem;
  Background: TBitmap;
  IsGameOn, IsFirstPlayerTurn, TwoPlayersMode: Boolean;
  MaxNumberOfShips: Integer;

implementation

{$R *.dfm}

function CreateListOfShips(Amount: Integer): PListElem;
var
    Head, Ship: PListElem;
    i, Count, Size: Integer;
begin
    New(Head);
    Head.Prev := nil;
    Ship := Head;
    Size := 1;
    Count := 4;
    for i := 1 to Amount do
    begin
        New(Ship.Next);
        Ship.Next.Prev := Ship;
        Ship := Ship.Next;
        Ship.X := -1;
        Ship.Y := -1;
        Ship.Size := Size;
        Ship.Orientation := Horizontal;
        Dec(Count);
        if Count = 0 then
        begin
            Inc(Size);
            Count := 5 - Size;
        end;
    end;
    Ship.Next := nil;
    CreateListOfShips := Head;
end;

procedure DeleteFromList(Start: PListElem; Ship: PListElem);
var
    IsDeleted: Boolean;
begin
     IsDeleted := False;
     while (not IsDeleted) and (Start.Next <> nil) do
     begin
        if Start.Next = Ship then
        begin
            Start.Next := Ship.Next;
            if Start.Next <> nil then
                Start.Next.Prev := Start;
            IsDeleted := True;
        end
        else
            Start := Start.Next;
     end;
end;

procedure InsertInList(Start: PListElem; X, Y, Size: Integer; Orientation: TOrientation);
var
    Ship: PListElem;
begin
     while (Start.Next <> nil) and (Start.Next.Size < Size) do
        Start := Start.Next;
     New(Ship);
     Ship.X := X;
     Ship.Y := Y;
     Ship.Size := Size;
     Ship.Orientation := Orientation;
     Ship.Next := Start.Next;
     Ship.Prev := Start;
     Start.Next := Ship;
     if Ship.Next <> nil then
        Ship.Next.Prev := Ship;
end;

procedure DeleteList(Head: PListElem);
var
    Node: PListElem;
begin
    if Head <> nil then
    begin
        Node := Head;
        while Node.Next <> nil do
            Node := Node.Next;
        while Node.Prev <> nil do
        begin
            Node := Node.Prev;
            Dispose(Node);
        end;
    end;
end;

procedure DefineShipsPlacementCoords(Head: PListElem);
var
    X, Y, PrevSize: Integer;
    Ship: PListElem;
begin
    X := FirstField.Image.Width + 3 * OFFSET_X;
    Y := OFFSET_Y;
    Ship := Head.Next;
    if Ship <> nil then
        PrevSize := Ship.Size;
    while Ship <> nil do
    begin
        if Ship.Size <> PrevSize then
        begin
            X := FirstField.Image.Width + 3 * OFFSET_X;
            Y := Y + FirstField.CellSize + 20;
        end;
        if (Ship.X < 0) or (Ship.X > FirstField.Image.Width) or
            (Ship.Y < 0) or (Ship.Y > FirstField.Image.Height) then
        begin
            Ship.X := X - OFFSET_X;
            Ship.Y := Y - OFFSET_Y;
            X := X + (Ship.Size + 1) * FirstField.CellSize;
        end;

        PrevSize := Ship.Size;
        Ship := Ship.Next;
    end;
end;

procedure DrawShipsForPlacement(Head: PListElem);
var
    i, Border: Integer;
    ShipImg: TBitmap;
    Ship: PListElem;
begin
    ShipImg := TBitmap.Create;
    ShipImg.LoadFromFile(SHIP_CELL_IMAGE_PATH);
    Border := FirstField.Image.Width + 2 * OFFSET_X;
    Ship := Head.Next;
    while Ship <> nil do
    begin
        if (Ship.X >= Border) then
            for i := 0 to Ship.Size - 1 do
                GameForm.Image.Canvas.Draw(Ship.X + OFFSET_X + i * FirstField.CellSize, Ship.Y + OFFSET_Y, ShipImg);
        Ship := Ship.Next;
    end;
    ShipImg.Destroy;
end;

procedure Redraw();
begin
    GameForm.Image.Canvas.Draw(0, 0, Background);
    if IsGameOn then
    begin
        GameForm.Image.Canvas.Draw(OFFSET_X, OFFSET_Y, FirstField.Image);
        GameForm.Image.Canvas.Draw(3 * OFFSET_X + FirstField.Image.Width, OFFSET_Y, SecondField.Image);
    end
    else
    begin
        if IsFirstPlayerTurn then
        begin
            DrawShipsForPlacement(FirstShipListHead);
            GameForm.Image.Canvas.Draw(OFFSET_X, OFFSET_Y, FirstField.Image);
        end
        else
        begin
            DrawShipsForPlacement(SecondShipListHead);
            GameForm.Image.Canvas.Draw(OFFSET_X, OFFSET_Y, SecondField.Image);
        end;
    end;
end;

procedure ContinueGame();
var
    InputFile: file of Integer;
    Tmp: Integer;
    i, j: Integer;
begin
    IsGameOn := True;
    AssignFile(InputFile, GAME_FILE_PATH);
    Reset(InputFile);
    Read(InputFile, UnitSettings.Difficulty);
    Read(InputFile, UnitSettings.FieldSize );
    if UnitSettings.FieldSize > 10 then
        MaxNumberOfShips := 11
    else
        MaxNumberOfShips := UnitSettings.FieldSize;
    Read(InputFile, Tmp);
    if Tmp = 0 then
        IsFirstPlayerTurn := True
    else
        IsFirstPlayerTurn := False;
    Read(InputFile, Tmp);
    if Tmp = 0 then
        TwoPlayersMode := False
    else
        TwoPlayersMode := True;
    FirstField := TField.Create(UnitSettings.FieldSize);
    SecondField := TField.Create(UnitSettings.FieldSize);
    Read(InputFile, Tmp);
    FirstField.NumberOfShips := Tmp;
    Read(InputFile, Tmp);
    SecondField.NumberOfShips := Tmp;
    for i := 0 to High(FirstField.FieldMatrix) do
        for j := 0 to High(FirstField.FieldMatrix) do
        begin
            Read(InputFile, Tmp);
            FirstField.FieldMatrix[i,j] := TCellState(Tmp);
        end;
    for i := 0 to High(SecondField.FieldMatrix) do
        for j := 0 to High(SecondField.FieldMatrix) do
        begin
            Read(InputFile, Tmp);
            SecondField.FieldMatrix[i,j] := TCellState(Tmp);
        end;
    CloseFile(InputFile);
end;

procedure SaveCurrentGame();
var
    OutputFile: file of Integer;
    i, j, Tmp: Integer;
begin
    AssignFile(OutputFile, GAME_FILE_PATH);
    Rewrite(OutputFile);
    Write(OutputFile, UnitSettings.Difficulty);
    Write(OutputFile, UnitSettings.FieldSize);
    if IsFirstPlayerTurn then
        Tmp := 0
    else
        Tmp := 1;
    Write(OutputFile, Tmp);
    if TwoPlayersMode then
        Tmp := 1
    else
        Tmp := 0;
    Write(OutputFile, Tmp);
    Write(OutputFile, FirstField.NumberOfShips);
    Write(OutputFile, SecondField.NumberOfShips);
    for i := 0 to High(FirstField.FieldMatrix) do
        for j := 0 to High(FirstField.FieldMatrix) do
        begin
            Tmp := Ord(FirstField.FieldMatrix[i,j]);
            Write(OutputFile, Tmp);
        end;
    for i := 0 to High(SecondField.FieldMatrix) do
        for j := 0 to High(SecondField.FieldMatrix) do
        begin
            Tmp := Ord(SecondField.FieldMatrix[i,j]);
            Write(OutputFile, Tmp);
        end;
    CloseFile(OutputFile);
end;

procedure ChangeInfoLabel();
begin
    if TwoPlayersMode then
        if IsFirstPlayerTurn then
            GameForm.InfoLabel.Caption := 'Ход первого игрока'
        else
            GameForm.InfoLabel.Caption := 'Ход второго игрока'
    else
        if IsFirstPlayerTurn then
            GameForm.InfoLabel.Caption := 'Ваш ход'
        else
            GameForm.InfoLabel.Caption := 'Ход противника';
    GameForm.InfoLabel.Left := (GameForm.ClientWidth - GameForm.InfoLabel.Width) div 2;
    GameForm.InfoLabel.Top := 35;
end;

procedure AdjustComponentsPosition();
begin
    with GameForm do
    begin
        StartButton.Left := FirstField.Image.Width + 3 * OFFSET_X;
        StartButton.Top := OFFSET_Y + FirstField.Image.Height - StartButton.Height;
        AutoButton.Left := FirstField.Image.Width + 3 * OFFSET_X;
        AutoButton.Top := OFFSET_Y + FirstField.Image.Height - 20 - StartButton.Height - AutoButton.Height;
        ClientHeight := FirstField.Image.Height + 2 * OFFSET_Y;
        ClientWidth := FirstField.Image.Width * 2 + OFFSET_X * 4;
        Image.Width := ClientWidth;
        Image.Height := GameForm.ClientHeight;
        InfoLabel.Left := (GameForm.ClientWidth - GameForm.InfoLabel.Width) div 2;
        InfoLabel.Top := 35;
        FirstPlayerShipsLabel.Left := OFFSET_X + (FirstField.Image.Width - FirstPlayerShipsLabel.Width) div 2;
        FirstPlayerShipsLabel.Top := ClientHeight - OFFSET_Y + 10;
        SecondPlayerShipsLabel.Top := ClientHeight - OFFSET_Y + 10;
        SecondPlayerShipsLabel.Left := 3 * OFFSET_X + FirstField.Image.Width + (SecondField.Image.Width - SecondPlayerShipsLabel.Width) div 2;
    end;
end;

procedure AdjustFormComponents(IsNewGame: Boolean);
begin
    with GameForm do
        if IsNewGame then
        begin
            FirstPlayerShipsLabel.Visible := False;
            SecondPlayerShipsLabel.Visible := False;
            AutoButton.Visible := True;
            StartButton.Visible := True;
            StartButton.Enabled := False;
            AutoButton.Enabled := True;
            FirstPlayerShipsLabel.Caption := 'Осталось кораблей: ' + IntToStr(MaxNumberOfShips);
            SecondPlayerShipsLabel.Caption := 'Осталось кораблей: ' + IntToStr(MaxNumberOfShips);
            if TwoPlayersMode then
            begin
                InfoLabel.Caption := 'Расстановка кораблей первого игрока';
                StartButton.Caption := 'Продолжить';
            end
            else
            begin
                InfoLabel.Caption := 'Расставьте корабли';
                StartButton.Caption := 'Начать игру';
            end;
        end
        else
        begin
            AutoButton.Visible := False;
            StartButton.Visible := False;
            FirstPlayerShipsLabel.Visible := True;
            SecondPlayerShipsLabel.Visible := True;
            FirstPlayerShipsLabel.Caption := 'Осталось кораблей: ' + IntToStr(FirstField.NumberOfShips);
            SecondPlayerShipsLabel.Caption := 'Осталось кораблей: ' + IntToStr(SecondField.NumberOfShips);
            ChangeInfoLabel();
        end;
    AdjustComponentsPosition();
end;

procedure InitializeGame(IsNewGame: Boolean);
begin
    Background := TBitmap.Create;
    Background.LoadFromFile(BACKGROUND_IMAGE_PATH);
    if IsNewGame then
    begin
        IsGameOn := False;
        IsFirstPlayerTurn := True;
        SelectedShip := nil;
        FirstField := TField.Create(UnitSettings.FieldSize);
        SecondField := TField.Create(UnitSettings.FieldSize);
        if UnitSettings.FieldSize > 10 then
            MaxNumberOfShips := UnitSettings.FieldSize - 1
        else
            MaxNumberOfShips := UnitSettings.FieldSize;
        FirstShipListHead := CreateListOfShips(MaxNumberOfShips);
        SecondShipListHead := CreateListOfShips(MaxNumberOfShips);
        DefineShipsPlacementCoords(FirstShipListHead);
    end
    else
    begin
        ContinueGame();
        FirstField.DrawField();
        SecondField.DrawField();
        FirstShipListHead := nil;
        SecondShipListHead := nil;
        if not (TwoPlayersMode) then
        begin
            FirstField.ShowShips();
            if not IsFirstPlayerTurn then
                GameForm.BotTimer.Enabled := True;
        end;
    end;
    AdjustFormComponents(IsNewGame);
    Redraw();
end;

procedure AutoPlacementOfShips();
begin
    if SelectedShip <> nil then
    begin
        InsertInList(FirstShipListHead, SelectedShip.X, SelectedShip.Y, SelectedShip.Size, SelectedShip.Orientation);
        SelectedShip := nil;
    end;
    GameForm.MoveTimer.Enabled := False;
    if IsFirstPlayerTurn then
        FirstField.AutoPlacement(FirstShipListHead)
    else
        SecondField.AutoPlacement(SecondShipListHead);
    GameForm.StartButton.Enabled := True;
    Redraw();
end;

procedure SelectShip(X, Y: Integer);
var
    Node, Head: PListElem;
    IsClicked: Boolean;
begin
    IsClicked := False;
    if IsFirstPlayerTurn then
        Head := FirstShipListHead
    else
        Head := SecondShipListHead;
    Node := Head.Next;
    X := X - OFFSET_X;
    Y := Y - OFFSET_Y;
    while (Node <> nil) and (not IsClicked) do
        if ((Node.Orientation = Horizontal) and (X > Node.X) and (X < Node.X + Node.Size * FirstField.CellSize) and
            (Y > Node.Y) and (Y < Node.Y + FirstField.CellSize)) or ((Node.Orientation = Vertical) and (X > Node.X) and
            (X < Node.X + FirstField.CellSize) and (Y > Node.Y) and (Y < Node.Y + Node.Size * FirstField.CellSize)) then
        begin
            SelectedShip := Node;
            if (X < FirstField.Image.Width) then
                if IsFirstPlayerTurn then
                    FirstField.RemoveShip(Node^)
                else
                    SecondField.RemoveShip(Node^);
            DeleteFromList(Head, Node);
            GameForm.StartButton.Enabled := False;
            GameForm.MoveTimer.Enabled := True;
            IsClicked := True;
        end
        else
            Node := Node.Next;
end;

procedure PlaceShipOnField(X, Y: Integer; const Field: TField);
begin
    X := X - OFFSET_X;
    Y := Y - OFFSET_Y;
    if (X > 0) and (X < FirstField.Image.Width) and
        (Y > 0) and (Y < FirstField.Image.Height) then
    begin
        if (Field.IsVacantPlace(X, Y, SelectedShip.Size, SelectedShip.Orientation)) then
        begin
            SelectedShip.X := X - X mod Field.CellSize;
            SelectedShip.Y := Y - Y mod Field.CellSize;
            Field.PlaceShip(SelectedShip^);
            if Field = FirstField then
                InsertInList(FirstShipListHead, SelectedShip.X, SelectedShip.Y,
                             SelectedShip.Size, SelectedShip.Orientation)
            else
                InsertInList(SecondShipListHead, SelectedShip.X, SelectedShip.Y,
                             SelectedShip.Size, SelectedShip.Orientation);
            if Field.NumberOfShips = MaxNumberOfShips then
                GameForm.StartButton.Enabled := True;
            SelectedShip := nil;
            GameForm.AutoButton.Enabled := True;
            GameForm.MoveTimer.Enabled := False;
            Redraw();
        end;
    end;
end;

procedure ChangeSelectedShipOrientation();
begin
    if SelectedShip.Orientation = Horizontal then
        SelectedShip.Orientation := Vertical
    else
        SelectedShip.Orientation := Horizontal;
end;

procedure CloseForm();
begin
    GameForm.MoveTimer.Enabled := False;
    GameForm.BotTimer.Enabled := False;
    GameForm.Hide;
    Background.Destroy;
    FirstField.Free;
    SecondField.Free;
    DeleteList(FirstShipListHead);
    DeleteList(SecondShipListHead);
    MainMenuForm.Show;
end;

procedure SinglePlayerEndGame(IsWin: Boolean);
var
    Text, Caption: PWideChar;
begin
    if IsWin then
    begin
        Text := '                   Вы выиграли!' + #13#10 +
                '          Хотите сыграть ещё раз?';
        Caption := 'Победа';
    end
    else
    begin
        Text := '                  Вы проиграли!' + #13#10 +
                '          Хотите сыграть ещё раз?';
        Caption := 'Поражение';
    end;
    if Application.MessageBox(Text, Caption, MB_YESNO) = IDYES then
        InitializeGame(True)
    else
        CloseForm();
end;

procedure MultiPlayerEndGame(IsFirstWinner: Boolean);
var
    Text, Caption: PWideChar;
begin
    if IsFirstWinner then
    begin
        Text := '            Первый игрок выиграл!' + #13#10 +
                '          Хотите сыграть ещё раз?';
        Caption := 'Победа первого игрока';
    end
    else
    begin
        Text := '            Второй игрок выиграл!' + #13#10 +
                '          Хотите сыграть ещё раз?';
        Caption := 'Победа второго игрока';
    end;
    if Application.MessageBox(Text, Caption, MB_YESNO) = IDYES then
        InitializeGame(True)
    else
        CloseForm();
end;

function RandomShot(const Field: TField): TPoint;
begin
    repeat
        Result.X := Random(Length(Field.FieldMatrix));
        Result.Y := Random(Length(Field.FieldMatrix));
    until (Field.FieldMatrix[Result.X, Result.Y] = Empty) or (Field.FieldMatrix[Result.X, Result.Y] = Ship);
end;

function CloseShot(const Field: TField; X, Y: Integer): TPoint;
begin
     repeat
        Result.X := X;
        Result.Y := Y;
        case Random(4) of
            0: Inc(Result.X);
            1: Inc(Result.Y);
            2: Dec(Result.X);
            3: Dec(Result.Y);
        end;
     until (Result.X in [0..High(Field.FieldMatrix)]) and (Result.Y in [0..High(Field.FieldMatrix)]) and
           ((Field.FieldMatrix[Result.X, Result.Y] = Ship) or (Field.FieldMatrix[Result.X, Result.Y] = Empty));
end;

function LineShot(const Field: TField; X, Y: Integer; IsHorizontal: Boolean): TPoint;
begin
    Result.X := X;
    Result.Y := Y;
    if IsHorizontal then
        repeat
            Result.X := X;
            if Random(2) = 0 then
                Dec(Result.X)
            else
                Inc(Result.X);
        until (Result.X in [0..High(Field.FieldMatrix)]) and
              ((Field.FieldMatrix[Result.X, Y] = Ship) or (Field.FieldMatrix[Result.X, Y] = Empty))
    else
        repeat
            Result.Y := Y;
            if Random(2) = 0 then
                Dec(Result.Y)
            else
                Inc(Result.Y);
        until (Result.Y in [0..High(Field.FieldMatrix)]) and
              ((Field.FieldMatrix[X, Result.Y] = Ship) or (Field.FieldMatrix[X, Result.Y] = Empty));
end;

function BotShoot(const Field: TField; HardDifficulty: Boolean): TPoint;
var
    DamagedShip: PPoint;
    ShipDir: TDirection;
begin
    DamagedShip := Field.FindDamagedShip();
    if DamagedShip = nil then
        Result := RandomShot(Field)
    else
    begin
        if HardDifficulty then
        begin
            ShipDir := Field.FindDirectionOfShip(DamagedShip.X, DamagedShip.Y, True);
            if ShipDir = dHorizontal then
                Result := LineShot(Field, DamagedShip.X, DamagedShip.Y, True)
            else if ShipDir = dVertical then
                Result := LineShot(Field, DamagedShip.X, DamagedShip.Y, False)
            else
                Result := CloseShot(Field, DamagedShip.X, DamagedShip.Y);
        end
        else
            Result := CloseShot(Field, DamagedShip.X, DamagedShip.Y);
    end;
end;

procedure TGameForm.BotTimerTimer(Sender: TObject);
var
    Point: TPoint;
    IsHit: Boolean;
begin
    case UnitSettings.Difficulty of
        0: Point := RandomShot(FirstField);
        1: Point := BotShoot(FirstField, False);
        2: Point := BotShoot(FirstField, True);
        3:
        begin
            if Random(3) = 0 then
                Point := FirstField.FindShip()^
            else
                Point := BotShoot(FirstField, True);
        end;
    end;
    IsHit := FirstField.Shoot(Point.X * FirstField.CellSize, Point.Y * FirstField.CellSize);
    Redraw();
    if IsHit then
    begin
        GameForm.FirstPlayerShipsLabel.Caption := 'Осталось кораблей: ' + IntToStr(FirstField.NumberOfShips);
        if (FirstField.NumberOfShips = 0) then
        begin
            GameForm.BotTimer.Enabled := False;
            SinglePlayerEndGame(False);
        end;
    end
    else
    begin
        IsFirstPlayerTurn := True;
        GameForm.BotTimer.Enabled := False;
        ChangeInfoLabel();
    end;
end;

procedure ShootField(const Field: TField; X, Y: Integer);
var
    IsHit: Boolean;
    LeftBorder, RightBorder: Integer;
begin
    if Field = FirstField then
    begin
        LeftBorder := OFFSET_X;
        RightBorder := OFFSET_X + Field.Image.Width;
    end
    else
    begin
        LeftBorder := 3 * OFFSET_X + FirstField.Image.Width;
        RightBorder := GameForm.ClientWidth - OFFSET_X;
    end;
    if (X > LeftBorder) and (X < RightBorder) and
        (Y > OFFSET_Y) and (Y < OFFSET_Y + Field.Image.Height) then
    begin
        IsHit := Field.Shoot(X - LeftBorder, Y - OFFSET_Y);
        Redraw();
        if IsHit then
        begin
            GameForm.FirstPlayerShipsLabel.Caption := 'Осталось кораблей: ' + IntToStr(FirstField.NumberOfShips);
            GameForm.SecondPlayerShipsLabel.Caption := 'Осталось кораблей: ' + IntToStr(SecondField.NumberOfShips);
            if Field.NumberOfShips = 0 then
                if TwoPlayersMode then
                    MultiPlayerEndGame(IsFirstPlayerTurn)
                else
                    SinglePlayerEndGame(True);
        end
        else
        begin
            IsFirstPlayerTurn := not IsFirstPlayerTurn;
            ChangeInfoLabel();
            if not TwoPlayersMode then
                GameForm.BotTimer.Enabled := True;
        end;
    end;
end;

procedure TGameForm.ImageMouseDown(Sender: TObject; Button: TMouseButton;
                                   Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then
    begin
        if IsGameOn then
            if IsFirstPlayerTurn then
                ShootField(SecondField, X, Y)
            else
                ShootField(FirstField, X, Y)
        else if not MoveTimer.Enabled then
            SelectShip(X, Y)
        else if IsFirstPlayerTurn then
            PlaceShipOnField(X, Y, FirstField)
        else
            PlaceShipOnField(X, Y, SecondField);
    end
    else if (Button = mbRight) and (MoveTimer.Enabled) then
        ChangeSelectedShipOrientation();
end;

procedure TGameForm.MoveTimerTimer(Sender: TObject);
var
    ShipImg: TBitmap;
    i, X, Y: Integer;
begin
    Redraw();
    ShipImg := TBitmap.Create;
    ShipImg.LoadFromFile(SHIP_CELL_IMAGE_PATH);
    if SelectedShip <> nil then
    begin
        X := Mouse.CursorPos.X - GameForm.ClientOrigin.X;
        Y := Mouse.CursorPos.Y - GameForm.ClientOrigin.Y;
        if SelectedShip.Orientation = Horizontal then
            for i := 0 to SelectedShip.Size - 1 do
                GameForm.Image.Canvas.Draw(X + i * ShipImg.Width, Y, ShipImg)
        else
            for i := 0 to SelectedShip.Size - 1 do
                GameForm.Image.Canvas.Draw(X, Y + i * ShipImg.Height, ShipImg);
    end;
    ShipImg.Destroy;
end;

procedure StartGame();
begin
    if (TwoPlayersMode) and (IsFirstPlayerTurn) then
    begin
        IsFirstPlayerTurn := False;
        SelectedShip := nil;
        DefineShipsPlacementCoords(SecondShipListHead);
        GameForm.StartButton.Caption := 'Начать игру';
        GameForm.StartButton.Enabled := False;
        GameForm.InfoLabel.Caption := 'Расстановка кораблей второго игрока';
    end
    else
    begin
        IsGameOn := True;
        GameForm.AutoButton.Visible := False;
        GameForm.StartButton.Visible := False;
        GameForm.FirstPlayerShipsLabel.Visible := True;
        GameForm.SecondPlayerShipsLabel.Visible := True;
        ChangeInfoLabel();
        if not IsFirstPlayerTurn then
        begin
            FirstField.HideShips;
            IsFirstPlayerTurn := True;
        end
        else if not TwoPlayersMode then
            SecondField.AutoPlacement(SecondShipListHead);
        SecondField.HideShips();
    end;
    Redraw();
end;

procedure TGameForm.FormCreate(Sender: TObject);
begin
    Randomize();
end;

procedure TGameForm.FormShow(Sender: TObject);
begin
    InitializeGame(not UnitMainMenu.IsContinueBtnPressed);
end;

procedure TGameForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
    SelectedButton: Integer;
begin
    if IsGameOn then
    begin
        SelectedButton := MessageBox(GameForm.Handle, 'Сохранить игру?', 'Выход',
                                     MB_YesNoCancel + MB_ICONINFORMATION);
        if SelectedButton = mrYes then
            SaveCurrentGame()
        else if SelectedButton = mrCancel then
            CanClose := False;
    end;
end;

procedure TGameForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    CloseForm();
end;

procedure TGameForm.AutoButtonClick(Sender: TObject);
begin
    AutoPlacementOfShips();
end;

procedure TGameForm.StartButtonClick(Sender: TObject);
begin
    StartGame();
end;

procedure TGameForm.HelpMenuClick(Sender: TObject);
begin
    ShowMessage('Для размещения корабля на поле, щёлкните левой кнопкой ' + #13#10 +
                'мыши сначала по кораблю, а затем по клетке поля.' + #13#10 +
                'Вы можете повернуть корабль, нажав правую кнопку мыши' + #13#10 +
                'после выбора корабля.');
end;

procedure TGameForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_F1 then
        ShowMessage('Для размещения корабля на поле, щёлкните левой кнопкой ' + #13#10 +
                    'мыши сначала по кораблю, а затем по клетке поля.' + #13#10 +
                    'Вы можете повернуть корабль, нажав правую кнопку мыши' + #13#10 +
                    'после выбора корабля.');
end;

procedure TGameForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #27 then
        GameForm.Close;
end;

end.
