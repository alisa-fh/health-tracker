unit sleepPlan;

interface

uses
  globalUnit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, system.math, enterData,
  Vcl.Imaging.pngimage;

type
  Tform_sleepPlan = class(TForm)
    pnl_sleep: TPanel;
    lbl_sleepGoal: TLabel;
    lbl_bmi: TLabel;
    lbl_displayBmi: TLabel;
    shp_displayBmi: TShape;
    mmo_desc: TMemo;
    lbl_slide: TLabel;
    tbr_hours: TTrackBar;
    mmo_trackbar: TMemo;
    mmo_etb: TMemo;
    btn_save: TButton;
    img_icon: TImage;
    lbl_back: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure tbr_hoursChange(Sender: TObject);
    procedure btn_saveClick(Sender: TObject);
    procedure lbl_backClick(Sender: TObject);
    procedure lbl_backMouseEnter(Sender: TObject);
    procedure lbl_backMouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_sleepPlan: Tform_sleepPlan;

implementation
{$R *.dfm}
uses dashboard;
//click save button
procedure Tform_sleepPlan.btn_saveClick(Sender: TObject);
begin
saveGoal('sleep', tbr_hours.Position); //parameters: factor, trackbar value
form_sleepPlan.Hide; //hides the current form
dashboardInitialisation; //reinitialises the dashboard
form_dashboard.Show; //shows dashboard
end;
//on creating form
procedure Tform_sleepPlan.FormCreate(Sender: TObject);
begin
mmo_desc.Text:='Having the correct amount of sleep is crucial for a happy and'+
              ' healthy lifestyle. The ideal length of sleep for a healthy adult'+
               ' is 8 hours per night.';   //description
mmo_trackbar.text:= inttostr(tbr_hours.Position) +' hours per day'; //outputs value on the trackbar

mmo_desc.ReadOnly:=true; //making the description box read only
mmo_etb.ReadOnly:= TRUE; //making the ETB box read only
mmo_trackbar.ReadOnly:= TRUE; //making the trackbar box read only

mmo_etb.Text:='Effect on BMI will be displayed here'; //displays effect on BMI
end;
//on clicking back to dashboard
procedure Tform_sleepPlan.lbl_backClick(Sender: TObject);
begin
form_dashboard.Show;//show dashboard
form_sleepPlan.Hide; //hide current form
end;
//hovering over back to dashboard
procedure Tform_sleepPlan.lbl_backMouseEnter(Sender: TObject);
begin
lbl_back.Font.Style:=[fsBold, fsUnderline]; //style bold and underlined
end;
//hovering off back to dashboard
procedure Tform_sleepPlan.lbl_backMouseLeave(Sender: TObject);
begin
lbl_back.Font.Style:=[fsUnderline]; //style underlined
end;
//changing trackbar value
procedure Tform_sleepPlan.tbr_hoursChange(Sender: TObject);
var difference:double;
begin
mmo_trackbar.Text:= inttostr(tbr_hours.Position) + #13#10 +' hours per day'; //outputs value on the trackbar
difference:= roundto(changeETB('sleep', tbr_hours.Position),-3); //returns the difference in BMI using the factor and trackbar position as parameters
if difference < 0 then //if negative
  mmo_etb.Text:= 'By sticking to this regime, your BMI could increase by ' + floattostr(roundto(difference*-1, -3))
else if difference > 0 then  //if positive
  mmo_etb.Text:= 'By sticking to this regime, your BMI could decrease by ' + floattostr(roundto(difference,-3))
else //if difference = 0
  mmo_etb.Text:= 'By sticking to this regime, your BMI is predicted to remain unchanged';
end;
end.

