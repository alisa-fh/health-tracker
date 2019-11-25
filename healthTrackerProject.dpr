program healthTrackerProject;

uses
  Vcl.Forms,
  Account in 'Account.pas' {form_acc},
  enterData in 'enterData.pas' {form_enterData},
  databases in 'databases.pas' {frm_dtb},
  globalUnit in 'globalUnit.pas',
  dashboard in 'dashboard.pas' {form_dashboard},
  sleepPlan in 'sleepPlan.pas' {form_sleepPlan},
  waterPlan in 'waterPlan.pas' {form_waterPlan},
  happiPlan in 'happiPlan.pas' {form_happiPlan},
  exercPlan in 'exercPlan.pas' {form_exercPlan},
  sleepTrack in 'sleepTrack.pas' {form_sleepTrack},
  waterTrack in 'waterTrack.pas' {form_waterTrack},
  happiTrack in 'happiTrack.pas' {form_happiTrack},
  exercTrack in 'exercTrack.pas' {form_exercTrack},
  sleepEnterDaily in 'sleepEnterDaily.pas' {form_sleepEnterDaily},
  exercEnterDaily in 'exercEnterDaily.pas' {form_exercEnterDaily},
  waterEnterDaily in 'waterEnterDaily.pas' {form_waterEnterDaily},
  happiEnterDaily in 'happiEnterDaily.pas' {Form_happiEnterDaily},
  bmiTrack in 'bmiTrack.pas' {form_bmiTrack},
  bmiEnterDaily in 'bmiEnterDaily.pas' {form_bmiEnterDaily},
  bmiCharts in 'bmiCharts.pas' {form_bmiCharts};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tform_acc, form_acc);
  Application.CreateForm(Tform_enterData, form_enterData);
  Application.CreateForm(Tfrm_dtb, frm_dtb);
  Application.CreateForm(Tform_dashboard, form_dashboard);
  Application.CreateForm(Tform_sleepPlan, form_sleepPlan);
  Application.CreateForm(Tform_waterPlan, form_waterPlan);
  Application.CreateForm(Tform_happiPlan, form_happiPlan);
  Application.CreateForm(Tform_exercPlan, form_exercPlan);
  Application.CreateForm(Tform_sleepTrack, form_sleepTrack);
  Application.CreateForm(Tform_waterTrack, form_waterTrack);
  Application.CreateForm(Tform_happiTrack, form_happiTrack);
  Application.CreateForm(Tform_exercTrack, form_exercTrack);
  Application.CreateForm(Tform_sleepEnterDaily, form_sleepEnterDaily);
  Application.CreateForm(Tform_exercEnterDaily, form_exercEnterDaily);
  Application.CreateForm(Tform_waterEnterDaily, form_waterEnterDaily);
  Application.CreateForm(TForm_happiEnterDaily, Form_happiEnterDaily);
  Application.CreateForm(Tform_bmiTrack, form_bmiTrack);
  Application.CreateForm(Tform_bmiEnterDaily, form_bmiEnterDaily);
  Application.CreateForm(Tform_bmiCharts, form_bmiCharts);
  Application.Run;
end.
