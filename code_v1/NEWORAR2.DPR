program neworar2;

uses
  Forms,
  dataU2 in 'dataU2.pas' {dataFRM},
  mainU2 in 'mainU2.pas' {mainFRM},
  selectU2 in 'selectU2.pas' {selectFRM},
  prefU2 in 'prefU2.pas' {prefFRM},
  resultU2 in 'resultU2.pas' {rezFRM},
  workU2 in 'workU2.pas' {workFRM},
  tipU2 in 'tipU2.pas' {tipFRM},
  errU2 in 'errU2.pas' {errFRM},
  p in 'p.pas',
  r in 'r.pas',
  fis in 'fis.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Orar Scolar';
  Application.HelpFile := 'c:\My Documents\orar.hlp';
  Application.CreateForm(TmainFRM, mainFRM);
  Application.Run;
end.
