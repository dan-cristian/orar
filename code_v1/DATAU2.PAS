unit dataU2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, checklst, Menus, ExtCtrls, Buttons, ComCtrls;

type
  TdataFRM = class(TForm)
    claspan: TPanel;
    clasEd: TEdit;
    clasList: TListBox;
    clasLab: TLabel;
    matpan: TPanel;
    matList: TListBox;
    matEd: TEdit;
    matLab: TLabel;
    profpan: TPanel;
    profLab: TLabel;
    profEd: TEdit;
    profList: TListBox;
    butpan: TPanel;
    OKbut: TButton;
    Cancelbut: TButton;
    Status: TStatusBar;
    helpBut: TButton;
    delBut: TButton;
    upBut: TButton;
    downBut: TButton;
    procedure matEdKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    function retctrl(sender:TObject;var lista:TListBox;var edit:TEdit):boolean;
    procedure matListClick(Sender: TObject);
    procedure OKbutClick(Sender: TObject);
    procedure CancelbutClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure refreshStatus;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure helpButClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure modiFont;
    procedure matListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure editButClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const dataModi:boolean=false;

var
  dataFRM: TdataFRM;

implementation
  uses mainU2,p;
{$R *.DFM}

procedure TdataFRM.helpButClick(Sender: TObject);
const crlf=#13+#10;
var s:string;
begin
s:='Taste:'+crlf+crlf;
s:=s+'DELETE'+tab+tab+'Sterge selectia'+crlf;
s:=s+'INS, ENTER'+tab+tab+'Modifica selectia'+crlf;
s:=s+'CTRL+UP'+tab+'Muta selectia in sus'+crlf;
s:=s+'CTRL+DOWN'+tab+'Muta selectia in jos';
s:=s+'CTRL+S'+tab+'Sorteaza in ordine alfabetica';
MessageDlg(s,mtinformation,[mbOk],0);
end;

procedure Elib;
var i:integer;
begin
for i:=1 to nrclas do ElibSir(clasN[i]);
for i:=1 to nrmat do ElibSir(matN[i]);
for i:=1 to nrprof do ElibSir(profN[i]);
end;

function TdataFRM.retctrl(sender:TObject;var lista:TListBox;var edit:TEdit):boolean;
var max:integer;
begin
retctrl:=false;max:=0;
if sender=matEd then begin edit:=matEd;lista:=matlist;max:=maxmat;end;
if sender=clasEd then begin edit:=clasEd;lista:=claslist;max:=minim(maxclas,veri1+veri2);end;
if sender=profEd then begin edit:=profEd;lista:=proflist;max:=maxprof;end;
if lista.items.count<max then retctrl:=true;
end;

procedure TdataFRM.refreshStatus;
begin
status.Panels.Items[0].text:='Nr. materii: '+inttostr(matList.Items.Count);
status.Panels.Items[1].text:='Nr. clase: '+inttostr(clasList.Items.Count);
status.Panels.Items[2].text:='Nr. profesori: '+inttostr(profList.Items.Count);
end;

procedure TdataFRM.matEdKeyPress(Sender: TObject; var Key: Char);
var i,j:integer;
    lista:TListbox;Edit:TEdit;
begin
if not retctrl(sender,lista,edit)then exit;
j:=0;
if key=#13 then begin
if lista.tag<>-1 then begin
   lista.items.strings[lista.tag]:=edit.text;
   lista.tag:=-1;edit.text:='';exit;end;
for i:=0 to lista.items.count-1 do
   if lista.Items.Strings[i]=edit.Text then j:=1;
if j=0 then begin lista.items.add(edit.text);edit.text:='';end;
refreshStatus;
end;
end;
{--------------------------------------------------------------}
procedure TdataFRM.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var lista:Tlistbox;edit:TEdit;
    index:integer;
begin
if matlist.focused then begin lista:=matlist;edit:=matEd;end
else if claslist.focused then begin lista:=claslist;edit:=clasEd;end
else {if proflist.focused then }begin lista:=proflist;edit:=profEd;end;
if not lista.focused then exit;
index:=lista.itemindex;if index=-1 then exit;
if (key=vk_insert)or(key=13)then begin
   edit.Text:=lista.items.strings[index];
   lista.tag:=index;edit.SetFocus;exit;end;
end;
{--------------------------------------------------------------}
procedure TdataFRM.matListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var lista:TListBox;index:integer;
begin
lista:=TListBox(Sender);index:=lista.Itemindex;
if key=vk_delete then begin dataModi:=true;lista.Items.Delete(index);refreshStatus;
   lista.itemindex:=minim(index,lista.items.Count-1);exit;end;
if (shift=[ssCtrl])and(key=vk_up)and (index>0) then begin dataModi:=true;
   lista.Items.Exchange(index,index-1);lista.itemindex:=index-1;key:=0;exit;end;
if (shift=[ssCtrl])and(key=vk_down)and(index<lista.items.count-1) then begin
   lista.Items.Exchange(index,index+1);key:=0;dataModi:=true;
   lista.itemindex:=minim(index+1,lista.items.count-1);exit;end;
if (shift=[ssCtrl,ssAlt])and(true)then with lista do begin sorted:=true;sorted:=false;end;
end;
{--------------------------------------------------------------}
procedure TdataFRM.editButClick(Sender: TObject);
var i:integer;w:word;shift:TShiftState;but:TButton;
begin
but:=TButton(sender);
if but=delBut then begin w:=vk_delete;shift:=[];end;
if but=upBut then begin w:=vk_up;shift:=[ssCtrl];end;
if but=downBut then begin w:=vk_down;shift:=[ssCtrl];end;
for i:=0 to ComponentCount-1 do if Components[i] is TListBox then
    if TListBox(Components[i]).itemindex<>-1 then
       matList.OnKeyDown(TObject(Components[i]),w,shift);
end;
{--------------------------------------------------------------}
procedure TdataFRM.matListClick(Sender: TObject);
begin
if sender<>matlist then matlist.itemindex:=-1;
if sender<>claslist then claslist.itemindex:=-1;
if sender<>proflist then proflist.itemindex:=-1;
end;

procedure TdataFRM.CancelbutClick(Sender: TObject);
begin
dataFRM.release;dataFRM:=nil;
end;

procedure TdataFRM.FormResize(Sender: TObject);
const st=10;
var lung,lat:integer;
begin
if dataFRM=nil then exit;
if dataFRM.width<280 then dataFRM.width:=280;
if dataFRM.height<250 then dataFRM.height:=250;
matlist.top:=matEd.top+matEd.height+5;
claslist.top:=clasEd.top+clasEd.height+5;
proflist.top:=profEd.top+profEd.height+5;
lat:=trunc(datafrm.width/3);
lung:=butpan.top-matlist.top-20;
matpan.Width:=lat;profpan.width:=lat;
matEd.width:=lat-20;clasEd.width:=lat-20-5;profEd.width:=lat-20-10-5;
matlist.width:=lat-20;claslist.width:=lat-20-5;proflist.width:=lat-20-10-5;
matlist.height:=lung;claslist.height:=lung;proflist.height:=lung;
end;

procedure TdataFRM.FormShow(Sender: TObject);
begin
refreshStatus;
end;

procedure TdataFRM.modiFont;
var F:TFont;
begin
F:=mainfrm.fontdlg.font;
matlist.font:=F;matEd.font:=F;
proflist.font:=F;profEd.font:=F;
claslist.font:=F;clasEd.font:=F;
formResize(dataFrm);
end;

procedure TdataFRM.FormCreate(Sender: TObject);
var i:integer;
begin
Width:=mainFRM.Width-border;Height:=mainFRM.Height-border;
modiFont;dataModi:=false;
if nrmat*nrprof*nrclas<>0 then begin
   matlist.items.clear;claslist.items.clear;proflist.items.clear;
   for i:=1 to nrmat do matList.items.add(matN[i]^);
   for i:=1 to nrclas do clasList.items.add(clasN[i]^);
   for i:=1 to nrprof do profList.items.add(profN[i]^);
   end
else {listele au continut default};
end;

procedure TdataFRM.OKbutClick(Sender: TObject);
var i:integer;
begin
if matlist.items.count*claslist.items.count*proflist.items.count=0 then
   begin MessageDlg('Nu ati completat toate listele !',mtwarning,[mbOk],0);
   exit;end;
if dataModi then begin
   if (messagedlg('Datele generale au fost modificate.'+crlf+
      'Doriti sa pastrati materiile selectate',mtconfirmation,[mbYes,mbNo],0)=mrYes)
      then exit;
   nrclassel:=0;end;
Elib;
nrmat:=matlist.items.count;
nrclas:=claslist.items.count;
nrprof:=proflist.items.count;
for i:=1 to nrmat do InitSir(matN[i],matlist.Items.strings[i-1]);
for i:=1 to nrclas do InitSir(clasN[i],claslist.Items.strings[i-1]);
for i:=1 to nrprof do initSir(profN[i],proflist.Items.strings[i-1]);
mainFRM.RefreshForms('dataFRM');
cancelButClick(sender);
end;

procedure TdataFRM.FormDestroy(Sender: TObject);
begin RemoveItem(winPos,'dataWin');end;
procedure TdataFRM.FormClose(Sender: TObject; var Action: TCloseAction);
begin cancelButClick(sender);end;
procedure TdataFRM.FormActivate(Sender: TObject);
begin
defilare(dataFRM.Caption,dataFRM);
end;

END.
