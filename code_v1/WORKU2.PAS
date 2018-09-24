unit workU2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons;

type
  TworkFRM = class(TForm)
    clasBar: TProgressBar;
    cancelBut: TButton;
    BtimeLab: TLabel;
    EtimeLab: TLabel;
    startBut: TButton;
    optimCheck: TCheckBox;
    MetodCheck: TCheckBox;
    otherBar: TProgressBar;
    okB: TButton;
    ordChk: TCheckBox;
    procedure FormCreate(Sender: TObject);
    function MakeOrar1:byte;
    procedure InitTemp;
    procedure startButClick(Sender: TObject);
    procedure cancelButClick(Sender: TObject);
    procedure DoneOrar;
    procedure Optimizare;
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure okBClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  workFRM: TworkFRM;
  ziPut,oraPut:integer;

implementation

uses mainU2,resultU2,errU2,p,r;

{$R *.DFM}
var
  _workRez:integer;

{-----------------------------------------------------}
procedure TworkFRM.FormCreate(Sender: TObject);
var i,j:integer;
begin
width:=clasBar.Width+clasBar.left+20;
height:=startBut.Top+startBut.Height+20+20;
top:=trunc((mainFRM.height-height-50)/2);
left:=trunc((mainFRM.width-width)/2);
j:=0;
for i:=1 to nrmat do j:=maxim(j,oremat[i,1]^);
if (cond[3,1]^=0)or(j=1)then optimCheck.Checked:=true;
end;
{-----------------------------------------------------}
procedure TworkFRM.InitTemp;
var i,j,k:integer;
begin
for i:=1 to nrclasSel do for j:=1 to maxzile do for k:=1 to maxore do
    begin
    if _matR[i,j,k]=nil then new(_matR[i,j,k]);_matR[i,j,k]^:=0;
    if _profR[i,j,k]=nil then new(_profR[i,j,k]);_profR[i,j,k]^:=0;
    end;
for i:=1 to NrClasSel do for j:=1 to matNr[i]^ do begin
    initInt(_matI[i,j],matI[i,j]^);initInt(_profI[i,j],profI[i,j]^);
    initInt(_oreI[i,j],oreI[i,j]^);initInt(_restOre[i,j],_oreI[i,j]^);
    end;
end;
{-----------------------------------------------------}
procedure TworkFRM.Optimizare;
var i,j,k:integer;
    temp:integer;
begin
for i:=1 to nrclasSel do for j:=1 to MatNr[i]^-1 do
    for k:=j+1 to MatNr[i]^ do if _oreI[i,k]^>_oreI[i,j]^ then begin
    temp:=_matI[i,j]^;_matI[i,j]^:=_matI[i,k]^;_matI[i,k]^:=temp;
    temp:=_profI[i,j]^;_profI[i,j]^:=_profI[i,k]^;_profI[i,k]^:=temp;
    temp:=_oreI[i,j]^;_oreI[i,j]^:=_oreI[i,k]^;_oreI[i,k]^:=temp;
    temp:=_restore[i,j]^;_restore[i,j]^:=_restore[i,k]^;_restore[i,k]^:=temp;
    end;
end;
{----------------------MAKE-------------------------------}
function TworkFRM.MakeOrar1:byte;
var indClas,i,j,k,lastCond,pas:integer;_cond:array[1..maxcond]of integer;
begin
makeOrar1:=0;rez.InitVar;lastCond:=7;
for i:=1 to maxcond do _cond[i]:=cond[i,1]^;
if cond[8,1]^=1 then k:=nrcond else k:=1;
try
for i:=1 to k do if i<>8 then begin
    if ordChk.Checked then begin indClas:=NrClasSel;pas:=-1;end
       else begin indClas:=1;pas:=1;end;
    repeat
    workFRM.Caption:='Creare orar   '+clasN[clasI[indClas,1]^]^;
    Application.ProcessMessages;
    if startBut.tag=1 then begin makeOrar1:=1;exit;end;
    rez.PutAllMat(indClas,i);
    if i=1 then clasBar.Position:=indclas
       else otherBar.Position:=indClas;
    inc(indClas,pas);
    until (indClas>NrClasSel)or(indClas=0);
for j:=1 to maxCond do if cond[j,2]^=lastCond then begin
    dec(lastCond);if j<>5 then cond[j,1]^:=0;
    end;
end;//for
finally for i:=1 to maxcond do initInt(cond[i,1],_cond[i]);
if startBut.tag=0 then rez.verifica(0,Ver_List);end;
end;
{-----------------------------------------------------}
procedure FillZero;
var i,j:integer;
begin
for i:=1 to nrclas do for j:=1 to maxzile do
    if oreZi[i,j]=nil then begin
       new(oreZi[i,j]);oreZi[i,j]^:=0;end;
end;
{-----------------------------------------------------}
procedure TworkFRM.startButClick(Sender: TObject);
begin
if startBut.caption='S&top' then begin startBut.tag:=1;exit;end;
if startBut.caption='&Start' then begin
okB.Enabled:=false;
errList0.Clear;if errFRM<>nil then errFRM.errList.Items.Clear;
cancelBut.enabled:=false;startBut.tag:=0;
startBut.caption:='S&top';InitTemp;
if optimCheck.Checked then Optimizare;
if not DoOreZi then makeOreZi(NrZile);
FillZero;
BtimeLab.caption:='Start at:   '+ DateTimeToStr(Now);
with clasBar do begin min:=0;max:=nrClasSel;position:=0;end;
with otherBar do begin Max:=nrClasSel;position:=0;end;
application.ProcessMessages;
if metodCheck.Checked then _WorkRez:=makeOrar1;
EtimeLab.caption:='End  at:   '+ DateTimeToStr(Now);
cancelBut.enabled:=true;
if _workRez<>0 then begin
   WorkFRM.caption:='Orar neterminat !';
   if messageDlg('Doriti sa lucrati cu orarul neterminat ?',mtconfirmation,
      [mbYes,mbNo],1)=idYes then begin _workrez:=0;startBut.caption:='&OK';end
   else startBut.caption:='&Start';
   exit;end;
workFRM.caption:='Creare orar';
startBut.caption:='&Start';okB.Enabled:=true;
end;
end;
{-----------------------------------------------------}
procedure TworkFRM.DoneOrar;
var i,j,k:integer;
begin
if _workRez<>0 then begin cancelButClick(nil);exit;end;
for i:=1 to nrClasSel do for j:=1 to maxzile do for k:=1 to maxore do
    begin InitInt(matR[i,j,k],_matR[i,j,k]^);
    InitInt(profR[i,j,k],_profR[i,j,k]^);end;
workRez:=_workRez;
mainFRM.RefreshForms('workFRM');
cancelButClick(nil);
end;
{-----------------------------------------------------}
procedure TworkFRM.cancelButClick(Sender: TObject);
begin
if (rezFRM<>nil)and(rezFRM.isedit=0) then rez.FreeTemp;
workFRM.release;workFRM:=nil;
end;
procedure TworkFRM.FormDestroy(Sender: TObject);
begin
removeItem(winPos,'workWin');
end;
procedure TworkFRM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
cancelButClick(sender);
end;
{-----------------------------------------------------}
procedure TworkFRM.FormActivate(Sender: TObject);
begin
defilare(workFRM.Caption,workFRM);
end;

procedure TworkFRM.okBClick(Sender: TObject);
begin
doneorar;
end;

end.
