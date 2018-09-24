unit selectU2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolWin, ComCtrls, StdCtrls, checklst, ExtCtrls, Spin, Menus, Buttons;

type
  TselectFRM = class(TForm)
    Status: TStatusBar;
    matPan: TPanel;
    headPan: TPanel;
    butPan: TPanel;
    matList: TCheckListBox;
    okBut: TButton;
    CancelBut: TButton;
    matLab: TLabel;
    profPan: TPanel;
    profList: TListBox;
    profLab: TLabel;
    orePan: TPanel;
    oreList: TListBox;
    oreLab: TLabel;
    clasLab: TLabel;
    Panel1: TPanel;
    mprofiBut: TSpeedButton;
    mprofiL: TLabel;
    grup2But: TSpeedButton;
    grup2L: TLabel;
    grup1But: TSpeedButton;
    grup1L: TLabel;
    altePan: TPanel;
    clasPan: TPanel;
    clasList: TListBox;
    clasCombo: TComboBox;
    oregPan: TPanel;
    oreRad: TRadioGroup;
    oreEd: TEdit;
    oreSpin: TUpDown;
    butgPan: TPanel;
    closeBut: TButton;
    delBut: TButton;
    clasL: TLabel;
    grupPan: TPanel;
    grpL: TLabel;
    grupList: TListBox;
    grupEd: TEdit;
    cancBut: TButton;
    clasCmb: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure matListClick(Sender: TObject);
    procedure okButClick(Sender: TObject);
    procedure CancelButClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure modiFont;
    function MakeVar(Sender: TObject):boolean;
    procedure FormActivate(Sender: TObject);
    procedure alteButClick(Sender: TObject);
    procedure alteRefresh(Sender: TObject);
    procedure updateL(Sender: TObject);
    procedure updateLine(line,lineList,opt:integer);
    procedure grupEdKeyPress(Sender: TObject; var Key: Char);
    function addItem(var lista:TListBox;Val:string;max:integer):integer;
    procedure clasPanMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure clasPanMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure clasPanMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure clasCmbChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  selectFRM: TselectFRM;

implementation
  uses mainU2,
       p;
{$R *.DFM}

const
     _lungProf=maxchar-10;
     _lungMat=maxchar;
     _lungOre=4;sp=1;//spatiu
     dragX:integer=-1;
     dragY:integer=-1;
var
  _matI:array[1..maxclas,1..maxmat]of pIntTip;
  _profI:array[1..maxclas,1..maxmat]of pIntTip;
  _clasI:array[1..maxclas]of pIntTip;
  _oreI:array[1..maxclas,1..maxmat]of pIntTip;
  _matNr:array[1..maxclas]of pIntTip;
  _nrMprofi,_nrMgrup,_nrMclas,_nrMmat,_nrClasSel:integer;
  _Mprofi:array[1..maxclas*maxmat,0..maxMprofi]of pIntTip;
  _Mgrup:array[1..maxclas*maxmat,0..maxMgrup]of pSirTip;
  _Mclas:array[1..maxclas*maxmat,0..maxMclas]of pIntTip;
  _Mmat:array[1..maxclas*maxmat,1..maxMmat]of pIntTip;
  _ore:array[1..maxclas*maxmat]of pIntTip;
  FirstTime:boolean;
procedure setvar;forward;

{---------------------------------------------------}
procedure TselectFRM.FormResize(Sender: TObject);
var lung,lat:integer;
begin
if selectFRM=nil then exit;
selectFRM.width:=maxim(580,selectFRM.width);
selectFRM.height:=maxim(250,selectFRM.height);
lat:=trunc(selectFRM.width/2)-30;
lung:=selectFRM.Height-matpan.top-butpan.Height-status.Height;
matPan.width:=lat-4+150;profPan.Width:=lat-4-150;
matList.width:=lat-40+150;profList.width:=lat-40-150;
matList.Height:=lung-80;profList.Height:=lung-80;
oreList.Height:=lung-80;
end;
{-----------------------------------------------------}
procedure TselectFRM.okButClick(Sender: TObject);
begin
if not MakeVar(sender) then exit;
mainFRM.RefreshForms('selectFRM');
cancelButClick(sender);end;
{-----------------------------------------------------}
procedure FreeTemp;
var m,n:integer;
begin
for m:=1 to maxclas do begin ElibInt(_matNr[m]);ElibInt(_ClasI[m]);
    for n:=1 to maxmat do begin
        ElibInt(_matI[m,n]);ElibInt(_profI[m,n]);ElibInt(_oreI[m,n]);end;end;
for m:=1 to maxclas*maxmat do begin
    for n:=0 to maxMprofi do ElibInt(_Mprofi[m,n]);
    for n:=0 to maxMgrup do ElibSir(_Mgrup[m,n]);
    for n:=0 to maxMclas do ElibInt(_MClas[m,n]);
    for n:=1 to maxMmat do ElibInt(_Mmat[m,n]);
    ElibInt(_ore[m]);
    end;
end;
{-----------------------------------------------------}
procedure InitVar;
var i,j,k,line,grp,cls:integer;
begin
for i:=1 to nrclas do for j:=1 to nrmat do begin
    line:=(i-1)*(nrmat+1)+j;initSir(_Mgrup[line,0],'0');
    InitInt(_ore[line],0);initInt(_Mprofi[line,0],0);
    initInt(_Mclas[line,0],0);
    initInt(_Mmat[line,1],j);initInt(_Mmat[line,2],0);initInt(_Mmat[line,5],-1);
    end;
if nrclasSel<>0 then for i:=1 to nrclasSel do for j:=1 to matNr[i]^ do
   begin
   k:=matI[i,j]^;if k<0 then k:=Mmat[-k,1]^;
   line:=(clasI[i,1]^-1)*(nrmat+1)+k;
   initInt(_ore[line],oreI[i,j]^);
   if profI[i,j]^>0 then begin initInt(_Mprofi[line,0],1);
      initInt(_Mprofi[line,1],profI[i,j]^);end;
   if profI[i,j]^<0 then begin for k:=0 to Mprofi[-profI[i,j]^,0]^ do
          initInt(_Mprofi[line,k],Mprofi[-profI[i,j]^,k]^);
          initInt(_Mmat[line,2],1);end;
   if matI[i,j]^>0 then InitInt(_Mmat[line,1],matI[i,j]^);
   if matI[i,j]^<0 then begin
      for k:=1 to maxMmat do InitInt(_Mmat[line,k],Mmat[-matI[i,j]^,k]^);
      grp:=_Mmat[line,3]^;cls:=_Mmat[line,4]^;
      for k:=0 to strtoint(Mgrup[grp,0]^) do InitSir(_Mgrup[line,k],Mgrup[grp,k]^);
      if _MMat[line,2]^=3 then
         for k:=0 to Mclas[cls,0]^ do InitInt(_Mclas[line,k],Mclas[cls,k]^);
      end;
   end;
end;
{-----------------------------------------------------}
procedure TselectFRM.modiFont;
var F:TFont;
begin
F:=mainfrm.fontdlg.font;proflist.font:=F;orelist.font:=F;
clasList.font:=F;grupList.Font:=F;Status.Font.Charset:=F.Charset;
matlist.font.size:=f.size;matlist.font.style:=f.style;
matlist.font.Color:=f.color;matlist.font.Charset:=f.Charset;
matlist.ItemHeight:=abs(f.Height)+3;
end;
{---------------------------------------------------}
procedure TselectFRM.CancelButClick(Sender: TObject);
begin
FreeTemp;selectFRM.release;selectFRM:=nil;
end;
{---------------------------------------------------}
procedure TselectFRM.FormDestroy(Sender: TObject);
begin removeItem(winPos,'selectWin');end;
procedure TselectFRM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
cancelButClick(sender);
end;
{-----------------------------------------------------}
procedure TselectFRM.FormActivate(Sender: TObject);
var i,j,k,line:integer;
begin
defilare(selectFRM.Caption,selectFRM);
if not FirstTime then exit;
Enabled:=False;clasCombo.items.Clear;clasCmb.items.Clear;
for i:=1 to nrprof do profList.items.add(profN[i]^);
for i:=1 to nrclas do begin
    clasCmb.items.add(clasN[i]^);
    clasCombo.items.add(clasN[i]^);
    matList.items.add(umple(' ',8)+'Clasa '+clasN[i]^);
    if nrclasSel=0 then matlist.State[matList.items.count-1]:=cbChecked;
    for j:=1 to nrmat do matList.items.add(matN[j]^);end;
Application.ProcessMessages;
if nrclasSel<>0 then for i:=1 to nrclasSel do begin
   matlist.State[(clasI[i,1]^-1)*(nrmat+1)]:=cbChecked;
   for j:=1 to matNr[i]^ do begin
       k:=matI[i,j]^;if k<0 then k:=Mmat[-k,1]^;
       line:=(clasI[i,1]^-1)*(nrmat+1)+k;
       matList.itemindex:=line;updateL(nil);end;
   Status.SimpleText:='Asteptati ( '+inttostr(trunc(100*i/nrclassel))+' % )';
   Application.ProcessMessages;end;
matList.itemindex:=0;FirstTime:=False;matList.Visible:=True;
Enabled:=True;Status.SimpleText:='';clasCmb.itemindex:=0;
end;
{-----------------------------------------------------}
procedure TselectFRM.FormCreate(Sender: TObject);
begin
Width:=mainFRM.Width-border;Height:=mainFRM.Height-border;
modiFont;matList.clear;profList.clear;
InitVar;FirstTime:=True;FormResize(nil);matList.Visible:=False;
if Sender=mainFRM then FormActivate(nil);
end;
{---------------------------------------------------}
function TselectFRM.MakeVar(Sender: TObject):boolean;
var i,j,line,curClas,curMat,curProf,curOre:integer;
    mesaju:string;foundMat:boolean;
function proces(linie,clasa,materie:integer):boolean;
var m,n:integer;
begin Result:=true;
if _Mprofi[linie,0]^=0 then begin Result:=false;matList.itemindex:=linie;
   mesaju:='Lipsa profesor la clasa '+clasN[clasa]^+', '+matN[materie]^;
   Mesaj(mesaju,Mes_OK);exit;end;
if _ore[linie]^=0 then begin Result:=false;matList.itemindex:=linie;
   mesaju:='Lipsa numar ore la clasa '+clasN[clasa]^+', materia '+matN[materie]^;
   Mesaj(mesaju,Mes_ok);exit;end;
inc(curMat);
if (_Mmat[linie,2]^ in [0,1]) then InitInt(_matI[curClas,curMat],_Mmat[linie,1]^)
   else begin
   if (_Mmat[linie,2]^=2)or(_Mclas[linie,1]^=curClas) then begin
      inc(_nrMmat);InitInt(_matI[curClas,curMat],-_nrMmat);
      for m:=1 to maxMmat do initInt(_Mmat[_nrMmat,m],_Mmat[linie,m]^);
      if (_Mmat[linie,2]^=2)or(_Mclas[linie,1]^=curClas)then begin
         inc(_nrMGrup);for m:=0 to strtoint(_Mgrup[linie,0]^) do initSir(_Mgrup[_nrMgrup,m],_Mgrup[linie,m]^);
         InitInt(_Mmat[_nrMmat,3],_nrMgrup);end;
      case _Mmat[linie,2]^ of
      2: ;
      3: begin
         if _Mclas[linie,1]^=curClas then begin
            inc(_nrMclas);for m:=0 to _Mclas[linie,0]^do initInt(_Mclas[_nrMclas,m],_Mclas[linie,m]^);
            InitInt(_Mmat[_nrMmat,4],_nrMclas);
            end
         else for m:=1 to _nrMclas do
           if (_Mmat[m,1]^=_Mmat[linie,1]^)and(_Mmat[m,2]^=_Mmat[linie,2]^)then
              begin InitInt(_Mmat[_nrMmat,4],_Mmat[m,4]^);
                    InitInt(_Mmat[_nrMmat,3],_Mmat[m,3]^);break;end;
         end;
      end;//case
      end
   else begin InitInt(_MatI[curclas,curMat],0);
        for m:=1 to _nrMmat do begin
            for n:=1 to _Mclas[_Mmat[m,4]^,0]^ do
                if (_Mclas[_Mmat[m,4]^,n]^=curClas)and(_Mmat[m,1]^=_Mmat[linie,1]^)
               then begin InitInt(_matI[curClas,curMat],-m);
                    break;end;
            if not EgalInt(_MatI[curclas,curMat],0)then break;
            end;
        end;
   end;
inc(_matNr[CurClas]^);inc(curProf);
if _Mprofi[linie,0]^=1 then initInt(_profI[curClas,curProf],_Mprofi[linie,1]^)
   else begin inc(_nrMprofi);initInt(_profI[curClas,curProf],-_nrMprofi);
   for m:=0 to _Mprofi[linie,0]^ do InitInt(_Mprofi[_nrMprofi,m],_Mprofi[linie,m]^);
   end;
inc(curOre);InitInt(_oreI[curClas,curMat],_ore[linie]^);
end;

begin Result:=false;
nrMmat:=0;nrMgrup:=0;nrMclas:=0;
curClas:=0;_nrClasSel:=0;_nrMprofi:=0;_nrMmat:=0;_nrMgrup:=0;_nrMclas:=0;
for i:=1 to nrclas do begin
    if matList.Checked[(i-1)*(nrmat+1)] then
       begin curMat:=0;curProf:=0;curOre:=0;
       inc(curClas);InitInt(_matNr[curClas],0);inc(_nrClasSel);
       InitInt(_clasI[curClas],i);foundMat:=false;
       for j:=1 to nrmat do begin
           line:=(i-1)*(nrmat+1)+j;
           if matList.Checked[line]then begin foundMat:=true;
              if not proces(line,i,j)then exit;end;end;
       if not foundMat then begin
          matlist.itemindex:=(i-1)*(nrmat+1);
          messageDlg('Clasa '+clasN[i]^+' nu are selectata nici o materie !',
          mtwarning,[mbOk],0);exit;end;
       end;
    end;
setvar;MakeOreZi(NrZile);
workrez:=255;Result:=true;
end;
{---------------------------------------------------}
procedure setvar;
var i,j,k:integer;
begin
nrclasSel:=_nrclasSel;
nrMprofi:=_nrMprofi;nrMgrup:=_nrMgrup;nrMclas:=_nrMclas;nrMmat:=_nrMmat;
for i:=1 to nrMprofi do for j:=0 to _Mprofi[i,0]^ do
    initInt(Mprofi[i,j],_Mprofi[i,j]^);
for i:=1 to nrMgrup do for j:=0 to strtoint(_Mgrup[i,0]^) do
    initSir(Mgrup[i,j],_Mgrup[i,j]^);
for i:=1 to nrMclas do for j:=0 to _Mclas[i,0]^ do
    initInt(Mclas[i,j],_Mclas[i,j]^);
for i:=1 to nrMmat do for j:=1 to maxMmat do
    initInt(Mmat[i,j],_Mmat[i,j]^);
for i:=1 to _nrClasSel do begin
    initInt(clasI[i,1],_clasI[i]^);initInt(matNr[i],_matNr[i]^);
    for j:=1 to _matNr[i]^ do begin initInt(matI[i,j],_matI[i,j]^);
        initInt(profI[i,j],_profI[i,j]^);initInt(oreI[i,j],_oreI[i,j]^);end;
    end;
for i:=1 to maxCond do begin
    initInt(cond[i,1],1);initInt(cond[i,2],0);end;
initInt(cond[7,1],0);
for i:=1 to maxclas do for j:=1 to maxzile do
    for k:=1 to maxore do begin initInt(matR[i,j,k],0);
        initInt(profR[i,j,k],0);end;
if oremat[1,1]=nil then for i:=1 to nrmat do initInt(oremat[i,1],1);
if sali[1]=nil then for i:=1 to maxmat do initInt(sali[i],-1);
end;
{---------------------------------------------------}
procedure getClasMat(var Clas,Mat,line:integer);
begin
Clas:=1+trunc(line/(nrmat+1));Mat:=line-(Clas-1)*(nrmat+1);
end;
procedure TselectFRM.matListClick(Sender: TObject);
begin
clasLab.Caption:='Clasa '+clasN[1+trunc(matList.itemindex/(nrmat+1))]^;
if altePan.Visible then begin matList.Itemindex:=matPan.Tag;
   closeBut.Onclick(closeBut);end;
if not altePan.Visible then matList.Tag:=0;
Status.SimpleText:=matList.Items.Strings[matList.itemindex];
end;
procedure TselectFRM.alteButClick(Sender: TObject);
begin
if (trunc(matList.itemindex/(nrmat+1))=matList.itemindex/(nrmat+1))
   or(matList.itemindex=-1)or(altePan.Visible)then exit;
if sender=matlist then begin
   matList.Tag:=_Mmat[matlist.itemindex,2]^;
   if _Mmat[matlist.itemindex,2]^=0 then exit;end
else matList.Tag:=Tcomponent(sender).tag;
matPan.Tag:=matList.itemindex;alteRefresh(sender);
end;

function DelLine(line,tip:integer):boolean;
var i,j:integer;
begin Result:=True;
if _Mmat[line,2]^=0 then exit;
if mesaj('Datele la aceasta materie se vor pierde. Continuam ?',Mes_YN)=Mes_No
   then begin Result:=False;exit;end else case _MMat[line,2]^ of
     1: begin InitInt(_Mprofi[line,0],0);InitInt(_ore[line],0);end;
     2: begin InitSir(_Mgrup[line,0],'0');InitInt(_Mprofi[line,0],0);InitInt(_ore[line],0);end;
     3: begin InitInt(_ore[line],0);InitInt(_Mprofi[line,0],0);
        for i:=1 to _Mclas[line,0]^ do with selectFRM do begin
        j:=(i-1)*(nrmat+1)+_Mmat[line,1]^;InitSir(_Mgrup[line,0],'0');
        InitInt(_Mprofi[j,0],0);InitInt(_ore[j],0);
        initInt(_Mmat[j,2],0);updateLine(j,-1,0);
        matList.state[j]:=cbUnchecked;end;
        initInt(_Mclas[line,0],0);end;
     end;//case
end;
{---------------------------------------------------}
procedure TselectFRM.alteRefresh(Sender: TObject);
var Clas,Mat,line,line2,i,j:integer;
begin
line:=matList.Itemindex;if line=-1 then exit;
getClasMat(Clas,Mat,line);i:=TComponent(Sender).Tag;
if i<10 then matList.Tag:=i;
case i of
     0:;//nimic
     1: begin grupPan.Visible:=False;clasPan.Visible:=True;oregPan.Visible:=false;
        clasCombo.visible:=false;clasL.Caption:='Profesori';
        if (not EgalInt(_Mmat[line,2],i))and((matList.Tag<>0)or(_Mprofi[line,0]^<>1))
           then if not DelLine(line,1) then exit;
        clasList.items.Clear;
        for i:=1 to _Mprofi[line,0]^ do clasList.items.Add(profN[_Mprofi[line,i]^]^);
        altePan.Width:=200;altePan.Visible:=True;
        end;
     2: begin grupPan.Visible:=True;clasPan.Visible:=False;oregPan.Visible:=true;
        if not EgalInt(_Mmat[line,2],i) then if not DelLine(line,2) then exit;
        grupList.items.clear;grpL.caption:='Grupe';
        for i:=1 to strtoint(_Mgrup[line,0]^) do grupList.items.Add(_Mgrup[line,i]^);
        if (_Mmat[line,5]=nil)or(_Mmat[line,5]^<1) then oreRad.ItemIndex:=0
           else begin oreRad.ItemIndex:=1;oreSpin.Position:=_Mmat[line,5]^;end;
        altePan.Width:=300;altePan.Visible:=True;
        end;
     3: begin grupPan.Visible:=True;clasPan.Visible:=True;oregPan.Visible:=false;
        clasCombo.visible:=true;clasL.Caption:='Clase';grpL.caption:='Grupe, profesori';
        clasList.items.Clear;grupList.Items.Clear;
        if not EgalInt(_Mmat[line,2],i) then if not DelLine(line,3) then exit;
        for i:=1 to strtoint(_Mgrup[line,0]^) do
           grupList.items.Add(_Mgrup[line,i]^+'  '+profN[_Mprofi[line,i]^]^);
        for i:=1 to _Mclas[line,0]^ do clasList.Items.Add(clasN[_Mclas[line,i]^]^);
        if clasList.items.count=0 then with clasCombo do
           begin itemindex:=clas-1;updateL(clasCombo);end;
        altePan.Width:=300;altePan.Visible:=True;end;
     10: begin //inchide
         case matList.Tag of
          1: if _Mprofi[line,0]^=0 then matList.Tag:=0;
          2: begin
             InitInt(_Mmat[line,1],mat);
             for i:=3 to 4 do InitInt(_Mmat[line,i],0);
             if oreRad.itemindex=0 then InitInt(_Mmat[line,5],-1)
                else InitInt(_Mmat[line,5],oreSpin.Position);
             if strtoint(_Mgrup[line,0]^)=0 then begin
                matList.Tag:=0;initInt(_Mprofi[line,0],0);end;
             end;
          3: begin
            InitInt(_Mmat[line,1],mat);initInt(_Mmat[line,2],3);
            initInt(_Mprofi[line,0],strtoint(_MGrup[line,0]^));
            for i:=1 to strtoint(_MGrup[line,0]^) do if (_Mprofi[line,i]=nil)then
                begin mesaj('Lipsa Profesor',Mes_Ok);exit;end;
            if strtoint(_MGrup[line,0]^)<>0 then begin
               if (_Mclas[line,0]^=0)then begin mesaj('Lipsa clasa',Mes_Ok);exit;end;
               end else begin
                   if (_Mclas[line,0]^>1)then begin mesaj('Lipsesc grupele ',Mes_Ok);exit;end;
                   matList.Tag:=0;end;
            for i:=3 to 5 do InitInt(_Mmat[line,i],0);
            for i:=1 to _Mclas[line,0]^ do begin
                line2:=(_Mclas[line,i]^-1)*(nrmat+1)+mat;
               if line<>line2 then begin
                initint(_ore[line2],_ore[line]^);
                for j:=1 to maxMmat do initInt(_Mmat[line2,j],_Mmat[line,j]^);
                for j:=0 to _Mprofi[line,0]^ do initInt(_Mprofi[line2,j],_Mprofi[line,j]^);
                for j:=0 to _Mclas[line,0]^ do initInt(_Mclas[line2,j],_Mclas[line,j]^);
                for j:=0 to strtoint(_Mgrup[line,0]^) do initSir(_Mgrup[line2,j],_Mgrup[line,j]^);
                updateLine(line2,-1,0);
               end;
                end;
            end;
         end;//case
         initInt(_Mmat[line,2],matList.Tag);altePan.Visible:=False;
         updateL(nil);matList.Tag:=0;end;
     11: begin //ok
         initInt(_Mprofi[line,0],0);initInt(_Mclas[line,0],0);initSir(_Mgrup[line,0],'0');
         grupList.items.clear;clasList.items.clear;
         with clasCombo do begin itemindex:=clas-1;updateL(clasCombo);end;
         updateL(nil);
         end;
     12: begin //cancel

         end;
end;//case
end;
{---------------------------------------------------}
procedure TselectFRM.updateLine;
var lineMat,indClas,indMat:integer;
    materie,profesor,ore,s:string;
function prof:boolean;
var i,lineGrup:integer;s1:string;
begin Result:=False;
case matList.Tag of
     0,2: begin if _Mmat[lineMat,2]^=3 then if not DelLine(lineMat,3) then exit;
        profesor:=profN[lineList]^;InitInt(_Mprofi[lineMat,0],1);
        InitInt(_Mprofi[lineMat,1],lineList);
        if (_Mmat[lineMat,2]^<>2)then initInt(_Mmat[lineMat,2],0);
        end;
     1: begin
        if addItem(clasList,profN[lineList]^,maxMprofi)<>0 then exit;
        i:=_Mprofi[lineMat,0]^+1;initInt(_Mprofi[lineMat,0],i);
        InitInt(_Mprofi[lineMat,i],lineList);end;
     3: begin lineGrup:=grupList.itemindex+1;if lineGrup=0 then exit;
        initInt(_Mprofi[lineMat,lineGrup],lineList);
        s1:=_Mgrup[lineMat,lineGrup]^+'  '+profN[_Mprofi[lineMat,lineGrup]^]^;
        grupList.Items.strings[lineGrup-1]:=s1;grupList.itemindex:=lineGrup;end;
end;//case
Result:=True;end;
procedure orele;
var i,lin:integer;
begin
if (_Mmat[LineMat,2]^=3)then begin
   for i:=1 to _Mclas[lineMat,0]^ do begin
       lin:=(_Mclas[lineMat,i]^-1)*(nrmat+1)+indMat;
       initInt(_ore[lin],lineList);updateLine(lin,-1,0);
       end;
   end;
if (_Mmat[LineMat,2]^<>3)then initInt(_ore[lineMat],lineList);
end;
function clase:boolean;
var i:integer;
begin Result:=false;if clasCombo.Itemindex=-1 then exit;
if addItem(clasList,clasCombo.Text,maxMclas)<>0 then exit;
i:=_Mclas[lineMat,0]^+1;initInt(_Mclas[lineMat,0],i);
InitInt(_Mclas[lineMat,i],clasCombo.itemindex+1);Result:=true;
end;
begin
lineMat:=Line;getClasMat(indClas,indMat,lineMat);
if (indMat=0)then exit;
if opt=1 then clase;
if (opt=2)and(not prof)then exit;
if _Mprofi[lineMat,0]^=0 then profesor:='' else
   if _Mprofi[lineMat,0]^=1 then profesor:=profN[_Mprofi[lineMat,1]^]^ else
      profesor:='('+inttostr(_Mprofi[lineMat,0]^)+' profesori)';
if opt=3 then orele;
ore:=inttostr(_ore[lineMat]^)+' h';
if ore='0 h'then ore:='';
materie:=matN[indMat]^;
if (_Mmat[lineMat,2]^<>0)then materie:=materie+'/'+inttostr(_Mmat[lineMat,2]^);
profesor:=truncStr(profesor,_lungProf);materie:=truncStr(materie,_lungMat);
s:= materie+umple(' ',sp+_lungMat-length(materie))+
    profesor+umple(' ',sp+_lungProf-length(profesor))+ore;
matList.Items.Strings[lineMat]:=s;
matList.State[lineMat]:=cbChecked;
if (profesor<>'')and(_ore[lineMat]^<>0)and(not altePan.visible)and(opt<>0)then
   matList.Itemindex:=lineMat+1;
end;
{---------------------------------------------------}
procedure TselectFRM.updateL(Sender:TObject);
var line,lineList,opt:integer;
begin
opt:=0;line:=matList.Itemindex;if line=-1 then exit;
if sender is TListBox then lineList:=TListBox(Sender).itemindex+1 else lineList:=0;
if sender=clasCombo then opt:=1;
if sender=profList then opt:=2;
if sender=oreList then opt:=3;
updateLine(line,lineList,opt);
end;
{---------------------------------------------------}
procedure TselectFRM.grupEdKeyPress(Sender: TObject; var Key: Char);
var i,line:integer;
begin
if key=#13 then begin
   if matList.Tag in [2,3]then begin
      if addItem(grupList,grupEd.Text,maxMgrup)<>0 then exit;
      line:=matList.itemindex;i:=1+strtoint(_Mgrup[line,0]^);
      initSir(_Mgrup[line,0],inttostr(i));initSir(_Mgrup[line,i],grupEd.text);
      grupEd.Text:='';end;
   end;
end;
{---------------------------------------------------}
function TselectFRM.addItem(var lista:TListBox;Val:string;max:integer):integer;
var i:integer;
begin
Result:=1;for i:=1 to lista.items.count do if val=lista.items.strings[i-1]then exit;
Result:=2;if lista.items.count=max then exit;
lista.items.Add(Val);Result:=0;
end;
{---------------------------------------------------}
procedure TselectFRM.clasPanMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin if (dragX<0)or(dragY<0)then exit;
altePan.Left:=altePan.Left+(X-dragX);altePan.Top:=altePan.Top+(Y-dragY);
matPan.refresh;altePan.refresh;end;
procedure TselectFRM.clasPanMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin dragX:=X;dragY:=Y;end;
procedure TselectFRM.clasPanMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin dragX:=-1;dragY:=-1;
with altePan do begin left:=maxim(left,0);left:=minim(left,matPan.width-100);
     top:=maxim(top,0);top:=minim(top,matPan.Height-100);end;
end;

procedure TselectFRM.clasCmbChange(Sender: TObject);
begin
if clasCmb.Items.Count=0 then exit;
with matlist do begin
     TopIndex:=(clasCmb.itemindex)*(nrmat+1);
     ItemIndex:=topindex;
     onclick(nil);end;
//clasLab.Caption:='Clasa '+clasN[1+trunc(matList.itemindex/(nrmat+1))]^;
end;



END.
