program Konich;

uses
  Forms,
  Bob in 'Bob.pas' {Form1},
  SldWorks_TLB in '..\SWC\SldWorks_TLB.pas',
  SwConst_TLB in '..\SWC\SwConst_TLB.pas',
  Konich_bob in 'Konich_bob.pas',
  Konich_zub in 'Konich_zub.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
