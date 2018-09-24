unit OrrClass;

interface

uses Classes,comctrls,Forms;

const
     max_items=200;//mai mare decat toate
     max_ani=10;
     max_sectii=20;
     max_clasL=8;
     max_grupe=50;
     max_mat=200;
     max_prof=200;
     max_Mprof=100;
     max_zile=7;
     max_ore=12;
     max_cond=20;
     max_corp=10;
     max_sali=100;
     max_nrsapt=2;
     max_asoc=10;
     nr_tip_mat=3;
     zileN:array[1..max_zile]of string=
     	('Luni','Marti','Miercuri','Joi','Vineri','Sambata','Duminica');
     tipMatN:array[1..nr_tip_mat]of string=
      ('Curs','Seminar','Laborator');
     t_curs=1;
     t_sem=2;
     t_lab=3;
type
    TStringsP=^TStrings;
    TItem=class;
    TItems=class;
    TProfs=class;
    TGrup=class;
    TGrp=class;
    TRez=class;
    TGrups=class;
    TMItem=class;
    TMItems=class;
    TCat=class;

TVal=string;
TCod=integer;
TTip=integer;

TItem=class
    Cod:TCod;
    Val:TVal;
    // tip materie(curs,sem,lab)
    // (sectii, ani, grupe) - codul profilului
    // profile=catedre
    Tip:TTip;
    CParent:TCod;
    MOreCons:integer;//ore consecutive - config (materie)
    MGradDif:integer;//grad dificultate (materie)
  private
    procedure SaveToFile(var F:TextFile);
    procedure LoadFromFile(var F:TextFile);
  public
    constructor Create;
    procedure Assign(value:TItem);
    procedure SetVal(value:TItem);
  end;

TItems=class
  private
    _maxItems:integer;
    list:array[1..max_items]of TItem;
    _last:integer;
    function ItemRead(Index:Integer):TItem;
    procedure ItemWrite(Index:integer;Value:TItem);
    property ValItem[Index:Integer]:TItem read ItemRead write ItemWrite;default;
    procedure SaveToFile(var F:TextFile);
    procedure LoadFromFile(var F:TextFile);
    procedure Add(value:TItem);
  public
    Cod:TCod;//folosit pt TGrupe
    property Count:integer read _last;
    property Max:integer read _maxItems;
    constructor Create;
    destructor Destroy;override;
    function MaxGradDif:integer;
    function MaxLength:integer;
    procedure Assign(value:TItems);
    function AddWithCod(value:TItem):TCod;
    procedure DelCod(valueCod:TCod);
	 procedure DelAll(index:integer);
    procedure Del(index:integer);
    function ByCod(valueCod:TCod):TItem;
    function FromVal(value:TVal):TItem;
    function ExistCod(valueCod:TCod):boolean;
    function ExistIndex(index:integer):boolean;
    function ExistTip(valueCod:TCod;_tip:integer):integer;
    function CodToIndex(valueCod:TCod):integer;
    function IndexToCod(index:integer):TCod;
    function iTipToCod(index,_tip:integer):TCod;
    function GetFreeCod:TCod;
    procedure Switch(index1,index2:integer);
    procedure Sort;
    function MVal(value:TMItem):string;
    procedure ToStrings(p:TStringsP);
    procedure TipToStrings(p:TStringsP;_tip:integer);
  end;

TProfs=class
    Items:TItems;
    Cat:TCat;
    Grade:TItems;
  private
    _maxProfs:integer;
    function ValRead(Index:Integer):TItem;
    procedure ValWrite(Index:integer;Value:TItem);
    property ValProf[Index:Integer]:TItem read ValRead write ValWrite;default;
    procedure SaveToFile(var F:TextFile);
    procedure LoadFromFile(var F:TextFile);
  public
    Pref:array[1..max_prof,1..max_zile,1..max_ore]of integer;
    property Max:integer read _maxProfs;
    constructor Create;
    destructor Destroy;override;
    procedure Assign(value:TProfs);
    procedure delMatCat(cod:TCod);
  end;

TMats=class(TProfs)
  private
    _maxMats:integer;
  public
    Tip:array[1..3]of string;//curs,sem,lab
    property Max:integer read _maxMats;
    constructor Create;
    procedure Assign(value:TMats);
  end;

TGrp=class
   CMat:TCod;
   CProf:TCod;
   Ora:integer; //nr de ore pe saptamana
   TipAsoc:TCod;//1..n - nr grupare 0-separat
   OreCons:integer;//0-se folosesc cele din configU, restul
   Sapt:integer;//la cate saptamani se face materia
   PozSapt:integer;//in a catea saptamana se pune materia
   CCorp:TCod;//cod cladire in care se face materia
   OGrp:TGrp;//legatura catre alte Grp-uri (pt. 2 saptamani)
  private
	_OraRest:TCod;
   procedure SaveToFile(var F:TextFile);
   procedure LoadFromFile(var F:TextFile);
   procedure WriteOraRest(Value:TCod);
  public
   constructor Create;
   destructor Destroy;override;
   property OraRest:integer read _OraRest write WriteOraRest;
   procedure Assign(value:TGrp);
   procedure SetVal(value:TGrp);
   procedure Clear;
   function Full:boolean;
   function Part:boolean;
   function Egal(value:TGrp):boolean;
  end;

TMItem=class
    Cod:TCod;
  private
    list:array[1..max_items]of TCod;
    last:integer;
    function ValRead(Index:Integer):TCod;
    procedure ValWrite(Index:integer;Value:TCod);
    procedure SaveToFile(var F:TextFile);
    procedure LoadFromFile(var F:TextFile);
  public
  	 property ValCod[Index:Integer]:TCod read ValRead write ValWrite;default;
    property Count:integer read last;
    procedure Assign(value:TMItem);
    function Add(valueCod:TCod):boolean;
    procedure Del(index:integer);
    procedure DelCod(cod:TCod);
    function ExistCod(value:TCod):integer;
  end;

TMItems=class
  private
    list:array[1..max_items]of TMItem;
    last:integer;
    function ValRead(Index:Integer):TMItem;
    procedure ValWrite(Index:integer;Value:TMItem);
    property ValMItem[Index:Integer]:TMItem read ValRead write ValWrite;default;
    procedure SaveToFile(var F:TextFile);
    procedure LoadFromFile(var F:TextFile);
  public
    constructor Create;
    destructor Destroy;override;
    procedure Assign(value:TMItems);
    procedure CreateGrp(valueCod:TCod);
    function GetFreeCod:TCod;
    function CreateWithCod:TCod;
    function CodToIndex(valueCod:TCod):integer;
    function ExistCod(valueCod:TCod):integer;
    function ByCod(valueCod:TCod):TMItem;
    procedure Del(valueCod:TCod);
  end;

TCat=class(TMItems)  //catedre
  Items:TItems;
  private
    procedure SaveToFile(var F:TextFile);
    procedure LoadFromFile(var F:TextFile);
  public
    constructor Create;
    destructor Destroy;override;
    procedure Assign(value:TCat);
  end;

TRez=class
  private
    list:array[1..max_zile,1..max_ore]of TGrp;
{ DONE -oDan -cAlgoritm : S-ar putea sa trebuiasca diferentiere pe saptamani la ore puse }
    _orePuse:array[1..max_zile]of integer;
    function ValRead(zi,ora:Integer):TGrp;
    procedure ValWrite(zi,ora:integer;Value:TGrp);
    property ValRez[zi,ora:integer]:TGrp read ValRead write ValWrite;default;
    procedure SaveToFile(var F:TextFile);
    procedure LoadFromFile(var F:TextFile);
  public
    OreTot:array[1..max_zile]of integer;
    constructor Create;
    destructor Destroy;override;
    procedure Assign(value:TRez);
    function OrePuse(zi:integer):integer;
    procedure CreateGrp(zi,ora:integer;value:TGrp);
    procedure Del(zi,ora,_PozSapt:integer);
    procedure Switch(zi1,ora1,zi2,ora2:integer);
    function Exist(zi,ora:integer):boolean;
    function GetMaxOra:integer;
    function GetMaxZi:integer;
    function getFreePozSapt(zi,ora:integer):integer;
    function getNrPozSapt(zi,ora:integer):integer;
    function getLastPozSapt(zi,ora:integer):integer;
    function getGrp(zi,ora,PozSapt:integer):TGrp;
    function existGrp(zi,ora,PozSapt:integer):boolean;
  end;

TGrup=class
  	Rez:TRez;
  private
   list:array[1..max_items]of TGrp;
   _last:integer;
   _totalore:integer;
   function ValRead(Index:Integer):TGrp;
   procedure ValWrite(Index:integer;Value:TGrp);
   function CodToIndex(cod_prof,cod_mat,_ora:integer):integer;
   procedure SaveToFile(var F:TextFile);
   procedure LoadFromFile(var F:TextFile);
  public
   Cod:integer;
   OreZi:array[1..max_zile]of integer;
   Dif:array[1..max_ore,1..2]of integer;
   property Grp[Index:Integer]:TGrp read ValRead write ValWrite;default;
   property Count:integer read _last;
   property TotalOre:integer read _totalore;
   constructor Create;
   destructor Destroy;override;
   procedure Assign(value:TGrup);
   function Add(value:TGrp):integer;
   procedure DelIndex(index:integer);
   procedure DelS(cod_mat,cod_prof,cod_ora:integer);
   procedure MakeTotalOre;
   procedure ClearGrups;
   function ByGrp(_Grp:TGrp):TGrp;
   function iByMat(cod:integer):integer;
   function gByMat(cod:integer):TGrp;
   end;

TGrupe=class
	Items:TItems;// nume grupe
   Opt:TMItem;// componenta optionale
  private
   _maxGrupe:integer;
   _last:integer;
   _totalOre:integer;
   listg:array[1..max_grupe]of TGrup;//componenta ani
   function GrupRead(Index:Integer):TGrup;
   procedure GrupWrite(Index:integer;Value:TGrup);
   property ValGrup[Index:Integer]:TGrup read GrupRead write GrupWrite;default;
   procedure SaveToFile(var F:TextFile);
   procedure LoadFromFile(var F:TextFile);
   procedure Add(value:TCod);
   function AddWithCod:TCod;
  public
   Cod:integer;
   property Max:integer read _maxGrupe;
   property Count:integer read _last;
   property totalOre:integer read _totalOre;
   constructor Create;
   destructor Destroy;override;
   procedure Assign(value:TGrupe);
   procedure CreateGrup(valueCod:TCod);
   procedure ToStrings(p:TStringsP);
   function ByCod(valueCod:TCod):TGrup;
   function AddItem(value:TItem):TCod;
   procedure DelItem(index:integer);
   function IndexToCod(index:integer):TCod;
   function CodToIndex(valueCod:TCod):integer;
   function ExistCod(valueCod:TCod):boolean;
   procedure ClearGrups;
   procedure MakeTotalOre;
   procedure MakeOreZi(nrZile:integer);
   procedure Switch(index1,index2:integer);
   procedure Sort;
  end;

TAni=class
   Items:TItems; //nume ani
  private
   lista:array[1..max_ani]of TGrupe;
   _last:integer;
   _maxAni:integer;
   _totalOre:integer;
   function GrupeRead(Index:Integer):TGrupe;
   procedure GrupeWrite(Index:integer;Value:TGrupe);
   property ValGrupe[Index:Integer]:TGrupe read GrupeRead write GrupeWrite;default;
   procedure SaveToFile(var F:TextFile);
   procedure LoadFromFile(var F:TextFile);
   procedure Add(valueCod:TCod);
   function AddWithCod:TCod;
  public
   Cod:integer;
   property Max:integer read _maxAni;
   property Count:integer read _last;
   property totalOre:integer read _totalOre;
   constructor Create;
   destructor Destroy;override;
   procedure Assign(value:TAni);
   function AddItem(value:TItem):TCod;
   procedure DelItem(index:integer);
   procedure ToStrings(p:TStringsP);
   function ByCod(valueCod:TCod):TGrupe;
   function IndexToCod(index:integer):TCod;
   function CodToIndex(valueCod:TCod):integer;
   procedure ClearGrups;
   procedure MakeOreZi(nrZile:integer);
   procedure MakeTotalOre;
   procedure Switch(index1,index2:integer);
   procedure Sort;
  end;

TSec=class
   Items:TItems; //nume ani
   Ani:TAni;// ani
  private
   lists:array[1..max_sectii]of TAni;
   _last:integer;
   _maxSec:integer;
   _totalOre:integer;
   function AniRead(Index:Integer):TAni;
   procedure AniWrite(Index:integer;Value:TAni);
   property ValAni[Index:Integer]:TAni read AniRead write AniWrite;default;
   procedure SaveToFile(var F:TextFile);
   procedure LoadFromFile(var F:TextFile);
   procedure Add(valueCod:TCod);
   function AddWithCod:TCod;
  public
   property Max:integer read _maxSec;
   property Count:integer read _last;
   property totalOre:integer read _totalOre;
   constructor Create;
   destructor Destroy;override;
   procedure Assign(value:TSec);
   function AddItem(value:TItem):TCod;
   procedure DelItem(index:integer);
   procedure ToStrings(p:TStringsP);
   function ByCod(valueCod:TCod):TAni;
   function IndexToCod(index:integer):TCod;
   function CodToIndex(valueCod:TCod):integer;
   procedure ClearGrups;
   procedure MakeOreZi(nrZile:integer);
   procedure MakeTotalOre;
   procedure Switch(index1,index2:integer);
   procedure Sort;
   function MaxLengthAni:integer;
   function MaxLengthGrupe:integer;
  end;

TGen=class
   	Items:TItems;
   protected
   	list:array[1..max_items]of TObject;
      _last,_max:integer;
   	function _Read(Index:Integer):TObject;
   	procedure _Write(Index:integer;Value:TObject);
   	property _Val[Index:Integer]:TObject read _Read write _Write;default;
   	procedure SaveToFile(var F:TextFile);virtual;
   	procedure LoadFromFile(var F:TextFile);virtual;
      procedure Add(valueCod:TCod);
	   function AddWithCod:TCod;
   public
      constructor Create;
      destructor Destroy;override;
      procedure Assign(value:TGen);virtual;
      property Count:integer read _last;
      property Max:integer read _max;
   	function CodToIndex(valueCod:TCod):integer;
      procedure ToStrings(p:TStringsP);
      function AddItem(value:TItem):TCod;
	   procedure DelItem(index:integer);
      procedure Switch(index1,index2:integer);virtual;
   	procedure Sort;virtual;
	end;

TSala=class
   CMat:TCod;
   NrSali:integer;
  private
   procedure SaveToFile(var F:TextFile);
   procedure LoadFromFile(var F:TextFile);
  public
   procedure Assign(value:TSala);
   constructor Create;
  end;


TSali=class(TGen)
  private
  	procedure SaveToFile(var F:TextFile);override;
   procedure LoadFromFile(var F:TextFile);override;
  public
   Cod:TCod;
   procedure Assign(value:TGen);override;
	end;

TCorp=class(TGen)
  private
  	procedure SaveToFile(var F:TextFile);override;
   procedure LoadFromFile(var F:TextFile);override;
  public
   dist:array[1..max_corp,1..max_corp]of integer;
   constructor Create;
   destructor Destroy;override;
   function getNrSali(_CMat:TCod):integer;
   function getNrSaliCorp(_CMat,_CCorp:TCod):integer;
   function getCloseCorp(_CCorp:TCod;try_nr:integer):TCod;
   procedure Assign(value:TCorp);reintroduce;
   procedure Switch(index1,index2:integer);override;
   procedure Sort;reintroduce;
  	end;

TGrups=class 			//obiect ani sau clase
  Profs:TProfs;		//profi
  Mats:TMats;  		//materii
  Sec:TSec;				//sectii
  Corp:TCorp;
  MProfs:TMItems;
  private
   _totalOre:integer;
   //_ora1{,_ora2}:integer;	//ora 1 la ultima stergere(Del)
   _profSec,_profAn,_profGr:integer;
   err,errsec,erran,errgr,errmat,errzi,errora:integer;
   //err=0 pt nemutabil
   procedure SaveToFile(var F:TextFile);
   procedure LoadFromFile(var F:TextFile);
   procedure AddCompon(sect,an,gr,zi,ora:integer;_Grp:TGrp);
   procedure DelCompon(sect,an,gr,zi,ora:integer;_PozSapt:integer);
   procedure SwitchCompon(sect,an,gr,zi1,ora1,zi2,ora2:integer);
  public
   oraStart,minStart,oraEnd,minEnd,nrZile,maxOreZi,marjaOre:integer;
   maxFer,minBloc:integer;
   cond:array[1..max_cond]of integer;
   secBar,aniBar,grupeBar:TProgressBar;
   ShowMakeProgress:boolean;
   property totalOre:integer read _totalOre;
   constructor Create;
   destructor Destroy;override;
   procedure Assign(value:TGrups);
   function CompItems(index,indSec,indAn,indCorp:integer):TItems;
   procedure MakeTotalOre;
   procedure MakeOreZi;
   function Put(sect,an,gr,zi,ora:integer;_Grp:TGrp):integer;
   function Del(sect,an,gr,zi,ora,_PozSapt:integer):integer;
   function Switch(sect,an,gr,zi1,ora1,zi2,ora2:integer;canSwitch:boolean):integer;
   function CheckOk(sect,an,gr,zi,ora,ora_start,ora_end:integer;_Grp:TGrp):integer;
   function ReturnErr(errCode:integer):string;
   function ExistProf(_CProf:TCod;zi,ora:integer):boolean;
   function GetMaxOraProf(_CProf:TCod):integer;
   function GetMaxZiProf(_CProf:TCod):integer;
   function GetTotalOreProf(_CProf:TCod):integer;//de la Rez
   function GetOreProf(_CProf:TCod):integer;//de la Date
   function Make:integer;
   function MakeRez:integer;
   function MakeRezPerm:integer;
   function MakeRezSec(sect:integer):integer;
   function MakeRezPermSec(sect:integer):integer;
   function MakeRezAn(sect,an:integer):integer;
   function MakeRezPermAn(sect,an:integer):integer;
   function MakeRezGr(sect,an,gr:integer):integer;
   function MakeRezPermGr(sect,an,gr:integer):integer;
   function MakeRezMat(sect,an,gr:integer;_Grp:TGrp):integer;
   function MakeRezPermMat(sect,an,gr:integer;_Grp:TGrp):integer;
   procedure DelOpt(cmat: TCod);
   function getCorp(_Grp:TGrp;sect,an,gr:TCod;zi,ora:integer):TCod;
   function getSaliOcup(_Grp:TGrp;zi,ora:integer;sect,an:TCod;saliDisp:integer;var errsec,erran,errgr:integer):integer;

  end;

TOrar=class
  Grups:TGrups;
  Zile:TItems;
  private
    F:TextFile;
    _spec:integer;
    procedure Clear;
    procedure writeSpec(value:integer);
  public
    Info:string;
    Empty:boolean;
    clasL:array[1..max_clasL]of string;
    property specific:integer read _spec write writeSpec;
    constructor Create;
    destructor Destroy;override;
    procedure Assign(value:TOrar);
    procedure SaveToFile(FileName:string);
    procedure LoadFromFile(FileName:string);
  end;

implementation
uses rezU,dialogs,sysutils,controls,procs;

//----------------ITEM--------------
constructor TItem.Create;
begin
Val:='';
MOreCons:=1;
Tip:=t_curs;
CParent:=0;
end;

procedure TItem.Assign;
begin
SetVal(value);
end;

procedure TItem.SetVal;
begin
Val:=value.Val;
Cod:=value.Cod;
Tip:=value.Tip;
MOreCons:=value.MOreCons;
MGradDif:=value.MGradDif;
if MOreCons=0 then MOreCons:=1;
CParent:=value.CParent;
end;

procedure TItem.SaveToFile;
begin
write(F,Val,',',Cod,',',Tip);
write(F,',',MoreCons);
write(F,',',MGradDif);
writeln(F,',',CParent);
end;

procedure TItem.LoadFromFile;
var s:string;
begin
readln(F,s);
Val:=paramS(s,1);
Cod:=param(s,2);
Tip:=param(s,3);
MOreCons:=param(s,4);
MGradDif:=param(s,5);
CParent:=param(s,6);
end;

//----------------ITEMS----------------
constructor TItems.Create;
begin
_last:=0;_maxItems:=max_items;
end;

destructor TItems.Destroy;
var i:integer;
begin
for i:=1 to Count do begin ItemRead(i).Free;
    ItemWrite(i,nil);end;
_last:=0;
inherited Destroy;
end;

procedure TItems.Assign;
var i:integer;
begin
_maxItems:=value._maxItems;
_last:=value.Count;
for i:=1 to Count do begin
    list[i]:=TItem.Create;
    ItemRead(i).Assign(value.ItemRead(i));
	 with ItemRead(i) do if Tip=1 then CParent:=Cod;//temporar
    end;
end;

function TItems.ItemRead;
begin
Result:=nil;
if Index>Count then showmessage('read out')
	else Result:=list[Index];
end;

procedure TItems.ItemWrite;
begin
if Index>Count then showmessage('write out')
	else list[Index]:=value;
end;

function TItems.ExistCod;
var i:integer;
begin
for i:=1 to Count do	if (valueCod=ItemRead(i).Cod) then begin Result:=True;exit;end;
Result:=False;
end;

function TItems.ExistIndex;
begin
if (index in [1..Count]) then begin Result:=True;exit;end;
Result:=False;
end;

function TItems.ExistTip;
var i:integer;
begin
Result:=-1;
for i:=1 to Count do
	if (valueCod=ItemRead(i).CParent)then
      if (_tip=ItemRead(i).Tip)then
         begin Result:=i;break;end;
end;

function TItems.CodToIndex;
var i:integer;
begin
Result:=-1;
for i:=1 to Count do if valueCod=ItemRead(i).Cod then begin Result:=i;break;end;
if Result=-1 then ShowMessage('Item not found -CodToIndex-');
end;

function TItems.IndexToCod;
begin
if index>Count then Result:=0 else Result:=ItemRead(index).Cod;
end;

function TItems.iTipToCod;
var i,j:integer;
begin
j:=0;
for i:=1 to Count do begin
	if ItemRead(i).Tip=_tip then inc(j);
   if j=index then break;
   end;
Result:=IndexToCod(i);
end;

procedure TItems.SaveToFile;
var i:integer;
begin
writeln(F,'[ITEMS]');
writeln(F,'nr=',Count);
for i:=1 to Count do ItemRead(i).SaveToFile(F);
writeln(F,'[END-ITEMS]');
end;

procedure TItems.LoadFromFile;
var i:integer;T:TItem;s:string;
begin
T:=TItem.Create;
readln(F,s);//items
readln(F,s);//nr
for i:=1 to param(s,2) do begin
    T.LoadFromFile(F);Add(T);end;
T.Free;
readln(F,s);//end-items
end;

procedure TItems.Add;
begin
inc(_last);
list[Count]:=TItem.Create;
ItemRead(Count).SetVal(value);
end;

function TItems.MaxLength;
var i,max:integer;
begin
max:=0;
for i:=1 to Count do
	max:=maxim(max,length(ItemRead(i).Val));
Result:=max;
end;

function TItems.MaxGradDif;
var i,max:integer;
begin
max:=0;
for i:=1 to Count do max:=maxim(max,ItemRead(i).MGradDif);
Result:=max;
end;

function TItems.AddWithCod;
begin
Result:=-1977;
if Count+1>max_items then begin ShowMessage('Depasire add');exit;end;
value.Cod:=GetFreeCod;
with value do if Tip=1 then CParent:=Cod;
Add(value);
Result:=value.Cod;
end;

procedure TItems.DelAll;
var i,j:integer;
begin
cod:=IndexToCod(index);
for i:=nr_tip_mat downto 1 do begin
	j:=ExistTip(cod,i);
	if j>0 then Del(j);
end;
end;

procedure TItems.Del;
var i:integer;
begin
if index>Count then begin ShowMessage('Depasire del');exit;end;
ItemRead(index).Free;
for i:=index to Count-1 do ItemWrite(i,ItemRead(i+1));
list[Count]:=nil;
dec(_last);
end;

procedure TItems.DelCod;
begin
valueCod:=CodToIndex(valueCod);
Del(valueCod);
end;

function TItems.ByCod;
var i:integer;
begin
for i:=1 to Count do if valueCod=list[i].Cod then begin Result:=list[i];exit;end;
ShowMessage('Item not found');Result:=nil;
end;

function TItems.FromVal;
var i:integer;
begin
for i:=1 to Count do if value=list[i].Val then begin Result:=list[i];exit;end;
ShowMessage('Item not found');Result:=nil;
end;

function TItems.GetFreeCod;
var i,j:integer;found:boolean;
begin
for i:=1 to Count+1 do begin
    found:=false;
    for j:=1 to Count do if list[j].Cod=i then found:=true;
    if not found then begin Result:=i;exit;end;
    end;
ShowMessage('new cod not found');result:=0;
end;

procedure TItems.Switch;
var It:TItem;
begin
It:=ItemRead(index1);
ItemWrite(index1,ItemRead(index2));
ItemWrite(index2,It);
end;

procedure TItems.Sort;
var i,j:integer;
begin
for i:=1 to Count-1 do for j:=i+1 to Count do begin
    if ItemRead(i).Val>ItemRead(j).Val then Switch(i,j);
    end;
end;

function TItems.MVal;
var i:integer;sep:string;
begin Result:='';
for i:=1 to value.Count do begin
    if i=1 then sep:='' else sep:='/';
    Result:=Result+sep+ByCod(value.list[i]).Val;
    end;
end;

procedure TItems.ToStrings;
var i:integer;
begin
for i:=1 to Count do p^.Add(ValItem[i].Val);
end;

procedure TItems.TipToStrings;
var i:integer;
begin
for i:=1 to Count do
   if ValItem[i].Tip=_tip then
      p^.Add(ValItem[i].Val);
end;

//-----------------------PROFS----------------
constructor TProfs.Create;
begin
if 1=2 then ValProf[0]:=ValProf[0];//no hint stress
_maxProfs:=max_prof;
Items:=TItems.Create;
Items._maxItems:=Max;
Cat:=TCat.Create;Cat.Items._maxItems:=Max;
Grade:=TItems.Create;
end;

destructor TProfs.Destroy;
begin
Items.Free;Items:=nil;
Cat.Free;Cat:=nil;
Grade.Free;Grade:=nil;
inherited Destroy;
end;

procedure TProfs.Assign;
var i,zi,ora:integer;
begin
_maxProfs:=value._maxProfs;
Items:=TItems.Create;
Items.Assign(value.Items);
for i:=1 to Items.Count do for zi:=1 to max_zile do
	for ora:=1 to max_ore do Pref[i,zi,ora]:=value.Pref[i,zi,ora];
Cat.Assign(value.Cat);
Grade.Assign(value.Grade);
end;

function TProfs.ValRead;
begin
Result:=nil;
if Index>Items.Count then showmessage('read out') else Result:=Items[Index];
end;

procedure TProfs.ValWrite;
begin
if Index>Items.Count then showmessage('write out') else Items[Index]:=Value;
end;

procedure TProfs.SaveToFile;
var i,zi,ora,countPref:integer;
begin
Items.SaveToFile(F);
Cat.SaveToFile(F);
Grade.SaveToFile(F);
writeln(F,'[PREF]');
for i:=1 to Items.Count do begin countPref:=0;
   for zi:=1 to max_zile do for ora:=1 to max_ore do
    	if Pref[i,zi,ora]=1 then inc(countPref);
   if countPref>0 then begin
   	writeln(F,'IndProf=',i);
		for zi:=1 to max_zile do for ora:=1 to max_ore do
    		if Pref[i,zi,ora]=1 then writeln(F,zi,',',ora);
      end;
	end;
writeln(F,'[END-PREF]');
end;

procedure TProfs.LoadFromFile;
var s:string;indProf,zi,ora:integer;
begin
Items.LoadFromFile(F);
Cat.LoadFromFile(F);
Grade.LoadFromFile(F);
readln(F);indProf:=-1;
repeat
readln(F,s);
if s<>'[END-PREF]' then begin
    if paramS(s,1)='IndProf' then begin
        repeat
    	indProf:=param(s,2);
        readln(F,s);
        until paramS(s,1)<>'IndProf';
        end;
    if s<>'[END-PREF]' then begin
    	zi:=param(s,1);ora:=param(s,2);
    	Pref[indProf,zi,ora]:=1;end;
    end;
until s='[END-PREF]';
end;

procedure TProfs.delMatCat;
var indcat,ind:integer;
begin
for indcat:=1 to Cat.Items.Count do
   for ind:=1 to Cat[indcat].Count do
      if Cat[indcat][ind]=cod then begin
         Cat[indcat].Del(ind);
         break;
      end;
end;

//------------------------MATS-------------
constructor TMats.Create;
var i:integer;
begin
for i:=1 to nr_tip_mat do Tip[i]:=TipMatN[i];
_maxMats:=max_mat;
inherited Create;
//Items:=TItems.Create;
//Items._maxItems:=Max;
end;

procedure TMats.Assign;
begin
_maxMats:=value._maxMats;
inherited Assign(value);
end;

//---------------------GRP-----------------
constructor TGrp.Create;
begin
CProf:=0;CMat:=0;Ora:=0;OraRest:=0;
TipAsoc:=0;OreCons:=0;Sapt:=1;PozSapt:=0;CCorp:=0;
OGrp:=nil;
end;

destructor TGrp.Destroy;
begin
inherited Destroy;
if OGrp<>nil then OGrp.Destroy;
end;

procedure TGrp.Assign;
begin
SetVal(value);
end;

procedure TGrp.SaveToFile;
begin
write(F,CMat,',',CProf,',',Ora,',',OraRest,',',
   TipAsoc,',',OreCons,',',Sapt,',',CCorp,',',Ord(OGrp<>nil),','
   ,',',PozSapt);
if OGrp<>nil then OGrp.SaveToFile(F);
writeln(F);
end;

procedure TGrp.LoadFromFile;
var s:string;
begin
readln(F,s);
CMat:=param(s,1);
CProf:=param(s,2);
Ora:=param(s,3);
OraRest:=param(s,4);
TipAsoc:=param(s,5);
OreCons:=param(s,6);
Sapt:=param(s,7);
CCorp:=param(s,8);
if param(s,9)=0 then
   OGrp:=nil
else
   OGrp:=nil;
PozSapt:=param(s,10);
end;

procedure TGrp.SetVal;
begin
if value.OGrp<>nil then
   begin
      if (OGrp=nil) then
         //ShowMessage('OGrp must be created first');
         OGrp:=TGrp.Create;
      OGrp.Assign(value.OGrp)
   end
else
   begin
      if OGrp<>nil then
         ShowMessage('OGrp must be destroyed first');
         //OGrp.Destroy;
      OGrp:=nil;
   end;

CMat:=value.CMat;
CProf:=value.CProf;
Ora:=value.Ora;
OraRest:=value.OraRest;
TipAsoc:=value.TipAsoc;
OreCons:=value.OreCons;
Sapt:=value.Sapt;
PozSapt:=value.PozSapt;
if PozSapt<0 then PozSapt:=0;
CCorp:=value.CCorp;
end;

procedure TGrp.Clear;
begin
CMat:=0;CProf:=0;
Ora:=0;OraRest:=0;OreCons:=0;
TipAsoc:=0;
Sapt:=1;PozSapt:=0;
CCorp:=0;
end;

procedure TGrp.WriteOraRest;
begin
if _OraRest<0 then showmessage('OraRest<0')
   else _OraRest:=Value;
end;

function TGrp.Full;
begin
if Cprof*Ora<>0 then Result:=True else Result:=False;
end;

function TGrp.Part;
begin
if (Cprof<>0)or(Ora<>0)then Result:=True else Result:=False;
end;

function TGrp.Egal;
begin
if (CMat=value.CMat)and(CProf=value.CProf)and(Ora=value.Ora)
   and(TipAsoc=value.TipAsoc)
   and(OreCons=value.OreCOns)and(sapt=value.Sapt)
   then Result:=True else Result:=False;
end;
//------------------------MITEM------------
procedure TMItem.Assign;
var i:integer;
begin
if 1=2 then ValCod[0]:=ValCod[0];//no hint stress
Cod:=value.Cod;last:=value.last;
for i:=1 to last do list[i]:=value.list[i];
end;

function TMItem.ValRead;
begin
if Index>last then ShowMessage('read out');
Result:=list[Index];
end;

procedure TMItem.ValWrite;
begin
if Index>last then ShowMessage('write out');
list[Index]:=Value;
end;

function TMItem.Add;
var i:integer;
begin
for i:=1 to Self.Count do if list[i]=valueCod then
	begin Result:=False;exit;end;
inc(last);list[last]:=valueCod;Result:=True;
end;

procedure TMItem.SaveToFile;
var i:integer;
begin
writeln(F,'nr=',last);
write(F,Cod);
for i:=1 to last do write(F,',',list[i]);
writeln(F);
end;

procedure TMItem.LoadFromFile;
var s:string;i:integer;
begin
readln(F,s);last:=param(s,2);
readln(F,s);Cod:=param(s,1);
for i:=1 to last do list[i]:=param(s,i+1);//+1 pt Cod
end;

procedure TMItem.Del;
var i:integer;
begin
if index>last then ShowMessage('del out');
for i:=index to last-1 do list[i]:=list[i+1];
dec(last);
end;

procedure TMItem.DelCod;
var i:integer;
begin
for i:=1 to last do if list[i]=cod then begin
   Del(i);exit;
end;
end;

function TMItem.ExistCod;
var i:integer;
begin
Result:=-1;
for i:=1 to Count do if ValCod[i]=value then begin
   Result:=i;exit;end;
end;

//------------------------MITEMS--------------
constructor TMItems.Create;
begin
if 1=2 then ValMItem[0]:=ValMItem[0];//no hint stress
last:=0;
end;

destructor TMItems.Destroy;
var i:integer;
begin
for i:=1 to last do begin
    list[i].Free;list[i]:=nil;end;
last:=0;
inherited Destroy;
end;

procedure TMItems.Assign;
var i:integer;
begin
last:=value.last;
for i:=1 to last do begin
    list[i]:=TMItem.Create;
    list[i].Assign(value.list[i]);
    end;
end;

function TMItems.ValRead;
begin
if Index>last then ShowMessage('read out');
Result:=list[Index];
end;

procedure TMItems.ValWrite;
begin
if Index>last then ShowMessage('write out');
list[Index]:=Value;
end;

function TMItems.ExistCod;
var i:integer;
begin
Result:=-1;
for i:=1 to last do if list[i].Cod=valueCod then
   begin Result:=i;exit;end;
end;

function TMItems.ByCod;
var i:integer;
begin
Result:=nil;
for i:=1 to last do if list[i].Cod=valueCod then
   begin Result:=list[i];exit;end;
if Result=nil then ShowMessage('not found');
end;

procedure TMItems.CreateGrp;
begin
inc(last);list[last]:=TMItem.Create;
list[last].Cod:=valueCod;
end;

function TMItems.GetFreeCod;
var i,j:integer;found:boolean;
begin
for i:=1 to last+1 do begin found:=false;
    for j:=1 to last do if list[j].Cod=i then found:=true;
    if not found then begin Result:=i;exit;end;
    end;
ShowMessage('new cod not found');result:=0;
end;

function TMItems.CreateWithCod;
begin
Result:=GetFreeCod;CreateGrp(Result);
end;

procedure TMItems.SaveToFile;
var i:integer;
begin
writeln(F,'[MITEMS]');
writeln(F,'Nr=',last);
for i:=1 to last do list[i].SaveToFile(F);
writeln(F,'[END-MITEMS]');
end;

procedure TMItems.LoadFromFile;
var i:integer;s:string;
begin
readln(F,s);//mitems
readln(F,s);last:=param(S,2);
for i:=1 to last do begin
    list[i]:=TMItem.Create;
    list[i].LoadFromFile(F);
    end;
readln(F,s);//end-mitems
end;

function TMItems.CodToIndex;
var i:integer;
begin
Result:=0;
for i:=1 to last do if list[last].Cod=valueCod then
    begin Result:=i;break;end;
if Result=0 then ShowMessage('cod not found');
end;

procedure TMItems.Del;
var i:integer;
begin
for i:=CodToIndex(valueCod) to last-1 do list[i]:=list[i+1];
list[last].Free;list[last]:=nil;dec(last);
end;
//---------------------GRUP-----------------
constructor TGrup.Create;
var i,j:integer;
begin
Rez:=TRez.Create;
for i:=1 to max_ore do for j:=1 to 2 do Dif[i,j]:=0;
end;

destructor TGrup.Destroy;
var i:integer;
begin
Rez.Free;Rez:=nil;
for i:=1 to Count do list[i].Destroy;
inherited Destroy;
end;

procedure TGrup.Assign;
var i,j:integer;
begin
Rez:=TRez.Create;Rez.Assign(value.Rez);
_last:=value._last;
_totalore:=value.TotalOre;
for i:=1 to Count do begin list[i]:=TGrp.Create;
    list[i].Assign(value.list[i]);
    end;
for i:=1 to max_zile do
    OreZi[i]:=value.OreZi[i];
for i:=1 to max_ore do for j:=1 to 2 do
	Dif[i,j]:=value.Dif[i,j];
Cod:=value.Cod;
end;

function TGrup.ValRead;
begin
Result:=nil;
if Index>Count then showmessage('read out') else Result:=list[Index];
end;

procedure TGrup.ValWrite;
begin
if Index>Count then showmessage('write out') else list[Index]:=Value;
end;

procedure TGrup.SaveToFile;
var i,j:integer;s:string[1];
begin
writeln(F,'[GRUP]');
s:=',';
for i:=1 to max_ore do for j:=1 to 2 do begin
	if (i=max_ore)and(j=2) then s:='';
   write(F,Dif[i,j],s);
   end;
writeln(F);//dif
writeln(F,'Cod=',Cod);
writeln(F,'[DATA]');
writeln(F,'nr=',Count);
for i:=1 to Count do list[i].SaveToFile(F);
writeln(F,'[END-DATA]');
writeln(F,'[OREZI]');
for i:=1 to max_zile do begin write(F,OreZi[i]);
	if i<>max_zile then write(F,',');end;
writeln(F);
writeln(F,'[END-OREZI]');
Rez.SaveToFile(F);
writeln(F,'[END-GRUP]');
end;

procedure TGrup.LoadFromFile;
var i,j:integer;g:Tgrp;s:string;
begin
g:=Tgrp.Create;
readln(F,s);//grup
readln(F,s);//dif
for i:=1 to max_ore do for j:=1 to 2 do
   	Dif[i,j]:=param(s,(i-1)*2+j);
readln(F,s);//cod codgrupa
Cod:=param(s,2);
readln(F,s);//data
readln(F,s);//nr
for i:=1 to param(s,2) do begin
    g.LoadFromFile(F);Add(g);end;
g.Free;
readln(F,s);//end-data
readln(F,s);//orezi
readln(F,s);
for i:=1 to max_zile do OreZi[i]:=param(s,i);
readln(F);//end-orezi
Rez.LoadFromFile(F);
readln(F);//end-grup
end;

function TGrup.Add;
begin
if Count+1>max_items then begin ShowMessage('Depasire add');
	Result:=-1;exit;end;
inc(_last);list[Count]:=TGrp.Create;
list[Count].SetVal(value);Result:=Count;
end;

function TGrup.CodToIndex;
var i:integer;
begin
Result:=-1;
for i:=1 to Count do
	if (list[i].CProf=cod_prof)and(list[i].CMat=cod_mat)and
   	(list[i].Ora=_ora) then begin Result:=i;exit;end;
//...
ShowMessage('Grp not found');
end;

procedure TGrup.DelS;
var i:integer;
begin
i:=CodToIndex(cod_prof,cod_mat,cod_ora);
DelIndex(i);
end;

procedure TGrup.DelIndex;
var i:integer;
begin
list[index].Free;
for i:=index to Count-1 do list[i]:=list[i+1];
list[Count]:=nil;dec(_last);
end;

procedure TGrup.MakeTotalOre;
var i:integer;
begin
_totalore:=0;
for i:=1 to Self.Count do
	_totalore:=_totalore+Self[i].Ora;
end;

procedure TGrup.ClearGrups;
var i:integer;
begin
for i:=1 to Count do begin list[i].Destroy;list[i]:=nil;end;
_last:=0;
end;

function TGrup.ByGrp;
var i:integer;
begin
Result:=nil;
for i:=1 to Count do if
	Grp[i].Egal(_Grp)then begin Result:=Grp[i];exit;end;
end;

function TGrup.iByMat;
var i:integer;
begin
for i:=1 to Count do if Grp[i].CMat=cod then begin Result:=i;exit;end;
Result:=0;
end;

function TGrup.gByMat;
var index:integer;
begin
   index:=iByMat(cod);
   if index=0 then
      Result:=nil
   else
      Result:=ValRead(index);
end;
//-----------------GRUPE-----------------
constructor TGrupe.Create;
begin
if 1=2 then ValGrup[0]:=ValGrup[0];
_last:=0;_maxGrupe:=max_grupe;
Items:=TItems.Create;
Opt:=TMItem.Create;
inherited Create;
end;

destructor TGrupe.Destroy;
var i:integer;
begin
for i:=1 to Count do begin
	listg[i].Destroy;listg[i]:=nil;end;
_last:=0;
Items.Free;
Opt.Free;
inherited Destroy;
end;

procedure TGrupe.SaveToFile;
var i:integer;
begin
writeln(F,'[GRUPE]');
writeln(F,'Cod=',Cod);
Items.SaveToFile(F);
Opt.SaveToFile(F);
writeln(F,'Nr=',Count);
for i:=1 to Count do begin
   listg[i].SaveToFile(F);
	end;
writeln(F,'[END-GRUPE]');
end;

procedure TGrupe.LoadFromFile;
var i:integer;s:string;
begin
readln(F,s);//grupe
readln(F,s);//cod
Cod:=param(s,2);
Items.LoadFromFile(F);
Opt.LoadFromFile(F);
readln(F,s);_last:=param(s,2);
for i:=1 to Count do begin
   listg[i]:=TGrup.Create;
   listg[i].LoadFromFile(F);
	end;
readln(F,s);//end-grupe
end;

function TGrupe.GrupRead;
begin
Result:=nil;
if Index>Count then showmessage('Grupe read out')
	else Result:=listg[index];
end;

procedure TGrupe.GrupWrite;
begin
if Index>Count then showmessage('Grupe write out')
	else listg[Index]:=Value;
end;

procedure TGrupe.Assign;
var i:integer;
begin
Items.Assign(value.Items);
Opt.Assign(value.Opt);
_last:=value.Count;
for i:=1 to value.Count do begin
   listg[i]:=TGrup.Create;
	listg[i].Assign(value[i]);
   end;
Cod:=value.Cod;
end;

procedure TGrupe.CreateGrup;
var i:integer;
begin
for i:=1 to Count do if listg[i].Cod=valueCod then
	ShowMessage('Grup.Cod exista deja');
inc(_last);
listg[Count]:=TGrup.Create;
listg[Count].Cod:=valueCod;
end;

procedure TGrupe.Add;
begin
inc(_last);
listg[Count]:=TGrup.Create;
listg[Count].Cod:=value;
end;

function TGrupe.AddItem;
begin
Items.AddWithCod(value);Result:=AddWithCod;
end;

function TGrupe.ByCod;
var i:integer;
begin
for i:=1 to Count do if listg[i].Cod=valueCod then
	begin Result:=listg[i];exit;end;
ShowMessage('grup not found');Result:=nil;
end;

function TGrupe.IndexToCod;
begin
if index>Count then Result:=0 else Result:=listg[index].Cod;
end;

function TGrupe.CodToIndex;
var i:integer;
begin
Result:=-1;
for i:=1 to Count do if valueCod=listg[i].Cod then begin Result:=i;exit;end;
ShowMessage('not found Grupe.CodToIndex');
end;

function TGrupe.ExistCod;
var i:integer;
begin
Result:=false;
for i:=1 to Count do if listg[i].Cod=valueCod then begin
    Result:=True;break;end;
end;

function TGrupe.AddWithCod;
var value:TCod;
begin
value:=Items[Items.Count].Cod;Add(value);
Result:=value;
end;

procedure TGrupe.DelItem;
var itCod,itInd,i:integer;
begin
itCod:=Items[index].Cod;Items.Del(index);
itInd:=CodToIndex(itCod);Self[itInd].Destroy;
for i:=itInd to Count-1 do Self[i]:=Self[i+1];
Self[Count]:=nil;dec(_last);
end;

procedure TGrupe.ClearGrups;
var i:integer;
begin
for i:=1 to Count do listg[i].ClearGrups;
end;

procedure TGrupe.ToStrings;
var i:integer;
begin
for i:=1 to Count do p^.Add(Items.ByCod(listg[i].Cod).Val);
end;

procedure TGrupe.MakeTotalOre;
var i:integer;
begin
_totalore:=0;
for i:=1 to Count do begin
    ValGrup[i].MakeTotalOre;
	 _totalore:=_totalore+ValGrup[i].TotalOre;
    end;
end;

procedure TGrupe.MakeOreZi;
var i,j,totalor:integer;
    rest,cat:integer;
begin
for i:=1 to Count do begin
   MakeTotalOre;
	totalor:=Self[i].TotalOre;
   cat:=totalor div nrZile;rest:=totalor mod nrZile;
   for j:=1 to max_zile do
   	if j<=nrZile then Self[i].OreZi[j]:=cat
     		else Self[i].OreZi[j]:=0;
   for j:=1 to rest do inc(Self[i].OreZi[j]);
   end;
end;

procedure TGrupe.Switch;
var _Grup:TGrup;
begin
Items.Switch(index1,index2);
_Grup:=GrupRead(index1);
GrupWrite(index1,GrupRead(index2));
GrupWrite(index2,_Grup);
end;

procedure TGrupe.Sort;
var i,j:integer;
begin
for i:=1 to Count-1 do for j:=i to Count do
   if Items[i].Val>Items[j].Val then Switch(i,j);
end;

//-----------------ANI-------------------
constructor TAni.Create;
begin
if 1=2 then ValGrupe[0]:=ValGrupe[0];
_last:=0;_maxAni:=max_ani;
Items:=TItems.Create;
inherited Create;
end;

destructor TAni.Destroy;
var i:integer;
begin
for i:=1 to Count do begin
	lista[i].Destroy;lista[i]:=nil;end;
_last:=0;Items.Free;
inherited Destroy;
end;

procedure TAni.SaveToFile;
var i:integer;
begin
writeln(F,'[ANI]');
writeln(F,'Cod=',Cod);
Items.SaveToFile(F);
writeln(F,'Nr=',Count);
for i:=1 to Count do lista[i].SaveToFile(F);
writeln(F,'[END-ANI]');
end;

procedure TAni.LoadFromFile;
var i:integer;s:string;
begin
readln(F,s);//ani
readln(F,s);//cod
Cod:=param(s,2);
Items.LoadFromFile(F);
readln(F,s);_last:=param(s,2);
for i:=1 to Count do begin
   lista[i]:=TGrupe.Create;
   lista[i].LoadFromFile(F);
	end;
readln(F,s);//end-ani
end;

function TAni.GrupeRead;
begin
Result:=nil;
if Index>Count then showmessage('Ani read out')
	else Result:=lista[index];
end;

procedure TAni.GrupeWrite;
begin
if Index>Count then showmessage('Ani write out')
	else lista[Index]:=Value;
end;

procedure TAni.Assign;
var i:integer;
begin
Items.Assign(value.Items);
_last:=value.Count;
for i:=1 to value.Count do begin
   lista[i]:=TGrupe.Create;
	lista[i].Assign(value[i]);
   end;
Cod:=value.Cod;
end;

procedure TAni.Add;
begin
inc(_last);
lista[Count]:=TGrupe.Create;
lista[Count].Cod:=valueCod;
end;

function TAni.AddWithCod;
var valueCod:TCod;
begin
valueCod:=Items[Items.Count].Cod;
Add(valueCod);Result:=valueCod;
end;

function TAni.AddItem;
begin
Items.AddWithCod(value);Result:=AddWithCod;
end;

procedure TAni.DelItem;
var itCod,itInd,i:integer;
begin
itCod:=Items[index].Cod;Items.Del(index);
itInd:=CodToIndex(itCod);Self[itInd].Destroy;
for i:=itInd to Count-1 do Self[i]:=Self[i+1];
Self[Count]:=nil;dec(_last);
end;

procedure TAni.ToStrings;
var i:integer;
begin
for i:=1 to Count do p^.Add(Items.ByCod(lista[i].Cod).Val);
end;

function TAni.IndexToCod;
begin
if index>Count then Result:=0 else Result:=lista[index].Cod;
end;

function TAni.CodToIndex;
var i:integer;
begin
Result:=-1;
for i:=1 to Count do if valueCod=lista[i].Cod then begin Result:=i;exit;end;
ShowMessage('not found Ani.CodToIndex');
end;

function TAni.ByCod;
var i:integer;
begin
for i:=1 to Count do	if lista[i].Cod=valueCod then begin
	Result:=lista[i];exit;end;
Result:=nil;ShowMessage('grupe not found');
end;

procedure TAni.ClearGrups;
var i:integer;
begin
for i:=1 to Count do lista[i].ClearGrups;
end;

procedure TAni.MakeOreZi;
var i:integer;
begin
MakeTotalOre;
for i:=1 to Count do Self[i].MakeOreZi(nrZile);
end;

procedure TAni.MakeTotalOre;
var i:integer;
begin
_totalore:=0;
for i:=1 to Count do begin
    ValGrupe[i].MakeTotalOre;
	 _totalore:=_totalore+ValGrupe[i].TotalOre;
    end;
end;

procedure TAni.Switch;
var _Grupe:TGrupe;
begin
Items.Switch(index1,index2);
_Grupe:=GrupeRead(index1);
GrupeWrite(index1,GrupeRead(index2));
GrupeWrite(index2,_Grupe);
end;

procedure TAni.Sort;
var i,j:integer;
begin
for i:=1 to Count-1 do for j:=i to Count do
   if Items[i].Val>Items[j].Val then Switch(i,j);
end;

//-----------------SECTII----------------
constructor TSec.Create;
begin
if 1=2 then ValAni[0]:=ValAni[0];
_last:=0;_maxSec:=max_sectii;
Items:=TItems.Create;
inherited Create;
end;

destructor TSec.Destroy;
var i:integer;
begin
for i:=1 to Count do begin
	lists[i].Destroy;lists[i]:=nil;end;
_last:=0;Items.Free;
inherited Destroy;
end;

procedure TSec.SaveToFile;
var i:integer;
begin
writeln(F,'[SECTII]');
Items.SaveToFile(F);
writeln(F,'Nr=',Count);
for i:=1 to Count do lists[i].SaveToFile(F);
writeln(F,'[END-SECTII]');
end;

procedure TSec.LoadFromFile;
var i:integer;s:string;
begin
readln(F,s);//sectii
Items.LoadFromFile(F);
readln(F,s);_last:=param(s,2);
for i:=1 to Count do begin
   lists[i]:=TAni.Create;
   lists[i].LoadFromFile(F);
	end;
readln(F,s);//end-sectii
end;

function TSec.AniRead;
begin
Result:=nil;
if Index>Count then showmessage('Sec read out')
	else Result:=lists[index];
end;

procedure TSec.AniWrite;
begin
if Index>Count then showmessage('Sec write out')
	else lists[Index]:=Value;
end;

procedure TSec.Assign;
var i:integer;
begin
Items.Assign(value.Items);
_last:=value.Count;
for i:=1 to value.Count do begin
   lists[i]:=TAni.Create;
	lists[i].Assign(value[i]);
   end;
end;

procedure TSec.Add;
begin
inc(_last);
lists[Count]:=TAni.Create;
lists[Count].Cod:=valueCod;
end;

function TSec.AddWithCod;
var valueCod:TCod;
begin
valueCod:=Items[Items.Count].Cod;
Add(valueCod);Result:=valueCod;
end;

function TSec.AddItem;
begin
Items.AddWithCod(value);Result:=AddWithCod;
end;

procedure TSec.DelItem;
var itCod,itInd,i:integer;
begin
itCod:=Items[index].Cod;Items.Del(index);
itInd:=CodToIndex(itCod);Self[itInd].Destroy;
for i:=itInd to Count-1 do Self[i]:=Self[i+1];
Self[Count]:=nil;dec(_last);
end;

procedure TSec.ToStrings;
var i:integer;
begin
for i:=1 to Count do p^.Add(Items.ByCod(lists[i].Cod).Val);
end;

function TSec.IndexToCod;
begin
if index>Count then Result:=0 else Result:=lists[index].Cod;
end;

function TSec.CodToIndex;
var i:integer;
begin
Result:=-1;
for i:=1 to Count do if valueCod=lists[i].Cod then begin Result:=i;exit;end;
ShowMessage('not found Sec.CodToIndex');
end;

function TSec.ByCod;
var i:integer;
begin
for i:=1 to Count do	if lists[i].Cod=valueCod then begin
	Result:=lists[i];exit;end;
Result:=nil;ShowMessage('grupe not found');
end;

procedure TSec.ClearGrups;
var i:integer;
begin
for i:=1 to Count do lists[i].ClearGrups;
end;

procedure TSec.MakeOreZi;
var i:integer;
begin
MakeTotalOre;
for i:=1 to Count do Self[i].MakeOreZi(nrZile);
end;

procedure TSec.MakeTotalOre;
var i:integer;
begin
_totalore:=0;
for i:=1 to Count do begin
    ValAni[i].MakeTotalOre;
	 _totalore:=_totalore+ValAni[i].TotalOre;
    end;
end;

procedure TSec.Switch;
var _Ani:TAni;
begin
Items.Switch(index1,index2);
_Ani:=AniRead(index1);
AniWrite(index1,AniRead(index2));
AniWrite(index2,_Ani);
end;

procedure TSec.Sort;
var i,j:integer;
begin
for i:=1 to Count-1 do for j:=i to Count do
   if Items[i].Val>Items[j].Val then Switch(i,j);
end;

function TSec.MaxLengthAni;
var isec:integer;
begin
Result:=0;
for isec:=1 to Count do
	Result:=maxim(Result,ValAni[isec].Items.MaxLength);
end;

function TSec.MaxLengthGrupe;
var isec,ian:integer;
begin
Result:=0;
for isec:=1 to Count do for ian:=1 to ValAni[isec].Count do
	Result:=maxim(Result,ValAni[isec][ian].Items.MaxLength);
end;
//---------------GEN------------------------
constructor TGen.Create;
begin
if 1=2 then _Val[0]:=_Val[0];
_last:=0;_max:=0;
Items:=TItems.Create;
if ClassNameIs('TCorp')then _max:=max_corp
else if ClassNameIs('TSali')then _max:=max_sali;
inherited Create;
end;

destructor TGen.Destroy;
var i:integer;
begin
for i:=1 to Count do begin
	list[i].Destroy;list[i]:=nil;end;
_last:=0;Items.Free;
inherited Destroy;
end;

procedure TGen.SaveToFile;
var i:integer;
begin
writeln(F,'[GEN]');
Items.SaveToFile(F);
writeln(F,'Nr=',Count);
for i:=1 to Count do begin
   if ClassNameIs('TCorp')then TSali(list[i]).SaveToFile(F);
   if ClassNameIs('TSali')then TSala(list[i]).SaveToFile(F);
   end;
writeln(F,'[END-GEN]');
end;

procedure TGen.LoadFromFile;
var s:string;i:integer;
begin
readln(F,s);//gen
Items.LoadFromFile(F);
readln(F,s);_last:=param(s,2);
for i:=1 to Count do begin
   if ClassNameIs('TCorp')then begin
      list[i]:=TSali.Create;
	   TSali(list[i]).LoadFromFile(F);
      end;
   if ClassNameIs('TSali')then begin
      list[i]:=TSala.Create;
	   TSala(list[i]).LoadFromFile(F);
   	end;
	end;
readln(F,s);//end-gen
end;

procedure TGen.Assign;
var i:integer;
begin
Items.Assign(value.Items);
_last:=value.Count;_max:=value.Max;
for i:=1 to value.Count do begin
   if ClassNameIs('TCorp')then begin
      list[i]:=TSali.Create;
	   TSali(list[i]).Assign(TSali(TCorp(value)[i]));
      end;
   if ClassNameIs('TSali')then begin
      list[i]:=TSala.Create;
	   TSala(list[i]).Assign(TSala(TSali(value)[i]));
   	end;
   end;
end;

function TGen._Read;
begin
Result:=nil;
if Index>Count then showmessage('Gen read out')
	else Result:=list[index];
end;

procedure TGen._Write;
begin
if Index>Count then showmessage('Gen write out')
	else list[Index]:=Value;
end;

procedure TGen.ToStrings;
var i,cod:integer;
begin
for i:=1 to Count do begin
   cod:=-1;
	if ClassNameIs('TCorp') then cod:=TSali(list[i]).Cod;
   if ClassNameIs('TSali') then cod:=TSala(list[i]).CMat;
   if cod<>-1 then p^.Add(Items.ByCod(cod).Val)
   	else showmessage('class not found');
   end;
end;

function TGen.CodToIndex;
var i:integer;found:boolean;
begin
Result:=-1; found:=false;
for i:=1 to Count do begin
	if ClassNameIs('TCorp')and(valueCod=TSali(list[i]).Cod)then found:=true;
   if ClassNameIs('TSali')and(valueCod=TSala(list[i]).CMat)then found:=true;
	if found then begin Result:=i;exit;end;
   end;
ShowMessage('not found Gen.CodToIndex');
end;

procedure TGen.Add;
begin
inc(_last);
if ClassNameIs('TCorp')then begin
	list[Count]:=TSali.Create;
   TSali(list[Count]).Cod:=valueCod;
   end
else if ClassNameIs('TSali')then begin
	list[Count]:=TSala.Create;
   TSala(list[Count]).CMat:=valueCod;end
else showmessage('class not found - add');
end;

function TGen.AddWithCod;
var valueCod:TCod;
begin
valueCod:=Items[Items.Count].Cod;
Add(valueCod);Result:=valueCod;
end;

function TGen.AddItem;
begin
Items.AddWithCod(value);Result:=AddWithCod;
end;

procedure TGen.DelItem;
var itCod,itInd,i:integer;
begin
itCod:=Items[index].Cod;Items.Del(index);
itInd:=CodToIndex(itCod);Self[itInd].Destroy;
for i:=itInd to Count-1 do Self[i]:=Self[i+1];
Self[Count]:=nil;dec(_last);
end;

procedure TGen.Switch;
var _Obj:TObject;
begin
Items.Switch(index1,index2);
_Obj:=_Read(index1);
_Write(index1,_Read(index2));
_Write(index2,_Obj);
end;

procedure TGen.Sort;
var i,j:integer;
begin
for i:=1 to Count-1 do for j:=i to Count do
   if Items[i].Val>Items[j].Val then Switch(i,j);
end;
//---------------------SALA---------------
constructor TSala.Create;
begin
NrSali:=-1;
inherited Create;
end;

procedure TSala.Assign;
begin
CMat:=value.CMat;NrSali:=value.NrSali;
end;

procedure TSala.SaveToFile;
begin
writeln(F,CMat,',',NrSali);
end;

procedure TSala.LoadFromFile;
var s:string;
begin
readln(F,s);CMat:=param(s,1);NrSali:=param(s,2);
end;

//---------------------SALI--------------------

procedure TSali.Assign;
begin
Cod:=TSali(value).Cod;
inherited Assign(value);
end;

procedure TSali.SaveToFile;
begin
writeln(F,'Cod sali=',Cod);
inherited SaveToFile(F);
end;

procedure TSali.LoadFromFile;
var s:string;
begin
readln(F,s);Cod:=param(s,2);
inherited LoadFromFile(F);
end;


//------------------CORPURI------------------
constructor TCorp.Create;
begin
inherited Create;
end;

destructor TCorp.Destroy;
begin
inherited Destroy;
end;

procedure TCorp.Assign;
var i,j:integer;
begin
Items.Assign(value.Items);
_last:=value.Count;_max:=value.Max;
for i:=1 to value.Count do begin
	for j:=1 to value.Count do dist[i,j]:=value.dist[i,j];
   list[i]:=TSali.Create;
	TSali(list[i]).Assign(TSali(TCorp(value)[i]));
   end;
end;

procedure TCorp.SaveToFile;
var i,j:integer;
begin
inherited SaveToFile(F);
for i:=1 to Count do
   begin
      write(F,dist[i,1]);
  	   for j:=2 to Count do
         write(F,',',dist[i,j]);
      writeln(F);
 	end;
end;

procedure TCorp.LoadFromFile;
var i,j:integer;s:string;
begin
inherited LoadFromFile(F);
for i:=1 to Count do begin
   readln(F,s);
  	for j:=1 to Count do dist[i,j]:=param(s,j);
  	end;
end;

function TCorp.getNrSali;
var icorp,nrsali:integer;_ccorp:TCod;
begin
Result:=-1;
for icorp:=1 to Count do
   begin
      _CCorp:=Items.IndexToCod(icorp);
      nrsali:=GetNrSaliCorp(_CMat,_CCorp);
      if nrsali<>-1 then Result:=Result+nrsali;
   end;
if Result<>-1 then inc(Result);
end;

function TCorp.getNrSaliCorp;
var icorp,isali:integer;
begin
   Result:=-1;
   icorp:=Items.CodToIndex(_CCorp);
   for isali:=1 to TSali(_Read(icorp)).Count do
	   with TSala(TSali(_Read(icorp))[isali]) do
         if (_CMat=CMat)and(NrSali<>-1)then Result:=Result+NrSali;
   if Result<>-1 then inc(Result);
end;

function TCorp.getCloseCorp;
var i,j,icorp:integer;
    distsort:array[1..max_corp,1..2]of integer;
begin
   icorp:=Items.CodToIndex(_CCorp);
   for i:=1 to Count do
      begin
         distsort[i,1]:=dist[icorp,i];
         distsort[i,2]:=i;
      end;
   for i:=1 to Count-1 do
      for j:=i to Count do
         if distsort[j,1]<distsort[i,1] then
            begin
               switchInt(distsort[j,1],distsort[i,1]);
               switchInt(distsort[j,2],distsort[i,2]);
            end;
   Result:=Items.IndexToCod(distsort[try_nr+1,2]);
end;

procedure TCorp.Switch;
var x,y,xx,yy:integer;
   temp:array[1..max_corp,1..max_corp]of integer;
begin
inherited Switch(index1,index2);
for y:=1 to Count do for x:=1 to Count do
   begin temp[y,x]:=dist[y,x];end;
for y:=1 to Count do for x:=1 to Count do if x<>y then begin
   xx:=x;yy:=y;
   if x=index1 then xx:=index2 else if x=index2 then xx:=index1;
   if y=index1 then yy:=index2 else if y=index2 then yy:=index1;
   dist[x,y]:=temp[xx,yy];
   end;
end;

procedure TCorp.Sort;
var i,j:integer;
begin
for i:=1 to Count-1 do for j:=i+1 to Count do
   if Items[i].Val>Items[j].Val then Self.Switch(i,j);
end;

//-----------------GRUPS-----------------
constructor TGrups.Create;
var i:integer;
begin
nrZile:=5;
oraStart:=8;minStart:=0;
oraEnd:=20;minEnd:=0;
maxOreZi:=8;marjaOre:=1;
maxFer:=1;minBloc:=1;
secBar:=nil;aniBar:=nil;grupeBar:=nil;
ShowMakeProgress:=false;
Profs:=TProfs.Create;
Mats:=TMats.Create;
MProfs:=TMItems.Create;
Sec:=TSec.Create;
Corp:=TCorp.Create;
for i:=1 to max_cond do cond[i]:=1;
cond[9]:=0;
end;

destructor TGrups.Destroy;
begin
Profs.Free;Profs:=nil;
Mats.Free;Mats:=nil;
MProfs.Free;MProfs:=nil;
Sec.Free;Sec:=nil;
Corp.Free;Corp:=nil;
secBar:=nil;aniBar:=nil;grupeBar:=nil;
inherited Destroy;
end;

procedure TGrups.Assign;
var i:integer;
begin
nrZile:=value.nrZile;
oraStart:=value.oraStart;
minStart:=value.minStart;
oraEnd:=value.oraEnd;
minEnd:=value.minEnd;
maxOreZi:=value.maxOreZi;
maxFer:=value.maxFer;
minBloc:=value.minBloc;
_totalOre:=value.TotalOre;
marjaOre:=value.marjaOre;
Sec:=TSec.Create;Sec.Assign(value.Sec);
Profs:=TProfs.Create;Profs.Assign(value.Profs);
Mats:=TMats.Create;Mats.Assign(value.Mats);
MProfs:=TMItems.Create;MProfs.Assign(value.MProfs);
Corp:=TCorp.Create;Corp.Assign(value.Corp);
for i:=1 to max_cond do cond[i]:=value.cond[i];
end;

procedure TGrups.SaveToFile;
var i:integer;
begin
writeln(F,'[GRUPS]');
writeln(F,nrZile);
writeln(F,totalOre);
writeln(F,oraStart);
writeln(F,minStart);
writeln(F,oraEnd);
writeln(F,minEnd);
writeln(F,maxOreZi);
writeln(F,marjaOre);
writeln(F,maxFer);
writeln(F,minBloc);
writeln(F,'[COND]');
for i:=1 to max_cond do begin write(F,cond[i]);
	if i<>max_cond then write(F,',');end;
writeln(F);
writeln(F,'[END-COND]');
MProfs.SaveToFile(F);
Sec.SaveToFile(F);
Profs.SaveToFile(F);
Mats.SaveToFile(F);//new
Corp.SaveToFile(F);
writeln(F,'[END-GRUPS]');
end;

procedure TGrups.LoadFromFile;
var i:integer;s:string;
begin
readln(F,s);//grups
readln(F,nrZile);
readln(F,_totalOre);
readln(F,oraStart);
readln(F,minStart);
readln(F,oraEnd);
readln(F,minEnd);
readln(F,maxOreZi);
readln(F,marjaOre);
readln(F,maxFer);
readln(F,minBloc);
readln(F,s);//cond
readln(F,s);
for i:=1 to max_cond do cond[i]:=param(s,i);
readln(F,s);//end-cond
MProfs.LoadFromFile(F);
Sec.LoadFromFile(F);
Profs.LoadFromFile(F);
Mats.LoadFromFile(F);//new
Corp.LoadFromFile(F);
readln(F,s);//end-grups
MakeTotalOre;
end;

function TGrups.CompItems;
begin
Result:=nil;
case index of
1:Result:=Sec.Items;
2:Result:=Sec[indSec].Items;
3:Result:=Sec[indSec][indAn].Items;
10:Result:=Mats.Items;
20:Result:=Profs.Items;
30:Result:=Profs.Cat.Items;
35:Result:=Mats.Cat.Items;
40:Result:=Corp.Items;
//50:Result:=TCorp(Corp[indCorp]).Items;
else ShowMessage('case not found');
end;
end;

procedure TGrups.DelOpt(cmat: TCod);
var indsec,indan:integer;
begin
for indsec:=1 to Sec.Count do
   for indan:=1 to Sec[indSec].Count do
      Sec[indSec][indAn].Opt.DelCod(cmat);
end;

function TGrups.ExistProf;
var indSec,indAn,indGr,j:integer;_Grp:TGrp;
begin
_Grp:=TGrp.Create;
try Result:=False;
for indSec:=1 to Sec.Count do
for indAn:=1 to Sec[indSec].Count do
for indGr:=1 to Sec[indSec][indAn].Count do
   	if Sec[indSec][indAn][indgr].Rez.Exist(zi,ora) then begin
   	_Grp.Assign(Sec[indSec][indAn][indgr].Rez[zi,ora]);
   	if _Grp.CProf=_CProf then Result:=True;
      if _Grp.CProf<0 then for j:=1 to MProfs.ByCod(-_Grp.CProf).Count do
       	if MProfs.ByCod(-_Grp.CProf).ValCod[j]=_CProf then Result:=True;
      if Result then begin
         _profSec:=indSec;_profAn:=indAn;_profGr:=indGr;
      	end;
      end;
finally _Grp.Free;end;
end;

function TGrups.GetMaxOraProf;
var zi,ora:integer;
begin
Result:=0;
for zi:=1 to max_zile do for ora:=1 to max_ore do
   if ExistProf(_CProf,zi,ora) then Result:=maxim(Result,ora);
end;

function TGrups.GetMaxZiProf;
var zi,ora:integer;
begin
Result:=0;
for zi:=1 to max_zile do for ora:=1 to max_ore do
   if ExistProf(_CProf,zi,ora) then Result:=maxim(Result,zi);
end;

function TGrups.GetTotalOreProf;
var zi,ora:integer;
begin
Result:=0;
for zi:=1 to max_zile do for ora:=1 to max_ore do
if ExistProf(_CProf,zi,ora) then Result:=Result+1;
end;

function TGrups.GetOreProf;
var j,indSec,indAn,indGr,indG:integer;
	_Grp:TGrp;
begin _Grp:=TGrp.Create;Result:=0;
for indSec:=1 to Sec.Count do
for indAn:=1 to Sec[indSec].Count do
for indGr:=1 to Sec[indSec][indAn].Count do
for indG:=1 to Sec[indSec][indAn][indGr].Count do begin
   _Grp.Assign(Sec[indSec][indAn][indGr][indG]);
   if _Grp.CProf=_CProf then Result:=Result+_Grp.Ora;
      if _Grp.CProf<0 then for j:=1 to MProfs.ByCod(-_Grp.CProf).Count do
       	if MProfs.ByCod(-_Grp.CProf).ValCod[j]=_CProf then Result:=Result+_Grp.Ora;
	end;
end;

procedure TGrups.AddCompon;
var indGrp:integer;
begin
with Sec.ByCod(sect).ByCod(an).ByCod(gr) do begin
Rez.CreateGrp(zi,ora,_Grp);
indGrp:=CodToIndex(_Grp.CProf,_Grp.CMat,_Grp.Ora);
Grp[indGrp].OraRest:=Grp[indGrp].OraRest-1;
end;
end;

procedure TGrups.DelCompon;
var indGrp:integer;
    _Grp:TGrp;
begin
_Grp:=TGrp.Create;
with Sec.ByCod(sect).ByCod(an).ByCod(gr) do
begin
   if Rez.existGrp(zi,ora,_PozSapt)then
      _Grp.Assign(Rez.getGrp(zi,ora,_PozSapt))
   else
      ShowMessage('delcompon sapt not found');
   {if Rez.Exist(zi,ora) then
      begin
         _Grp.Assign(Rez[zi,ora]);
         if _Grp.PozSapt<>_PozSapt then
            begin
               if Rez[zi,ora].OGrp<>nil then
                  _Grp.Assign(Rez[zi,ora].OGrp);
               if _Grp.PozSapt<>_PozSapt then
                  ShowMessage('delcompon sapt not found');
            end;
      end;}
   indGrp:=CodToIndex(_Grp.CProf,_Grp.CMat,_Grp.Ora);
   Grp[indGrp].OraRest:=Grp[indGrp].OraRest+1;
   Rez.Del(zi,ora,_PozSapt);
end;
_Grp.Destroy;
end;

procedure TGrups.SwitchCompon;
var _Grp1,_Grp2:array[1..2,1..max_ore] of TGrp;
    nrpoz1,nrpoz2,i,j:integer;
begin
   for i:=1 to 2 do
      for j:=1 to max_ore do
         begin
            _Grp1[i,j]:=TGrp.Create;
            _Grp2[i,j]:=TGrp.Create;
         end;
   with Sec.ByCod(sect).ByCod(an).ByCod(gr) do
   begin
      nrpoz1:=Rez.getNrPozSapt(zi1,ora1);
      nrpoz2:=Rez.getNrPozSapt(zi2,ora2);
      for i:=nrpoz1 downto 1 do
         begin
            _Grp1[1,i].Assign(Rez.getGrp(zi1,ora1,i));
            DelCompon(sect,an,gr,zi1,ora1,i);
         end;
      for i:=nrpoz2 downto 1 do
         begin
            _Grp2[2,i].Assign(Rez.getGrp(zi2,ora2,i));
            DelCompon(sect,an,gr,zi2,ora2,i);
         end;
      for i:=1 to nrpoz1 do
         begin
            AddCompon(sect,an,gr,zi2,ora2,_Grp1[1,i]);
         end;
      for i:=1 to nrpoz2 do
         begin
            AddCompon(sect,an,gr,zi1,ora1,_Grp2[2,i]);
         end;
   end;
   for i:=1 to 2 do
      for j:=1 to max_ore do
         begin
            _Grp1[i,j].Free;
            _Grp2[i,j].Free;
         end;
end;

function TGrups.getSaliOcup;
var i,j,k,isec,ian,igr:integer;impreuna:boolean;
    salimem:array[0..max_sectii*max_ani*max_grupe,1..4]of integer;
begin
j:=0;salimem[0,1]:=0;
for isec:=1 to Sec.Count do
for ian:=1 to Sec[isec].Count do
for igr:=1 to Sec[isec][ian].Count do
with Sec[isec][ian][igr] do
   begin
   	if Rez.Exist(zi,ora) then
      begin
      	if ((Rez[zi,ora].CMat=_Grp.CMat)and(Rez[zi,ora].CCorp=_Grp.CCorp))then
         begin
         	impreuna:=False;
            if (((Mats.Items.ByCod(_Grp.CMat).Tip=t_curs)
               and (Mats.Items.ByCod(Rez[zi,ora].CMat).Tip=t_curs)
               or(_Grp.TipAsoc=Rez[zi,ora].TipAsoc))
               and ((Sec.Items.CodToIndex(sect)=isec)and(Sec[isec].Items.CodToIndex(an)=ian)))
               then impreuna:=True;
            for i:=1 to salimem[0,1] do
            	if (salimem[i,1]=isec)and(salimem[i,2]=ian)
                  and((salimem[i,4]=_Grp.TipAsoc)or
                  ((salimem[i,3]=t_curs)and(Mats.Items.ByCod(_Grp.CMat).Tip=t_curs)))
                  then impreuna:=True;
            if not impreuna then
               begin
            	   inc(j);
                  inc(salimem[0,1]);
                  k:=salimem[0,1];
            	   salimem[k,1]:=isec;
                  salimem[k,2]:=ian;
                  salimem[k,3]:=Mats.Items.ByCod(Rez[zi,ora].CMat).Tip;
                  salimem[k,4]:=Rez[zi,ora].TipAsoc;
               end;
            if j>0 then if (saliDisp<>-1)and(saliDisp=j) then
               begin
      		      errsec:=isec;erran:=ian;errgr:=igr;
               end;
         end;//if
      end;//if Rez.Exist
   end;//with
Result:=j;
end;

function TGrups.getCorp;
var i,saliDisp,errsec,erran,errgr,try_nr,saliOcup:integer;
    lastccorp:TCod;
begin
   Result:=0;
   with Sec.ByCod(sect).ByCod(an).ByCod(gr) do
      begin
         lastccorp:=-1;
         for i:=ora downto 1 do
            if Rez.Exist(zi,i) then
               begin
                  lastccorp:=Rez[zi,i].CCorp;
                  break;
               end;
         if lastccorp=-1 then
            begin
               //corpul sugerat daca e prima ora din zi
               lastccorp:=Corp.Items.IndexToCod(1);
            end;
      end;//with
   with Corp do
      begin
      { DONE -oDan -cAlgoritm : Verifica daca mai sunt sali libere, daca nu, sugereaza alt corp }
         saliDisp:=GetNrSaliCorp(_Grp.CMat,lastccorp);
         _Grp.CCorp:=lastccorp;
         saliOcup:=getSaliOcup(_Grp,zi,ora,sect,an,saliDisp,errsec,erran,errgr);
         if ((saliOcup) < saliDisp) or (saliDisp=-1) then
            begin
               Result:=lastccorp;
               exit;
            end
         else
            begin
               for try_nr:=1 to Count-1 do
                  begin
                     Result:=getCloseCorp(lastccorp,try_nr);
                     _Grp.CCorp:=Result;
                     saliDisp:=GetNrSaliCorp(_Grp.CMat,Result);
                     if getSaliOcup(_Grp,zi,ora,sect,an,saliDisp,errsec,erran,errgr)<saliDisp then
                        exit
                     else Result:=0;
                  end;
            end;
      end;
end;

function TGrups.Put;
var j,igr,igr1,igr2:integer;_Grp2:TGrp;gr1:TCod;
	allOk:array[1..3,1..max_grupe]of integer;
function Put1Grp(_Grp1:TGrp;_gr:TCod;indGr:integer):integer;
var indgrp,i,NrOreCons,RestOre,nrOre:integer;
begin
   Result:=-1;
   with Sec.ByCod(sect).ByCod(an).ByCod(_gr) do
   begin
      allOk[1,indGr]:=-1;
      indGrp:=CodToIndex(_Grp1.CProf,_Grp1.CMat,_Grp1.Ora);
      if _Grp1.OreCons<>0 then
         NrOreCons:=_Grp1.OreCons
      else
         NrOreCons:=Mats.Items.ByCod(_Grp1.CMat).MOreCons;
      if cond[3]=0 then NrOreCons:=1;
      RestOre:=Grp[indGrp].OraRest;
      nrOre:=minim(NrOreCons,RestOre);
      for i:=0 to nrOre-1 do
         begin
            //verifica daca sunt sali disponibile
            _Grp1.CCorp:=getCorp(_Grp1,sect,an,_gr,zi,ora+i);
            _Grp1.PozSapt:=Rez.getFreePozSapt(zi,ora+i);
            if (_Grp1.Sapt>1) and (_Grp1.PozSapt=0) then
               _Grp1.PozSapt:=1;
            if _Grp1.CCorp>0 then
	            Result:=CheckOk(sect,an,_gr,zi,ora+i,ora,ora+nrOre-1,_Grp1)
            else
               Result:=41;
	         if Result=0 then
               begin
   	            AddCompon(sect,an,_gr,zi,ora+i,_Grp1);
		            allOk[2,indGr]:=i;
                  allOk[3,indGr]:=_Grp1.PozSapt;
               end
		      else
               begin
                  allOk[1,indGr]:=i;
                  break;
               end;
         end;
      if allOk[1,indGr]<>-1 then
         begin
	         for i:=0 to allOk[1,indGr]-1 do
               DelCompon(sect,an,_gr,zi,ora+i,allOk[3,indGr]);
            allOk[1,indGr]:=-1;allOk[2,indGr]:=-1;
         end;
      if (rezF<>nil)and(rezF.pasChk.Checked) then
         if Result=0 then
            begin
               rezF.secRadClick(nil);
	            if MessageDlg('Put zi='+inttostr(zi)+' ora='+inttostr(ora),
   	            mtInformation,[mbYes,mbNo],0)=mrNo then rezF.pasChk.Checked:=false;
            end;
   end;//with
end;
begin// BEGIN //
   Result:=-1;
   _Grp2:=TGrp.Create;
   try
      for igr:=1 to max_grupe do
         begin
            allOk[1,igr]:=-1;
            allOk[2,igr]:=-1;
         end;
      with Sec.ByCod(sect).ByCod(an) do
      begin
         if cond[10]=0 then
            begin
               igr1:=CodToIndex(gr);
               igr2:=igr1;
            end
         else
            begin
               igr1:=1;
               igr2:=Sec.ByCod(sect).ByCod(an).Count;
            end;
         //NU (daca sunt grupate sau sunt cursuri le pune in toate grupele)
         if (_Grp.TipAsoc=0)and(Mats.Items.ByCod(_Grp.CMat).Tip<>t_curs) then
            begin
               igr1:=CodToIndex(gr);
               igr2:=igr1;
            end;
         for igr:=igr1 to igr2 do
         begin
            gr1:=IndexToCod(igr);
            //pt grupe asociate verifica daca sunt la fel
            if ByCod(gr1).ByGrp(_Grp)<>nil then
               begin
   	            _Grp2.Assign(ByCod(gr1).ByGrp(_Grp));
                  if (_Grp2.TipAsoc=_Grp.TipAsoc)or(igr1=igr2)then
   		            begin
                        Result:=Put1Grp(_Grp2,gr1,igr);
                        if Result<>0 then break;
                     end;
               end;
         end;
         if Result<>0 then for igr:=igr1 to igr2 do
         begin
	         gr1:=IndexToCod(igr);
            if allOk[2,igr]<>-1 then
               for j:=0 to allOk[2,igr] do DelCompon(sect,an,gr1,zi,ora+j,allOk[3,igr]);
         end;
      end;//with
   finally
      _Grp2.Free;
   end;
end;

function TGrups.Del;
var igr,gr1,igr1,igr2:integer;_Grp,_Grp2:TGrp;GS1,GS2:TGrp;
function Delul(_gr:TCod):integer;
var i,j,i1,i2:integer;
begin
   i1:=0;i2:=0;
   with Sec.ByCod(sect).ByCod(an).ByCod(_gr) do
   begin
      if not Rez.existGrp(zi,ora,_PozSapt) then showmessage('Del nothing');
      for i:=ora downto 1 do
         begin
            if not Rez.existGrp(zi,i,_PozSapt) then break;
            if (_Grp.Egal(Rez.getGrp(zi,i,_PozSapt)))then
               i1:=i
            else
               break;
         end;
      for i:=ora to max_ore do
         begin
            if not Rez.existGrp(zi,i,_PozSapt) then break;
            if (_Grp.Egal(Rez.getGrp(zi,i,_PozSapt)))then
               i2:=i
            else
               break;
         end;

{      for i:=ora downto 1 do
         begin
            if not Rez.Exist(zi,i) then break;
	         if (GS1.Egal(Rez[zi,i]))
               or((GS2<>nil)and(GS2.Egal(Rez[zi,i]))) then
                  i1:=i
            else
               begin
                  if Rez[zi,i].OGrp<>nil then
                     begin
                        if (GS1.Egal(Rez[zi,i].OGrp))or
                           ((GS2<>nil)and(GS2.Egal(Rez[zi,i].OGrp)))then
                           i1:=i
                        else
                           break;
                     end
                  else
                     break;
               end;
         end;
      for i:=ora to max_ore do
         begin
            if not Rez.Exist(zi,i) then break;
	         if (GS1.Egal(Rez[zi,i]))
               or((GS2<>nil)and(GS2.Egal(Rez[zi,i]))) then
                  i2:=i
            else
               begin
                  if Rez[zi,i].OGrp<>nil then
                     begin
                        if (GS1.Egal(Rez[zi,i].OGrp))or
                           ((GS2<>nil)and(GS2.Egal(Rez[zi,i].OGrp)))then
                           i2:=i
                        else
                           break;
                     end
                  else
                     break;
               end;
         end;         }
      if cond[3]=0 then
         begin
            i1:=ora;
            i2:=ora;
         end;
      //daca pozsapt=0 le sterg toate
      {if _PozSapt=0 then
         begin
            ShowMessage('del all not implemented');
            for i:=i1 to i2 do
               for j:=Rez.getPozSapt(zi,i) downto 1 do
                  DelCompon(sect,an,_gr,zi,i,j)
         end
      else                                     }
         for i:=i1 to i2 do
            DelCompon(sect,an,_gr,zi,i,_PozSapt);
   end;
   Result:=i1;
   if (rezF<>nil)and(rezF.pasChk.Checked)then
      if Result=0 then
   	   begin
            rezF.secRadClick(nil);
            if MessageDlg('Del zi='+inttostr(zi)+' ora='+inttostr(ora),
   	         mtInformation,[mbYes,mbNo],0)=mrNo then
                  rezF.pasChk.Checked:=false;
         end;
end;
begin
   _Grp:=TGrp.Create;
   _Grp2:=TGrp.Create;
   GS1:=TGrp.Create;
   GS2:=nil;
   Result:=-1;
   with Sec.ByCod(sect).ByCod(an) do
   begin
//      _Grp.Assign(Sec.ByCod(sect).ByCod(an).ByCod(gr).Rez[zi,ora]);
      with Sec.ByCod(sect).ByCod(an).ByCod(gr) do
         if Rez.existGrp(zi,ora,_PozSapt)then
            _Grp.Assign(Rez.getGrp(zi,ora,_PozSapt))
         else
            ShowMessage('nu am rez la del');
      GS1.Assign(_Grp);
      if GS1.OGrp<>nil then
         begin
            GS2:=TGrp.Create;
            GS2.Assign(GS1.OGrp);
         end;
      if cond[10]=0 then
         begin
            igr1:=CodToIndex(gr);igr2:=igr1;
	      end
      else
         begin
            igr1:=1;
            igr2:=Sec.ByCod(sect).ByCod(an).Count;
         end;
      if _Grp.TipAsoc=0 then
         begin
            igr1:=CodToIndex(gr);
            igr2:=igr1;
	      end;
      for igr:=igr1 to igr2 do
         begin
            gr1:=IndexToCod(igr);
            if ByCod(gr1).ByGrp(_Grp)<>nil then
               begin
   	            _Grp2.Assign(ByCod(gr1).ByGrp(_Grp));
   	            if (_Grp2.TipAsoc=_Grp.TipAsoc)or(igr1=igr2)then
      	            Result:=Delul(gr1);
               end;
         end;
   end;//with
   _Grp.Free;_Grp2.Free;
   GS1.Free;GS2.Free;
end;

{function TGrups.Switch;
var _Grp1,_Grp2:TGrp;
	ora11,ora21,err:integer;
begin
   Result:=0;
   err:=0;ora11:=0;ora21:=0;
   _Grp1:=TGrp.Create;
   _Grp2:=TGrp.Create;
   if (zi1<>zi2)or(ora1<>ora2)then
      with Sec.ByCod(sect).ByCod(an).ByCod(gr) do
      begin
         if Rez.Exist(zi1,ora1)then
         begin
	         _Grp1.Assign(Rez[zi1,ora1]);
            ora11:=Del(sect,an,gr,zi1,ora1);
         end;
      if Rez.Exist(zi2,ora2)then
         begin
	         _Grp2.Assign(Rez[zi2,ora2]);
            ora21:=Del(sect,an,gr,zi2,ora2);
         end;
      if _Grp1.CMat<>0 then
         Result:=Put(sect,an,gr,zi2,ora2,_Grp1);
      if Result=0 then
         if _Grp2.CMat<>0 then
            begin
	            Result:=Put(sect,an,gr,zi1,ora1,_Grp2);
               if Result<>0 then Del(sect,an,gr,zi2,ora2);
            end;
      if (Result<>0) then
         begin
            if _Grp1.CMat<>0 then
               err:=Put(sect,an,gr,zi1,ora11,_Grp1);
            if err<>0 then
               ShowMessage('Nu pot pune inapoi 1 '+ReturnErr(err));
            if _Grp2.CMat<>0 then
               err:=Put(sect,an,gr,zi2,ora21,_Grp2);
            if err<>0 then
               ShowMessage('Nu pot pune inapoi 2 '+ReturnErr(err));
	      end;
      if (Result=0)and(not canSwitch) then
         begin
            if _Grp1.CMat<>0 then Del(sect,an,gr,zi2,ora2);
            if _Grp2.CMat<>0 then Del(sect,an,gr,zi1,ora1);
            if _Grp1.CMat<>0 then
               begin
                  err:=Put(sect,an,gr,zi1,ora11,_Grp1);
   	            if err<>0 then
                     ShowMessage('Nu pot pune inapoi 1 - '+ReturnErr(err));
               end;
            if _Grp2.CMat<>0 then
               begin
                  err:=Put(sect,an,gr,zi2,ora21,_Grp2);
   	            if err<>0 then
                     ShowMessage('Nu pot pune inapoi 2 - '+ReturnErr(err));
               end;
         end;
      end;
   _Grp1.Destroy;_Grp2.Destroy;
   exit;//gata
   //SwitchCompon(sect,an,gr,zi1,ora1,zi2,ora2);//anti hint
end;}

function TGrups.Switch;
var _Grp1,_Grp2:array[1..max_nrsapt] of TGrp;
    oraS1,oraS2:array[1..max_nrsapt] of integer;
    nrpoz1,nrpoz2,i,j:integer;
procedure Restore;
var er,k:integer;
begin
   for k:=1 to nrpoz1 do
      begin
         er:=Put(sect,an,gr,zi1,OraS1[k],_Grp1[k]);
         if er<>0 then ShowMessage('Nu pot pune inapoi 1');
      end;
   for k:=1 to nrpoz2 do
      begin
         er:=Put(sect,an,gr,zi2,OraS2[k],_Grp2[k]);
         if er<>0 then ShowMessage('Nu pot pune inapoi 2');
      end;
end;

begin
   Result:=0;
   for i:=1 to max_nrsapt do
      begin
         _Grp1[i]:=TGrp.Create;
         _Grp2[i]:=TGrp.Create;
         oraS1[i]:=0;oraS2[i]:=0;
      end;
   if (zi1<>zi2)or(ora1<>ora2)then
      with Sec.ByCod(sect).ByCod(an).ByCod(gr) do
      begin
         //memorez
         nrpoz1:=Rez.getNrPozSapt(zi1,ora1);
         for i:=nrpoz1 downto 1 do
            begin
               _Grp1[i].Assign(Rez.getGrp(zi1,ora1,i));
               oraS1[i]:=Del(sect,an,gr,zi1,ora1,i);
            end;
         nrpoz2:=Rez.getNrPozSapt(zi2,ora2);
         for i:=nrpoz2 downto 1 do
            begin
               _Grp2[i].Assign(Rez.getGrp(zi2,ora2,i));
               oraS2[i]:=Del(sect,an,gr,zi2,ora2,i);
            end;
         //sterg
         for i:=nrpoz1 downto 1 do
            begin

            end;
         for i:=nrpoz2 downto 1 do
            begin

            end;
         //pun 1
         for i:=1 to nrpoz1 do
            begin
               Result:=Put(sect,an,gr,zi2,ora2,_Grp1[i]);
               if Result<>0 then
                  begin
                     for j:=i-1 downto 1 do
                        Del(sect,an,gr,zi2,ora2,j);
                  end;
               if Result<>0 then break;
            end;
         //in caz de eroare restore all
         if Result<>0 then
            begin
               Restore;exit;
            end;
         //pun 2
         for i:=1 to nrpoz2 do
            begin
               Result:=Put(sect,an,gr,zi1,ora1,_Grp2[i]);
               if Result<>0 then
                  begin
                     for j:=i-1 downto 1 do
                        Del(sect,an,gr,zi1,ora1,j);
                     for j:=nrpoz1 downto 1 do
                        Del(sect,an,gr,zi2,ora2,j);
                  end;
               if Result<>0 then break;
            end;
         //in caz de eroare restore all
         if Result<>0 then
            begin
               Restore;exit;
            end;
         if (Result=0)and(not canSwitch) then
            begin
               for j:=nrpoz2 downto 1 do
                  Del(sect,an,gr,zi1,ora1,j);
               for j:=nrpoz1 downto 1 do
                  Del(sect,an,gr,zi2,ora2,j);
               Restore;
            end;
      end;
   for i:=1 to max_nrsapt do
      begin
         _Grp1[i].Free;
         _Grp2[i].Free;
      end;
   exit;//gata
   SwitchCompon(sect,an,gr,zi1,ora1,zi2,ora2);//anti hint
end;

function TGrups.ReturnErr;
begin
case errCode of
   -1: Result:='Result neschimbat';
   0: Result:='Operatie reusita';
	1: Result:='Depasire ore pe zi pentru clasa';
	2: Result:='Exista deja o materie';
   3: Result:='Depasire numar maxim de ore pe zi';
   4: Result:='Depasire numar maxim de ore admis de program';
   10,11,12,13: Result:='Profesor ocupat';
	20,21: Result:='Preferinta profesor';
   30:Result:='Exista inca o materie in ziua precedenta';
   31:Result:='Exista inca o materie in ziua urmatoare';
   40:Result:='Depasire numar de sali pentru materie';
   41:Result:='Nu mai exista sali disponibile';
   50:Result:='Grad de dificultate al materiei prea mic';
   51:Result:='Grad de dificultate al materiei prea mare';
   60:Result:='Depasire numar de ore pe zi pentru materie';
   70:Result:='Nu se admit goluri in orar';
   90:Result:='Depasire numar maxim de ferestre pe zi';
  100:Result:='Ora depaseste ultima ora admisa';
  105: Result:='Suprapunere ora la o saptamana cu ora la 2 saptamani';
  106: Result:='Suprapunere ora la 2 saptamani cu ora la 1 saptamana';
  107: Result:='Ora nu se afla in aceeasi saptamana cu cea dinainte';
  108: Result:='Ora nu se afla in aceeasi saptamana cu cea de dupa';

else Result:='Cod (eroare) necunoscut'
end;
end;

function TGrups.Make;
begin
Result:=MakeRez;
if Result<>0 then Result:=MakeRezPerm;
end;

function TGrups.MakeRez;
var indsec:integer;
begin
Result:=0;
if secBar<>nil then secBar.Max:=Sec.Count;
for indsec:=1 to Sec.Count do begin
	Result:=maxim(Result,MakeRezSec(Sec.IndexToCod(indsec)));
   if (secBar<>nil)and(ShowMakeProgress)
   	then secBar.Position:=indsec;
   end;
end;

function TGrups.MakeRezPerm;
var indsec:integer;
begin
Result:=0;
for indsec:=1 to Sec.Count do
	Result:=maxim(Result,MakeRezPermSec(Sec.IndexToCod(indsec)));
end;

function TGrups.MakeRezSec;
var indan:integer;
begin
Result:=0;
if aniBar<>nil then aniBar.Max:=Sec.ByCod(sect).Count;
for indan:=1 to Sec.ByCod(sect).Count do begin
	Result:=maxim(Result,MakeRezAn(sect,Sec.ByCod(sect).IndexToCod(indAn)));
   if (aniBar<>nil)and(ShowMakeProgress)
   	then aniBar.Position:=indan;
   end;
end;

function TGrups.MakeRezPermSec;
var indAn:integer;
begin
Result:=0;
for indAn:=1 to Sec.ByCod(sect).Count do
	Result:=maxim(Result,MakeRezPermAn(sect,Sec.ByCod(sect).IndexToCod(indAn)));
end;

function TGrups.MakeRezAn;
var indgr:integer;
begin
Result:=0;
with Sec.ByCod(sect).ByCod(an) do begin
if grupeBar<>nil then grupeBar.Max:=Count;
for indGr:=1 to Count do begin
	Result:=maxim(Result,MakeRezGr(sect,an,IndexToCod(indGr)));
   if (grupeBar<>nil)and(ShowMakeProgress)
   	then begin grupeBar.Position:=indGr;
   	Application.ProcessMessages;end;
   end;
end;
end;

function TGrups.MakeRezPermAn;
var indgr:integer;
begin
Result:=0;
with Sec.ByCod(sect).ByCod(an) do
for indGr:=1 to Count do
	Result:=maxim(Result,MakeRezPermGr(sect,an,IndexToCod(indGr)));
end;

function TGrups.MakeRezGr;
var i:integer;
begin
Result:=0;
with Sec.ByCod(sect).ByCod(an) do begin
for i:=1 to ByCod(gr).Count do begin
   Result:=maxim(Result,MakeRezMat(sect,an,gr,ByCod(gr).Grp[i]));
   end;
end;
end;

function TGrups.MakeRezPermGr;
var i:integer;
begin
Result:=0;
with Sec.ByCod(sect).ByCod(an) do begin
for i:=1 to ByCod(gr).Count do begin
   Result:=maxim(Result,MakeRezPermMat(sect,an,gr,ByCod(gr).Grp[i]));
   end;
end;
end;

function TGrups.MakeRezMat;
var zi,ora,indGrp:integer;
begin
with Sec.ByCod(sect).ByCod(an).ByCod(gr) do begin
   indGrp:=CodToIndex(_Grp.CProf,_Grp.CMat,_Grp.Ora);
   _Grp.Assign(Grp[indGrp]);
   repeat Result:=0;
   if _Grp.OraRest>0 then
		for zi:=1 to nrZile do begin
   		for ora:=1 to max_ore{OreZi[zi]} do begin
   			Result:=Put(sect,an,gr,zi,ora,_Grp);
      		if Result=0 then break;
      		end;
      	if Result=0 then break;
      	end;
   indGrp:=CodToIndex(_Grp.CProf,_Grp.CMat,_Grp.Ora);
   _Grp.Assign(Grp[indGrp]);
   until (_Grp.OraRest=0)or(Result<>0);
	end;
end;

function TGrups.MakeRezPermMat;
var i,zi,ora,err,err1,ora1,endu:integer;
	memGrp:TGrp;
begin
memGrp:=TGrp.Create;Result:=0;
with Sec.ByCod(sect).ByCod(an).ByCod(gr) do begin
for i:=1 to Count do
   repeat
      err:=-1;endu:=0;
      if Grp[i].OraRest>0 then
         for zi:=1 to nrZile do
         begin
   		   for ora:=1 to max_ore do
               if Rez.Exist(zi,ora) then
         	   begin
                  memGrp.Assign(Rez[zi,ora]);
                  { TODO -cAlgoritm : Rezolva Del la PermMat }
                  //ora1:=Del(sect,an,gr,zi,ora);
   			      err:=Put(sect,an,gr,zi,ora,Grp[i]);
      		      if err<>0 then
                  begin
                     endu:=-1;
            	      err1:=Put(sect,an,gr,zi,ora1,memGrp);
                     if err1<>0 then ShowMessage('am luat da nu pot pune inapoi');
                  end
                  else
                     begin
                        err:=MakeRezMat(sect,an,gr,memGrp);
                        if err=0 then break else
                        begin
                           endu:=-1;
                           { TODO -cAlgoritm : Rezolva Del la PermMat }
                           //Del(sect,an,gr,zi,ora);
                           err1:=Put(sect,an,gr,zi,ora1,memGrp);
               	         if err1<>0 then ShowMessage('am luat da nu pot pune inapoi');
               	      end;
            	      end;
               end;
      	   if err=0 then break;
      	end;
      Result:=maxim(Result,err);
   until (Grp[i].OraRest=0)or(endu<>0)or(err=-2);
end;//with
memGrp.Destroy;
end;

///////////////////////////////////////////////////

function TGrups.CheckOk;
var isec,ian,igr,i,j,k,lastfer,_CProf,_CProf1,indProf:integer;
	gradDif,NrSali{,sapt,poz_sapt}:integer;_Grp2:TGrp;
begin
_Grp2:=TGrp.Create;//sapt:=_Grp.Sapt;
try
Result:=0;_CProf:=_Grp.CProf;
with Sec.ByCod(sect).ByCod(an).ByCod(gr) do begin
//-1-depasire max_ore
err:=0;
if ora>max_ore then begin Result:=4;exit;end;
//-1-depasire orezi pe clasa
j:=0;
errsec:=sect;erran:=an;errgr:=gr;
errmat:=_Grp.CMat;errzi:=zi;errora:=ora;
err:=0;
{ TODO -oDan -cAlgoritm : Verifica depasire ore/zi si pt 2 sapt }
for i:=1 to max_ore do
   if Rez.Exist(zi,i) then inc(j);
if Self.cond[8]=1 then
	if j=OreZi[zi]+marjaOre then begin Result:=1;exit;end;
//depasire maxorezi
if Self.cond[11]=1 then
   if j=maxOreZi then begin Result:=3;exit;end;
//-10-nesuprapunere profesori
{ TODO 1 -cAlgoritm : Verificarea nu e buna pt ore la 2 saptamani }
err:=1;
if (Self.cond[1]=1)then
for isec:=1 to Sec.Count do
for ian:=1 to Sec[isec].Count do
for igr:=1 to Sec[isec][ian].Count do
begin
   if Sec[isec][ian][igr].Rez.Exist(zi,ora) then
   begin
      if _Grp2.OGrp<>nil then
         begin
            _Grp2.OGrp.Free;_Grp2.OGrp:=nil;
         end;
      _Grp2.Assign(Sec[isec][ian][igr].Rez[zi,ora]);
      _CProf1:=_Grp2.CProf;
      if (cond[10]=1)and
         ( (isec=Sec.Items.CodToIndex(sect))and
            (ian=Sec.ByCod(sect).Items.CodToIndex(an)) )
               and ( ((_Grp.TipAsoc=_Grp2.TipAsoc)and
                  (_Grp.Egal(_Grp2)))
                  or ((_Grp.Sapt=2)and(Sec[isec][ian][igr].Rez[zi,ora].Sapt=2)) )then
      else
         begin
            errsec:=isec;erran:=ian;errgr:=igr;
    	      if _CProf1=_CProf then
               begin
      	         Result:=10;exit;
               end; //prof<>prof1
            if _Grp.CProf<0 then with Sec[isec][ian][igr] do
      	      for j:=1 to MProfs.ByCod(-_CProf).Count do
                  begin //mprof<>prof1
        	            if _CProf1>0 then
                        if _CProf1=MProfs.ByCod(-_CProf).ValCod[j] then
                           begin
                              Result:=11;exit;
                           end;
        	            if _CProf1<0 then
                        for k:=1 to MProfs.ByCod(-_CProf1).Count do //mprof<>mprof1
         	               if MProfs.ByCod(-_CProf1).ValCod[k]=MProfs.ByCod(-_CProf).ValCod[j] then
                              begin
                                 Result:=12;exit;
                              end;
        	         end;
            if (_CProf1<0)and(_CProf>0) then
               for j:=1 to MProfs.ByCod(-_CProf1).Count do //prof<>mprof1
      	         if MProfs.ByCod(-_CProf1).ValCod[j]=_CProf then
                     begin
                        Result:=13;exit;
                     end;
         end;//cond
   end;
end;
//-2-nesuprapunere ore sau suprapunere ore la 2 saptamani
{ TODO -oDan -cAlgoritm : Verificare suprapunere ore la 2 saptamani }
err:=1;errsec:=sect;erran:=an;errgr:=gr;errzi:=zi;errora:=ora;
case _Grp.Sapt of
   1: begin
         if Rez.Exist(zi,ora) then
            begin
               Result:=2;exit;
            end;
      end;
   2: begin
         if Rez.Exist(zi,ora) then
            begin
               //verifica sa nu se suprapuna peste 1 saptamana
               if Rez[zi,ora].Sapt=1 then
                  begin
                     Result:=106;exit;
                  end;
            end;
         //verifica sa fie in aceeasi a 2-a saptamana cu cea dinainte sau dupa(daca exista)
         if (ora>1) then
            begin
               for i:=1 to Rez.getNrPozSapt(zi,ora-1) do
                  if (Rez.existGrp(zi,ora-1,i)) then
                     if Rez.getGrp(zi,ora-1,i).Egal(_Grp) then
                        begin
                           if _Grp.PozSapt<>i then
                              begin
                                 Result:=107;exit;
                              end;
                        end;
            end;
         //dupa
         if (ora<max_ore) then
            begin
               for i:=1 to Rez.getNrPozSapt(zi,ora+1) do
                  if (Rez.existGrp(zi,ora+1,i)) then
                     if Rez.getGrp(zi,ora+1,i).Egal(_Grp) then
                        begin
                           if _Grp.PozSapt<>i then
                              begin
                                 Result:=108;exit;
                              end;
                        end;
            end;
      end;
end;
//-20-preferinte profi
err:=0;
if Self.cond[6]=1 then begin
if _CProf>0 then begin
   indProf:=Profs.Items.CodToIndex(_CProf);
	if Profs.Pref[indProf,zi,ora]=1 then begin
		Result:=20;exit;end;end;
if _CProf<0 then for i:=1 to MProfs.ByCod(-_CProf).Count do begin
	indProf:=Profs.Items.CodToIndex(MProfs.ByCod(-_CProf).ValCod[i]);
   if Profs.Pref[indProf,zi,ora]=1 then begin
		Result:=21;exit;end;end;
end;
//-30-o zi distanta intre 2 materii
err:=1;
if (Self.cond[5]=1)and(_Grp.Ora=2)then begin
errsec:=sect;erran:=an;errgr:=gr;errzi:=zi-1;errora:=ora;
if zi>1 then for i:=1 to max_ore do
	if Rez.Exist(zi-1,i) then if Rez[zi-1,i].CMat=_Grp.CMat then
      begin Result:=30;exit;end;
errzi:=zi+1;
if zi<nrZile then for i:=1 to max_ore do
	if Rez.Exist(zi+1,i) then if Rez[zi+1,i].CMat=_Grp.CMat then
   	begin Result:=31;exit;end;
end;
//-40-sali
err:=1;
//NrSali:=Corp.GetNrSali(_Grp.CMat);
{ TODO -cAlgoritm -oDan:Nu face bine verificarea salilor }
NrSali:=Corp.GetNrSaliCorp(_Grp.CMat,_Grp.CCorp);
//salimem[0,1]:=0;
if Self.cond[4]=1 then
begin
   j:=getSaliOcup(_Grp,zi,ora,sect,an,NrSali,errsec,erran,errgr);
   if j>0 then if (NrSali<>-1)and(j>=NrSali) then
      begin
         //errsec:=isec;erran:=ian;errgr:=igr;
         errzi:=zi;errora:=ora;
         Result:=40;exit;
      end;
   if (NrSali>=0)and(j>NrSali)then showmessage('nrsali>nrsali');
end;//if
//-50-grad dificultate
err:=0;
if Self.cond[7]=1 then begin
	GradDif:=Mats.Items.ByCod(_Grp.CMat).MGradDif;
   if GradDif<>0 then begin
      if Dif[ora,1]<>0 then if GradDif<=Dif[ora,1]then begin
      	Result:=50;exit;end;
      if Dif[ora,2]<>0 then if GradDif>=Dif[ora,2]then begin
      	Result:=51;exit;end;
   	end;
	end;
//-60-depasire ore pe zi pt. materie
err:=1;
if Self.cond[3]=1 then begin j:=0;
   for i:=1 to max_ore do if Rez.Exist(zi,i) then begin
   	if Rez[zi,i].CMat=_Grp.CMat then inc(j);
   	errsec:=sect;erran:=an;errgr:=gr;errzi:=i;errora:=ora;
   	end;
   if _Grp.OreCons=0 then k:=Mats.Items.ByCod(_Grp.CMat).MOreCons
   	else k:=_Grp.OreCons;
	if j=k then begin Result:=60;exit;end
   else if j>k then ShowMessage('depasire nrorecons');
end;
//-70-verificare goluri
err:=0;
if (Self.cond[9]=1)and(ora>1)then
begin
   if not Rez.Exist(zi,ora-1) then
   begin
      Result:=70;
      exit;
   end;
end;
//-80-grupele fac impreuna
if Self.cond[10]=1 then begin
   //if _Grp.TipMatGrupe=1
	end;
//-90-verificare ferestre
{ TODO -oDan -cAlgoritm : Verifica ferestre si pt 2 sapt }
err:=0;
if Self.cond[12]=1 then
   begin
      lastfer:=0;
      j:=0;//nr ferestre
      k:=1;//ultima ora
      for i:=1 to max_ore do
         begin
            if (Rez.Exist(zi,i)and (Rez[zi,i].Sapt=1))or(i in [ora_start..ora_end])then
               k:=0
            else
               begin
                  if k=0 then
                     begin
                        inc(j);
                        lastfer:=i;
                     end;
                  k:=1;
               end;
         end;
      dec(j);
      for i:=lastfer to max_ore do if Rez.Exist(zi,i) then
         begin
            inc(j);break;
         end;
      if j>maxFer then
         begin
            Result:=90;
            exit;
         end;
   end;
//-100-se respecta ora de final
err:=0;
if Self.cond[13]=1 then
   begin
      if ora>(oraEnd-oraStart) then
         begin
            Result:=100;exit;
         end;
   end;
end;//with
finally _Grp2.Free;end;
end;

procedure TGrups.MakeTotalOre;
var i:integer;
begin
_totalore:=0;
for i:=1 to Self.Sec.Count do begin
    Sec[i].MakeTotalOre;
	_totalore:=_totalore+Sec[i].TotalOre;
    end;
end;

procedure TGrups.MakeOreZi;
var i:integer;
begin
for i:=1 to Sec.Count do Sec[i].MakeOreZi(nrZile);
end;
//-------------------CAT----------------
constructor TCat.Create;
begin
Items:=TItems.Create;
inherited Create;
end;

destructor TCat.Destroy;
begin
Items.Destroy;
inherited Destroy;
end;

procedure TCat.Assign;
begin
Items:=TItems.Create;
Items.Assign(value.Items);
inherited Assign(value);
end;

procedure TCat.SaveToFile;
begin
writeln(F,'[CAT]');
Items.SaveToFile(F);
inherited SaveToFile(F);
writeln(F,'[END-CAT]');
end;

procedure TCat.LoadFromFile;
begin
readln(F);
Items.LoadFromFile(F);
inherited LoadFromFile(F);
readln(F);
end;

//------------------REZ----------------
constructor TRez.Create;
var i:integer;
begin
if 1=2 then ValRez[0,0]:=ValRez[0,0];//no hint stress
for i:=1 to max_zile do begin
    _orePuse[i]:=0;OreTot[i]:=0;end;
end;

destructor TRez.Destroy;
var zi,ora:integer;
begin
for zi:=1 to max_zile do for ora:=1 to max_ore do
    begin list[zi,ora].Free;list[zi,ora]:=nil;end;
inherited Destroy;
end;

procedure TRez.Assign;
var zi,ora,i:integer;
begin
for zi:=1 to max_zile do begin
    for ora:=1 to max_ore do for i:=1 to max_nrsapt do
        if value.list[zi,ora]<>nil then begin
           list[zi,ora]:=TGrp.Create;
           list[zi,ora].Assign(value.list[zi,ora]);
           end;
    _orePuse[zi]:=value._orePuse[zi];
    OreTot[zi]:=value.OreTot[zi];
    end;
end;

function TRez.ValRead;
begin
Result:=list[zi,ora];
if Result=nil then ShowMessage('Read nil - TRez.ValRead');
end;

procedure TRez.ValWrite;
var G1:TGrp;
begin
   if list[zi,ora]=nil then
      begin
         list[zi,ora]:=TGrp.Create;
         list[zi,ora].SetVal(value);
      end
   else
      begin//inserez in ordinea pozsapt
         if value.PozSapt>=ValRead(zi,ora).PozSapt then
            begin
               list[zi,ora].OGrp:=TGrp.Create;
               list[zi,ora].OGrp.SetVal(value)
            end
         else
            begin
               G1:=TGrp.Create;
               G1.Assign(ValRead(zi,ora));
               list[zi,ora].SetVal(value);
               list[zi,ora].OGrp:=TGrp.Create;
               list[zi,ora].OGrp.Assign(G1);
               G1.Destroy;
            end;
      end;
end;

procedure TRez.SaveToFile;
var zi,ora:integer;
begin
writeln(F,'[REZ]');
for zi:=1 to max_zile do for ora:=1 to max_ore do
    if list[zi,ora]<>nil then begin
       writeln(F,zi,',',ora);
       list[zi,ora].SaveToFile(F);
       end;
writeln(F,'[END-REZ]');
end;

procedure TRez.LoadFromFile;
var zi,ora:integer;s:string;G:TGrp;endu:boolean;
begin
readln(F);//rez
G:=TGrp.Create;
repeat
   readln(F,s);
   if s<>'[END-REZ]'then
   begin
      endu:=false;
      zi:=param(s,1);ora:=param(s,2);
      G.LoadFromFile(F);
      CreateGrp(zi,ora,G);
   end
   else endu:=true;
until endu;
G.Free;
end;

procedure TRez.CreateGrp;
begin
   ValWrite(zi,ora,value);
   inc(_orePuse[zi]);
end;

procedure TRez.Del;
var G:TGrp;
begin
if Exist(zi,ora) then
   begin
      if (list[zi,ora].OGrp<>nil)and(ValRead(zi,ora).OGrp.PozSapt=_PozSapt)then
         begin
            list[zi,ora].OGrp.Destroy;
            list[zi,ora].OGrp:=nil;
            dec(_orePuse[zi]);
            if _orePuse[zi]<0 then showmessage('OrePuse[zi]<0');
            exit;
         end
      else
         begin
            if ValRead(zi,ora).PozSapt=_PozSapt then
               begin
                  if list[zi,ora].OGrp<>nil then
                     begin
                        G:=TGrp.Create;
                        G.Assign(list[zi,ora].OGrp);
                        list[zi,ora].OGrp.Destroy;
                        list[zi,ora].OGrp:=nil;
                        list[zi,ora].Assign(G);
                        G.Destroy;
                     end
                  else
                     begin
                        list[zi,ora].Destroy;
                        list[zi,ora]:=nil;
                     end;
                  dec(_orePuse[zi]);
                  if _orePuse[zi]<0 then showmessage('OrePuse[zi]<0');
                  exit;
               end;
         end;
   end
else
   ShowMessage('Del nil');
ShowMessage('del pozsapt not found');
end;

function TRez.OrePuse;
begin
   Result:=_orePuse[zi];
end;

procedure TRez.Switch;
var i:TGrp;
begin
i:=list[zi1,ora1];
list[zi1,ora1]:=list[zi2,ora2];
list[zi2,ora2]:=i;
end;

function TRez.Exist;
begin
if list[zi,ora]<>nil then Result:=True else Result:=False;
end;

function TRez.GetMaxOra;
var zi,ora:integer;
begin
Result:=0;
for zi:=1 to max_zile do for ora:=1 to max_ore do
	if Exist(zi,ora) then Result:=maxim(Result,ora);
end;

function TRez.GetMaxZi;
var zi,ora:integer;
begin
Result:=0;
for zi:=1 to max_zile do for ora:=1 to max_ore do
	if Exist(zi,ora) then Result:=maxim(Result,zi);
end;

function TRez.getFreePozSapt;
var i:integer;
begin
   Result:=1;
   if Exist(zi,ora) then
      for i:=1 to max_nrsapt do
         if not existGrp(zi,ora,i) then
            begin
               Result:=i;exit;
            end;
end;

function TRez.getNrPozSapt;
var i:integer;
begin
   Result:=0;
   if Exist(zi,ora) then
      for i:=1 to max_nrsapt do
         if existGrp(zi,ora,i) then
            inc(Result);
end;

function TRez.getLastPozSapt;
var i:integer;
begin
   Result:=0;
   if Exist(zi,ora) then
      for i:=1 to max_nrsapt do
         if existGrp(zi,ora,i) then
            Result:=maxim(Result,getGrp(zi,ora,i).PozSapt);
end;

function TRez.getGrp;
begin
   Result:=nil;
   if Exist(zi,ora) then
      begin
         if ValRead(zi,ora).PozSapt=PozSapt then
            Result:=ValRead(zi,ora)
         else
            if ValRead(zi,ora).OGrp<>nil then
               begin
                  if ValRead(zi,ora).OGrp.PozSapt=PozSapt then
                     Result:=ValRead(zi,ora).OGrp;
               end;
      end;
end;

function TRez.existGrp;
begin
   if getGrp(zi,ora,PozSapt)<>nil then
      Result:=True
   else
      Result:=False;
end;

//-------------ORAR---------------------------------
constructor TOrar.Create;
var i:integer;g:TItem;
begin
Empty:=True;specific:=2;
Grups:=TGrups.Create;
Zile:=TItems.Create;
g:=TItem.Create;Info:='Orarul Facultatii de Stiinte Economice';
for i:=1 to 7 do begin g.Val:=zileN[i];g.Cod:=i;
    Zile.AddWithCod(g);end;
g.Free;
end;

destructor TOrar.Destroy;
begin
Grups.Free;Grups:=nil;
Zile.Free;Zile:=nil;
inherited Destroy;
end;

procedure TOrar.Assign;
begin
Clear;
Grups:=TGrups.Create;Grups.Assign(value.Grups);
Zile:=TItems.Create;Zile.Assign(value.Zile);
Info:=value.Info;Empty:=value.Empty;
specific:=value.specific;
end;

procedure TOrar.Clear;
begin
Grups.Free;Grups:=TGrups.Create;
Zile.Free;Zile:=TItems.Create;
Info:='';Empty:=True;
end;

procedure TOrar.writeSpec;
begin
_spec:=value;
case Specific of
1: begin
	clasL[1]:='Clase';
   clasL[2]:='clase';
   clasL[3]:='Clasa';
   clasL[4]:='Clase';
   clasL[5]:='clase';
   end;
2: begin
	clasL[1]:='Ani';
   clasL[2]:='ani';
   clasL[3]:='Anul';
   clasL[4]:='Grupe';
   clasL[5]:='grupe';
   end;
end;//case
end;

procedure TOrar.SaveToFile;
begin
if FileExists(FileName)then
   if MessageDlg('Fisierul "'+FileName+'" deja exista. Doriti sa-l suprascrieti ?',
      mtWarning,mbOKCancel,0)=mrCancel then exit;
try
   AssignFile(F,FileName);
   Rewrite(F);
   writeln(F,'CD');
   writeln(F,'[ORAR]');
   writeln(F,Info);
   writeln(F,specific);
   Zile.SaveToFile(F);
   Grups.SaveToFile(F);
   writeln(F,'[END-ORAR]');
finally Close(F);end;
end;

procedure TOrar.LoadFromFile;
var s:string;i:integer;
begin
if not FileExists(FileName)then
   MessageDlg('Fisierul "'+FileName+'" nu exista. Verificati calea si numele.',mtWarning,[mbOK],0);
AssignFile(F,FileName);
try
   Reset(F);
   readln(F,s);//cd
   if s<>'CD' then begin
          MessageDlg('Fisierul '+FileName+' este corupt.',mtError,[mbOK],0);exit;end;
   readln(F);//orar
   Clear;
   readln(F,Info);//info
   readln(F,i);//specific
   specific:=i;
   Zile.LoadFromFile(F);
   Grups.LoadFromFile(F);
   readln(F,s);//end-orar
   Empty:=false;
finally Close(F);end;
end;
//------------------------------------------------

end.
