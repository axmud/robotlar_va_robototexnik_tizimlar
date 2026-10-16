// ============================================================
//  Robotlar va robototexnik tizimlar — 5-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_5.typ
// ============================================================

#import "@preview/cetz:0.4.2"

#let headingblue = rgb(20, 50, 120)

#set document(title: "RM-01 sanoat robotining ishlash prinsipini oʻrganish")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MASHGʻULOTI №5]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[Mavzu: RM-01 sanoat robotining ishlash prinsipini oʻrganish]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Ishning maqsadi

*Mashgʻulotning maqsadi:* talabalarni *RM-01* antropomorf sanoat robotining tuzilishi, kinematik sxemasi, ikki pogʻonali boshqaruv tizimining ishlash prinsipi, qoʻlda boshqarish pulti (PRU) rejimlari hamda *ARPS* tilida oʻrgatish (_teach-in_) usuli bilan dasturlash asoslari bilan tanishtirish, shuningdek robot ish jarayonini tavsiflovchi asosiy kinematik va boshqaruv kattaliklarini hisoblash koʻnikmalarini shakllantirish.

*Oʻquv vazifalari va kutilayotgan natijalar:*

- *Konstruksiya va texnik tavsif:* RM-01 robotining zvenolari, kinematik juftliklari, yuritmalari va datchiklarining vazifasini tushuntirish, texnik koʻrsatkichlarini tahlil qilish.
- *Kinematika:* Denavit–Hartenberg (D-H) parametrlari asosida bilak markazining koordinatalarini ($P_x, P_y, P_z$) hisoblash va sferik bilak tufayli yuzaga keladigan kinematik ajratish (_decoupling_) tamoyilini tushunish.
- *Boshqaruv tizimi:* yuqori (markaziy EHM) va quyi (boʻgʻin mikroprotsessorlari) darajalar vazifalarini farqlash; interpolyatsiya, enkoder ajratish qobiliyati va tezlikni raqamli baholash kattaliklarini hisoblash.
- *Dasturlash:* PRU ning COMP, JOINT, WORLD, TOOL va FREE rejimlaridan foydalanish, nuqtalarni `HERE` buyrugʻi bilan oʻrgatish hamda ARPS tilida “olib qoʻyish” (_pick-and-place_) dasturini tuzish.

= Nazariy asoslar va analitik formulalar

== RM-01 robotining vazifasi va tuzilishi

*RM-01* --- universal antropomorf sanoat roboti boʻlib, *Unimation PUMA 560* robotining analogi hisoblanadi. U dastlab yigʻish operatsiyalarini bajarish uchun dasturlanadigan universal manipulyator sifatida ishlab chiqilgan. Robot yuqori mexanik aniqlikda tayyorlangani va yetarlicha quvvatli oʻzgarmas tok yuritmalari bilan ajralib turadi; u asosiy texnologik va qisman transport operatsiyalarini bajaradi, imkoniyatlari esa manipulyatorga avtomatik oʻrnatiladigan asboblar komplekti hisobiga kengaytirilgan. Hozirgi kunda RM-01 koʻplab oliy taʼlim muassasalarida oʻquv-laboratoriya roboti sifatida qoʻllaniladi.

Manipulyator *oltita erkinlik darajasiga* ega. Oltita zveno va asos oʻzaro oltita V sinf aylanma kinematik juftlikni hosil qiladi (6R mexanizm). Zvenolarning vazifalari quyidagicha:

+ *1-boʻgʻin (ustun):* manipulyatorni vertikal oʻq atrofida burish;
+ *2-boʻgʻin (yelka)* va *3-boʻgʻin (tirsak):* gorizontal oʻqlar atrofida burilib, bilakni vertikal tekislikda joylashtirish;
+ *4-, 5-, 6-boʻgʻinlar (bilak):* asbobning fazodagi orientatsiyasini taʼminlash.

4-, 5- va 6-boʻgʻinlar oʻqlari bitta nuqtada kesishadi va oʻzaro perpendikulyar joylashgan --- bunday tuzilma *sferik bilak* deb ataladi. Shuningdek, PUMA 560 oilasidagi robotlarda bilakdagi tishli uzatmalar 4–6-boʻgʻinlar harakatini oʻzaro bogʻlaydi, shu sababli bu boʻgʻinlar uchun *yuritma fazosi* va *boʻgʻin fazosi* farqlanadi. Robotning asosiy texnik koʻrsatkichlari @tab-spec da keltirilgan.

#figure(
  btable(
    columns: (auto, 1fr),
    align: (left + horizon, left + horizon),
    ([*Koʻrsatkich*], [*Qiymati*]),
    [Erkinlik darajalari soni], [6 (barcha boʻgʻinlar aylanma, 6R)],
    [Kinematik turi], [Antropomorf (burchakli), sferik bilakli],
    [Maksimal yuk koʻtarish qobiliyati], [2.5 kg],
    [Manipulyator massasi], [53 kg],
    [Asbob ishchi nuqtasidagi statik kuch], [60 N gacha],
    [Takroriy pozitsiyalash aniqligi], [0.1 mm],
    [Bilak markazining erishish radiusi], [$approx 864$ mm],
    [Yuritmalar], [Oʻzgarmas tok elektr dvigatellari (elektromagnit tormozli)],
    [Teskari aloqa datchiklari], [Inkremental fotoimpulsli enkoder va potensiometr],
    [Boshqaruv qurilmasi], [“Sfera-36” (ikki pogʻonali ierarxik tizim)],
    [Dasturlash tili], [ARPS (_Advanced Robot Programming System_)],
  ),
  caption: [RM-01 robotining asosiy texnik koʻrsatkichlari],
) <tab-spec>

Zvenolar faqat qatʼiy belgilangan diapazonda harakatlana oladi (@tab-limits).

#figure(
  btable(
    columns: (auto, 1fr, auto, auto),
    align: (center + horizon, left + horizon, center + horizon, center + horizon),
    ([*Boʻgʻin*], [*Harakat turi*], [*$q_(i,min)$*], [*$q_(i,max)$*]),
    [1], [Ustunning vertikal oʻq atrofida burilishi], [$-160 degree$], [$+160 degree$],
    [2], [Yelka zvenosining burilishi], [$-255 degree$], [$+45 degree$],
    [3], [Tirsak zvenosining burilishi], [$-45 degree$], [$+225 degree$],
    [4], [Bilakning boʻylama oʻq atrofida burilishi], [$-110 degree$], [$+170 degree$],
    [5], [Bilakning egilishi], [$-100 degree$], [$+100 degree$],
    [6], [Flanetsning aylanishi], [$-266 degree$], [$+266 degree$],
  ),
  caption: [RM-01 boʻgʻinlarining harakat diapazonlari (ishlab chiqaruvchi shkalasida)],
) <tab-limits>

== Kinematik sxema va D-H parametrlari

RM-01 manipulyatorining kinematik sxemasi @fig-kin da koʻrsatilgan.

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
        $J_1$: ustun burilishi \
        $J_2$: yelka, $J_3$: tirsak \
        $J_4, J_5, J_6$: sferik bilak \
        $W$: bilak markazi \
        $a_2$: yelka zvenosi uzunligi \
        $d_4$: tirsak zvenosi uzunligi \
        $d_3$: yelkaning yon siljishi \
        #h(1.2em) (chizma tekisligiga \
        #h(1.2em) perpendikulyar)
      ]),
    ))
  }),
  caption: [RM-01 manipulyatorining kinematik sxemasi (barcha boʻgʻin burchaklari nolga teng holat)],
) <fig-kin>

Standart D-H konvensiyasi boʻyicha RM-01 (PUMA 560) manipulyatorining parametrlari @tab-dh da berilgan. ${0}$ freym 1- va 2-boʻgʻin oʻqlarining kesishish nuqtasiga (yelka markaziga) joylashtirilgan; yelkaning poldan balandligi $h_0$ alohida bazaviy transformatsiya $T_0^"base" = bold("Trans")_(z, h_0)$ orqali hisobga olinadi. D-H boʻyicha nol holat ishlab chiqaruvchi shkalasidagi noldan farq qilishi mumkin.

#figure(
  btable(
    columns: 5,
    ([*Boʻgʻin $i$*], [*$a_i$ \[mm\]*], [*$alpha_i$*], [*$d_i$ \[mm\]*], [*$theta_i$*]),
    [1], [0], [$+90 degree$], [0], [$theta_1^*$],
    [2], [$a_2 = 431.8$], [$0$], [0], [$theta_2^*$],
    [3], [$a_3 = 20.3$], [$-90 degree$], [$d_3 = 150.05$], [$theta_3^*$],
    [4], [0], [$+90 degree$], [$d_4 = 431.8$], [$theta_4^*$],
    [5], [0], [$-90 degree$], [0], [$theta_5^*$],
    [6], [0], [$0$], [0], [$theta_6^*$],
  ),
  caption: [RM-01 (PUMA 560) manipulyatorining standart D-H parametrlari],
) <tab-dh>

Toʻliq toʻgʻri kinematika ikki qismga ajraladi:

$ T_6^0 = underbrace(A_1^0 A_2^1 A_3^2, T_3^0 (theta_1, theta_2, theta_3)) dot underbrace(A_4^3 A_5^4 A_6^5, T_6^3 (theta_4, theta_5, theta_6)) $ <eq-split>

Sferik bilak tufayli bilak markazi $W$ ning holati faqat dastlabki uchta burchakka bogʻliq. @tab-dh dagi parametrlar bilan $A_1^0 A_2^1 A_3^2 A_4^3$ koʻpaytmasining pozitsiya ustunidan quyidagi ifodalar olinadi ($c_i = cos theta_i$, $s_i = sin theta_i$, $c_(23) = cos(theta_2 + theta_3)$, $s_(23) = sin(theta_2 + theta_3)$):

$ r = a_2 c_2 + a_3 c_(23) - d_4 s_(23) $ <eq-r>

$ P_x = c_1 r + d_3 s_1, quad P_y = s_1 r - d_3 c_1, quad P_z = a_2 s_2 + a_3 s_(23) + d_4 c_(23) $ <eq-wc>

Bilak markazining maksimal erishish radiusi yelka va tirsak zvenolari bir chiziqqa choʻzilganda yuzaga keladi:

$ R_max = sqrt(d_3^2 + (a_2 + sqrt(a_3^2 + d_4^2))^2) $ <eq-rmax>

Bu ajratish teskari kinematika masalasini ham ikkiga boʻladi: avval $W$ ning berilgan holati boʻyicha $theta_1, theta_2, theta_3$ topiladi (pozitsiya masalasi), soʻngra $R_6^3 = (R_3^0)^T R_6^0$ boʻyicha $theta_4, theta_5, theta_6$ aniqlanadi (orientatsiya masalasi). PUMA 560 tipidagi manipulyator ayrim maqsadli holatlarga *sakkiztagacha* turli konfiguratsiyada yetib borishi mumkin: “chap/oʻng yelka”, “tirsak yuqorida/pastda” va “bilak aylantirilgan/aylantirilmagan” kombinatsiyalari.

== Boshqaruv tizimining tuzilishi va ishlash prinsipi

RM-01 boshqaruv tizimi *ikki pogʻonali ierarxik* tamoyil asosida qurilgan (@fig-ctrl).

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
    content((14.75, -1.68), text(size: 7.5pt, fill: csec)[Quyi daraja: har bir boʻgʻin uchun ($times 6$)], anchor: "south-east")

    // Yuqori daraja
    bx((4.5, 5.0), 5.4, 2.0, fill: csec.lighten(85%))[
      *Markaziy EHM (yuqori daraja)* \
      ARPS dasturini talqin qilish, \
      teskari kinematika, \
      trayektoriya generatsiyasi
    ]
    bx((10.9, 5.65), 4.6, 0.55)[Videoterminal, NGMD]
    bx((10.9, 5.0), 4.6, 0.55)[Qoʻlda boshqarish pulti (PRU)]
    bx((10.9, 4.35), 4.6, 0.55)[Kirish/chiqish liniyalari]
    ar((8.6, 5.65), (7.2, 5.65))
    ar((8.6, 5.0), (7.2, 5.0))
    line((8.6, 4.35), (7.2, 4.35), stroke: 0.8pt, mark: (start: ">", end: ">", fill: black, scale: 0.55))
    content((13.3, 4.35), text(size: 7pt)[konveyer, stanok], anchor: "west")

    // Quyi daraja qatori
    bx((1.6, 2.2), 3.2, 1.3, fill: cacc.lighten(85%))[*Boʻgʻin* \ *mikroprotsessori* \ (interpolyatsiya, PID)]
    bx((4.6, 2.2), 1.4, 1.1)[RAOʻ \ (DAC)]
    bx((6.9, 2.2), 2.1, 1.1)[Tok \ kuchaytirgichi]
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
    bx((5.3, 0.4), 3.0, 0.85)[Reversiv \ hisoblagich]
    ar((9.4, 1.65), (9.4, 0.83))
    ar((8.25, 0.4), (6.8, 0.4))
    lb((7.52, 0.45), [impulslar])
    line((3.8, 0.4), (2.2, 0.4), stroke: 0.8pt)
    ar((2.2, 0.4), (2.2, 1.55))

    // Potensiometr kanali
    bx((13.8, -0.9), 2.0, 0.8)[Potensiometr]
    bx((5.3, -0.9), 3.0, 0.8)[AROʻ (ADC)]
    ar((13.8, 1.65), (13.8, -0.5))
    ar((12.8, -0.9), (6.8, -0.9))
    lb((9.8, -0.85), [absolyut holat (ishga tushirishda)])
    line((3.8, -0.9), (0.8, -0.9), stroke: 0.8pt)
    ar((0.8, -0.9), (0.8, 1.55))
  }),
  caption: [RM-01 (PUMA 560) boshqaruv tizimining ikki pogʻonali ierarxik tuzilishi],
) <fig-ctrl>

*Yuqori daraja (markaziy EHM)* robot dasturini satrma-satr talqin qiladi. Harakat buyrugʻi kelganda u teskari kinematikani yechadi, trayektoriyani rejalashtiradi va har $T_h$ vaqtda boʻgʻin kontrollerlariga yangi topshiriq nuqtasini ($q_d$) yuboradi. Unga videoterminal, gibkiy magnit disklar yigʻuvchisi (NGMD), qoʻlda boshqarish pulti hamda tashqi jihozlarni (konveyer, stanok, payvandlash qurilmasi) boshqaruvchi kirish/chiqish liniyalari ulanadi.

*Quyi daraja* har bir boʻgʻin uchun alohida mikroprotsessordan iborat. Analog PUMA 560 robotining boshqaruv tizimida yuqori daraja topshiriqni har $T_h = 28$ ms da yuboradi, boʻgʻin mikroprotsessorlari esa $T_s = 0.875$ ms tsikl bilan ishlaydi. Har bir servo tsiklda mikroprotsessor: (1) topshiriq nuqtalari orasini interpolyatsiya qiladi, (2) enkoder hisoblagichidan haqiqiy holatni oʻqib xatolikni hisoblaydi, (3) PID qonuni boʻyicha boshqaruv signalini hosil qiladi va (4) uni RAOʻ orqali tok kuchaytirgichiga beradi. Dvigatel yakor toki analog sxemada stabillanadi. Bir $T_h$ oraligʻidagi interpolyatsiya qadamlari soni:

$ N = T_h / T_s $ <eq-N>

Chiziqli interpolyatsiyada $j$-va $(j+1)$-topshiriq nuqtalari orasidagi oraliq qiymatlar (@fig-interp):

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
        #box(std.circle(radius: 3pt, fill: cacc, stroke: none)) EHM topshiriq nuqtalari \
        #box(std.line(length: 0.5cm, stroke: 1pt + csec)) Interpolyatsiyalangan qiymat
      ]),
    ))
  }),
  caption: [Yuqori daraja topshiriq nuqtalari orasida quyi darajadagi chiziqli interpolyatsiya],
) <fig-interp>

*Teskari aloqa datchiklari.* Har bir yuritmada ikkita datchik oʻrnatilgan. *Inkremental fotoimpulsli enkoder* dvigatel vali burilganda impulslar hosil qiladi; ularni reversiv hisoblagich yoʻnalishni hisobga olgan holda yigʻadi. Kvadratur ($times 4$) dekodlashda boʻgʻin burchagining ajratish qobiliyati:

$ Delta theta_q = (360 degree) / (4 N_e i) $ <eq-res>

bunda $N_e$ --- enkoderning bir aylanishdagi chiziqlar soni, $i$ --- reduktorning uzatish soni. Inkremental enkoder faqat nisbiy siljishni oʻlchagani uchun ishga tushirishda boʻgʻinning taxminiy *absolyut holati* *potensiometr* orqali aniqlanadi.

PUMA 560 tipidagi robotlarda taxogenerator yoʻq: boʻgʻin tezligi ketma-ket servo tsikllardagi holatlar ayirmasi orqali baholanadi. Bunday baholashning kvantlash qadami:

$ hat(omega)_k = (theta_k - theta_(k-1)) / T_s, quad Delta omega = (Delta theta_q) / T_s $ <eq-vel>

Diskret PID qonuni ($e_k = q_(d,k) - q_k$):

$ u_k = K_p e_k + K_i T_s sum_(j=0)^k e_j + K_d (e_k - e_(k-1)) / T_s $ <eq-pid>

Dvigatel va boʻgʻin tezliklari hamda momentlari reduktor orqali bogʻlangan ($eta$ --- reduktor FIK):

$ omega_m = i dot omega_q, quad tau_q = eta dot i dot tau_m $ <eq-gear>

== Qoʻlda boshqarish pulti va ish rejimlari

Qoʻlda boshqarish pulti (PRU) manipulyatorni qoʻlda boshqarish, robotni nuqtalarga oʻrgatish hamda tekshiruv va sozlash ishlarini bajarish uchun ishlatiladi. Pultning beshta ish rejimi @tab-modes da keltirilgan; tanlangan rejim yorugʻlik diodi bilan koʻrsatiladi.

#figure(
  btable(
    columns: (auto, 1fr),
    align: (center + horizon, left + horizon),
    ([*Rejim*], [*Vazifasi*]),
    [COMP], [Manipulyator EHM dan boshqariladi; pult tugmalari bloklanadi],
    [JOINT], [Har bir boʻgʻin alohida, oʻzining bogʻlangan koordinatalar tizimida harakatlantiriladi (1–6 tugmalari “+”/“−”)],
    [WORLD], [Asbob bazaviy koordinatalar tizimi oʻqlari boʻylab siljitiladi (X/1, Y/2, Z/3) va shu oʻqlar atrofida buriladi (RX/4, RY/5, RZ/6)],
    [TOOL], [Siljitish va burish asbob koordinatalar tizimi oʻqlariga nisbatan bajariladi],
    [FREE], [Boʻgʻin yuritmalari oʻchiriladi],
  ),
  caption: [Qoʻlda boshqarish pultining ish rejimlari],
) <tab-modes>

Pultdagi “SPEED +/−” tugmalari harakat tezligini sakkiz pogʻonali indikator boʻyicha oʻzgartiradi, “STEP” tugmasi manipulyatorning joriy holatini xotiraga yozib, unga nuqta nomini beradi, “OPEN”/“CLOSE” tugmalari esa JOINT, WORLD va TOOL rejimlarida tutqichni boshqaradi.

*Xavfsizlik boʻyicha tavsiyalar.* Tutqichni avval JOINT rejimida ishchi zonaga chiqarib, kerakli orientatsiya berish maqsadga muvofiq. WORLD rejimida alohida ehtiyotkorlik talab etiladi: bu rejimda boʻgʻinlar aylanishini EHM bazaviy koordinatalardagi berilgan siljishdan kelib chiqib oʻzi rejalashtiradi, shuning uchun zvenolar chegaraviy holatga chiqib, boshqaruv tizimi oʻchib qolishi mumkin. Pult bilan ishlashni past tezlikda (indikatorning bir-ikki pogʻonasi) boshlash kerak.

== ARPS tili va oʻrgatish usulida dasturlash

*Oʻrgatish (_teach-in_) usulida dasturlash* --- operator manipulyatorning ishchi organini oldindan kerakli holatlarga olib borib, harakat parametrlarini boshqaruv qurilmasiga yozib boradigan dasturlash usuli. RM-01 da nuqtalarning ikki asosiy turi ishlatiladi:

+ *Absolyut nuqtalar* (nomi oldida `#` belgisi, masalan `#A2`): boʻgʻin burilish burchaklari bilan beriladi. Ular yuqori aniqlik va konfiguratsiyaning bir qiymatliligini taʼminlaydi, ammo ularni dastur ichida oʻzgartirib yoki boshqa nuqtalar bilan birlashtirib boʻlmaydi.
+ *Koordinata nuqtalari:* asbob koordinatalar tizimi boshining bazaviy tizim oʻqlaridagi proyeksiyalari ($x, y, z$) va uchta orientatsiya burchagi bilan beriladi; ularni `SHIFT` kabi buyruqlar bilan oʻzgartirish mumkin.

Oʻrgatish usulining samaradorligi aniqlik koʻrsatkichlari bilan izohlanadi: RM-01 ning takroriy pozitsiyalash aniqligi taxminan 0.1 mm, kalibrlanmagan robotda analitik berilgan nuqtaga chiqish xatoligi esa 5–10 mm gacha yetishi mumkin. Oʻrgatilgan nuqtaga qaytishda takroriylik hal qiluvchi boʻladi, shuning uchun bu usul yuqori aniqlik beradi.

ARPS buyrugʻining umumiy formati `BUYRUQ argument1, argument2, ...` koʻrinishida; burchakli qavslarda (`<...>`) berilgan argumentlar ixtiyoriy boʻlib, berilmasa standart qiymat (odatda nol) olinadi. Burchak qiymatlari $-180 degree$ dan $179.995 degree$ gacha $0.005 degree$ qadam bilan, masofalar esa $-1024$ dan $1023.99$ mm gacha $0.01$ mm qadam bilan beriladi. Asosiy buyruqlar @tab-arps da keltirilgan.

#figure(
  btable(
    columns: (auto, 1fr),
    align: (left + horizon, left + horizon),
    ([*Buyruq*], [*Vazifasi*]),
    [`HERE A`], [Manipulyatorning joriy holatini `A` nuqta sifatida xotiraga yozish],
    [`SHIFT A = dx, dy, dz`], [`A` nuqtani bazaviy koordinatalar tizimida berilgan masofalarga siljitish],
    [`DISTANCE X = A, B`], [`A` va `B` nuqtalar orasidagi masofani `X` oʻzgaruvchiga yozish],
    [`GO A`], [Manipulyatorni `A` nuqtaga olib borish],
    [`GOS A`], [`A` nuqtaga toʻgʻri chiziqli trayektoriya boʻyicha harakatlanish],
    [`GONEAR A, h`], [`A` nuqtadan robot $z$ oʻqi boʻyicha $h$ mm uzoqlikdagi holatga borish],
    [`GOSNEAR , h`], [Joriy holatdan $h$ mm ga toʻgʻri chiziq boʻylab uzoqlashish],
    [`GO READY`], [Manipulyatorni dastlabki (vertikal) holatga keltirish],
    [`OPEN` / `CLOSE`], [Tutqichni ochish / yopish],
    [`DELAY t`], [Dastur bajarilishini $t$ soniyaga toʻxtatish],
    [`SET X = Y + 1`], [Butun sonli oʻzgaruvchi qiymatini hisoblash],
    [`IF X < N THEN JUMP 10`], [Shart bajarilsa, `10` belgili satrga oʻtish],
    [`BASE dx, dy, dz, rz`], [Bazaviy koordinatalar tizimini siljitish va burish],
  ),
  caption: [ARPS tilining asosiy buyruqlari],
) <tab-arps>

Detalni bir joydan olib, ikkinchi joyga qoʻyish uchun ARPS dasturi @lst-pick da keltirilgan. Bunda `PART` --- detal olinadigan nuqta, `BOX` --- detal qoʻyiladigan nuqta; sikl boshida tutqich ochiq deb faraz qilinadi.

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
  caption: [Detalni olib qoʻyish (_pick-and-place_) dasturi],
) <lst-pick>

Dastur bajarilganda manipulyator detal ustidan 50 mm balandlikka chiqadi, unga toʻgʻri chiziq boʻylab yaqinlashib, tutqichni yopadi, 150 mm yuqoriga koʻtariladi, idish ustidan 100 mm balandlikka oʻtadi, idishga tushib, tutqichni ochadi va 100 mm yuqoriga qaytadi. Dasturni ishga tushirishdan oldin robot ikkala nuqtaga oʻrgatiladi: PRU yordamida manipulyator detalni olish holatiga keltiriladi va `HERE PART` buyrugʻi kiritiladi, soʻngra xuddi shunday `HERE BOX` bajariladi.

= Namunaviy masalalar va ularning yechimlari

== Masala 1: Bilak markazining holatini hisoblash

*Masala sharti:* RM-01 manipulyatorining boʻgʻin burchaklari (D-H shkalasida) $theta_1 = 30 degree$, $theta_2 = -30 degree$, $theta_3 = 45 degree$ ga teng. Parametrlar @tab-dh dan olinadi.

#set enum(numbering: "a)")
+ Bilak markazi $W$ ning ${0}$ freymdagi koordinatalarini ($P_x, P_y, P_z$) hisoblang.
+ $W$ ning yelka markazidan masofasini ($R_W$) toping va uni maksimal erishish radiusi $R_max$ bilan solishtiring.
#set enum(numbering: "1.")

*Hisoblash bosqichlari:*

- *Trigonometrik qiymatlar.* $c_1 = cos 30 degree = 0.8660$, $s_1 = 0.5000$; $c_2 = cos(-30 degree) = 0.8660$, $s_2 = -0.5000$; $theta_2 + theta_3 = 15 degree$: $c_(23) = 0.9659$, $s_(23) = 0.2588$.

- *Yordamchi kattalik* (@eq-r), metrlarda:
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

- *Masofa va erishish chegarasi:*
  $
    R_W = sqrt(P_x^2 + P_y^2 + P_z^2) = sqrt(0.10180 + 0.00012 + 0.04261) \
    = sqrt(0.14453) approx 0.380 "m"
  $
  (@eq-rmax) formula boʻyicha:
  $
    R_max = sqrt(0.15005^2 + (0.4318 + sqrt(0.0203^2 + 0.4318^2))^2) \
    = sqrt(0.02252 + 0.86408^2) = sqrt(0.76915) approx 0.877 "m"
  $
  $R_W < R_max$, demak nuqta ishchi zona ichida joylashgan.

*Javob:* $P_x approx 0.319 "m"$, $P_y approx 0.011 "m"$, $P_z approx 0.206 "m"$; $R_W approx 0.380 "m" < R_max approx 0.877 "m"$.

== Masala 2: Boʻgʻin boshqaruv kanalining parametrlari

*Masala sharti:* RM-01 ning 1-boʻgʻini yuritmasida bir aylanishga $N_e = 1000$ chiziqli inkremental enkoder (kvadratur dekodlash) va uzatish soni $i = 62.61$ boʻlgan reduktor oʻrnatilgan. Yuqori daraja topshiriqni $T_h = 28$ ms da, quyi daraja servo tsiklni $T_s = 0.875$ ms da bajaradi. Navbatdagi trayektoriya segmentida boʻgʻin burchagi $Delta q = 0.5 degree$ ga oʻzgarishi kerak.

#set enum(numbering: "a)")
+ Boʻgʻin burchagining ajratish qobiliyatini ($Delta theta_q$) toping.
+ Interpolyatsiya qadamlari sonini ($N$) aniqlang.
+ Boʻgʻin va dvigatel tezliklarini ($omega_q$, $omega_m$) hisoblang.
+ Bir servo tsiklda hisoblagichga keladigan impulslar sonini toping.
+ Tezlikni raqamli baholashning kvantlash qadamini ($Delta omega$) aniqlang va natijani baholang.
#set enum(numbering: "1.")

*Hisoblash bosqichlari:*

- *Ajratish qobiliyati* (@eq-res):
  $ Delta theta_q = (360 degree) / (4 dot 1000 dot 62.61) = (360 degree) / 250440 approx 1.4375 dot 10^(-3) degree $

- *Interpolyatsiya qadamlari soni* (@eq-N):
  $ N = (28 "ms") / (0.875 "ms") = 32 $

- *Tezliklar* (@eq-gear):
  $ omega_q = (Delta q) / T_h = (0.5 degree) / (0.028 "s") approx 17.86 degree"/s" $
  $
    omega_m = i dot omega_q = 62.61 dot 17.86 approx 1118 degree"/s" \
    = 1118 / 360 dot 60 approx 186.3 "ayl/min"
  $

- *Bir servo tsikldagi impulslar soni.* Bir qadamdagi burchak orttirmasi $delta q = Delta q \/ N = 0.5 degree \/ 32 = 0.015625 degree$, demak:
  $ n_"imp" = (delta q) / (Delta theta_q) = 0.015625 / (1.4375 dot 10^(-3)) approx 10.9 approx 11 "impuls" $

- *Tezlikni baholashning kvantlash qadami* (@eq-vel):
  $ Delta omega = (1.4375 dot 10^(-3) degree) / (0.875 dot 10^(-3) "s") approx 1.64 degree"/s" $
  Bu qiymat $omega_q$ ning taxminan $1.64 \/ 17.86 approx 9.2 %$ ini tashkil etadi. Demak, taxogeneratorsiz tizimda past tezliklarda bitta servo tsikl boʻyicha olingan tezlik bahosi sezilarli shovqinga ega; uni bir necha tsikl boʻyicha oʻrtacha qiymat yoki raqamli filtr orqali silliqlash zarur (masalan, $T_h$ oraligʻida baholanganda $Delta omega = 1.64 \/ 32 approx 0.05 degree"/s"$).

*Javob:* $Delta theta_q approx 1.44 dot 10^(-3) degree$; $N = 32$; $omega_q approx 17.86 degree"/s"$, $omega_m approx 186 "ayl/min"$; $n_"imp" approx 11$; $Delta omega approx 1.64 degree"/s"$.

== Masala 3: Detallarni taxlash uchun ARPS dasturi

*Masala sharti:* robot bitta `PART` nuqtasiga ketma-ket keltiriladigan uchta detalni olib, ularni idishga $X$ oʻqi boʻylab 60 mm qadam bilan qatorlab qoʻyishi kerak. Birinchi detal `BOX` nuqtasiga qoʻyiladi. Detalga yaqinlashish balandligi 50 mm, idishga yaqinlashish balandligi 100 mm.

#set enum(numbering: "a)")
+ ARPS tilida sikl koʻrinishidagi dasturni tuzing.
+ Oʻrgatilishi kerak boʻlgan nuqtalarni va ularni oʻrgatishda foydalaniladigan PRU rejimlarini koʻrsating.
#set enum(numbering: "1.")

*Yechim:*

- *Dastur.* Detallar sonini hisoblash uchun `N` oʻzgaruvchisi, idishdagi joyni oʻzgartirish uchun `SHIFT` buyrugʻi ishlatiladi (@lst-pallet). Sikl oxirida `BOX` nuqtasi dastlabki holatiga qaytariladi, aks holda dasturning keyingi ishga tushirilishida qoʻyish joyi siljib ketadi.

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
    caption: [Uchta detalni 60 mm qadam bilan taxlash dasturi],
  ) <lst-pallet>

- *Oʻrgatiladigan nuqtalar.* Dasturda faqat ikkita nuqta oʻrgatiladi: `PART` va `BOX`; qolgan holatlar (`GONEAR`, `GOSNEAR`, `SHIFT`) ulardan hisoblanadi. Shu sababli bu nuqtalar *koordinata nuqtalari* boʻlishi kerak (absolyut `#` nuqtalarni `SHIFT` bilan oʻzgartirib boʻlmaydi). Har bir nuqtani oʻrgatishda manipulyator avval JOINT rejimida ishchi zonaga chiqariladi, soʻngra WORLD yoki TOOL rejimida past tezlikda aniq joylashtiriladi va `HERE PART` (`HERE BOX`) buyrugʻi kiritiladi. Dastur bajarilayotganda pult COMP rejimida boʻladi.

*Javob:* dastur @lst-pallet da keltirilgan; detallar `BOX`, `BOX` + 60 mm va `BOX` + 120 mm nuqtalarga ($X$ boʻyicha) qoʻyiladi.

= Individual amaliy topshiriqlar

Har bir talaba oʻz variant raqamiga mos maʼlumotlar (@tab-variants) boʻyicha quyidagilarni bajarishi lozim (barcha variantlarda $T_h = 28$ ms, $T_s = 0.875$ ms, D-H parametrlari @tab-dh boʻyicha):

+ Berilgan $theta_1, theta_2, theta_3$ burchaklar uchun bilak markazi koordinatalarini ($P_x, P_y, P_z$) va yelka markazidan masofasini ($R_W$) hisoblash, natijani $R_max$ bilan solishtirish.
+ Boʻgʻin boshqaruv kanali uchun $Delta theta_q$, $N$, $omega_q$, $omega_m$ (ayl/min), bir servo tsikldagi impulslar soni va $Delta omega$ ni hisoblash.
+ $n$ ta detalni $X$ oʻqi boʻylab $s$ qadam bilan taxlovchi ARPS dasturini tuzish, oʻrgatiladigan nuqtalar va PRU rejimlarini koʻrsatish.
+ 1- va 2-bandlar natijalarini Python (NumPy) dasturi yordamida tekshirish.

#figure(
  btable(
    columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto),
    (
      [*Var.*],
      [*$theta_1$*],
      [*$theta_2$*],
      [*$theta_3$*],
      [*$N_e$ \ \[chiziq\]*],
      [*$i$*],
      [*$Delta q$ \ \[°/segment\]*],
      [*$n$ \ \[dona\]*],
      [*$s$ \ \[mm\]*],
    ),
    [*1*], [$20 degree$], [$-40 degree$], [$60 degree$], [500], [62.61], [0.40], [3], [50],
    [*2*], [$-30 degree$], [$-20 degree$], [$30 degree$], [1000], [107.82], [0.30], [4], [45],
    [*3*], [$45 degree$], [$-60 degree$], [$90 degree$], [250], [53.71], [0.60], [3], [60],
    [*4*], [$60 degree$], [$-10 degree$], [$20 degree$], [1000], [76.04], [0.50], [5], [40],
    [*5*], [$-45 degree$], [$-50 degree$], [$70 degree$], [500], [71.92], [0.35], [4], [55],
    [*6*], [$15 degree$], [$-35 degree$], [$50 degree$], [2000], [76.69], [0.25], [3], [70],
    [*7*], [$-60 degree$], [$-25 degree$], [$40 degree$], [250], [62.61], [0.80], [6], [35],
    [*8*], [$90 degree$], [$-45 degree$], [$45 degree$], [1000], [53.71], [0.45], [4], [50],
    [*9*], [$-15 degree$], [$-70 degree$], [$100 degree$], [500], [107.82], [0.20], [5], [45],
    [*10*], [$75 degree$], [$-30 degree$], [$60 degree$], [2000], [71.92], [0.55], [3], [65],
  ),
  caption: [Talabalar uchun individual topshiriqlar],
) <tab-variants>

= Nazorat savollari

+ RM-01 roboti qaysi robotning analogi hisoblanadi va qanday kinematik turga mansub?
+ Sferik bilak deganda nima tushuniladi va u kinematika masalalarini yechishni qanday soddalashtiradi?
+ Ikki pogʻonali boshqaruv tizimida yuqori va quyi darajalar qanday vazifalarni bajaradi?
+ Nima uchun quyi darajada interpolyatsiya zarur va interpolyatsiya qadamlari soni qanday aniqlanadi?
+ Inkremental enkoder va potensiometr datchiklarining vazifalari bir-biridan nimasi bilan farq qiladi?
+ Taxogenerator boʻlmagan tizimda boʻgʻin tezligi qanday baholanadi va bu usulning kamchiligi nimada?
+ PRU ning JOINT, WORLD va TOOL rejimlari qanday farqlanadi? Nima uchun WORLD rejimida ehtiyotkorlik talab etiladi?
+ Absolyut va koordinata nuqtalari farqini tushuntiring. Nima uchun oʻrgatish usuli yuqori aniqlik beradi?
