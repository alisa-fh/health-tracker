unit happiTrack;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXCalendars, Vcl.StdCtrls,
  Vcl.Grids, Vcl.ExtCtrls, Vcl.Imaging.pngimage, globalUnit,System.Math, happiEnterDaily;

type
  Tform_happiTrack = class(TForm)
    lbl_goal: TLabel;
    lbl_displaygoal: TLabel;
    shp_displayGoal: TShape;
    lbl_showdata: TLabel;
    lbl_showOneDay: TLabel;
    lbl_viewManyError: TLabel;
    img_qu: TImage;
    Panel1: TPanel;
    img_icon: TImage;
    lbl_happiTracker: TLabel;
    lbl_back: TLabel;
    cbo_selectView: TComboBox;
    cbo_days: TComboBox;
    stg_viewMany: TStringGrid;
    stg_viewOne: TStringGrid;
    mmo_help: TMemo;
    cdr_selectDate: TCalendarView;
    lbl_viewOneError: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cbo_selectViewChange(Sender: TObject);
    procedure cdr_selectDateChange(Sender: TObject);
    procedure cbo_daysChange(Sender: TObject);
    procedure img_quMouseEnter(Sender: TObject);
    procedure img_quMouseLeave(Sender: TObject);
    procedure lbl_backClick(Sender: TObject);
    procedure lbl_backMouseEnter(Sender: TObject);
    procedure lbl_backMouseLeave(Sender: TObject);
  private
  public
  end;
var
  form_happiTrack: Tform_happiTrack;

implementation
{$R *.dfm}

uses dashboard, sleepTrack;
//changing number of days combo box:
procedure Tform_happiTrack.cbo_daysChange(Sender: TObject);
var path, aDate, aValue: string;
    numdays, I, fileLength, row:integer;
    happiData: TStringList;
    recordsDisplayed: double;
begin
lbl_viewManyError.Hide; //hide error labels
lbl_viewOneError.Hide;
for I := 0 to 1 do
  stg_viewMany.Cols[I].Clear; //clearing contents of stringgrid
numDays:= cbo_days.ItemIndex +1; //number of days requested. +1 because indexing begins at 0
path:= currentDir + '\' + 'happiProgress.txt'; //happiProgress filepath
happiData:=TStringList.Create; //creating a stringList to hold all the data in happiProgress
  happiData.LoadFromFile(path); //loading the happiProgress data into stringList happiData
  fileLength:= happiData.Count; //number of records
  if (((fileLength)-1)/2)>= numDays then  //if the user has the requested number of entries
    begin
    i:= (fileLength+1)- numdays*2;  //pointer on the first record
    row:= 0; //initialising first row
    while I < fileLength do  //loop for each entry
     begin
     aDate:=happiData[I-1]; //assigning aDate from happiData
     stg_viewMany.Cells[0,row]:=aDate; //output date on stringgrid
     i:= i +1;  //increment array pointer
     aValue:= happiData[I-1]; //assigning aValue from happiData
     stg_viewMany.Cells[1,row]:= ('Rating: ' +aValue);  //output value on stringgrid
     i:=i+1;
     row:=row+1; //next stringgrid row
     end;
    happiData.Free; //free stringlist
    end
 else //if user doesnt have requested number of entries:
    begin
    lbl_viewManyError.Show; //show the error label
    recordsDisplayed:= 0.5*(fileLength-1); //the number of records recorded
    lbl_viewManyError.Caption:= 'You do not yet have '+inttostr(numdays)+' entries recorded.'+#13#10+' The last '+floattostr(recordsDisplayed) + ' values have been displayed' ; //the error message
    I:= 1; //initialising pointer to the first date
    row:= 0; //initialising string grid row
    WHILE I< fileLength-1 do //iteration for each record, until end of string list
      begin
      aDate:=happiData[I]; //assigning the date from string list
      stg_viewMany.Cells[0, row]:= aDate; //displaying the date
      I:= I + 1; //increment array pointer
      aValue:= happiData[I]; //assigning the value
      stg_viewMany.Cells[1, row]:= aValue; //displaying the value
      I:= I +1;
      row:= row+1; //next string grid row
      end;
    happiData.Free; //free string list
    end;
end;
//on changing combobox to change form:
procedure Tform_happiTrack.cbo_selectViewChange(Sender: TObject);
begin
if cbo_selectView.ItemIndex= 0 then  //if on option 'enter today's data'
  begin
  form_happiTrack.Hide; //hide the current form
  form_happiEnterDaily.show; //show the data entry form
  form_happiEnterDaily.lbl_displaygoal.Caption:= 'Rating: '+ getGoal('happi'); //display goal
  form_happiEnterDaily.lbl_date.Caption:= ' Todays date is ' + datetostr(date); //display date
  form_happiEnterDaily.lbl_displaybmi.caption:= floattostr(roundto(getBMI,-1)); //display BMI
  if isTodayRecorded('happi') = TRUE then  //if data has been recorded today
    begin
    form_happiEnterDaily.edt_input.ReadOnly:=TRUE; //make edit box read only
    form_happiEnterDaily.edt_input.Text:= 'Todays data has been recorded';  //display message
    form_happiEnterDaily.edt_input.Font.Style:=[fsBold]; //change font to bold
    form_happiEnterDaily.btn_submit.Hide; //hide the submit button
    end;
  end;
end;
//on changing calendar date:
procedure Tform_happiTrack.cdr_selectDateChange(Sender: TObject);
var happiData: TStringList;
    path: string;
    fileLength, index:integer;
begin
stg_viewOne.Rows[0].Clear; //clearing previous data from the grid
lbl_viewManyError.Hide; //hiding previous error messages
lbl_viewOneError.Hide;  //hiding previous error messages
path:= currentDir + '\' + 'happiProgress.txt'; //happiProgress filepath
happiData:=TStringList.Create; //creating a stringList to hold all the data in happiProgress
  happiData.LoadFromFile(path); //loading the happiProgress data into stringList happiData
  fileLength:= happiData.Count; //number of records
  index:= searchDate(happiData, cdr_selectDate.Date, 1, (fileLength-1)); //calling searchDate, returning the date's index
  if (index = -1) then  //date not found
    begin
    lbl_viewOneError.Show; //show error message
    lbl_viewOneError.Caption:= 'There is no data recorded for '+ #13#10+ datetostr(cdr_selectDate.Date)+'.'; //error message
    end
  else
    begin
     stg_viewOne.Cells[0,0]:= datetostr(cdr_selectDate.Date); //outputting date on grid
     stg_viewOne.Cells[1,0]:= 'rating: '+happiData[index+1]  ; //outputting the date's data
    end;
happiData.Free;//free stringlist
end;
//on creating the form:
procedure Tform_happiTrack.FormCreate(Sender: TObject);
begin
cbo_days.ItemHeight:= 0;  //setting default index
lbl_viewManyError.Hide; //hiding the error messages
lbl_viewOneError.Hide;
mmo_help.Hide; //hiding the help memo
end;
//on hovering over question bubble:
procedure Tform_happiTrack.img_quMouseEnter(Sender: TObject);
begin
mmo_help.show; //show help memo
mmo_help.Text:= 'Select a date from the calendar'; //text on help memo
end;
//on hovering off question bubble:
procedure Tform_happiTrack.img_quMouseLeave(Sender: TObject);
begin
mmo_help.hide; //hide help memo
end;
//on clicking 'back to dashboard':
procedure Tform_happiTrack.lbl_backClick(Sender: TObject);
begin
form_dashboard.show; //show dashboard
form_sleepTrack.Hide; //hide current form
end;
//on hovering over 'back to dashboard':
procedure Tform_happiTrack.lbl_backMouseEnter(Sender: TObject);
begin
lbl_back.Font.Style:=[fsBold, fsUnderline]; //style bold, underlined
end;
//on hovering off 'back to dashboard':
procedure Tform_happiTrack.lbl_backMouseLeave(Sender: TObject);
begin
lbl_back.Font.Style:=[fsUnderline]; //style underlined
end;
end.
