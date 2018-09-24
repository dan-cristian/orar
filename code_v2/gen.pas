unit gen;

interface
uses OrrClass,procs,Dialogs,SysUtils;

type mess_type=set of (
   m_noprofcat,m_noprofgrp,m_noprofmat,
   m_nomatinprof

   );

const
     borderW=80;borderH=100;
     borderTop=100;

function GiveLine(indsec,indan,indgr,indmat,tip:integer;Orr:TOrar):integer;
procedure DecodeIndex(index,tip:integer;var indsec,indan,indgr,indmat:integer;Orr:TOrar);
function Mess(mesaj:mess_type):integer;

implementation

function Mess;
var s:string;
begin
s:='';
if m_noprofcat in mesaj then
   s:=s+'Nu ati definit corespondentele dintre profesori si catedre'+crlf;
if m_noprofgrp in mesaj then
   s:=s+'Nu ati selectat profilele pentru grupe sau ani'+crlf;
if m_noprofmat in mesaj then
   s:=s+'Nu ati selectat profilele pentru materii'+crlf;
if m_nomatinprof in mesaj then
   s:=s+'Nu ati selectat materii pentru profil'+crlf;

ShowMessage(s);
Result:=1;
end;

function GiveLine;		//tip 1-sec 2-ani 3-gr 0-mat >10 restrans fara grupe
var isec,ian,igr,imat:integer;
begin
Result:=0;
with Orr.Grups do
for isec:=1 to Sec.Items.Count do begin
inc(Result);
if (tip mod 10=1)and(isec=indsec)then exit;
for ian:=1 to Sec[isec].Items.Count do begin
   inc(Result);
   if (tip mod 10=2)and(isec=indsec)and(ian=indan)then exit;
	for igr:=1 to Sec[isec][ian].Items.Count do begin
      if tip<10 then inc(Result);
      if (tip mod 10=3)and(isec=indsec)and(ian=indan)and(igr=indgr)then exit;
      for imat:=1 to Mats.Items.Count do begin
      	if (isec=indsec)and(ian=indan)and(igr=indgr)and(imat=indmat)then exit;
      	if (tip<10)or(igr=1)then inc(Result);
      	end;
      end;
	end;
end;
end;

procedure DecodeIndex;
var countBef,isec,ian,igr,imat:integer;
begin
with Orr.Grups do begin
inc(index);countBef:=0;igr:=0;imat:=0;ian:=0;
for isec:=1 to Sec.Items.Count do begin
   ian:=0;igr:=0;imat:=0;
   if countBef>=index then break;
   inc(countBef);
   if countBef>=index then break;
	for ian:=1 to Sec[isec].Items.Count do begin
		igr:=0;imat:=0;
   	if countBef>=index then break;
   	inc(countBef);
   	if countBef>=index then break;
   	for igr:=1 to Sec[isec][ian].Items.Count do begin
   		imat:=0;
         if tip<10 then inc(countBef);
      	if countBef>=index then break;
         if ((tip>=10)and(igr=1))or(tip<10)then
      		for imat:=1 to Mats.Items.Count do begin
      			inc(countBef);if countBef>=index then break;
         		end;
      	if countBef>=index then break;
      	end;
   	if countBef>=index then break;
   	end;
   if countBef>=index then break;
	end;
indsec:=isec;indan:=ian;indgr:=igr;indmat:=imat;
end;
end;

begin

end.
