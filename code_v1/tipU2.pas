unit tipU2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, StdCtrls, ExtCtrls, Menus, Spin,  Printers, Buttons;

type
  TtipFRM = class(TForm)
    tipPan: TPanel;
    
    checkPan: TGroupBox;
    ClasCheck: TCheckBox;
    MatCheck: TCheckBox;
    ProfCheck: TCheckBox;
    tipGroup: TRadioGroup;
    PrintSetupDlg: TPrinterSetupDialog;
    PrintDlg: TPrintDialog;
    tipMenu: TMainMenu;
    tipMn1: TMenuItem;
    SaveMn: TMenuItem;
    PrintMn: TMenuItem;
    PrintSetupMn: TMenuItem;
    N2: TMenuItem;
    comboPan: TGroupBox;
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
    GroupBox1: TGroupBox;
    compCheck: TCheckBox;
    combo: TComboBox;
    Button1: TButton;
    Button2: TButton;
    sumCheck: TCheckBox;
    Button3: TButton;
    refreshBut: TButton;
    setupBut: TSpeedButton;
    printBut: TSpeedButton;
    xcolEd: TEdit;
    xcolSpin: TUpDown;
    Label1: TLabel;
    procedure ModiFont;
    procedure FormCreate(Sender: TObject);
    procedure disp(opt:integer);
    procedure tipGroupClick(Sender: TObject);
    procedure PrintSetupMnClick(Sender: TObject);
    procedure PrintMnClick(Sender: TObject);
    procedure RefreshMnClick(Sender: TObject);
    procedure closeButClick(Sender: TObject);
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
    procedure leftRigth(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure xcolSpinClick(Sender: TObject; Button: TUDBtnType);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure getTotalCol(comboind:integer);
  end;

const firstTime:boolean=True;

var
  tipFRM: TtipFRM;
  xpix,ypix,xscr,xcol,totalcol:integer;
  RichRefresh:boolean;
  maxs:ansistring;

implementation
uses mainu2,p;
{$R *.DFM}

procedure TtipFRM.ModiFont;

var f:Tfont;
begin
f:=mainfrm.fontDlg.Font;rich.Font.charset:=F.charset;
combo.Font.Charset:=F.charset;
end;

procedure TtipFRM.FormCreate(Sender: TObject);
var i:integer;
begin
Width:=mainfrm.Width-border;Height:=mainFRM.Height-border;
ModiFont;SetPageSize;
//mainFRM.FontsCombo.Clear;GetFontNames;
tipGroupClick(sender);
xcol:=0;for i:=1 to nrprof do if length(profN[i]^)>xcol then xcol:=length(profN[i]^);
if nrclassel=0 then refreshBut.enabled:=false else refreshBut.enabled:=true;
mainFRM.openTipMn.Enabled:=true;mainFRM.saveTipMn.Enabled:=true;
end;

procedure TtipFRM.disp(opt:integer);
const spatiu=1;fix=10;indent=3;
var i,j,m,nrafis,line,nrcol,startcol,nropt,indexu:integer;
    comboind,nrore,cmb:integer;
function dispLine(ora,step,what,startcol,nrcol,index:integer):integer;
var k,locline:integer;s,s1:ansistring;s2,s3:string;ch:string[1];
begin Result:=0;
if ora=0 then begin s:=umple(' ',indent+fix);
   for k:=startcol to startcol+nrcol-1 do begin s1:='';
         case opt of
              0,1: if k<=maxzile then s1:=ZileN[k];
              2,3..5: if k<=maxore then s1:=OraMinNext(oraStart,k);end;
         s:=s+s1+umple(' ',spatiu+xcol-length(s1));end;
   if Printer.Canvas.TextWidth(s)>xpix then begin
      Result:=Printer.Canvas.TextWidth(s)-xpix;exit;end;
   locline:=1;end
else begin
     s:=umple(' ',indent);s1:='';
     if index=1 then case opt of
        0,1:  s1:=OraMinNext(oraStart,ora);
        2,5:  s1:='';
        3,4:  s1:=ZileN[ora];
        end;
     s:=s+s1+umple(' ',fix-length(s1));
     for k:=startcol to startcol+nrcol-1 do begin s1:='';s2:='';s3:='';
         case opt of
              0,1: s1:=GetRez(comboind,k,ora,opt,what,rezR);
              2:   s1:=GetRez(ora,comboind,k,opt,what,rezR);
              5:   s1:=GetRez(ora,comboind,k,opt-3,what,rezR);
              3:   begin
                   if matCheck.checked then s2:=GetRez(comboind,ora,k,opt-3,0,rezR);
                   if profCheck.checked then s3:=Initiale(GetRez(comboind,ora,k,opt-3,1,rezR));
                   if matCheck.Checked and profCheck.Checked then ch:='/' else ch:='';
                   s1:=s2+ch+s3;end;
              4:   begin
                   if clasCheck.checked then s2:=GetRez(comboind,ora,k,opt-3,2,rezR);
                   if matCheck.checked then s3:=GetRez(comboind,ora,k,opt-3,0,rezR);
                   if matCheck.Checked and clasCheck.Checked then ch:='/' else ch:='';
                   s1:=s2+ch+s3;end;
              end;
         if s1='/' then s1:='';
         if length(s1)>xcol then delete(s1,xcol+1,length(s1)-xcol);
         s:=s+s1+umple(' ',spatiu+xcol-length(s1));
         end;
     locline:=index+(ora-1)*step;
     end;
if delblank(s)='' then exit;
if rich.lines.count<line+locline then
   for k:=rich.lines.count to line+locline-1 do rich.lines.add('');
rich.lines[line+locline-1]:=s;
end;

begin
Printer.Canvas.Font:=Rich.Font;SetPageSize;
line:=0;comboind:=combo.itemindex;cmb:=comboind;
with rich do begin
if compCheck.checked then begin nrafis:=combo.items.count;comboind:=0;end
   else nrafis:=1;
DefAttributes.Style:=[];
for j:=1 to nrafis do begin
inc(comboind);GetTotalCol(comboind);
nrcol:=totalcol;startcol:=1;
lines.add('');lines.add('');SelAttributes.Style:=[fsBold];
lines.add(umple(' ',indent)+UpperCase(combo.Items.Strings[comboind-1]));
SelAttributes.Style:=[];combo.itemindex:=comboind-1;Application.ProcessMessages;
line:=line+3;
repeat
nrcol:=minim(nrcol,totalcol-startcol+1);
SelAttributes.Style:=[fsItalic];
while dispLine(0,-1,-1,startcol,nrcol,-1)<>0 do dec(nrcol);inc(line);
SelAttributes.Style:=[];
lines.add(umple(' ',indent)+umple('—',(xcol+spatiu)*nrcol+fix));inc(line);
nropt:=0;indexu:=0;nrore:=0;
for i:=0 to checkPan.ControlCount-1 do with TCheckBox(checkPan.Controls[i])do
    if checked and enabled and(tag>=0) then inc(nropt);
if opt>=3 then begin nropt:=1;
   case opt of
        3: nrore:=GetZileOre(comboind,1);
        4: nrore:=GetZileOre(comboind,4);
        5: nrore:=nrclassel;end;
   for m:=1 to nrore do displine(m,nropt,Tag,startcol,nrcol,1);
   end else
   for i:=0 to checkPan.ControlCount-1 do with TCheckBox(checkPan.Controls[i]) do
    if checked and enabled and(tag>=0) then begin inc(indexu);
       if indexu=1 then case opt of
         0:nrore:=GetZileOre(comboind,2);
         1:nrore:=GetZileOre(comboind,3);
         2:nrore:=nrclassel;
         end;
       for m:=1 to nrore do displine(m,nropt,Tag,startcol,nrcol,indexu);
    end;
startcol:=startcol+nrcol;
line:=lines.count+ord(startcol<=totalcol);
if startcol<=totalcol then lines.add('');
until startcol>totalcol;
end;//for
end;//with
combo.itemindex:=cmb;
end;

procedure TtipFRM.tipGroupClick(Sender: TObject);
var i:integer;
begin
clasCheck.enabled:=true;profCheck.enabled:=true;combo.items.clear;
case tipGroup.itemindex of
0: begin clasCheck.enabled:=false;
   for i:=1 to nrclasSel do combo.items.add(clasN[clasI[i,1]^]^);end;
1: begin profCheck.enabled:=false;
   for i:=1 to nrprof do combo.items.add(profN[i]^);end;
2: begin for i:=1 to maxzile do combo.items.add(zileN[i]);end;
end;
combo.itemindex:=0;
end;

procedure TtipFRM.RefreshMnClick(Sender: TObject);
var visi:boolean;sumar:integer;
begin
visi:=Rich.Visible;
Status.SimpleText:='Asteptati...';RichRefresh:=true;
if not firstTime then Rich.Visible:=False
   else firstTime:=False;
Rich.Clear;tipFRM.Enabled:=false;
if sumCheck.Checked then sumar:=3 else sumar:=0;
getTotalCol(0);
try
   disp(tipGroup.itemindex+sumar);
finally
   tipFRM.Enabled:=true;Rich.Visible:=visi;
   RichRefresh:=false;
end;
Rich.SelStart:=0;Status.SimpleText:='';FormResize(self);
end;

procedure TtipFRM.getTotalCol(comboind:integer);
var sumar:integer;
begin
if sumCheck.Checked then sumar:=3 else sumar:=0;
case tipGroup.itemindex+sumar of
     0:totalcol:=GetZileOre(comboind,1);
     1:totalcol:=GetZileOre(comboind,4);
     2,5:totalcol:=GetZileOre(comboind,5);
     3:totalcol:=GetZileOre(comboind,2);
     4:totalcol:=GetZileOre(comboind,3);end;
end;

procedure TtipFRM.leftRigth(Sender: TObject);
var pas,index:integer;
begin
if combo.itemindex=-1 then exit;
pas:=TButton(sender).tag;
with combo do begin
index:=itemindex;index:=index+pas;
if index>Items.count then index:=Items.count-1;if index<0 then index:=0;
itemindex:=index;end;
end;

procedure TtipFRM.closeButClick(Sender: TObject);
begin
//with mainFRM.DividerMn do begin Style:=tbsSeparator;Refresh;end;
removeItem(winPos,'tipWin');FirstTime:=True;
mainFRM.SetEditTool(false);
mainFRM.openTipMn.Enabled:=False;mainFRM.saveTipMn.Enabled:=false;
tipFRM.Release;tipFRM:=nil;
end;

function TtipFRM.CurrText: TTextAttributes;
begin
if rich.SelLength>0 then Result:=rich.SelAttributes
  else Result:=rich.DefAttributes;
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
begin
TStrings(Data).Add(LogFont.lfFaceName);Result:=1;
end;
procedure TtipFRM.GetFontNames;
var DC:HDC;
begin
//DC:=GetDC(0);
//EnumFonts(DC,nil,@EnumFontsProc,Pointer(mainFRM.FontsCombo.Items));
//ReleaseDC(0,DC);mainFRM.FontsCombo.Sorted:=True;
end;

procedure TtipFRM.BoldMnClick(Sender: TObject);
begin
if fsBold in CurrText.Style then CurrText.Style:=CurrText.Style - [fsBold]
   else CurrText.Style:=CurrText.Style + [fsBold];
RichSelectionChange(nil);
end;
procedure TtipFRM.ItalicMnClick(Sender: TObject);
begin
if fsItalic in CurrText.Style then CurrText.Style:=CurrText.Style - [fsItalic]
   else CurrText.Style:=CurrText.Style + [fsItalic];
RichSelectionChange(nil);
end;
procedure TtipFRM.UnderMnClick(Sender: TObject);
begin
if fsUnderline in CurrText.Style then CurrText.Style:=CurrText.Style - [fsUnderline]
   else CurrText.Style:=CurrText.Style + [fsUnderline];
RichSelectionChange(nil);
end;
procedure TtipFRM.AlignButtonClick(Sender: TObject);
begin
Rich.Paragraph.Alignment := TAlignment(TControl(Sender).Tag-4);
RichSelectionChange(nil);
end;
procedure TtipFRM.BulletsMnClick(Sender: TObject);
begin
//Rich.Paragraph.Numbering := TNumberingStyle(mainFRM.bulletsBut.Down);
RichSelectionChange(nil);
end;
procedure TtipFRM.wrapMnClick(Sender: TObject);
begin
if wrapMn.Checked then begin Rich.WordWrap:=False;
   wrapMn.Checked:=false;end
else begin Rich.WordWrap:=true;wrapMn.Checked:=true;end
end;

procedure TtipFRM.FontsChange(Sender: TObject);
var i,code:integer;
begin
{CurrText.Name:=mainFRM.FontsCombo.Text;
Val(mainFRM.SizeCombo.Text,i,Code);
if code=0 then CurrText.Size:=i;
}Rich.SetFocus;
end;

procedure TtipFRM.RichKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin RichRefresh:=True;end;
procedure TtipFRM.RichKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin RichRefresh:=False;RichSelectionChange(Self)end;

procedure TtipFRM.RichSelectionChange(Sender: TObject);
begin
if (RichRefresh)and(Sender<>nil) then exit;
with mainFRM do begin
{BoldBut.Down := fsBold in rich.SelAttributes.Style;
ItalicBut.Down := fsItalic in rich.SelAttributes.Style;
UnderBut.Down := fsUnderline in rich.SelAttributes.Style;
BulletsBut.Down := Boolean(rich.Paragraph.Numbering);
SizeCombo.Text := inttostr(rich.SelAttributes.Size);
FontsCombo.Text := rich.SelAttributes.Name;
leftBut.down:=false;centerBut.down:=false;rightBut.down:=false;end;
with Rich.Paragraph do begin
case Ord(Alignment) of
0: mainFRM.LeftBut.Down := True;
1: mainFRM.RightBut.Down := True;
2: mainFRM.CenterBut.Down := True;
end;}end;end;

procedure TtipFRM.PrintSetupMnClick(Sender: TObject);
begin
PrintSetupDlg.Execute;SetPageSize;
end;

procedure TtipFRM.SetPageSize;
begin
xpix:=Printer.PageWidth;ypix:=Printer.PageHeight;
maxs:='';while Printer.Canvas.TextWidth(maxs)<xpix do maxs:=maxs+'0';
xscr:=tipFRM.Canvas.TextWidth(maxs);
FormResize(self);
end;

procedure TtipFRM.FormResize(Sender: TObject);
var R:TRect;FormFont:TFont;GutterWid:integer;
begin
if tipFRM=nil then exit;
if tipFRM.width<550 then tipFRM.width:=550;
FormFont:=tipFRM.Font;tipFRM.Font:=Rich.Font;
with Rich do begin
GutterWid:=trunc((ClientWidth-xscr)/2);
R := Rect(GutterWid,0,ClientWidth-GutterWid,ClientHeight);
SendMessage(Handle, EM_SETRECT, 0, Longint(@R));
end;
tipFRM.Font:=FormFont;
end;

procedure TtipFRM.PrintMnClick(Sender: TObject);
begin
if PrintDlg.Execute then begin
   Rich.print('Orar Scolar (CD)');
   end;
end;

procedure TtipFRM.FormActivate(Sender: TObject);
begin
defilare(tipFRM.Caption,tipFRM);
if refreshBut.Enabled and firsttime then refreshBut.OnClick(sender);
end;

procedure TtipFRM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
closeButClick(sender);
end;









procedure TtipFRM.xcolSpinClick(Sender: TObject; Button: TUDBtnType);
begin
xcol:=xcolSpin.Position;
end;






end.
