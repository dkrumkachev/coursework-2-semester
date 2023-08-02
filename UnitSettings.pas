unit UnitSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls;

type
  TSettingsForm = class(TForm)
    SizeLabel: TLabel;
    TextLabel: TLabel;
    RadioButton10: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton12: TRadioButton;
    DifficultyLabel: TLabel;
    DifficultyTrackBar: TTrackBar;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;
  FieldSize, Difficulty: Integer;

implementation

{$R *.dfm}

uses UnitMainMenu;

procedure TSettingsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if RadioButton8.Checked then
        FieldSize := 8
    else if RadioButton10.Checked then
        FieldSize := 10
    else if RadioButton12.Checked then
        FieldSize := 12;
    Difficulty := DifficultyTrackBar.Position;
end;


procedure TSettingsForm.FormCreate(Sender: TObject);
begin
    FieldSize := 10;
    Difficulty := 1;
    DifficultyTrackBar.Position := 1;
end;

procedure TSettingsForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #27 then
        SettingsForm.Close;
end;

end.
