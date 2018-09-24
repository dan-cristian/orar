unit prefU2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Spin, Grids, Buttons;

type
  TprefFRM = class(TForm)
    optionsPage: TPageControl;
    genTab: TTabSheet;
    ProfTab: TTabSheet;
    matTab: TTabSheet;
    ClasTab: TTabSheet;
    prefGrid: TStringGrid;
    profCombo: TComboBox;
    profLab1: TLabel;
    matListM: TListBox;
    matLab1: TLabel;
    salaRadio: TRadioGroup;
    consecGroup: TGroupBox;
    saliStatic: TStaticText;
    condTab: TTabSheet;
    condGroup: TGroupBox;
    caractEd: TEdit;
    caractLab: TLabel;
    startGroup: TGroupBox;
    zileLab: TLabel;
    startLab: TLabel;
    clasCombo: TComboBox;
    ZileGroup: TGroupBox;
    luniLab: TLabel;
    MartiLab: TLabel;
    MiercLab: TLabel;
    JoiLab: TLabel;
    VineriLab: TLabel;
    SambLab: TLabel;
    DumLab: TLabel;
    lab1: TLabel;
    Lab2: TLabel;
    lab3: TLabel;
    lab4: TLabel;
    lab5: TLabel;
    lab6: TLabel;
    clasLab: TLabel;
    lab7: TLabel;
    totLab: TLabel;
    butPan: TPanel;
    okBut: TButton;
    cancelBut: TButton;
    nroreLab: TLabel;
    defaultGroup: TGroupBox;
    curBut: TButton;
    delBut: TButton;
    infoLab: TLabel;
    saliEdit: TEdit;
    saliSpin: TUpDown;
    zileSpin: TUpDown;
    oraSpin: TUpDown;
    zileEdit: TEdit;
    oraEd: TEdit;
    oraGroup: TGroupBox;
    ora1Ed: TEdit;
    min1Ed: TEdit;
    ora1Spin: TUpDown;
    min1Spin: TUpDown;
    Label1: TLabel;
    Label2: TLabel;
    minEd: TEdit;
    minSpin: TUpDown;
    up: TButton;
    dn: TButton;
    Check5: TCheckBox;
    Check3: TCheckBox;
    Check6: TCheckBox;
    Check2: TCheckBox;
    Check1: TCheckBox;
    Check4: TCheckBox;
    speedBar: TTrackBar;
    depthBar: TTrackBar;
    beforeLab: TLabel;
    tryLab: TLabel;
    orematEdit: TEdit;
    orematSpin: TUpDown;
    difEdit: TEdit;
    difSpin: TUpDown;
    consecLab: TLabel;
    difLab: TLabel;
    dif1Lab: TLabel;
    Check7: TCheckBox;
    difScroll: TScrollBox;
    applyBut: TButton;
    delB: TButton;
    invB: TButton;
    l1: TEdit;
    l2: TEdit;
    l3: TEdit;
    l4: TEdit;
    l5: TEdit;
    l6: TEdit;
    l7: TEdit;
    Check8: TCheckBox;
    profLst: TListBox;
    procedure modiFont;
    procedure okButClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cancelButClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure profComboChange(Sender: TObject);
    procedure matListMClick(Sender: TObject);
    procedure salaRadioClick(Sender: TObject);
    procedure clasComboChange(Sender: TObject);
    procedure luniLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure upClick(Sender: TObject);
    procedure refreshZile;
    procedure zileSpin1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure curButClick(Sender: TObject);
    procedure delButClick(Sender: TObject);
    procedure saliSpinMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure orematSpinMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure zileSpinMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ora1EdChange(Sender: TObject);
    procedure min1EdChange(Sender: TObject);
    procedure prefFixed(Sender: TObject);
    procedure oraEdChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure difInit;
    procedure difSpinMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure prefKey(Sender: TObject);
    procedure l1Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Tgraf= class(TStringGrid)
       private
         lastCol,lastRow,dragcol,dragrow,which,Tindclas,raza:integer;
       protected
         procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
                   X, Y: Integer); override;
         procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
                   X, Y: Integer); override;
         procedure MouseMove(Shift: TShiftState;X, Y: Integer); override;
         procedure KeyDown(var Key:Word;Shift:TShiftState);override;
         function  SelectCell(ACol, ARow: Longint): Boolean; override;
         procedure Paint;override;
         procedure Redo(Value:integer);
         procedure TopLeftChanged;override;
       public
         constructor Create(AOwner:TComponent);override;
       property indClas:integer read Tindclas write Redo;
       end;

var
  prefFRM: TprefFRM;
  graf:Tgraf;

implementation
uses mainU2,fis,p,r;
{$R *.DFM}
const ix='   X';
var
  _pref:array[1..maxprof,1..maxzile,1..maxore]of pIntTip;
  _clasOre:array[1..maxclas]of pIntTip;
  _oremat:array[1..maxmat,1..2]of pIntTip;
  _sali:array[1..maxmat]of pIntTip;
  _oreZi:array[1..maxclas,1..maxzile]of pIntTip;
  _dif:array[1..maxclas,1..maxore]of pIntTip;
  zileIndex1,zileIndex2:integer;
  _oraStart,oreIndex1,oreIndex2:integer;

procedure TprefFRM.modiFont;
var f:Tfont;
begin
f:=mainFrm.fontDlg.Font;caractEd.Font:=F;
matListM.Font:=f;clasCombo.font:=f;profCombo.font:=F;
end;

procedure FreeTemp;
var m,n,z:integer;
begin
for m:=1 to maxmat do begin ElibInt(_oremat[m,1]);
    ElibInt(_oremat[m,2]);ElibInt(_sali[m]);end;
for m:=1 to maxprof do for n:=1 to maxzile do for z:=1 to maxore do
        ElibInt(_pref[m,n,z]);
for m:=1 to nrclas do begin
    ElibInt(_clasOre[m]);for n:=1 to maxzile do ElibInt(_oreZi[m,n]);
    for n:=1 to maxore do ElibInt(_dif[m,n]);
    end;
end;
{-----------------------------------------------------}
procedure TprefFRM.cancelButClick(Sender: TObject);
begin
removeItem(winPos,'prefWin');
freeTemp;prefFRM.release;prefFRM:=nil;
graf.Free;graf:=nil;
end;
{-----------------------------------------------------}
procedure TprefFRM.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin end;
{-----------------------------------------------------}
procedure TprefFRM.okButClick(Sender: TObject);
var i,j,k:integer;
begin
optionsPage.ActivePage:=condTab;
rez.beforeDepth:=speedBar.Position;
rez.tryDepth:=depthBar.Position;
caracterizare:=caractEd.text;
oraStart:=oraSpin.position*60+minSpin.position;
nrZile:=zileSpin.position;
for k:=1 to nrprof do for i:=1 to maxzile do for j:=1 to maxore do
    if _pref[k,i,j]<>nil then initInt(pref[k,i,j],_pref[k,i,j]^);
for i:=1 to nrmat do for j:=1 to 2 do
    if _oremat[i,j]<>nil then initInt(oremat[i,j],_oremat[i,j]^);
for i:=1 to nrmat do if _sali[i]<>nil then initInt(sali[i],_sali[i]^);
for i:=1 to condGroup.ControlCount do if condGroup.Controls[i-1] is TEdit then
    TEdit(condGroup.Controls[i-1]).SetFocus;
for i:=1 to condGroup.ControlCount do if condGroup.Controls[i-1] is TCheckBox then begin
    j:=TCheckBox(condGroup.Controls[i-1]).tag;
    if j>0 then begin
       initInt(cond[j,2],-1);
       initInt(cond[j,1],ord(TCheckBox(condGroup.Controls[i-1]).Checked));
       for k:=0 to CondGroup.ControlCount-1 do if condGroup.Controls[k] is TEdit then
           if TEdit(condGroup.Controls[k]).Tag=j then
              cond[j,2]^:=strtoint(TEdit(condGroup.Controls[k]).Text);
       end;
    end;
for i:=1 to nrclassel do begin
    for j:=1 to maxore do if (_dif[i,j]<>nil)then
        begin
        if (_dif[i,j]^ mod maxmat)=0 then
           _dif[i,j]^:=(_dif[i,j]^ div maxmat)*maxmat+maxore;
        initInt(dif[i,j],_dif[i,j]^);
        end;
    initInt(clasI[i,2],_clasOre[i]^);
    for j:=1 to maxzile do
        if _oreZi[i,j]<>nil then initInt(oreZi[i,j],_oreZi[i,j]^);
    end;
mainFRM.RefreshForms('prefFRM');
if tbutton(sender).name<>'applyBut'then begin freeTemp;cancelButClick(sender);end;
end;
{-----------------------------------------------------}
procedure TprefFRM.FormCreate(Sender: TObject);
var i,j,k:integer;
begin
if graf=nil then graf:=TGraf.Create(self);
DifInit;ModiFont;
speedBar.Position:=rez.beforeDepth;depthBar.Position:=rez.tryDepth;
caractEd.text:=caracterizare;
oraSpin.position:=trunc(oraStart/60);
minSpin.position:=oraStart-60*oraSpin.position;
zileSpin.position:=nrZile;
width:=difScroll.left+difScroll.width+32;
height:=butPan.top+butPan.Height+32;
zileIndex1:=0;zileIndex2:=0;
profCombo.clear;matListM.clear;clasCombo.clear;
prefFixed(self);
for i:=1 to nrprof do profCombo.items.add(profN[i]^);
for i:=1 to nrmat do matListM.items.add(matN[i]^);
for i:=1 to maxzile do prefGrid.Cells[i,0]:=izileN[i];
for k:=1 to nrprof do for i:=1 to maxzile do for j:=1 to maxore do
    if pref[k,i,j]<>nil then initInt(_pref[k,i,j],pref[k,i,j]^);
for i:=1 to nrmat do begin
    if oremat[i,1]=nil then initInt(_oremat[i,1],1) else
       initInt(_oremat[i,1],oremat[i,1]^);
    if oremat[i,2]<>nil then initInt(_oremat[i,2],oremat[i,2]^);end;
for i:=1 to nrmat do
    if sali[i]=nil then initInt(_sali[i],-1) else
       initInt(_sali[i],sali[i]^);
for i:=1 to condGroup.ControlCount do if condGroup.Controls[i-1] is TCheckBox then begin
    j:=TCheckBox(condGroup.controls[i-1]).tag;
    if j>0 then if cond[j,1]<>nil then begin
       if cond[j,1]^=1 then TCheckBox(condGroup.controls[i-1]).state:=cbchecked;
       if cond[j,1]^=0 then TCheckBox(condGroup.controls[i-1]).state:=cbunchecked;
       end
       else tcheckbox(condGroup.controls[i-1]).state:=cbunchecked;
    for k:=0 to condGroup.ControlCount-1 do if condGroup.Controls[k] is TEdit
        and(TEdit(condGroup.Controls[k]).Tag=j)and(cond[j,2]<>nil)then
        TEdit(condGroup.Controls[k]).Text:=inttostr(cond[j,2]^);
    end;
for i:=1 to nrclasSel do begin
    for j:=1 to maxore do if dif[i,j]<>nil then initInt(_dif[i,j],dif[i,j]^);
    initInt(_clasOre[i],clasI[i,2]^);
    clasCombo.items.add(clasN[clasI[i,1]^]^);
    end;
if not DoOreZi then MakeOreZi(NrZile);
for i:=1 to nrclas do for j:=1 to maxzile do
    if oreZi[i,j]<>nil then initInt(_oreZi[i,j],oreZi[i,j]^)
       else initInt(_oreZi[i,j],0);
end;
{-----------------------------------------------------}
procedure TprefFRM.profComboChange(Sender: TObject);
var i,j,prof:integer;
begin
prof:=profCombo.itemindex+1;
if prof=0 then exit;
for i:=1 to maxzile do for j:=1 to maxore do begin
    prefGrid.cells[i,j]:='';
    if _pref[prof,i,j]<>nil then if _pref[prof,i,j]^=1 then
       prefGrid.cells[i,j]:=ix;end;
nroreLab.caption:='Numar total de ore: '+inttostr(GetOreProf(prof));
end;
{-----------------------------------------------------}
procedure TprefFRM.prefKey(Sender: TObject);
var i,j,prof:integer;
begin
prof:=profCombo.itemindex+1;if prof=0 then exit;
with prefGrid.Selection do begin
for i:=Left to Right do for j:=Top to Bottom do case TComponent(Sender).Tag of
    1: begin prefGrid.Cells[i,j]:='';InitInt(_pref[prof,i,j],0);end;
    2: if prefGrid.cells[i,j]=ix then begin
       prefGrid.cells[i,j]:='';InitInt(_pref[prof,i,j],0);end
       else begin
       prefGrid.cells[i,j]:=ix;initInt(_pref[prof,i,j],1);end;
    end;
end;
end;
{-----------------------------------------------------}
procedure TprefFRM.matListMClick(Sender: TObject);
var materie:integer;
begin
materie:=matListM.itemindex+1;if materie=0 then exit;
orematSpin.position:=_oremat[materie,1]^;
   if _sali[materie]^=-1 then begin
      SalaRadio.itemindex:=0;{sare la salaRadioClick}
      saliSpin.position:=1;
      saliSpin.enabled:=false;end;
   if _sali[materie]^<>-1 then begin
      saliSpin.position:=_sali[materie]^;{linia tr.sa ramana inainte de urmatoarea}
      SalaRadio.itemindex:=1;{sare la salaRadioClick}
      saliSpin.enabled:=true;end;
   if _oremat[materie,2]<>nil then difSpin.Position:=_oremat[materie,2]^
      else difSpin.Position:=0;
end;
{-----------------------------------------------------}
procedure TprefFRM.salaRadioClick(Sender: TObject);
var materie:integer;
begin
materie:=matListM.itemindex+1;if materie=0 then exit;
if salaRadio.Itemindex=0 then begin
   saliSpin.enabled:=false;saliSpin.position:=1;
   _sali[materie]^:=-1;end;
if salaRadio.Itemindex=1 then begin
   saliSpin.enabled:=true;_sali[materie]^:=saliSpin.position;end;
end;
{-----------------------------------------------------}
procedure TprefFRM.clasComboChange(Sender: TObject);
var clasa,i,j,total:integer;
begin
clasa:=clasCombo.itemindex+1;if clasa=0 then exit;
graf.indClas:=clasa;
i:=_clasOre[clasa]^;//probleme cu schimbare la spin
ora1Spin.position:=trunc(i/60);min1Spin.position:=i-ora1Spin.position*60;
if clasa=0 then exit;
for i:=1 to maxzile do begin
    for j:=1 to zileGroup.ControlCount do
    if Tlabel(zileGroup.Controls[j-1]).tag=i then
       if _oreZi[clasa,i]<>nil then
          Tlabel(zileGroup.controls[j-1]).Caption:=inttostr(_oreZi[clasa,i]^);
    end;
for j:=1 to zileGroup.ControlCount do begin
if Tlabel(zileGroup.Controls[j-1]).tag=11 then zileIndex1:=j;
if Tlabel(zileGroup.Controls[j-1]).tag=12 then zileIndex2:=j;
if Tlabel(zileGroup.Controls[j-1]).tag=1 then oreIndex1:=j;
if Tlabel(zileGroup.Controls[j-1]).tag=2 then oreIndex2:=j;
end;
if clasa>NrclasSel then total:=0 else total:=TotalOreClas(clasa);
totLab.caption:='TOTAL: '+inttostr(total)+' h';
refreshZile;
end;
{-----------------------------------------------------}
procedure TprefFRM.ora1EdChange(Sender: TObject);
var index:integer;
begin
index:=clasCombo.itemindex+1;if index=0 then exit;
if sender=ora1Ed then min1Spin.position:=0;
_clasOre[index]^:=strtoint(ora1Ed.text)*60+strtoint(min1Ed.text);
end;
{-----------------------------------------------------}
procedure TprefFRM.min1EdChange(Sender: TObject);
var index:integer;
begin
index:=clasCombo.itemindex+1;if index=0 then exit;
_clasOre[index]^:=strtoint(ora1Ed.text)*60+strtoint(min1Ed.text);
end;
{-----------------------------------------------------}
procedure TprefFRM.refreshZile;
var i:integer;
begin
for i:=1 to zileGroup.Controlcount do
    if Tlabel(zileGroup.controls[i-1]).tag>10 then
       Tlabel(zileGroup.controls[i-1]).color:=clBtnFace;
Tlabel(zileGroup.controls[zileIndex1-1]).color:=clWhite;
Tlabel(zileGroup.controls[zileIndex2-1]).color:=clYellow;
end;
{-----------------------------------------------------}
procedure TprefFRM.luniLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i,zileval,oreval:integer;
begin
if clasCombo.itemindex=-1 then exit;
zileval:=0;oreval:=0;
for i:=1 to zileGroup.controlCount do begin
    if Tlabel(zileGroup.Controls[i-1]).tag=Tlabel(sender).tag then zileval:=i;
    if Tlabel(zileGroup.Controls[i-1]).tag=Tlabel(sender).tag-10 then oreval:=i;
    end;
if button=mbLeft then begin zileIndex1:=zileval;oreindex1:=oreval;end;
if button=mbRight then begin zileIndex2:=zileval;oreindex2:=oreval;end;
refreshZile;
end;
{-----------------------------------------------------}
procedure TprefFRM.upClick(Sender: TObject);
var clasa,val1,val2,nrzi1,nrzi2:integer;Lab1,Lab2:TLabel;
begin
clasa:=clasCombo.itemindex+1;if clasa=0 then exit;
if zileIndex1*zileIndex2=0 then exit;
Lab1:=Tlabel(zileGroup.controls[oreIndex1-1]);
Lab2:=Tlabel(zileGroup.controls[oreIndex2-1]);
val1:=strtoint(Lab1.caption);val2:=strtoint(Lab2.caption);
if(sender=up)and(val2>0)and(val1<maxore)then begin inc(val1);dec(val2);end;
if(sender=dn)and(val1>0)and(val2<maxore)then begin inc(val2);dec(val1);end;
Lab1.caption:=inttostr(val1);Lab2.caption:=inttostr(val2);
nrzi1:=Lab1.tag;nrzi2:=Lab2.tag;
_oreZi[clasa,nrzi1]^:=val1;_oreZi[clasa,nrzi2]^:=val2;
graf.Redo(graf.indClas);
end;

procedure TprefFRM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
cancelButClick(sender);
end;

procedure TprefFRM.curButClick(Sender: TObject);
begin
fileLaunch('SaveDlg',dataFile,1);
end;

procedure TprefFRM.delButClick(Sender: TObject);
begin
deleteFile(dataFile);
end;
{-----------------------------------------------------}
procedure TprefFRM.zileSpin1Change(Sender: TObject);
begin
end;
{-----------------------------------------------------}
procedure TprefFRM.saliSpinMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var materie:integer;
begin
materie:=matListM.itemindex+1;if materie=0 then exit;
_sali[materie]^:=saliSpin.position;
end;

procedure TprefFRM.orematSpinMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var materie:integer;
begin
materie:=matListM.itemindex+1;if materie=0 then exit;
_oremat[materie,1]^:=orematSpin.position;
end;

procedure TprefFRM.zileSpinMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i,j,totalore:integer;
    rest,cat,numarZile:integer;
begin
numarZile:=zileSpin.position;
for i:=1 to nrClasSel do begin
    totalore:=totaloreClas(i);
    cat:=totalore div numarZile;rest:=totalore mod NumarZile;
    for j:=1 to maxzile do begin
        if _oreZi[i,j]=nil then new(_oreZi[i,j]);
        if j<=numarzile then _oreZi[i,j]^:=cat else _oreZi[i,j]^:=0;end;
    for j:=1 to rest do inc(_oreZi[i,j]^);
    end;
clasComboChange(zileSpin);
end;

procedure TprefFRM.prefFixed(Sender: TObject);
var i:integer;
begin
_oraStart:=oraSpin.position*60+minSpin.position;
prefGrid.ColWidths[0]:=LungOraMin(prefGrid.Canvas,_oraStart);
for i:=1 to maxore do prefGrid.Cells[0,i]:=OraMinNext(_oraStart,i);
graf.Redo(graf.indClas);
end;

procedure TprefFRM.oraEdChange(Sender: TObject);
begin
minSpin.Position:=0;
end;

procedure TprefFRM.FormActivate(Sender: TObject);
begin
defilare(prefFRM.Caption,prefFRM);
end;

procedure TprefFRM.difSpinMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var mat:integer;
begin
mat:=matListM.itemindex+1;if mat=0 then exit;
initInt(_oremat[mat,2],difSpin.position);
end;

procedure TprefFRM.difInit;
var i,j:integer;
begin
difSpin.Max:=nrmat;
for i:=1 to nrclassel do for j:=1 to maxore do
    if dif[i,j]<>nil then initInt(_dif[i,j],dif[i,j]^)
    else initInt(_dif[i,j],maxmat+0);
for i:=1 to nrmat do if oremat[i,2]<>nil then
    initInt(_oremat[i,2],oremat[i,2]^);
end;

constructor TGraf.Create;
begin
inherited Create(AOwner);
Parent:=prefFRM.difScroll;borderStyle:=bsNone;
DefaultColWidth:=25;DefaultRowHeight:=22;
Left:=0;Top:=0;colcount:=5;rowcount:=3;raza:=5;
Options:=[goFixedVertLine,goFixedHorzLine];
width:=200;height:=100;color:=clSilver;col:=0;row:=0;
end;

procedure Tgraf.Paint;
var y,cl:array[1..2]of integer;
    i,j,dx,dy:integer;r:TRect;
begin
cl[2]:=clWhite;cl[1]:=clYellow;
inherited Paint;if (indclas=0)or(nrclassel=0)then exit;
for j:=1 to 2 do for i:=1 to colcount-1 do begin
    y[2]:=_dif[indclas,i]^ mod maxmat;y[1]:=_dif[indclas,i]^ div maxmat;
    if y[1]=0 then y[1]:=1;
    if (y[2]=0)or(y[2]>rowcount-1) then y[2]:=rowcount-1;
    if (i=dragCol)and(j=which) then
       y[j]:=rowCount-MouseCoord(HitTest.x,HitTest.y).y;
    r:=CellRect(i,rowCount-y[j]);
    dx:=trunc((r.Right-r.Left)/2)-raza;dy:=trunc((r.Bottom-r.Top)/2)-raza;
    with canvas do begin
         if i=1 then MoveTo(r.Left+dx+raza,r.Top+dy+raza);
         pen.Color:=clBlack;
         brush.color:=cl[j];
         FillRect(rect(r.Left+dx,r.Top+dy,r.Right-dx,r.Bottom-dy));
         LineTo(r.Left+dx+raza,r.Top+dy+raza)
         end;
    end;
end;

procedure Tgraf.MouseMove;
var lcol,lrow:integer;
begin
inherited MouseMove(Shift,X,Y);
lcol:=MouseCoord(x,y).x;lrow:=MouseCoord(x,y).y;
if (indClas=0)or(dragRow<1)or(dragCol<1)or(lcol<1)or(lrow<1)then exit;
if (lcol=lastcol)and(lrow=lastrow)then exit;
lastcol:=lcol;lastrow:=lrow;Paint;
end;

procedure TGraf.MouseDown;
var y2,y1,acol,arow,tmp:integer;
begin
if indClas=0 then exit;
acol:=MouseCoord(x,y).X;arow:=MouseCoord(x,y).y;
if (acol<1)or(arow<1)then exit;which:=0;
tmp:=_dif[indClas,aCol]^;
y2:=tmp mod maxmat;if (y2=0)or(y2>rowcount-1) then y2:=rowcount-1;
y1:=tmp div maxmat;if y1<1 then y1:=1;
if y2=(rowCount-aRow)then which:=2 else
if y1=(rowCount-aRow)then which:=1;
if which=0 then exit;
dragCol:=acol;dragRow:=arow;lastCol:=acol;lastRow:=arow;
end;

procedure TGraf.MouseUp;
var acol,arow,y1,y2:integer;
begin
if indClas=0 then exit;
acol:=MouseCoord(x,y).X;arow:=MouseCoord(x,y).y;
try
if (acol<1)or(arow<1)or(dragCol<1)or(dragRow<1)or(dragCol<>acol)then exit;
y2:=_dif[indclas,acol]^ mod maxmat;
if (y2=0)or(y2>rowcount-1)then y2:=rowcount-1;
y1:=_dif[indclas,acol]^ div maxmat;if y1=0 then y1:=1;
case which of
2:if rowcount-arow<=y1 then exit else y2:=rowcount-arow;
1:if rowcount-arow>=y2 then exit else y1:=rowcount-arow;end;
if y2=rowCount-1 then y2:=0;
initInt(_dif[indClas,acol],y1*maxmat+y2);
finally dragCol:=0;dragRow:=0;Which:=0;Paint;end;
end;

procedure Tgraf.Redo;
var i,j:integer;
begin
if Value<1 then exit;TIndClas:=Value;
j:=1;for i:=1 to nrmat do if _oremat[i,2]<>nil then j:=maxim(_oremat[i,2]^,j);
rowcount:=maxim(2,j+1);
for i:=1 to rowCount-1 do cells[0,i]:=inttostr(rowCount-i);
colcount:=GetZileOre(indClas,6)+1;
for i:=1 to Colcount-1 do cells[i,0]:=inttostr(trunc(_oraStart/lungOra)+i-1);
width:=(colCount+1)*(ColWidths[0]+GridLineWidth);
height:=(rowCount+1)*(RowHeights[0]+GridLineWidth);
Paint;
end;

procedure Tgraf.TopLeftChanged;
begin inherited TopLeftChanged;Paint;end;

function  TGraf.SelectCell;
begin if acol*arow=0 then Result:=true else Result:=false;end;

procedure Tgraf.KeyDown;
begin end;
//-------------------------------

procedure TprefFRM.l1Exit(Sender: TObject);
var i,j:integer;
begin
if not check8.Checked then exit;
val(TEdit(sender).text,i,j);
if (j<>0)or(i<1)or(i>nrcond-1)then begin
   mesaj('Prioritate invalida. Trebuie sa fie cuprinsa intre 1 si '
         +inttostr(nrcond-1),Mes_OK);TEdit(Sender).SetFocus;end;
end;

END.
