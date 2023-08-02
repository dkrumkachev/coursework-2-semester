unit UnitInstruction;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TInstructionForm = class(TForm)
    NameLabel: TLabel;
    ReturnButton: TButton;
    YearLabel: TLabel;
    Label1: TLabel;
    procedure ReturnButtonClick(Sender: TObject);
    procedure ReturnButtonKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InstructionForm: TInstructionForm;

implementation

{$R *.dfm}

procedure TInstructionForm.ReturnButtonClick(Sender: TObject);
begin
    InstructionForm.Close;
end;

procedure TInstructionForm.ReturnButtonKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #27 then
        InstructionForm.Close;
end;

end.
