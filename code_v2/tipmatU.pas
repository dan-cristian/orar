unit tipmatU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TtipmatF = class(TForm)
    richPan: TPanel;
    Rich: TRichEdit;
    headP: TPanel;
    refreshB: TButton;
    closeB: TButton;
    princRad: TRadioGroup;
    procedure refreshBClick(Sender: TObject);
    procedure closeBClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DispMat;
    procedure DispProf;
    procedure DispErr;
  end;

var
  tipmatF: TtipmatF;

implementation
  uses tipgen,procs,mainU;
{$R *.DFM}

procedure TtipmatF.closeBClick(Sender: TObject);
begin
tipmatF.Release;tipmatF:=nil;
end;

procedure TtipmatF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
closeBClick(nil);
end;

procedure TtipmatF.refreshBClick(Sender: TObject);
begin
case princRad.ItemIndex of
   0: DispMat;
   1: DispProf;
   2,3,4: DispErr;
	end;
end;

procedure TtipmatF.DispMat;
const
	mat:array[1..6]of string=
   	('Cod materie','Denumire','Tip materie','Ore consecutive',
       'Grad dificultate','Nr. sali');
var indmat,i:integer;s:string;
	matL:array[1..6]of integer;
begin
Rich.Clear;
writeTitle(Orar,Rich);s:='';
with Orar.Grups do begin
matL[1]:=length(mat[1])+1;
matL[2]:=maxim(length(mat[2]),Mats.Items.MaxLength)+1;
matL[3]:=length(mat[3])+1;
matL[4]:=length(mat[4])+1;
matL[5]:=length(mat[5])+1;
matL[6]:=length(mat[6])+1;
for i:=1 to 6 do s:=s+Adjuststr(mat[i],matL[i]);
Rich.Lines.Add(s);
s:=umple('—',length(s));Rich.Lines.Add(s);
for indmat:=1 to Mats.Items.Count do begin
   s:=inttostr(Mats.Items[indmat].Cod);
   s:=AdjustStr(s,matL[1]);
   with Mats.Items[indmat] do begin
   	s:=s+AdjustStr(Val,matL[2]);
   	s:=s+AdjustStr(inttostr(Tip),matL[3]);
   	s:=s+AdjustStr(inttostr(MOreCons),matL[4]);
   	s:=s+AdjustStr(inttostr(MGradDif),matL[5]);
//   	s:=s+AdjustStr(inttostr(MNrSali),matL[6]);
      end;
   Rich.Lines.Add(s);
	end;
end;//with
end;

procedure TtipmatF.DispProf;
const
	prof:array[1..3]of string=
   	('Cod profesor','Nume','Total ore');
var indprof,i:integer;s:string;
	profL:array[1..3]of integer;
begin
Rich.Clear;
writeTitle(Orar,Rich);s:='';
with Orar.Grups do begin
profL[1]:=length(prof[1])+1;
profL[2]:=maxim(length(prof[2]),Profs.Items.MaxLength)+1;
profL[3]:=length(prof[3])+1;
for i:=1 to 3 do s:=s+Adjuststr(prof[i],profL[i]);
Rich.Lines.Add(s);
s:=umple('—',length(s));Rich.Lines.Add(s);
for indprof:=1 to Profs.Items.Count do begin
   s:=inttostr(Profs.Items[indprof].Cod);
   s:=AdjustStr(s,profL[1]);
   with Profs do begin
   	s:=s+AdjustStr(Items[indprof].Val,profL[2]);
      s:=s+AdjustStr(inttostr(GetTotalOreProf(Items.IndexToCod(indProf))),profL[3]);
      end;
   Rich.Lines.Add(s);
	end;
end;//with
end;

procedure TtipmatF.DispErr;
begin
MessageDlg('Nu aveti date suficiente date pentru a obtine situatia',mtWarning,[mbOk],0);
end;

end.
