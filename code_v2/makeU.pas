unit makeU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls;

type
  TmakeF = class(TForm)
    makeAvi: TAnimate;
    secBar: TProgressBar;
    aniBar: TProgressBar;
    startB: TButton;
    okB: TButton;
    closeB: TButton;
    grupeBar: TProgressBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    profChk: TCheckBox;
    procedure closeBClick(Sender: TObject);
    procedure okBClick(Sender: TObject);
    procedure startBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
	makeF: TmakeF;

implementation
	uses OrrClass,mainU;
{$R *.DFM}
var OrarMake:TOrar;

procedure TmakeF.closeBClick(Sender: TObject);
begin
makeF.Release;makeF:=nil;
end;

procedure TmakeF.okBClick(Sender: TObject);
begin
Orar.Assign(OrarMake);
closeBClick(nil);
end;

procedure TmakeF.startBClick(Sender: TObject);
var err:integer;
begin
err:=OrarMake.Grups.Make;
if err<>0 then mainF.errMnClick(nil);
end;

procedure TmakeF.FormCreate(Sender: TObject);
begin
OrarMake:=TOrar.Create;OrarMake.Assign(Orar);
with OrarMake do begin
   Grups.secBar:=secBar;
   Grups.aniBar:=aniBar;
   Grups.grupeBar:=grupeBar;
   Grups.ShowMakeProgress:=True;
	end;
end;

end.
