unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Windows, InterfaceBase, Classes, SysUtils, FileUtil, RTTICtrls, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ComCtrls, MaskEdit, ExtCtrls, Buttons, Spin, EditBtn,
  FileCtrl, mmSystem, Types, ComObj;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Novo: TButton;
    Atualizar: TButton;
    CBox1: TComboBox;
    CBox2: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    LTarefa: TLabel;
    LTime: TLabel;
    Label4: TLabel;
    Lbox1: TListBox;
    LBox2: TListBox;
    Panel1: TPanel;
    Progress: TProgressBar;
    Progress2: TProgressBar;
    ProgressBar1: TProgressBar;
    TimeEdit1: TTimeEdit;
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    procedure NovoClick(Sender: TObject);
    procedure AtualizarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Lbox1Click(Sender: TObject);
    function  TimeToSegundos(Time: TTime): Integer;
  private

  public
     var inicio: ttime;
         PMax: array[0..19] of Integer;

  end;

var
  Form1: TForm1;
  Player: OleVariant;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.TimeToSegundos(Time: TTime): Integer;
  var
  hora, minuto, segundo, miliseg: Word;
begin
    DecodeTime(Time, hora, minuto, segundo, miliseg);
    Result := ((hora * 3600) + (minuto*60)+segundo);
end;

procedure TForm1.NovoClick(Sender: TObject);
begin
   inicio:= time;
   CBox1.Items.Add(TimeEdit1.Text+':01');
   CBox2.Items.Add(timetostr(inicio));
   LBox2.Items.Add(timetostr(time - inicio));
   Timer1.Enabled:=true;

   Label2.Caption:= 'Número de Tarefas: '+inttostr(LBox2.Items.Count)+' / 20';
   PMax[CBox1.Items.Count-1]:= TimeToSegundos(strtotime(CBox1.Items.Strings[CBox1.Items.Count-1]));
   Progress.Max:= PMax[CBox1.Items.Count-1];
   Panel1.Visible:=false;
   Atualizar.Enabled:=true;

   if Edit1.Text = '' then
   begin
      LBox1.Items.Add('Tarefa '+inttostr(LBox1.Items.Count+1));

   end
   else
   begin
      LBox1.Items.Add(Edit1.Text);
   end;
   Edit1.Text:='';
   if LBox2.Items.Count = 20 then
   begin
      Novo.Enabled:= False;
   end;
   LBox1.Selected[LBox2.Count-1]:=true;
end;

procedure TForm1.AtualizarClick(Sender: TObject);
begin
   inicio:= time;
   Cbox1.Items.Strings[Lbox1.ItemIndex]:=TimeEdit1.Text+':01';
   Cbox2.Items.Strings[Lbox1.ItemIndex]:=timetostr(inicio);
   PMax[Lbox1.ItemIndex]:= TimeToSegundos(strtotime(CBox1.Items.Strings[LBox1.ItemIndex]));
   Progress.Max:=PMax[Lbox1.ItemIndex];
   LBox1.Items.Strings[LBox1.ItemIndex]:= Edit1.Text;
   LTarefa.Left:= (Form1.Width - LTarefa.Width) div 2;
   Panel1.Visible:=false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   LTime.Left:= (Form1.Width - LTime.Width) div 2;
   Label5.Left:= (panel1.Width - Label5.Width) div 2;
   LTime.font.Color:= rgb(110, 217, 239);
   LBox1.Color:=rgb(40, 41, 35);
   LBox2.Color:=rgb(40, 41, 35);
   Panel1.Color:=rgb(40, 41, 35);
   Panel1.Font.Color:= rgb(110, 217, 239);
   Label1.Font.Color:= rgb(110, 217, 239);
   Label2.Font.Color:= rgb(110, 217, 239);
   Label4.Font.Color:= rgb(110, 217, 239);
   LBox1.Font.Color:=rgb(110, 217, 239);
   LBox2.Font.Color:=rgb(110, 217, 239);

end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
  Panel1.Visible:=false;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
  var i, Pseg:integer;

begin
   i := 0;
   for i := 0 to LBox2.Items.Count - 1 do
begin
      if CBox1.Items.Strings[i] <> '00:00:00' then
      begin
         LBox2.Items.Strings[i]:= timetostr(strtotime(CBox1.Items.Strings[i])
         -(time - strtotime(CBox2.Items.Strings[i])));
         if LBox2.Items.Strings[i] = '00:00:00' then
         begin
            CBox1.Items.Strings[i]:= '00:00:00';
            Player:= CreateOleObject('wmplayer.ocx.7');
            Player.url:=OleVariant(UTF8Decode('./som.mp3'));
            Label3.Caption:= LBox1.Items.Strings[i];
            Panel1.Visible:=true;
            Label3.Left:= (panel1.Width - Label3.Width) div 2;
            Panel1.Visible:= true;
            If Not Application.Active then
            FlashWindow(WidgetSet.AppHandle, True);
         end;
      end;
  end;
  LTime.Caption:=  LBox2.Items.Strings[Lbox1.ItemIndex];
  Pseg:=TimeToSegundos(strtotime(LBox2.Items.Strings[Lbox1.ItemIndex]));
  progress.Position:= Pseg;
  Progress2.Max:= Progress.Max;
  Progress2.Position:= Progress.Position;
  end;

procedure TForm1.Lbox1Click(Sender: TObject);
begin
  LTarefa.Caption:= Lbox1.Items.Strings[Lbox1.ItemIndex];
  Atualizar.Enabled:=true;
  Progress.Max:=PMax[Lbox1.ItemIndex];
  Edit1.Text:= LBox1.Items.Strings[LBox1.ItemIndex];
  LTarefa.Left:= (Form1.Width - LTarefa.Width) div 2;
  Panel1.Visible:=false;

end;

end.

