unit waterEnterDaily;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, globalUnit;

type
  Tform_waterEnterDaily = class(TForm)
    lbl_goal: TLabel;
    lbl_displaygoal: TLabel;
    shp_displayGoal: TShape;
    lbl_date: TLabel;
    lbl_bmi: TLabel;
    lbl_displayBMI: TLabel;
    shp_displayBMI: TShape;
    lbl_question: TLabel;
    lbl_bounds: TLabel;
    Panel1: TPanel;
    img_icon: TImage;
    lbl_sleepTracker: TLabel;
    lbl_back: TLabel;
    cbo_selectView: TComboBox;
    edt_input: TEdit;
    btn_submit: TButton;
    mmo_comment: TMemo;
    procedure btn_submitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbo_selectViewChange(Sender: TObject);
    procedure lbl_backClick(Sender: TObject);
    procedure lbl_backMouseEnter(Sender: TObject);
    procedure lbl_backMouseLeave(Sender: TObject);
  private
  public
  end;
var
  form_waterEnterDaily: Tform_waterEnterDaily;
implementation
{$R *.dfm}

uses waterTrack, dashboard;
//on clicking submit:
procedure Tform_waterEnterDaily.btn_submitClick(Sender: TObject);
var index: integer;
    isError: boolean;
begin
  isError:= validateDailyInput(1, edt_input.Text); //validate input
  if isError = FALSE then //if no errors
    begin
    mmo_comment.Show;  //show the comment
    index:= trunc(random); //generating a random number between 0 and 4
      case index of //motivating comments chosen at random
      0: mmo_comment.Text:= 'Keep going, '+currentUser+ '! Your body will thank you for it.';
      1: mmo_comment.Text:= 'It will take time and determination, '+currentUser+', but you will achieve your goal.';
      2: mmo_comment.Text:= 'You’re already halfway there to a new, healthier and happier you, ' + currentUser+'.';
      3: mmo_comment.Text:= 'A Sore today is a strong tomorrow, '+currentUser+'.';
      4: mmo_comment.Text:= 'A little progress each day adds up to big results, '+currentUser+'.';
      end;
    saveData('water', edt_input.Text); //saving the users input in the progress file
    updateFactorBMI; //updates factorBMI according to recent averages
    edt_input.ReadOnly:= TRUE;//make edit box read only
    btn_submit.Hide; //hiding submit button
    end;
end;
//changing combobox to change form:
procedure Tform_waterEnterDaily.cbo_selectViewChange(Sender: TObject);
begin
if cbo_selectView.itemIndex = 1 then //if choosing to view track page
  begin
  form_waterTrack.show;  //show tracking form
  form_waterEnterDaily.Hide; //hide current form
  end;
end;
//on creating form:
procedure Tform_waterEnterDaily.FormCreate(Sender: TObject);
begin
mmo_comment.Hide;  //hiding encouraging comment
mmo_comment.ReadOnly; //making encouraging comment read only
end;
//clicking 'back to dashboard':
procedure Tform_waterEnterDaily.lbl_backClick(Sender: TObject);
begin
form_waterEnterDaily.Hide; //hide current form
form_dashboard.show; //show dashboard
end;
//hovering over 'back to dashboard':
procedure Tform_waterEnterDaily.lbl_backMouseEnter(Sender: TObject);
begin
lbl_back.Font.Style:=[fsBold, fsUnderline]; //style bold and underlined
end;
//hovering off 'back to dashboard':
procedure Tform_waterEnterDaily.lbl_backMouseLeave(Sender: TObject);
begin
lbl_back.Font.Style:=[fsUnderline];  //style underlined
end;

end.
