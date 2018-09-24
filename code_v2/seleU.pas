unit seleU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, checklst, ExtCtrls, ComCtrls, SeleWin, Grids
  ,OrrClass;


type
  TseleF = class(TForm)
    Status: TStatusBar;
    matP: TPanel;
    headP: TPanel;
    butP: TPanel;
    okB: TButton;
    CancelB: TButton;
    matL: TLabel;
    profP: TPanel;
    profLst: TListBox;
    profL: TLabel;
    oreP: TPanel;
    oreLst: TListBox;
    oreL: TLabel;
    rightP: TPanel;
    aniCmb: TComboBox;
    secCmb: TComboBox;
    grupeCmb: TComboBox;
    grupeChk: TCheckBox;
    mprofiB: TButton;
    orematEd: TEdit;
    orematSpin: TUpDown;
    consecLab: TLabel;
    saptEd: TEdit;
    saptSpin: TUpDown;
    saptL: TLabel;
    asocEd: TEdit;
    asocSpin: TUpDown;
    asocL: TLabel;
    profilChk: TCheckBox;
    matGrid: TStringGrid;
    profilmatChk: TCheckBox;
    deplB: TButton;
    asocB: TButton;
    optChk: TCheckBox;
    SeleWin: TSeleWin;
    delmatB: TButton;
    grupateChk: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure CancelBClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure modiFont;
    procedure aniCmbChange(Sender: TObject);
    procedure profLstDblClick(Sender: TObject);
    procedure okBClick(Sender: TObject);
    procedure matGridClick(Sender: TObject);
    procedure mprofiBClick(Sender: TObject);
    procedure closeBClick(Sender: TObject);
    procedure delBClick(Sender: TObject);
    procedure grupeChkClick(Sender: TObject);
    procedure orematSpinClick(Sender: TObject; Button: TUDBtnType);
    procedure profilChkClick(Sender: TObject);
    procedure deplBMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure asocBClick(Sender: TObject);
    procedure profilmatChkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Apply(Warning:boolean):integer;
    procedure PutMatStruc;
    procedure matLstOnDraw(Control: TWinControl; Index: Integer;
  					Rect: TRect; State: TOwnerDrawState);
    procedure ClearGrid;
    procedure DispGrp(_Grp:TGrp);
    procedure SetGridHead;
    procedure SetGrid;
    procedure DispAn(ccat:TCod);
    function GetIndex(var isec,ian,igr:integer):integer;
    procedure SetSome(isec,ian,igr:integer;cmat:TCod;Sender:TObject);
    function getProfil:integer;
    function getSelProf:integer;
    function getSelGrp:TGrp;
    function getCat:TCod;
    function getSelMat:TCod;
  end;

var
  seleF: TseleF;

implementation

uses mainU,procs,gen;//,mycheckLst;

{$R *.DFM}
const
	c_max=4;
	c_mat=1;
   c_prof=2;
   c_ora=3;
   c_orecons=4;

   header:array[1..c_max]of string
      =('Materie','Profesor','Ore','Cons');
var
   OrarSele:TOrar;

procedure TseleF.FormResize(Sender: TObject);
var lung,lat:integer;
begin
if seleF=nil then exit;
Width:=maxim(580,Width);
Height:=maxim(250,Height);oreLst.Width:=35;
lat:=trunc((ClientWidth-oreLst.Width)/2);
lung:=ClientHeight-matP.top-butP.Height-status.Height;
matP.width:=trunc(lat*4/3);profP.Width:=trunc(lat*2/3);
matGrid.Width:=matP.ClientWidth-20;
profLst.Width:=profP.ClientWidth-20;
matGrid.Height:=lung-40;profLst.Height:=lung-40;
oreLst.Height:=lung-40;
end;
{---------------------------------------------------}
procedure TseleF.modiFont;
var F:TFont;
begin
F:=mainF.fontdlg.font;profLst.font:=F;oreLst.font:=F;
Status.Font.Charset:=F.Charset;
with matGrid do begin
     font.size:=f.size;font.style:=f.style;
     font.Color:=f.color;font.Charset:=f.Charset;
     DefaultRowHeight:=abs(f.Height)+3;end;
end;
{---------------------------------------------------}
procedure TseleF.CancelBClick(Sender: TObject);
begin
OrarSele.Destroy;
seleF.release;seleF:=nil;
end;
{---------------------------------------------------}
procedure TseleF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
cancelBClick(sender);
end;
{-----------------------------------------------------}
procedure TseleF.FormCreate(Sender: TObject);
begin
OrarSele:=TOrar.Create;OrarSele.Assign(Orar);
Width:=mainF.ClientWidth-borderW;
Height:=mainF.ClientHeight-borderH;
modiFont;
profLst.Clear;
FormResize(nil);
SeleWin.closeB.Caption:='Sterge';
with OrarSele.Grups do begin
grupeCmb.Enabled:=grupeChk.Checked;
Sec.Items.ToStrings(@secCmb.Items);
secCmb.Perform(WM_KEYDOWN,vk_down,0);
aniCmbChange(secCmb);
SetGrid;
end;
end;
{----------------------------}
procedure TseleF.SetGridHead;
var i:integer;
begin
for i:=1 to c_max do matGrid.Cells[i,0]:=header[i];
end;

procedure TseleF.SetGrid;
begin
with OrarSele.Grups do with matGrid do begin
Left:=10;Top:=matL.Top+matL.Height+3;
ColCount:=c_max+1;ColWidths[0]:=8;
SetGridHead;
with Canvas do begin
   ColWidths[c_prof]:=maxim(TextWidth
      (umple('o',Profs.Items.MaxLength)),TextWidth('(00 profs.)'));
   ColWidths[c_mat]:=TextWidth(umple('o',Mats.Items.MaxLength));
   end;
end;
end;
{---------------------------------------------------}
procedure TseleF.aniCmbChange(Sender: TObject);
var indsec,indan,indgr:integer;
begin
GetIndex(indsec,indan,indgr);if indsec<=0 then exit;
with matGrid do with OrarSele.Grups do case TComboBox(Sender).Tag of
	1: begin aniCmb.Clear;
      Sec[indsec].Items.ToStrings(@aniCmb.Items);
      aniCmb.Perform(WM_KEYDOWN,vk_down,0);
      end;
   2: begin if (indan<=0)or(indsec<=0) then exit;
      grupeCmb.Clear;
      if grupeChk.Checked then
      	Sec[indsec][indan].Items.ToStrings(@grupeCmb.Items);
      grupeCmb.Perform(WM_KEYDOWN,vk_down,0);
      end;
   3: ;
   end;
PutMatStruc;
end;
{---------------------------------------------------}
procedure TseleF.PutMatStruc;
var isec,ian,igr,imat,cmat,i:integer;
   ccat:integer;
begin
if GetIndex(isec,ian,igr)<>0 then exit;
with OrarSele.Grups do with matGrid do begin
if grupeChk.Checked then ccat:=Sec[isec][ian].Items[igr].Tip
   else ccat:=Sec[isec].Items[ian].Tip;
//display materii pe profile
if profilmatChk.Checked then begin
   if ccat=0 then begin
      Mess([m_noprofgrp]);profilmatChk.Checked:=false;exit;
   end;
   i:=Mats.Cat.ByCod(ccat).Count;
   if i=0 then begin
      Mess([m_nomatinprof]);profilmatChk.Checked:=false;exit;end;
   ClearGrid;SetGridHead;
   RowCount:=i+1;
   for imat:=1 to i do begin
      cmat:=Mats.Cat.ByCod(ccat).ValCod[imat];
      Cells[c_mat,imat]:=Mats.Items.ByCod(cmat).Val;
      end;
   end else begin
   //display toate materiile
   ccat:=0;
   ClearGrid;SetGridHead;
   RowCount:=Mats.Items.Count+1;
   for imat:=1 to Mats.Items.Count do begin
      Cells[c_mat,imat]:=Mats.Items[imat].Val;
	   end;
   end;
//afisare date deja introduse
if not grupeChk.Checked then DispAn(ccat) else
   for i:=1 to Sec[isec][ian][igr].Count do
      with Sec[isec][ian][igr] do DispGrp(Grp[i]);
end;//with
profilChkClick(nil);
end;

procedure TseleF.DispAn;
var isec,ian,igr,imat,cmat,cprofil,igrid:integer;
    ccmat,ccprof,ccora,ccons:integer;_Grp:TGrp;s:string;
begin
GetIndex(isec,ian,igr);
_Grp:=TGrp.Create;
with OrarSele.Grups do
   with matGrid do
   begin
      cprofil:=getProfil;
      ccat:=Mats.Cat.Items.ByCod(cprofil).Tip;
      igrid:=0;
      for imat:=1 to Mats.Items.Count do
      begin
         cmat:=Mats.Items.IndexToCod(imat);
         ccmat:=0;ccprof:=0;ccora:=0;ccons:=0;
         //verifica daca apare in profil
         if ((profilmatChk.Checked)and(Mats.Cat.ByCod(ccat).ExistCod(cmat)>0))
            or(not profilmatChk.Checked) then
               begin
                  for igr:=1 to Sec[isec][ian].Count do
                     if Sec[isec][ian][igr].gByMat(cmat)<>nil then
                     begin
                        _Grp.Assign(Sec[isec][ian][igr].gByMat(cmat));
                        if ccmat=0 then ccmat:=_Grp.CMat;//nu prea are rost
                        if ccprof=0 then ccprof:=_Grp.CProf;
                        if ccora=0 then ccora:=_Grp.Ora;
                        if ccons=0 then ccons:=_Grp.OreCons;
                        if (_Grp.CMat<>ccmat) then ccmat:=-1;
                        if (_Grp.CProf<>ccprof) then ccprof:=-1;
                        if (_Grp.Ora<>ccora) then ccora:=-1;
                        if (_Grp.OreCons<>ccons) then ccons:=-1;
                     end
                     else
                        begin
                           if ccprof<>0 then ccprof:=-1;
                           if ccora<>0 then ccora:=-1;
                           if ccons<>0 then ccons:=-1;
                        end;
                  with MatGrid do
                     begin
                        inc(igrid);
                        s:=Mats.Items[imat].Val;
                        Cells[c_mat,igrid]:=s;
                        if ccprof>0 then s:=Profs.Items.ByCod(ccprof).Val
                        else if ccprof=0 then s:='' else s:=' ? ';
                        Cells[c_prof,igrid]:=s;
                        if ccora>0 then s:=inttostr(ccora)
                        else if ccora=0 then s:='' else s:=' ? ';
                        Cells[c_ora,igrid]:=s;
                        if ccons>0 then s:=inttostr(ccons)
                        else if ccons=0 then s:=''//inttostr(Mats.Items[imat].MOreCons)+' x'
                           else s:=' ? ';
                        Cells[c_orecons,igrid]:=s;
                     end;
               end;
      end;//for
   end;//with
_Grp.Destroy;
end;

procedure TseleF.DispGrp;
var i,isec,ian,igr,iimat,imat,cmat,ccat:integer;
   s:string;
begin
if GetIndex(isec,ian,igr)<>0 then exit;
with OrarSele.Grups do with matGrid do begin
imat:=Mats.Items.CodToIndex(_Grp.CMat);
if _Grp.CProf>0 then s:=Profs.Items.ByCod(_Grp.CProf).Val
   else if _Grp.CProf<0 then s:='('+inttostr(MProfs.ByCod(-_Grp.CProf).Count)+' prof.)'
      else s:='';
if profilmatChk.Checked then begin
   cmat:=Mats.Items[imat].Cod;
   if grupeChk.Checked then ccat:=Sec[isec][ian].Items[igr].Tip
      else ccat:=Sec[isec].Items[ian].Tip;
   iimat:=Mats.Cat.ByCod(ccat).ExistCod(cmat);
   if iimat=-1 then exit;
   //materia nu face parte din profil, nu se afiseaza
end else iimat:=imat;
Cells[c_prof,iimat]:=s;
i:=_Grp.Ora;if i=0 then s:='' else s:=inttostr(i);
Cells[c_ora,iimat]:=s;
if _Grp.OreCons>0 then s:=inttostr(_Grp.OreCons)
   else if _Grp.OreCons=0 then s:=inttostr(Mats.Items[imat].MOreCons)+' x'
      else s:='';
Cells[c_orecons,iimat]:=s;
end;//with
end;

procedure TseleF.profLstDblClick(Sender: TObject);
var isec,ian,igr,igr1,igr2,imat,gcount,tipmat:integer;
    cmat:TCod;
begin
if GetIndex(isec,ian,igr1)<>0 then exit;
with OrarSele.Grups do begin
gcount:=Sec[isec][ian].Count;
igr2:=igr1;
for imat:=matGrid.Selection.Top to matGrid.Selection.Bottom do
   begin
   cmat:=getSelMat;
   tipmat:=Mats.Items.ByCod(cmat).Tip;
   //daca e optionala sau e curs
   if (Sec[isec][ian].Opt.ExistCod(cmat)<>-1)or(tipmat=t_curs)then
      begin
         igr2:=gcount;
         igr1:=1;
      end;
    { TODO -oDan -cInterfata : Pentru seminarii si laboratoare }
   for igr:=igr1 to igr2 do
      begin
      { TODO -oDan -cInterfata : Pentru selectie multipla }
      SetSome(isec,ian,igr,cmat,Sender);
      end;
   end;
end;//with
end;

procedure TseleF.SetSome;
var indprof,indexGrp:integer;
   cprofil,cprof,ccat:integer;
	_Grp:TGrp;Avance:boolean;
begin
_Grp:=TGrp.Create;Avance:=True;
with OrarSele.Grups do begin
indexGrp:=Sec[isec][ian][igr].iByMat(cmat);
if indexGrp<>0 then _Grp.Assign(Sec[isec][ian][igr][indexGrp])
   else _Grp.CMat:=cmat;
if Sender=profLst then
   begin
      if not profilChk.Checked then
         begin
            indprof:=profLst.Itemindex+1;
            cprof:=Profs.Items.IndexToCod(indprof);
         end
      else
         begin
            cprofil:=-1;
            if (grupeChk.Checked)and(igr<>0)then
               cprofil:=Sec[isec][ian].Items[igr].Tip;
            if (not grupeChk.Checked)and(ian<>0)then
               cprofil:=Sec[isec].Items[ian].Tip;
            if cprofil<=0 then
               begin
                  indprof:=profLst.Itemindex+1;
                  cprof:=Profs.Items.IndexToCod(indprof);
               end
            else
               begin
                  ccat:=Mats.Cat.Items.ByCod(cprofil).Tip;
                  cprof:=Profs.Cat.ByCod(ccat).ValCod[profLst.ItemIndex+1];
                  indprof:=Profs.Items.CodToIndex(cprof);
               end;//eif
         end;//ebegin
      if _Grp.CProf<0 then
         begin
            if MProfs.ByCod(-_Grp.CProf).Add(cprof) then
               SeleWin.Items.Add(Profs.Items[indprof].Val);
         end
      else
         if SeleWin.Visible then
            begin
               _Grp.CProf:=MProfs.CreateWithCod;
               if MProfs.ByCod(_Grp.CProf).Add(cprof)then
                  SeleWin.Items.Add(Profs.Items[indprof].Val)
               else
                  showmessage('exista deja ceva in ceva abia creat');
               _Grp.CProf:=-_Grp.CProf;
            end;
      if _Grp.CProf>=0 then _Grp.CProf:=cprof;
   end;//if sender
if Sender=oreLst then
   begin
      _Grp.Ora:=strtoint(oreLst.Items[oreLst.ItemIndex]);
      _Grp.OraRest:=_Grp.Ora;
   end;
if Sender=asocSpin then
   begin
      _Grp.TipAsoc:=asocSpin.Position;
      Avance:=False;
   end;
if Sender=orematSpin then
   begin
      _Grp.OreCons:=orematSpin.Position;
      Avance:=False;
   end;
if Sender=saptSpin then
   begin
      _Grp.Sapt:=saptSpin.Position;
      Avance:=False;
   end;
   //daca e optionala le grupeaza
if Sec[isec][ian].Opt.ExistCod(cmat)<>-1 then
   _Grp.TipAsoc:=1;
   //daca e curs le grupeaza
if Mats.Items.ByCod(_Grp.CMat).Tip=t_curs then
   _Grp.TipAsoc:=2;
if Sender=delmatB then
   begin
      if indexGrp<>0 then
         begin
            Sec[isec][ian][igr].DelIndex(indexGrp);
            _Grp.Clear;_Grp.CMat:=cmat;
         end;
      if indexGrp=0 then _Grp.OreCons:=-1;
   end
   else
      begin
         if indexGrp<>0 then Sec[isec][ian][igr][indexGrp].Assign(_Grp)
         else Sec[isec][ian][igr].Add(_Grp);
      end;
   DispGrp(_Grp);
end;//with
if Avance and _Grp.Full then ;//with matGrid do Row:=minim(Row+1,RowCount);
_Grp.Free;
end;

function TseleF.Apply;
//var i,linesec,linean,linegr,indSec,indAn,indGr,indmat:integer;
//	_codSec,_codAn,_codGr,nrmat:integer;_grp:TGrp;
begin
Result:=0;
{_Grp:=TGrp.Create;
with OrarSele.Grups do begin
nrmat:=Mats.Items.Count;Sec.ClearGrups;
for i:=0 to matLst.Items.Count-1 do begin
   DecodeIndex(i,0,indsec,indan,indgr,indmat,OrarSele);
   linesec:=GiveLine(indsec,indan,indgr,0,1,OrarSele)-1;
   linean:=GiveLine(indsec,indan,indgr,0,2,OrarSele)-1;
   linegr:=GiveLine(indsec,indan,indgr,0,3,OrarSele)-1;
   if (matLst.Checked[linesec])and(indan<>0)and(indgr<>0)and(indmat<>0)then begin
   	_codSec:=Sec.Items[indsec].Cod;
   	_codAn:=Sec[indSec].Items[indAn].Cod;
      _codGr:=Sec.ByCod(_codSec).ByCod(_codAn).Items[indgr].Cod;
      if (matLst.Checked[linean])and(matLst.Checked[linegr])
			and(matLst.State[i]<>cbUnchecked)then begin
      	if matLst.Exist(i) then _Grp.Assign(matLst.GetItem(i)) else _Grp.Clear;
      	if (not _Grp.Full) then begin
         	if Warning then matLst.ItemIndex:=i;
            Result:=1;exit;end;
         if _Grp.Ora<_Grp.OreCons then begin
            if Warning then matLst.ItemIndex:=i;
            Result:=3;exit;end;
      	Sec.ByCod(_codSec).ByCod(_codAn).ByCod(_codGr).Add(matLst.GetItem(i));
      	end;//lineAn-linegr
      if Warning then
      if (indmat=nrmat)and(matLst.Checked[linean])and(matLst.Checked[linegr])
      	then with Sec.ByCod(_codSec).ByCod(_codAn)do
         if ExistCod(_codGr)and(ByCod(_codGr).Count=0)then
         	begin Result:=2;if Warning then matLst.ItemIndex:=linegr;
            exit;end;
   	end;//linesec
   end;
end;//with}
end;

procedure MesajErr(cod:integer);
begin
case cod of
1: MessageDlg('Nu ati completat toate datele',mtInformation,[mbOK],0);
2: MessageDlg('Grupa nu are selectata nici o materie',mtInformation,[mbOK],0);
3: MessageDlg('Numarul de ore pe zi este mai mic'+crlf+
	'decat numarul de ore consecutive',mtInformation,[mbOK],0);
end;
end;

procedure TseleF.okBClick(Sender: TObject);
var cod:integer;
begin
if not grupeChk.Checked then begin
	grupeChk.Checked:=true;grupeChkClick(nil);end;
cod:=Apply(True);
if cod in[1,3] then begin MesajErr(cod);exit;end;
if cod=2 then if MessageDlg('Unele grupe nu au selectate nici o materie. Continuam?',
   mtConfirmation,[mbYes,mbNo],0)=mrNo then exit;
OrarSele.Grups.MakeOreZi;
Orar.Destroy;Orar:=TOrar.Create;
Orar.Assign(OrarSele);
CancelBClick(nil);
end;

function TseleF.getCat;
var isec,ian,igr:integer;
begin
   GetIndex(isec,ian,igr);
   if grupeChk.Checked then
      Result:=OrarSele.Grups.Sec[isec][ian].Items[igr].Tip
   else
      Result:=OrarSele.Grups.Sec[isec].Items[ian].Tip;
end;

function TseleF.getSelGrp;
var isec,ian,igr,imat,cod:integer;ccat:TCod;
begin
   with OrarSele.Grups do
   begin
      Result:=nil;
      if GetIndex(isec,ian,igr)<>0 then exit;
      imat:=matGrid.Row;
      if profilmatChk.Checked then
         begin
            ccat:=getCat;
            cod:=Mats.Cat.ByCod(ccat).ValCod[imat];
         end
      else
         cod:=Mats.Items.IndexToCod(imat);
      Result:=Sec[isec][ian][igr].gByMat(cod);
   end;
end;

function TseleF.getSelProf;
var _Grp:TGrp;ccat:TCod;
begin
   _Grp:=TGrp.Create;
   if getSelGrp=nil then
      Result:=-1
   else
      begin
         _Grp.Assign(getSelGrp);
         ccat:=getCat;
         if profilChk.Checked then
            Result:=OrarSele.Grups.Profs.Cat.ByCod(ccat).ExistCod(_Grp.CProf)
         else
            Result:=OrarSele.Grups.Profs.Items.CodToIndex(_Grp.CProf);
         _Grp.Destroy;
      end;
end;

function TseleF.getSelMat;
var imat:integer;ccat:TCod;
begin
    imat:=matGrid.Row;
    ccat:=getCat;
    if profilmatChk.Checked then
      Result:=OrarSele.Grups.Mats.Cat.ByCod(ccat).ValCod[imat]
    else
      Result:=OrarSele.Grups.Mats.Items.IndexToCod(imat);
end;

procedure TseleF.matGridClick(Sender: TObject);
var isec,ian,igr,tipmat:integer;
	_Grp:TGrp;cmat:TCod;
begin
if GetIndex(isec,ian,igr)<>0 then exit;
if SeleWin.Visible then SeleWin.okB.Click;
with OrarSele.Grups do begin
   cmat:=getSelMat;
   tipmat:=Mats.Items.ByCod(cmat).Tip;
   //afis daca e optionala
   optChk.Checked:=False;
   grupateChk.Checked:=False;
   if (Sec[isec][ian].Opt.ExistCod(cmat)<>-1) then
      optChk.Checked:=True
   else
      if tipmat=t_curs then
         grupateChk.Checked:=True;
   asocB.Enabled:=not (optChk.Checked or grupateChk.Checked);
   end;
   saptSpin.Position:=0;
   orematSpin.Position:=0;
   profLst.ItemIndex:=-1;
   oreLst.ItemIndex:=-1;
   if getSelGrp=nil then exit;
   _Grp:=TGrp.Create;
   _Grp.Assign(getSelGrp);
   oreLst.ItemIndex:=_Grp.Ora-1;
   if _Grp.CProf>0 then
      profLst.ItemIndex:=getSelProf-1
   else
      profLst.ItemIndex:=-1;
   AsocSpin.Position:=_Grp.TipAsoc;
   if _Grp.OreCons=0 then
   	orematSpin.Position:=0
   else
      orematSpin.Position:=_Grp.OreCons;
	saptSpin.Position:=_Grp.Sapt;
   _Grp.Destroy;
end;

procedure TseleF.mprofiBClick(Sender: TObject);
var i,cmat,index,isec,ian,igr:integer;MItem:TMItem;_Grp:TGrp;
begin
SeleWin.Tag:=1;SeleWin.closeB.Show;
SeleWin.seleLst.Clear;_Grp:=TGrp.Create;
if GetIndex(isec,ian,igr)<>0 then exit;
with OrarSele.Grups do begin
cmat:=getSelMat;
index:=Sec[isec][ian][igr].iByMat(cmat);
if index<>0 then _Grp.Assign(Sec[isec][ian][igr][index]);
if _Grp.CProf<0 then begin
   MItem:=MProfs.ByCod(-_Grp.CProf);
   for i:=1 to MItem.Count do
   SeleWin.Items.Add(Profs.Items.ByCod(MItem[i]).Val);
   end;
end;//with
SeleWin.BringToFront;SeleWin.Show;_Grp.Free;
end;

procedure TseleF.closeBClick(Sender: TObject);
var isec,ian,igr,cmat,index:integer;_Grp:TGrp;
begin
if not SeleWin.Visible then exit;
if SeleWin.Tag=2 then with OrarSele.Grups do begin
   if GetIndex(isec,ian,igr)<>0 then exit;
   _Grp:=TGrp.Create;
   cmat:=getSelMat;
	index:=Sec[isec][ian][igr].iByMat(cmat);
	if index<>0 then _Grp.Assign(Sec[isec][ian][igr][index])
   	else begin _Grp.CMat:=cmat;
      index:=Sec[isec][ian][igr].Add(_Grp);
      end;
   with SeleWin.seleLst do if ItemIndex>=0 then begin
   	_Grp.TipAsoc:=ItemIndex;
      Sec[isec][ian][igr][index].Assign(_Grp);
		DispGrp(_Grp);end;
   _Grp.Free;
	end;
SeleWin.Hide;
end;

procedure TseleF.delBClick(Sender: TObject);
var index,cmat,isec,ian,igr,j:integer;_Grp:TGrp;
begin
j:=SeleWin.seleLst.itemindex;if j=-1 then exit;
_Grp:=TGrp.Create;
if GetIndex(isec,ian,igr)<>0 then exit;
if SeleWin.Tag=1 then with OrarSele.Grups do begin
cmat:=getSelMat;
index:=Sec[isec][ian][igr].iByMat(cmat);
if index<>0 then _Grp.Assign(Sec[isec][ian][igr][index]);
if _Grp.CProf<0 then with MProfs do begin
     ByCod(-_Grp.CProf).Del(j+1);
     if ByCod(-_Grp.CProf).Count=0 then begin
        Del(-_Grp.CProf);_Grp.CProf:=0;
        Sec[isec][ian][igr][index].Assign(_Grp);
        end;
     SeleWin.Items.Delete(j);
     DispGrp(_Grp);
     SeleWin.seleLst.ItemIndex:=0;
     end;
end;//with
_Grp.Free;
end;

procedure TseleF.grupeChkClick(Sender: TObject);
begin
grupeCmb.Enabled:=grupeChk.Checked;
if not grupeChk.Checked then grupeCmb.Clear else aniCmb.OnChange(aniCmb);
PutMatStruc;
end;

procedure TseleF.matLstOnDraw;
var
	Offset: Integer;
   indsec,indan,indgr,indmat,tip:integer;
   s:string;
begin
if seleF<>nil then
with (Control as TCheckListBox).Canvas do begin
FillRect(Rect);
Offset := 2;
if grupeChk.Checked then tip:=0 else tip:=10;
DecodeIndex(index,tip,indsec,indan,indgr,indmat,OrarSele);
if (indan=0)and(indgr=0)and(indmat=0)then
	Brush.Color:=clYellow;
if (indan<>0)and(indgr=0)and(indmat=0)then
   Brush.Color:=clAqua;
if (indan<>0)and(indgr<>0)and(indmat=0)then
   Brush.Color:=clSilver;
s:=umple(' ',100);
TextOut(Rect.Left+Offset,Rect.Top,(Control as TCheckListBox).Items[Index]+s);
end;
end;

procedure TseleF.orematSpinClick(Sender: TObject; Button: TUDBtnType);
begin
profLstDblClick(Sender);
end;

function TseleF.getProfil;
var isec,ian,igr:integer;
begin
   Result:=-1;
   if GetIndex(isec,ian,igr)<>0 then exit;
   if grupeChk.Checked and(igr<>0)then
      Result:=OrarSele.Grups.Sec[isec][ian].Items[igr].Tip;
   if (not grupeChk.Checked)and(ian<>0)then
      Result:=OrarSele.Grups.Sec[isec].Items[ian].Tip;
end;

procedure TseleF.profilChkClick(Sender: TObject);
var i,isec,ian,igr:integer;
	cprofil,ccat,cod,ok:integer;
begin
if GetIndex(isec,ian,igr)<>0 then exit;
with OrarSele.Grups do
   begin
   ok:=0;ccat:=-1;
   cprofil:=getProfil;
   if not profilChk.Checked then begin
      profLst.Clear;
      Profs.Items.ToStrings(@profLst.Items)
   end
   else begin
      if cprofil<=0 then
         begin
            ok:=-1;
            Mess([m_noprofgrp]);
         end
      else
         begin
            ccat:=Mats.Cat.Items.ByCod(cprofil).Tip;
            if Profs.Cat.ExistCod(ccat)=-1 then begin
               ok:=-1;
               Mess([m_noprofcat]);
               end;
         end;
      if ok=-1 then begin profilChk.Checked:=false;exit;end;
      profLst.Clear;
      with Profs do for i:=1 to Cat.ByCod(ccat).Count do begin
   	   cod:=Cat.ByCod(ccat).ValCod[i];
         profLst.Items.Add(Items.ByCod(cod).Val);
      end;//with-for
   end;//else
end;//with
end;

procedure TSeleF.ClearGrid;
var x,y:integer;
begin
with matGrid do
for x:=1 to ColCount-1 do for y:=1 to RowCount-1 do Cells[x,y]:='';
end;

function TseleF.GetIndex;
begin
isec:=secCmb.ItemIndex+1;
ian:=aniCmb.ItemIndex+1;
igr:=grupeCmb.ItemIndex+1;
if (isec*ian=0)or(grupeChk.Checked and (igr=0))
	then Result:=1 else Result:=0;
if (not grupeChk.Checked)and(igr=0) then igr:=1;
end;

procedure TseleF.deplBMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var index,pas:integer;
begin
if X>(deplB.Width/2)then pas:=1 else pas:=-1;
index:=grupeCmb.ItemIndex+pas;
if index<0 then begin
   if aniCmb.ItemIndex=0 then begin
      pas:=secCmb.ItemIndex;
   	secCmb.Perform(WM_KEYDOWN,VK_UP,0);
      with aniCmb do if pas>0 then ItemIndex:=Items.Count-1
      	else ItemIndex:=0;
      aniCmb.OnChange(aniCmb);
      end
   else aniCmb.Perform(WM_KEYDOWN,VK_UP,0);
	index:=grupeCmb.Items.Count-1;
   end;
if index>grupeCmb.Items.Count-1 then begin
   if aniCmb.ItemIndex+1=aniCmb.Items.Count then
   	secCmb.Perform(WM_KEYDOWN,VK_DOWN,0)
   else aniCmb.Perform(WM_KEYDOWN,VK_DOWN,0);
	index:=0;
   end;
grupeCmb.ItemIndex:=index;
grupeCmb.OnChange(grupeCmb);
end;

procedure TseleF.asocBClick(Sender: TObject);
var i,j,cmat,index,isec,ian,igr,selInd:integer;
	_Grp,_Grp1:TGrp;s:string;
begin
SeleWin.Tag:=2;SeleWin.seleLst.Clear;SeleWin.closeB.Hide;
_Grp:=TGrp.Create;_Grp1:=TGrp.Create;
if GetIndex(isec,ian,igr)<>0 then exit;
with OrarSele.Grups do begin
cmat:=getSelMat;
index:=Sec[isec][ian][igr].iByMat(cmat);
if index<>0 then _Grp.Assign(Sec[isec][ian][igr][index]);
//if _Grp.TipAsoc<>0 then begin
   selInd:=0;
   SeleWin.Items.Add('separat');
   for j:=1 to max_asoc do
      begin
         s:='';
         for i:=1 to Sec[isec][ian].Count do
            begin
               index:=Sec[isec][ian][i].iByMat(cmat);
      	      if index<>0 then
                  _Grp1.Assign(Sec[isec][ian][i][index])
         	   else
                  _Grp1.Clear;
               if _Grp1.TipAsoc=j then
                  begin
                     s:=s+Sec[isec][ian].Items[i].Val+'/';
                     if i=igr then selInd:=SeleWin.Items.Count;
                  end;
      	   end;
         SeleWin.Items.Add(s);
         SeleWin.seleLst.ItemIndex:=selInd;
      end;
//   end;
end;//with
SeleWin.BringToFront;SeleWin.Show;_Grp.Free;_Grp1.Free;
end;

procedure TseleF.profilmatChkClick(Sender: TObject);
begin
PutMatStruc;
end;

end.
