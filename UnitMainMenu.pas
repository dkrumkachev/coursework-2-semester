unit UnitMainMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus, Vcl.MPlayer,
  Vcl.ExtCtrls;

type
  TMainMenuForm = class(TForm)
    SinglePlayerButton: TButton;
    TwoPlayersButton: TButton;
    SettingsButton: TButton;
    ContinueButton: TButton;
    MainMenu: TMainMenu;
    InstructionMenu: TMenuItem;
    DeveloperMenu: TMenuItem;
    NameLabel: TLabel;
    procedure SinglePlayerButtonClick(Sender: TObject);
    procedure SettingsButtonClick(Sender: TObject);
    procedure TwoPlayersButtonClick(Sender: TObject);
    procedure ContinueButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DeveloperMenuClick(Sender: TObject);
    procedure InstructionMenuClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainMenuForm: TMainMenuForm;
  IsContinueBtnPressed: Boolean;

implementation

{$R *.dfm}

uses UnitGame, UnitSettings, UnitDeveloperInfo, UnitInstruction;

procedure StartSinglePlayerGame();
begin
    MainMenuForm.Hide;
    UnitGame.TwoPlayersMode := False;
    GameForm.Show;
end;

procedure StartMultiPlayerGame();
begin
    MainMenuForm.Hide;
    UnitGame.TwoPlayersMode := True;
    GameForm.Show;
end;

procedure TMainMenuForm.ContinueButtonClick(Sender: TObject);
begin
    IsContinueBtnPressed := True;
    MainMenuForm.Hide;
    GameForm.Show;
end;

procedure TMainMenuForm.DeveloperMenuClick(Sender: TObject);
begin
    DeveloperForm.Show;
end;

procedure TMainMenuForm.FormActivate(Sender: TObject);
begin
    IsContinueBtnPressed := False;
end;

procedure TMainMenuForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    if Application.MessageBox('Вы действительно хотите выйти?', 'Выход', MB_YESNO) = IDYES then
        CanClose := True
    else
        CanClose := False;
end;

procedure TMainMenuForm.FormCreate(Sender: TObject);
begin
    NameLabel.Left := (ClientWidth - NameLabel.Width) div 2;
    SinglePlayerButton.Left := (ClientWidth - SinglePlayerButton.Width) div 2;
    TwoPlayersButton.Left := (ClientWidth - TwoPlayersButton.Width) div 2;
    ContinueButton.Left := (ClientWidth - ContinueButton.Width) div 2;
    SettingsButton.Left := (ClientWidth - SettingsButton.Width) div 2;
end;

procedure TMainMenuForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_F1 then
        InstructionForm.Show
    else if Key = VK_F2 then
        DeveloperForm.Show;
end;

procedure TMainMenuForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #27 then
        Close;
end;

procedure TMainMenuForm.FormShow(Sender: TObject);
begin
    if FileExists(GAME_FILE_PATH) then
        MainMenuForm.ContinueButton.Enabled := True
    else
        MainMenuForm.ContinueButton.Enabled := False;
end;

procedure TMainMenuForm.InstructionMenuClick(Sender: TObject);
begin
    InstructionForm.Show;
end;

procedure TMainMenuForm.SettingsButtonClick(Sender: TObject);
begin
    SettingsForm.ShowModal;
end;

procedure TMainMenuForm.SinglePlayerButtonClick(Sender: TObject);
begin
    StartSinglePlayerGame();
end;

procedure TMainMenuForm.TwoPlayersButtonClick(Sender: TObject);
begin
    StartMultiPlayerGame();
end;

end.
