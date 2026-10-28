// ============================================================
//  Robotlar va robototexnik tizimlar — 3-amaliy mashgʻulot (sirtqi taʼlim) — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_3_sirtqi.typ
// ============================================================

#import "@preview/cetz:0.4.2"

#let headingblue = rgb(20, 50, 120)

#set document(title: "Robotlarning yuritmalari, boşqariş tizimlari va mobil robototexnik tizimlar")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 3  // amaliyot raqami
#set document(keywords: (info.fan,))
#set page(header: context {
  set text(size: 9pt, fill: luma(110))
  grid(
    columns: (1fr, auto, 1fr),
    align: (left, center, right),
    info.fan, info.semestr, [Amaliyot №#raqam (sirtqi)],
  )
  v(-0.5em)
  line(length: 100%, stroke: 0.4pt + luma(170))
})
// ===================

#set text(size: 12pt, lang: "uz", font: info.font)
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1")
#set math.equation(numbering: "(1)", supplement: none)
#show link: set text(fill: blue.darken(20%))
#show heading: set text(fill: headingblue)
#show heading.where(level: 1): set block(above: 1.4em, below: 0.9em)
#show figure.where(kind: table): set figure.caption(position: top)
#show figure.where(kind: image): set figure(supplement: "Rasm")
#show figure.where(kind: table): set figure(supplement: "Jadval")
#show figure.where(kind: raw): set figure(supplement: "Listing")
#show raw.where(block: true): set text(size: 10pt)
#show raw.where(block: true): set align(left)
#show raw.where(block: true): block.with(fill: luma(245), inset: 8pt, radius: 3pt, width: 100%)

// Blok formula (raqamlangan)
#let eq(body) = math.equation(block: true, numbering: "(1)", body)

// Chizmalar uchun ranglar
#let cprim = rgb(15, 42, 74)
#let csec = rgb(30, 90, 140)
#let cacc = rgb(217, 83, 79)

// Booktabs uslubidagi jadval
#let btable(columns: auto, align: center + horizon, header, ..rows) = {
  set text(size: 10pt)
  set par(justify: false)
  table(
    columns: columns,
    align: align,
    stroke: none,
    inset: (x: 6pt, y: 5pt),
    table.hline(stroke: 1pt),
    table.header(..header),
    table.hline(stroke: 0.5pt),
    ..rows,
    table.hline(stroke: 1pt),
  )
}

// ---------------- Sarlavha ----------------
#align(center)[
  #set par(justify: false)
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №#raqam]
  #v(0.4cm)
  #text(
    size: 14pt,
    weight: "bold",
  )[Mavzu: Robotlarning yuritmalarini örganiş. Robotning pnevmatik, gidravlik va elektrik yuritmasi. Sanoat robotlarini boşqariş tizimlarini örganiş. Robotlarni programmali boşqariş tizimlari. Mobil robototexnik tizimlarni örganiş]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* talabalarni robotlarning pnevmatik, gidravlik va elektr yuritmalari, sanoat robotlarini boşqariş tizimlarining tuzilişi va turlari, robotlarni dasturlaş usullari hamda mobil robototexnik tizimlarning tarkibi va navigatsiya prinsiplari bilan taniştiriş, şuningdek yuritmalar va mobil robotning asosiy parametrlarini hisoblaş könikmalarini şakllantiriş.

*Öquv vazifalari va kutilayotgan natijalar:*

- *Yuritmalar:* pnevmatik, gidravlik va elektr yuritmalarning tuzilişi, afzalliklari va kamçiliklarini taqqoslaş; silindr diametri, havo va suyuqlik sarfi, dvigatel momenti va quvvatini hisoblaş.
- *Boşqariş tizimlari:* boşqariş tizimining ierarxik darajalarini, siklli, pozitsion va kontur boşqariş turlarini farqlaş.
- *Dasturlaş:* örgatiş, qölda yetaklaş va off-line dasturlaş usullarini, robot dasturlaş tillarini tavsiflaş.
- *Mobil robototexnika:* AGV va AMR robotlarining tarkibi, navigatsiya usullari va datçiklarini tuşuntiriş, akkumulyator bilan işlaş vaqtini hisoblaş.

= Nazariy asoslar va analitik formulalar

== Robot yuritmalarining umumiy tuzilişi

*Yuritma* --- energiya manbaidan olingan energiyani boşqaruv signaliga muvofiq manipulyator zvenosining mexanik harakatiga aylantiruvçi qurilmalar majmui. Har qanday yuritma quyidagi asosiy elementlardan taşkil topadi (@fig-drive): energiya manbai; energiya oqimini boşqaruv signali böyiça taqsimlovçi qurilma (taqsimlagiç, klapan, invertor); dvigatel (silindr, gidromotor, elektr dvigatel); mexanik uzatma (reduktor); teskari aloqa datçiklari (holat, tezlik, bosim).

#figure(
  cetz.canvas(length: 0.82cm, {
    import cetz.draw: *
    set-style(content: (padding: 1pt))
    let bx(c, w, h, body, fill: white) = {
      rect(
        (c.at(0) - w / 2, c.at(1) - h / 2),
        (c.at(0) + w / 2, c.at(1) + h / 2),
        fill: fill,
        stroke: 0.9pt + cprim,
        radius: 2pt,
      )
      content(c, align(center, text(size: 8pt, body)))
    }
    let ar(..pts) = line(..pts, stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.55))
    let lb(p, body, anchor: "south") = content(p, text(size: 7pt, fill: cacc, body), anchor: anchor)

    bx((1.3, 2.2), 2.6, 1.1, fill: csec.lighten(85%))[Boşqaruv \ qurilmasi]
    bx((5.0, 2.2), 2.6, 1.1)[Taqsimlovçi \ qurilma]
    bx((8.6, 2.2), 2.2, 1.1)[Dvigatel]
    bx((12.0, 2.2), 2.2, 1.1)[Mexanik \ uzatma]
    bx((15.2, 2.2), 1.8, 1.1, fill: cacc.lighten(88%))[Zveno]
    bx((5.0, 4.2), 2.6, 0.9, fill: luma(240))[Energiya manbai]
    bx((8.6, 0.2), 4.0, 0.9)[Teskari aloqa datçiklari]

    ar((2.6, 2.2), (3.7, 2.2))
    lb((3.15, 2.25), [signal])
    ar((6.3, 2.2), (7.5, 2.2))
    lb((6.9, 2.25), [energiya])
    ar((9.7, 2.2), (10.9, 2.2))
    ar((13.1, 2.2), (14.3, 2.2))
    ar((5.0, 3.75), (5.0, 2.75))
    line((15.2, 1.65), (15.2, 0.2), stroke: 0.8pt)
    ar((15.2, 0.2), (10.6, 0.2))
    line((6.6, 0.2), (1.3, 0.2), stroke: 0.8pt)
    ar((1.3, 0.2), (1.3, 1.65))
    lb((3.9, 0.25), [holat, tezlik])
  }),
  caption: [Robot yuritmasining umumlaşgan tuziliş sxemasi],
  placement: auto,
) <fig-drive>

Işçi muhitning turiga köra yuritmalar pnevmatik, gidravlik va elektr yuritmalarga bölinadi. Ularning qiyosiy tavsifi @tab-drives da keltirilgan.

#figure(
  btable(
    columns: (auto, 1fr, 1fr, 1fr),
    align: (left + horizon, left + horizon, left + horizon, left + horizon),
    ([*Körsatkiç*], [*Pnevmatik*], [*Gidravlik*], [*Elektr*]),
    [Işçi muhit],
    [Siqilgan havo],
    [Mineral moy],
    [Elektr toki],
    [Işçi bosim],
    [0.4–0.8 MPa],
    [10–32 MPa],
    [---],
    [Kuç/massa nisbati],
    [Örtaça],
    [Juda yuqori],
    [Yuqori (reduktor bilan)],
    [Pozitsiyalaş aniqligi],
    [Past (asosan tayançgaça)],
    [Yuqori],
    [Juda yuqori],
    [Afzalliklari],
    [Arzon, sodda, tez, portlaş xavfsiz, ortiqça yuklanişdan qörqmaydi],
    [Katta kuç va moment, ixçam, harakat ravon],
    [Boşqaruvi qulay, aniq, toza, energiya manbai hamma joyda mavjud],
    [Kamçiliklari],
    [Havoning siqiluvçanligi tufayli tezlik va oraliq holatni boşqariş qiyin, şovqinli],
    [Moy oqişi, alohida nasos stansiyasi, harorat taʼsiri, xizmat qimmat],
    [Katta momentlar uçun reduktor kerak, qiziş],
    [Qöllanişi],
    [Qisqiçlar, sodda siklli manipulyatorlar],
    [Oğir yuk robotlari, pressga xizmat körsatiş],
    [Zamonaviy sanoat va xizmat robotlarining aksariyati],
  ),
  caption: [Robot yuritmalarining qiyosiy tavsifi],
  placement: auto,
) <tab-drives>

== Pnevmatik yuritma

Pnevmatik yuritma kompressor, havoni tayyorlaş bloki (filtr, bosim rostlagiçi, moylagiç), elektropnevmatik taqsimlagiç va pnevmosilindr yoki pnevmomotordan taşkil topadi. Ikki tomonlama taʼsir etuvçi silindrning itariş kuçi va zarur porşen diametri ($p$ --- ortiqça bosim, $eta$ --- işqalanişni hisobga oluvçi FIK, odatda $0.8 dots 0.9$):

$ F = p dot (pi D^2) / 4 dot eta quad arrow.double quad D >= sqrt((4 F) / (pi p eta)) $ <eq-pneu>

Bir iş sikli (oldinga va orqaga yuriş) uçun atmosfera bosimiga keltirilgan erkin havo sarfi ($s$ --- porşen yurişi, $p_a approx 0.1$ MPa --- atmosfera bosimi, ştok hajmi hisobga olinmagan):

$ V_"erk" = 2 dot (pi D^2) / 4 dot s dot (p + p_a) / p_a $ <eq-air>

== Gidravlik yuritma

Gidravlik yuritma nasos stansiyasi (nasos, moy baki, filtr, saqlaş klapani), boşqariladigan taqsimlagiç yoki servoklapan va gidrosilindr yoki gidromotordan iborat. Moy deyarli siqilmagani uçun yuritma qattiq va ravon harakatni taʼminlaydi. Gidrosilindrning asosiy parametrlari ($Q$ --- moy sarfi, $A$ --- porşen yuzasi):

$ v = Q / A, quad F = p A eta, quad N = p Q $ <eq-hyd>

bunda $v$ --- ştok tezligi, $F$ --- kuç, $N$ --- yuritmaning gidravlik quvvati.

== Elektr yuritma

Zamonaviy sanoat robotlarida asosan *servoelektr yuritmalar* işlatiladi. Ular doimiy magnitli sinxron dvigatel (PMSM) yoki çötkasiz özgarmas tok dvigateli (BLDC), servokuçaytirgiç (invertor), holat datçigi (enkoder yoki rezolver) va elektromagnit tormozdan iborat. Kiçik robotlar va öquv qurilmalarida qadamli dvigatellar va çötkali özgarmas tok dvigatellari ham uçraydi. Dvigatel tezligi yuqori, momenti esa kiçik bölgani uçun böğinga reduktor (tölqinli, sikloid, planetar) orqali ulanadi.

Zvenoni uşlab turiş uçun zarur statik moment, dvigatel momenti, tezligi va quvvati ($m$ --- yuk massasi, $l$ --- yuk markazigaça yelka, $i$ --- uzatiş soni, $eta$ --- reduktor FIK, $omega_q$ --- böğin burçak tezligi):

$ tau_q = m g l, quad tau_m = tau_q / (i eta), quad n_m = (30 omega_q i) / pi, quad P_m = tau_m omega_m $ <eq-elec>

Dinamik rejimda tezlaniş momenti ham qöşiladi, şuning uçun dvigatel hisoblangan quvvatdan 1.5–2 marta zaxira bilan tanlanadi.

== Sanoat robotlarini boşqariş tizimlari

Sanoat robotining boşqaruv tizimi odatda *ierarxik* tuzilgan:

+ *Strategik (yuqori) daraja:* vazifani tahlil qiliş, operatsiyalar ketma-ketligini va robot dasturini şakllantiriş, taşqi jihozlar bilan muvofiqlaştiriş.
+ *Taktik (örta) daraja:* trayektoriyani rejalaştiriş, teskari kinematika masalasini yeçiş, böğinlar uçun topşiriq nuqtalarini hosil qiliş.
+ *Ijro (quyi) daraja:* har bir böğin yuritmasini teskari aloqa asosida servoboşqariş (PID rostlagiç, tok, tezlik va holat konturlari).

Harakat trayektoriyasini boşqariş usuliga köra boşqaruv tizimlari @tab-ctrl dagi turlarga bölinadi.

#figure(
  btable(
    columns: (auto, 1fr, 1fr),
    align: (left + horizon, left + horizon, left + horizon),
    ([*Boşqaruv turi*], [*Tavsifi*], [*Qöllanişi*]),
    [Siklli],
    [Har bir öq faqat ikki çekka holat orasida mexanik tayançlar yoki oxirgi uzgiçlar böyiça harakatlanadi; ketma-ketlik dasturlanadi],
    [Pnevmatik manipulyatorlar, sodda yuklaş-tuşiriş],
    [Pozitsion (PTP)],
    [Işçi organ dasturlangan nuqtalarga ketma-ket olib boriladi, nuqtalar orasidagi yöl nazorat qilinmaydi],
    [Nuqtali payvandlaş, detallarni köçiriş, stanoklarga xizmat körsatiş],
    [Kontur (CP)],
    [Işçi organ butun trayektoriya böylab (töğri çiziq, aylana yoyi, splayn) berilgan tezlik bilan uzluksiz boşqariladi],
    [Yoysimon payvandlaş, böyaş, kesiş, germetik surtiş],
    [Adaptiv],
    [Datçiklar (kuç-moment, texnik köriş) maʼlumoti asosida dastur iş vaqtida tuzatiladi],
    [Tikuvni kuzatib payvandlaş, betartib joylaşgan detallarni oliş],
    [Intellektual],
    [Vazifani tuşuniş, rejalaştiriş va örganiş (sunʼiy intellekt)],
    [Kollaborativ va mobil manipulyatorlar],
  ),
  caption: [Sanoat robotlarini boşqariş tizimlarining turlari],
  placement: auto,
) <tab-ctrl>

Pozitsion va kontur boşqariş orasidagi farq @fig-ptp da körsatilgan: PTP rejimida böğinlar öz harakatini mustaqil interpolyatsiya qiladi va işçi organ egri çiziq böylab harakatlanadi, CP rejimida esa işçi organ dekart fazosida berilgan çiziqdan oğmaydi.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let pt(p, name) = {
      circle(p, radius: 0.09, fill: cacc, stroke: none)
      content((p.at(0), p.at(1) - 0.15), text(size: 9pt, name), anchor: "north")
    }
    // PTP
    let A = (0, 0)
    let B = (4.5, 0.6)
    let C = (5.5, 3.0)
    bezier(A, B, (1.5, 2.2), stroke: 1.2pt + csec)
    bezier(B, C, (6.6, 1.0), stroke: 1.2pt + csec)
    line(A, B, stroke: (paint: luma(160), dash: "dashed", thickness: 0.6pt))
    line(B, C, stroke: (paint: luma(160), dash: "dashed", thickness: 0.6pt))
    pt(A, [$P_1$])
    pt(B, [$P_2$])
    circle(C, radius: 0.09, fill: cacc, stroke: none)
    content((C.at(0) - 0.15, C.at(1)), text(size: 9pt)[$P_3$], anchor: "east")
    content((2.8, -1.0), text(size: 9pt)[a) pozitsion (PTP) boşqariş])
    // CP
    let o = 8.0
    let A2 = (o, 0)
    let B2 = (o + 4.5, 0.6)
    let C2 = (o + 5.5, 3.0)
    line(A2, B2, stroke: 1.2pt + csec)
    arc(B2, start: -60deg, stop: 40deg, radius: 1.45, stroke: 1.2pt + csec)
    pt(A2, [$P_1$])
    pt(B2, [$P_2$])
    circle((o + 4.886, 2.788), radius: 0.09, fill: cacc, stroke: none)
    content((o + 4.75, 2.85), text(size: 9pt)[$P_3$], anchor: "south-east")
    content((o + 2.8, -1.0), text(size: 9pt)[b) kontur (CP) boşqariş])
    content((o + 2.2, 0.55), text(size: 8pt)[töğri çiziq], anchor: "south")
    content((o + 5.3, 1.7), text(size: 8pt)[yoy], anchor: "west")
  }),
  caption: [Işçi organ trayektoriyasi: a) pozitsion boşqariş; b) kontur boşqariş],
) <fig-ptp>

== Robotlarni programmali boşqariş

Robot dasturi işçi organ ötişi kerak bölgan nuqtalar, harakat turlari, tezliklar va taşqi jihozlar bilan almaşinadigan signallar ketma-ketligidan iborat. Dasturlaşning asosiy usullari:

- *Örgatiş usuli (_teach-in_):* operator qölda boşqariş pulti yordamida robotni kerakli nuqtalarga olib boradi va ularni xotiraga yozadi. Sodda va işonçli, ammo dasturlaş vaqtida robot işlab çiqarişdan çetlatiladi.
- *Qölda yetaklaş (_lead-through_):* operator manipulyatorni qöli bilan yetaklab harakatni yozadi. Asosan böyaş robotlari va kollaborativ robotlarda qöllaniladi.
- *Off-line dasturlaş:* dastur kompyuterda, robot va iş joyining 3D modeli asosida simulyatsiya muhitida tuziladi va tekşiriladi (masalan, RoboDK, ABB RobotStudio). Robot işlab çiqarişdan töxtatilmaydi, murakkab trayektoriyalarni CAD modeldan avtomatik oliş mumkin.
- *Matnli dasturlaş:* işlab çiqaruvçining robot tilida dastur yoziladi: ABB --- RAPID, KUKA --- KRL, Fanuc --- TP va KAREL, Yaskawa --- INFORM. Zamonaviy tizimlarda Python va ROS (_Robot Operating System_) orqali boşqariş ham keng tarqalgan.

Robot dasturidagi harakat buyruqlari odatda uç turda böladi: böğin interpolyatsiyasi (PTP, masalan `MoveJ`), töğri çiziqli harakat (`MoveL`) va aylana yoyi böylab harakat (`MoveC`). Quyida ABB RAPID tilidagi detalni olib qöyiş dasturining soddalaştirilgan namunasi keltirilgan (@lst-rapid).

#figure(
  ```text
  MoveJ pYuqori1, v1000, z50, tool0;  ! detal ustiga yaqinlashish
  MoveL pOlish, v200, fine, tool0;    ! detalga tushish
  SetDO doQisqich, 1;                 ! qisqichni yopish
  WaitTime 0.5;
  MoveL pYuqori1, v500, z10, tool0;   ! yuqoriga koʻtarilish
  MoveJ pYuqori2, v1000, z50, tool0;  ! qoʻyish joyi ustiga
  MoveL pQoyish, v200, fine, tool0;
  SetDO doQisqich, 0;                 ! qisqichni ochish
  MoveL pYuqori2, v500, z10, tool0;
  ```,
  caption: [ABB RAPID tilida olib qöyiş dasturi (soddalaştirilgan)],
) <lst-rapid>

Bunda `v1000` --- tezlik (mm/s), `z50` --- nuqta yonidan 50 mm radius bilan silliq ötiş zonasi, `fine` --- nuqtaga aniq töxtaş, `tool0` --- asbob koordinatalar tizimi.

== Mobil robototexnik tizimlar

*Mobil robot* --- iş muhitida öz-özidan harakatlana oladigan robot. Sanoat va logistikada ikki asosiy turi qöllaniladi:

- *AGV* (_Automated Guided Vehicle_) --- avtomatik boşqariladigan transport aravaçasi. U polga yopiştirilgan magnit lenta, induktiv sim, QR-kodlar yoki lazer reflektorlari bilan belgilangan qatʼiy yönaliş böyiça harakatlanadi; tösiqqa duç kelsa töxtaydi.
- *AMR* (_Autonomous Mobile Robot_) --- avtonom mobil robot. U lazerli skaner (LiDAR), kamera va boşqa datçiklar yordamida muhit xaritasini tuzadi, öz holatini aniqlaydi va yölni mustaqil rejalaştiradi; tösiqni aylanib ötadi.

Mobil robototexnik tizimning tuzilişi @fig-mobile da keltirilgan. Robot holatini (lokalizatsiya) aniqlaş uçun ğildirak enkoderlari böyiça hisoblangan *odometriya* LiDAR va inersial datçik (IMU) maʼlumotlari bilan Kalman filtri yoki zarraçalar filtri yordamida birlaştiriladi. Xarita va holatni bir vaqtda aniqlaş masalasi *SLAM* (_Simultaneous Localization and Mapping_) deb ataladi.

#figure(
  cetz.canvas(length: 0.85cm, {
    import cetz.draw: *
    set-style(content: (padding: 1pt))
    let bx(c, w, h, body, fill: white) = {
      rect(
        (c.at(0) - w / 2, c.at(1) - h / 2),
        (c.at(0) + w / 2, c.at(1) + h / 2),
        fill: fill,
        stroke: 0.9pt + cprim,
        radius: 2pt,
      )
      content(c, align(center, text(size: 8pt, body)))
    }
    let ar(..pts) = line(..pts, stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.55))

    bx((1.5, 2.0), 3.0, 2.6, fill: luma(240))[*Datçiklar* \ LiDAR, kamera, \ IMU, enkoderlar, \ ultratovuş]
    bx((5.6, 2.9), 3.0, 1.0, fill: csec.lighten(85%))[Lokalizatsiya \ va xaritalaş (SLAM)]
    bx((5.6, 1.1), 3.0, 1.0)[Tösiqlarni \ aniqlaş]
    bx((9.6, 2.0), 2.8, 1.2, fill: csec.lighten(85%))[Yölni \ rejalaştiriş]
    bx((13.2, 2.0), 2.6, 1.2)[Harakatni \ boşqariş]
    bx((9.6, 4.2), 2.8, 0.9, fill: luma(240))[Topşiriq \ (flot tizimi)]
    bx((13.2, -0.2), 2.6, 0.9, fill: cacc.lighten(88%))[Yuritmalar, \ ğildiraklar]

    ar((3.0, 2.9), (4.1, 2.9))
    ar((3.0, 1.1), (4.1, 1.1))
    ar((7.1, 2.9), (8.2, 2.3))
    ar((7.1, 1.1), (8.2, 1.7))
    ar((11.0, 2.0), (11.9, 2.0))
    ar((9.6, 3.75), (9.6, 2.6))
    ar((13.2, 1.4), (13.2, 0.25))
    line((11.9, -0.2), (1.5, -0.2), stroke: (paint: luma(120), dash: "dashed", thickness: 0.7pt))
    ar((1.5, -0.2), (1.5, 0.7))
    content((6.5, -0.25), text(size: 7pt, fill: cacc)[harakat natijasi (odometriya)], anchor: "north")
  }),
  caption: [Avtonom mobil robotning (AMR) boşqaruv tizimi tuzilişi],
  placement: auto,
) <fig-mobile>

Mobil robot akkumulyator bilan işlaydi. Bir marta zaryadlaşda işlaş vaqti ($U$ --- kuçlaniş, $C$ --- siğim, $k$ --- ruxsat etilgan razryad çuqurligi, $P_"ör"$ --- örtaça isteʼmol quvvati):

$ t = (k U C) / P_"ör" $ <eq-battery>

= Namunaviy masalalar va ularning yeçimlari

== Masala 1: Pnevmatik silindrni tanlaş

*Masala şarti:* qisqiç yuritmasi $F = 400$ N kuç hosil qilişi kerak. Tarmoq bosimi $p = 0.6$ MPa, FIK $eta = 0.85$, porşen yurişi $s = 100$ mm. Robot minutiga 20 ta sikl bajaradi.

#set enum(numbering: "a)")
+ Silindrning zarur diametrini toping va standart qiymatni tanlang (10, 12, 16, 20, 25, 32, 40, 50 mm).
+ Bir sikldagi va bir minutdagi erkin havo sarfini aniqlang.
#set enum(numbering: "1.")

*Hisoblaş bosqiçlari:*

- *Diametr* (@eq-pneu):
  $ D >= sqrt((4 dot 400) / (pi dot 0.6 dot 10^6 dot 0.85)) = sqrt(9.99 dot 10^(-4)) approx 0.0316 "m" $
  Standart qatordan $D = 32$ mm tanlanadi. Tekşiriş: $F = 0.6 dot 10^6 dot 8.04 dot 10^(-4) dot 0.85 approx 410 "N" > 400 "N"$.

- *Havo sarfi* (@eq-air), $A = pi dot 0.032^2 \/ 4 approx 8.04 dot 10^(-4) "m"^2$:
  $
    V_"erk" = 2 dot 8.04 dot 10^(-4) dot 0.1 dot (0.6 + 0.1) / 0.1 \
    approx 1.13 dot 10^(-3) "m"^3 = 1.13 "l"
  $
  Bir minutdagi sarf: $Q = 1.13 dot 20 approx 22.5$ l/min.

*Javob:* $D = 32$ mm; $V_"erk" approx 1.13$ l/sikl; $Q approx 22.5$ l/min.

== Masala 2: Gidrosilindrning parametrlari

*Masala şarti:* oğir yuk robotining gidrosilindri diametri $D = 50$ mm, nasosning moy sarfi $Q = 12$ l/min, işçi bosim $p = 10$ MPa, FIK $eta = 0.9$. Ştok tezligini, kuçini va gidravlik quvvatni toping.

*Hisoblaş bosqiçlari* (@eq-hyd):

- *Porşen yuzasi va sarf:* $A = pi dot 0.05^2 \/ 4 approx 1.963 dot 10^(-3) "m"^2$; $Q = 12 dot 10^(-3) \/ 60 = 2 dot 10^(-4) "m"^3"/s"$.
- *Tezlik:*
  $ v = (2 dot 10^(-4)) / (1.963 dot 10^(-3)) approx 0.102 "m/s" $
- *Kuç:*
  $ F = 10 dot 10^6 dot 1.963 dot 10^(-3) dot 0.9 approx 17.7 dot 10^3 "N" = 17.7 "kN" $
- *Quvvat:*
  $ N = 10 dot 10^6 dot 2 dot 10^(-4) = 2000 "Vt" = 2 "kVt" $

*Javob:* $v approx 0.10$ m/s; $F approx 17.7$ kN; $N = 2$ kVt.

Natijani Masala 1 bilan soliştiring: bir xil diametrli silindr gidravlik yuritmada pnevmatik yuritmadagiga qaraganda taxminan bosimlar nisbatiça, yaʼni $10 \/ 0.6 approx 17$ marta katta kuç hosil qiladi.

== Masala 3: Elektr yuritmaning dvigatelini tanlaş

*Masala şarti:* robot böğini $l = 0.6$ m yelkada joylaşgan $m = 5$ kg yukni gorizontal holatda uşlab turişi va $omega_q = 90 degree"/s"$ tezlik bilan burişi kerak. Reduktorning uzatiş soni $i = 100$, FIK $eta = 0.8$. Zvenoning öz massasi hisobga olinmasin.

*Hisoblaş bosqiçlari* (@eq-elec):

- *Böğindagi statik moment:*
  $ tau_q = 5 dot 9.81 dot 0.6 approx 29.4 "N" dot "m" $
- *Dvigatel momenti:*
  $ tau_m = 29.4 / (100 dot 0.8) approx 0.368 "N" dot "m" $
- *Dvigatel tezligi:* $omega_q = 90 degree"/s" = 1.571$ rad/s, $omega_m = 157.1$ rad/s:
  $ n_m = (30 dot 1.571 dot 100) / pi = 1500 "ayl/min" $
- *Quvvat:*
  $ P_m = 0.368 dot 157.1 approx 57.8 "Vt" $
  Dinamik zaxirani hisobga olib ($times 1.5 dots 2$), nominal quvvati 100 Vt va tezligi kamida 1500 ayl/min bölgan servodvigatel tanlanadi.

*Javob:* $tau_m approx 0.37$ N·m; $n_m = 1500$ ayl/min; $P_m approx 58$ Vt, tanlangan dvigatel 100 Vt.

== Masala 4: Mobil robotning akkumulyator bilan işlaş vaqti

*Masala şarti:* AMR robotining akkumulyatori 24 V, 40 A·soat. Ruxsat etilgan razryad çuqurligi $k = 0.8$, robotning örtaça isteʼmol quvvati $P_"ör" = 150$ Vt. Bir marta zaryadlaşda işlaş vaqtini toping.

*Hisoblaş* (@eq-battery):
$ t = (0.8 dot 24 dot 40) / 150 = 768 / 150 approx 5.1 "soat" $

*Javob:* $t approx 5.1$ soat; uç smenali işda robot smena davomida kamida bir marta qayta zaryadlanişi kerak.

= Individual amaliy topşiriqlar

Har bir talaba öz variant raqamiga mos maʼlumotlar (@tab-var-a va @tab-var-b) böyiça quyidagilarni bajarişi lozim:

+ Pnevmatik silindr diametrini hisoblaş, standart qiymatni tanlaş va minutiga $z$ sikl uçun havo sarfini aniqlaş ($eta = 0.85$).
+ Gidrosilindrning tezligi, kuçi va quvvatini hisoblaş ($eta = 0.9$).
+ Elektr yuritma uçun böğin va dvigatel momenti, dvigatel tezligi va quvvatini hisoblaş, dvigatelni tanlaş ($eta = 0.8$).
+ Mobil robotning bir marta zaryadlaşda işlaş vaqtini aniqlaş ($k = 0.8$).
+ @tab-ctrl dan foydalanib, öz variantingizdagi robot vazifasi uçun boşqaruv turini va dasturlaş usulini asoslab tanlaş.

#figure(
  btable(
    columns: (auto, auto, auto, auto, auto, auto, auto, auto),
    (
      [*Var.*],
      [*$F$ \ \[N\]*],
      [*$p$ \ \[MPa\]*],
      [*$s$ \ \[mm\]*],
      [*$z$ \ \[sikl/min\]*],
      [*$D_h$ \ \[mm\]*],
      [*$Q$ \ \[l/min\]*],
      [*$p_h$ \ \[MPa\]*],
    ),
    [*1*],
    [250],
    [0.5],
    [80],
    [15],
    [40],
    [8],
    [12],
    [*2*],
    [600],
    [0.6],
    [120],
    [10],
    [63],
    [20],
    [16],
    [*3*],
    [150],
    [0.4],
    [50],
    [30],
    [32],
    [6],
    [10],
    [*4*],
    [800],
    [0.7],
    [150],
    [12],
    [80],
    [30],
    [20],
    [*5*],
    [350],
    [0.6],
    [100],
    [25],
    [50],
    [10],
    [14],
    [*6*],
    [500],
    [0.5],
    [60],
    [20],
    [63],
    [15],
    [12],
    [*7*],
    [200],
    [0.6],
    [40],
    [40],
    [40],
    [9],
    [18],
    [*8*],
    [1000],
    [0.8],
    [200],
    [8],
    [100],
    [40],
    [25],
    [*9*],
    [450],
    [0.7],
    [90],
    [18],
    [50],
    [12],
    [16],
    [*10*],
    [300],
    [0.4],
    [70],
    [22],
    [32],
    [5],
    [10],
  ),
  caption: [Individual topşiriqlar: pnevmatik va gidravlik yuritmalar],
) <tab-var-a>

#figure(
  btable(
    columns: (auto, auto, auto, auto, auto, auto, auto, auto, 1fr),
    (
      [*Var.*],
      [*$m$ \ \[kg\]*],
      [*$l$ \ \[m\]*],
      [*$i$*],
      [*$omega_q$ \ \[°/s\]*],
      [*$U$ \ \[V\]*],
      [*$C$ \ \[A·soat\]*],
      [*$P_"ör"$ \ \[Vt\]*],
      [*Robot vazifasi*],
    ),
    [*1*],
    [3],
    [0.5],
    [80],
    [120],
    [24],
    [30],
    [120],
    [Nuqtali payvandlaş],
    [*2*],
    [8],
    [0.7],
    [120],
    [60],
    [48],
    [50],
    [300],
    [Yoysimon payvandlaş],
    [*3*],
    [2],
    [0.4],
    [50],
    [180],
    [24],
    [20],
    [90],
    [Detallarni saralaş],
    [*4*],
    [10],
    [0.8],
    [160],
    [45],
    [48],
    [80],
    [400],
    [Avtomobil kuzovini böyaş],
    [*5*],
    [4],
    [0.6],
    [100],
    [90],
    [24],
    [40],
    [160],
    [Stanokka xizmat körsatiş],
    [*6*],
    [6],
    [0.5],
    [120],
    [75],
    [36],
    [60],
    [250],
    [Germetik surtiş],
    [*7*],
    [1.5],
    [0.35],
    [50],
    [200],
    [24],
    [25],
    [100],
    [Elektronika yiğiş],
    [*8*],
    [12],
    [0.9],
    [160],
    [40],
    [48],
    [100],
    [450],
    [Tikuvni kuzatib payvandlaş],
    [*9*],
    [5],
    [0.65],
    [100],
    [80],
    [36],
    [45],
    [200],
    [Qutilarni taxlaş],
    [*10*],
    [7],
    [0.75],
    [120],
    [60],
    [48],
    [70],
    [350],
    [Lazerli kesiş],
  ),
  caption: [Individual topşiriqlar: elektr yuritma, mobil robot va boşqaruv turi],
  placement: auto,
) <tab-var-b>

= Nazorat savollari

+ Robot yuritmasi qanday asosiy elementlardan taşkil topadi?
+ Pnevmatik, gidravlik va elektr yuritmalarning afzalliklari va kamçiliklarini taqqoslang.
+ Nima uçun pnevmatik yuritmada oraliq holatlarda aniq pozitsiyalaş qiyin?
+ Servoelektr yuritma qanday qismlardan iborat? Nima uçun dvigatel böğinga reduktor orqali ulanadi?
+ Robot boşqaruv tizimining ierarxik darajalari qanday vazifalarni bajaradi?
+ Siklli, pozitsion va kontur boşqariş tizimlari qanday farqlanadi? Har biriga misol keltiring.
+ Robotlarni dasturlaşning qanday usullari mavjud? Off-line dasturlaşning afzalligi nimada?
+ AGV va AMR robotlarining farqi nimada? SLAM deganda nima tuşuniladi?
