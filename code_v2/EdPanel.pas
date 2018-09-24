unit EdPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TEdPanel = class(TPanel)
   Ed:TEdit;
   List:TListBox;
   Lab:TLabel;
   private
    { Private declarations }
   _Items:TStrings;
   _Space:integer;
   _LabSpace:integer;
   _EdWidth:single;
   _EdAlign:boolean;
   _LabCaption:string;
   _EdOnKeyPress:TKeyPressEvent;
   _EdOnClick:TNotifyEvent;
   _ListOnKeyPress:TKeyPressEvent;
   _ListOnClick:TNotifyEvent;
   _ListOnDblClick:TNotifyEvent;
   _ListOnKeyDown:TKeyEvent;
   _EdOnEnter:TNotifyEvent;
   _ListOnEnter:TNotifyEvent;
   procedure wSpace(value:integer);
   procedure wItems(value:TStrings);
   procedure wLabSpace(value:integer);
   procedure wEdWidth(value:single);
   procedure wEdAlign(value:boolean);
   procedure wLabCaption(value:string);
   procedure wListIndex(value:integer);
   function  rListIndex:integer;
   procedure wEdOnClick(value:TNotifyEvent);
   procedure wListOnClick(value:TNotifyEvent);
   procedure wListOnDblClick(value:TNotifyEvent);
   procedure wEdOnKeyPress(value:TKeyPressEvent);
   procedure wListOnKeyPress(value:TKeyPressEvent);
   procedure wListOnKeyDown(value:TKeyEvent);
   procedure wEdOnEnter(value:TNotifyEvent);
   procedure wListOnEnter(value:TNotifyEvent);
   procedure EdResize;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Paint;override;
  published
    { Published declarations }
    property Space:integer read _Space write wSpace;
    property Items:TStrings read _Items write wItems;
    property LabSpace:integer read _LabSpace write wLabSpace;
    property EdWidth:single read _EdWidth write wEdWidth;
    property EdAlign:boolean read _EdAlign write wEdAlign;
    property LabCaption:string read _LabCaption write wLabCaption;
    property ListIndex:integer read rListIndex write wListIndex;
    property EdOnKeyPress:TKeyPressEvent
         read _EdOnKeyPress write wEdOnKeyPress;
    property EdOnClick:TNotifyEvent
         read _EdOnClick write wEdOnClick;
    property ListOnKeyPress:TKeyPressEvent
         read _ListOnKeyPress write wListOnKeyPress;
    property ListOnClick:TNotifyEvent
         read _ListOnClick write wListOnClick;
    property ListOnDblClick:TNotifyEvent
         read _ListOnDblClick write wListOnDblClick;
    property ListOnKeyDown:TKeyEvent
         read _ListOnKeyDown write wListOnKeyDown;
    property EdOnEnter:TNotifyEvent
         read _EdOnEnter write wEdOnEnter;
    property ListOnEnter:TNotifyEvent
         read _ListOnEnter write wListOnEnter;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TEdPanel]);
end;

constructor TEdPanel.Create;
begin
inherited Create(AOwner);
BorderWidth:=2;
BevelInner:=bvNone;
BevelOuter:=bvNone;
Ed:=TEdit.Create(Self);
List:=TListBox.Create(Self);
Lab:=TLabel.Create(Self);
Items:=List.Items;
with Lab do begin
   Parent:=Self;
   Top:=BorderWidth+BevelWidth;
   Left:=Top;
   end;
with Ed do begin
   Parent:=Self;
   Left:=Lab.Left;
   end;
with List do begin
   Parent:=Self;
   Left:=Lab.Left;
   end;
Caption:='';
Space:=5;
EdWidth:=1;
EdAlign:=True;
EdResize;
end;

destructor TEdPanel.Destroy;
begin
Lab.Destroy;
Ed.Destroy;
List.Destroy;
inherited Destroy;
end;

procedure TEdPanel.Paint;
begin
if List.Height<>Self.Height-(Ed.Top+Ed.Height+Space+BorderWidth)
   then EdResize;
if List.Width<>Self.Width-(2*List.Left)
   then EdResize;
inherited Paint;
end;

procedure TEdPanel.EdResize;
begin
if EdAlign then Ed.Width:=Width-(2*Ed.Left);
Ed.Top:=Lab.Top+Lab.Height+LabSpace;
List.Top:=Ed.Top+Ed.Height+Space;
List.Width:=Width-(2*List.Left);
List.Height:=Height-(Ed.Top+Ed.Height+Space);
end;

procedure TEdPanel.wItems;
begin
_Items:=List.Items;
end;

procedure TEdPanel.wSpace;
begin
_Space:=value;EdResize;
end;

procedure TEdPanel.wLabSpace;
begin
_LabSpace:=value;EdResize;
end;

procedure TEdPanel.wEdWidth;
begin
_EdWidth:=value;
if not EdAlign then Ed.Width:=trunc(List.Width*EdWidth);
end;

procedure TEdPanel.wEdAlign;
begin
_EdAlign:=value;if EdAlign then EdResize;
end;

procedure TEdPanel.wLabCaption;
begin
_LabCaption:=value;Lab.Caption:=LabCaption;
end;

procedure TEdPanel.wListIndex;
begin
List.ItemIndex:=value;
end;

function TEdPanel.rListIndex;
begin
Result:=List.ItemIndex;
end;

procedure TEdPanel.wEdOnClick;
begin
_EdOnClick:=value;Ed.OnClick:=EdOnClick;
end;

procedure TEdPanel.wListOnClick;
begin
_ListOnClick:=value;List.OnClick:=ListOnClick;
end;

procedure TEdPanel.wListOnDblClick;
begin
_ListOnDblClick:=value;List.OnDblClick:=ListOnDblClick;
end;

procedure TEdPanel.wEdOnKeyPress;
begin
_EdOnKeyPress:=value;Ed.OnKeyPress:=EdOnKeyPress;
end;

procedure TEdPanel.wListOnKeyPress;
begin
_ListOnKeyPress:=value;List.OnKeyPress:=ListOnKeyPress;
end;

procedure TEdPanel.wListOnKeyDown;
begin
_ListOnKeyDown:=value;List.OnKeyDown:=ListOnKeyDown;
end;

procedure TEdPanel.wEdOnEnter;
begin
_EdOnEnter:=value;Ed.OnEnter:=EdOnEnter;
end;

procedure TEdPanel.wListOnEnter;
begin
_ListOnEnter:=value;List.OnEnter:=ListOnEnter;
end;


end.
