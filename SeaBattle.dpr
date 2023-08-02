program SeaBattle;

uses
  Vcl.Forms,
  UnitGame in 'UnitGame.pas' {GameForm},
  Vcl.Themes,
  Vcl.Styles,
  UnitField in 'UnitField.pas',
  UnitMainMenu in 'UnitMainMenu.pas' {MainMenuForm},
  UnitSettings in 'UnitSettings.pas' {SettingsForm},
  UnitDeveloperInfo in 'UnitDeveloperInfo.pas' {DeveloperForm},
  UnitInstruction in 'UnitInstruction.pas' {InstructionForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Tablet Dark');
  Application.CreateForm(TMainMenuForm, MainMenuForm);
  Application.CreateForm(TGameForm, GameForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.CreateForm(TDeveloperForm, DeveloperForm);
  Application.CreateForm(TInstructionForm, InstructionForm);
  Application.Run;
end.
