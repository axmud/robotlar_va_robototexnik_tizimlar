// ============================================================
//  Robotlar va robototexnik tizimlar — 7-amaliy maşğulot — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_7.typ
// ============================================================

#import "@preview/cetz:0.4.2"

#let headingblue = rgb(20, 50, 120)

#set document(title: "Robotlarning harakatlaniş qurilmalari")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 7  // amaliyot raqami
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №#raqam]
  #v(0.4cm)
  #text(
    size: 14pt,
    weight: "bold",
  )[Mavzu: Sanoat robotlarining qisqiç qurilmalarini örganiş. Robotlarning harakatlaniş qurilmalari. 2-qism: harakatlaniş qurilmalari]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* talabalarni mobil robotlarning harakatlaniş qurilmalari --- ğildirakli, tirtilli, qadamlovçi va relsli tizimlarning tuzilişi, kinematikasi va qöllaniş sohalari bilan taniştiriş, şuningdek differensial, Akkerman va mecanum ğildirakli robotlarning kinematik parametrlarini, odometriya böyiça robot holatini va tirtilli yuritmaning zarur quvvatini hisoblaş könikmalarini şakllantiriş.

*Öquv vazifalari va kutilayotgan natijalar:*

- *Tasnif:* harakatlaniş qurilmalarini harakatlaniş usuli, manevrçanlik va öta oliş qobiliyati böyiça taqqoslaş.
- *Ğildirakli robotlar:* ğildirak turlarini, holonomik va noholonomik harakat tuşunçalarini farqlaş; differensial, Akkerman va mecanum sxemalari kinematikasini özlaştiriş.
- *Odometriya:* enkoder impulslari böyiça robotning yangi holatini (koordinatalari va yönalişini) aniqlaş.
- *Tirtilli va qadamlovçi robotlar:* tirtilli yuritmaning tortiş kuçi va quvvatini hisoblaş, qadamlovçi robotlarning statik turğunlik şartini tuşuntiriş.

= Nazariy asoslar va analitik formulalar

== Harakatlaniş qurilmalarining vazifasi va tasnifi

*Harakatlaniş qurilmasi* --- mobil robotni yoki unga örnatilgan manipulyatorni iş muhitida bir joydan ikkinçi joyga köçiruvçi mexanizm. U robotning tezligi, manevrçanligi, notekis sirtlardan öta oliş qobiliyati va energiya sarfini belgilaydi. Sanoatda (omborlar, sexlar) asosan ğildirakli robotlar, qişloq xöjaligi, quriliş va qutqaruv işlarida tirtilli va qadamlovçi robotlar qöllaniladi. Asosiy turlarning qiyosiy tavsifi @tab-loco da keltirilgan.

#figure(
  btable(
    columns: (auto, 1fr, 1fr, 1fr),
    align: (left + horizon, left + horizon, left + horizon, left + horizon),
    ([*Turi*], [*Afzalliklari*], [*Kamçiliklari*], [*Qöllanişi*]),
    [Ğildirakli],
    [Tekis sirtda tez, energiya tejamkor, boşqaruvi sodda],
    [Notekis va yumşoq gruntda öta oliş qobiliyati past],
    [AGV/AMR, ombor va xizmat robotlari],
    [Tirtilli],
    [Grunt bilan tayanç yuzasi katta, notekis va yumşoq sirtda yuqori öta oliş],
    [Burilişda sirpaniş, energiya sarfi va eyilişi katta],
    [Qişloq xöjaligi, quriliş, qutqaruv robotlari],
    [Qadamlovçi],
    [Töşiq va zinapoyalardan öta oladi, grunt bilan nuqtali kontakt],
    [Konstruksiyasi va boşqaruvi murakkab, tezligi past],
    [Inspeksiya, tadqiqot, gumanoid robotlar],
    [Relsli],
    [Aniqlik va takroriylik yuqori, ğildirak sirpanişi yöq],
    [Harakat faqat yönaltiruvçi böylab],
    [Sanoat robotining “7-öqi”, portal tizimlar],
  ),
  caption: [Harakatlaniş qurilmalarining qiyosiy tavsifi],
  placement: auto,
) <tab-loco>

== Ğildirakli harakatlaniş qurilmalari

*Ğildirak turlari.* Mobil robotlarda quyidagi ğildiraklar işlatiladi: *standart qatʼiy ğildirak* (öqi korpusga nisbatan qözğalmas); *buriluvçi ğildirak* (vertikal öq atrofida buriladi); *kastor ğildirak* (vertikal öqdan siljigan holda erkin buriladi, tayanç vazifasini bajaradi); *omni ğildirak* (gardişida ğildirak öqiga perpendikulyar erkin roliklar bor); *mecanum ğildirak* (roliklar ğildirak öqiga $45 degree$ burçak ostida joylaşgan).

*Holonomik va noholonomik harakat.* Standart ğildiraklar ön-yon tomonga sirpanmaydi, şuning uçun robot öz öqiga perpendikulyar yönalişda bevosita harakatlana olmaydi. Bu şart *noholonomik bağlaniş* deyiladi ($x, y$ --- robot markazining koordinatalari, $theta$ --- yönaliş burçagi):

$ dot(x) sin theta - dot(y) cos theta = 0 $ <eq-nonhol>

Omni va mecanum ğildirakli robotlarda bu çeklov yöq: ular istalgan yönalişda harakatlanib, bir vaqtda buriliş oladi. Bunday robotlar *holonomik* yoki *har tomonlama harakatlanuvçi* (_omnidirectional_) deyiladi.

=== Differensial yuritmali robot

Differensial sxemada ikki yetakçi ğildirak bitta öqda joylaşgan va mustaqil dvigatellar bilan aylantiriladi; turğunlik uçun bir yoki ikkita kastor ğildirak qöşiladi (@fig-diff). Ğildirak radiusi $r$, ğildiraklar orasidagi masofa $L$, öng va çap ğildiraklarning burçak tezliklari $omega_R$, $omega_L$ bölganda:

$
  v = r (omega_R + omega_L) / 2, quad omega = r (omega_R - omega_L) / L, quad R = v / omega = L / 2 dot (omega_R + omega_L) / (omega_R - omega_L)
$ <eq-diff>

Robot har bir onda *oniy aylaniş markazi* (OAM) atrofida aylanadi; u ğildiraklar öqining davomida, robot markazidan $R$ masofada yotadi. $omega_R = omega_L$ bölganda $R arrow infinity$ (töğri çiziqli harakat), $omega_R = -omega_L$ bölganda $R = 0$ (joyida aylaniş).

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let ar(a, b, col: black) = line(a, b, stroke: 1pt + col, mark: (end: ">", fill: col, scale: 0.6))
    // korpus
    rect((-1.4, -1.1), (1.4, 1.1), fill: luma(235), stroke: 1pt + cprim, radius: 4pt)
    rect((-0.55, 1.15), (0.55, 1.55), fill: luma(80), stroke: none, radius: 2pt)
    rect((-0.55, -1.55), (0.55, -1.15), fill: luma(80), stroke: none, radius: 2pt)
    circle((-1.0, 0), radius: 0.14, fill: white, stroke: 0.8pt)
    // ğildiraklar öqi va OAM
    line((0, -1.9), (0, 5.2), stroke: (paint: luma(140), dash: "dash-dotted", thickness: 0.6pt))
    circle((0, 4.6), radius: 0.1, fill: cacc, stroke: none)
    content((0.15, 4.6), text(size: 9pt)[OAM], anchor: "west")
    line((-0.25, 0), (-0.25, 4.6), stroke: 0.7pt + cacc, mark: (start: ">", end: ">", fill: cacc, scale: 0.45))
    content((-0.3, 2.9), text(size: 9pt)[$R$], anchor: "east")
    circle((0, 0), radius: 0.07, fill: black)
    // tezliklar
    ar((0.6, 1.35), (1.9, 1.35), col: cacc)
    content((1.95, 1.35), text(size: 9pt)[$v_L = r omega_L$], anchor: "west")
    ar((0.6, -1.35), (2.9, -1.35), col: cacc)
    content((2.95, -1.35), text(size: 9pt)[$v_R = r omega_R$], anchor: "west")
    ar((0, 0), (2.4, 0), col: csec)
    content((2.45, 0), text(size: 9pt)[$v$], anchor: "west")
    // L
    line((-1.9, -1.35), (-1.9, 1.35), stroke: 0.8pt + cacc, mark: (start: ">", end: ">", fill: cacc, scale: 0.5))
    content((-2.0, 0), text(size: 9pt)[$L$], anchor: "east")
    // trayektoriya yoyi
    arc((0, 0), start: -90deg, stop: -50deg, radius: 4.6, stroke: (paint: csec, dash: "dashed", thickness: 0.8pt))
  }),
  caption: [Differensial yuritmali robotning kinematik sxemasi va oniy aylaniş markazi (yuqoridan körinişi)],
  placement: auto,
) <fig-diff>

*Odometriya.* Robot holatini ğildirak enkoderlari böyiça aniqlaş usuli *odometriya* deyiladi. Kiçik $Delta t$ vaqt oraliğida enkoderlar $Delta n_R$ va $Delta n_L$ impuls hisoblagan bölsa ($N$ --- ğildirakning bir aylanişiga töğri keladigan impulslar soni):

$
  Delta phi_(R,L) = (2 pi Delta n_(R,L)) / N, quad Delta s = r (Delta phi_R + Delta phi_L) / 2, quad Delta theta = r (Delta phi_R - Delta phi_L) / L
$ <eq-odo1>

$
  x_(k+1) = x_k + Delta s cos(theta_k + (Delta theta) / 2), quad y_(k+1) = y_k + Delta s sin(theta_k + (Delta theta) / 2), \
  theta_(k+1) = theta_k + Delta theta
$ <eq-odo2>

Ğildiraklarning sirpaniş, radiusning noaniqligi va kvantlaş xatolari har qadamda yiğilib boradi, şuning uçun odometriya xatosi vaqt ötişi bilan ösadi. Amalda u LiDAR, IMU yoki GNSS (RTK) maʼlumotlari bilan Kalman filtri yordamida tuzatiladi.

=== Akkerman sxemali robot

Avtomobil va traktor tipidagi robotlarda orqa ğildiraklar qatʼiy, oldingi ğildiraklar esa buriluvçi böladi. Barça ğildiraklar sirpanmasdan aylaniši uçun ularning öqlari bitta OAM da kesişişi kerak (@fig-ack). Bunda içki oldingi ğildirak taşqisiga qaraganda kattaroq burçakka buriladi. Ğildirak bazasi $L_b$, izi $W$ va orqa öq markazigaça buriliş radiusi $R$ bölganda içki ($delta_i$) va taşqi ($delta_o$) ğildiraklarning buriliş burçaklari:

$
  delta_i = arctan L_b / (R - W \/ 2), quad delta_o = arctan L_b / (R + W \/ 2), quad cot delta_o - cot delta_i = W / L_b
$ <eq-ack>

Oxirgi tenglik *Akkerman şarti* deyiladi. Akkerman sxemali robot joyida aylana olmaydi; uning minimal buriliş radiusi ğildiraklarning maksimal buriliş burçagi bilan çeklangan.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let lb = 2.6
    let w = 1.6
    let R = 6.0
    // OAM orqa öq davomida (y = R)
    let icr = (0, R)
    // korpus
    rect((-0.4, -w / 2 - 0.15), (lb + 0.4, w / 2 + 0.15), stroke: 1pt + cprim, fill: luma(240), radius: 3pt)
    // orqa öq
    line((0, -w / 2), (0, w / 2), stroke: 1.5pt)
    let wh(c, ang) = {
      let (cx, cy) = c
      let dx = 0.35 * calc.cos(ang)
      let dy = 0.35 * calc.sin(ang)
      line((cx - dx, cy - dy), (cx + dx, cy + dy), stroke: 5pt + luma(60))
    }
    wh((0, w / 2), 0deg)
    wh((0, -w / 2), 0deg)
    // oldingi öq
    line((lb, -w / 2), (lb, w / 2), stroke: 1.5pt)
    let di = calc.atan(lb / (R - w / 2))
    let do = calc.atan(lb / (R + w / 2))
    wh((lb, w / 2), di)
    wh((lb, -w / 2), do)
    // OAM ga çiziqlar
    line((0, -w / 2), icr, stroke: (paint: luma(140), dash: "dash-dotted", thickness: 0.6pt))
    line((lb, w / 2), icr, stroke: (paint: cacc, dash: "dashed", thickness: 0.7pt))
    line((lb, -w / 2), icr, stroke: (paint: cacc, dash: "dashed", thickness: 0.7pt))
    circle(icr, radius: 0.1, fill: cacc, stroke: none)
    content((0.15, R + 0.1), text(size: 9pt)[OAM], anchor: "south-west")
    content((lb + 0.35, w / 2 + 0.3), text(size: 9pt)[$delta_i$], anchor: "west")
    content((lb + 0.35, -w / 2 - 0.3), text(size: 9pt)[$delta_o$], anchor: "west")
    // ölçamlar
    line((0, -w / 2 - 0.6), (lb, -w / 2 - 0.6), stroke: 0.8pt + cacc, mark: (
      start: ">",
      end: ">",
      fill: cacc,
      scale: 0.5,
    ))
    content((lb / 2, -w / 2 - 0.65), text(size: 9pt)[$L_b$], anchor: "north")
    line((-0.8, -w / 2), (-0.8, w / 2), stroke: 0.8pt + cacc, mark: (start: ">", end: ">", fill: cacc, scale: 0.5))
    content((-0.85, 0), text(size: 9pt)[$W$], anchor: "east")
    line((-0.25, 0), (-0.25, R), stroke: 0.7pt + csec, mark: (start: ">", end: ">", fill: csec, scale: 0.45))
    content((-0.3, R / 2 + 0.6), text(size: 9pt)[$R$], anchor: "east")
    line((0, 0), (0, R), stroke: (paint: luma(140), dash: "dotted", thickness: 0.6pt))
  }),
  caption: [Akkerman buriliş geometriyasi (yuqoridan körinişi; robot oldinga harakatlanib, çapga burilmoqda)],
  placement: auto,
) <fig-ack>

=== Mecanum ğildirakli robot

Törtta mecanum ğildirakli platforma istalgan yönalişda harakatlana oladi (@fig-mec). Robot korpusiga bağlangan koordinatalar tizimida berilgan tezliklar $v_x$ (oldinga), $v_y$ (çapga) va $omega$ (soat millariga teskari) böyiça ğildiraklarning zarur burçak tezliklari (teskari kinematika; $l_x$, $l_y$ --- robot markazidan ğildirak markazigaça böylama va köndalang masofalar):

$
  mat(delim: "[", omega_1; omega_2; omega_3; omega_4) = 1 / r mat(delim: "[", 1, -1, -(l_x + l_y); 1, 1, l_x + l_y; 1, 1, -(l_x + l_y); 1, -1, l_x + l_y) mat(delim: "[", v_x; v_y; omega)
$ <eq-mec>

bunda 1 --- oldingi çap, 2 --- oldingi öng, 3 --- orqa çap, 4 --- orqa öng ğildirak. Formula grunt bilan kontaktdagi roliklar öqlari @fig-mec dagidek joylaşgan hol uçun yozilgan; roliklar teskari örnatilsa, $v_y$ va $omega$ oldidagi işoralar özgaradi. Törtala ğildirak bir xil yönalişda aylansa, robot oldinga, diagonal juftlar qarama-qarşi aylansa, robot yon tomonga harakatlanadi.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let ar(a, b, col: black) = line(a, b, stroke: 1pt + col, mark: (end: ">", fill: col, scale: 0.6))
    rect((-1.6, -1.2), (1.6, 1.2), fill: luma(240), stroke: 1pt + cprim, radius: 3pt)
    let whs = ((1.2, 1.55, 1, [1]), (1.2, -1.55, -1, [2]), (-1.2, 1.55, -1, [3]), (-1.2, -1.55, 1, [4]))
    for (x, y, s, nm) in whs {
      rect((x - 0.5, y - 0.22), (x + 0.5, y + 0.22), fill: luma(90), stroke: none, radius: 2pt)
      for k in range(-1, 2) {
        let cx = x + k * 0.3
        line((cx - 0.12, y - 0.17 * s), (cx + 0.12, y + 0.17 * s), stroke: 1.2pt + white)
      }
      content((x, y + 0.45 * calc.abs(y) / y), text(size: 9pt)[#nm], anchor: if y > 0 { "south" } else { "north" })
    }
    // koordinatalar
    ar((0, 0), (1.0, 0), col: red.darken(10%))
    content((1.0, 0), text(size: 9pt)[$x$], anchor: "west")
    ar((0, 0), (0, 1.0), col: green.darken(30%))
    content((0, 1.0), text(size: 9pt)[$y$], anchor: "south")
    arc((0, 0), start: 200deg, stop: 300deg, radius: 0.55, anchor: "origin", stroke: 0.8pt + csec, mark: (
      end: ">",
      fill: csec,
      scale: 0.45,
    ))
    content((-0.6, -0.35), text(size: 9pt)[$omega$], anchor: "east")
    // ölçamlar
    line((0, -2.7), (1.2, -2.7), stroke: 0.8pt + cacc, mark: (start: ">", end: ">", fill: cacc, scale: 0.5))
    content((0.6, -2.75), text(size: 9pt)[$l_x$], anchor: "north")
    line((2.1, 0), (2.1, 1.55), stroke: 0.8pt + cacc, mark: (start: ">", end: ">", fill: cacc, scale: 0.5))
    content((2.15, 0.78), text(size: 9pt)[$l_y$], anchor: "west")
    content((-2.4, 0), text(size: 8pt)[orqa], anchor: "east")
    content((2.4, -0.6), text(size: 8pt)[oldi], anchor: "west")
  }),
  caption: [Mecanum ğildirakli platforma (yuqoridan körinişi; oq çiziqlar --- grunt bilan kontaktdagi roliklar öqlari)],
) <fig-mec>

== Tirtilli harakatlaniş qurilmalari

Tirtilli yuritmada robot ğildiraklar (yetakçi yulduzça, yönaltiruvçi va tayanç katoklari) atrofida aylanuvçi uzluksiz tasma böylab harakatlanadi. Tayanç yuzasi katta bölgani uçun gruntga tuşadigan bosim kiçik, öta oliş qobiliyati esa yuqori. Robot öng va çap tirtillarning tezliklari farqi hisobiga buriladi (_skid steering_); bunda tirtillar gruntda sirpanadi, şuning uçun burilişga qöşimça kuç va energiya sarflanadi.

Qiyalik burçagi $alpha$ bölgan yöl böylab $v$ tezlik bilan bir tekis harakatlaniş uçun zarur tortiş kuçi va dvigatel quvvati ($m$ --- robot massasi, $f$ --- harakatga qarşilik koeffitsiyenti, $eta$ --- uzatmaning FIK):

$ F_t = m g (f cos alpha + sin alpha) + m a, quad P = (F_t v) / eta $ <eq-track>

Tirtil gruntga nisbatan sirpanmasligi uçun tortiş kuçi ilaşiş kuçidan oşmasligi kerak ($phi$ --- ilaşiş koeffitsiyenti):

$ F_t <= phi m g cos alpha $ <eq-adh>

== Qadamlovçi harakatlaniş qurilmalari

Qadamlovçi robotlar oyoqlarini navbat bilan kötarib qöyiş orqali harakatlanadi. Har bir oyoq odatda 2–3 erkinlik darajasiga ega bölgan kiçik manipulyatordir. Oyoqlar soniga köra ikki oyoqli (gumanoid), tört oyoqli va olti oyoqli robotlar mavjud.

*Statik turğunlik.* Sekin harakatlanayotgan robot ağdarilmasligi uçun uning massa markazining gorizontal tekislikdagi proyeksiyasi yerga tayangan oyoqlar hosil qilgan *tayanç poligoni* içida yotişi kerak (@fig-support). Turğunlik zaxirasi massa markazi proyeksiyasidan poligonning eng yaqin tomonigaça bölgan masofa bilan baholanadi:

$
  S_m = min_i d_i, quad d_i = (|(x_(i+1) - x_i)(y_i - y_c) - (x_i - x_c)(y_(i+1) - y_i)|) / sqrt((x_(i+1) - x_i)^2 + (y_(i+1) - y_i)^2)
$ <eq-margin>

bunda $(x_c, y_c)$ --- massa markazi proyeksiyasi, $(x_i, y_i)$ --- tayanç nuqtalari. Olti oyoqli robotlarda köp qöllaniladigan *tripod yuriş* da har doim uçta oyoq (bir tomonning oldingi va orqa, ikkinçi tomonning örta oyoği) yerga tayanadi, şuning uçun robot har bir onda statik turğun böladi. Tez yuruvçi ikki va tört oyoqli robotlar esa *dinamik turğunlik* hisobiga muvozanat saqlaydi.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let A = (0, 0)
    let B = (4.0, 0.4)
    let C = (1.8, 3.0)
    line(A, B, C, close: true, fill: csec.lighten(82%), stroke: 1pt + csec)
    for (p, nm, off, anc) in ((A, [1], (-0.2, 0), "east"), (B, [2], (0.2, 0), "west"), (C, [3], (0, 0.2), "south")) {
      circle(p, radius: 0.12, fill: cprim, stroke: none)
      content((p.at(0) + off.at(0), p.at(1) + off.at(1)), text(size: 9pt)[#nm], anchor: anc)
    }
    let G = (1.9, 1.0)
    circle(G, radius: 0.1, fill: cacc, stroke: none)
    content((G.at(0) + 0.15, G.at(1) + 0.1), text(size: 9pt)[$G$], anchor: "south-west")
    // eng yaqin tomon (AB) gaça perpendikulyar
    let ux = 4.0 / calc.sqrt(16.16)
    let uy = 0.4 / calc.sqrt(16.16)
    let t = G.at(0) * ux + G.at(1) * uy
    let F = (t * ux, t * uy)
    line(G, F, stroke: 0.9pt + cacc, mark: (start: ">", end: ">", fill: cacc, scale: 0.45))
    content(((G.at(0) + F.at(0)) / 2 + 0.1, (G.at(1) + F.at(1)) / 2), text(size: 9pt)[$S_m$], anchor: "west")
    content(
      (5.6, 1.5),
      box(
        fill: luma(245),
        stroke: 0.6pt + csec,
        radius: 3pt,
        inset: 5pt,
        align(left, text(size: 8.5pt)[
          1, 2, 3 --- tayanç oyoqlari \
          $G$ --- massa markazi proyeksiyasi \
          $S_m$ --- turğunlik zaxirasi
        ]),
      ),
      anchor: "west",
    )
  }),
  caption: [Tayanç poligoni va statik turğunlik zaxirasi],
) <fig-support>

== Relsli va maxsus harakatlaniş qurilmalari

*Relsli (çiziqli) öqlar* sanoat robotini yönaltiruvçi böylab siljitadi va uning iş zonasini kengaytiradi; bunday öq robotning “7-öqi” deb ataladi va bitta robotga bir neçta stanokka xizmat körsatiş yoki uzun detallarni payvandlaş imkonini beradi. Relsli tizimlarda ğildirak sirpanişi bölmagani uçun pozitsiyalaş aniqligi yuqori. *Maxsus* harakatlaniş qurilmalariga uçuvçi (dronlar), suzuvçi, quvur içida va vertikal sirtlarda (magnitli yoki vakuumli tayançlar bilan) harakatlanuvçi robotlar kiradi.

= Namunaviy masalalar va ularning yeçimlari

== Masala 1: Differensial robotning odometriyasi

*Masala şarti:* differensial yuritmali robotning ğildirak radiusi $r = 0.05$ m, ğildiraklar orasidagi masofa $L = 0.3$ m, enkoderlar ğildirakning bir aylanişiga $N = 2000$ impuls beradi. Robot $(x, y, theta) = (0, 0, 0)$ holatdan harakatlanib, bir oraliqda öng enkoder $Delta n_R = 1200$, çap enkoder $Delta n_L = 800$ impuls hisobladi.

#set enum(numbering: "a)")
+ Enkoderning çiziqli siljiş böyiça ajratiş qobiliyatini toping.
+ Robotning yangi holatini ($x$, $y$, $theta$) aniqlang.
#set enum(numbering: "1.")

*Hisoblaş bosqiçlari:*

- *Ajratiş qobiliyati:*
  $ Delta_s = (2 pi r) / N = (2 pi dot 0.05) / 2000 approx 1.57 dot 10^(-4) "m" = 0.157 "mm" $

- *Ğildiraklarning burilişi* (@eq-odo1):
  $
    Delta phi_R = (2 pi dot 1200) / 2000 approx 3.770 "rad", quad Delta phi_L = (2 pi dot 800) / 2000 approx 2.513 "rad"
  $

- *Yöl va yönaliş özgarişi:*
  $ Delta s = 0.05 dot (3.770 + 2.513) / 2 approx 0.1571 "m" $
  $ Delta theta = 0.05 dot (3.770 - 2.513) / 0.3 approx 0.2094 "rad" = 12 degree $

- *Yangi holat* (@eq-odo2), $theta_k + Delta theta \/ 2 = 6 degree$:
  $
    x = 0.1571 dot cos 6 degree approx 0.1562 "m", quad y = 0.1571 dot sin 6 degree approx 0.0164 "m", quad theta = 12 degree
  $

*Javob:* $Delta_s approx 0.157$ mm; robotning yangi holati $(0.156 "m", 0.016 "m", 12 degree)$.

== Masala 2: Akkerman sxemali qişloq xöjaligi robotining buriliş burçaklari

*Masala şarti:* traktor tipidagi avtonom robotning ğildirak bazasi $L_b = 2.5$ m, izi $W = 1.5$ m. Robot dala çetida orqa öq markazi böyiça $R = 8$ m radiusli yoy bilan burilişi kerak. Oldingi ğildiraklarning buriliş burçaklarini toping va Akkerman şarti bajarilişini tekşiring.

*Hisoblaş* (@eq-ack):
$ delta_i = arctan 2.5 / (8 - 0.75) = arctan 0.3448 approx 19.03 degree $
$ delta_o = arctan 2.5 / (8 + 0.75) = arctan 0.2857 approx 15.95 degree $

*Tekşiriş:*
$ cot 15.95 degree - cot 19.03 degree = 3.50 - 2.90 = 0.60 = W / L_b = 1.5 / 2.5 $

*Javob:* $delta_i approx 19.0 degree$, $delta_o approx 15.9 degree$; içki ğildirak taşqisidan taxminan $3.1 degree$ ga köproq buriladi.

== Masala 3: Mecanum ğildirakli platformaning teskari kinematikasi

*Masala şarti:* ombor robotining mecanum ğildiraklari radiusi $r = 0.05$ m, $l_x = 0.2$ m, $l_y = 0.15$ m. Robot bir vaqtda $v_x = 0.3$ m/s, $v_y = 0.2$ m/s tezlik bilan siljib, $omega = 0.5$ rad/s burçak tezlik bilan burilişi kerak. Ğildiraklarning burçak tezliklarini toping.

*Hisoblaş* (@eq-mec), $(l_x + l_y) omega = 0.35 dot 0.5 = 0.175$ m/s:
$ omega_1 = (0.3 - 0.2 - 0.175) / 0.05 = -1.5 "rad/s", quad omega_2 = (0.3 + 0.2 + 0.175) / 0.05 = 13.5 "rad/s" $
$ omega_3 = (0.3 + 0.2 - 0.175) / 0.05 = 6.5 "rad/s", quad omega_4 = (0.3 - 0.2 + 0.175) / 0.05 = 5.5 "rad/s" $

*Javob:* $omega_1 = -1.5$, $omega_2 = 13.5$, $omega_3 = 6.5$, $omega_4 = 5.5$ rad/s. Manfiy işora oldingi çap ğildirak teskari yönalişda aylanişini bildiradi.

== Masala 4: Tirtilli robot yuritmasining quvvati

*Masala şarti:* massasi $m = 120$ kg bölgan tirtilli qişloq xöjaligi roboti $alpha = 15 degree$ qiyalikda $v = 0.5$ m/s tezlik bilan bir tekis kötariladi. Harakatga qarşilik koeffitsiyenti $f = 0.08$, uzatma FIK $eta = 0.75$, tirtilning grunt bilan ilaşiş koeffitsiyenti $phi = 0.6$. Zarur tortiş kuçi va quvvatni toping, tirtil sirpanmasligini tekşiring.

*Hisoblaş bosqiçlari* (@eq-track, @eq-adh):

- *Tortiş kuçi:*
  $
    F_t = 120 dot 9.81 dot (0.08 dot cos 15 degree + sin 15 degree) \
    = 1177.2 dot (0.0773 + 0.2588) approx 395.6 "N"
  $
- *Quvvat:*
  $ P = (395.6 dot 0.5) / 0.75 approx 264 "Vt" $
- *Ilaşiş şarti:*
  $ phi m g cos alpha = 0.6 dot 1177.2 dot 0.9659 approx 682.3 "N" > 395.6 "N" $

*Javob:* $F_t approx 396$ N, $P approx 264$ Vt; tortiş kuçi ilaşiş kuçidan kiçik, demak tirtil sirpanmaydi.

= Individual amaliy topşiriqlar

Har bir talaba öz variant raqamiga mos maʼlumotlar (@tab-var-a va @tab-var-b) böyiça quyidagilarni bajarişi lozim:

+ Differensial robot uçun enkoderning ajratiş qobiliyatini va $(0, 0, 0)$ holatdan keyingi yangi holatni hisoblaş.
+ Akkerman sxemali robot uçun $delta_i$, $delta_o$ ni hisoblaş va Akkerman şartini tekşiriş.
+ Mecanum ğildirakli platforma uçun ğildiraklarning burçak tezliklarini aniqlaş.
+ Tirtilli robot uçun tortiş kuçi, quvvat va ilaşiş şartini tekşiriş ($phi = 0.6$, $eta = 0.75$).
+ 1- va 3-bandlar natijalarini Python dasturi yordamida tekşiriş.

#figure(
  btable(
    columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto),
    (
      [*Var.*],
      [*$r$ \ \[m\]*],
      [*$L$ \ \[m\]*],
      [*$N$ \ \[imp\]*],
      [*$Delta n_R$*],
      [*$Delta n_L$*],
      [*$L_b$ \ \[m\]*],
      [*$W$ \ \[m\]*],
      [*$R$ \ \[m\]*],
    ),
    [*1*],
    [0.05],
    [0.30],
    [1000],
    [700],
    [500],
    [2.2],
    [1.4],
    [6],
    [*2*],
    [0.06],
    [0.35],
    [2000],
    [1500],
    [900],
    [2.8],
    [1.6],
    [10],
    [*3*],
    [0.04],
    [0.25],
    [1024],
    [600],
    [600],
    [1.8],
    [1.2],
    [5],
    [*4*],
    [0.08],
    [0.45],
    [4096],
    [2500],
    [1800],
    [3.0],
    [1.8],
    [12],
    [*5*],
    [0.05],
    [0.32],
    [2048],
    [1000],
    [1400],
    [2.4],
    [1.5],
    [7],
    [*6*],
    [0.07],
    [0.40],
    [1000],
    [800],
    [400],
    [2.6],
    [1.7],
    [9],
    [*7*],
    [0.10],
    [0.50],
    [4000],
    [3000],
    [2600],
    [3.2],
    [2.0],
    [15],
    [*8*],
    [0.045],
    [0.28],
    [500],
    [350],
    [200],
    [2.0],
    [1.3],
    [5.5],
    [*9*],
    [0.06],
    [0.38],
    [2500],
    [900],
    [1500],
    [2.7],
    [1.6],
    [8],
    [*10*],
    [0.09],
    [0.48],
    [3000],
    [2200],
    [1200],
    [3.5],
    [2.1],
    [11],
  ),
  caption: [Individual topşiriqlar: differensial va Akkerman sxemali robotlar],
) <tab-var-a>

#figure(
  btable(
    columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto, auto),
    (
      [*Var.*],
      [*$r_m$ \ \[m\]*],
      [*$l_x + l_y$ \ \[m\]*],
      [*$v_x$ \ \[m/s\]*],
      [*$v_y$ \ \[m/s\]*],
      [*$omega$ \ \[rad/s\]*],
      [*$m$ \ \[kg\]*],
      [*$alpha$*],
      [*$f$*],
      [*$v$ \ \[m/s\]*],
    ),
    [*1*],
    [0.05],
    [0.30],
    [0.4],
    [0.0],
    [0.3],
    [80],
    [$10 degree$],
    [0.06],
    [0.6],
    [*2*],
    [0.06],
    [0.40],
    [0.2],
    [0.3],
    [0.0],
    [150],
    [$12 degree$],
    [0.08],
    [0.4],
    [*3*],
    [0.04],
    [0.25],
    [0.0],
    [0.4],
    [0.5],
    [60],
    [$20 degree$],
    [0.07],
    [0.3],
    [*4*],
    [0.075],
    [0.45],
    [0.5],
    [-0.2],
    [0.4],
    [200],
    [$8 degree$],
    [0.10],
    [0.8],
    [*5*],
    [0.05],
    [0.35],
    [-0.3],
    [0.1],
    [0.6],
    [100],
    [$15 degree$],
    [0.05],
    [0.5],
    [*6*],
    [0.06],
    [0.38],
    [0.3],
    [0.3],
    [-0.5],
    [90],
    [$18 degree$],
    [0.09],
    [0.35],
    [*7*],
    [0.10],
    [0.60],
    [0.6],
    [0.0],
    [-0.2],
    [300],
    [$5 degree$],
    [0.12],
    [1.0],
    [*8*],
    [0.045],
    [0.28],
    [0.1],
    [-0.4],
    [0.3],
    [70],
    [$22 degree$],
    [0.06],
    [0.25],
    [*9*],
    [0.065],
    [0.42],
    [0.4],
    [0.2],
    [0.2],
    [180],
    [$14 degree$],
    [0.08],
    [0.45],
    [*10*],
    [0.08],
    [0.50],
    [-0.2],
    [-0.3],
    [0.7],
    [250],
    [$10 degree$],
    [0.11],
    [0.7],
  ),
  caption: [Individual topşiriqlar: mecanum ğildirakli va tirtilli robotlar],
) <tab-var-b>

= Nazorat savollari

+ Mobil robotlarning harakatlaniş qurilmalari qanday turlarga bölinadi? Har birining afzallik va kamçiliklarini ayting.
+ Holonomik va noholonomik harakatning farqi nimada? Qaysi ğildiraklar holonomik harakatni taʼminlaydi?
+ Differensial yuritmali robot qanday qilib töğri çiziq böylab harakatlanadi va joyida aylanadi?
+ Oniy aylaniş markazi nima va u differensial hamda Akkerman sxemalarida qayerda joylaşadi?
+ Odometriya qanday amalga oşiriladi? Nima uçun odometriya xatosi vaqt ötişi bilan ösadi?
+ Akkerman şarti nimani bildiradi va nima uçun içki ğildirak kattaroq burçakka buriladi?
+ Tirtilli robotning tortiş kuçi qanday omillarga bağliq? Ilaşiş şarti nima uçun tekşiriladi?
+ Qadamlovçi robotning statik turğunlik şarti nima? Tripod yuriş qanday amalga oşiriladi?
