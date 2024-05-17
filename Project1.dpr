program Project1;

{$R *.dres}

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit3 in 'Unit3.pas' {form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Dgt Server';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tform3, form3);
  Application.Run;
end.
