import Foundation

/// Curated, Chinese-friendly catalog of world time zones plus search.
enum TimeZoneCatalog {

    private static func z(_ id: String, _ cityZh: String, _ cityEn: String, _ shortZh: String,
                          _ flag: String, _ countryZh: String, _ keywords: [String] = []) -> ZoneInfo {
        ZoneInfo(id: id, cityZh: cityZh, cityEn: cityEn, shortZh: shortZh,
                 flag: flag, countryZh: countryZh, keywords: keywords)
    }

    // MARK: - Curated list

    static let all: [ZoneInfo] = [
        // 中国
        z("Asia/Shanghai", "北京", "Beijing", "京", "🇨🇳", "中国",
          ["beijing", "bj", "peking", "china", "zhongguo", "cst", "北京时间", "中国标准时间",
           "上海", "shanghai", "sh", "沪", "广州", "guangzhou", "gz", "穗", "深圳", "shenzhen", "sz",
           "杭州", "hangzhou", "hz", "成都", "chengdu", "cd", "蓉", "重庆", "chongqing", "cq",
           "南京", "nanjing", "nj", "武汉", "wuhan", "wh", "西安", "xian", "xa", "天津", "tianjin", "tj",
           "苏州", "suzhou", "厦门", "xiamen", "青岛", "qingdao", "长沙", "changsha", "郑州", "zhengzhou"]),
        z("Asia/Hong_Kong", "香港", "Hong Kong", "港", "🇭🇰", "中国香港", ["xianggang", "xg", "hk", "hkt"]),
        z("Asia/Macau", "澳门", "Macau", "澳", "🇲🇴", "中国澳门", ["aomen", "am", "macao"]),
        z("Asia/Taipei", "台北", "Taipei", "台", "🇹🇼", "中国台湾", ["taibei", "tb", "taiwan", "台湾", "高雄", "台中"]),
        z("Asia/Urumqi", "乌鲁木齐", "Urumqi", "乌", "🇨🇳", "中国", ["wulumuqi", "wlmq", "新疆", "xinjiang"]),
        // 东亚
        z("Asia/Tokyo", "东京", "Tokyo", "东", "🇯🇵", "日本", ["dongjing", "dj", "japan", "riben", "jst", "大阪", "osaka", "京都", "kyoto", "横滨"]),
        z("Asia/Seoul", "首尔", "Seoul", "首", "🇰🇷", "韩国", ["shouer", "se", "汉城", "korea", "hanguo", "kst", "釜山", "busan"]),
        z("Asia/Pyongyang", "平壤", "Pyongyang", "平", "🇰🇵", "朝鲜", ["pingrang", "pr"]),
        z("Asia/Ulaanbaatar", "乌兰巴托", "Ulaanbaatar", "乌", "🇲🇳", "蒙古", ["wulanbatuo", "wlbt", "mongolia"]),
        // 东南亚
        z("Asia/Singapore", "新加坡", "Singapore", "新", "🇸🇬", "新加坡", ["xinjiapo", "xjp", "sg", "sgt"]),
        z("Asia/Bangkok", "曼谷", "Bangkok", "曼", "🇹🇭", "泰国", ["mangu", "mg", "thailand", "taiguo", "普吉", "清迈"]),
        z("Asia/Jakarta", "雅加达", "Jakarta", "雅", "🇮🇩", "印度尼西亚", ["yajiada", "yjd", "indonesia", "印尼", "wib"]),
        z("Asia/Makassar", "巴厘岛", "Bali", "巴", "🇮🇩", "印度尼西亚", ["balidao", "bld", "denpasar", "望加锡", "makassar", "wita"]),
        z("Asia/Kuala_Lumpur", "吉隆坡", "Kuala Lumpur", "吉", "🇲🇾", "马来西亚", ["jilongpo", "jlp", "kl", "malaysia", "malaixiya"]),
        z("Asia/Manila", "马尼拉", "Manila", "马", "🇵🇭", "菲律宾", ["manila", "mnl", "philippines", "feilvbin"]),
        z("Asia/Ho_Chi_Minh", "胡志明市", "Ho Chi Minh City", "胡", "🇻🇳", "越南", ["huzhiming", "hzm", "西贡", "saigon", "河内", "hanoi", "henei", "vietnam", "yuenan"]),
        z("Asia/Yangon", "仰光", "Yangon", "仰", "🇲🇲", "缅甸", ["yangguang", "yg", "myanmar", "rangoon"]),
        z("Asia/Phnom_Penh", "金边", "Phnom Penh", "金", "🇰🇭", "柬埔寨", ["jinbian", "jb", "cambodia"]),
        // 南亚 / 中亚
        z("Asia/Kolkata", "新德里", "New Delhi", "德", "🇮🇳", "印度", ["xindeli", "xdl", "delhi", "india", "yindu", "ist", "孟买", "mumbai", "班加罗尔", "bangalore", "加尔各答", "kolkata", "calcutta"]),
        z("Asia/Karachi", "卡拉奇", "Karachi", "卡", "🇵🇰", "巴基斯坦", ["kalaqi", "klq", "pakistan", "伊斯兰堡", "islamabad", "pkt"]),
        z("Asia/Dhaka", "达卡", "Dhaka", "达", "🇧🇩", "孟加拉国", ["daka", "dk", "bangladesh"]),
        z("Asia/Kathmandu", "加德满都", "Kathmandu", "加", "🇳🇵", "尼泊尔", ["jiademandu", "jdmd", "nepal"]),
        z("Asia/Colombo", "科伦坡", "Colombo", "科", "🇱🇰", "斯里兰卡", ["kelunpo", "klp", "sri lanka"]),
        z("Asia/Almaty", "阿拉木图", "Almaty", "阿", "🇰🇿", "哈萨克斯坦", ["alamutu", "almt", "kazakhstan", "阿斯塔纳"]),
        z("Asia/Tashkent", "塔什干", "Tashkent", "塔", "🇺🇿", "乌兹别克斯坦", ["tashigan", "tsg", "uzbekistan"]),
        // 西亚
        z("Asia/Dubai", "迪拜", "Dubai", "迪", "🇦🇪", "阿联酋", ["dibai", "db", "uae", "阿布扎比", "abu dhabi", "gst"]),
        z("Asia/Riyadh", "利雅得", "Riyadh", "利", "🇸🇦", "沙特阿拉伯", ["liyade", "lyd", "saudi", "沙特", "吉达", "jeddah", "麦加", "mecca"]),
        z("Asia/Qatar", "多哈", "Doha", "多", "🇶🇦", "卡塔尔", ["duoha", "dh", "qatar"]),
        z("Asia/Kuwait", "科威特城", "Kuwait City", "科", "🇰🇼", "科威特", ["keweite", "kwt", "kuwait"]),
        z("Asia/Baghdad", "巴格达", "Baghdad", "巴", "🇮🇶", "伊拉克", ["bageda", "bgd", "iraq"]),
        z("Asia/Tehran", "德黑兰", "Tehran", "德", "🇮🇷", "伊朗", ["deheilan", "dhl", "iran", "yilang", "irst"]),
        z("Asia/Jerusalem", "耶路撒冷", "Jerusalem", "耶", "🇮🇱", "以色列", ["yelusaleng", "ylsl", "israel", "特拉维夫", "tel aviv"]),
        z("Asia/Beirut", "贝鲁特", "Beirut", "贝", "🇱🇧", "黎巴嫩", ["beilute", "blt", "lebanon"]),
        z("Asia/Baku", "巴库", "Baku", "巴", "🇦🇿", "阿塞拜疆", ["baku", "bk", "azerbaijan"]),
        z("Asia/Tbilisi", "第比利斯", "Tbilisi", "第", "🇬🇪", "格鲁吉亚", ["dibilisi", "dbls", "georgia"]),
        z("Europe/Istanbul", "伊斯坦布尔", "Istanbul", "伊", "🇹🇷", "土耳其", ["yisitanbuer", "ystbe", "turkey", "tuerqi", "安卡拉", "ankara", "trt"]),
        // 欧洲
        z("Europe/London", "伦敦", "London", "伦", "🇬🇧", "英国", ["lundun", "ld", "uk", "britain", "yingguo", "gmt", "bst", "曼彻斯特", "manchester", "爱丁堡", "edinburgh"]),
        z("Europe/Dublin", "都柏林", "Dublin", "都", "🇮🇪", "爱尔兰", ["dubolin", "dbl", "ireland"]),
        z("Europe/Lisbon", "里斯本", "Lisbon", "里", "🇵🇹", "葡萄牙", ["lisiben", "lsb", "portugal", "putaoya", "波尔图", "wet"]),
        z("Europe/Paris", "巴黎", "Paris", "巴", "🇫🇷", "法国", ["bali", "bl", "france", "faguo", "cet", "cest", "里昂", "lyon", "马赛", "marseille", "尼斯"]),
        z("Europe/Berlin", "柏林", "Berlin", "柏", "🇩🇪", "德国", ["bolin", "bl", "germany", "deguo", "法兰克福", "frankfurt", "慕尼黑", "munich", "汉堡", "hamburg"]),
        z("Europe/Rome", "罗马", "Rome", "罗", "🇮🇹", "意大利", ["luoma", "lm", "italy", "yidali", "米兰", "milan", "威尼斯", "venice", "佛罗伦萨"]),
        z("Europe/Madrid", "马德里", "Madrid", "马", "🇪🇸", "西班牙", ["madeli", "mdl", "spain", "xibanya", "巴塞罗那", "barcelona"]),
        z("Europe/Amsterdam", "阿姆斯特丹", "Amsterdam", "阿", "🇳🇱", "荷兰", ["amusitedan", "amstd", "netherlands", "helan", "鹿特丹"]),
        z("Europe/Brussels", "布鲁塞尔", "Brussels", "布", "🇧🇪", "比利时", ["bulusaier", "blse", "belgium"]),
        z("Europe/Zurich", "苏黎世", "Zurich", "苏", "🇨🇭", "瑞士", ["sulishi", "sls", "switzerland", "ruishi", "日内瓦", "geneva", "伯尔尼"]),
        z("Europe/Vienna", "维也纳", "Vienna", "维", "🇦🇹", "奥地利", ["weiyena", "wyn", "austria"]),
        z("Europe/Prague", "布拉格", "Prague", "布", "🇨🇿", "捷克", ["bulage", "blg", "czech"]),
        z("Europe/Warsaw", "华沙", "Warsaw", "华", "🇵🇱", "波兰", ["huasha", "hs", "poland", "bolan"]),
        z("Europe/Budapest", "布达佩斯", "Budapest", "布", "🇭🇺", "匈牙利", ["budapeisi", "bdps", "hungary"]),
        z("Europe/Copenhagen", "哥本哈根", "Copenhagen", "哥", "🇩🇰", "丹麦", ["gebenhagen", "gbhg", "denmark"]),
        z("Europe/Stockholm", "斯德哥尔摩", "Stockholm", "斯", "🇸🇪", "瑞典", ["sidegeermo", "sdgem", "sweden", "ruidian"]),
        z("Europe/Oslo", "奥斯陆", "Oslo", "奥", "🇳🇴", "挪威", ["aosilu", "asl", "norway"]),
        z("Europe/Helsinki", "赫尔辛基", "Helsinki", "赫", "🇫🇮", "芬兰", ["heerxinji", "hexj", "finland", "eet"]),
        z("Europe/Athens", "雅典", "Athens", "雅", "🇬🇷", "希腊", ["yadian", "yd", "greece", "xila"]),
        z("Europe/Bucharest", "布加勒斯特", "Bucharest", "布", "🇷🇴", "罗马尼亚", ["bujialesite", "bjlst", "romania"]),
        z("Europe/Kyiv", "基辅", "Kyiv", "基", "🇺🇦", "乌克兰", ["jifu", "jf", "kiev", "ukraine", "wukelan"]),
        z("Europe/Minsk", "明斯克", "Minsk", "明", "🇧🇾", "白俄罗斯", ["mingsike", "msk", "belarus"]),
        z("Europe/Moscow", "莫斯科", "Moscow", "莫", "🇷🇺", "俄罗斯", ["mosike", "msk", "russia", "eluosi", "圣彼得堡", "st petersburg"]),
        z("Asia/Yekaterinburg", "叶卡捷琳堡", "Yekaterinburg", "叶", "🇷🇺", "俄罗斯", ["yekajielinbao", "ykjlb"]),
        z("Asia/Novosibirsk", "新西伯利亚", "Novosibirsk", "新", "🇷🇺", "俄罗斯", ["xinxiboliya", "xxbly"]),
        z("Asia/Vladivostok", "海参崴", "Vladivostok", "海", "🇷🇺", "俄罗斯", ["haishenwai", "hsw", "符拉迪沃斯托克"]),
        z("Atlantic/Reykjavik", "雷克雅未克", "Reykjavik", "雷", "🇮🇸", "冰岛", ["leikeyaweike", "lkywk", "iceland", "bingdao"]),
        // 北美
        z("America/New_York", "纽约", "New York", "纽", "🇺🇸", "美国", ["niuyue", "ny", "nyc", "usa", "meiguo", "est", "edt", "et", "美东", "华盛顿", "washington", "huashengdun", "dc", "波士顿", "boston", "迈阿密", "miami", "费城", "philadelphia", "亚特兰大", "atlanta", "底特律"]),
        z("America/Toronto", "多伦多", "Toronto", "多", "🇨🇦", "加拿大", ["duolunduo", "dld", "canada", "jianada", "蒙特利尔", "montreal", "渥太华", "ottawa"]),
        z("America/Chicago", "芝加哥", "Chicago", "芝", "🇺🇸", "美国", ["zhijiage", "zjg", "cst", "cdt", "ct", "美中", "达拉斯", "dallas", "休斯顿", "houston", "奥斯汀", "austin", "新奥尔良"]),
        z("America/Denver", "丹佛", "Denver", "丹", "🇺🇸", "美国", ["danfo", "df", "mst", "mdt", "mt", "盐湖城", "salt lake city"]),
        z("America/Phoenix", "凤凰城", "Phoenix", "凤", "🇺🇸", "美国", ["fenghuangcheng", "fhc", "亚利桑那", "arizona", "mst"]),
        z("America/Los_Angeles", "洛杉矶", "Los Angeles", "洛", "🇺🇸", "美国", ["luoshanji", "lsj", "la", "pst", "pdt", "pt", "美西", "旧金山", "san francisco", "jiujinshan", "sf", "硅谷", "silicon valley", "西雅图", "seattle", "xiyatu", "圣何塞", "san jose", "拉斯维加斯", "las vegas", "圣地亚哥(美)", "san diego"]),
        z("America/Vancouver", "温哥华", "Vancouver", "温", "🇨🇦", "加拿大", ["wengehua", "wgh"]),
        z("America/Edmonton", "埃德蒙顿", "Edmonton", "埃", "🇨🇦", "加拿大", ["aidemengdun", "admd", "卡尔加里", "calgary"]),
        z("America/Halifax", "哈利法克斯", "Halifax", "哈", "🇨🇦", "加拿大", ["halifakesi", "hlfks", "ast", "adt"]),
        z("America/St_Johns", "圣约翰斯", "St. John's", "圣", "🇨🇦", "加拿大", ["shengyuehansi", "syhs", "纽芬兰", "newfoundland", "nst"]),
        z("America/Anchorage", "安克雷奇", "Anchorage", "安", "🇺🇸", "美国", ["ankeleiqi", "aklq", "阿拉斯加", "alaska", "akst"]),
        z("Pacific/Honolulu", "檀香山", "Honolulu", "檀", "🇺🇸", "美国", ["tanxiangshan", "txs", "火奴鲁鲁", "夏威夷", "hawaii", "hst"]),
        z("America/Mexico_City", "墨西哥城", "Mexico City", "墨", "🇲🇽", "墨西哥", ["moxigecheng", "mxgc", "mexico", "moxige"]),
        z("America/Cancun", "坎昆", "Cancun", "坎", "🇲🇽", "墨西哥", ["kankun", "kk"]),
        // 中南美
        z("America/Havana", "哈瓦那", "Havana", "哈", "🇨🇺", "古巴", ["hawana", "hwn", "cuba"]),
        z("America/Panama", "巴拿马城", "Panama City", "巴", "🇵🇦", "巴拿马", ["banamacheng", "bnmc", "panama"]),
        z("America/Bogota", "波哥大", "Bogotá", "波", "🇨🇴", "哥伦比亚", ["bogeda", "bgd", "bogota", "colombia"]),
        z("America/Lima", "利马", "Lima", "利", "🇵🇪", "秘鲁", ["lima", "lm", "peru", "bilu"]),
        z("America/Caracas", "加拉加斯", "Caracas", "加", "🇻🇪", "委内瑞拉", ["jialajiasi", "jljs", "venezuela"]),
        z("America/Santiago", "圣地亚哥", "Santiago", "圣", "🇨🇱", "智利", ["shengdiyage", "sdyg", "chile", "zhili"]),
        z("America/Sao_Paulo", "圣保罗", "São Paulo", "圣", "🇧🇷", "巴西", ["shengbaoluo", "sbl", "sao paulo", "brazil", "baxi", "里约热内卢", "rio", "巴西利亚", "brt"]),
        z("America/Argentina/Buenos_Aires", "布宜诺斯艾利斯", "Buenos Aires", "布", "🇦🇷", "阿根廷", ["buyinuosiailisi", "bynsals", "argentina", "agenting", "art"]),
        z("America/Montevideo", "蒙得维的亚", "Montevideo", "蒙", "🇺🇾", "乌拉圭", ["mengdeweidiya", "mdwdy", "uruguay"]),
        // 大洋洲
        z("Australia/Sydney", "悉尼", "Sydney", "悉", "🇦🇺", "澳大利亚", ["xini", "xn", "australia", "aodaliya", "aest", "aedt", "堪培拉", "canberra"]),
        z("Australia/Melbourne", "墨尔本", "Melbourne", "墨", "🇦🇺", "澳大利亚", ["moerben", "meb"]),
        z("Australia/Brisbane", "布里斯班", "Brisbane", "布", "🇦🇺", "澳大利亚", ["bulisiban", "blsb", "黄金海岸", "gold coast"]),
        z("Australia/Adelaide", "阿德莱德", "Adelaide", "阿", "🇦🇺", "澳大利亚", ["adelaide", "adld", "acst"]),
        z("Australia/Perth", "珀斯", "Perth", "珀", "🇦🇺", "澳大利亚", ["posi", "ps", "awst"]),
        z("Pacific/Auckland", "奥克兰", "Auckland", "奥", "🇳🇿", "新西兰", ["aokelan", "akl", "new zealand", "xinxilan", "惠灵顿", "wellington", "nzst", "nzdt"]),
        z("Pacific/Guam", "关岛", "Guam", "关", "🇬🇺", "美国关岛", ["guandao", "gd", "chst"]),
        z("Pacific/Fiji", "苏瓦", "Suva", "斐", "🇫🇯", "斐济", ["suwa", "feiji", "fiji"]),
        // 非洲
        z("Africa/Cairo", "开罗", "Cairo", "开", "🇪🇬", "埃及", ["kailuo", "kl", "egypt", "aiji"]),
        z("Africa/Johannesburg", "约翰内斯堡", "Johannesburg", "约", "🇿🇦", "南非", ["yuehanneisibao", "yhnsb", "south africa", "nanfei", "开普敦", "cape town", "sast"]),
        z("Africa/Lagos", "拉各斯", "Lagos", "拉", "🇳🇬", "尼日利亚", ["lagesi", "lgs", "nigeria", "阿布贾", "wat"]),
        z("Africa/Nairobi", "内罗毕", "Nairobi", "内", "🇰🇪", "肯尼亚", ["neiluobi", "nlb", "kenya", "eat"]),
        z("Africa/Addis_Ababa", "亚的斯亚贝巴", "Addis Ababa", "亚", "🇪🇹", "埃塞俄比亚", ["yadisiyabeiba", "ydsybb", "ethiopia"]),
        z("Africa/Casablanca", "卡萨布兰卡", "Casablanca", "卡", "🇲🇦", "摩洛哥", ["kasabulanka", "ksblk", "morocco", "拉巴特"]),
        z("Africa/Algiers", "阿尔及尔", "Algiers", "阿", "🇩🇿", "阿尔及利亚", ["aerjier", "aeje", "algeria"]),
        z("Africa/Accra", "阿克拉", "Accra", "阿", "🇬🇭", "加纳", ["akela", "akl", "ghana"]),
        z("Africa/Kinshasa", "金沙萨", "Kinshasa", "金", "🇨🇩", "刚果（金）", ["jinshasa", "jss", "congo"]),
        z("Indian/Maldives", "马累", "Malé", "马", "🇲🇻", "马尔代夫", ["malei", "maerdaifu", "maldives"]),
        z("Indian/Mauritius", "路易港", "Port Louis", "毛", "🇲🇺", "毛里求斯", ["luyigang", "maoliqiusi", "mauritius"]),
        // 协调世界时
        z("UTC", "协调世界时", "UTC", "UTC", "🌐", "", ["utc", "gmt", "zulu", "z", "格林尼治", "世界时", "xietiaoshijieshi"]),
    ]

    static let common: [ZoneInfo] = [
        "Asia/Shanghai", "Asia/Hong_Kong", "Asia/Taipei", "Asia/Tokyo", "Asia/Seoul",
        "Asia/Singapore", "Europe/London", "Europe/Paris", "America/New_York",
        "America/Los_Angeles", "Australia/Sydney", "Asia/Dubai",
    ].map { info(for: $0) }

    // MARK: - Lookup

    private static let byID: [String: ZoneInfo] = {
        var dict: [String: ZoneInfo] = [:]
        for zone in all where dict[zone.id] == nil { dict[zone.id] = zone }
        return dict
    }()

    /// Curated info for an IANA id, or a synthesized entry for any other id.
    static func info(for id: String) -> ZoneInfo {
        if let zone = byID[id] { return zone }
        let last = id.split(separator: "/").last.map(String.init) ?? id
        let city = last.replacingOccurrences(of: "_", with: " ")
        return ZoneInfo(id: id, cityZh: city, cityEn: city,
                        shortZh: city.first.map { String($0) } ?? "?",
                        flag: "🌐", countryZh: "", keywords: [])
    }

    // MARK: - Search

    static func search(_ query: String) -> [ZoneInfo] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return all }

        // Zones matched by abbreviation ("PST") or UTC offset ("GMT+8", "+5:30").
        var abbrevIDs = Set<String>()
        if let ids = abbreviationMap[q] { abbrevIDs.formUnion(ids) }
        let offset = parseOffset(q)

        var scored: [(rank: Int, index: Int, zone: ZoneInfo)] = []
        for (index, zone) in all.enumerated() {
            var rank = textRank(zone, q)
            if abbrevIDs.contains(zone.id) { rank = min(rank, 0) }
            if let offset, zone.timeZone.secondsFromGMT() == offset { rank = min(rank, 1) }
            if rank < Int.max { scored.append((rank, index, zone)) }
        }
        scored.sort { $0.rank != $1.rank ? $0.rank < $1.rank : $0.index < $1.index }
        var results = scored.map(\.zone)

        // Non-curated IANA identifiers.
        var extra: [(rank: Int, id: String)] = []
        for id in TimeZone.knownTimeZoneIdentifiers where byID[id] == nil {
            var rank = match(id.lowercased(), q)
            let city = (id.split(separator: "/").last.map(String.init) ?? id)
                .replacingOccurrences(of: "_", with: " ").lowercased()
            rank = min(rank, match(city, q))
            if abbrevIDs.contains(id) { rank = min(rank, 0) }
            if offset == nil, rank == Int.max { continue }
            if let offset, rank == Int.max {
                guard TimeZone(identifier: id)?.secondsFromGMT() == offset else { continue }
                rank = 3
            }
            extra.append((rank, id))
        }
        extra.sort { $0.rank != $1.rank ? $0.rank < $1.rank : $0.id < $1.id }
        results += extra.map { info(for: $0.id) }
        return results
    }

    /// 0 = exact, 1 = prefix, 2 = contains, Int.max = no match.
    private static func match(_ field: String, _ q: String) -> Int {
        if field.isEmpty { return Int.max }
        if field == q { return 0 }
        if field.hasPrefix(q) { return 1 }
        if field.contains(q) { return 2 }
        return Int.max
    }

    private static func textRank(_ zone: ZoneInfo, _ q: String) -> Int {
        var best = Int.max
        let fields = [zone.cityZh, zone.cityEn, zone.shortZh, zone.countryZh, zone.id,
                      zone.id.replacingOccurrences(of: "_", with: " ")] + zone.keywords
        for field in fields {
            best = min(best, match(field.lowercased(), q))
            if best == 0 { break }
        }
        return best
    }

    /// Lowercased abbreviation -> zone ids, from Foundation plus each zone's current abbreviation.
    private static let abbreviationMap: [String: Set<String>] = {
        var map: [String: Set<String>] = [:]
        for (abbr, id) in TimeZone.abbreviationDictionary {
            map[abbr.lowercased(), default: []].insert(id)
        }
        let now = Date()
        for zone in all {
            guard let tz = TimeZone(identifier: zone.id) else { continue }
            if let abbr = tz.abbreviation(for: now) {
                map[abbr.lowercased(), default: []].insert(zone.id)
            }
        }
        map["cst", default: []].insert("Asia/Shanghai") // 中国标准时间
        map["utc", default: []].insert("UTC")
        map["gmt", default: []].insert("UTC")
        return map
    }()

    /// Parses "gmt+8", "utc-5", "+8", "+05:30", "utc+530" into seconds from GMT.
    private static func parseOffset(_ q: String) -> Int? {
        var s = Substring(q)
        for prefix in ["gmt", "utc"] where s.hasPrefix(prefix) {
            s = s.dropFirst(prefix.count)
            break
        }
        s = Substring(s.trimmingCharacters(in: .whitespaces))
        guard let sign = s.first, sign == "+" || sign == "-" || sign == "＋" || sign == "－" else { return nil }
        let body = s.dropFirst()
        guard !body.isEmpty else { return nil }
        var hours = 0, minutes = 0
        if let colon = body.firstIndex(where: { $0 == ":" || $0 == "：" }) {
            guard let h = Int(body[..<colon]), let m = Int(body[body.index(after: colon)...]) else { return nil }
            hours = h; minutes = m
        } else {
            guard body.allSatisfy(\.isNumber), let n = Int(body) else { return nil }
            if body.count <= 2 { hours = n } else { hours = n / 100; minutes = n % 100 }
        }
        guard hours <= 14, minutes < 60 else { return nil }
        let total = hours * 3600 + minutes * 60
        return (sign == "-" || sign == "－") ? -total : total
    }
}
