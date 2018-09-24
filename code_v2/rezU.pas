unit rezU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, StdCtrls, Grids, ToolWin, ExtCtrls, SeleWin;

type
  TrezF = class(TForm)
    headP: TPanel;
    butP: TPanel;
    orarP: TPanel;
    orarGrid: TStringGrid;
    okB: TButton;
    cancelB: TButton;
    princRad: TRadioGroup;
    secRad: TRadioGroup;
    Status: TStatusBar;
    rezPop: TPopupMenu;
    MakeRezPermGr1: TMenuItem;
    MakeRezGr1: TMenuItem;
    dragL: TStaticText;
    editChk: TCheckBox;
    moveChk: TCheckBox;
    veriChk: TCheckBox;
    pasChk: TCheckBox;
    MakeRezAn1: TMenuItem;
    MakeRezAn2: TMenuItem;
    MakeRezPermAn1: TMenuItem;
    N1: TMenuItem;
    MakeRez1: TMenuItem;
    MakeRezPerm1: TMenuItem;
    N2: TMenuItem;
    MakeRezMat1: TMenuItem;
    MakeRezPermMat1: TMenuItem;
    N3: TMenuItem;
    Make1: TMenuItem;
    aniCmb: TComboBox;
    combo: TComboBox;
    secCmb: TComboBox;
    MakeRezSec1: TMenuItem;
    MakeRezPermSec1: TMenuItem;
    N4: TMenuItem;
    deplB: TButton;
    editLst: TSeleWin;
    procedure cancelBClick(Sender: TObject);
    procedure modiFont;
    procedure FormCreate(Sender: TObject);
    procedure princRadClick(Sender: TObject);
    procedure secRadClick(Sender: TObject);
    procedure orarGridDblClick(Sender: TObject);
    procedure Disp;
    procedure DispP;
    procedure orarGridClick(Sender: TObject);
    procedure comboChange(Sender: TObject);
    procedure editLstDblClick(Sender: TObject);
    procedure okBClick(Sender: TObject);
    procedure editLstFill;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure orarGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure orarGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure orarGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure orarGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure editLstKeyPress(Sender: TObject; var Key: Char);
    procedure MakeRezGr1Click(Sender: TObject);
    procedure MakeRezMat1Click(Sender: TObject);
    procedure secCmbChange(Sender: TObject);
    procedure aniCmbChange(Sender: TObject);
    procedure deplBMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure saptSpClick(Sender: TObject; Button: TUDBtnType);
    procedure moveChkClick(Sender: TObject);
  private
    { Private declarations }
  public
    isEdit,lastPrinc:integer;
    function getProfIndex(isec,ian,igr,zi,ora:integer):integer;
    function getSecAnGr(var isec,ian,igr:integer):boolean;
    procedure getSecAnGrFromProf(var isec,ian,igr:integer;iprof,zi,ora:integer);
    { Public declarations }
  end;

var
  rezF:TrezF;



implementation

uses mainU,gen,procs,orrClass;

{$R *.DFM}
const
     dragCol:integer=0;
     dragRow:integer=0;
     max_found=20;
var
   xdist,ydist:integer;
   OrarRez:TOrar;
	ProfMoved:string;
{-----------------------------------------------------}
procedure TrezF.modiFont;
var F:TFont;
begin
F:=mainF.fontDlg.font;combo.font:=f;
orarGrid.Font:=F;editLst.font:=F;
end;
{-------------------------------------------------------------}
procedure TrezF.cancelBClick(Sender: TObject);
begin
OrarRez.Destroy;
rezF.release;rezF:=nil;
end;
{-------------------------------------------------------------}
procedure TrezF.FormCreate;
var i:integer;
begin
OrarRez:=TOrar.Create;
OrarRez.Assign(Orar);
editLst.closeB.Hide;
with OrarRez.Grups do begin
Sec.Items.ToStrings(@SecCmb.Items);secCmb.ItemIndex:=0;
orarGrid.ColCount:=nrZile+1;
orarGrid.RowCount:=max_ore+1;
for i:=1 to nrZile do orarGrid.Cells[i,0]:=OrarRez.Zile[i].Val;
for i:=1 to max_ore do orarGrid.Cells[0,i]:=OraMinNext(OrarRez.Grups.oraStart,i);
end;
FormResize(nil);princRadClick(nil);
end;

procedure TrezF.FormResize(Sender: TObject);
const colw=40;rowh=20;
begin
with orarGrid do begin
Width:=orarP.ClientWidth;Height:=orarP.ClientHeight;
if (orarP.ClientWidth>500)and(orarP.ClientHeight>250)then begin
	DefaultColWidth:=trunc(((orarP.ClientWidth-colw-2)-2*orarP.BorderWidth)/(ColCount-1))-GridLineWidth;
	DefaultRowHeight:=trunc(((orarP.ClientHeight-rowh-10)-2*orarP.BorderWidth)/(RowCount-1))-GridLineWidth;
	ScrollBars:=ssNone;
	end else ScrollBars:=ssBoth;
ColWidths[0]:=colw;RowHeights[0]:=rowh;
end;
end;

procedure TrezF.deplBMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var index,pas:integer;
begin
if X>(deplB.Width/2)then pas:=1 else pas:=-1;
index:=combo.ItemIndex+pas;
if index<0 then begin
   if aniCmb.ItemIndex=0 then
   	secCmb.Perform(WM_KEYDOWN,VK_UP,0)
   else aniCmb.Perform(WM_KEYDOWN,VK_UP,0);
	index:=combo.Items.Count-1;
   end;
if index>combo.Items.Count-1 then begin
   if aniCmb.ItemIndex+1=aniCmb.Items.Count then
   	secCmb.Perform(WM_KEYDOWN,VK_DOWN,0)
   else aniCmb.Perform(WM_KEYDOWN,VK_DOWN,0);
	index:=0;
   end;
combo.ItemIndex:=index;
combo.OnChange(nil);
end;

procedure TrezF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
cancelBClick(nil);
end;

procedure TrezF.princRadClick(Sender: TObject);
var i:integer;isec,ian,igr:integer;
begin
with secRad do for i:=1 to ControlCount do Controls[i-1].Enabled:=true;
with OrarRez.Grups do case princRad.ItemIndex of
	0: begin
      getSecAnGrFromProf(isec,ian,igr,maxim(combo.ItemIndex+1,1),OrarGrid.Col,OrarGrid.Row);
      if Sec.Count=0 then exit;
      combo.Clear;aniCmb.Clear;secCmb.Clear;
   	secCmb.Enabled:=True;aniCmb.Enabled:=True;
      Sec.Items.ToStrings(@secCmb.Items);
      secCmb.ItemIndex:=isec-1;
      Sec[isec].Items.ToStrings(@aniCmb.Items);
      aniCmb.ItemIndex:=ian-1;
      Sec[isec][ian].Items.ToStrings(@combo.Items);
      combo.ItemIndex:=igr-1;
      for i:=2 to 4 do secRad.Controls[i].Enabled:=False;
      end;
   1: if getSecAnGr(isec,ian,igr) then begin
      combo.Clear;aniCmb.Clear;secCmb.Clear;
      Profs.Items.ToStrings(@combo.Items);
   	secRad.Controls[1].Enabled:=false;
      secCmb.Enabled:=False;aniCmb.Enabled:=False;
      combo.ItemIndex:=getProfIndex(isec,ian,igr,OrarGrid.Col,OrarGrid.Row)-1;
      end;
   2: OrarRez.Zile.ToStrings(@combo.Items);
   end;
with secRad do if Controls[Itemindex].Enabled=False then Itemindex:=0;
secRad.OnClick(nil);
end;

procedure TrezF.Disp;
var zi,ora,an,gr,sect,secondInd:integer;_cod:TCod;s1,s2,s:string;
function dis(G:TGrp):string;
begin
   with OrarRez.Grups do with Sec.ByCod(sect).ByCod(an).ByCod(gr) do
   case secondInd of
      0: begin
            _cod:=G.CMat;
            Result:=Mats.Items.ByCod(_cod).Val;
         end;
      1: begin
            _cod:=G.CProf;
            if _cod<0 then
               Result:=Profs.Items.MVal(MProfs.ByCod(-_cod))
            else
               if _cod>0 then Result:=Profs.Items.ByCod(_cod).Val;
         end;
      5: begin
            Result:=Corp.Items.ByCod(G.CCorp).Val;
         end;
   end;//case
end;
begin
with OrarRez.Grups do
begin
   sect:=Sec.IndexToCod(secCmb.ItemIndex+1);
   an:=Sec.ByCod(sect).IndexToCod(aniCmb.ItemIndex+1);
   gr:=Sec.ByCod(sect).ByCod(an).IndexToCod(combo.ItemIndex+1);
   secondInd:=secRad.ItemIndex;
{ TODO -oDan -cAlgoritm+Interfata : Afiseaza si din saptamana 2. Trebuie modificat Rez.Exist }
   for zi:=1 to max_zile do for ora:=1 to max_ore do
      with Sec.ByCod(sect).ByCod(an).ByCod(gr) do
         begin
            s:='';
            if Rez.Exist(zi,ora) then
               begin
                  s1:=dis(Rez[zi,ora]);
                  if Rez[zi,ora].OGrp<>nil then
                     begin
                        s2:=dis(Rez[zi,ora].OGrp);
                     end
                  else
                     s2:='';
                  if Rez[zi,ora].Sapt>1 then
                     begin
                        if Rez[zi,ora].PozSapt=1 then
                           s:=s1+' / '+s2
                        else
                           s:=s2+' / '+s1;
                     end
                  else
                     s:=s1;
               end;
            orarGrid.Cells[zi,ora]:=s;
         end;
end;//with
end;

procedure TrezF.DispP;
var _CProf:TCod;
	j,zi,ora,sect,an,gr:integer;s,desp:string;
   indSec,indAn,indGr:integer;
   found:boolean;_Grp:TGrp;
begin
with OrarRez.Grups do begin
_CProf:=Profs.Items.IndexToCod(combo.ItemIndex+1);
_Grp:=TGrp.Create;
for zi:=1 to max_zile do for ora:=1 to max_ore do begin
	s:='';found:=false;desp:='';
   for indSec:=1 to Sec.Count do
   for indAn:=1 to Sec[indSec].Count do
   for indGr:=1 to Sec[indSec][indAn].Count do begin
   sect:=Sec.IndexToCod(indSec);
  	an:=Sec[indSec].IndexToCod(indAn);
   gr:=Sec[indSec][indAn].IndexToCod(indGr);
{ TODO -cInterfata : Afisare 2 sapt si la DISPP }
   if Sec.ByCod(sect).ByCod(an).ByCod(gr).Rez.Exist(zi,ora) then
   	begin
   	_Grp.Assign(Sec.ByCod(sect).ByCod(an).ByCod(gr).Rez[zi,ora]);
      if _Grp.CProf=_CProf then found:=True;
      if _Grp.CProf<0 then for j:=1 to MProfs.ByCod(-_Grp.CProf).Count do
       	if MProfs.ByCod(-_Grp.CProf).ValCod[j]=_CProf then found:=True;
      if found then case secRad.ItemIndex of
      	0: s:=s+desp+Mats.Items.ByCod(_Grp.CMat).Val;
         1: ;
       	2: s:=s+desp+Sec.ByCod(sect).ByCod(an).Items.ByCod(gr).Val;
         3: s:=s+desp+Sec.ByCod(sect).Items.ByCod(an).Val;
         4: s:=s+desp+Sec.Items.ByCod(sect).Val;
         end;
      if (found)and(desp='') then desp:='/';
      found:=False;
      end;
   end;
   orarGrid.Cells[zi,ora]:=s;
   end;
end;//with
_Grp.Free;
end;

procedure TrezF.secRadClick(Sender: TObject);
begin
if combo.ItemIndex=-1 then exit;
case princRad.ItemIndex of
     0: Disp;
     1: DispP;
     end;
editLstFill;
end;

procedure TrezF.editLstFill;
var i,sect,an,gr,maxL:integer;ora,_cod:TCod;s:string;
begin
editLst.seleLst.Clear;
with OrarGrid do begin
   with OrarRez.Grups do case secRad.ItemIndex of
        0: maxL:=Mats.Items.MaxLength;
        1: maxL:=Profs.Items.MaxLength;
        else maxL:=20;end;
   with editLst do Width:=Canvas.TextWidth(umple('0',maxL))+60;
   end;
if princRad.ItemIndex=0 then with OrarRez.Grups do begin
   sect:=Sec.IndexToCod(secCmb.ItemIndex+1);
   an:=Sec.ByCod(sect).IndexToCod(aniCmb.ItemIndex+1);
   gr:=Sec.ByCod(sect).ByCod(an).IndexToCod(combo.ItemIndex+1);
   with Sec.ByCod(sect).ByCod(an).ByCod(gr) do
   	for i:=1 to Count do begin
      ora:=Grp[i].OraRest;
      if secRad.ItemIndex=0 then s:=Mats.Items.ByCod(Grp[i].CMat).Val
      else with Profs.Items do begin _cod:=Grp[i].CProf;
         if _cod>0 then s:=ByCod(_cod).Val;
         if _cod<0 then s:=MVal(OrarRez.Grups.MProfs.ByCod(-_cod));
         end;
      editLst.Items.Add(inttostr(ora)+' h  '+s);
      end;
   end else editLst.Hide;
end;

procedure TrezF.orarGridDblClick(Sender: TObject);
begin
if (princRad.itemindex=0)and(editChk.Checked)then
	with OrarGrid do begin
	editLst.Left:= maxim(0,Left+ColWidths[0]+(Col-1)*ColWidths[Col]
		-abs(trunc((ColWidths[Col]-editLst.Width)/2)));
   editLst.Top:= Top+RowHeights[0]+(Row-1)*RowHeights[Row];
   with editLst do if Left+Width>OrarGrid.Width then
   	Left:=OrarGrid.Width-Width;
   editLst.Show;
   editLst.seleLst.SetFocus;
end;
end;

procedure TrezF.orarGridClick(Sender: TObject);
begin
editLst.Hide;
end;

procedure TrezF.comboChange(Sender: TObject);
begin
secRad.OnClick(nil);
end;

procedure TrezF.editLstDblClick(Sender: TObject);
var sect,an,gr,zi,ora,ind,err:integer;Grp:TGrp;
begin
ind:=editLst.selelst.itemindex+1;
if (princRad.itemindex<>0)or(ind=0)then exit;
with OrarRez.Grups do begin Grp:=TGrp.Create;
sect:=Sec.IndexToCod(secCmb.ItemIndex+1);
an:=Sec.ByCod(sect).IndexToCod(aniCmb.ItemIndex+1);
gr:=Sec.ByCod(sect).ByCod(an).IndexToCod(combo.ItemIndex+1);
zi:=OrarGrid.Col;ora:=orarGrid.Row;
if Sec.ByCod(sect).ByCod(an).ByCod(gr).Grp[ind].OraRest>0 then
	begin
   Grp.Assign(Sec.ByCod(sect).ByCod(an).ByCod(gr).Grp[ind]);
   err:=Put(sect,an,gr,zi,ora,Grp);
   if err<>0 then ShowMessage(ReturnErr(err));
   editLst.Hide;
   end;
end;//with
secRadClick(nil);
orarGrid.SetFocus;Grp.Free;
end;

procedure TrezF.okBClick(Sender: TObject);
begin
Orar.Destroy;Orar:=TOrar.Create;
Orar.Assign(OrarRez);
cancelBClick(nil);
end;

procedure TrezF.orarGridMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
if dragCol*dragRow=0 then exit;
dragL.left:=X-xdist+orarP.BorderWidth;
dragL.top:=Y-ydist+orarP.BorderWidth;
end;

{function switchProf(zi1,ora1,zi2,ora2:integer;canSwitch:boolean):integer;
var zi,ora,nrprof,mprof:integer;
	cprof,cprof0,sect,an,gr:TCod;
   gata:boolean;
   indsec,isec1,isec2,indan,ian1,ian2,indgr,igr1,igr2:integer;
begin
gata:=false;ProfMoved:='';
isec1:=0;isec2:=0;ian1:=0;ian2:=0;igr1:=0;igr2:=0;
with OrarRez.Grups do begin
for zi:=1 to nrzile do for ora:=1 to max_ore do
for indsec:=1 to Sec.Count do
for indan:=1 to Sec[indsec].Count do
for indgr:=1 to Sec[indsec][indan].Count do
with Sec[indsec][indan][indgr] do if Rez.Exist(zi,ora)then
	begin cprof:=Rez[zi,ora,1].CProf;
   if cprof<0 then nrprof:=MProfs.ByCod(-cprof).Count
   	else nrprof:=1;
   for mprof:=1 to nrprof do begin
   	if nrprof>1 then cprof0:=MProfs.ByCod(-cprof).ValCod[mprof]
      	else cprof0:=cprof;
      if cprof=cprof0 then begin
      	if (zi1=zi)and(ora1=ora)then begin
         	gata:=true;ian1:=indan;igr1:=indgr;
				isec1:=indsec;end;
         if (zi2=zi)and(ora2=ora)then begin
         	gata:=true;ian2:=indan;igr2:=indgr;
            isec2:=indsec;end;
         end;
      if gata then break;
      end;
   if gata then break;
   end;
if isec1+isec2=0 then begin Result:=-1;exit;end;
if isec2<>0 then begin isec1:=isec2;ian1:=ian2;igr1:=igr2;end;
with Sec[isec1][ian1][igr1] do if Rez.Exist(zi2,ora2) then begin
	cprof0:=Rez[zi2,ora2,1].CProf;
	if cprof0>0 then
		ProfMoved:=Profs.Items.ByCod(cprof0).Val
   else ProfMoved:='---';
   end;
sect:=Sec.IndexToCod(isec1);
an:=Sec.ByCod(sect).IndexToCod(ian1);
gr:=Sec.ByCod(sect).ByCod(an).IndexToCod(igr1);
Result:=Switch(sect,an,gr,zi1,ora1,zi2,ora2,canSwitch);
end;//with
end;}

function switchProf(cprof,zi1,ora1,zi2,ora2:integer;canSwitch:boolean):integer;
var nrprof:integer;
	cprof0,sect,an,gr:TCod;
   find1:boolean;
   indsec,isec1,isec2,indan,ian1,ian2,indgr,igr1,igr2:integer;
function ver(_zi,_ora:integer):boolean;
var mprof:integer;
begin
Result:=False;
with OrarRez.Grups do with Sec[indsec][indan][indgr] do begin
if Rez.Exist(_zi,_ora) then
begin
   cprof0:=Rez[_zi,_ora].CProf;
   if cprof0<0 then nrprof:=MProfs.ByCod(-cprof).Count else nrprof:=1;
   for mprof:=1 to nrprof do
   begin
      if nrprof>1 then cprof0:=MProfs.ByCod(-cprof).ValCod[mprof];
      if cprof=cprof0 then
      begin
         if (_zi=zi1)and(_ora=ora1)then
         begin
            ian1:=indan;igr1:=indgr;isec1:=indsec;Result:=True;exit;
         end;
      end;
   end;
end;
end;

end;
begin
ProfMoved:='';find1:=False;
isec1:=0;isec2:=0;ian1:=0;ian2:=0;igr1:=0;igr2:=0;
with OrarRez.Grups do begin
for indsec:=1 to Sec.Count do
   for indan:=1 to Sec[indsec].Count do
      for indgr:=1 to Sec[indsec][indan].Count do
      begin
         if not find1 then find1:=ver(zi1,ora1);
         if find1 then break;
      end;
if isec1=0 then begin Result:=-1;exit;end;
if isec2<>0 then begin isec1:=isec2;ian1:=ian2;igr1:=igr2;end;
with Sec[isec1][ian1][igr1] do if Rez.Exist(zi2,ora2) then begin
	cprof0:=Rez[zi2,ora2].CProf;
	if cprof0>0 then
		ProfMoved:=Profs.Items.ByCod(cprof0).Val
   else ProfMoved:='---';
   end;
sect:=Sec.IndexToCod(isec1);
an:=Sec.ByCod(sect).IndexToCod(ian1);
gr:=Sec.ByCod(sect).ByCod(an).IndexToCod(igr1);
Result:=Switch(sect,an,gr,zi1,ora1,zi2,ora2,canSwitch);
end;//with
end;

procedure TrezF.orarGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
procedure DispAniCannot;
var zi,ora,sect,an,gr,index,cprof:integer;
begin
with OrarRez.Grups do with OrarGrid do begin
index:=combo.ItemIndex+1;
if princRad.ItemIndex=1 then cprof:=Profs.Items.IndexToCod(index) else cprof:=0;
for zi:=1 to nrZile do for ora:=1 to max_ore do
   case princRad.Itemindex of
   0: begin
      sect:=Sec.IndexToCod(secCmb.ItemIndex+1);
		an:=Sec.ByCod(sect).IndexToCod(aniCmb.ItemIndex+1);
		gr:=Sec.ByCod(sect).ByCod(an).IndexToCod(combo.ItemIndex+1);
		if OrarRez.Grups.Switch(sect,an,gr,Col,Row,zi,ora,False)<>0
      	then Cells[zi,ora]:='X';
      end;
   1: if princRad.Itemindex=1 then
      	if switchProf(cprof,Col,Row,zi,ora,False)<>0
      		then Cells[zi,ora]:='X' else Cells[zi,ora]:=ProfMoved;
   end;//case
end;//with
end;
//----------------
begin
with OrarGrid do
if (Cells[Col,Row]<>'')and(moveChk.Checked)then begin
     dragCol:=Col;dragRow:=Row;
     dragL.Caption:=orarGrid.Cells[Col,Row];
     xdist:=X-CellRect(Col,Row).Left;
     ydist:=Y-CellRect(Col,Row).Top;
     dragL.Visible:=true;
     if veriChk.Checked then begin
      cells[Col,Row]:='  *';
     	DispAniCannot;
      end;
     end;
end;

procedure TrezF.orarGridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var sect,an,gr,err:integer;
begin
with OrarGrid do
if dragL.Visible and((dragCol<>Col)or(dragRow<>Row))and
	(dragCol*dragRow>0) then with OrarRez.Grups do
   case princRad.ItemIndex of
   	0: begin
         sect:=Sec.IndexToCod(secCmb.ItemIndex+1);
			an:=Sec.ByCod(sect).IndexToCod(aniCmb.ItemIndex+1);
			gr:=Sec.ByCod(sect).ByCod(an).IndexToCod(combo.ItemIndex+1);
         err:=Switch(sect,an,gr,dragCol,dragRow,Col,Row,True);
         if err<>0 then ShowMessage(ReturnErr(err));
         end;
      1: begin
         err:=SwitchProf(Profs.Items.IndexToCod(combo.ItemIndex+1),
            dragCol,dragRow,Col,Row,True);
         if err<>0 then ShowMessage(ReturnErr(err));
         end;
      end;
dragL.Visible:=false;dragCol:=0;dragRow:=0;
secRadClick(nil);
end;

procedure TrezF.orarGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var sect,an,gr,pozSapt:integer;rez:integer;
begin
if Key=13 then begin orarGridDblClick(nil);exit;end;
if (secCmb.ItemIndex=-1)or(aniCmb.ItemIndex=-1)or(combo.ItemIndex=-1)then exit;
with OrarRez.Grups.Sec do begin
	sect:=IndexToCod(secCmb.ItemIndex+1);
	an:=ByCod(sect).IndexToCod(aniCmb.ItemIndex+1);
	gr:=ByCod(sect).ByCod(an).IndexToCod(combo.ItemIndex+1);
	end;
if Key=vk_delete then with OrarGrid do if Cells[Col,Row]<>'' then begin
   case princRad.ItemIndex of
      0: with OrarRez.Grups do
            begin
               pozSapt:=Sec.ByCod(sect).ByCod(an).ByCod(gr).Rez.getLastPozSapt(Col,Row);
               rez:=Del(sect,an,gr,Col,Row,pozSapt);
               if pasChk.Checked then
                  ShowMessage(inttostr(rez));
               secRadClick(nil);
            end;
        1:;
        end;
   end;
end;

procedure TrezF.editLstKeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then editLstDblClick(nil);
end;

procedure TrezF.MakeRezMat1Click(Sender: TObject);
var sect,an,gr,err:integer;_Grp:TGrp;
begin
if (princRad.ItemIndex<>0)or(combo.ItemIndex=-1) then exit;
with OrarRez.Grups do begin
sect:=Sec.IndexToCod(secCmb.ItemIndex+1);
an:=Sec.ByCod(sect).IndexToCod(aniCmb.ItemIndex+1);
gr:=Sec.ByCod(sect).ByCod(an).IndexToCod(combo.ItemIndex+1);
_Grp:=TGrp.Create;
_Grp.Assign(Sec.ByCod(sect).ByCod(an).ByCod(gr).Grp[editLst.selelst.ItemIndex+1]);
case TMenuItem(sender).Tag of
	1:err:=MakeRezMat(sect,an,gr,_Grp);
   2:err:=MakeRezPermMat(sect,an,gr,_Grp);
   else err:=-1;
   end;
end;_Grp.Free;
secRadClick(nil);
ShowMessage(OrarRez.Grups.ReturnErr(err));
end;

procedure TrezF.MakeRezGr1Click(Sender: TObject);
var sect,an,gr,err:integer;
begin
if (princRad.ItemIndex<>0)or(combo.ItemIndex=-1) then exit;
with OrarRez.Grups do begin
sect:=Sec.IndexToCod(secCmb.ItemIndex+1);
an:=Sec.ByCod(sect).IndexToCod(aniCmb.ItemIndex+1);
gr:=Sec.ByCod(sect).ByCod(an).IndexToCod(combo.ItemIndex+1);
case TMenuItem(sender).Tag of
   1:err:=Make;
   2:err:=MakeRez;
   3:err:=MakeRezPerm;
   4:err:=MakeRezSec(sect);
   5:err:=MakeRezPermSec(sect);
   6:err:=MakeRezAn(sect,an);
   7:err:=MakeRezPermAn(sect,an);
   8:err:=MakeRezGr(sect,an,gr);
   9:err:=MakeRezPermGr(sect,an,gr);
   else err:=-1;
   end;
end;
secRadClick(nil);
ShowMessage(OrarRez.Grups.ReturnErr(err));
end;

procedure TrezF.secCmbChange(Sender: TObject);
begin
aniCmb.Clear;
OrarRez.Grups.Sec[secCmb.ItemIndex+1].Items.ToStrings(@aniCmb.Items);
aniCmb.ItemIndex:=0;
AniCmbChange(nil);
end;

procedure TrezF.aniCmbChange(Sender: TObject);
begin
combo.Clear;
OrarRez.Grups.Sec[SecCmb.Itemindex+1][AniCmb.ItemIndex+1].Items.ToStrings(@combo.Items);
combo.ItemIndex:=0;
secRadClick(nil);
end;

function TrezF.getSecAnGr;
begin
isec:=secCmb.ItemIndex+1;
ian:=aniCmb.ItemIndex+1;
igr:=combo.ItemIndex+1;
if isec*ian*igr=0 then Result:=False else Result:=True;
end;

function TrezF.getProfIndex;
var cprof:integer;
begin
with OrarRez.Grups do with Sec[isec][ian][igr] do
if Rez.Exist(zi,ora) then begin
   cprof:=Rez[zi,ora].CProf;
   if cprof<0 then cprof:=MProfs.ByCod(-cprof).ValCod[1];
   Result:=Profs.Items.CodToIndex(cprof);
end else Result:=1;
end;

procedure TrezF.getSecAnGrFromProf;
var _isec,_ian,_igr:integer;
begin
with OrarRez.Grups do
   for _isec:=1 to sec.Count do
      for _ian:=1 to sec[_isec].Count do
         for _igr:=1 to sec[_isec][_ian].Count do
            with sec[_isec][_ian][_igr] do
               if Rez.Exist(zi,ora)and
                  (Rez[zi,ora].CProf=Profs.Items.IndexToCod(iprof)) then
               begin
                  isec:=_isec;ian:=_ian;igr:=_igr;exit;
               end;
isec:=1;ian:=1;igr:=1;
end;

procedure TrezF.saptSpClick(Sender: TObject; Button: TUDBtnType);
begin
secRadClick(nil);
end;

procedure TrezF.moveChkClick(Sender: TObject);
begin
   veriChk.Enabled:=moveChk.Checked;
end;

end.
