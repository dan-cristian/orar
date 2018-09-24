unit tipU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, checklst, ExtCtrls, ComCtrls, Printers, Menus;

type
  TtipF = class(TForm)
    tipPan: TPanel;
    tipMenu: TMainMenu;
    tipFMn: TMenuItem;
    SaveMn: TMenuItem;
    PrintMn: TMenuItem;
    PrintSetupMn: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshMn: TMenuItem;
    OpenMn: TMenuItem;
    N1: TMenuItem;
    BoldMn: TMenuItem;
    ItalicMn: TMenuItem;
    UnderMn: TMenuItem;
    LeftMn: TMenuItem;
    CenterMn: TMenuItem;
    RightMn: TMenuItem;
    BulletsMn: TMenuItem;
    ParaMn: TMenuItem;
    StyleMn: TMenuItem;
    wrapMn: TMenuItem;
    Status: TStatusBar;
    richPan: TPanel;
    Rich: TRichEdit;
    headP: TPanel;
    princRad: TRadioGroup;
    aniCmb: TComboBox;
    combo: TComboBox;
    secCmb: TComboBox;
    refreshB: TButton;
    closeB: TButton;
    secGrp: TGroupBox;
    matChk: TCheckBox;
    profChk: TCheckBox;
    grupeChk: TCheckBox;
    aniChk: TCheckBox;
    secChk: TCheckBox;
    completChk: TCheckBox;
    sumarChk: TCheckBox;
    procedure ModiFont;
    procedure FormCreate(Sender: TObject);
    procedure PrintSetupMnClick(Sender: TObject);
    procedure PrintMnClick(Sender: TObject);
    procedure closeBClick(Sender: TObject);
    procedure BoldMnClick(Sender: TObject);
    procedure ItalicMnClick(Sender: TObject);
    procedure UnderMnClick(Sender: TObject);
    procedure BulletsMnClick(Sender: TObject);
    function  CurrText: TTextAttributes;
    procedure AlignButtonClick(Sender: TObject);
    procedure RichSelectionChange(Sender: TObject);
    procedure wrapMnClick(Sender: TObject);
    procedure GetFontNames;
    procedure FontsChange(Sender: TObject);
    procedure SetPageSize;
    procedure FormResize(Sender: TObject);
    procedure RichKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RichKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure secCmbChange(Sender: TObject);
    procedure princRadClick(Sender: TObject);
    procedure refreshBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Disp(sect,an,gr:integer);
    procedure DispP(indProf:integer);
    procedure DispZi(indzi:integer);
    procedure AfisCheck(tip,lung,maxora,maxzi,sect,an,gr,ind:integer);
    procedure Process(Sender:TObject);
  end;

var
  tipF: TtipF;

implementation
uses mainU,procs,gen,OrrClass,tipgen;
{$R *.DFM}

const firstTime:boolean=True;
var
  xpix,ypix,xscr,xcol:integer;
  RichRefresh:boolean;
  maxs:ansistring;

procedure TtipF.ModiFont;
var f:Tfont;
begin
f:=mainF.fontDlg.Font;rich.Font.charset:=F.charset;
combo.Font.Charset:=F.charset;
end;

function TtipF.CurrText: TTextAttributes;
begin
if rich.SelLength>0 then Result:=rich.SelAttributes
else Result:=rich.DefAttributes;
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
begin
TStrings(Data).Add(LogFont.lfFaceName);
Result:=1;
end;

procedure TtipF.GetFontNames;
var DC:HDC;
begin
DC:=GetDC(0);mainF.fontsCmb.Clear;
EnumFonts(DC,nil,@EnumFontsProc,Pointer(mainF.fontsCmb.Items));
ReleaseDC(0,DC);mainF.fontsCmb.Sorted:=True;
end;

procedure TtipF.BoldMnClick(Sender: TObject);
begin
if fsBold in CurrText.Style then CurrText.Style:=CurrText.Style - [fsBold]
   else CurrText.Style:=CurrText.Style + [fsBold];
RichSelectionChange(nil);
end;

procedure TtipF.ItalicMnClick(Sender: TObject);
begin
if fsItalic in CurrText.Style then CurrText.Style:=CurrText.Style - [fsItalic]
   else CurrText.Style:=CurrText.Style + [fsItalic];
RichSelectionChange(nil);
end;

procedure TtipF.UnderMnClick(Sender: TObject);
begin
if fsUnderline in CurrText.Style then CurrText.Style:=CurrText.Style - [fsUnderline]
   else CurrText.Style:=CurrText.Style + [fsUnderline];
RichSelectionChange(nil);
end;

procedure TtipF.AlignButtonClick(Sender: TObject);
begin
Rich.Paragraph.Alignment := TAlignment(TControl(Sender).Tag-4);
RichSelectionChange(nil);
end;

procedure TtipF.BulletsMnClick(Sender: TObject);
begin
Rich.Paragraph.Numbering := TNumberingStyle(mainF.bulletsB.Down);
RichSelectionChange(nil);
end;

procedure TtipF.wrapMnClick(Sender: TObject);
begin
if wrapMn.Checked then begin Rich.WordWrap:=False;
   wrapMn.Checked:=false;end
else begin Rich.WordWrap:=true;wrapMn.Checked:=true;end
end;

procedure TtipF.FontsChange(Sender: TObject);
var i,code:integer;
begin
CurrText.Name:=mainF.fontsCmb.Text;
Val(mainF.sizeCmb.Text,i,Code);
if code=0 then CurrText.Size:=i;
Rich.SetFocus;
end;

procedure TtipF.RichKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin RichRefresh:=True;end;

procedure TtipF.RichKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
RichRefresh:=False;RichSelectionChange(Self);
end;

procedure TtipF.RichSelectionChange(Sender: TObject);
begin
if (RichRefresh)and(Sender<>nil) then exit;
with mainF do begin
BoldB.Down := fsBold in rich.SelAttributes.Style;
ItalicB.Down := fsItalic in rich.SelAttributes.Style;
UnderB.Down := fsUnderline in rich.SelAttributes.Style;
BulletsB.Down := Boolean(rich.Paragraph.Numbering);
SizeCmb.Text := inttostr(rich.SelAttributes.Size);
FontsCmb.Text := rich.SelAttributes.Name;
leftB.down:=false;centerB.down:=false;rightB.down:=false;end;
with Rich.Paragraph do begin
case Ord(Alignment) of
0: mainF.LeftB.Down := True;
1: mainF.RightB.Down := True;
2: mainF.CenterB.Down := True;
end;
end;
end;

procedure TtipF.PrintSetupMnClick(Sender: TObject);
begin
mainF.PrintSetupDlg.Execute;SetPageSize;
end;

procedure TtipF.SetPageSize;
begin
xpix:=Printer.PageWidth;ypix:=Printer.PageHeight;
maxs:='';while Printer.Canvas.TextWidth(maxs)<xpix do maxs:=maxs+'0';
xscr:=tipF.Canvas.TextWidth(maxs);
FormResize(self);
end;

procedure TtipF.PrintMnClick(Sender: TObject);
begin
if mainF.PrintDlg.Execute then Rich.print(Orar.Info);
end;

procedure TtipF.Process;
begin
if (Sender=mainF.fontsCmb)or(Sender=mainF.sizeCmb)then FontsChange(Sender);
if TWinControl(Sender).Tag in [4,5,6] then AlignButtonClick(Sender);
if Sender=mainF.boldB then BoldMnClick(Sender);
if Sender=mainF.italicB then ItalicMnClick(Sender);
if Sender=mainF.underB then UnderMnClick(Sender);
if Sender=mainF.bulletsB then BulletsMnClick(Sender);
end;

procedure TtipF.FormResize(Sender: TObject);
var R:TRect;FormFont:TFont;GutterWid:integer;
begin
if tipF=nil then exit;
if tipF.width<550 then tipF.width:=550;
FormFont:=tipF.Font;tipF.Font:=Rich.Font;
with Rich do begin
GutterWid:=trunc((ClientWidth-xscr)/2);
R := Rect(GutterWid,0,ClientWidth-GutterWid,ClientHeight);
SendMessage(Handle, EM_SETRECT, 0, Longint(@R));
end;
tipF.Font:=FormFont;
end;

procedure TtipF.closeBClick(Sender: TObject);
begin
mainF.tipBar.Hide;
tipF.Release;tipF:=nil;
end;

procedure TtipF.FormActivate(Sender: TObject);
begin
if refreshB.Enabled and firsttime then refreshB.OnClick(sender);
firsttime:=false;
end;

procedure TtipF.FormCreate(Sender: TObject);
begin
Width:=mainF.Width-borderW;Height:=mainF.Height-borderH;
ModiFont;SetPageSize;
xcol:=Orar.Grups.Profs.Items.MaxLength;
GetFontNames;
Orar.Grups.Sec.Items.ToStrings(@secCmb.Items);
princRadClick(nil);
end;

procedure TtipF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
closeBClick(sender);
end;

procedure TtipF.secCmbChange(Sender: TObject);
var indsec,indan,indgr:integer;
begin
indsec:=secCmb.ItemIndex+1;indan:=aniCmb.ItemIndex+1;
indgr:=combo.ItemIndex+1;
with Orar.Grups do case TComboBox(Sender).Tag of
	1: begin if indsec<=0 then exit;
      aniCmb.Clear;
      Sec[indsec].Items.ToStrings(@aniCmb.Items);
      end;
   2: begin if (indan<=0)or(indsec<=0) then exit;
      combo.Clear;
      Sec[indsec][indan].Items.ToStrings(@combo.Items);
      end;
   3: if (indgr<=0)or(indan<=0)or(indsec<=0)then exit;
   end;
end;

procedure TtipF.princRadClick(Sender: TObject);
var i:integer;
begin
combo.Clear;aniCmb.Clear;if Orar.Grups.Sec.Count=0 then exit;
with secGrp do for i:=1 to ControlCount do Controls[i-1].Enabled:=true;
with Orar.Grups do case princRad.ItemIndex of
	0: begin
   	secCmb.Enabled:=True;aniCmb.Enabled:=True;
      SecCmb.ItemIndex:=0;
      Sec[1].Items.ToStrings(@aniCmb.Items);aniCmb.ItemIndex:=0;
      Sec[1][1].Items.ToStrings(@combo.Items);combo.ItemIndex:=0;
      for i:=2 to 4 do secGrp.Controls[i].Enabled:=False;
      end;
   1: begin Profs.Items.ToStrings(@combo.Items);
   	secGrp.Controls[1].Enabled:=false;
      secCmb.Enabled:=False;aniCmb.Enabled:=False;
      end;
   2: Orar.Zile.ToStrings(@combo.Items);
   end;
combo.Itemindex:=0;
end;

procedure TtipF.refreshBClick(Sender: TObject);
var sect,an,gr,isec,ian,igr:integer;
begin
if combo.ItemIndex=-1 then exit;
rich.Clear;
with Orar.Grups do begin
writeTitle(Orar,Rich);
case princRad.ItemIndex of
	0: begin
      sect:=Sec.IndexToCod(secCmb.ItemIndex+1);
		an:=Sec.ByCod(sect).IndexToCod(aniCmb.ItemIndex+1);
		gr:=Sec.ByCod(sect).ByCod(an).IndexToCod(combo.ItemIndex+1);
   	if completChk.Checked then begin
      	SecCmb.ItemIndex:=0;aniCmb.ItemIndex:=0;combo.ItemIndex:=0;
      	for isec:=1 to Sec.Count do for ian:=1 to Sec[isec].Count do
      	for igr:=1 to Sec[isec][ian].Count do begin
         	sect:=Sec.IndexToCod(isec);
         	an:=Sec.ByCod(sect).IndexToCod(ian);
				gr:=Sec.ByCod(sect).ByCod(an).IndexToCod(igr);
         	Disp(sect,an,gr);
         	end;
			end else Disp(sect,an,gr);
      end;
   1: if completChk.Checked then
   		for igr:=1 to Profs.Items.Count do begin
         combo.ItemIndex:=igr-1;
   		DispP(igr);
         end
     	else DispP(combo.ItemIndex+1);
   2: if completChk.Checked then
      	for igr:=1 to max_zile do begin
         combo.ItemIndex:=igr-1;
         DispZi(igr);
   		end
   	else DispZi(combo.ItemIndex+1);
   end;
end;//with
Rich.SelStart:=0;
end;

function GetLine(sect,an,gr,lung,izi,izi1,iora,iora1,secondInd:integer):string;
var zi,ora:integer;
	_cod:TCod;s:string;
begin
with Orar.Grups do begin Result:='';
for zi:=izi to izi1 do for ora:=iora to iora1 do
   with Sec.ByCod(sect).ByCod(an).ByCod(gr) do begin s:='';
   if Rez.Exist(zi,ora{/,1\})then
      case secondInd of
   	0: begin _cod:=Rez[zi,ora].CMat;
         s:=Mats.Items.ByCod(_cod).Val;end;
      1: begin _cod:=Rez[zi,ora].CProf;
         if _cod<0 then s:=Profs.Items.MVal(MProfs.ByCod(-_cod))
            else if _cod>0 then s:=Profs.Items.ByCod(_cod).Val;
         end;
      2: s:=Sec.ByCod(sect).ByCod(an).Items.ByCod(gr).Val;
      3: s:=Sec.ByCod(sect).Items.ByCod(an).Val;
      4: s:=Sec.Items.ByCod(sect).Val;
      end;//case
   Result:=Result+AdjustStr(s,lung);
   end;
end;//with
end;

function GetLineP(indProf,lung,izi,izi1,iora,iora1,secondInd:integer):string;
var _CProf:TCod;
	j,zi,ora,sect,an,gr:integer;s:string;
   indSec,indAn,indGr:integer;
	found:boolean;_Grp:TGrp;
begin
with Orar.Grups do begin
_CProf:=Profs.Items.IndexToCod(indProf);
_Grp:=TGrp.Create;Result:='';s:='';
for zi:=izi to izi1 do for ora:=iora to iora1 do begin found:=false;
   for indSec:=1 to Sec.Count do
   for indAn:=1 to Sec[indSec].Count do
   for indGr:=1 to Sec[indSec][indAn].Count do begin
   	sect:=Sec.IndexToCod(indSec);
  		an:=Sec[indSec].IndexToCod(indAn);
   	gr:=Sec[indSec][indAn].IndexToCod(indGr);
   	if Sec.ByCod(sect).ByCod(an).ByCod(gr).Rez.Exist(zi,ora) then begin
   		_Grp.Assign(Sec.ByCod(sect).ByCod(an).ByCod(gr).Rez[zi,ora]);
      	if _Grp.CProf=_CProf then found:=true;
      	if _Grp.CProf<0 then for j:=1 to MProfs.ByCod(-_Grp.CProf).Count do
       		if MProfs.ByCod(-_Grp.CProf).ValCod[j]=_CProf then found:=true;
      	if found then
         	case secondInd of
      		0: s:=Mats.Items.ByCod(_Grp.CMat).Val;
         	1: ;
       		2: s:=Sec.ByCod(sect).ByCod(an).Items.ByCod(gr).Val;
         	3: s:=Sec.ByCod(sect).Items.ByCod(an).Val;
         	4: s:=Sec.Items.ByCod(sect).Val;
         	end;
      	found:=false;
      	end;
   	end;
   Result:=Result+AdjustStr(s,lung);s:='';
   end;
end;//with
_Grp.Free;
end;

function GetLineZi(indzi,lung,iora,iora1,secondInd:integer):string;
var _Grp:TGrp;s:string;ora,indSec,indAn,indGr:integer;
	sect,an,gr:TCod;
begin
with Orar.Grups do begin
_Grp:=TGrp.Create;Result:='';s:='';
for ora:=iora to iora1 do begin
   for indSec:=1 to Sec.Count do
   for indAn:=1 to Sec[indSec].Count do
   for indGr:=1 to Sec[indSec][indAn].Count do begin
   	sect:=Sec.IndexToCod(indSec);
  		an:=Sec[indSec].IndexToCod(indAn);
   	gr:=Sec[indSec][indAn].IndexToCod(indGr);
   	if Sec.ByCod(sect).ByCod(an).ByCod(gr).Rez.Exist(indzi,ora) then begin
   		_Grp.Assign(Sec.ByCod(sect).ByCod(an).ByCod(gr).Rez[indzi,ora]);
         case secondInd of
      		0: s:=Mats.Items.ByCod(_Grp.CMat).Val;
         	1: s:=Profs.Items.ByCod(_Grp.CProf).Val;
       		2: s:=Sec.ByCod(sect).ByCod(an).Items.ByCod(gr).Val;
         	3: s:=Sec.ByCod(sect).Items.ByCod(an).Val;
         	4: s:=Sec.Items.ByCod(sect).Val;
         	end;
         Result:=Result+AdjustStr(s,lung);s:='';
         end;
      end;
   end;//for
end;//with
_grp.Free;
end;

procedure TtipF.AfisCheck;
var i,j,chk:integer;sir:string;ChkBox:TCheckBox;
begin
with Rich do
if (sumarChk.Checked)or(tip<>2)then begin
	sir:=AdjustStr(' ',lung);
	for i:=1 to maxora do begin
      sir:=sir+AdjustStr(Trim(OraMinNext(Orar.Grups.oraStart,i)),lung);
      end;
   SelAttributes.Style:=[fsBold];
	Lines.Add(sir);
   SelAttributes.Style:=[];
	sir:=umple('—',(maxora+1)*lung);Rich.Lines.Add(sir);
	for i:=1 to maxzi do begin j:=0;
		for chk:=0 to secGrp.ControlCount-1 do begin
         ChkBox:=TCheckBox(secGrp.Controls[chk]);
   		if ChkBox.Checked and ChkBox.Enabled then begin inc(j);
   			if j=1 then sir:=AdjustStr(Orar.Zile[i].Val,lung)
      			else sir:=AdjustStr(' ',lung);
            case tip of
   				0: sir:=sir+GetLine(sect,an,gr,lung,i,i,1,maxora,ChkBox.Tag);
            	1: sir:=sir+GetLineP(ind,lung,i,i,1,maxora,ChkBox.Tag);
               //2: sir:=sir+GetLineZi(ind,lung,i,i,ChkBox.Tag);
            	end;
				rich.Lines.Add(sir);
         	end;
         end;
   	end;
   end
else begin
	sir:=AdjustStr(' ',lung);
	for i:=1 to maxzi do begin
      if tip=2 then sir:=sir+AdjustStr(inttostr(i),lung)
      else sir:=sir+AdjustStr(Orar.Zile[i].Val,lung);
      end;
   SelAttributes.Style:=[fsBold];
	Rich.Lines.Add(sir);
   SelAttributes.Style:=[];
   sir:=umple('—',(maxzi+1)*lung);Rich.Lines.Add(sir);
	for i:=1 to maxora do begin j:=0;
		for chk:=0 to secGrp.ControlCount-1 do begin
         ChkBox:=TCheckBox(secGrp.Controls[chk]);
   		if ChkBox.Checked and ChkBox.Enabled then begin inc(j);
   			if j=1 then sir:=AdjustStr(Trim(OraMinNext(Orar.Grups.oraStart,i)),lung)
      			else sir:=AdjustStr(' ',lung);
            case tip of
   				0: sir:=sir+GetLine(sect,an,gr,lung,1,maxzi,i,i,ChkBox.Tag);
            	1: sir:=sir+GetLineP(ind,lung,1,maxzi,i,i,ChkBox.Tag);
               2: sir:=sir+GetLineZi(ind,lung,i,i,ChkBox.Tag);
               end;
				rich.Lines.Add(sir);
         	end;
         end;
   	end;
   end;
end;

procedure TtipF.Disp;
var lung,i,j,maxora,maxzi:integer;
	sir:string;
begin
with Orar.Grups.Sec.ByCod(sect) do with Rich do begin
maxora:=ByCod(an).ByCod(gr).Rez.GetMaxOra;
maxzi:=ByCod(an).ByCod(gr).Rez.GetMaxZi;
with Orar.Grups do begin i:=10;j:=10;
	if matChk.Checked then i:=Mats.Items.MaxLength;
   if profChk.Checked then j:=Profs.Items.MaxLength;
	lung:=maxim(i,j);lung:=maxim(lung,Orar.Zile.MaxLength);
   lung:=lung+2;end;
sir:='Sectia: '+Orar.Grups.Sec.Items.ByCod(sect).Val;
sir:=sir+'  Anul: '+Items.ByCod(an).Val;
sir:=sir+'  Grupa: '+ByCod(an).Items.ByCod(gr).Val;
Lines.Add(sir);Lines.Add('');
AfisCheck(0,lung,maxora,maxzi,sect,an,gr,-1);
Lines.Add('');
end;//with
end;

procedure TtipF.DispP;
var lung,i,j,maxora,maxzi:integer;sir:string;
	_CProf:TCod;
begin
with Orar.Grups do with Rich do begin i:=10;j:=10;
if matChk.Checked then i:=Mats.Items.MaxLength;
if grupeChk.Checked then j:=Sec.MaxLengthGrupe;
lung:=maxim(i,j);
if aniChk.Checked then i:=Sec.MaxLengthAni;
if secChk.Checked then j:=Sec.Items.MaxLength;
lung:=maxim(lung,i);lung:=maxim(lung,j);
lung:=maxim(lung,Orar.Zile.MaxLength);
lung:=lung+2;
_CProf:=Profs.Items.IndexToCod(indProf);
maxora:=GetMaxOraProf(_CProf);
maxzi:=GetMaxZiProf(_CProf);
sir:='Profesor: '+Profs.Items.ByCod(_CProf).Val;
Lines.Add(sir);Lines.Add('');
AfisCheck(1,lung,maxora,maxzi,-1,-1,-1,indProf);
Lines.Add('');
end;//with
end;

procedure TtipF.DispZi;
var i,j,lung,maxora,maxzi:integer;sir:string;
begin
with Orar.Grups do with Rich do begin i:=10;j:=10;
if matChk.Checked then i:=Mats.Items.MaxLength;
if grupeChk.Checked then j:=Sec.MaxLengthGrupe;
lung:=maxim(i,j);
if aniChk.Checked then i:=Sec.MaxLengthAni;
if secChk.Checked then j:=Sec.Items.MaxLength;
lung:=maxim(lung,i);lung:=maxim(lung,j);
if profChk.Checked then
	lung:=maxim(lung,Orar.Grups.Profs.Items.MaxLength);
lung:=maxim(lung,Orar.Zile.MaxLength);
lung:=lung+2;
maxora:=8;maxzi:=max_zile;
sir:='Ziua: '+Orar.Zile[indzi].Val;
Lines.Add(sir);Lines.Add('');
AfisCheck(2,lung,maxora,maxzi,-1,-1,-1,indzi);
Lines.Add('');
end;//with
end;


end.
