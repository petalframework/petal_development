defmodule Util.Countries do
  def find_by_code(code), do: Enum.find(all_countries(), &(&1.code == String.upcase(code)))
  def list_valid_codes(), do: Enum.map(all_countries(), & &1.code)
  def random(), do: Enum.random(all_countries())

  def list_select_options(),
    do: Enum.map(all_countries(), &{&1.value <> " " <> &1.map, &1.code})

  def all_countries() do
    [
      %{code: "AF", map: "🇦🇫", phone_code: 93, value: "Afghanistan"},
      %{code: "AL", map: "🇦🇱", phone_code: 355, value: "Albania"},
      %{code: "DZ", map: "🇩🇿", phone_code: 213, value: "Algeria"},
      %{code: "AS", map: "🇦🇸", phone_code: 1684, value: "American Samoa"},
      %{code: "AD", map: "🇦🇩", phone_code: 376, value: "Andorra"},
      %{code: "AO", map: "🇦🇴", phone_code: 244, value: "Angola"},
      %{code: "AI", map: "🇦🇮", phone_code: 1264, value: "Anguilla"},
      %{code: "AQ", map: "🇦🇶", phone_code: 0, value: "Antarctica"},
      %{code: "AR", map: "🇦🇷", phone_code: 54, value: "Argentina"},
      %{code: "AM", map: "🇦🇲", phone_code: 374, value: "Armenia"},
      %{code: "AW", map: "🇦🇼", phone_code: 297, value: "Aruba"},
      %{code: "AU", map: "🇦🇺", phone_code: 61, value: "Australia"},
      %{code: "AT", map: "🇦🇹", phone_code: 43, value: "Austria"},
      %{code: "AZ", map: "🇦🇿", phone_code: 994, value: "Azerbaijan"},
      %{code: "BH", map: "🇧🇭", phone_code: 973, value: "Bahrain"},
      %{code: "BD", map: "🇧🇩", phone_code: 880, value: "Bangladesh"},
      %{code: "BB", map: "🇧🇧", phone_code: 1246, value: "Barbados"},
      %{code: "BY", map: "🇧🇾", phone_code: 375, value: "Belarus"},
      %{code: "BE", map: "🇧🇪", phone_code: 32, value: "Belgium"},
      %{code: "BZ", map: "🇧🇿", phone_code: 501, value: "Belize"},
      %{code: "BJ", map: "🇧🇯", phone_code: 229, value: "Benin"},
      %{code: "BM", map: "🇧🇲", phone_code: 1441, value: "Bermuda"},
      %{code: "BT", map: "🇧🇹", phone_code: 975, value: "Bhutan"},
      %{code: "BO", map: "🇧🇴", phone_code: 591, value: "Bolivia"},
      %{code: "BW", map: "🇧🇼", phone_code: 267, value: "Botswana"},
      %{code: "BV", map: "🇧🇻", phone_code: 0, value: "Bouvet Island"},
      %{code: "BR", map: "🇧🇷", phone_code: 55, value: "Brazil"},
      %{code: "IO", map: "🇮🇴", phone_code: 246, value: "British Indian Ocean Territory"},
      %{code: "BN", map: "🇧🇳", phone_code: 673, value: "Brunei"},
      %{code: "BG", map: "🇧🇬", phone_code: 359, value: "Bulgaria"},
      %{code: "BF", map: "🇧🇫", phone_code: 226, value: "Burkina Faso"},
      %{code: "BI", map: "🇧🇮", phone_code: 257, value: "Burundi"},
      %{code: "KH", map: "🇰🇭", phone_code: 855, value: "Cambodia"},
      %{code: "CM", map: "🇨🇲", phone_code: 237, value: "Cameroon"},
      %{code: "CA", map: "🇨🇦", phone_code: 1, value: "Canada"},
      %{code: "CV", map: "🇨🇻", phone_code: 238, value: "Cape Verde"},
      %{code: "KY", map: "🇰🇾", phone_code: 1345, value: "Cayman Islands"},
      %{code: "CF", map: "🇨🇫", phone_code: 236, value: "Central African Republic"},
      %{code: "TD", map: "🇹🇩", phone_code: 235, value: "Chad"},
      %{code: "CL", map: "🇨🇱", phone_code: 56, value: "Chile"},
      %{code: "CN", map: "🇨🇳", phone_code: 86, value: "China"},
      %{code: "CX", map: "🇨🇽", phone_code: 61, value: "Christmas Island"},
      %{code: "CC", map: "🇨🇨", phone_code: 672, value: "Cocos (Keeling) Islands"},
      %{code: "CO", map: "🇨🇴", phone_code: 57, value: "Colombia"},
      %{code: "KM", map: "🇰🇲", phone_code: 269, value: "Comoros"},
      %{code: "CK", map: "🇨🇰", phone_code: 682, value: "Cook Islands"},
      %{code: "CR", map: "🇨🇷", phone_code: 506, value: "Costa Rica"},
      %{code: "CU", map: "🇨🇺", phone_code: 53, value: "Cuba"},
      %{code: "CY", map: "🇨🇾", phone_code: 357, value: "Cyprus"},
      %{code: "DK", map: "🇩🇰", phone_code: 45, value: "Denmark"},
      %{code: "DJ", map: "🇩🇯", phone_code: 253, value: "Djibouti"},
      %{code: "DM", map: "🇩🇲", phone_code: 1767, value: "Dominica"},
      %{code: "DO", map: "🇩🇴", phone_code: 1809, value: "Dominican Republic"},
      %{code: "EC", map: "🇪🇨", phone_code: 593, value: "Ecuador"},
      %{code: "EG", map: "🇪🇬", phone_code: 20, value: "Egypt"},
      %{code: "SV", map: "🇸🇻", phone_code: 503, value: "El Salvador"},
      %{code: "GQ", map: "🇬🇶", phone_code: 240, value: "Equatorial Guinea"},
      %{code: "ER", map: "🇪🇷", phone_code: 291, value: "Eritrea"},
      %{code: "EE", map: "🇪🇪", phone_code: 372, value: "Estonia"},
      %{code: "ET", map: "🇪🇹", phone_code: 251, value: "Ethiopia"},
      %{code: "FK", map: "🇫🇰", phone_code: 500, value: "Falkland Islands"},
      %{code: "FO", map: "🇫🇴", phone_code: 298, value: "Faroe Islands"},
      %{code: "FI", map: "🇫🇮", phone_code: 358, value: "Finland"},
      %{code: "FR", map: "🇫🇷", phone_code: 33, value: "France"},
      %{code: "GF", map: "🇬🇫", phone_code: 594, value: "French Guiana"},
      %{code: "PF", map: "🇵🇫", phone_code: 689, value: "French Polynesia"},
      %{code: "TF", map: "🇹🇫", phone_code: 0, value: "French Southern Territories"},
      %{code: "GA", map: "🇬🇦", phone_code: 241, value: "Gabon"},
      %{code: "GE", map: "🇬🇪", phone_code: 995, value: "Georgia"},
      %{code: "DE", map: "🇩🇪", phone_code: 49, value: "Germany"},
      %{code: "GH", map: "🇬🇭", phone_code: 233, value: "Ghana"},
      %{code: "GI", map: "🇬🇮", phone_code: 350, value: "Gibraltar"},
      %{code: "GR", map: "🇬🇷", phone_code: 30, value: "Greece"},
      %{code: "GL", map: "🇬🇱", phone_code: 299, value: "Greenland"},
      %{code: "GD", map: "🇬🇩", phone_code: 1473, value: "Grenada"},
      %{code: "GP", map: "🇬🇵", phone_code: 590, value: "Guadeloupe"},
      %{code: "GU", map: "🇬🇺", phone_code: 1671, value: "Guam"},
      %{code: "GT", map: "🇬🇹", phone_code: 502, value: "Guatemala"},
      %{code: "GN", map: "🇬🇳", phone_code: 224, value: "Guinea"},
      %{code: "GW", map: "🇬🇼", phone_code: 245, value: "Guinea-Bissau"},
      %{code: "GY", map: "🇬🇾", phone_code: 592, value: "Guyana"},
      %{code: "HT", map: "🇭🇹", phone_code: 509, value: "Haiti"},
      %{code: "HN", map: "🇭🇳", phone_code: 504, value: "Honduras"},
      %{code: "HU", map: "🇭🇺", phone_code: 36, value: "Hungary"},
      %{code: "IS", map: "🇮🇸", phone_code: 354, value: "Iceland"},
      %{code: "IN", map: "🇮🇳", phone_code: 91, value: "India"},
      %{code: "ID", map: "🇮🇩", phone_code: 62, value: "Indonesia"},
      %{code: "IR", map: "🇮🇷", phone_code: 98, value: "Iran"},
      %{code: "IQ", map: "🇮🇶", phone_code: 964, value: "Iraq"},
      %{code: "IE", map: "🇮🇪", phone_code: 353, value: "Ireland"},
      %{code: "IL", map: "🇮🇱", phone_code: 972, value: "Israel"},
      %{code: "IT", map: "🇮🇹", phone_code: 39, value: "Italy"},
      %{code: "JM", map: "🇯🇲", phone_code: 1876, value: "Jamaica"},
      %{code: "JP", map: "🇯🇵", phone_code: 81, value: "Japan"},
      %{code: "JO", map: "🇯🇴", phone_code: 962, value: "Jordan"},
      %{code: "KZ", map: "🇰🇿", phone_code: 7, value: "Kazakhstan"},
      %{code: "KE", map: "🇰🇪", phone_code: 254, value: "Kenya"},
      %{code: "KI", map: "🇰🇮", phone_code: 686, value: "Kiribati"},
      %{code: "KW", map: "🇰🇼", phone_code: 965, value: "Kuwait"},
      %{code: "KG", map: "🇰🇬", phone_code: 996, value: "Kyrgyzstan"},
      %{code: "LA", map: "🇱🇦", phone_code: 856, value: "Laos"},
      %{code: "LV", map: "🇱🇻", phone_code: 371, value: "Latvia"},
      %{code: "LB", map: "🇱🇧", phone_code: 961, value: "Lebanon"},
      %{code: "LS", map: "🇱🇸", phone_code: 266, value: "Lesotho"},
      %{code: "LR", map: "🇱🇷", phone_code: 231, value: "Liberia"},
      %{code: "LY", map: "🇱🇾", phone_code: 218, value: "Libya"},
      %{code: "LI", map: "🇱🇮", phone_code: 423, value: "Liechtenstein"},
      %{code: "LT", map: "🇱🇹", phone_code: 370, value: "Lithuania"},
      %{code: "LU", map: "🇱🇺", phone_code: 352, value: "Luxembourg"},
      %{code: "MK", map: "🇲🇰", phone_code: 389, value: "Macedonia"},
      %{code: "MG", map: "🇲🇬", phone_code: 261, value: "Madagascar"},
      %{code: "MW", map: "🇲🇼", phone_code: 265, value: "Malawi"},
      %{code: "MY", map: "🇲🇾", phone_code: 60, value: "Malaysia"},
      %{code: "MV", map: "🇲🇻", phone_code: 960, value: "Maldives"},
      %{code: "ML", map: "🇲🇱", phone_code: 223, value: "Mali"},
      %{code: "MT", map: "🇲🇹", phone_code: 356, value: "Malta"},
      %{code: "MH", map: "🇲🇭", phone_code: 692, value: "Marshall Islands"},
      %{code: "MQ", map: "🇲🇶", phone_code: 596, value: "Martinique"},
      %{code: "MR", map: "🇲🇷", phone_code: 222, value: "Mauritania"},
      %{code: "MU", map: "🇲🇺", phone_code: 230, value: "Mauritius"},
      %{code: "YT", map: "🇾🇹", phone_code: 269, value: "Mayotte"},
      %{code: "MX", map: "🇲🇽", phone_code: 52, value: "Mexico"},
      %{code: "FM", map: "🇫🇲", phone_code: 691, value: "Micronesia"},
      %{code: "MD", map: "🇲🇩", phone_code: 373, value: "Moldova"},
      %{code: "MC", map: "🇲🇨", phone_code: 377, value: "Monaco"},
      %{code: "MN", map: "🇲🇳", phone_code: 976, value: "Mongolia"},
      %{code: "MS", map: "🇲🇸", phone_code: 1664, value: "Montserrat"},
      %{code: "MA", map: "🇲🇦", phone_code: 212, value: "Morocco"},
      %{code: "MZ", map: "🇲🇿", phone_code: 258, value: "Mozambique"},
      %{code: "NA", map: "🇳🇦", phone_code: 264, value: "Namibia"},
      %{code: "NR", map: "🇳🇷", phone_code: 674, value: "Nauru"},
      %{code: "NP", map: "🇳🇵", phone_code: 977, value: "Nepal"},
      %{code: "NC", map: "🇳🇨", phone_code: 687, value: "New Caledonia"},
      %{code: "NZ", map: "🇳🇿", phone_code: 64, value: "New Zealand"},
      %{code: "NI", map: "🇳🇮", phone_code: 505, value: "Nicaragua"},
      %{code: "NE", map: "🇳🇪", phone_code: 227, value: "Niger"},
      %{code: "NG", map: "🇳🇬", phone_code: 234, value: "Nigeria"},
      %{code: "NU", map: "🇳🇺", phone_code: 683, value: "Niue"},
      %{code: "NF", map: "🇳🇫", phone_code: 672, value: "Norfolk Island"},
      %{code: "MP", map: "🇲🇵", phone_code: 1670, value: "Northern Mariana Islands"},
      %{code: "NO", map: "🇳🇴", phone_code: 47, value: "Norway"},
      %{code: "OM", map: "🇴🇲", phone_code: 968, value: "Oman"},
      %{code: "PK", map: "🇵🇰", phone_code: 92, value: "Pakistan"},
      %{code: "PW", map: "🇵🇼", phone_code: 680, value: "Palau"},
      %{code: "PA", map: "🇵🇦", phone_code: 507, value: "Panama"},
      %{code: "PY", map: "🇵🇾", phone_code: 595, value: "Paraguay"},
      %{code: "PE", map: "🇵🇪", phone_code: 51, value: "Peru"},
      %{code: "PH", map: "🇵🇭", phone_code: 63, value: "Philippines"},
      %{code: "PL", map: "🇵🇱", phone_code: 48, value: "Poland"},
      %{code: "PT", map: "🇵🇹", phone_code: 351, value: "Portugal"},
      %{code: "PR", map: "🇵🇷", phone_code: 1787, value: "Puerto Rico"},
      %{code: "QA", map: "🇶🇦", phone_code: 974, value: "Qatar"},
      %{code: "RO", map: "🇷🇴", phone_code: 40, value: "Romania"},
      %{code: "RU", map: "🇷🇺", phone_code: 70, value: "Russia"},
      %{code: "RW", map: "🇷🇼", phone_code: 250, value: "Rwanda"},
      %{code: "WS", map: "🇼🇸", phone_code: 684, value: "Samoa"},
      %{code: "SM", map: "🇸🇲", phone_code: 378, value: "San Marino"},
      %{code: "SA", map: "🇸🇦", phone_code: 966, value: "Saudi Arabia"},
      %{code: "SN", map: "🇸🇳", phone_code: 221, value: "Senegal"},
      %{code: "RS", map: "🇷🇸", phone_code: 381, value: "Serbia"},
      %{code: "SC", map: "🇸🇨", phone_code: 248, value: "Seychelles"},
      %{code: "SL", map: "🇸🇱", phone_code: 232, value: "Sierra Leone"},
      %{code: "SG", map: "🇸🇬", phone_code: 65, value: "Singapore"},
      %{code: "SK", map: "🇸🇰", phone_code: 421, value: "Slovakia"},
      %{code: "SI", map: "🇸🇮", phone_code: 386, value: "Slovenia"},
      %{code: "SB", map: "🇸🇧", phone_code: 677, value: "Solomon Islands"},
      %{code: "SO", map: "🇸🇴", phone_code: 252, value: "Somalia"},
      %{code: "ZA", map: "🇿🇦", phone_code: 27, value: "South Africa"},
      %{code: "SS", map: "🇸🇸", phone_code: 211, value: "South Sudan"},
      %{code: "ES", map: "🇪🇸", phone_code: 34, value: "Spain"},
      %{code: "LK", map: "🇱🇰", phone_code: 94, value: "Sri Lanka"},
      %{code: "SD", map: "🇸🇩", phone_code: 249, value: "Sudan"},
      %{code: "SR", map: "🇸🇷", phone_code: 597, value: "Suriname"},
      %{code: "SZ", map: "🇸🇿", phone_code: 268, value: "Swaziland"},
      %{code: "SE", map: "🇸🇪", phone_code: 46, value: "Sweden"},
      %{code: "CH", map: "🇨🇭", phone_code: 41, value: "Switzerland"},
      %{code: "SY", map: "🇸🇾", phone_code: 963, value: "Syria"},
      %{code: "TW", map: "🇹🇼", phone_code: 886, value: "Taiwan"},
      %{code: "TJ", map: "🇹🇯", phone_code: 992, value: "Tajikistan"},
      %{code: "TZ", map: "🇹🇿", phone_code: 255, value: "Tanzania"},
      %{code: "TH", map: "🇹🇭", phone_code: 66, value: "Thailand"},
      %{code: "TG", map: "🇹🇬", phone_code: 228, value: "Togo"},
      %{code: "TK", map: "🇹🇰", phone_code: 690, value: "Tokelau"},
      %{code: "TO", map: "🇹🇴", phone_code: 676, value: "Tonga"},
      %{code: "TN", map: "🇹🇳", phone_code: 216, value: "Tunisia"},
      %{code: "TR", map: "🇹🇷", phone_code: 90, value: "Turkey"},
      %{code: "TM", map: "🇹🇲", phone_code: 7370, value: "Turkmenistan"},
      %{code: "TV", map: "🇹🇻", phone_code: 688, value: "Tuvalu"},
      %{code: "UG", map: "🇺🇬", phone_code: 256, value: "Uganda"},
      %{code: "UA", map: "🇺🇦", phone_code: 380, value: "Ukraine"},
      %{code: "AE", map: "🇦🇪", phone_code: 971, value: "United Arab Emirates"},
      %{code: "GB", map: "🇬🇧", phone_code: 44, value: "United Kingdom"},
      %{code: "US", map: "🇺🇸", phone_code: 1, value: "United States"},
      %{code: "UY", map: "🇺🇾", phone_code: 598, value: "Uruguay"},
      %{code: "UZ", map: "🇺🇿", phone_code: 998, value: "Uzbekistan"},
      %{code: "VU", map: "🇻🇺", phone_code: 678, value: "Vanuatu"},
      %{code: "VE", map: "🇻🇪", phone_code: 58, value: "Venezuela"},
      %{code: "VN", map: "🇻🇳", phone_code: 84, value: "Vietnam"},
      %{code: "EH", map: "🇪🇭", phone_code: 212, value: "Western Sahara"},
      %{code: "YE", map: "🇾🇪", phone_code: 967, value: "Yemen"},
      %{code: "ZM", map: "🇿🇲", phone_code: 260, value: "Zambia"},
      %{code: "ZW", map: "🇿🇼", phone_code: 26, value: "Zimbabwe"}
    ]
  end
end