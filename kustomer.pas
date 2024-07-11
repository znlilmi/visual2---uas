unit kustomer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, QuickRpt, ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    edtNik: TEdit;
    btnSimpan: TButton;
    btnUbah: TButton;
    DBGrid: TDBGrid;
    btnHapus: TButton;
    btnBatal: TButton;
    edtNama: TEdit;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtTelp: TEdit;
    edtEmail: TEdit;
    edtAlamat: TEdit;
    LabelDiskon: TLabel;
    btnBaru: TButton;
    btnCetak: TButton;
    cbMember: TComboBox;
    procedure btnSimpanClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnUbahClick(Sender: TObject);
    procedure DBGridCellClick(Column: TColumn);
    procedure btnHapusClick(Sender: TObject);
    procedure btnBatalClick(Sender: TObject);
    procedure btnBaruClick(Sender: TObject);
    procedure cbMemberChange(Sender: TObject);
    procedure btnCetakClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  DataModule, Report;
  

{$R *.dfm}

procedure TForm1.btnSimpanClick(Sender: TObject);
begin
  if edtNik.Text = '' then
  begin
    ShowMessage('Nik Tidak Boleh Kosong!');
  end else
  if DataModule1.ZQuery1.Locate('nik', edtNik.Text, []) then
  begin
    ShowMessage('Nik ' + edtNik.Text + ' Sudah Ada Didalam Sistem');
  end else
  begin
    // Simpan
    with DataModule1.ZQuery1 do
    begin
      SQL.Clear;
      SQL.Add('insert into kustomer (nik, nama, telp, email, alamat, member) values(:nik, :nama, :telp, :email, :alamat, :member)');
      ParamByName('nik').AsString := edtNik.Text;
      ParamByName('nama').AsString := edtNama.Text;
      ParamByName('telp').AsString := edtTelp.Text;
      ParamByName('email').AsString := edtEmail.Text;
      ParamByName('alamat').AsString := edtAlamat.Text;
      ParamByName('member').AsString := cbMember.Text; // Assuming cbMember is a ComboBox
      ExecSQL;
      SQL.Clear;
      SQL.Add('select * from kustomer');
      Open;
    end;
    ShowMessage('Data Berhasil Disimpan!');

    // Nonaktifkan kembali komponen input dan tombol SIMPAN setelah data disimpan
    edtNik.Enabled := False;
    edtNama.Enabled := False;
    edtTelp.Enabled := False;
    edtEmail.Enabled := False;
    edtAlamat.Enabled := False;
    cbMember.Enabled := False;
    btnSimpan.Enabled := False;
    btnUbah.Enabled := False;
    btnHapus.Enabled := False;
    btnBatal.Enabled := False;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Nonaktifkan komponen input dan tombol SIMPAN pada awal form diinisialisasi
  edtNik.Enabled := False;
  edtNama.Enabled := False;
  edtTelp.Enabled := False;
  edtEmail.Enabled := False;
  edtAlamat.Enabled := False;
  cbMember.Enabled := False;
  btnSimpan.Enabled := False;
  btnUbah.Enabled := False;
  btnHapus.Enabled := False;
  btnBatal.Enabled := False;

  // Isi ComboBox dengan opsi 'yes' dan 'no'
  cbMember.Items.Clear;
  cbMember.Items.Add('yes');
  cbMember.Items.Add('no');
  cbMember.ItemIndex := -1; // Pilih default 'yes'

  // Tambahkan event handler untuk ComboBox cbMember
  cbMember.OnChange := cbMemberChange;
end;

procedure TForm1.btnUbahClick(Sender: TObject);
begin
  if edtNik.Text = '' then
  begin
    ShowMessage('Nik Tidak Boleh Kosong!');
  end
  else if not DataModule1.ZQuery1.Locate('nik', edtNik.Text, []) then
  begin
    ShowMessage('Nik ' + edtNik.Text + ' Tidak Ditemukan Dalam Sistem');
  end
  else
  begin
    // Ubah
    with DataModule1.ZQuery1 do
    begin
      SQL.Clear;
      SQL.Add('update kustomer set nama = :nama, telp = :telp, email = :email, alamat = :alamat, member = :member  where nik = :nik');
      ParamByName('nik').AsString := edtNik.Text;
      ParamByName('nama').AsString := edtNama.Text;
      ParamByName('telp').AsString := edtTelp.Text;
      ParamByName('email').AsString := edtEmail.Text;
      ParamByName('alamat').AsString := edtAlamat.Text;
      ParamByName('member').AsString := cbMember.Text; // Assuming cbMember is a ComboBox
      ExecSQL;
      SQL.Clear;
      SQL.Add('select * from kustomer');
      Open;
    end;
    ShowMessage('Data Berhasil Disimpan!');
  end;
end;

procedure TForm1.DBGridCellClick(Column: TColumn);
begin
  edtNik.Text := DataModule1.ZQuery1.FieldByName('nik').AsString;
  edtNama.Text := DataModule1.ZQuery1.FieldByName('nama').AsString;
  edtTelp.Text := DataModule1.ZQuery1.FieldByName('telp').AsString;
  edtEmail.Text := DataModule1.ZQuery1.FieldByName('email').AsString;
  edtAlamat.Text := DataModule1.ZQuery1.FieldByName('alamat').AsString;
  cbMember.Text := DataModule1.ZQuery1.FieldByName('member').AsString;

  // Update LabelDiskon berdasarkan nilai cbMember yang baru
  cbMemberChange(nil); // Panggil cbMemberChange untuk mengupdate LabelDiskon

  edtNik.Enabled := True;
  edtNama.Enabled := True;
  edtTelp.Enabled := True;
  edtEmail.Enabled := True;
  edtAlamat.Enabled := True;
  cbMember.Enabled := True;

  btnSimpan.Enabled := False;
  btnUbah.Enabled := True;
  btnHapus.Enabled := True;
  btnBatal.Enabled := True;
end;

procedure TForm1.btnHapusClick(Sender: TObject);
begin
  if edtNik.Text = '' then
  begin
    ShowMessage('Nik Tidak Boleh Kosong!');
  end
  else if not DataModule1.ZQuery1.Locate('nik', edtNik.Text, []) then
  begin
    ShowMessage('Nik ' + edtNik.Text + ' Tidak Ditemukan Dalam Sistem');
  end
  else
  begin
    // Delete data
    with DataModule1.ZQuery1 do
    begin
      SQL.Clear;
      SQL.Add('delete from kustomer where nik = :nik');
      ParamByName('nik').AsString := edtNik.Text;
      ExecSQL;
      SQL.Clear;
      SQL.Add('select * from kustomer');
      Open;
    end;
    ShowMessage('Data Berhasil Dihapus!');

    // Kosongkan semua field input
    edtNik.Text := '';
    edtNama.Text := '';
    edtTelp.Text := '';
    edtEmail.Text := '';
    edtAlamat.Text := '';
    cbMember.ItemIndex := -1;

    // Nonaktifkan komponen input dan tombol yang tidak diperlukan
    edtNik.Enabled := False;
    edtNama.Enabled := False;
    edtTelp.Enabled := False;
    edtEmail.Enabled := False;
    edtAlamat.Enabled := False;
    cbMember.Enabled := False;
    btnSimpan.Enabled := False;
    btnUbah.Enabled := False;
    btnHapus.Enabled := False;
    btnBatal.Enabled := False;
  end;
end;

procedure TForm1.btnBatalClick(Sender: TObject);
begin
  edtNik.Text := '';
  edtNama.Text := '';
  edtTelp.Text := '';
  edtEmail.Text := '';
  edtAlamat.Text := '';
  cbMember.Text := '';
end;

procedure TForm1.btnBaruClick(Sender: TObject);
begin
  // Aktifkan komponen input
  edtNik.Enabled := True;
  edtNama.Enabled := True;
  edtTelp.Enabled := True;
  edtEmail.Enabled := True;
  edtAlamat.Enabled := True;
  cbMember.Enabled := True;

  // Aktifkan tombol SIMPAN dan tombol lain yang diperlukan
  btnSimpan.Enabled := True;
  btnUbah.Enabled := False;
  btnHapus.Enabled := False;
  btnBatal.Enabled := True;

  // Kosongkan semua field input untuk input baru
  edtNik.Text := '';
  edtNama.Text := '';
  edtTelp.Text := '';
  edtEmail.Text := '';
  edtAlamat.Text := '';
  cbMember.ItemIndex := 0; // Pilih default 'yes'

  edtNik.SetFocus; // Set focus ke input Nik
end;

procedure TForm1.cbMemberChange(Sender: TObject);
begin
  if cbMember.Text = 'yes' then
    LabelDiskon.Caption := 'DISKON : 10%'
  else if cbMember.Text = 'no' then
    LabelDiskon.Caption := 'DISKON : 5%';
end;


procedure TForm1.btnCetakClick(Sender: TObject);
begin
  Form2.QuickRep1.Preview;
end;

end.
