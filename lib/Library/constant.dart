library constant;

const String _host = "https://api.bravosolutionindonesia.com";
const String _apiserver = "$_host/v1";

// TEST SERVER
const String TEST = '$_apiserver/test';

// PROFIL
const String PROFILAPP = '$_apiserver/get_profil_app';
const String TOKEN = '$_apiserver/post_token';
const String TOKENATASAN = '$_apiserver/get_token_atasan';

// REST
const String AUTH = '$_apiserver/check_auth';
const String PROFIL = '$_apiserver/get_profil';
const String SETTING = '$_apiserver/get_setting';
const String ABSEN = '$_apiserver/post_absen';
const String ABSENSHIF = '$_apiserver/post_absen_shif';
const String ABSENAPEL = '$_apiserver/post_absen_apel';
const String IJINABSEN = '$_apiserver/post_ijin_absen';
const String GETIJIN = '$_apiserver/get_ijin';
const String GETIJINKET = '$_apiserver/get_ijin_ket';
const String POSTIJINPENGAJUAN = '$_apiserver/post_ijin_pengajuan';
const String DELETEIJINPENGAJUAN = '$_apiserver/delete_ijin_pengajuan';
const String REJECTIJINPENGAJUAN = '$_apiserver/reject_ijin_pengajuan';
const String APPROVEIJINPENGAJUAN = '$_apiserver/approve_ijin_pengajuan';
const String POSTABSENDINAS = '$_apiserver/post_absen_dinas';
const String GETDATAKEHADIRAN = '$_apiserver/get_data_kehadiran';
const String GETDATAAPEL = '$_apiserver/get_data_apel';
const String GETAGENDA = '$_apiserver/get_agenda';
const String POSTAGENDA = '$_apiserver/post_agenda';
const String DELETEAGENDA = '$_apiserver/delete_agenda';
const String UPDATEPOSPEGAWAI = '$_apiserver/update_posisi_pegawai';
const String UPDATEPROFILPEGAWAI = '$_apiserver/update_profil_pegawai';
const String GETDATAABSEN = '$_apiserver/get_data_absen';

// IMAGES
const String IMG_PEGAWAI = '$_host/e-absen/images/pegawai/';