unit UnitField;

interface

uses Winapi.Windows, Vcl.Graphics, Math;

type
    TCellState = (Empty, Ship, Miss, Hit);
    TOrientation = (Horizontal, Vertical);
    TDirection = (None, dHorizontal, dVertical);
    PListElem = ^TShip;
    TShip = record
      X, Y: Integer;
      Size: Integer;
      Orientation: TOrientation;
      Next: PListElem;
      Prev: PListElem;
    end;
    TField = class
    private
        FieldImage: TBitmap;
        CellsSize: Integer;
        ShipsNumber: Integer;
        procedure SetNumberOfShips(Number: Integer);
        procedure MakeCellsEmpty();
        function CheckCollision(X, Y, Size: Integer; Orientation: TOrientation): Boolean;
        function IsDestroyed(X, Y: Integer; IsHorizontal: Boolean): Boolean;
        procedure CheckIfShipDestroyed(X, Y: Integer);
        procedure CoverCells(X, Y: Integer; IsHorizontal, IsCorner: Boolean);
        procedure DestroyShip(X, Y: Integer; IsHorizontal: Boolean);
    public
        FieldMatrix: array of array of TCellState;
        constructor Create(Size: Integer);
        destructor Destroy(); override;
        procedure PlaceShip(const NewShip: TShip);
        procedure RemoveShip(const Ship: TShip);
        procedure AutoPlacement(const Head: PListElem);
        function IsVacantPlace(X, Y, Size: Integer; Orientation: TOrientation): Boolean;
        function FindDirectionOfShip(X, Y: Integer; IsDamaged: Boolean): TDirection;
        procedure HideShips();
        procedure ShowShips();
        procedure DrawField();
        function FindDamagedShip(): PPoint;
        function FindShip(): PPoint;
        function Shoot(X, Y: Integer): Boolean;
        property Image: TBitmap read FieldImage;
        property CellSize: Integer read CellsSize;
        property NumberOfShips: Integer read ShipsNumber write SetNumberOfShips;

  end;

implementation

uses UnitGame;

procedure TField.SetNumberOfShips(Number: Integer);
begin
    ShipsNumber := Number;
end;

procedure TField.MakeCellsEmpty();
var
    EmptyCell: TBitmap;
begin
    EmptyCell := TBitmap.Create;
    EmptyCell.LoadFromFile(EMPTY_CELL_IMAGE_PATH);
    for var i := 0 to High(FieldMatrix) do
        for var j := 0 to High(FieldMatrix) do
        begin
            FieldMatrix[i, j] := Empty;
            FieldImage.Canvas.Draw(i * CellsSize, j * CellsSize, EmptyCell);
        end;
    EmptyCell.Destroy;
end;

constructor TField.Create(Size: Integer);
var
    EmptyCell: TBitmap;
begin
    SetLength(FieldMatrix, Size, Size);
    ShipsNumber := 0;
    EmptyCell := TBitmap.Create;
    EmptyCell.LoadFromFile(EMPTY_CELL_IMAGE_PATH);
    CellsSize := EmptyCell.Width;
    FieldImage := TBitmap.Create;
    FieldImage.Width := Size * CellSize;
    FieldImage.Height := FieldImage.Width;
    EmptyCell.Destroy;
    MakeCellsEmpty();
end;

function TField.CheckCollision(X, Y, Size: Integer; Orientation: TOrientation): Boolean;
var
    IsColliding: Boolean;
    StartX, StartY, i, j, Width, Height: Integer;
begin
    IsColliding := False;
    if Orientation = Horizontal then
    begin
        Width := Size + 2;
        Height := 3;
    end
    else
    begin
        Width := 3;
        Height := Size + 2;
    end;
    StartX := X - 1;
    StartY := Y - 1;
    if X = 0 then
    begin
        StartX := 0;
        Dec(Width);
    end;
    if Y = 0 then
    begin
        StartY := 0;
        Dec(Height);
    end;
    Width := StartX + Width;
    Height := StartY + Height;
    if Width > Length(FieldMatrix) then
        Dec(Width);
    if Height > Length(FieldMatrix)then
        Dec(Height);
    i := StartX;
    while (not IsColliding) and (i < Width) do
    begin
        j := StartY;
        while (not IsColliding) and (j < Height) do
            if FieldMatrix[i, j] = Ship then
                IsColliding := True
            else
                Inc(j);
        Inc(i);
    end;
    Result := IsColliding;
end;

function TField.IsVacantPlace(X, Y, Size: Integer; Orientation: TOrientation): Boolean;
var
    IsVacant: Boolean;
begin
    X := X div CellsSize;
    Y := Y div CellsSize;
    if (Orientation = Horizontal) then
        if X + Size > Length(FieldMatrix) then
            IsVacant := False
        else
            IsVacant := not CheckCollision(X, Y, Size, Orientation)
    else
    begin
        if Y + Size > Length(FieldMatrix) then
            IsVacant := False
        else
            IsVacant := not CheckCollision(X, Y, Size, Orientation);
    end;
    Result := IsVacant;
end;

procedure TField.PlaceShip(const NewShip: TShip);
var
    i, X, Y: Integer;
    ShipCell: TBitmap;
begin
    ShipCell := TBitmap.Create;
    ShipCell.LoadFromFile(SHIP_CELL_IMAGE_PATH);
    X := NewShip.X div CellsSize;
    Y := NewShip.Y div CellsSize;
    if NewShip.Orientation = Horizontal then
        for i := 0 to NewShip.Size - 1 do
        begin
            FieldMatrix[X + i][Y] := Ship;
            FieldImage.Canvas.Draw((X + i) * CellsSize, Y * CellsSize, ShipCell);
        end
    else
        for i := 0 to NewShip.Size - 1 do
        begin
            FieldMatrix[X][Y + i] := Ship;
            FieldImage.Canvas.Draw(X * CellsSize, (Y + i) * CellsSize, ShipCell);
        end;
    ShipCell.Destroy;
    Inc(ShipsNumber);
end;

procedure TField.RemoveShip(const Ship: TShip);
var
    i, X, Y: Integer;
    EmptyCell: TBitmap;
begin
    EmptyCell := TBitmap.Create;
    EmptyCell.LoadFromFile(EMPTY_CELL_IMAGE_PATH);
    X := Ship.X div CellsSize;
    Y := Ship.Y div CellsSize;
    if Ship.Orientation = Horizontal then
        for i := 0 to Ship.Size - 1 do
        begin
            FieldMatrix[X + i][Y] := Empty;
            FieldImage.Canvas.Draw((X + i) * CellsSize, Y * CellsSize, EmptyCell);
        end
    else
        for i := 0 to Ship.Size - 1 do
        begin
            FieldMatrix[X][Y + i] := Empty;
            FieldImage.Canvas.Draw(X * CellsSize, (Y + i) * CellsSize, EmptyCell);
        end;
    EmptyCell.Destroy;
    Dec(ShipsNumber);
end;

procedure TField.AutoPlacement(const Head: PListElem);
var
    Orientation: TOrientation;
    X, Y, RandNum: Integer;
    Ship: PListElem;
begin
    MakeCellsEmpty();
    ShipsNumber := 0;
    Ship := Head;
    while Ship.Next <> nil do
        Ship := Ship.Next;
    while Ship <> Head do
    begin
        repeat
            RandNum := Random(2);
            if RandNum = 0 then
            begin
                Orientation := Horizontal;
                X := Random(Length(FieldMatrix) - Ship.Size + 1);
                Y := Random(Length(FieldMatrix));
            end
            else
            begin
                Orientation := Vertical;
                Y := Random(Length(FieldMatrix) - Ship.Size + 1);
                X := Random(Length(FieldMatrix));
            end;
        until IsVacantPlace(X * CellsSize, Y * CellsSize, Ship.Size, Orientation);
        Ship.X := X * CellsSize;
        Ship.Y := Y * CellsSize;
        Ship.Orientation := Orientation;
        PlaceShip(Ship^);
        Ship := Ship.Prev;
    end;
end;

procedure TField.CoverCells(X, Y: Integer; IsHorizontal, IsCorner: Boolean);
var
    MissCell: TBitmap;
begin
    MissCell := TBitmap.Create;
    MissCell.LoadFromFile(MISS_CELL_IMAGE_PATH);
    if IsHorizontal then
    begin
        if Y <> 0 then
        begin
            FieldMatrix[X, Y - 1] := Miss;
            FieldImage.Canvas.Draw(X * CellsSize, (Y - 1) * CellsSize, MissCell);
        end;
        if Y <> High(FieldMatrix) then
        begin
            FieldMatrix[X, Y + 1] := Miss;
            FieldImage.Canvas.Draw(X * CellsSize, (Y + 1) * CellsSize, MissCell);
        end;
    end
    else
    begin
        if X <> 0 then
        begin
            FieldMatrix[X - 1, Y] := Miss;
            FieldImage.Canvas.Draw((X - 1) * CellsSize, Y * CellsSize, MissCell);
        end;
        if X <> High(FieldMatrix) then
        begin
            FieldMatrix[X + 1, Y] := Miss;
            FieldImage.Canvas.Draw((X + 1) * CellsSize, Y * CellsSize, MissCell);
        end;
    end;
    if IsCorner then
    begin
        FieldMatrix[X, Y] := Miss;
        FieldImage.Canvas.Draw(X * CellsSize, Y * CellsSize, MissCell);
    end;
end;

procedure TField.DestroyShip(X, Y: Integer; IsHorizontal: Boolean);
var
    i, j, StartX, StartY: Integer;
begin
    StartX := X;
    StartY := Y;
    i := -1;
    for j := 1 to 2 do
    begin
        while (X in [0..High(FieldMatrix)]) and (Y in [0..High(FieldMatrix)]) and
            (FieldMatrix[X, Y] = Hit) do
        begin
            CoverCells(X, Y, IsHorizontal, False);
            if IsHorizontal then
                X := X + i
            else
                Y := Y + i;
        end;
        if ((X in [0..High(FieldMatrix)])) and (Y in [0..High(FieldMatrix)]) then
            CoverCells(X, Y, IsHorizontal, True);
        X := StartX;
        Y := StartY;
        i := 1;
    end;
end;

procedure TField.HideShips();
var
    EmptyCell: TBitmap;
begin
    EmptyCell := TBitmap.Create;
    EmptyCell.LoadFromFile(EMPTY_CELL_IMAGE_PATH);
    for var i := 0 to High(FieldMatrix) do
        for var j := 0 to High(FieldMatrix) do
            FieldImage.Canvas.Draw(i * CellsSize, j * CellsSize, EmptyCell);
end;

procedure TField.ShowShips();
var
    ShipCell: TBitmap;
begin
    ShipCell := TBitmap.Create;
    ShipCell.LoadFromFile(SHIP_CELL_IMAGE_PATH);
    for var i := 0 to High(FieldMatrix) do
        for var j := 0 to High(FieldMatrix) do
            if FieldMatrix[i, j] = Ship then
                FieldImage.Canvas.Draw(i * CellsSize, j * CellsSize, ShipCell);
end;

procedure TField.DrawField();
var
    MissCell, HitCell: TBitmap;
begin
    MissCell := TBitmap.Create;
    MissCell.LoadFromFile(MISS_CELL_IMAGE_PATH);
    HitCell := TBitmap.Create;
    HitCell.LoadFromFile(HIT_CELL_IMAGE_PATH);
    for var i := 0 to High(FieldMatrix) do
        for var j := 0 to High(FieldMatrix) do
            if FieldMatrix[i, j] = Miss then
                FieldImage.Canvas.Draw(i * CellsSize, j * CellsSize, MissCell)
            else if FieldMatrix[i, j] = Hit then
                FieldImage.Canvas.Draw(i * CellsSize, j * CellsSize, HitCell);
end;

function TField.FindDirectionOfShip(X, Y: Integer; IsDamaged: Boolean): TDirection;
var
    ShipState: TCellState;
begin
    if IsDamaged then
        ShipState := Hit
    else
        ShipState := Ship;
    Result := None;
    if ((X <> 0) and (FieldMatrix[X - 1, Y] = ShipState)) or
        ((X <> High(FieldMatrix)) and (FieldMatrix[X + 1, Y] = ShipState)) then
        Result := dHorizontal
    else if (Y <> 0) and (FieldMatrix[X, Y - 1] = ShipState) or
        ((Y <> High(FieldMatrix)) and (FieldMatrix[X, Y + 1] = ShipState)) then
        Result := dVertical;
end;

function TField.IsDestroyed(X, Y: Integer; IsHorizontal: Boolean): Boolean;
var
    i, StartX, StartY: Integer;
    IsChecked, IsFirstTime, IsShipDestroyed: Boolean;
    Cell: TCellState;
begin
    IsShipDestroyed := False;
    StartX := X;
    StartY := Y;
    i := -1;
    IsFirstTime := True;
    IsChecked := False;
    while not IsChecked do
    begin
        Cell := FieldMatrix[X, Y];
        if IsHorizontal then
            X := X + i
        else
            Y := Y + i;
        if (Cell = Ship) then
        begin
            IsChecked := True;
            IsShipDestroyed := False;
        end
        else if (Cell = Empty) or (Cell = Miss) or not (X in [0..High(FieldMatrix)]) or
                not (Y in [0..High(FieldMatrix)]) then
            if IsFirstTime then
            begin
                i := 1;
                X := StartX;
                Y := StartY;
                IsFirstTime := False;
            end
            else
            begin
                IsChecked := True;
                IsShipDestroyed := True;
            end;
    end;
    Result := IsShipDestroyed;
end;

procedure TField.CheckIfShipDestroyed(X, Y: Integer);
var
    IsHorizontal: Boolean;
begin
    if (FindDirectionOfShip(X, Y, False) = None) then
    begin
        if FindDirectionOfShip(X, Y, True) = dHorizontal then
            IsHorizontal := True
        else
            IsHorizontal := False;
        if IsDestroyed(X, Y, IsHorizontal) then
        begin
            DestroyShip(X, Y, IsHorizontal);
            Dec(ShipsNumber);
        end;
    end;    
end;

function TField.Shoot(X, Y: Integer): Boolean;
var
    MissCell, HitCell: TBitmap;
begin
    X := X div CellsSize;
    Y := Y div CellsSize;
    Result := True;
    if FieldMatrix[X, Y] = Empty then
    begin
        MissCell := TBitmap.Create;
        MissCell.LoadFromFile(MISS_CELL_IMAGE_PATH);
        FieldMatrix[X, Y] := Miss;
        FieldImage.Canvas.Draw(X * CellsSize, Y * CellsSize, MissCell);
        MissCell.Destroy;
        Result := False;
    end
    else if FieldMatrix[X, Y] = Ship then
    begin
        HitCell := TBitmap.Create;
        HitCell.LoadFromFile(HIT_CELL_IMAGE_PATH);
        FieldMatrix[X, Y] := Hit;
        FieldImage.Canvas.Draw(X * CellsSize, Y * CellsSize, HitCell);
        HitCell.Destroy;
        CheckIfShipDestroyed(X, Y);
    end;
end;

function TField.FindDamagedShip: PPoint;
var
    IsNotFound: Boolean;
    i, j: Integer;
begin
    Result := nil;
    IsNotFound := True;
    i := 0;
    while (IsNotFound) and (i < Length(FieldMatrix)) do
    begin
        j := 0;
        while (IsNotFound) and (j < Length(FieldMatrix)) do
        begin
            if (FieldMatrix[i, j] = Hit) and (FindDirectionOfShip(i, j, False) <> None) then
            begin
                IsNotFound := False;
                New(Result);
                Result.X := i;
                Result.Y := j;
            end;
            Inc(j);
        end;
        Inc(i);
    end;
end;

function TField.FindShip: PPoint;
var
    IsNotFound: Boolean;
    i, j: Integer;
begin
    Result := nil;
    IsNotFound := True;
    i := 0;
    while (IsNotFound) and (i < Length(FieldMatrix)) do
    begin
        j := 0;
        while (IsNotFound) and (j < Length(FieldMatrix)) do
        begin
            if (FieldMatrix[i, j] = Ship) then
            begin
                IsNotFound := False;
                New(Result);
                Result.X := i;
                Result.Y := j;
            end;
            Inc(j);
        end;
        Inc(i);
    end;
end;

destructor TField.Destroy;
begin
    FieldImage.Destroy;
end;

end.
