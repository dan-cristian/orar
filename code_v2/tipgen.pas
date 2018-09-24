unit tipgen;

interface

uses ComCtrls,OrrClass;

procedure writeTitle(Orr:TOrar;rich:TRichEdit);

implementation

uses Graphics,Forms,Classes;

procedure writeTitle;
begin
with Rich do begin
SelAttributes.Style:=[fsBold];Paragraph.Alignment:=taCenter;
SelAttributes.Size:=13;
Lines.Add(Orr.Info);
SelAttributes.Style:=[];Paragraph.Alignment:=taLeftJustify;
SelAttributes.Size:=8;
Lines.Add('');
end;
end;

end.
