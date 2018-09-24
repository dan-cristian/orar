unit ConfigU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Spin, Grids, Buttons
  ,OrrClass;

type
  TconfigF = class(TForm)
    optionsPage: TPageControl;
    genTab: TTabSheet;
    caractLab: TLabel;
    infoEd: TEdit;
    startGroup: TGroupBox;
    zileLab: TLabel;
    startLab: TLabel;
    saliL: TLabel;
    zileSpin: TUpDown;
    oraSpin: TUpDown;
    zileEdit: TEdit;
    oraEd: TEdit;
    minEd: TEdit;
    minSpin: TUpDown;
    saliobEd: TEdit;
    saliobSpin: TUpDown;
    defaultGroup: TGroupBox;
    delcurB: TButton;
    curB: TButton;
    specRad: TRadioGroup;
    ProfTab: TTabSheet;
    profL: TLabel;
    nroreprofL: TLabel;
    infoLab: TLabel;
    prefGrid: TStringGrid;
    profCmb: TComboBox;
    delB: TButton;
    invB: TButton;
    matTab: TTabSheet;
    matLab1: TLabel;
    consecGrp: TGroupBox;
    consecLab: TLabel;
    difLab: TLabel;
    orematEd: TEdit;
    orematSpin: TUpDown;
    difEdit: TEdit;
    difSpin: TUpDown;
    matLstM: TListBox;
    ClasTab: TTabSheet;
    grupeL: TLabel;
    dif1Lab: TLabel;
    aniL: TLabel;
    grupeCmb: TComboBox;
    ZileGroup: TGroupBox;
    up: TButton;
    dn: TButton;
    oreZiGrid: TStringGrid;
    difScroll: TScrollBox;
    AniCmb: TComboBox;
    condTab: TTabSheet;
    condGrp: TGroupBox;
    Check1: TCheckBox;
    Check2: TCheckBox;
    Check3: TCheckBox;
    Check4: TCheckBox;
    Check5: TCheckBox;
    Check6: TCheckBox;
    Check7: TCheckBox;
    Check8: TCheckBox;
    Check9: TCheckBox;
    secL: TLabel;
    secCmb: TComboBox;
    butPan: TPanel;
    okBut: TButton;
    cancelBut: TButton;
    applyB: TButton;
    Check10: TCheckBox;
    maxoreziL: TLabel;
    maxoreziEd: TEdit;
    maxoreziSpin: TUpDown;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Check11: TCheckBox;
    Bevel4: TBevel;
    marjaL: TLabel;
    marjaEd: TEdit;
    marjaSpin: TUpDown;
    situatiiGrp: TGroupBox;
    nrsaliL: TLabel;
    prefRad: TRadioGroup;
    setB: TButton;
    ferGrp: TGroupBox;
    maxferL: TLabel;
    maxferEd: TEdit;
    maxferSp: TUpDown;
    minblocL: TLabel;
    minblocEd: TEdit;
    minblocSp: TUpDown;
    maxblocL: TLabel;
    maxblocEd: TEdit;
    maxblocSp: TUpDown;
    Check12: TCheckBox;
    endL: TLabel;
    oraeL: TEdit;
    oraeSp: TUpDown;
    mineL: TEdit;
    mineSp: TUpDown;
    Bevel5: TBevel;
    Check13: TCheckBox;
    impT: TTrackBar;
    Label1: TLabel;
    procedure okButClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cancelBClick(Sender: TObject);
    procedure matLstMClick(Sender: TObject);
    procedure grupeCmbChange(Sender: TObject);
    procedure orematSpinClick(Sender: TObject; Button: TUDBtnType);
    procedure difSpinClick(Sender: TObject; Button: TUDBtnType);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure zileSpinClick(Sender: TObject; Button: TUDBtnType);
    procedure oraSpinClick(Sender: TObject; Button: TUDBtnType);
    procedure Check1Click(Sender: TObject);
    procedure infoEdExit(Sender: TObject);
    procedure invBClick(Sender: TObject);
    procedure profCmbChange(Sender: TObject);
    procedure specRadClick(Sender: TObject);
    procedure AniCmbChange(Sender: TObject);
    procedure oreconsGridExit(Sender: TObject);
    procedure secCmbChange(Sender: TObject);
    procedure maxoreziSpinClick(Sender: TObject; Button: TUDBtnType);
    procedure marjaSpinClick(Sender: TObject; Button: TUDBtnType);
    procedure prefRadClick(Sender: TObject);
    procedure maxferSpClick(Sender: TObject; Button: TUDBtnType);
    procedure minblocSpClick(Sender: TObject; Button: TUDBtnType);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Tgraf= class(TStringGrid)
       private
         dragcol,dragrow:integer;
         Grup:TGrup;
         Painted:boolean;
         which,raza:integer;
       protected
         procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
                   X, Y: Integer); override;
         procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
                   X, Y: Integer); override;
         procedure MouseMove(Shift: TShiftState;X, Y: Integer); override;
         procedure KeyDown(var Key:Word;Shift:TShiftState);override;
         function  SelectCell(ACol, ARow: Longint): Boolean; override;
         procedure Paint;override;
         procedure Redo;
         procedure TopLeftChanged;override;
       public
         constructor Create(AOwner:TComponent);override;

       end;

var
  configF: TconfigF;
  graf:Tgraf;

implementation

uses mainU,procs,gen;
{$R *.DFM}
const ix:array[-1..10]of string[5]=
   ('   ?',' ','   1','   2','   3','   4','   5','   6','   7','   8','   9','  10');

var OrarConf:TOrar;

{-----------------------------------------------------}
procedure TconfigF.cancelBClick(Sender: TObject);
begin
OrarConf.Destroy;
configF.Release;configF:=nil;
end;
{-----------------------------------------------------}
procedure TconfigF.okButClick(Sender: TObject);
begin
//Orar.Destroy;Orar:=TOrar.Create;
Orar.Assign(OrarConf);
if sender<>applyB then cancelBClick(nil);
end;
{-----------------------------------------------------}
procedure VarToScreen;
var i,j:integer;
	CheckBox:TCheckBox;
begin
with configF do with OrarConf do with OrarConf.Grups do begin
Mats.Items.ToStrings(@MatLstM.Items);
Profs.Items.ToStrings(@ProfCmb.Items);
Sec.Items.ToStrings(@SecCmb.Items);
if Sec.Count<>0 then begin
	Sec[1].Items.ToStrings(@AniCmb.Items);
	SecCmb.ItemIndex:=0;secCmbChange(nil);
   end;
zileSpin.Position:=nrZile;
oraSpin.Position:=oraStart;
minSpin.Position:=minStart;
oraeSp.Position:=oraEnd;
mineSp.Position:=minEnd;
maxferSp.Max:=max_nrsapt;
maxoreziSpin.Position:=maxOreZi;
marjaSpin.Position:=marjaOre;
maxFerSp.Position:=maxFer;
minBlocSp.Position:=minBloc;
infoEd.Text:=Info;
specRad.ItemIndex:=specific-1;
with oreZiGrid do begin
	for i:=1 to max_zile do begin
   	oreZiGrid.Cells[0,i-1]:=Zile[i].Val;
      prefGrid.Cells[i,0]:=Zile[i].Val;
      end;
   for i:=1 to max_ore do
   	prefGrid.Cells[0,i]:=OraMinNext(OrarConf.Grups.oraStart,i);
   Cells[0,7]:='Total';
	ColWidths[1]:=20;ColWidths[0]:=50;
   end;
for j:=1 to max_cond do for i:=1 to condGrp.ControlCount do
	if (condGrp.Controls[i-1] is TCheckBox) then begin
   	CheckBox:=TCheckBox(condGrp.Controls[i-1]);
      if CheckBox.tag=j then case Grups.cond[j] of
      	0: CheckBox.Checked:=False;
         1: CheckBox.Checked:=true;
         end;
      end;
end;
end;

procedure TconfigF.FormCreate(Sender: TObject);
begin
OrarConf:=TOrar.Create;
OrarConf.Assign(Orar);
if OrarConf.Grups.Sec.Count>0 then begin
	graf:=TGraf.Create(Self);
	graf.Grup:=OrarConf.Grups.Sec[1][1][1];
	graf.Redo;end;
VarToScreen;
end;

procedure TconfigF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
cancelBClick(nil);
end;

//-----------------------General----------------------

procedure TconfigF.zileSpinClick(Sender: TObject; Button: TUDBtnType);
begin
OrarConf.Grups.nrZile:=zileSpin.Position;
end;

procedure TconfigF.oraSpinClick(Sender: TObject; Button: TUDBtnType);
begin
   with OrarConf.Grups do
      begin
         oraStart:=oraSpin.Position;
         minStart:=minSpin.Position;
         oraEnd:=oraeSp.Position;
         minEnd:=mineSp.Position;
      end;
end;

procedure TconfigF.infoEdExit(Sender: TObject);
begin
OrarConf.Info:=infoEd.Text;
end;

procedure TconfigF.specRadClick(Sender: TObject);
begin
OrarConf.specific:=specRad.ItemIndex+1;
end;

procedure TconfigF.maxoreziSpinClick(Sender: TObject; Button: TUDBtnType);
begin
OrarConf.Grups.maxOreZi:=maxoreziSpin.Position;
end;

procedure TconfigF.marjaSpinClick(Sender: TObject; Button: TUDBtnType);
begin
OrarConf.Grups.marjaOre:=marjaSpin.Position;
end;

//---------------------Profesori--------------------------
procedure TconfigF.invBClick(Sender: TObject);
var i,i1,i2,j,indProf,indCmb,cprof,ccat,k1,k2,k:integer;
begin
indCmb:=profCmb.itemindex+1;if indCmb=0 then exit;
if prefRad.Itemindex=0 then begin i1:=indCmb;i2:=i1;ccat:=-1;end
	else begin i1:=1;i2:=OrarConf.Grups.Profs.Items.Count;
   ccat:=OrarConf.Grups.Profs.Cat.Items.IndexToCod(indCmb);end;
for indProf:=i1 to i2 do
with OrarConf.Grups.Profs do with prefGrid.Selection do
for i:=Left to Right do for j:=Top to Bottom do begin
   cprof:=Items.IndexToCod(indProf);
   k1:=1;if i1=i2 then k2:=k1 else k2:=Cat.ByCod(ccat).Count;
   for k:=k1 to k2 do
   	if (i1=i2)or(Cat.ByCod(ccat)[k]=cprof)then
		case TComponent(Sender).Tag of
    		1: begin //sterge
       		Pref[indProf,i,j]:=0;end;
    		2: begin //inverseaza
            Pref[indProf,i,j]:=abs(1-Pref[indProf,i,j]);
         	end;
         3: begin //seteaza
       		Pref[indProf,i,j]:=impT.Position;
            end;
   		end;//case
   	end;//if
profCmbChange(nil);
end;

procedure TconfigF.profCmbChange(Sender: TObject);
var indCmb,indProf,i,j,k,i1,i2,k1,k2,ccat,cprof,nrore,status:integer;
begin
   indCmb:=profCmb.itemindex+1;
   if indCmb=0 then exit;
   with OrarConf.Grups do
   begin
      if prefRad.Itemindex=0 then
         begin
            i1:=indCmb;
            i2:=i1;
            ccat:=-1;
         end
	   else
         begin
            i1:=1;
            i2:=OrarConf.Grups.Profs.Items.Count;
            ccat:=OrarConf.Grups.Profs.Cat.Items.IndexToCod(indCmb);
         end;
      with Profs do for i:=1 to max_zile do for j:=1 to max_ore do
      begin
         status:=-1;//status initial
	      for indProf:=i1 to i2 do
            begin
   	         cprof:=Items.IndexToCod(indProf);
   	         k1:=1;
               if i1=i2 then
                  k2:=k1
               else
                  k2:=Cat.ByCod(ccat).Count;
   	         for k:=k1 to k2 do
                  if (i1=i2)or(Cat.ByCod(ccat)[k]=cprof)then
      	            if status=-1 then
                        status:=Pref[indProf,i,j]
                     else
                        if status<>Pref[indProf,i,j] then
                           status:=-1;
   	         prefGrid.cells[i,j]:=ix[status];
   	      end;
      end;
      if i1<>i2 then
         nrore:=0
      else
	      nrore:=GetOreProf(Profs.Items.IndexToCod(i1));
      nroreprofL.caption:='Numar total de ore: '+inttostr(nrore);
   end;
end;

procedure TconfigF.prefRadClick(Sender: TObject);
var i,j:integer;
begin
profCmb.Clear;
for i:=1 to max_zile do for j:=1 to max_ore do prefGrid.Cells[i,j]:=ix[0];
with OrarConf.Grups do case prefRad.ItemIndex of
   0: begin Profs.Items.ToStrings(@profCmb.Items);
   	profL.Caption:='Profesori:';end;
   1: begin Profs.Cat.Items.ToStrings(@profCmb.Items);
   	profL.Caption:='Catedre:';end;
	end;
end;

{---------------------MATERII--------------------------------}
procedure TconfigF.matLstMClick(Sender: TObject);
var indMat:integer;
begin
indMat:=MatLstM.ItemIndex+1;
with OrarConf.Grups do begin
	if Mats.Items.Count=0 then exit;
   oreMatSpin.Position:=Mats.Items[indMat].MOreCons;
   difSpin.Position:=Mats.Items[indMat].MGradDif;
   nrsaliL.Caption:='Numar sali: '+inttostr(
   	Orar.Grups.Corp.GetNrSali(Mats.Items.IndexToCod(indMat)));
   end;
end;

procedure TconfigF.orematSpinClick(Sender: TObject; Button: TUDBtnType);
var indMat:integer;
begin
indMat:=MatLstM.ItemIndex+1;
if OrarConf.Grups.Mats.Items.Count=0 then exit;
OrarConf.Grups.Mats.Items[indMat].MOreCons:=orematSpin.Position;
end;

procedure TconfigF.difSpinClick(Sender: TObject; Button: TUDBtnType);
var indMat:integer;
begin
indMat:=MatLstM.ItemIndex+1;
if OrarConf.Grups.Mats.Items.Count=0 then exit;
OrarConf.Grups.Mats[indMat].MGradDif:=difSpin.Position;
graf.Redo;
end;

procedure TconfigF.oreconsGridExit(Sender: TObject);
begin
end;

{-------------------ANI----------------------------------}
procedure TconfigF.secCmbChange(Sender: TObject);
begin
aniCmb.Clear;
OrarConf.Grups.Sec[secCmb.ItemIndex+1].Items.ToStrings(@aniCmb.Items);
aniCmb.ItemIndex:=0;
AniCmbChange(nil);
end;

procedure TconfigF.AniCmbChange(Sender: TObject);
begin
GrupeCmb.Clear;
OrarConf.Grups.Sec[SecCmb.Itemindex+1][AniCmb.ItemIndex+1].Items.ToStrings(@GrupeCmb.Items);
GrupeCmb.ItemIndex:=0;
grupeCmbChange(nil);
end;

procedure TconfigF.grupeCmbChange(Sender: TObject);
var i,indsec,indan,indgr:integer;
begin
indsec:=secCmb.ItemIndex+1;
indgr:=grupeCmb.ItemIndex+1;
indan:=AniCmb.ItemIndex+1;
if indgr=0 then exit;
with OrarConf.Grups.Sec[indsec][indan][indgr] do with oreZiGrid do begin
	for i:=1 to max_zile do Cells[1,i-1]:=inttostr(OreZi[i]);
   Cells[1,7]:=inttostr(TotalOre);
   end;
graf.Grup:=OrarConf.Grups.Sec[indsec][indan][indgr];graf.Redo;
end;

//------------------------Conditii------------------
procedure TconfigF.Check1Click(Sender: TObject);
begin
if Sender is TCheckBox then begin
if TCheckBox(Sender).Checked then
	OrarConf.Grups.cond[TCheckBox(Sender).Tag]:=1
    else OrarConf.Grups.cond[TCheckBox(Sender).Tag]:=0;
	end;
end;

{-----------------------------------------------------}
constructor TGraf.Create;
var i:integer;
begin
inherited Create(AOwner);
Parent:=configF.difScroll;borderStyle:=bsNone;
DefaultColWidth:=35;DefaultRowHeight:=22;ColWidths[0]:=25;
Left:=0;Top:=0;Painted:=False;
Colcount:=max_ore+1;Rowcount:=5;
raza:=5;Align:=alNone;ScrollBars:=ssNone;
Options:=[goFixedVertLine,goFixedHorzLine];
Width:=470;Height:=300;Color:=clSilver;Col:=0;Row:=0;
for i:=1 to max_ore do
	Cells[i,0]:=Trim(OraMinNext(OrarConf.Grups.oraStart,i));
end;

procedure Tgraf.Paint;
const cl:array[1..2]of integer=(clWhite,clYellow);
var i,j,dx,dy:integer;r:TRect;
begin
inherited Paint;
for j:=1 to 2 do for i:=1 to max_ore do begin
   r:=CellRect(i,Grup.Dif[i,j]+1);
   if (j=1)and(Grup.Dif[i,j]=0)then r:=CellRect(i,1);
   if (j=2)and(Grup.Dif[i,j]=0)then r:=CellRect(i,RowCount-1);
   if (j=1)and(Grup.Dif[i,j]+1>=RowCount-1)then Grup.Dif[i,j]:=0;
   if (j=2)and(Grup.Dif[i,j]+1>=RowCount-1)then Grup.Dif[i,j]:=0;
   dx:=trunc((r.Right-r.Left)/2)-raza;dy:=trunc((r.Bottom-r.Top)/2)-raza;
   with Canvas do begin
   	if i=1 then MoveTo(r.Left+dx+raza,r.Top+dy+raza);
   	pen.Color:=clBlack;
   	brush.color:=cl[j];
   	FillRect(rect(r.Left+dx,r.Top+dy,r.Right-dx,r.Bottom-dy));
   	LineTo(r.Left+dx+raza,r.Top+dy+raza)
      end;
   end;
end;

procedure Tgraf.MouseMove;
begin
inherited MouseMove(Shift,X,Y);
end;

procedure TGraf.MouseDown;
begin
dragcol:=MouseCoord(x,y).X;dragrow:=MouseCoord(x,y).y;
if dragCol*dragRow=0 then exit;
which:=0;
if Grup.Dif[dragCol,1]=dragRow-1 then which:=1;
if Grup.Dif[dragCol,2]=dragRow-1 then which:=2;
if (Grup.Dif[dragCol,1]=0)and(dragRow=1)then which:=1;
if (Grup.Dif[dragCol,2]=0)and(dragRow=RowCount-1)then which:=2;
end;

procedure TGraf.MouseUp;
var acol,arow,row1,row2:integer;
begin
if (dragCol*dragRow=0)or(which=0)then exit;
aCol:=MouseCoord(x,y).X;aRow:=MouseCoord(x,y).y;
if (aCol*aRow=0)or(dragCol<>aCol)then exit;
row1:=Grup.Dif[aCol,1];row2:=Grup.Dif[aCol,2];
if which=1 then begin
	if (row2<>0)and(aRow>=row2+1)then exit;
   if (row2=0)and(aRow=RowCount-1)then exit;
   end;
if which=2 then begin
	if (row1<>0)and(aRow<=row1+1)then exit;
   if (row1=0)and(aRow=1)then exit;
   end;
if (aRow=RowCount-1)or(aRow=1)then aRow:=0
	else dec(aRow);
Grup.Dif[aCol,which]:=aRow;
Redo;
end;

procedure Tgraf.Redo;
var i:integer;
begin
with OrarConf.Grups.Mats.Items do begin
RowCount:=maxim(3,MaxGradDif+3);
for i:=1 to RowCount do Cells[0,i]:='';
for i:=1 to MaxGradDif do Cells[0,1+i]:=' '+inttostr(i);
end;
Paint;
end;

procedure Tgraf.TopLeftChanged;
begin
inherited TopLeftChanged;
//Paint;
end;

function  TGraf.SelectCell;
begin
if acol*arow=0 then Result:=true else Result:=false;
end;

procedure Tgraf.KeyDown;
begin
end;
//--------------------------------------------------


procedure TconfigF.maxferSpClick(Sender: TObject; Button: TUDBtnType);
begin
OrarConf.Grups.maxFer:=maxFerSp.Position;
end;

procedure TconfigF.minblocSpClick(Sender: TObject; Button: TUDBtnType);
begin
OrarConf.Grups.minBloc:=minBlocSp.Position;
end;

END.
