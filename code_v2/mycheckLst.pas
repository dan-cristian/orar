unit mycheckLst;

interface
uses checklst,classes,sysutils,dialogs,stdctrls,
     procs,gen,orrClass;

const max_it=max_sectii*max_ani*max_mat;
type

TCheckLst=class(TCheckListBox)
    Orr:TOrar;
  private
    mylist:array[0..max_it-1]of TGrp;
    mylistc:array[0..max_it-1]of TCheckBoxState;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;             //0-disp 1-modi 2-first
    procedure AddItem(index,indexmic:integer;value:TGrp;Add:integer;Avance:boolean);
    function GetItem(index:integer):TGrp;
    procedure SetItem(index,indexmic:integer;value:TGrp);
    function Exist(index:integer):boolean;
    procedure ClearItems;
    procedure SetCheck(index:integer;state:TCheckBoxState);
  end;

implementation

constructor TCheckLst.Create;
begin
ClearItems;
inherited Create(AOwner);
end;

destructor TCheckLst.Destroy;
begin
ClearItems;
inherited Destroy;
end;

procedure TCheckLst.ClearItems;
var i:integer;
begin
for i:=0 to max_it-1 do begin
	if Exist(i) then mylist[i].Free;
   mylistc[i]:=cbUnchecked;
   mylist[i]:=nil;end;
end;

procedure TCheckLst.SetItem;
begin
GetItem(index).Assign(value);
value.Clear;
AddItem(index,indexmic,value,1,True);
end;

function TCheckLst.GetItem;
begin
if not Exist(index)then ShowMessage('Get nil');
Result:=mylist[index];
end;

function TCheckLst.Exist;
begin
if mylist[index]=nil then Result:=False else Result:=True;
end;

procedure TCheckLst.SetCheck;
begin
mylistc[index]:=state;
end;

procedure TCheckLst.AddItem;
var s,s0:string;
    _Grp:TGrp;
begin
_Grp:=TGrp.Create;
if Exist(index) then _Grp.Assign(GetItem(index));
if value.CProf=0 then value.CProf:=_Grp.CProf;
if value.CMat=0 then value.CMat:=_Grp.CMat;
if value.Ora=0 then value.Ora:=_Grp.Ora;
if value.OraRest=0 then value.OraRest:=_Grp.OraRest;
if value.TipMat=0 then value.TipMat:=_Grp.TipMat;
if value.TipAsoc=-1 then value.TipAsoc:=_Grp.TipAsoc;
if value.TipAsoc=-1 then value.TipAsoc:=0;
if value.OreCons=-1 then value.OreCons:=_Grp.OreCons;
if value.OreCons=-1 then value.OreCons:=0;
if value.Sapt=0 then value.Sapt:=_Grp.Sapt;
with Orr.Grups do with value do begin
     if CMat>0 then s0:=Mats.Items.ByCod(CMat).Val else s0:=' ';//mat
     s:=s+AdjustStr(s0,Mats.Items.MaxLength)+' ';
     if CProf>0 then s0:=Profs.Items.ByCod(CProf).Val           //prof
        else if CProf<0 then
             s0:='('+inttostr(MProfs.ByCod(-CProf).Count)+' prof)'
        else s0:=' ';
     s:=s+AdjustStr(s0,Profs.Items.MaxLength)+' ';
     if Ora>0 then s0:=inttostr(Ora)+' h' else s0:=' ';			//ore
     s:=s+AdjustStr(s0,4)+' ';
     if TipMat>0 then s0:=Mats.Tip[TipMat] else s0:=' ';			//tipmat
     s:=s+AdjustStr(s0,9)+' ';
     if OreCons>0 then s0:=inttostr(OreCons) else begin			//orecons
     	if CMat<>0 then s0:=inttostr(Mats.Items.ByCod(CMat).MOreCons)
      else s0:=' ';end;
     s:=s+AdjustStr(s0,2)+' ';
     s0:=inttostr(TipAsoc);												//asoc
     s:=s+AdjustStr(s0,2)+' ';
     s0:=inttostr(Sapt);                                       //sapt
     s:=s+AdjustStr(s0,2)+' ';
     if (mylist[index]=nil) then mylist[index]:=TGrp.Create;
     if Add=1 then GetItem(index).SetVal(value);
     end;
if indexmic=-1 then begin
	Self.Items[index]:=s;
   Self.State[index]:=mylistc[index];
   end else begin
   Self.Items[indexmic]:=s;
   Self.State[indexmic]:=mylistc[index];
   end;
with Self do if value.Full then begin
   mylistc[index]:=cbChecked;
   if indexmic=-1 then State[index]:=cbChecked else State[indexmic]:=cbChecked;
   if (value.CProf>0)and Avance then begin
      if indexmic<>-1 then Itemindex:=indexmic+1
      	else ItemIndex:=ItemIndex+1;
      end;
   end else
	if value.Part then begin
   	mylistc[index]:=cbGrayed;
   	if indexmic=-1 then State[index]:=cbGrayed
   		else State[indexmic]:=cbGrayed;
   	end;
_Grp.Free;
end;


end.
