unit dataU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Menus, SeleWin, Grids, EdPanel;

type
  TdataF = class(TForm)
    butP: TPanel;
    okB: TButton;
    cancelB: TButton;
    Status: TStatusBar;
    helpB: TButton;
    delB: TButton;
    upB: TButton;
    downB: TButton;
    sortB: TButton;
    dataPag: TPageControl;
    matTab: TTabSheet;
    aniTab: TTabSheet;
    profTab: TTabSheet;
    saliTab: TTabSheet;
    saliL: TLabel;
    saliLst: TListBox;
    nrsaliEd: TEdit;
    nrsaliSpin: TUpDown;
    matP: TPanel;
    profcatLst: TListBox;
    profcatL: TLabel;
    catP: TPanel;
    leftB: TButton;
    rightB: TButton;
    matcatL: TLabel;
    matcatLst: TListBox;
    profilB: TButton;
    tipMatPop: TPopupMenu;
    semMn: TMenuItem;
    labMn: TMenuItem;
    catB: TButton;
    clabMn: TMenuItem;
    semChk: TCheckBox;
    labChk: TCheckBox;
    SeleWin: TSeleWin;
    nrsaliM: TMemo;
    distGrid: TStringGrid;
    distL: TLabel;
    optTab: TTabSheet;
    secoL: TLabel;
    anioL: TLabel;
    compoL: TLabel;
    compLst: TListBox;
    secCmb: TComboBox;
    aniCmb: TComboBox;
    matoL: TLabel;
    matoLst: TListBox;
    addoptB: TButton;
    deloptB: TButton;
    secEdP: TEdPanel;
    aniEdP: TEdPanel;
    grupeEdP: TEdPanel;
    profilEdP: TEdPanel;
    matEdP: TEdPanel;
    profEdP: TEdPanel;
    catEdP: TEdPanel;
    corpEdP: TEdPanel;
    gradeEdP: TEdPanel;
    allmatChk: TCheckBox;
    procedure matEdKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure matLstClick(Sender: TObject);
    procedure okBClick(Sender: TObject);
    procedure cancelBClick(Sender: TObject);
    procedure refreshStatus;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure helpBClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure modiFont;
    procedure matLstKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure editButClick(Sender: TObject);
    procedure matLstEnter(Sender: TObject);
    procedure aniLstEnter(Sender: TObject);
    procedure profLstEnter(Sender: TObject);
    procedure sortBClick(Sender: TObject);
    procedure grupeEdEnter(Sender: TObject);
    procedure cursMnClick(Sender: TObject);
    procedure secEdEnter(Sender: TObject);
    procedure profLstClick(Sender: TObject);
    procedure catEdEnter(Sender: TObject);
    procedure corpEdEnter(Sender: TObject);
    procedure dataPagChange(Sender: TObject);
    procedure nrsaliSpinClick(Sender: TObject; Button: TUDBtnType);
    procedure saliLstDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure saliLstClick(Sender: TObject);
    procedure profilEdEnter(Sender: TObject);
    procedure rightBClick(Sender: TObject);
    procedure profilBClick(Sender: TObject);
    procedure applyBClick(Sender: TObject);
    procedure closeBClick(Sender: TObject);
    procedure profilBEnter(Sender: TObject);
    procedure catBClick(Sender: TObject);
    procedure semChkClick(Sender: TObject);
    procedure distGridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure secCmbChange(Sender: TObject);
    procedure aniCmbChange(Sender: TObject);
    procedure addoptBClick(Sender: TObject);
    procedure deloptBClick(Sender: TObject);
    procedure leftBClick(Sender: TObject);
    procedure gradeEdPEdOnEnter(Sender: TObject);
    procedure gradeEdPListOnClick(Sender: TObject);
    procedure secEdPListOnClick(Sender: TObject);
    procedure aniEdPListOnClick(Sender: TObject);
    procedure grupeEdPListOnClick(Sender: TObject);
    procedure corpEdPListOnClick(Sender: TObject);
    procedure profEdPListOnKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure catEdPListOnClick(Sender: TObject);
    procedure profilEdPListOnClick(Sender: TObject);
    procedure allmatChkClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    procedure refreshSali(tip:integer);
    procedure reloadSec;
    procedure reloadAni;
    procedure reloadMat;
    procedure SetCorpHead;
    procedure AddDel(Sender:TObject);
    function checkAni(indsec,indan:integer): boolean;

  end;

var
  dataF: TdataF;

implementation

{$R *.DFM}
uses gen,procs,mainU,OrrClass;
const
   p_sec=1;
   p_an=2;
   p_gr=3;
   p_mat=10;
   p_prof=20;
   p_catprof=30;
   p_catmat=35;
   p_corp=40;
   p_grade=50;

var lista:Tlistbox;edit:TEdit;
    poz,max:integer;
    OrarData:TOrar;

procedure TDataF.FormShow(Sender: TObject);
begin
refreshStatus;
end;

procedure TDataF.modiFont;
//var F:TFont;
begin
//F:=mainF.fontdlg.font;
//matLst.font:=F;matEd.font:=F;
//profLst.font:=F;profEd.font:=F;
//aniLst.font:=F;aniEd.font:=F;
end;

procedure TDataF.FormCreate(Sender: TObject);
begin
lista:=nil;
OrarData:=TOrar.Create;
OrarData.Assign(orar);
SeleWin.OkB.OnClick:=applyBClick;
SeleWin.closeB.OnClick:=closeBClick;
dataPag.SendToBack;
modiFont;
if not OrarData.Empty then begin
   matEdP.items.clear;aniEdP.List.Clear;
   profEdP.items.clear;
   with OrarData.Grups do begin
     Mats.Items.TipToStrings(@matEdP.Items,t_curs);
     Mats.Items.TipToStrings(@matoLst.Items,t_curs);
     Sec.Items.ToStrings(@secEdP.Items);
     Sec.Items.ToStrings(@secCmb.Items);
     Profs.Items.ToStrings(@profEdP.Items);
     Profs.Cat.Items.ToStrings(@catEdP.Items);
	  Mats.Cat.Items.ToStrings(@profilEdP.Items);
     Corp.ToStrings(@corpEdP.Items);
     Profs.Grade.ToStrings(@gradeEdP.List.Items);
     refreshSali(2);
     end;
   end
else {listele au continut default};
//secEdEnter(nil);matLstClick(nil);
end;

procedure TdataF.helpBClick(Sender: TObject);
var s:string;
begin
s:='Taste:'+crlf+crlf;
s:=s+'DELETE'+tab+'Sterge selectia'+crlf;
s:=s+'INS, ENTER'+tab+'Modifica selectia'+crlf;
s:=s+'CTRL+UP'+tab+'Muta selectia in sus'+crlf;
s:=s+'CTRL+DOWN'+tab+'Muta selectia in jos'+crlf;
s:=s+'CTRL+S'+tab+'Sorteaza in ordine alfabetica';
MessageDlg(s,mtinformation,[mbOk],0);
end;

procedure TDataF.refreshStatus;
var indAn,indSec:integer;s1,s2,s3:string;
begin
with status do with OrarData.Grups do begin
s1:='0';s2:='0';s3:='0';
indSec:=secEdP.ListIndex+1;
indAn:=aniEdP.ListIndex+1;
if not checkAni(indSec,indAn) then exit;
s1:=inttostr(Sec.Count);
if Sec[indSec].Count>0 then begin
   s2:=inttostr(Sec[indSec].Items.Count);
   if Sec[indSec][indAn].Count>0 then
      s3:=inttostr(Sec[indSec][indAn].Items.Count);
end;
SimpleText:='Sectii: '+s1+' Ani: '+s2+' Grupe: '+s3
	+' Materii: '+inttostr(Mats.Items.Count)+' Profesori: '+inttostr(Profs.Items.Count);
end;
end;

procedure TdataF.secEdPListOnClick(Sender: TObject);
var indsec:integer;
begin
indsec:=secEdP.ListIndex+1;
aniEdP.List.Clear;
grupeEdP.List.Clear;
if not checkAni(indsec,1) then exit;
with OrarData.Grups do begin
   Sec[indSec].Items.ToStrings(@aniEdP.Items);
   Sec[indSec][1].Items.ToStrings(@grupeEdP.Items);
end;//with
end;

procedure TdataF.aniEdPListOnClick(Sender: TObject);
var indsec,indan:integer;
begin
indsec:=secEdP.ListIndex+1;indan:=aniEdP.ListIndex+1;
if not checkAni(indsec,indan) then exit;
grupeEdP.List.Clear;
OrarData.Grups.Sec[indSec][indAn].Items.ToStrings(@grupeEdP.Items);
end;

procedure TdataF.grupeEdPListOnClick(Sender: TObject);
begin
;
end;

procedure TdataF.corpEdPListOnClick(Sender: TObject);
var indcorp:integer;
begin
saliLst.Clear;
with OrarData.Grups do
   if Corp.Count>0 then begin
      indcorp:=corpEdP.ListIndex+1;
      if (TCorp(Corp[indCorp]).Count>0)then
         TCorp(Corp[indCorp]).ToStrings(@saliLst.Items);
   end;
end;

procedure TDataF.matLstClick(Sender: TObject);
var index,cmat:integer;
begin
with OrarData.Grups do begin
if poz=p_mat then with Mats do begin
   index:=matEdP.ListIndex+1;
   if not Items.ExistIndex(index) then exit;
   cmat:=Items.iTipToCod(index,t_curs);
   semChk.Tag:=1;labChk.Tag:=1;//sa nu intre in event
   if Items.ExistTip(cmat,t_sem)>0 then
   	semChk.Checked:=True else semChk.Checked:=False;
   if Items.ExistTip(cmat,t_lab)>0 then
   	labChk.Checked:=True else labChk.Checked:=False;
   semChk.Tag:=0;labChk.Tag:=0;//acum poate sa intre in event
	end;
end;//with;
end;

procedure TDataF.matEdKeyPress(Sender: TObject; var Key: Char);
var i,j,indAn,indSec,indCorp,indSali:integer;
        It:TItem;s:string;cod:TCod;index:integer;
begin
s:=SentenceCase(Trim(edit.text));
if ((lista.items.Count>=max)and(lista.tag=-1))or(key<>#13)or(s='')then exit;
It:=TItem.Create;
indSec:=secEdP.ListIndex+1;
indAn:=aniEdP.ListIndex+1;j:=0;
indCorp:=corpEdP.ListIndex+1;
if lista.tag<>-1 then begin
   OrarData.Grups.CompItems(poz,indSec,indAn,indCorp)[lista.tag+1].Val:=s;
   lista.items.strings[lista.tag]:=s;
   case poz of
      p_mat: saliLst.Refresh;
      p_corp:SetCorpHead;
   end;
   lista.tag:=-1;edit.text:='';exit;end;
for i:=0 to lista.items.count-1 do
   if lista.Items.Strings[i]=SentenceCase(Trim(edit.text))then j:=1;
if j=0 then begin
   if (Sender<>semChk)and(Sender<>labChk)then begin
      lista.items.add(s);
      lista.ItemIndex:=lista.Items.Count-1;
      It.CParent:=0;
      if poz=p_mat then It.Tip:=t_curs;
      end;
   indSec:=secEdP.ListIndex+1;
   indAn:=aniEdP.ListIndex+1;
   indCorp:=corpEdP.ListIndex+1;
   it.Val:=s;edit.text:='';
   with OrarData.Grups do case poz of
      p_sec: Sec.AddItem(It);
      p_an:  Sec[indSec].AddItem(It);
      p_gr:  Sec[indSec][indAn].AddItem(It);
      p_mat: begin
         if Sender=semChk then It.Tip:=t_sem;
         if Sender=labChk then It.Tip:=t_lab;
         index:=matEdP.ListIndex+1;
         if It.Tip=t_curs then begin
            matolst.Items.Add(It.Val);
            end;
         if It.Tip>t_curs then begin
            if index>0 then cod:=Mats.Items.iTipToCod(index,t_curs) else cod:=0;
         	if cod<>0 then It.CParent:=cod else begin ShowMessage('error');exit;end;
         	end;
         cod:=CompItems(poz,indSec,indAn,indCorp).AddWithCod(It);
         if (indcorp<>0)and(corpEdP.Items.Count<>0)then begin
            for i:=1 to Corp.Count do
                TCorp(Corp[i]).AddItem(It);
            with saliLst do begin
            	Items.Add(s);ItemIndex:=Items.Count-1;
            	indsali:=itemindex+1;end;
            TSala(TSali(Corp[indCorp])[indsali]).CMat:=cod;
            end;
         end;
      p_prof:
      	CompItems(poz,indSec,indAn,indCorp).AddWithCod(It);
      p_catprof:
      	begin
         CompItems(poz,indSec,indAn,indCorp).AddWithCod(It);
         Profs.Cat.CreateGrp(It.Cod);
      	end;
      p_catmat:
      	begin
         CompItems(poz,indSec,indAn,indCorp).AddWithCod(It);
         Mats.Cat.CreateGrp(It.Cod);
      	end;
      p_corp:
      	begin Corp.AddItem(It);
      	refreshSali(1);
         refreshSali(2);
         end;
      p_grade:
         begin
         Profs.Grade.AddWithCod(It);
         end;
      end;
   end;
matLstClick(nil);It.Free;
if (Sender<>semChk)and(Sender<>labChk)then
	lista.ItemIndex:=lista.Items.Count-1;
end;
{--------------------------------------------------------------}
procedure TDataF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var pozi:integer;
begin
if lista=nil then exit;
pozi:=lista.itemindex;
if (pozi=-1)or(not lista.focused) then exit;
if (key=vk_insert)or(key=13) then
	if (lista.Items.Count>0)then begin
   	edit.Text:=lista.items.strings[pozi];
   	edit.SetFocus;lista.tag:=pozi;
   	exit;end;
end;
{--------------------------------------------------------------}
procedure TdataF.profEdPListOnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var index:integer;
begin
index:=profEdP.ListIndex;
if (index=-1)or(profEdP.Items.Count<=0)then exit;
with OrarData.Grups do begin
if key=vk_delete then begin
	profEdP.Items.Delete(index);
   Profs.delMatCat(Profs.Items.IndexToCod(index+1));
	Profs.Items.Del(index+1);
   profEdP.ListIndex:=index-1;
   profEdP.List.Tag:=-1;
   catEdP.ListOnClick(nil);
	end;
if (shift=[ssCtrl])and(key=vk_up)and(index>0) then begin
   Profs.Items.Switch(1+index,1+index-1);
   profEdP.Items.Exchange(index,index-1);
   Key:=0;profEdP.List.Tag:=-1;
end;
if (shift=[ssCtrl])and(key=vk_down)and(index<profEdP.Items.Count-1) then begin
   Profs.Items.Switch(1+index,1+index+1);
   profEdP.Items.Exchange(index,index+1);
   Key:=0;profEdP.List.Tag:=-1;
end;
end;
end;

procedure TDataF.matLstKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i,j,index,imat,indAn,indSec,indCorp,tip,cod:integer;
begin
if (lista.ItemIndex=-1)or(lista.Items.Count<=0)then exit;
tip:=t_curs;imat:=0;
if Sender=semChk then tip:=t_sem;
if Sender=labChk then tip:=t_lab;
index:=lista.Itemindex;
indCorp:=corpEdP.ListIndex+1;
indSec:=secEdP.ListIndex+1;
indAn:=aniEdP.ListIndex+1;
with OrarData.Grups do begin
if poz=p_mat then begin
   if allmatChk.Checked then begin
      //cod:=Mats.Items.IndexToCod(index+1);
      tip:=Mats.Items[index+1].Tip;
      imat:=index;
   end else begin
      cod:=Mats.Items.iTipToCod(index+1,t_curs);
      imat:=Mats.Items.ExistTip(cod,tip)-1;
   end;
   if imat<0 then
      ShowMessage('sterg ceva ce nu exista');
   end;
if key=vk_delete then begin
	if (tip=t_curs)or(allmatChk.Checked) then lista.Items.Delete(index);
   if (poz=p_mat)and(indcorp<>0)and(corpEdP.Items.Count>0)then begin
      i:=Mats.Items.IndexToCod(imat+1);
      i:=TCorp(Corp[indCorp]).CodToIndex(i);
      for j:=1 to Corp.Count do TCorp(Corp[j]).DelItem(i);
   	RefreshSali(0);
	end;
   case poz of
      p_sec: Sec.DelItem(index+1);
      p_an: Sec[indSec].DelItem(index+1);
   	p_gr: Sec[indSec][indAn].DelItem(index+1);
		p_mat: begin
         Mats.delMatCat(Mats.Items.IndexToCod(imat+1));
         DelOpt(Mats.Items.IndexToCod(imat+1));
			if tip=t_curs then begin
      		CompItems(poz,indSec,indAn,indCorp).DelAll(imat+1);
            if allmatChk.Checked then allmatChkClick(nil)
         end else
            CompItems(poz,indSec,indAn,indCorp).Del(imat+1);
         profilEdP.ListOnClick(nil);
         end;
      p_catprof,p_catmat:
			if tip=t_curs then
      		CompItems(poz,indSec,indAn,indCorp).DelAll(index+1)
			else
            CompItems(poz,indSec,indAn,indCorp).Del(index+1);
      p_corp:begin Corp.DelItem(index+1);
         refreshSali(0);refreshSali(2);end;
      end;
   if (tip=t_curs)or(allmatChk.Checked) then lista.ItemIndex:=index-1;
   refreshStatus;lista.tag:=-1;
   matLstClick(nil);exit;
   end;
if (shift=[ssCtrl])and(key=vk_up)and (index>0) then begin
   case poz of
      p_sec: Sec.Switch(1+index,1+index-1);
      p_an:  Sec[indSec].Switch(1+index,1+index-1);
      p_gr:  Sec[indSec][indAn].Switch(1+index,1+index-1);
      p_mat: CompItems(poz,indSec,indAn,indCorp).Switch(1+imat,1+imat-1);
      p_prof,p_catprof,p_catmat:
      	CompItems(poz,indSec,indAn,indCorp).Switch(1+index,1+index-1);
      p_corp: begin
         Corp.Switch(1+index,1+index-1);
         refreshSali(2);
         end;
   	end;
   lista.Items.Exchange(index,index-1);lista.tag:=-1;
   lista.itemindex:=index-1;key:=0;matLstClick(nil);exit;
   end;
if (shift=[ssCtrl])and(key=vk_down)and(index<lista.items.count-1) then begin
   case poz of
      p_sec: Sec.Switch(1+index,1+index+1);
      p_an:  Sec[indSec].Switch(1+index,1+index+1);
      p_gr:  Sec[indSec][indAn].Switch(1+index,1+index+1);
      p_mat: CompItems(poz,indSec,indAn,indCorp).Switch(1+imat,1+imat+1);
      p_prof,p_catprof,p_catmat:
      	CompItems(poz,indSec,indAn,indCorp).Switch(1+index,1+index+1);
      p_corp: begin
         Corp.Switch(1+index,1+index+1);
         refreshSali(2);
         end;
   	end;
   lista.Items.Exchange(index,index+1);key:=0;lista.tag:=-1;
   lista.itemindex:=minim(index+1,lista.items.count-1);
   matLstClick(nil);exit;
   end;
end;
end;

procedure TdataF.sortBClick(Sender: TObject);
var indSec,indAn:integer;
begin
indSec:=secEdP.ListIndex+1;
indAn:=aniEdP.ListIndex+1;
with OrarData.Grups do begin
case poz of
   p_sec: 	begin lista.Clear;Sec.Sort;
   			Sec.Items.ToStrings(@lista.Items);end;
   p_an: 	begin lista.Clear;Sec[indSec].Sort;
   			Sec[indSec].Items.ToStrings(@lista.Items);end;
   p_gr: 	begin lista.Clear;Sec[indSec][indAn].Sort;
   			Sec[indSec][indAn].Items.ToStrings(@lista.Items);end;
   p_mat:	begin lista.Sorted:=True;Mats.Items.Sort;
   			lista.Sorted:=False;
   			end;
   p_prof:	begin lista.Clear;Profs.Items.Sort;
   			Profs.Items.ToStrings(@lista.Items);end;
   p_corp:	begin
            lista.Clear;
            Corp.Sort;
   			Corp.Items.ToStrings(@lista.Items);
            refreshSali(2);
            end;
	end;
end;
//with lista do begin Sorted:=true;Sorted:=false;end;
case poz of
	p_mat,p_corp: refreshSali(0);
   end;
end;
{--------------------------------------------------------------}
procedure TDataF.editButClick(Sender: TObject);
var w:word;shift:TShiftState;but:TButton;
begin
but:=TButton(sender);
if but=delB then begin w:=vk_delete;shift:=[];end;
if but=upB then begin w:=vk_up;shift:=[ssCtrl];end;
if but=downB then begin w:=vk_down;shift:=[ssCtrl];end;
matEdP.List.OnKeyDown(lista,w,shift);
end;
{--------------------------------------------------------------}

procedure TDataF.cancelBClick(Sender: TObject);
begin
OrarData.Destroy;
dataF.release;dataF:=nil;
end;

procedure TDataF.okBClick(Sender: TObject);
var indSec,indAn:integer;s:string;
begin
{if matLst.items.count*secLst.items.count*profLst.items.count=0 then
   begin MessageDlg('Nu ati completat toate listele',mtwarning,[mbOk],0);
   exit;end;}
with OrarData.Grups do for indSec:=1 to Sec.Items.Count do
	begin
	if (Sec[indSec].Items.Count<=0) then begin
      s:='Nu ati completat anii la sectia '+inttostr(indSec);
   	MessageDlg(s,mtwarning,[mbOk],0);
      exit;end;
   for indAn:=1 to Sec[indSec].Items.Count do
   	if Sec[indSec][indAn].Items.Count<=0 then begin
      s:='Nu ati completat grupele la sectia '+inttostr(indSec);
      s:=s+', anul '+inttostr(indAn);
      MessageDlg(s,mtwarning,[mbOk],0);
   	exit;end;
   end;
OrarData.Empty:=False;
Orar.Destroy;Orar:=TOrar.Create;
Orar.Assign(OrarData);
cancelBClick(sender);
end;

procedure TDataF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
cancelBClick(sender);
end;

procedure TdataF.secEdEnter(Sender: TObject);
begin
lista:=secEdP.List;edit:=secEdP.Ed;poz:=p_sec;
max:=OrarData.Grups.Sec.Max;lista.Tag:=-1;
end;

procedure TdataF.aniLstEnter(Sender: TObject);
var indSec:integer;
begin
lista:=aniEdP.List;edit:=aniEdP.Ed;poz:=p_an;
indSec:=secEdP.ListIndex+1;lista.Tag:=-1;
if (indSec>0)and(secEdP.Items.Count>0)then
	max:=OrarData.Grups.Sec[indSec].Max else max:=0;
end;

procedure TdataF.grupeEdEnter(Sender: TObject);
var indAn,indSec:integer;
begin
lista:=grupeEdP.List;edit:=grupeEdP.Ed;poz:=p_gr;
indAn:=aniEdP.ListIndex+1;lista.Tag:=-1;
indSec:=secEdP.ListIndex+1;
if (indAn>0)and(aniEdP.Items.Count>0)then
   max:=OrarData.Grups.Sec[indSec][indAn].Items.Max else max:=0;
end;

procedure TdataF.matLstEnter(Sender: TObject);
begin
lista:=matEdP.List;edit:=matEdP.Ed;poz:=p_mat;
max:=OrarData.Grups.Mats.Max;lista.Tag:=-1;
end;

procedure TdataF.profLstEnter(Sender: TObject);
begin
lista:=profEdP.List;edit:=profEdP.Ed;poz:=p_prof;
max:=OrarData.Grups.Profs.Max;lista.Tag:=-1;
end;

procedure TdataF.catEdEnter(Sender: TObject);
begin
lista:=catEdP.List;edit:=catEdP.Ed;poz:=p_catprof;
max:=OrarData.Grups.Profs.Cat.Items.Max;lista.Tag:=-1;
end;

procedure TdataF.profilEdEnter(Sender: TObject);
begin
lista:=profilEdP.List;edit:=profilEdP.Ed;poz:=p_catmat;
max:=OrarData.Grups.Mats.Cat.Items.Max;lista.Tag:=-1;
end;

procedure TdataF.corpEdEnter(Sender: TObject);
begin
lista:=corpEdP.List;edit:=corpEdP.Ed;poz:=p_corp;
max:=OrarData.Grups.Corp.Max;lista.Tag:=-1;
end;

procedure TdataF.gradeEdPEdOnEnter(Sender: TObject);
begin
lista:=gradeEdP.List;edit:=gradeEdP.Ed;poz:=p_grade;
max:=OrarData.Grups.Profs.Grade.Max;lista.Tag:=-1;
end;

procedure TdataF.cursMnClick(Sender: TObject);
var indMat,codMat:integer;s,matN:string;key:char;
begin
indMat:=matEdP.ListIndex+1;if indMat=0 then exit;
with OrarData.Grups do begin key:=#13;
codMat:=Mats.Items.IndexToCod(indMat);
matN:=Mats.Items.ByCod(codMat).Val;
s:=matEdP.Ed.Text;
case TMenuItem(Sender).Tag of
   2: begin
   	matEdP.Ed.Text:=matN+' (sem)';
      matEdKeyPress(semChk,key);
      end;
   3: begin
      matEdP.Ed.Text:=matN+' (lab)';
      matEdKeyPress(labChk,key);
   	end;
   4: begin
      matEdP.Ed.Text:=matN+' (sem)';
      matEdKeyPress(nil,key);
   	matEdP.Ed.Text:=matN+' (lab)';
      matEdKeyPress(nil,key);
      end;
	end;
matEdP.Ed.Text:=s;
end;//with
end;

procedure TdataF.profLstClick(Sender: TObject);
var i:integer;
begin
if catEdP.Items.Count>0 then begin
   for i:=1 to ProfEdP.Items.Count do
   	if profEdP.List.Selected[i-1] then;
	end;
with OrarData.Grups do begin
   i:=Profs.Items[ProfEdP.ListIndex+1].Tip;
   if Profs.Grade.ExistCod(i) then
      GradeEdP.List.ItemIndex:=Profs.Grade.CodToIndex(i)-1;
end;
matLstClick(Sender);
end;

procedure TdataF.dataPagChange(Sender: TObject);
begin
catB.Hide;
if dataPag.ActivePage=aniTab then begin
	secEdP.Ed.SetFocus;catP.Hide;end;
if dataPag.ActivePage=profTab then catP.Show;
if dataPag.ActivePage=matTab then
	begin
   catP.Show;catB.Show;end;
if dataPag.ActivePage=saliTab then
	begin catP.Hide;end;
if dataPag.ActivePage=optTab then
   begin catP.Hide;
   reloadMat;
   reloadSec;
   end;
end;

procedure TdataF.nrsaliSpinClick(Sender: TObject; Button: TUDBtnType);
var indsali,indcorp:integer;
begin
indsali:=saliLst.ItemIndex+1;indcorp:=corpEdP.ListIndex+1;
if (indsali=0)or(saliLst.Items.Count=0)then exit;
with OrarData.Grups do with TSala(TSali(Corp[indcorp])[indsali])do begin
   if Sender=nrsaliSpin then NrSali:=nrSaliSpin.Position;
   saliLst.Refresh;
   end;
end;

procedure TdataF.saliLstDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var s,s1:string;indcorp:integer;
begin
if dataPag.ActivePage=matTab then exit;
indcorp:=corpEdP.ListIndex+1;
if (indcorp=0)or(corpEdP.Items.Count=0)then exit;
with (Control as TListBox).Canvas do begin
s:=(Control as TListBox).Items[Index];FillRect(Rect);
if (TListBox(Control).Items.Count>0)and(index<>-1) then with OrarData.Grups do
   begin
   if TSali(Corp[indcorp]).Items.Count>index then
   with TSala(TSali(Corp[indcorp])[index+1]) do begin
      if CMat<>0 then begin
         if Mats.Items.ExistCod(CMat)then
      		s1:=Mats.Items.ByCod(CMat).Val else
            begin s1:=' ';CMat:=0;end;
         end;
		s:=AdjustStr(s1,Mats.Items.MaxLength);
		s:=AdjustStr(inttostr(NrSali),2)+'  '+s;
      end;
   end;
TextOut(Rect.Left+2,Rect.Top,s);
end;
end;

procedure TdataF.saliLstClick(Sender: TObject);
var indsali,indcorp:integer;
begin
indsali:=saliLst.ItemIndex+1;indcorp:=corpEdP.ListIndex+1;
if (indsali>0)and(saliLst.Items.Count>0)then with OrarData.Grups do
   with TSala(TSali(Corp[indcorp])[indsali]) do
   nrsaliSpin.Position:=NrSali;
end;

procedure TdataF.SetCorpHead;
var i:integer;s:string;
begin
with OrarData.Grups do with distGrid do begin
   RowCount:=Corp.Count+1;
   ColCount:=Corp.Count+1;
   FixedCols:=1;FixedRows:=1;
   for i:=1 to Corp.Count do begin
      s:=Corp.Items[i].Val;
      Cells[i,0]:=s;Cells[0,i]:=s;
   end;//for
end;//with
end;

procedure TdataF.refreshSali;
var i,j,indcorp,indsali:integer;it:TItem;
begin
saliLst.Clear;
indcorp:=corpEdP.ListIndex+1;
it:=TItem.Create;
with distGrid do if tip=2 then begin
      Cells[1,0]:='';Cells[0,1]:='';
      SetCorpHead;
      for i:=1 to RowCount-1 do
         for j:=1 to ColCount-1 do
            if i<>j then Cells[j,i]:=inttostr(OrarData.Grups.Corp.dist[i,j])
            else Cells[j,i]:='0';
end;
with OrarData.Grups do if (indcorp<>0)and(corpEdP.Items.Count<>0)then
	case tip of
	0: for i:=1 to TSali(Corp[indcorp]).Count do saliLst.Items.Add(' ');
   1: begin
   	for i:=1 to Mats.Items.Count do begin
      	it.Val:='none';
   		TSali(Corp[indcorp]).AddItem(it);
      	indsali:=TSali(Corp[indcorp]).Count;
      	TSala(TSali(Corp[indcorp])[indsali]).CMat:=Mats.Items.IndexToCod(i);
      	end;
      refreshSali(0);
      end;
   end;//case
it.destroy;
end;

procedure TdataF.AddDel;
var imat,icat,cmat,ccat,index:integer;
	_matLst,_profilLst,_matcatLst:TListBox;
   _Mats:TProfs;
begin
if dataPag.ActivePage=matTab then begin
   _matLst:=matEdP.List;_profilLst:=profilEdP.List;
   _matcatLst:=matcatLst;_Mats:=OrarData.Grups.Mats;
	end
	else begin
   _matLst:=profEdP.List;_profilLst:=catEdP.List;
   _matcatLst:=profcatLst;_Mats:=OrarData.Grups.Profs;
	end;
imat:=_matLst.ItemIndex+1;icat:=_profilLst.ItemIndex+1;
if (icat=0)or(_matLst.Items.Count=0)or(_profilLst.Items.Count=0)then exit;
if (imat=0)and(Sender<>leftB)then exit;
with OrarData.Grups do begin cmat:=0;
if _matLst=matEdP.List then
   if allmatChk.Checked then cmat:=_Mats.Items.IndexToCod(imat)
   else cmat:=_Mats.Items.iTipToCod(imat,t_curs);
if _matLst=profEdP.List then cmat:=_Mats.Items.IndexToCod(imat);
ccat:=_Mats.Cat.Items.IndexToCod(icat);
if TComponent(Sender).Tag=2 then
	if _Mats.Cat.ByCod(ccat).Add(cmat)then
   	_matcatLst.Items.Add(_Mats.Items.ByCod(cmat).Val);
if TComponent(Sender).Tag=1 then begin
   index:=_matcatLst.ItemIndex+1;
   if (index=0)or(_matcatLst.Items.Count=0)then exit;
   _Mats.Cat.ByCod(ccat).Del(index);
   _matcatLst.Items.Delete(_matcatLst.ItemIndex);
	end;
end;
end;

procedure TdataF.catEdPListOnClick(Sender: TObject);
var icat,ccat,i,cprof:integer;
begin
icat:=catEdP.ListIndex+1;
if (icat=0)or(catEdP.Items.Count=0)then exit;
profcatLst.Items.Clear;
with OrarData.Grups do begin
ccat:=Profs.Cat.Items.IndexToCod(icat);
for i:=1 to Profs.Cat.ByCod(ccat).Count do begin
	cprof:=Profs.Cat.ByCod(ccat).ValCod[i];
	profcatLst.Items.Add(Profs.Items.ByCod(cprof).Val);
   end;
end;//with
end;

procedure TdataF.profilEdPListOnClick(Sender: TObject);
var icat,ccat,i,cmat:integer;
begin
icat:=profilEdP.ListIndex+1;
if (icat=0)or(profilEdP.Items.Count=0)then exit;
matcatLst.Items.Clear;
with OrarData.Grups do begin
ccat:=Mats.Cat.Items.IndexToCod(icat);
for i:=1 to Mats.Cat.ByCod(ccat).Count do begin
	cmat:=Mats.Cat.ByCod(ccat).ValCod[i];
	matcatLst.Items.Add(Mats.Items.ByCod(cmat).Val);
   end;
end;//with
end;

procedure TdataF.profilBClick(Sender: TObject);
var sindex,aindex,gindex,index,cod:integer;
begin
if OrarData.Grups.Mats.Cat.Items.Count=0 then exit;
SeleWin.Items.Clear;SeleWin.Items.Add('');
OrarData.Grups.Mats.Cat.Items.ToStrings(@seleWin.Items);
sindex:=secEdP.ListIndex+1;aindex:=aniEdP.ListIndex+1;
gindex:=grupeEdP.ListIndex+1;cod:=-1;
with SeleWin do with OrarData.Grups do case poz of
   p_sec: 	cod:=Sec.Items[sindex].Tip;
   p_an:	  	cod:=Sec[sindex].Items[aindex].Tip;
   p_gr:		cod:=Sec[sindex][aindex].Items[gindex].Tip;
	end;//case
if cod=0 then index:=0 else
	index:=OrarData.Grups.Mats.Cat.Items.CodToIndex(cod);
SeleWin.seleLst.ItemIndex:=index;
SeleWin.Show;
end;

procedure TdataF.applyBClick(Sender: TObject);
var sindex,aindex,gindex,cod,index:integer;
begin
SeleWin.Hide;
if dataPag.ActivePage=aniTab then with OrarData.Grups do begin
	sindex:=secEdP.ListIndex+1;
        aindex:=aniEdP.ListIndex+1;
	gindex:=grupeEdP.ListIndex+1;
   index:=SeleWin.seleLst.ItemIndex;
   if index<>0 then cod:=Mats.Cat.Items.IndexToCod(index) else cod:=0;
	case poz of
   	p_sec: Sec.Items[sindex].Tip:=cod;
   	p_an:	 Sec[sindex].Items[aindex].Tip:=cod;
   	p_gr:	 Sec[sindex][aindex].Items[gindex].Tip:=cod;
		end;//case
   end;
if dataPag.ActivePage=matTab then with OrarData.Grups do begin
   index:=SeleWin.seleLst.ItemIndex;
   if index<>0 then cod:=Profs.Cat.Items.IndexToCod(index) else cod:=0;
   index:=profilEdP.ListIndex+1;
   Mats.Cat.Items[index].Tip:=cod;
   end;
end;

procedure TdataF.closeBClick(Sender: TObject);
begin
seleWin.Hide;
end;

procedure TdataF.profilBEnter(Sender: TObject);
begin
case poz of
p_sec: if (secEdP.ListIndex=-1)or(secEdP.Items.Count=0)then
			secEdP.Ed.SetFocus;
p_an:  if (aniEdP.ListIndex=-1)or(aniEdP.Items.Count=0)then
			aniEdP.Ed.SetFocus;
p_gr:  if (grupeEdP.ListIndex=-1)or(grupeEdP.Items.Count=0)then
			grupeEdP.Ed.SetFocus;
end;
end;

procedure TdataF.catBClick(Sender: TObject);
var index,cod:integer;
begin
if (poz<>p_catmat)then profilEdP.List.SetFocus;
index:=profilEdP.ListIndex+1;
if (index=0)or(profilEdP.Items.Count=0)then begin profilEdP.Ed.SetFocus;exit;end;
SeleWin.Items.Clear;SeleWin.Items.Add('');
with OrarData.Grups do begin
	Profs.Cat.Items.ToStrings(@seleWin.Items);
   index:=profilEdP.ListIndex+1;
   cod:=Mats.Cat.Items[index].Tip;
   if Profs.Cat.Items.ExistCod(cod) then begin
      if cod=0 then index:=0 else
   	   index:=Profs.Cat.Items.CodToIndex(cod);
   	SeleWin.seleLst.ItemIndex:=index;
      SeleWin.Show;
   end;
   end;
end;

procedure TdataF.semChkClick(Sender: TObject);
var keyCR:char;index:integer;s:string;
	ssShift:TShiftState;keyDel:word;
begin
keyCR:=#13;keyDel:=vk_delete;ssShift:=[];
index:=matEdP.ListIndex+1;if index=0 then exit;
s:=matEdP.Items.Strings[index-1];
if Sender=semChk then begin
   if semChk.Tag=1 then exit;
	if semChk.Checked then begin
      edit.Text:=s+' (sem)';
   	matEdKeyPress(semChk,keyCR);end
   	else matLstKeyDown(semChk,keyDel,ssShift);
   end;
if Sender=labChk then begin
   if labChk.Tag=1 then exit;
	if labChk.Checked then begin
      edit.Text:=s+' (lab)';
   	matEdKeyPress(labChk,keyCR);end
   	else matLstKeyDown(labChk,keyDel,ssShift);;
   end;
end;

procedure TdataF.distGridSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: String);
var ival,code:integer;
begin
if distGrid.FixedCols<>1 then exit;
val(Value,ival,code);
if ACol=ARow then
   begin
      distgrid.Cells[ACol,ARow]:='';
      exit;
   end;
if code<>0 then
   begin
      Beep;
      distGrid.Cells[ACol,ARow]:='';
   end
else
   OrarData.Grups.Corp.dist[ARow,ACol]:=ival;
end;


procedure TdataF.reloadSec;
begin
with OrarData.Grups do begin
   secCmb.Clear;
   Sec.Items.ToStrings(@secCmb.Items);
   secCmb.ItemIndex:=0;
   reloadAni;
   end;
end;

procedure TdataF.reloadAni;
var indSec:integer;
begin
with OrarData.Grups do begin
indSec:=secCmb.ItemIndex+1;
if indSec=0 then exit;
aniCmb.Clear;
Sec[indSec].Items.ToStrings(@aniCmb.Items);
aniCmb.ItemIndex:=0;aniCmbChange(nil);
end;
end;

procedure TdataF.reloadMat;
begin
matoLst.Clear;
OrarData.Grups.Mats.Items.ToStrings(@matoLst.Items);
end;

procedure TdataF.secCmbChange(Sender: TObject);
begin
reloadAni;
end;

procedure TdataF.aniCmbChange(Sender: TObject);
var indSec,indAni,i:integer;
begin
with OrarData.Grups do begin
compLst.Clear;
indSec:=secCmb.ItemIndex+1;indAni:=aniCmb.ItemIndex+1;
if indSec*indAni=0 then exit;
with Sec[indSec][indAni] do for i:=1 to Opt.Count do
   compLst.Items.Add(Mats.Items[Mats.Items.CodToIndex(Opt[i])].Val);
end;
end;

procedure TdataF.addoptBClick(Sender: TObject);
var indSec,indAni,indMat:integer;
begin
with OrarData.Grups do begin
indSec:=secCmb.ItemIndex+1;indAni:=aniCmb.ItemIndex+1;
indMat:=matoLst.ItemIndex+1;
if (indSec*indAni=0)or(matolst.Items.Count=0)then exit;
Sec[indSec][indAni].Opt.Add(Mats.Items.IndexToCod(indMat));
aniCmbChange(nil);
end;
end;

procedure TdataF.deloptBClick(Sender: TObject);
var indSec,indAni,indMat:integer;
begin
with OrarData.Grups do begin
indSec:=secCmb.ItemIndex+1;indAni:=aniCmb.ItemIndex+1;
indMat:=compLst.ItemIndex+1;
if (indSec*indAni=0)or(compLst.Items.Count=0)then exit;
Sec[indSec][indAni].Opt.Del(indMat);
aniCmbChange(nil);
end;
end;

procedure TdataF.rightBClick(Sender: TObject);
begin
AddDel(rightB);
end;

procedure TdataF.leftBClick(Sender: TObject);
begin
AddDel(leftB);
end;

procedure TdataF.gradeEdPListOnClick(Sender: TObject);
var cod:integer;
begin
with OrarData.Grups do begin
   if not Profs.Items.ExistIndex(ProfEdP.ListIndex+1) then exit;
   cod:=Profs.Grade.IndexToCod(GradeEdP.List.ItemIndex+1);
   Profs.Items[ProfEdP.ListIndex+1].Tip:=cod;
end;
end;

function TdataF.checkAni;
begin
Result:=False;
with OrarData.Grups do begin
   if not Sec.Items.ExistIndex(indsec) then exit;
   if not Sec[indsec].Items.ExistIndex(indan) then exit;
end;
Result:=True;
end;

procedure TdataF.allmatChkClick(Sender: TObject);
begin
semChk.Enabled:=not allmatChk.Checked;
labChk.Enabled:=not allmatChk.Checked;
matEdP.Items.Clear;
if allmatChk.Checked then
   OrarData.Grups.Mats.Items.ToStrings(@matEdP.Items)
else
   OrarData.Grups.Mats.Items.TipToStrings(@matEdP.Items,t_curs);
end;

END.
