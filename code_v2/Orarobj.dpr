program orarOBJ;

{%ToDo 'Orarobj.todo'}

uses
  Forms,
  OrrClass in 'OrrClass.pas',
  mainU in 'mainU.pas' {mainF},
  gen in 'gen.pas',
  procs in 'procs.pas',
  seleU in 'seleU.pas' {seleF},
  rezU in 'rezU.pas' {rezF},
  configU in 'configU.pas' {configF},
  tipU in 'tipU.pas' {tipF},
  errU in 'errU.pas' {errF},
  makeU in 'makeU.pas' {makeF},
  tipgen in 'tipgen.pas',
  dataU in 'dataU.pas' {dataF},
  SeleWin in 'SeleWin.pas',
  EdPanel in 'EdPanel.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Orar Scolar';
  Application.CreateForm(TmainF, mainF);
  Application.Run;
end.
