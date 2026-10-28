// ============================================================
//  Robotlar va robototexnik tizimlar — 5-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_5.typ
// ============================================================

#import "@preview/cetz:0.4.2"

#let headingblue = rgb(20, 50, 120)

#set document(title: "RM-01 sanoat robotining işlaş prinsipini örganiş")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 5  // amaliyot raqami
#set document(keywords: (info.fan,))
#set page(header: context {
  set text(size: 9pt, fill: luma(110))
  grid(
    columns: (1fr, auto, 1fr),
    align: (left, center, right),
    info.fan, info.semestr, [Amaliyot №#raqam],
  )
  v(-0.5em)
  line(length: 100%, stroke: 0.4pt + luma(170))
})
// ===================
#set text(size: 12pt, lang: "uz")
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №5]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[Mavzu: RM-01 sanoat robotining işlaş prinsipini örganiş]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* talabalarni *RM-01* antropomorf sanoat robotining tuzilişi, kinematik sxemasi, ikki poğonali boşqaruv tizimining işlaş prinsipi, qölda boşqariş pulti (PRU) rejimlari hamda *ARPS* tilida örgatiş (_teach-in_) usuli bilan dasturlaş asoslari bilan taniştiriş, şuningdek robot iş jarayonini tavsiflovçi asosiy kinematik va boşqaruv kattaliklarini hisoblaş könikmalarini şakllantiriş.

*Öquv vazifalari va kutilayotgan natijalar:*

- *Konstruksiya va texnik tavsif:* RM-01 robotining zvenolari, kinematik juftliklari, yuritmalari va datçiklarining vazifasini tuşuntiriş, texnik körsatkiçlarini tahlil qiliş.
- *Kinematika:* Denavit–Hartenberg (D-H) parametrlari asosida bilak markazining koordinatalarini ($P_x, P_y, P_z$) hisoblaş va sferik bilak tufayli yuzaga keladigan kinematik ajratiş (_decoupling_) tamoyilini tuşuniş.
- *Boşqaruv tizimi:* yuqori (markaziy EHM) va quyi (böğin mikroprotsessorlari) darajalar vazifalarini farqlaş; interpolyatsiya, enkoder ajratiş qobiliyati va tezlikni raqamli baholaş kattaliklarini hisoblaş.
- *Dasturlaş:* PRU ning COMP, JOINT, WORLD, TOOL va FREE rejimlaridan foydalaniş, nuqtalarni `HERE` buyruği bilan örgatiş hamda ARPS tilida “olib qöyiş” (_pick-and-place_) dasturini tuziş.

= Nazariy asoslar va analitik formulalar

== RM-01 robotining vazifasi va tuzilişi

*RM-01* --- universal antropomorf sanoat roboti bölib, *Unimation PUMA 560* robotining analogi hisoblanadi. U dastlab yiğiş operatsiyalarini bajariş uçun dasturlanadigan universal manipulyator sifatida işlab çiqilgan. Robot yuqori mexanik aniqlikda tayyorlangani va yetarliça quvvatli özgarmas tok yuritmalari bilan ajralib turadi; u asosiy texnologik va qisman transport operatsiyalarini bajaradi, imkoniyatlari esa manipulyatorga avtomatik örnatiladigan asboblar komplekti hisobiga kengaytirilgan. Hozirgi kunda RM-01 köplab oliy taʼlim muassasalarida öquv-laboratoriya roboti sifatida qöllaniladi.

Manipulyator *oltita erkinlik darajasiga* ega. Oltita zveno va asos özaro oltita V sinf aylanma kinematik juftlikni hosil qiladi (6R mexanizm). Zvenolarning vazifalari quyidagiça:

+ *1-böğin (ustun):* manipulyatorni vertikal öq atrofida buriş;
+ *2-böğin (yelka)* va *3-böğin (tirsak):* gorizontal öqlar atrofida burilib, bilakni vertikal tekislikda joylaştiriş;
+ *4-, 5-, 6-böğinlar (bilak):* asbobning fazodagi orientatsiyasini taʼminlaş.

4-, 5- va 6-böğinlar öqlari bitta nuqtada kesişadi va özaro perpendikulyar joylaşgan --- bunday tuzilma *sferik bilak* deb ataladi. Şuningdek, PUMA 560 oilasidagi robotlarda bilakdagi tişli uzatmalar 4–6-böğinlar harakatini özaro boğlaydi, şu sababli bu böğinlar uçun *yuritma fazosi* va *böğin fazosi* farqlanadi. Robotning asosiy texnik körsatkiçlari @tab-spec da keltirilgan.

#figure(
  btable(
    columns: (auto, 1fr),
    align: (left + horizon, left + horizon),
    ([*Körsatkiç*], [*Qiymati*]),
    [Erkinlik darajalari soni],
    [6 (barça böğinlar aylanma, 6R)],
    [Kinematik turi],
    [Antropomorf (burçakli), sferik bilakli],
    [Maksimal yuk kötariş qobiliyati],
    [2.5 kg],
    [Manipulyator massasi],
    [53 kg],
    [Asbob işçi nuqtasidagi statik kuç],
    [60 N gaça],
    [Takroriy pozitsiyalaş aniqligi],
    [0.1 mm],
    [Bilak markazining erişiş radiusi],
    [$approx 864$ mm],
    [Yuritmalar],
    [Özgarmas tok elektr dvigatellari (elektromagnit tormozli)],
    [Teskari aloqa datçiklari],
    [Inkremental fotoimpulsli enkoder va potensiometr],
    [Boşqaruv qurilmasi],
    [“Sfera-36” (ikki poğonali ierarxik tizim)],
    [Dasturlaş tili],
    [ARPS (_Advanced Robot Programming System_)],
  ),
  caption: [RM-01 robotining asosiy texnik körsatkiçlari],
) <tab-spec>

Zvenolar faqat qatʼiy belgilangan diapazonda harakatlana oladi (@tab-limits).

#figure(
  btable(
    columns: (auto, 1fr, auto, auto),
    align: (center + horizon, left + horizon, center + horizon, center + horizon),
    ([*Böğin*], [*Harakat turi*], [*$q_(i,min)$*], [*$q_(i,max)$*]),
    [1],
    [Ustunning vertikal öq atrofida burilişi],
    [$-160 degree$],
    [$+160 degree$],
    [2],
    [Yelka zvenosining burilişi],
    [$-255 degree$],
    [$+45 degree$],
    [3],
    [Tirsak zvenosining burilişi],
    [$-45 degree$],
    [$+225 degree$],
    [4],
    [Bilakning böylama öq atrofida burilişi],
    [$-110 degree$],
    [$+170 degree$],
    [5],
    [Bilakning egilişi],
    [$-100 degree$],
    [$+100 degree$],
    [6],
    [Flanetsning aylanişi],
    [$-266 degree$],
    [$+266 degree$],
  ),
  caption: [RM-01 böğinlarining harakat diapazonlari (işlab çiqaruvçi şkalasida)],
) <tab-limits>

== Kinematik sxema va D-H parametrlari

RM-01 manipulyatorining kinematik sxemasi @fig-kin da körsatilgan.

#figure(
  cetz.canvas(length: 0.9cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let jc = cprim
    // revolute joint (o'q chizma tekisligiga perpendikulyar)
    let rj(p) = {
      circle(p, radius: 0.28, fill: white, stroke: 1.2pt + jc)
      circle(p, radius: 0.07, fill: jc, stroke: none)
    }
    // o'q chizma tekisligida yotgan aylanma boʻgʻin
    let aj(c, w, h) = rect(
      (c.at(0) - w / 2, c.at(1) - h / 2),
      (c.at(0) + w / 2, c.at(1) + h / 2),
      fill: csec.lighten(70%),
      stroke: 1.2pt + jc,
    )

    // Asos va pol
    line((-1.6, 0), (1.6, 0), stroke: 1.2pt)
    for k in range(8) {
      let x = -1.5 + k * 0.4
      line((x, 0), (x - 0.3, -0.3), stroke: 0.6pt)
    }
    rect((-0.9, 0), (0.9, 0.35), fill: luma(200), stroke: 1pt)
    // Ustun
    rect((-0.35, 0.35), (0.35, 2.7), fill: luma(225), stroke: 1pt)
    // J1 o'qi
    line((0, -0.5), (0, 4.0), stroke: (paint: luma(120), dash: "dash-dotted", thickness: 0.6pt))
    aj((0, 1.5), 0.95, 0.4)
    content((0.55, 1.5), [$J_1$], anchor: "west")
    // Yelka kronshteyni
    line((0, 2.7), (0, 3.0), stroke: 3pt + luma(90))
    // Yelka zvenosi
    line((0, 3.0), (3.0, 3.0), stroke: 4pt + csec)
    rj((0, 3.0))
    content((-0.35, 3.1), [$J_2$], anchor: "east")
    // Tirsak
    line((3.0, 3.0), (3.0, 6.0), stroke: 3.2pt + cacc)
    rj((3.0, 3.0))
    content((3.35, 2.85), [$J_3$], anchor: "west")
    // J4
    line((3.0, 3.6), (3.0, 6.6), stroke: (paint: luma(120), dash: "dash-dotted", thickness: 0.6pt))
    aj((3.0, 4.6), 0.75, 0.38)
    content((3.45, 4.6), [$J_4$], anchor: "west")
    // J5 (bilak markazi)
    rj((3.0, 6.0))
    content((2.65, 6.0), [$J_5$, $W$], anchor: "east")
    // J6 va tutqich
    line((3.0, 6.28), (3.0, 6.55), stroke: 2pt + luma(60))
    aj((3.0, 6.68), 0.55, 0.26)
    content((2.65, 6.68), [$J_6$], anchor: "east")
    line((2.7, 6.81), (3.3, 6.81), stroke: 1.5pt)
    line((2.7, 6.81), (2.7, 7.3), stroke: 1.5pt)
    line((3.3, 6.81), (3.3, 7.3), stroke: 1.5pt)
    circle((3.0, 7.2), radius: 0.07, fill: red, stroke: none)
    content((3.4, 7.3), text(size: 9pt)[TCP], anchor: "west")

    // O'lchamlar
    line((0, 2.35), (3.0, 2.35), stroke: 0.8pt + cacc, mark: (start: ">", end: ">", fill: cacc, scale: 0.6))
    content((1.5, 2.35), [$a_2$], anchor: "north")
    line((4.6, 3.0), (4.6, 6.0), stroke: 0.8pt + cacc, mark: (start: ">", end: ">", fill: cacc, scale: 0.6))
    content((4.65, 4.5), [$d_4$], anchor: "west")
    line((3.35, 6.0), (4.8, 6.0), stroke: (paint: luma(150), dash: "dotted"))
    line((3.9, 3.0), (4.8, 3.0), stroke: (paint: luma(150), dash: "dotted"))

    // Izoh
    content((9.0, 3.6), box(
      fill: luma(245),
      stroke: 0.6pt + csec,
      radius: 3pt,
      inset: 6pt,
      align(left, text(size: 9pt)[
        $J_1$: ustun burilişi \
        $J_2$: yelka, $J_3$: tirsak \
        $J_4, J_5, J_6$: sferik bilak \
        $W$: bilak markazi \
        $a_2$: yelka zvenosi uzunligi \
        $d_4$: tirsak zvenosi uzunligi \
        $d_3$: yelkaning yon siljişi \
        #h(1.2em) (çizma tekisligiga \
        #h(1.2em) perpendikulyar)
      ]),
    ))
  }),
  caption: [RM-01 manipulyatorining kinematik sxemasi (barça böğin burçaklari nolga teng holat)],
  placement: auto,
) <fig-kin>

Standart D-H konvensiyasi böyiça RM-01 (PUMA 560) manipulyatorining parametrlari @tab-dh da berilgan. ${0}$ freym 1- va 2-böğin öqlarining kesişiş nuqtasiga (yelka markaziga) joylaştirilgan; yelkaning poldan balandligi $h_0$ alohida bazaviy transformatsiya $T_0^"base" = bold("Trans")_(z, h_0)$ orqali hisobga olinadi. D-H böyiça nol holat işlab çiqaruvçi şkalasidagi noldan farq qilişi mumkin.

#figure(
  btable(
    columns: 5,
    ([*Böğin $i$*], [*$a_i$ \[mm\]*], [*$alpha_i$*], [*$d_i$ \[mm\]*], [*$theta_i$*]),
    [1],
    [0],
    [$+90 degree$],
    [0],
    [$theta_1^*$],
    [2],
    [$a_2 = 431.8$],
    [$0$],
    [0],
    [$theta_2^*$],
    [3],
    [$a_3 = 20.3$],
    [$-90 degree$],
    [$d_3 = 150.05$],
    [$theta_3^*$],
    [4],
    [0],
    [$+90 degree$],
    [$d_4 = 431.8$],
    [$theta_4^*$],
    [5],
    [0],
    [$-90 degree$],
    [0],
    [$theta_5^*$],
    [6],
    [0],
    [$0$],
    [0],
    [$theta_6^*$],
  ),
  caption: [RM-01 (PUMA 560) manipulyatorining standart D-H parametrlari],
) <tab-dh>

Töliq töğri kinematika ikki qismga ajraladi:

$
  T_6^0 = underbrace(A_1^0 A_2^1 A_3^2, T_3^0 (theta_1, theta_2, theta_3)) dot underbrace(A_4^3 A_5^4 A_6^5, T_6^3 (theta_4, theta_5, theta_6))
$ <eq-split>

Sferik bilak tufayli bilak markazi $W$ ning holati faqat dastlabki uçta burçakka boğliq. @tab-dh dagi parametrlar bilan $A_1^0 A_2^1 A_3^2 A_4^3$ köpaytmasining pozitsiya ustunidan quyidagi ifodalar olinadi ($c_i = cos theta_i$, $s_i = sin theta_i$, $c_(23) = cos(theta_2 + theta_3)$, $s_(23) = sin(theta_2 + theta_3)$):

$ r = a_2 c_2 + a_3 c_(23) - d_4 s_(23) $ <eq-r>

$ P_x = c_1 r + d_3 s_1, quad P_y = s_1 r - d_3 c_1, quad P_z = a_2 s_2 + a_3 s_(23) + d_4 c_(23) $ <eq-wc>

Bilak markazining maksimal erişiş radiusi yelka va tirsak zvenolari bir çiziqqa çözilganda yuzaga keladi:

$ R_max = sqrt(d_3^2 + (a_2 + sqrt(a_3^2 + d_4^2))^2) $ <eq-rmax>

Bu ajratiş teskari kinematika masalasini ham ikkiga böladi: avval $W$ ning berilgan holati böyiça $theta_1, theta_2, theta_3$ topiladi (pozitsiya masalasi), söngra $R_6^3 = (R_3^0)^T R_6^0$ böyiça $theta_4, theta_5, theta_6$ aniqlanadi (orientatsiya masalasi). PUMA 560 tipidagi manipulyator ayrim maqsadli holatlarga *sakkiztagaça* turli konfiguratsiyada yetib borişi mumkin: “çap/öng yelka”, “tirsak yuqorida/pastda” va “bilak aylantirilgan/aylantirilmagan” kombinatsiyalari.

== Boşqaruv tizimining tuzilişi va işlaş prinsipi

RM-01 boşqaruv tizimi *ikki poğonali ierarxik* tamoyil asosida qurilgan (@fig-ctrl).

#figure(
  cetz.canvas(length: 0.8cm, {
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
      content(c, align(center, text(size: 7.5pt, body)))
    }
    let ar(..pts) = line(..pts, stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.55))
    let lb(p, body, anchor: "south") = content(p, text(size: 7pt, fill: cacc, body), anchor: anchor)

    // Quyi daraja ramkasi
    rect((-0.35, -1.75), (14.85, 3.2), stroke: (paint: csec, dash: "dashed", thickness: 0.7pt), radius: 3pt)
    content(
      (14.75, -1.68),
      text(size: 7.5pt, fill: csec)[Quyi daraja: har bir böğin uçun ($times 6$)],
      anchor: "south-east",
    )

    // Yuqori daraja
    bx((4.5, 5.0), 5.4, 2.0, fill: csec.lighten(85%))[
      *Markaziy EHM (yuqori daraja)* \
      ARPS dasturini talqin qiliş, \
      teskari kinematika, \
      trayektoriya generatsiyasi
    ]
    bx((10.9, 5.65), 4.6, 0.55)[Videoterminal, NGMD]
    bx((10.9, 5.0), 4.6, 0.55)[Qölda boşqariş pulti (PRU)]
    bx((10.9, 4.35), 4.6, 0.55)[Kiriş/çiqiş liniyalari]
    ar((8.6, 5.65), (7.2, 5.65))
    ar((8.6, 5.0), (7.2, 5.0))
    line((8.6, 4.35), (7.2, 4.35), stroke: 0.8pt, mark: (start: ">", end: ">", fill: black, scale: 0.55))
    content((13.3, 4.35), text(size: 7pt)[konveyer, stanok], anchor: "west")

    // Quyi daraja qatori
    bx((1.6, 2.2), 3.2, 1.3, fill: cacc.lighten(85%))[*Böğin* \ *mikroprotsessori* \ (interpolyatsiya, PID)]
    bx((4.6, 2.2), 1.4, 1.1)[RAÖ \ (DAC)]
    bx((6.9, 2.2), 2.1, 1.1)[Tok \ kuçaytirgiçi]
    bx((9.4, 2.2), 1.8, 1.1)[DC motor \ + tormoz]
    bx((11.7, 2.2), 1.4, 1.1)[Reduktor \ ($i$)]
    bx((13.8, 2.2), 1.4, 1.1)[Zveno]
    ar((3.2, 2.2), (3.9, 2.2))
    lb((3.55, 2.25), [$u_k$])
    ar((5.3, 2.2), (5.85, 2.2))
    ar((7.95, 2.2), (8.5, 2.2))
    lb((8.22, 2.25), [$i_a$])
    ar((10.3, 2.2), (11.0, 2.2))
    lb((10.65, 2.25), [$tau_m$])
    ar((12.4, 2.2), (13.1, 2.2))
    lb((12.75, 2.25), [$q$])

    // Yuqoridan pastga
    ar((2.4, 4.0), (2.4, 2.85))
    content((2.5, 3.45), text(size: 7pt, fill: cacc)[$q_d$ (har $T_h$ da)], anchor: "west")

    // Enkoder kanali
    bx((9.4, 0.4), 2.3, 0.85)[Inkremental \ enkoder]
    bx((5.3, 0.4), 3.0, 0.85)[Reversiv \ hisoblagiç]
    ar((9.4, 1.65), (9.4, 0.83))
    ar((8.25, 0.4), (6.8, 0.4))
    lb((7.52, 0.45), [impulslar])
    line((3.8, 0.4), (2.2, 0.4), stroke: 0.8pt)
    ar((2.2, 0.4), (2.2, 1.55))

    // Potensiometr kanali
    bx((13.8, -0.9), 2.0, 0.8)[Potensiometr]
    bx((5.3, -0.9), 3.0, 0.8)[ARÖ (ADC)]
    ar((13.8, 1.65), (13.8, -0.5))
    ar((12.8, -0.9), (6.8, -0.9))
    lb((9.8, -0.85), [absolyut holat (işga tuşirişda)])
    line((3.8, -0.9), (0.8, -0.9), stroke: 0.8pt)
    ar((0.8, -0.9), (0.8, 1.55))
  }),
  caption: [RM-01 (PUMA 560) boşqaruv tizimining ikki poğonali ierarxik tuzilişi],
  placement: auto,
) <fig-ctrl>

*Yuqori daraja (markaziy EHM)* robot dasturini satrma-satr talqin qiladi. Harakat buyruği kelganda u teskari kinematikani yeçadi, trayektoriyani rejalaştiradi va har $T_h$ vaqtda böğin kontrollerlariga yangi topşiriq nuqtasini ($q_d$) yuboradi. Unga videoterminal, gibkiy magnit disklar yiğuvçisi (NGMD), qölda boşqariş pulti hamda taşqi jihozlarni (konveyer, stanok, payvandlaş qurilmasi) boşqaruvçi kiriş/çiqiş liniyalari ulanadi.

*Quyi daraja* har bir böğin uçun alohida mikroprotsessordan iborat. Analog PUMA 560 robotining boşqaruv tizimida yuqori daraja topşiriqni har $T_h = 28$ ms da yuboradi, böğin mikroprotsessorlari esa $T_s = 0.875$ ms tsikl bilan işlaydi. Har bir servo tsiklda mikroprotsessor: (1) topşiriq nuqtalari orasini interpolyatsiya qiladi, (2) enkoder hisoblagiçidan haqiqiy holatni öqib xatolikni hisoblaydi, (3) PID qonuni böyiça boşqaruv signalini hosil qiladi va (4) uni RAÖ orqali tok kuçaytirgiçiga beradi. Dvigatel yakor toki analog sxemada stabillanadi. Bir $T_h$ oraliğidagi interpolyatsiya qadamlari soni:

$ N = T_h / T_s $ <eq-N>

Çiziqli interpolyatsiyada $j$-va $(j+1)$-topşiriq nuqtalari orasidagi oraliq qiymatlar (@fig-interp):

$ q_d (t_j + k T_s) = q_(d,j) + k / N (q_(d,j+1) - q_(d,j)), quad k = 0, 1, dots, N - 1 $ <eq-interp>

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    line((0, 0), (10.5, 0), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.6))
    content((10.5, 0), [$t$], anchor: "west")
    line((0, 0), (0, 3.6), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.6))
    content((0, 3.6), [$q_d$], anchor: "south")
    let pts = ((0, 0.5), (3.2, 1.6), (6.4, 3.0), (9.6, 3.2))
    // Interpolyatsiya zinapoyasi
    for j in range(3) {
      let (x0, y0) = pts.at(j)
      let (x1, y1) = pts.at(j + 1)
      let n = 8
      for k in range(n) {
        let xa = x0 + k * (x1 - x0) / n
        let xb = x0 + (k + 1) * (x1 - x0) / n
        let y = y0 + k * (y1 - y0) / n
        line((xa, y), (xb, y), stroke: 1pt + csec)
        line((xb, y), (xb, y + (y1 - y0) / n), stroke: 1pt + csec)
      }
      line((x0, y0), (x1, y1), stroke: (paint: luma(150), dash: "dashed", thickness: 0.6pt))
    }
    for (j, p) in pts.enumerate() {
      circle(p, radius: 0.09, fill: cacc, stroke: none)
      line((p.at(0), 0), (p.at(0), -0.12), stroke: 0.8pt)
    }
    content((0, -0.15), text(size: 9pt)[$t_0$], anchor: "north")
    content((3.2, -0.15), text(size: 9pt)[$t_0 + T_h$], anchor: "north")
    content((6.4, -0.15), text(size: 9pt)[$t_0 + 2 T_h$], anchor: "north")
    content((9.6, -0.15), text(size: 9pt)[$t_0 + 3 T_h$], anchor: "north")
    // T_s belgisi
    line((3.2, 1.1), (3.6, 1.1), stroke: 0.6pt, mark: (start: ">", end: ">", fill: black, scale: 0.4))
    content((3.4, 1.05), text(size: 8pt)[$T_s$], anchor: "north")
    content((7.2, 1.3), box(
      fill: luma(245),
      stroke: 0.6pt + csec,
      radius: 3pt,
      inset: 5pt,
      align(left, text(size: 8.5pt)[
        #box(std.circle(radius: 3pt, fill: cacc, stroke: none)) EHM topşiriq nuqtalari \
        #box(std.line(length: 0.5cm, stroke: 1pt + csec)) Interpolyatsiyalangan qiymat
      ]),
    ))
  }),
  caption: [Yuqori daraja topşiriq nuqtalari orasida quyi darajadagi çiziqli interpolyatsiya],
  placement: auto,
) <fig-interp>

*Teskari aloqa datçiklari.* Har bir yuritmada ikkita datçik örnatilgan. *Inkremental fotoimpulsli enkoder* dvigatel vali burilganda impulslar hosil qiladi; ularni reversiv hisoblagiç yönalişni hisobga olgan holda yiğadi. Kvadratur ($times 4$) dekodlaşda böğin burçagining ajratiş qobiliyati:

$ Delta theta_q = (360 degree) / (4 N_e i) $ <eq-res>

bunda $N_e$ --- enkoderning bir aylanişdagi çiziqlar soni, $i$ --- reduktorning uzatiş soni. Inkremental enkoder faqat nisbiy siljişni ölçagani uçun işga tuşirişda böğinning taxminiy *absolyut holati* *potensiometr* orqali aniqlanadi.

PUMA 560 tipidagi robotlarda taxogenerator yöq: böğin tezligi ketma-ket servo tsikllardagi holatlar ayirmasi orqali baholanadi. Bunday baholaşning kvantlaş qadami:

$ hat(omega)_k = (theta_k - theta_(k-1)) / T_s, quad Delta omega = (Delta theta_q) / T_s $ <eq-vel>

Diskret PID qonuni ($e_k = q_(d,k) - q_k$):

$ u_k = K_p e_k + K_i T_s sum_(j=0)^k e_j + K_d (e_k - e_(k-1)) / T_s $ <eq-pid>

Dvigatel va böğin tezliklari hamda momentlari reduktor orqali boğlangan ($eta$ --- reduktor FIK):

$ omega_m = i dot omega_q, quad tau_q = eta dot i dot tau_m $ <eq-gear>

== Qölda boşqariş pulti va iş rejimlari

Qölda boşqariş pulti (PRU) manipulyatorni qölda boşqariş, robotni nuqtalarga örgatiş hamda tekşiruv va sozlaş işlarini bajariş uçun işlatiladi. Pultning beşta iş rejimi @tab-modes da keltirilgan; tanlangan rejim yoruğlik diodi bilan körsatiladi.

#figure(
  btable(
    columns: (auto, 1fr),
    align: (center + horizon, left + horizon),
    ([*Rejim*], [*Vazifasi*]),
    [COMP],
    [Manipulyator EHM dan boşqariladi; pult tugmalari bloklanadi],
    [JOINT],
    [Har bir böğin alohida, özining boğlangan koordinatalar tizimida harakatlantiriladi (1–6 tugmalari “+”/“−”)],
    [WORLD],
    [Asbob bazaviy koordinatalar tizimi öqlari böylab siljitiladi (X/1, Y/2, Z/3) va şu öqlar atrofida buriladi (RX/4, RY/5, RZ/6)],
    [TOOL],
    [Siljitiş va buriş asbob koordinatalar tizimi öqlariga nisbatan bajariladi],
    [FREE],
    [Böğin yuritmalari öçiriladi],
  ),
  caption: [Qölda boşqariş pultining iş rejimlari],
  placement: auto,
) <tab-modes>

Pultdagi “SPEED +/−” tugmalari harakat tezligini sakkiz poğonali indikator böyiça özgartiradi, “STEP” tugmasi manipulyatorning joriy holatini xotiraga yozib, unga nuqta nomini beradi, “OPEN”/“CLOSE” tugmalari esa JOINT, WORLD va TOOL rejimlarida tutqiçni boşqaradi.

*Xavfsizlik böyiça tavsiyalar.* Tutqiçni avval JOINT rejimida işçi zonaga çiqarib, kerakli orientatsiya beriş maqsadga muvofiq. WORLD rejimida alohida ehtiyotkorlik talab etiladi: bu rejimda böğinlar aylanişini EHM bazaviy koordinatalardagi berilgan siljişdan kelib çiqib özi rejalaştiradi, şuning uçun zvenolar çegaraviy holatga çiqib, boşqaruv tizimi öçib qolişi mumkin. Pult bilan işlaşni past tezlikda (indikatorning bir-ikki poğonasi) boşlaş kerak.

== ARPS tili va örgatiş usulida dasturlaş

*Örgatiş (_teach-in_) usulida dasturlaş* --- operator manipulyatorning işçi organini oldindan kerakli holatlarga olib borib, harakat parametrlarini boşqaruv qurilmasiga yozib boradigan dasturlaş usuli. RM-01 da nuqtalarning ikki asosiy turi işlatiladi:

+ *Absolyut nuqtalar* (nomi oldida `#` belgisi, masalan `#A2`): böğin buriliş burçaklari bilan beriladi. Ular yuqori aniqlik va konfiguratsiyaning bir qiymatliligini taʼminlaydi, ammo ularni dastur içida özgartirib yoki boşqa nuqtalar bilan birlaştirib bölmaydi.
+ *Koordinata nuqtalari:* asbob koordinatalar tizimi boşining bazaviy tizim öqlaridagi proyeksiyalari ($x, y, z$) va uçta orientatsiya burçagi bilan beriladi; ularni `SHIFT` kabi buyruqlar bilan özgartiriş mumkin.

Örgatiş usulining samaradorligi aniqlik körsatkiçlari bilan izohlanadi: RM-01 ning takroriy pozitsiyalaş aniqligi taxminan 0.1 mm, kalibrlanmagan robotda analitik berilgan nuqtaga çiqiş xatoligi esa 5–10 mm gaça yetişi mumkin. Örgatilgan nuqtaga qaytişda takroriylik hal qiluvçi böladi, şuning uçun bu usul yuqori aniqlik beradi.

ARPS buyruğining umumiy formati `BUYRUQ argument1, argument2, ...` körinişida; burçakli qavslarda (`<...>`) berilgan argumentlar ixtiyoriy bölib, berilmasa standart qiymat (odatda nol) olinadi. Burçak qiymatlari $-180 degree$ dan $179.995 degree$ gaça $0.005 degree$ qadam bilan, masofalar esa $-1024$ dan $1023.99$ mm gaça $0.01$ mm qadam bilan beriladi. Asosiy buyruqlar @tab-arps da keltirilgan.

#figure(
  btable(
    columns: (auto, 1fr),
    align: (left + horizon, left + horizon),
    ([*Buyruq*], [*Vazifasi*]),
    [`HERE A`],
    [Manipulyatorning joriy holatini `A` nuqta sifatida xotiraga yoziş],
    [`SHIFT A = dx, dy, dz`],
    [`A` nuqtani bazaviy koordinatalar tizimida berilgan masofalarga siljitiş],
    [`DISTANCE X = A, B`],
    [`A` va `B` nuqtalar orasidagi masofani `X` özgaruvçiga yoziş],
    [`GO A`],
    [Manipulyatorni `A` nuqtaga olib boriş],
    [`GOS A`],
    [`A` nuqtaga töğri çiziqli trayektoriya böyiça harakatlaniş],
    [`GONEAR A, h`],
    [`A` nuqtadan robot $z$ öqi böyiça $h$ mm uzoqlikdagi holatga boriş],
    [`GOSNEAR , h`],
    [Joriy holatdan $h$ mm ga töğri çiziq böylab uzoqlaşiş],
    [`GO READY`],
    [Manipulyatorni dastlabki (vertikal) holatga keltiriş],
    [`OPEN` / `CLOSE`],
    [Tutqiçni oçiş / yopiş],
    [`DELAY t`],
    [Dastur bajarilişini $t$ soniyaga töxtatiş],
    [`SET X = Y + 1`],
    [Butun sonli özgaruvçi qiymatini hisoblaş],
    [`IF X < N THEN JUMP 10`],
    [Şart bajarilsa, `10` belgili satrga ötiş],
    [`BASE dx, dy, dz, rz`],
    [Bazaviy koordinatalar tizimini siljitiş va buriş],
  ),
  caption: [ARPS tilining asosiy buyruqlari],
  placement: auto,
) <tab-arps>

Detalni bir joydan olib, ikkinçi joyga qöyiş uçun ARPS dasturi @lst-pick da keltirilgan. Bunda `PART` --- detal olinadigan nuqta, `BOX` --- detal qöyiladigan nuqta; sikl boşida tutqiç oçiq deb faraz qilinadi.

#figure(
  ```text
  GONEAR PART, 50
  GOS PART
  CLOSE
  GOSNEAR , 150
  GONEAR BOX, 100
  GOS BOX
  OPEN
  GOSNEAR , 100
  ```,
  caption: [Detalni olib qöyiş (_pick-and-place_) dasturi],
) <lst-pick>

Dastur bajarilganda manipulyator detal ustidan 50 mm balandlikka çiqadi, unga töğri çiziq böylab yaqinlaşib, tutqiçni yopadi, 150 mm yuqoriga kötariladi, idiş ustidan 100 mm balandlikka ötadi, idişga tuşib, tutqiçni oçadi va 100 mm yuqoriga qaytadi. Dasturni işga tuşirişdan oldin robot ikkala nuqtaga örgatiladi: PRU yordamida manipulyator detalni oliş holatiga keltiriladi va `HERE PART` buyruği kiritiladi, söngra xuddi şunday `HERE BOX` bajariladi.

= Namunaviy masalalar va ularning yeçimlari

== Masala 1: Bilak markazining holatini hisoblaş

*Masala şarti:* RM-01 manipulyatorining böğin burçaklari (D-H şkalasida) $theta_1 = 30 degree$, $theta_2 = -30 degree$, $theta_3 = 45 degree$ ga teng. Parametrlar @tab-dh dan olinadi.

#set enum(numbering: "a)")
+ Bilak markazi $W$ ning ${0}$ freymdagi koordinatalarini ($P_x, P_y, P_z$) hisoblang.
+ $W$ ning yelka markazidan masofasini ($R_W$) toping va uni maksimal erişiş radiusi $R_max$ bilan soliştiring.
#set enum(numbering: "1.")

*Hisoblaş bosqiçlari:*

- *Trigonometrik qiymatlar.* $c_1 = cos 30 degree = 0.8660$, $s_1 = 0.5000$; $c_2 = cos(-30 degree) = 0.8660$, $s_2 = -0.5000$; $theta_2 + theta_3 = 15 degree$: $c_(23) = 0.9659$, $s_(23) = 0.2588$.

- *Yordamçi kattalik* (@eq-r), metrlarda:
  $
    r = 0.4318 dot 0.8660 + 0.0203 dot 0.9659 - 0.4318 dot 0.2588 \
    = 0.37394 + 0.01961 - 0.11176 = 0.28179 "m"
  $

- *Bilak markazi koordinatalari* (@eq-wc):
  $ P_x = 0.8660 dot 0.28179 + 0.15005 dot 0.5 = 0.24404 + 0.07503 approx 0.3191 "m" $
  $ P_y = 0.5 dot 0.28179 - 0.15005 dot 0.8660 = 0.14090 - 0.12995 approx 0.0110 "m" $
  $
    P_z = 0.4318 dot (-0.5) + 0.0203 dot 0.2588 + 0.4318 dot 0.9659 \
    = -0.21590 + 0.00525 + 0.41708 approx 0.2064 "m"
  $

- *Masofa va erişiş çegarasi:*
  $
    R_W = sqrt(P_x^2 + P_y^2 + P_z^2) = sqrt(0.10180 + 0.00012 + 0.04261) \
    = sqrt(0.14453) approx 0.380 "m"
  $
  (@eq-rmax) formula böyiça:
  $
    R_max = sqrt(0.15005^2 + (0.4318 + sqrt(0.0203^2 + 0.4318^2))^2) \
    = sqrt(0.02252 + 0.86408^2) = sqrt(0.76915) approx 0.877 "m"
  $
  $R_W < R_max$, demak nuqta işçi zona içida joylaşgan.

*Javob:* $P_x approx 0.319 "m"$, $P_y approx 0.011 "m"$, $P_z approx 0.206 "m"$; $R_W approx 0.380 "m" < R_max approx 0.877 "m"$.

== Masala 2: Böğin boşqaruv kanalining parametrlari

*Masala şarti:* RM-01 ning 1-böğini yuritmasida bir aylanişga $N_e = 1000$ çiziqli inkremental enkoder (kvadratur dekodlaş) va uzatiş soni $i = 62.61$ bölgan reduktor örnatilgan. Yuqori daraja topşiriqni $T_h = 28$ ms da, quyi daraja servo tsiklni $T_s = 0.875$ ms da bajaradi. Navbatdagi trayektoriya segmentida böğin burçagi $Delta q = 0.5 degree$ ga özgarişi kerak.

#set enum(numbering: "a)")
+ Böğin burçagining ajratiş qobiliyatini ($Delta theta_q$) toping.
+ Interpolyatsiya qadamlari sonini ($N$) aniqlang.
+ Böğin va dvigatel tezliklarini ($omega_q$, $omega_m$) hisoblang.
+ Bir servo tsiklda hisoblagiçga keladigan impulslar sonini toping.
+ Tezlikni raqamli baholaşning kvantlaş qadamini ($Delta omega$) aniqlang va natijani baholang.
#set enum(numbering: "1.")

*Hisoblaş bosqiçlari:*

- *Ajratiş qobiliyati* (@eq-res):
  $ Delta theta_q = (360 degree) / (4 dot 1000 dot 62.61) = (360 degree) / 250440 approx 1.4375 dot 10^(-3) degree $

- *Interpolyatsiya qadamlari soni* (@eq-N):
  $ N = (28 "ms") / (0.875 "ms") = 32 $

- *Tezliklar* (@eq-gear):
  $ omega_q = (Delta q) / T_h = (0.5 degree) / (0.028 "s") approx 17.86 degree"/s" $
  $
    omega_m = i dot omega_q = 62.61 dot 17.86 approx 1118 degree"/s" \
    = 1118 / 360 dot 60 approx 186.3 "ayl/min"
  $

- *Bir servo tsikldagi impulslar soni.* Bir qadamdagi burçak orttirmasi $delta q = Delta q \/ N = 0.5 degree \/ 32 = 0.015625 degree$, demak:
  $ n_"imp" = (delta q) / (Delta theta_q) = 0.015625 / (1.4375 dot 10^(-3)) approx 10.9 approx 11 "impuls" $

- *Tezlikni baholaşning kvantlaş qadami* (@eq-vel):
  $ Delta omega = (1.4375 dot 10^(-3) degree) / (0.875 dot 10^(-3) "s") approx 1.64 degree"/s" $
  Bu qiymat $omega_q$ ning taxminan $1.64 \/ 17.86 approx 9.2 %$ ini taşkil etadi. Demak, taxogeneratorsiz tizimda past tezliklarda bitta servo tsikl böyiça olingan tezlik bahosi sezilarli şovqinga ega; uni bir neça tsikl böyiça örtaça qiymat yoki raqamli filtr orqali silliqlaş zarur (masalan, $T_h$ oraliğida baholanganda $Delta omega = 1.64 \/ 32 approx 0.05 degree"/s"$).

*Javob:* $Delta theta_q approx 1.44 dot 10^(-3) degree$; $N = 32$; $omega_q approx 17.86 degree"/s"$, $omega_m approx 186 "ayl/min"$; $n_"imp" approx 11$; $Delta omega approx 1.64 degree"/s"$.

== Masala 3: Detallarni taxlaş uçun ARPS dasturi

*Masala şarti:* robot bitta `PART` nuqtasiga ketma-ket keltiriladigan uçta detalni olib, ularni idişga $X$ öqi böylab 60 mm qadam bilan qatorlab qöyişi kerak. Birinçi detal `BOX` nuqtasiga qöyiladi. Detalga yaqinlaşiş balandligi 50 mm, idişga yaqinlaşiş balandligi 100 mm.

#set enum(numbering: "a)")
+ ARPS tilida sikl körinişidagi dasturni tuzing.
+ Örgatilişi kerak bölgan nuqtalarni va ularni örgatişda foydalaniladigan PRU rejimlarini körsating.
#set enum(numbering: "1.")

*Yeçim:*

- *Dastur.* Detallar sonini hisoblaş uçun `N` özgaruvçisi, idişdagi joyni özgartiriş uçun `SHIFT` buyruği işlatiladi (@lst-pallet). Sikl oxirida `BOX` nuqtasi dastlabki holatiga qaytariladi, aks holda dasturning keyingi işga tuşirilişida qöyiş joyi siljib ketadi.


- *Örgatiladigan nuqtalar.* Dasturda faqat ikkita nuqta örgatiladi: `PART` va `BOX`; qolgan holatlar (`GONEAR`, `GOSNEAR`, `SHIFT`) ulardan hisoblanadi. Şu sababli bu nuqtalar *koordinata nuqtalari* bölişi kerak (absolyut `#` nuqtalarni `SHIFT` bilan özgartirib bölmaydi). Har bir nuqtani örgatişda manipulyator avval JOINT rejimida işçi zonaga çiqariladi, söngra WORLD yoki TOOL rejimida past tezlikda aniq joylaştiriladi va `HERE PART` (`HERE BOX`) buyruği kiritiladi. Dastur bajarilayotganda pult COMP rejimida böladi.

*Javob:* dastur @lst-pallet da keltirilgan; detallar `BOX`, `BOX` + 60 mm va `BOX` + 120 mm nuqtalarga ($X$ böyiça) qöyiladi.

#figure(
  ```text
      SET N = 0
      OPEN
  10  GONEAR PART, 50
      GOS PART
      CLOSE
      GOSNEAR , 150
      GONEAR BOX, 100
      GOS BOX
      OPEN
      GOSNEAR , 100
      SHIFT BOX = 60, 0, 0
      SET N = N + 1
      IF N < 3 THEN JUMP 10
      SHIFT BOX = -180, 0, 0
      GO READY
  ```,
  caption: [Uçta detalni 60 mm qadam bilan taxlaş dasturi],
  placement: auto,
) <lst-pallet>

= Individual amaliy topşiriqlar

Har bir talaba öz variant raqamiga mos maʼlumotlar (@tab-variants) böyiça quyidagilarni bajarişi lozim (barça variantlarda $T_h = 28$ ms, $T_s = 0.875$ ms, D-H parametrlari @tab-dh böyiça):

+ Berilgan $theta_1, theta_2, theta_3$ burçaklar uçun bilak markazi koordinatalarini ($P_x, P_y, P_z$) va yelka markazidan masofasini ($R_W$) hisoblaş, natijani $R_max$ bilan soliştiriş.
+ Böğin boşqaruv kanali uçun $Delta theta_q$, $N$, $omega_q$, $omega_m$ (ayl/min), bir servo tsikldagi impulslar soni va $Delta omega$ ni hisoblaş.
+ $n$ ta detalni $X$ öqi böylab $s$ qadam bilan taxlovçi ARPS dasturini tuziş, örgatiladigan nuqtalar va PRU rejimlarini körsatiş.
+ 1- va 2-bandlar natijalarini Python (NumPy) dasturi yordamida tekşiriş.

#figure(
  btable(
    columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto),
    (
      [*Var.*],
      [*$theta_1$*],
      [*$theta_2$*],
      [*$theta_3$*],
      [*$N_e$ \ \[çiziq\]*],
      [*$i$*],
      [*$Delta q$ \ \[°/segment\]*],
      [*$n$ \ \[dona\]*],
      [*$s$ \ \[mm\]*],
    ),
    [*1*],
    [$20 degree$],
    [$-40 degree$],
    [$60 degree$],
    [500],
    [62.61],
    [0.40],
    [3],
    [50],
    [*2*],
    [$-30 degree$],
    [$-20 degree$],
    [$30 degree$],
    [1000],
    [107.82],
    [0.30],
    [4],
    [45],
    [*3*],
    [$45 degree$],
    [$-60 degree$],
    [$90 degree$],
    [250],
    [53.71],
    [0.60],
    [3],
    [60],
    [*4*],
    [$60 degree$],
    [$-10 degree$],
    [$20 degree$],
    [1000],
    [76.04],
    [0.50],
    [5],
    [40],
    [*5*],
    [$-45 degree$],
    [$-50 degree$],
    [$70 degree$],
    [500],
    [71.92],
    [0.35],
    [4],
    [55],
    [*6*],
    [$15 degree$],
    [$-35 degree$],
    [$50 degree$],
    [2000],
    [76.69],
    [0.25],
    [3],
    [70],
    [*7*],
    [$-60 degree$],
    [$-25 degree$],
    [$40 degree$],
    [250],
    [62.61],
    [0.80],
    [6],
    [35],
    [*8*],
    [$90 degree$],
    [$-45 degree$],
    [$45 degree$],
    [1000],
    [53.71],
    [0.45],
    [4],
    [50],
    [*9*],
    [$-15 degree$],
    [$-70 degree$],
    [$100 degree$],
    [500],
    [107.82],
    [0.20],
    [5],
    [45],
    [*10*],
    [$75 degree$],
    [$-30 degree$],
    [$60 degree$],
    [2000],
    [71.92],
    [0.55],
    [3],
    [65],
  ),
  caption: [Talabalar uçun individual topşiriqlar],
  placement: auto,
) <tab-variants>

= Nazorat savollari

+ RM-01 roboti qaysi robotning analogi hisoblanadi va qanday kinematik turga mansub?
+ Sferik bilak deganda nima tuşuniladi va u kinematika masalalarini yeçişni qanday soddalaştiradi?
+ Ikki poğonali boşqaruv tizimida yuqori va quyi darajalar qanday vazifalarni bajaradi?
+ Nima uçun quyi darajada interpolyatsiya zarur va interpolyatsiya qadamlari soni qanday aniqlanadi?
+ Inkremental enkoder va potensiometr datçiklarining vazifalari bir-biridan nimasi bilan farq qiladi?
+ Taxogenerator bölmagan tizimda böğin tezligi qanday baholanadi va bu usulning kamçiligi nimada?
+ PRU ning JOINT, WORLD va TOOL rejimlari qanday farqlanadi? Nima uçun WORLD rejimida ehtiyotkorlik talab etiladi?
+ Absolyut va koordinata nuqtalari farqini tuşuntiring. Nima uçun örgatiş usuli yuqori aniqlik beradi?
