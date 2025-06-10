//base url
//https://movie-b.origin.com.mm/api
const String kBaseUrl = 'https://movie-b.origin.com.mm/api';

const String kEndPointLogin = "/auth/login";
const String kEndPointGoogleLogin = '/auth/customer/login/google-login';
const String kEndPointLogout = '/auth/logout';
const String kEndPointSendOtp = '/auth/customer/login/otp/send';
const String kEndPointVerifyOtp = '/auth/customer/login/otp/verify';

const String kEndPointMovie = '/videos/movies';
const String kEndPointSeries = '/videos/series';
const String kEndPointSeason = '/videos/seasons';
const String kEndPointEpisode = 'videos/episodes';
const String kEndPointHomeMovieAndSeries = '/videos/movies-series';
const String kEndPointCategory = '/videos/categories';
const String kEndPointGenre = '/videos/genres';
const String kEndPointCategoryGroup = '/videos/category-groups';
const String kEndPointRedeemCode = '/transactions/redeem-code';
const String kEndPointGift = '/transactions/gift-code-by-user';

const String kEndPointAds = '/cms/ads';
const String kEndPointBanner = '/cms/banners';

const String kEndPointUser = '/auth/me';
const String kEndPointDeleteUser = '/auth/me';
const String kEndPointFaq = '/contents/faqs';

const String kEndPointCast = '/videos/casts';
const String kEndPointPackage = '/packages/plans';

const String kEndPointViewCount = '/videos/view-counts';
const String kEndPointAnnouncement = '/announcements';

const String kEndPointWatchLists = '/watchlists';
const String kEndPointHistory = '/history';
const String kEndPointUpdateUser = '/auth/me';
const String kEndPointWatchlistToggle = '/watchlists/toggle';
const String kEndPointHistoryToggle = '/history/toggle';
const String kEndPointTermAndCondition =
    '/contents/legal-agreements/terms-and-conditions';
const String kEndPointPrivacyPolicy =
    '/contents/legal-agreements/privacy-and-policy';

const String kHeaderAuthorization = "Authorization";
const String kHeaderAcceptLanguage = "Accept-Language";
const String kHeaderContentType = "Content-Type";
