import 'package:flutter/material.dart';

///Here we save any constants we might need for HAPIS tablet app
///
/// * We have a class [HapisColors] for saving the default colors for our app
/// * [earthRadius] property for defining earth radius for orbit functionality
class HapisColors {
  static const Color primary = Color(0xFF90CCF5);
  static const Color accent = Color.fromARGB(255, 255, 255, 255);
  static const Color background = Color(0xFFF0F0F0);
  static const Color secondary = Color.fromARGB(255, 62, 141, 76);
  static const Color lgColor1 = Color(0xFF537DC0);
  static const Color lgColor2 = Color(0xFFE54E3E);
  static const Color lgColor3 = Color(0xFFF6B915);
  static const Color lgColor4 = Color(0xFF4CB15F);
}

/// saving the [earthRadius] average radius of earth in meteres
const double earthRadius = 6371000; // Average radius of the Earth in meters

///Dimensions for responsive property
const mobileWidth = 770;
const tabletWidth = 1280;

///For drop down List of Donation form
final List<String> categoryList = [
  'Clothing',
  'Household',
  'Books and Media',
  'Toys and Games',
  'Sports Equipment',
  'Baby item',
  'Hygiene Products',
  'Medical Supplies',
  'Pet supplies',
  'Food',
  'Electronics'
];
//final List<String> statusList = ['Not Completed', 'Completed'];
final List<String> forWhoList = ['self', 'other'];
final List<String> typeList = ['giver', 'seeker', 'both'];

/// Mapping each country and its corresponding flag image from the assets folder in [countryMap]
const countryMap = {
  'Albania': 'assets/flags/albania--3591-512.png',
  'Algeria': 'assets/flags/algeria--3635-512.png',
  'American Samoa': 'assets/flags/american-samoa--3519-512.png',
  'Andorra': 'assets/flags/andorra--3537-512.png',
  'Aland Islands': 'assets/flags/aland-islands--3579-512.png',
  'Angola': 'assets/flags/angola--3609-512.png',
  'Anguilla': 'assets/flags/anguilla--3517-512.png',
  'Antigua and Barbuda': 'assets/flags/antigua-and-barbuda--3567-512.png',
  'Argentina': 'assets/flags/argentina--3689-512.png',
  'Armenia': 'assets/flags/armenia--3600-512.png',
  'Aruba': 'assets/flags/aruba--3534-512.png',
  'Australia': 'assets/flags/australia--3726-512.png',
  'Austria': 'assets/flags/austria--3495-512.png',
  'Azerbaijan': 'assets/flags/azerbaijan--3632-512.png',
  'Azores Islands': 'assets/flags/azores-islands--3732-512.png',
  'Bahamas': 'assets/flags/bahamas--3612-512.png',
  'Bahrain': 'assets/flags/bahrain--3629-512.png',
  'Balearic Islands': 'assets/flags/balearic-islands--3594-512.png',
  'Bangladesh': 'assets/flags/bangladesh--3638-512.png',
  'Barbados': 'assets/flags/barbados--3576-512.png',
  'Basque': 'assets/flags/basque--3585-512.png',
  'Belarus': 'assets/flags/belarus--3626-512.png',
  'Belgium': 'assets/flags/belgium--3656-512.png',
  'Belize': 'assets/flags/belize--3570-512.png',
  'Benin': 'assets/flags/benin--3552-512.png',
  'Bermuda': 'assets/flags/bermuda--3573-512.png',
  'Bhutan': 'assets/flags/bhutan--3532-512.png',
  'Bolivia': 'assets/flags/bolivia--3641-512.png',
  'Bonaire': 'assets/flags/bonaire--3564-512.png',
  'Bosnia and Herzegovina': 'assets/flags/bosnia-and-herzegovina--3623-512.png',
  'Botswana': 'assets/flags/botswana--3617-512.png',
  'Brazil': 'assets/flags/brazil--3747-512.png',
  'British Columbia': 'assets/flags/british-columbia--3614-512.png',
  'British Indian Ocean Territory':
      'assets/flags/british-indian-ocean-territory--3561-512.png',
  'British Virgin Islands': 'assets/flags/british-virgin-islands--3606-512.png',
  'Brunei': 'assets/flags/brunei--3611-512.png',
  'Bulgaria': 'assets/flags/bulgaria--3659-512.png',
  'Burkina Faso': 'assets/flags/burkina-faso--3582-512.png',
  'Burundi': 'assets/flags/burundi--3549-512.png',
  'Cambodia': 'assets/flags/cambodia--3650-512.png',
  'Cameroon': 'assets/flags/cameroon--3597-512.png',
  'Canada': 'assets/flags/canada--3735-512.png',
  'Canary Islands': 'assets/flags/canary-islands--3546-512.png',
  'Cape Verde': 'assets/flags/cape-verde--3530-512.png',
  'Cayman Islands': 'assets/flags/cayman-islands--3543-512.png',
  'Central African Republic':
      'assets/flags/central-african-republic--3528-512.png',
  'Ceuta': 'assets/flags/ceuta--3511-512.png',
  'Chad': 'assets/flags/chad--3558-512.png',
  'Chile': 'assets/flags/chile--3622-512.png',
  'China': 'assets/flags/china--3526-512.png',
  'Christmas Island': 'assets/flags/christmas-island--3509-512.png',
  'Cocos Island': 'assets/flags/cocos-island--3515-512.png',
  'Colombia': 'assets/flags/colombia--3668-512.png',
  'Comoros': 'assets/flags/comoros--3521-512.png',
  'Cook Islands': 'assets/flags/cook-islands--3513-512.png',
  'Corsica': 'assets/flags/corsica--3523-512.png',
  'Costa Rica': 'assets/flags/costa-rica--3647-512.png',
  'Croatia': 'assets/flags/croatia--3655-512.png',
  'Cuba': 'assets/flags/cuba--3644-512.png',
  'Curacao': 'assets/flags/curacao--3608-512.png',
  'Czech Republic': 'assets/flags/czech-republic--3640-512.png',
  'Democratic Republic of Congo':
      'assets/flags/democratic-republic-of-congo--3741-512.png',
  'Denmark': 'assets/flags/denmark--3665-512.png',
  'Djibouti': 'assets/flags/djibouti--3560-512.png',
  'Dominica': 'assets/flags/dominica--3677-512.png',
  'Dominican Republic': 'assets/flags/dominican-republic--3539-512.png',
  'East Timor': 'assets/flags/east-timor--3631-512.png',
  'Ecuador': 'assets/flags/ecuador--3596-512.png',
  'Egypt': 'assets/flags/egypt--3649-512.png',
  'El Salvador': 'assets/flags/el-salvador--3507-512.png',
  'England': 'assets/flags/england--3707-512.png',
  'Equatorial Guinea': 'assets/flags/equatorial-guinea--3680-512.png',
  'Eritrea': 'assets/flags/eritrea--3557-512.png',
  'Estonia': 'assets/flags/estonia--3500-512.png',
  'Ethiopia': 'assets/flags/ethiopia--3497-512.png',
  'European Union': 'assets/flags/european-union--3751-512.png',
  'Falkland Islands': 'assets/flags/falkland-islands--3706-512.png',
  'Fiji': 'assets/flags/fiji--3628-512.png',
  'Finland': 'assets/flags/finland--3616-512.png',
  'France': 'assets/flags/france--3686-512.png',
  'French Polynesia': 'assets/flags/french-polynesia--3671-512.png',
  'Gabon': 'assets/flags/gabon--3551-512.png',
  'Galapagos Islands': 'assets/flags/galapagos-islands--3662-512.png',
  'Gambia': 'assets/flags/gambia--3637-512.png',
  'Georgia': 'assets/flags/georgia--3748-512.png',
  'Germany': 'assets/flags/germany--3653-512.png',
  'Ghana': 'assets/flags/ghana--3545-512.png',
  'Gibraltar': 'assets/flags/gibraltar--3704-512.png',
  'Greece': 'assets/flags/greece--3661-512.png',
  'Greenland': 'assets/flags/greenland--3605-512.png',
  'Grenada': 'assets/flags/grenada--3701-512.png',
  'Guam': 'assets/flags/guam--3698-512.png',
  'Guatemala': 'assets/flags/guatemala--3590-512.png',
  'Guernsey': 'assets/flags/guernsey--3695-512.png',
  'Guinea': 'assets/flags/guinea--3602-512.png',
  'Guinea-Bissau': 'assets/flags/guinea-bissau--3548-512.png',
  'Haiti': 'assets/flags/haiti--3676-512.png',
  'Hawaii': 'assets/flags/hawaii--3754-512.png',
  'Honduras': 'assets/flags/honduras--3516-512.png',
  'Hong Kong': 'assets/flags/hong-kong--3674-512.png',
  'Hungary': 'assets/flags/hungary--3607-512.png',
  'Iceland': 'assets/flags/iceland--3572-512.png',
  'India': 'assets/flags/india--3738-512.png',
  'Indonesia': 'assets/flags/indonesia--3700-512.png',
  'Iran': 'assets/flags/iran--3494-512.png',
  'Iraq': 'assets/flags/iraq--3512-512.png',
  'Ireland': 'assets/flags/ireland--3670-512.png',
  'Isle of Man': 'assets/flags/isle-of-man--3710-512.png',
  'Italy': 'assets/flags/italy--3505-512.png',
  'Ivory Coast': 'assets/flags/ivory-coast--3652-512.png',
  'Jamaica': 'assets/flags/jamaica--3529-512.png',
  'Japan': 'assets/flags/japan--3555-512.png',
  'Jersey': 'assets/flags/jersey--3737-512.png',
  'Jordan': 'assets/flags/jordan--3569-512.png',
  'Kazakhstan': 'assets/flags/kazakhstan--3566-512.png',
  'Kenya': 'assets/flags/kenya--3559-512.png',
  'Kiribati': 'assets/flags/kiribati--3753-512.png',
  'Kosovo': 'assets/flags/kosovo--3544-512.png',
  'Kuwait': 'assets/flags/kwait--3599-512.png',
  'Kyrgyzstan': 'assets/flags/kyrgyzstan--3643-512.png',
  'Laos': 'assets/flags/laos--3604-512.png',
  'Latvia': 'assets/flags/latvia--3536-512.png',
  'Lebanon': 'assets/flags/lebanon--3510-512.png',
  'Lesotho': 'assets/flags/lesotho--3667-512.png',
  'Liberia': 'assets/flags/liberia--3660-512.png',
  'Libya': 'assets/flags/libya--3723-512.png',
  'Liechtenstein': 'assets/flags/liechtenstein--3625-512.png',
  'Lithuania': 'assets/flags/lithuania--3556-512.png',
  'Luxembourg': 'assets/flags/luxembourg--3527-512.png',
  'Macao': 'assets/flags/macao--3658-512.png',
  'Madagascar': 'assets/flags/madagascar--3734-512.png',
  'Madeira': 'assets/flags/madeira--3639-512.png',
  'Malaysia': 'assets/flags/malasya--3610-512.png',
  'Malawi': 'assets/flags/malawi--3705-512.png',
  'Maldives': 'assets/flags/maldives--3717-512.png',
  'Mali': 'assets/flags/mali--3664-512.png',
  'Malta': 'assets/flags/malta--3685-512.png',
  'Marshall Islands': 'assets/flags/marshall-island--3595-512.png',
  'Martinique': 'assets/flags/martinique--3692-512.png',
  'Mauritania': 'assets/flags/mauritania--3542-512.png',
  'Mauritius': 'assets/flags/mauritius--3627-512.png',
  'Melilla': 'assets/flags/melilla--3688-512.png',
  'Mexico': 'assets/flags/mexico--3744-512.png',
  'Micronesia': 'assets/flags/micronesia--3538-512.png',
  'Moldova': 'assets/flags/moldova--3703-512.png',
  'Monaco': 'assets/flags/monaco--3531-512.png',
  'Mongolia': 'assets/flags/mongolia--3750-512.png',
  'Montenegro': 'assets/flags/montenegro--3731-512.png',
  'Montserrat': 'assets/flags/montserrat--3535-512.png',
  'Morocco': 'assets/flags/morocco--3657-512.png',
  'Mozambique': 'assets/flags/mozambique--3588-512.png',
  'Myanmar': 'assets/flags/myanmar--3550-512.png',
  'Namibia': 'assets/flags/namibia--3554-512.png',
  'NATO': 'assets/flags/nato--3746-512.png',
  'Nauru': 'assets/flags/nauru--3720-512.png',
  'Nepal': 'assets/flags/nepal--3508-512.png',
  'Netherlands': 'assets/flags/netherlands--3729-512.png',
  'New Zealand': 'assets/flags/new-zealand--3613-512.png',
  'Nicaragua': 'assets/flags/nicaragua--3499-512.png',
  'Niger': 'assets/flags/niger--3713-512.png',
  'Nigeria': 'assets/flags/nigeria--3578-512.png',
  'Niue': 'assets/flags/niue--3673-512.png',
  'Norfolk Island': 'assets/flags/norfolk-island--3684-512.png',
  'Northern Cyprus': 'assets/flags/northern-cyprus--3593-512.png',
  'Northern Mariana Islands':
      'assets/flags/northern-marianas-islands--3651-512.png',
  'North Korea': 'assets/flags/north-korea--3522-512.png',
  'Norway': 'assets/flags/norway--3634-512.png',
  'Oman': 'assets/flags/oman--3496-512.png',
  'Ossetia': 'assets/flags/ossetia--3620-512.png',
  'Pakistan': 'assets/flags/pakistan--3592-512.png',
  'Palau': 'assets/flags/palau--3669-512.png',
  'Palestine': 'assets/flags/palestine--3699-512.png',
  'Panama': 'assets/flags/panama--3598-512.png',
  'Papua New Guinea': 'assets/flags/papua-new-guinea--3654-512.png',
  'Paraguay': 'assets/flags/paraguay--3533-512.png',
  'Peru': 'assets/flags/peru--3679-512.png',
  'Philippines': 'assets/flags/philippines--3683-512.png',
  'Pitcairn Islands': 'assets/flags/pitcairn-islands--3587-512.png',
  'Poland': 'assets/flags/poland--3702-512.png',
  'Portugal': 'assets/flags/portugal--3716-512.png',
  'Puerto Rico': 'assets/flags/puerto-rico--3520-512.png',
  'Qatar': 'assets/flags/qatar--3518-512.png',
  'Rapa Nui': 'assets/flags/rapa-nui--3666-512.png',
  'Republic of Macedonia': 'assets/flags/republic-of-macedonia--3728-512.png',
  'Republic of the Congo': 'assets/flags/republic-of-the-congo--3648-512.png',
  'Romania': 'assets/flags/romania--3601-512.png',
  'Russia': 'assets/flags/russia--3740-512.png',
  'Rwanda': 'assets/flags/rwanda--3697-512.png',
  'Saba Island': 'assets/flags/saba-island--3553-512.png',
  'Sahrawi Arab Democratic Republic':
      'assets/flags/sahrawi-arab-democratic-republic--3694-512.png',
  'Saint Kitts and Nevis': 'assets/flags/saint-kitts-and-nevis--3525-512.png',
  'Samoa': 'assets/flags/samoa--3743-512.png',
  'San Marino': 'assets/flags/san-marino--3589-512.png',
  'Sao Tome and Principe': 'assets/flags/sao-tome-and-prince--3504-512.png',
  'Sardinia': 'assets/flags/sardinia--3749-512.png',
  'Saudi Arabia': 'assets/flags/saudi-arabia--3624-512.png',
  'Scotland': 'assets/flags/scotland--3547-512.png',
  'Senegal': 'assets/flags/senegal--3719-512.png',
  'Serbia': 'assets/flags/serbia--3563-512.png',
  'Seychelles': 'assets/flags/seychelles--3745-512.png',
  'Sicily': 'assets/flags/sicily--3621-512.png',
  'Sierra Leone': 'assets/flags/sierra-leone--3584-512.png',
  'Singapore': 'assets/flags/singapore--3722-512.png',
  'Sint Eustatius': 'assets/flags/sint-eustatius--3742-512.png',
  'Sint Maarten': 'assets/flags/sint-maarten--3581-512.png',
  'Slovakia': 'assets/flags/slovakia--3583-512.png',
  'Slovenia': 'assets/flags/slovenia--3502-512.png',
  'Solomon Islands': 'assets/flags/solomon-islands--3577-512.png',
  'Somalia': 'assets/flags/somalia--3575-512.png',
  'Somaliland': 'assets/flags/somaliland--3739-512.png',
  'South Africa': 'assets/flags/south-africa--3691-512.png',
  'South Korea': 'assets/flags/south-korea--3586-512.png',
  'South Sudan': 'assets/flags/south-sudan--3736-512.png',
  'Spain': 'assets/flags/spain--3619-512.png',
  'Sri Lanka': 'assets/flags/sri-lanka--3618-512.png',
  'St. Barts': 'assets/flags/st-barts--3571-512.png',
  'St. Lucia': 'assets/flags/st-lucia--3663-512.png',
  'St. Vincent and the Grenadines':
      'assets/flags/st-vincent-and-the-grenadines--3733-512.png',
  'Sudan': 'assets/flags/sudan--3690-512.png',
  'Suriname': 'assets/flags/suriname--3568-512.png',
  'Swaziland': 'assets/flags/swaziland--3645-512.png',
  'Sweden': 'assets/flags/sweden--3675-512.png',
  'Switzerland': 'assets/flags/switzerland--3696-512.png',
  'Syria': 'assets/flags/syria--3514-512.png',
  'Taiwan': 'assets/flags/taiwan--3693-512.png',
  'Tajikistan': 'assets/flags/tajikistan--3687-512.png',
  'Tanzania': 'assets/flags/tanzania--3498-512.png',
  'Thailand': 'assets/flags/thailand--3730-512.png',
  'Tibet': 'assets/flags/tibet--3633-512.png',
  'Togo': 'assets/flags/togo--3565-512.png',
  'Tokelau': 'assets/flags/tokelau--3727-512.png',
  'Tonga': 'assets/flags/tonga--3682-512.png',
  'Transnistria': 'assets/flags/transnistria--3725-512.png',
  'Trinidad and Tobago': 'assets/flags/trinidad-and-tobago--3672-512.png',
  'Tunisia': 'assets/flags/tunisia--3541-512.png',
  'Turkey': 'assets/flags/turkey--3709-512.png',
  'Turkmenistan': 'assets/flags/turkmenistan--3721-512.png',
  'Turks and Caicos': 'assets/flags/turks-and-caicos--3715-512.png',
  'Tuvalu': 'assets/flags/tuvalu--3562-512.png',
  'Uganda': 'assets/flags/uganda--3501-512.png',
  'Ukraine': 'assets/flags/ukraine--3636-512.png',
  'United Arab Emirates': 'assets/flags/united-arab-emirates--3642-512.png',
  'United Kingdom': 'assets/flags/united-kingdom--3752-512.png',
  'United Nations': 'assets/flags/united-nations--3574-512.png',
  'United States': 'assets/flags/united-states--3718-512.png',
  'Uruguay': 'assets/flags/uruguay--3580-512.png',
  'Uzbekistan': 'assets/flags/uzbekistn--3681-512.png',
  'Vanuatu': 'assets/flags/vanuatu--3678-512.png',
  'Vatican City': 'assets/flags/vatican-city--3615-512.png',
  'Venezuela': 'assets/flags/venezuela--3630-512.png',
  'Vietnam': 'assets/flags/vietnam--3711-512.png',
  'Virgin Islands': 'assets/flags/virgin-islands--3708-512.png',
  'Wales': 'assets/flags/wales--3506-512.png',
  'Yemen': 'assets/flags/yemen--3724-512.png',
  'Zambia': 'assets/flags/zambia--3524-512.png',
  'Zimbabwe': 'assets/flags/zimbabwe--3503-512.png',
  'Abkhazia': 'assets/flags/abkhazia--3540-512.png',
  'Afghanistan': 'assets/flags/afghanistan--3603-512.png'
};

/*
for drop down list in mobile app:
Afghanistan
Albania
Algeria
Andorra
Angola
Antigua and Barbuda
Argentina
Armenia
Australia
Austria
Azerbaijan
Bahamas
Bahrain
Bangladesh
Barbados
Belarus
Belgium
Belize
Benin
Bhutan
Bolivia
Bosnia and Herzegovina
Botswana
Brazil
Brunei
Bulgaria
Burkina Faso
Burundi
Cabo Verde
Cambodia
Cameroon
Canada
Central African Republic
Chad
Chile
China
Colombia
Comoros
Congo
Costa Rica
Croatia
Cuba
Cyprus
Czech Republic
Denmark
Djibouti
Dominica
Dominican Republic
East Timor
Ecuador
Egypt
El Salvador
Equatorial Guinea
Eritrea
Estonia
Eswatini
Ethiopia
Fiji
Finland
France
Gabon
Gambia
Georgia
Germany
Ghana
Greece
Grenada
Guatemala
Guinea
Guinea-Bissau
Guyana
Haiti
Honduras
Hungary
Iceland
India
Indonesia
Iran
Iraq
Ireland
Israel
Italy
Jamaica
Japan
Jordan
Kazakhstan
Kenya
Kiribati
Korea, North
Korea, South
Kosovo
Kuwait
Kyrgyzstan
Laos
Latvia
Lebanon
Lesotho
Liberia
Libya
Liechtenstein
Lithuania
Luxembourg
Madagascar
Malawi
Malaysia
Maldives
Mali
Malta
Marshall Islands
Mauritania
Mauritius
Mexico
Micronesia
Moldova
Monaco
Mongolia
Montenegro
Morocco
Mozambique
Myanmar
Namibia
Nauru
Nepal
Netherlands
New Zealand
Nicaragua
Niger
Nigeria
North Macedonia
Norway
Oman
Pakistan
Palau
Panama
Papua New Guinea
Paraguay
Peru
Philippines
Poland
Portugal
Qatar
Romania
Russia
Rwanda
Saint Kitts and Nevis
Saint Lucia
Saint Vincent and the Grenadines
Samoa
San Marino
Sao Tome and Principe
Saudi Arabia
Senegal
Serbia
Seychelles
Sierra Leone
Singapore
Slovakia
Slovenia
Solomon Islands
Somalia
South Africa
South Sudan
Spain
Sri Lanka
Sudan
Suriname
Sweden
Switzerland
Syria
Taiwan
Tajikistan
Tanzania
Thailand
Togo
Tonga
Trinidad and Tobago
Tunisia
Turkey
Turkmenistan
Tuvalu
Uganda
Ukraine
United Arab Emirates
United Kingdom
United States
Uruguay
Uzbekistan
Vanuatu
Vatican City
Venezuela
Vietnam
Yemen
Zambia
Zimbabwe
*/


