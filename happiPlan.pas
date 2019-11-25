unit happiPlan;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, globalUnit, enterData, system.math;

type
  Tform_happiPlan = class(TForm)
    lbl_slide: TLabel;
    pnl_happi: TPanel;
    lbl_happiGoal: TLabel;
    lbl_bmi: TLabel;
    lbl_displayBmi: TLabel;
    shp_displayBmi: TShape;
    img_icon: TImage;
    lbl_back: TLabel;
    mmo_desc: TMemo;
    tbr_rating: TTrackBar;
    mmo_trackbar: TMemo;
    mmo_etb: TMemo;
    btn_save: TButton;
    procedure lbl_backClick(Sender: TObject);
    procedure btn_saveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbl_backMouseEnter(Sender: TObject);
    procedure lbl_backMouseLeave(Sender: TObject);
    procedure tbr_ratingChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_happiPlan: Tform_happiPlan;

implementation

{$R *.dfm}

uses dashboard;

procedure Tform_happiPlan.btn_saveClick(Sender: TObject);
begin
saveGoal('happi', tbr_rating.Position); //parameters: factor, trackbar value
form_happiPlan.Hide; //hides the current form
dashboardInitialisation; //reinitialises the dashboard
form_dashboard.Show; //shows dashboard
end;

procedure Tform_happiPlan.FormCreate(Sender: TObject);
begin
mmo_desc.Text:='Remaining happy and minimising stress is important for your wellbeing. '+
                'There are several ways through which you can improve your mental state. ' +
                'For instance: helping others, meditation and focussing on positive thoughts.';   //description
mmo_trackbar.text:= 'Aim for a happiness rating of '+inttostr(tbr_rating.Position); //outputs value on the trackbar

mmo_desc.ReadOnly:=true; //making the description box read only
mmo_etb.ReadOnly:= TRUE; //making the ETB box read only
mmo_trackbar.ReadOnly:= TRUE; //making the trackbar box read only

mmo_etb.Text:='Effect on BMI will be displayed here'; //displays effect on BMI
end;

procedure Tform_happiPlan.lbl_backClick(Sender: TObject); //clicking on lbl_back
begin
form_dashboard.Show; //showing dashboard
form_happiPlan.Hide; //hiding form_happiPlan
end;

procedure Tform_happiPlan.lbl_backMouseEnter(Sender: TObject); //hovering over lbl_back
begin
lbl_back.Font.Style:=[fsBold, fsUnderline]; //font is bold and underlined
end;

procedure Tform_happiPlan.lbl_backMouseLeave(Sender: TObject); //mouse stops hovering over lbl_back
begin
lbl_back.Font.Style:=[fsUnderline]; //font is underlined
end;





procedure Tform_happiPlan.tbr_ratingChange(Sender: TObject);
var difference:double;
begin
mmo_trackbar.Text:= 'Happiness rating of ' + inttostr(tbr_rating.Position); //outputs value on the trackbar
difference:= roundto(changeETB('happi', tbr_rating.Position),-3); //returns the difference in BMI using the factor and trackbar position as parameters
if difference < 0 then //if negative
  mmo_etb.Text:= 'By achieving this consistently, your BMI could increase by ' + floattostr(roundto(difference*-1, -3))
else if difference > 0 then  //if positive
  mmo_etb.Text:= 'By achieving this consistently, your BMI could decrease by ' + floattostr(roundto(difference,-3))
else //if difference = 0
  mmo_etb.Text:= 'By achieving this consistently, your BMI is predicted to remain unchanged';
end;

end.
