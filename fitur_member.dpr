program fitur_member;

uses
  Forms,
  kustomer in 'kustomer.pas' {Form1},
  DataModule in 'DataModule.pas' {DataModule1: TDataModule},
  Report in 'Report.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
