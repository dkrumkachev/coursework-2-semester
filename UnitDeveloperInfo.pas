unit UnitDeveloperInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TDeveloperForm = class(TForm)
    NameLabel: TLabel;
    SpecialityLabel: TLabel;
    YearLabel: TLabel;
    ReturnButton: TButton;
    procedure ReturnButtonClick(Sender: TObject);
    procedure ReturnButtonKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DeveloperForm: TDeveloperForm;

implementation

{$R *.dfm}

procedure TDeveloperForm.ReturnButtonClick(Sender: TObject);
begin
    DeveloperForm.Close();
end;

procedure TDeveloperForm.ReturnButtonKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #27 then
        DeveloperForm.Close;
end;

end.
