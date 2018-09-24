unit resultU2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ExtCtrls, ComCtrls, StdCtrls, Buttons, Menus, ToolWin;

type
  TrezFRM = class(TForm)
    HeadPan: TPanel;
    butPan: TPanel;
    orarPan: TPanel;
    orarGrid: TStringGrid;
    okBut: TButton;
    cancelBut: TButton;
    rigthPan: TPanel;
    combo: TComboBox;
    princRadio: TRadioGroup;
    secRadio: TRadioGroup;
    Status: TStatusBar;
    editList: TListBox;
    rezPop: TPopupMenu;
    curMn: TMenuItem;
    libMn: TMenuItem;
    oriceMn: TMenuItem;
    allMn: TMenuItem;
    beforeMn: TMenuItem;
    N1: TMenuItem;
    allclasMn: TMenuItem;
    dragLab: TStaticText;
    N2: TMenuItem;
    editCheck: TCheckBox;
    moveCheck: TCheckBox;
    veriCheck: TCheckBox;
    pasCheck: TCheckBox;
    navigTool: TToolBar;
    leftBut: TButton;
    rigthBut: TButton;
    startBut: TButton;
    endBut: TButton;
    condBut: TButton;
    procedure FormResize(Sender: TObject);
    procedure cancelButClick(Sender: TObject);
    procedure okButClick(Sender: TObject);
    procedure displayMat_Prof(index:integer);
    procedure displayZile(indZile:integer);
    procedure secRadioClick(Sender: TObject);
    procedure refresh(tip:integer);
    procedure princRadioClick(Sender: TObject);
    procedure putFixed;
    procedure editButClick(Sender: TObject);
    procedure orarGridKeyPress(Sender: TObject; var Key: Char);
    procedure editListKeyPress(Sender: TObject; var Key: Char);
    function Switch(zi1,ora1,zi2,ora2,indClas:integer;CanSwitch:boolean):byte;
    function profSwitch(zi1,ora1,zi2,ora2,indprof:integer;CanSwitch:boolean):byte;
    procedure orarGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure orarGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure orarGridClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure helpButClick(Sender: TObject);
    procedure editListDblClick(Sender: TObject);
    procedure refreshEdit;
    procedure modiFont;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure popClick(Sender: TObject);
    procedure orarGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure orarGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure leftRigth(Sender: TObject);
    procedure condButClick(Sender: TObject);
  private
    { Private declarations }
  public
    isEdit,lastPrinc:integer;
    { Public declarations }
  end;

var
  rezFRM:TrezFRM;
  _profMoved:string;
  _consec:integer;

implementation

uses mainU2,
     workU2,tipU2,p,r, prefU2;

{$R *.DFM}

var
   dragCol,dragRow,xdist,ydist:integer;

{-----------------------------------------------------}
procedure TrezFRM.modiFont;
var F:TFont;
begin
F:=mainfrm.fontDlg.font;combo.font:=f;
orarGrid.Font:=F;editList.font:=F;
formResize(rezFrm);
end;
{-----------------------------------------------------}
procedure TrezFRM.FormCreate(Sender: TObject);
var i:integer;
begin
Width:=mainFRM.Width-border;Height:=mainFRM.Height-border;
if nrclasSel=0 then begin
   okBut.enabled:=false;editCheck.enabled:=false;combo.enabled:=false;
   end else begin
   okBut.enabled:=true;editCheck.enabled:=true;combo.enabled:=true;
   end;
modiFont;dragLab.Parent:=orarGrid;
lastPrinc:=2;putFixed;
combo.items.clear;
if isEdit<>1 then isEdit:=0 else editCheck.Onclick(workFRM);
for i:=1 to nrclasSel do combo.Items.add(clasN[clasI[i,1]^]^);
combo.itemindex:=0;
princRadioClick(rezFRM);
end;
{-----------------------------------------------------}
procedure TrezFRM.okButClick(Sender: TObject);
var i,j,k,m,rest:integer;
begin
if isedit=1 then begin rest:=0;k:=0;m:=0;
   for i:=1 to nrClasSel do
       for j:=1 to matNr[i]^ do begin rest:=rest+_restore[i,j]^;
           if _restore[i,j]^<>0 then if k=0 then begin k:=i;m:=j;end;
           end;
   if rest<>0 then
      if messageDlg('Orarul nu e terminat la clasa '+clasN[clasI[k,1]^]^+'.'
         +crlf+'Pentru materia '+getMat(matI[k,m]^,0,0)+' mai sunt '+
         inttostr(_restore[k,m]^)+ 'h'+
         crlf+'Doriti sa lucrati cu acest orar ?'
         ,mtwarning,[mbYes,mbNo],0)=idNo then exit;
   for i:=1 to nrClasSel do for j:=1 to maxzile do for k:=1 to maxore do
        begin InitInt(matR[i,j,k],_matR[i,j,k]^);
        initInt(profR[i,j,k],_profR[i,j,k]^);end;
   workRez:=0;
   end;
if sender<>editCheck then CancelButClick(sender);
end;
{-------------------------------------------------------------}
procedure TrezFRM.cancelButClick(Sender: TObject);
begin
removeItem(winPos,'rezWin');
if (isedit=1)then rez.freetemp;
rezFRM.release;rezFRM:=nil;
end;
{-----------------------------------------------------}
procedure TrezFRM.FormResize(Sender: TObject);
const _MinLat=90;
var i,Lat,Lung,gros,_MinLung:integer;
begin
if rezFRM=nil then exit;
i:=HeadPan.Left+secRadio.Left+secRadio.Width+10;
if rezFRM.width<i then rezFRM.width:=i;
if rezFRM.height<300 then rezFRM.height:=300;
with orarGrid do begin
RowHeights[0]:=abs(Font.height)+10;
//ColWidths[0]:=Canvas.textwidth('99,99-99,99 ');
_MinLung:=abs(Font.height)+6;gros:=GridLineWidth;
Lat:=trunc((OrarPan.Width-20-ColWidths[0])/(ColCount-1))-gros;
Lung:=trunc((OrarPan.Height-30-Rowheights[0])/(RowCount-1))-gros;
if Lat<_MinLat then begin Lat:=_MinLat;ScrollBars:=ssBoth;end
   else begin
   if Lung<_MinLung then ScrollBars:=ssBoth else ScrollBars:=ssNone end;
if Lung<_MinLung then begin Lung:=_MinLung;ScrollBars:=ssBoth;end
   else begin
   if Lat=_MinLat then ScrollBars:=ssBoth else ScrollBars:=ssNone end;
for i:=1 to Colcount-1 do ColWidths[i]:=lat;
for i:=1 to Rowcount-1 do RowHeights[i]:=lung;
i:=(lat+gros+1)*(Colcount-1)+ColWidths[0]+gros;
if Lat<>_MinLat then Width:=i else Width:=OrarPan.Width-20;
i:=(lung+gros+1)*(rowcount-1)+rowHeights[0]+gros;//incerc sa nimeresc
if Lung<>_MinLung then height:=i else Height:=OrarPan.Height-30;
end;//orarGrid
end;
{-----------------------------------------------------}
procedure TrezFRM.putFixed;
var i,j,k:integer;s:string;
begin
if princRadio.Itemindex=2 then begin
   orarGrid.colcount:=1+nrClasSel;
   for i:=1 to nrClasSel do orarGrid.cells[i,0]:='';
   formResize(rezFRM);exit;end;
k:=5;//sa nu dea eroare cand e zero
for i:=1 to nrclassel do for j:=1 to maxzile do if OreZi[i,j]^>0 then
    k:=maxim(k,j);
if lastPrinc=2 then begin
   orarGrid.ColCount:=k+1;orarGrid.RowCount:=maxore+1;
   for i:=1 to maxzile do orarGrid.Cells[i,0]:=zileN[i];end;
orarGrid.ColWidths[0]:=LungOraMin(orarGrid.Canvas,oraStart);
for i:=1 to maxore do begin s:=OraMinNext(oraStart,i);
    if orarGrid.Cells[0,i]<>s then orarGrid.Cells[0,i]:=s;end;
formResize(rezFRM);
end;
{-----------------------------------------------------}
procedure TrezFRM.leftRigth(Sender: TObject);
var pas,index:integer;
begin
if combo.itemindex=-1 then exit;
pas:=TButton(sender).tag;
with combo do begin
index:=itemindex;index:=index+pas;
if index>Items.count then index:=Items.count-1;if index<0 then index:=0;
itemindex:=index;
end;refresh(0);
end;
{-----------------------------------------------------}
procedure TrezFRM.displayMat_Prof(index:integer);
var i,j,opt:integer;s:string;
begin
if isedit=1 then opt:=Rez_R else opt:=RezR;
for i:=1 to maxzile do for j:=1 to maxore do
    begin
    s:=getRez(index,i,j,princRadio.itemindex,secRadio.itemindex,opt);
    if orarGrid.cells[i,j]<>s then orarGrid.cells[i,j]:=s;
    end;
end;
{-------------------------------------------------------------}
procedure TrezFRM.displayZile(indZile:integer);
var i,k,opt:integer;s:string;
begin
if isedit=1 then opt:=Rez_R else opt:=RezR;
for i:=1 to maxore do begin
    for k:=1 to nrclassel do begin
    s:=GetRez(k,indZile,i,princRadio.itemindex,secRadio.itemindex,opt);
    if orarGrid.cells[k,i]<>s then orarGrid.cells[k,i]:=s;
    end;
end;
end;
{-------------------------------------------------------------}
procedure TrezFRM.secRadioClick(Sender: TObject);
begin
if combo.itemindex=-1 then exit;refresh(0);
end;
{-------------------------------------------------------------}
procedure TrezFRM.Refresh(tip:integer);
var index:integer;
begin
index:=combo.itemindex+1;if index=0 then exit;
case princRadio.itemindex of
0: begin displayMat_Prof(Index);end;
1: begin displayMat_Prof(Index);end;
2: begin displayZile(index);end;
end;{case}
if (isedit=1)and(tip=0)then refreshEdit;
end;
{-------------------------------------------------------------}
procedure TrezFRM.princRadioClick(Sender: TObject);
var i,j,k,m,prof:integer;
begin
j:=combo.itemindex;if j=-1 then exit;
for i:=0 to secRadio.controlCount-1 do
    secRadio.Controls[i].enabled:=true;
case princRadio.itemindex of
0: begin combo.Items.Clear;secRadio.itemindex:=0;
   secRadio.Controls[2].enabled:=false;
   for i:=1 to nrclasSel do combo.items.add(clasN[clasI[i,1]^]^);end;
1: begin combo.Items.Clear;secRadio.itemindex:=2;
   secRadio.controls[1].enabled:=false;
   for i:=1 to nrprof do combo.items.add(profN[i]^);end;
2: begin combo.Items.Clear;secRadio.itemindex:=1;
   for i:=1 to maxzile do combo.items.add(zileN[i]);end;
end;{case}
putFixed;i:=-1;
case lastPrinc of
0: case princRadio.Itemindex of
   0:i:=j;
   1:begin if isedit=1 then i:=_profR[j+1,orargrid.col,orargrid.row]^-1
     else i:=profR[j+1,orargrid.col,orargrid.row]^-1;
     if i+1<0 then i:=Mprofi[-(i+1),1]^-1;if i=-1 then i:=0;
     end;
   end;//case
1: case princRadio.ItemIndex of
   0: begin
      for k:=1 to nrclassel do begin
          if isedit=1 then prof:=_profR[k,orargrid.col,orargrid.row]^
             else prof:=profR[k,orargrid.col,orargrid.row]^;
          if prof=j+1 then begin i:=k-1;break;end;
          if prof<0 then for m:=1 to Mprofi[-prof,0]^ do if Mprofi[-prof,m]^=j+1 then
             begin i:=k-1;break;end;
          if i<>-1 then break;
          end;
      end;
   1:i:=j;
   end;//case
2:
end;//case
combo.itemindex:=maxim(0,i);
refresh(0);lastPrinc:=PrincRadio.ItemIndex;
end;
{----------------------EDIT--------------------------------------}
procedure TrezFRM.refreshEdit;
var i,index:integer;s:string;
function mayPut(indmat:integer):string;
var error:integer;
begin
Result:='   ';
if (rezPop.Tag<>1)or(not veriCheck.Checked)or(_restore[index,indmat]^=0)
   or(not editList.Visible)then exit;
with orargrid do begin
if rez.blankPoz(index,col,row){and(row<=OreZi[index,col]^)}then begin
   error:=rez.Put(index,indMat,col,row,-1,0,False);
   if error<>0 then Result:='X ';exit;end;
end;end;
begin
editList.items.clear;
if princRadio.itemindex<>0 then exit;
index:=combo.itemindex+1;
for i:=1 to matNr[index]^ do begin
case secRadio.itemindex of
0: s:=getMat(matI[index,i]^,0,0);
1: s:=GetProf(profI[index,i]^,0);
2: ;
3: s:=inttostr(matI[index,i]^);
end;{case}
editList.Items.add(inttostr(_restore[index,i]^)+' h '+' '+mayPut(i)+s);
end;//for
if isEdit=1 then editList.ItemIndex:=0;
end;
{-------------------------------------------------------------}
procedure TrezFRM.editButClick(Sender: TObject);
var i,j,k:integer;
begin
if (isedit=1)and(sender<>workFRM)then begin
   rezPop.AutoPopup:=False;moveCheck.Enabled:=false;
   veriCheck.Enabled:=False;princRadio.controls[2].enabled:=true;
   okButClick(editCheck);isedit:=0;FormCreate(self);
   rez.consec:=_consec;//--------------ATENTIE-------------
   end
else if isedit=0 then begin
rezPop.AutoPopup:=True;moveCheck.Enabled:=true;veriCheck.Enabled:=True;
workFRM.InitTemp;rez.InitVar;
_consec:=rez.consec;
rez.consec:=0;//--------------ATENTIE-------------
if workrez=0 then for i:=1 to nrclasSel do for j:=1 to maxzile do
for k:=1 to maxore do begin
    InitInt(_matR[i,j,k],matR[i,j,k]^);InitInt(_profR[i,j,k],profR[i,j,k]^);
    if matR[i,j,k]^<>0 then dec(_restOre[i,mat2ind(i,matR[i,j,k]^)]^);
    end;
princRadio.controls[2].enabled:=false;
dragCol:=0;dragRow:=0;orarGrid.setfocus;isEdit:=1;
rez.verifica(0,Ver_Mes);
end;
if princRadio.itemindex=2 then begin
   princRadio.itemindex:=0;princRadioClick(rezFRM);end
else Refresh(1);
end;
{-------------------------------------------------------------}
procedure TrezFRM.orarGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var index,indmat:integer;
begin
index:=combo.itemindex+1;if (isedit=0)or(index=0) then exit;
if key=vk_delete then with orargrid do begin
   indmat:=_mat2ind(index,_MatR[index,Col,Row]^);
   if (indmat<>0)and(_restore[index,indmat]^<_oreI[index,indmat]^) then
      rez.DelPoz(index,Col,Row,Poz_Fill);
   rezFRM.Refresh(0);
   end;
end;
{-------------------------------------------------------------}
procedure TrezFRM.orarGridKeyPress(Sender: TObject; var Key: Char);
begin
if isedit=0 then exit;if combo.itemindex=-1 then exit;
if key=#13 then with orargrid do begin
   if princRadio.itemindex<>0 then exit;
   //if row>oreZi[combo.itemindex+1,col]^then exit;
   refreshEdit;
   editList.left:=left+ColWidths[0]+(GridLineWidth+ColWidths[1])*(Col-1)+1;
   editList.top:=top+RowHeights[0]+(GridLineWidth+RowHeights[1])*(Row-1)+1;
   with editList do begin
   Width:= Canvas.TextWidth(umple('0',maxchar));
   if Width>rezFRM.width-left-5 then Left:=rezFRM.width-5-Width;
   if Height>orarPan.Height-top-5 then Top:=orarPan.height-5-Height;
   Visible:=true;SetFocus;
   end;//with
   end;
end;
{-------------------------------------------------------------}
procedure TrezFRM.editListDblClick(Sender: TObject);
var c:char;
begin c:=#13;editListKeyPress(sender,c);end;
{-------------------------------------------------------------}
procedure TrezFRM.editListKeyPress(Sender: TObject; var Key: Char);
var result:integer;
    indClas,zi,ora,indmat:integer;
begin
indmat:=editList.itemindex+1;if indMat=0 then exit;
indClas:=combo.itemindex+1;
if key=#13 then if _restOre[indclas,indMat]^<>0 then begin
   zi:=orarGrid.col;ora:=orarGrid.row;
   if not(rezPop.Tag in [1,2,3,5]) then rezPop.Tag:=1;
   case rezPop.Tag of
        1: Result:=rez.tryPutFix(indClas,indMat,zi,ora,-1,indMat,0,0,1,1,rez.tryDepth);
        2: Result:=rez.AllPut(indClas,indMat,-1,0,0,1);
        3: Result:=rez.tryPut(indClas,indMat,-1,0,0,1);
        5: Result:=rez.trybeforePutFix(indClas,indMat,zi,ora,0);
   else begin orarGrid.SetFocus;exit;end;
   end;//case
   editlist.visible:=True;
   if result<>0 then begin mesaj(getError(result),0);refresh(0);
      editList.Setfocus;exit;end;
   refresh(0);editlist.visible:=false;orargrid.SetFocus;
   end;
if key=#27 then begin editList.visible:=false;orarGrid.Setfocus;end;
end;
{-------------------------------------------------------------}
procedure TrezFRM.popClick(Sender: TObject);
var indClas:integer;c:char;
begin
indClas:=combo.itemindex+1;if indClas=0 then exit;
if Sender is TMenuitem then begin
   rezPop.Tag:=TMenuItem(Sender).Tag;
   TMenuItem(Sender).Checked:=True;
   if rezPop.Tag=4 then begin rez.PutAllMat(indClas,-1);
      refresh(0);rez.Verifica(indClas,Ver_List);exit;end;
   if rezPop.Tag=6 then begin rez.makeOrar;refresh(0);
      rez.Verifica(0,Ver_List);exit;end;
   end;
c:=#13;orarGrid.OnKeyPress(Sender,c);
end;
{-------------------------------------------------------------}
procedure TrezFRM.orarGridMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
if isedit=0 then exit;if dragCol*dragRow=0 then exit;
dragLab.left:=X-xdist;
dragLab.top:=Y-ydist;
end;
{-------------------------------------------------------------}
procedure TrezFRM.orarGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Acol,Arow,i,j,m,index:integer;ics,ics1:array[0..40]of char;s:string;
begin
index:=combo.itemindex+1;if index=0 then exit;
orargrid.mousetocell(x,y,Acol,Arow);if (Acol*Arow=0)or(Acol+Arow<0)then exit;
if button=mbleft then status.Panels.Items[0].Text:=orargrid.cells[Acol,Arow];
if (isedit=0)or(button<>mbleft)or(not moveCheck.checked) then exit;
if (princRadio.itemindex=0)and rez.blankPoz(index,Acol,Arow) then exit;
if orarGrid.cells[Acol,Arow]=''then exit;
dragCol:=Acol;dragRow:=Arow;
with dragLab do begin Caption:=orarGrid.Cells[Acol,Arow];
     xdist:=X-orargrid.CellRect(Acol,Arow).Left;
     ydist:=Y-orargrid.CellRect(Acol,Arow).Top;Visible:=true;end;
fillchar(ics,sizeof(ics),' ');fillchar(ics1,sizeof(ics1),' ');
m:=trunc(orargrid.ColWidths[1]/(orargrid.Font.Size));
ics[m]:='X';ics1[m]:='-';s:='';
with orargrid do for i:=1 to maxzile do for j:=1 to maxore do
    if not((i=dragCol)and(j=dragRow))then
    begin
    if princRadio.itemindex=1 then begin
       if profswitch(dragCol,dragRow,i,j,index,false)<>0 then
          cells[i,j]:=ics else cells[i,j]:=_ProfMoved;
       end
    else begin
       if switch(dragCol,dragRow,i,j,index,false)<>0 then s:=ics
          else begin case secRadio.itemindex of
               0:s:=GetMat(_matR[index,i,j]^,0,0);
               1:s:=GetProf(_profR[index,i,j]^,0);end;
               end;
       cells[i,j]:=s;
       end;
    end;
ics[m]:='*';orargrid.cells[dragCol,dragRow]:=ics;
end;
{-------------------------------------------------------------}
procedure TrezFRM.orarGridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Acol,Arow,result:integer;
procedure resetd;
begin dragLab.Visible:=false;dragCol:=0;dragRow:=0;end;
begin
if isedit=0 then exit;if combo.itemindex=-1 then exit;
Acol:=orargrid.col;Arow:=orargrid.row;
if (button=mbRight)then begin resetd;exit;end;
if (not moveCheck.checked)or((Arow=dragRow)and(Acol=dragCol))
   or(dragCol*dragRow=0)then begin resetd;refresh(0);exit;end;
if princRadio.itemindex=0 then
   result:=switch(dragCol,dragRow,Acol,Arow,combo.ItemIndex+1,true)
else
   result:=profSwitch(dragCol,dragRow,Acol,Arow,combo.ItemIndex+1,true);
if result<>0 then mesaj(getError(result),0);
resetD;refresh(0);
end;
{-------------------------------------------------------------}
function TrezFRM.profSwitch(zi1,ora1,zi2,ora2,indProf:integer;CanSwitch:boolean):byte;
var i,j,k,m,l,mat,prof,prof0,indClas1,indClas2:integer;
label jump;
begin
indClas1:=0;indClas2:=0;
for j:=1 to maxzile do for k:=1 to maxore do
for i:=1 to nrclasSel do begin mat:=_matR[i,j,k]^;prof:=_profR[i,j,k]^;
    if mat<>0 then begin
       if prof<0 then m:=Mprofi[-prof,0]^ else m:=1;
       for l:=1 to m do begin
           if m>1 then prof0:=Mprofi[-prof,l]^ else prof0:=prof;
           if indProf=prof0 then begin
              if (j=zi1)and(k=ora1)then begin indClas1:=i;goto jump;end;
              if (j=zi2)and(k=ora2)then begin indClas2:=i;goto jump;end;
    end;end;end;end;
jump:
if indclas1+indclas2=0 then begin profswitch:=1;exit;end;
if indclas2<>0 then indclas1:=indclas2;
prof:=_ProfR[indclas1,zi2,ora2]^;
if prof<>0 then _ProfMoved:=GetProf(prof,0) else _ProfMoved:='';
profSwitch:=switch(zi1,ora1,zi2,ora2,indclas1,canSwitch);
end;
{-------------------------------------------------------------}
function TrezFRM.switch(zi1,ora1,zi2,ora2,indClas:integer;
         CanSwitch:boolean):byte;
begin
if (not veriCheck.Checked)and(not CanSwitch)then result:=0 else
Result:=rez.switch(indClas,zi1,ora1,zi2,ora2,-1,canSwitch);
end;
{-------------------------------------------------------------}
procedure TrezFRM.orarGridClick(Sender: TObject);
begin
if isedit=0 then exit;
if editList.visible then editList.visible:=false;
end;
{-------------------------------------------------------------}
procedure TrezFRM.FormClose(Sender: TObject; var Action: TCloseAction);
begin cancelButClick(sender);end;
{-------------------------------------------------------------}
procedure TrezFRM.helpButClick(Sender: TObject);
begin
end;
{-------------------------------------------------------------}
procedure TrezFRM.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var index:integer;
begin
index:=combo.ItemIndex;
if (Shift=[ssCtrl])and(key=vk_up)then leftBut.OnClick(leftBut);
if (Shift=[ssCtrl])and(key=vk_down) then rigthBut.OnClick(rigthBut);
if index<>combo.itemindex then Key:=0;
end;
{-------------------------------------------------------------}
procedure TrezFRM.FormActivate(Sender: TObject);
begin
if not Hey then Application.Terminate;
defilare('Rezultate',rezFrm);
end;

procedure TrezFRM.condButClick(Sender: TObject);
begin
mainFRM.prefMn.OnClick(sender);
prefFRM.optionsPage.ActivePage:=prefFRM.CondTab;
end;

end.
