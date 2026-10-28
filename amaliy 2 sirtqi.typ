// ============================================================
//  Robotlar va robototexnik tizimlar — 2-amaliy mashgʻulot (sirtqi taʼlim) — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_2_sirtqi.typ
// ============================================================

#import "@preview/cetz:0.4.2"

#let headingblue = rgb(20, 50, 120)

#set document(title: "Sanoat robotining kinematikasi, komponovkalari, qisqiç va harakatlaniş qurilmalari")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 2  // amaliyot raqami
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
  )[Mavzu: Sanoat robotining kinematikasini örganiş. Robot manipulyatorlarining kinematik komponovkalari. Robot manipulyatorlarining konstruktiv xususiyatlari. Sanoat robotlarining qisqiç qurilmalarini örganiş. Robotlarning harakatlaniş qurilmalari]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* talabalarni sanoat roboti kinematikasining asosiy tuşunçalari, manipulyatorlarning kinematik komponovkalari va konstruktiv xususiyatlari, qisqiç qurilmalari hamda mobil robotlarning harakatlaniş qurilmalari bilan taniştiriş, şuningdek ikki zvenoli manipulyatorning kinematikasini, qisqiçning uşlaş kuçini va differensial yuritmali mobil robotning harakat parametrlarini hisoblaş könikmalarini şakllantiriş.

*Öquv vazifalari va kutilayotgan natijalar:*

- *Kinematika:* zveno, kinematik juftlik, kinematik zanjir va erkinlik darajasi tuşunçalarini farqlaş; töğri va teskari kinematika masalalarini ikki zvenoli tekis manipulyator misolida yeçiş.
- *Komponovka va konstruksiya:* manipulyatorlarning asosiy komponovkalarini, ularning işçi zonalarini, yuritma va reduktor turlarini tavsiflaş.
- *Qisqiç qurilmalari:* qisqiçlarni tasniflaş va mexanik qisqiçning zarur uşlaş kuçini hisoblaş.
- *Harakatlaniş qurilmalari:* mobil robotlarning harakatlaniş usullarini taqqoslaş va differensial yuritmali robotning tezliklarini aniqlaş.

= Nazariy asoslar va analitik formulalar

== Sanoat roboti kinematikasining asosiy tuşunçalari

*Kinematika* --- jismlar harakatini ularni yuzaga keltiruvçi kuçlarni hisobga olmasdan, faqat geometrik nuqtai nazardan örganadigan mexanika bölimi. Manipulyator *zvenolardan* (qattiq jismlar) va ularni özaro harakatçan biriktiruvçi *kinematik juftliklardan* (böğinlardan) taşkil topadi. Robotlarda asosan ikki turdagi V sinf juftlik işlatiladi: *aylanma* ($R$ --- _revolute_) va *ilgarilanma* ($P$ --- _prismatic_). Zvenolar ketma-ket ulanib *kinematik zanjir* hosil qiladi: oçiq zanjirda (ketma-ket manipulyator) oxirgi zveno erkin, yopiq zanjirda (parallel manipulyator) zvenolar halqa hosil qiladi.

Oçiq zanjirli manipulyatorning *erkinlik darajalari soni* böğinlar soniga teng. Fazoda işçi organni ixtiyoriy pozitsiya va orientatsiyaga keltiriş uçun 6 ta erkinlik darajasi zarur: dastlabki uçta böğin (*qöl*, _arm_) asosan pozitsiyani, keyingi uçtasi (*bilak*, _wrist_) orientatsiyani taʼminlaydi.

Kinematikaning ikki asosiy masalasi mavjud:

+ *Töğri masala:* böğin koordinatalari ($theta_1, theta_2, dots$) maʼlum bölganda işçi organning dekart koordinatalarini ($x, y, z$) va orientatsiyasini topiş. Bu masala har doim yagona yeçimga ega.
+ *Teskari masala:* işçi organning berilgan holati böyiça böğin koordinatalarini topiş. Bu masala bir neçta yeçimga ega bölişi yoki umuman yeçimga ega bölmasligi mumkin (nuqta işçi zonadan taşqarida bölsa).

*Ikki zvenoli tekis manipulyator* (@fig-2r) uçun töğri kinematika ($l_1, l_2$ --- zvenolar uzunligi):

$ x = l_1 cos theta_1 + l_2 cos(theta_1 + theta_2), quad y = l_1 sin theta_1 + l_2 sin(theta_1 + theta_2) $ <eq-fk>

Teskari kinematika kosinuslar teoremasidan kelib çiqadi:

$ cos theta_2 = (x^2 + y^2 - l_1^2 - l_2^2) / (2 l_1 l_2), quad theta_2 = plus.minus arccos(cos theta_2) $ <eq-ik2>

$ theta_1 = op("atan2")(y, x) - op("atan2")(l_2 sin theta_2, thin l_1 + l_2 cos theta_2) $ <eq-ik1>

$theta_2$ ning ikki işorasi “tirsak pastda” va “tirsak yuqorida” konfiguratsiyalariga mos keladi. Yeçim mavjud bölişi uçun nuqta halqasimon işçi zona içida yotişi kerak: $|l_1 - l_2| <= sqrt(x^2 + y^2) <= l_1 + l_2$.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let l1 = 3.2
    let l2 = 2.6
    let t1 = 30deg
    let t12 = 75deg
    let p1 = (l1 * calc.cos(t1), l1 * calc.sin(t1))
    let p2 = (p1.at(0) + l2 * calc.cos(t12), p1.at(1) + l2 * calc.sin(t12))
    // o'qlar
    line((-0.5, 0), (6.5, 0), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.6))
    content((6.5, 0), [$x$], anchor: "west")
    line((0, -0.5), (0, 5.4), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.6))
    content((0, 5.4), [$y$], anchor: "south")
    // asos
    line((-0.5, -0.35), (0.5, -0.35), stroke: 1.2pt)
    for k in range(5) { line((-0.45 + k * 0.22, -0.35), (-0.6 + k * 0.22, -0.55), stroke: 0.5pt) }
    // zvenolar
    line((0, 0), p1, stroke: 4pt + csec)
    line(p1, p2, stroke: 3.2pt + cacc)
    circle((0, 0), radius: 0.2, fill: white, stroke: 1.2pt + cprim)
    circle(p1, radius: 0.2, fill: white, stroke: 1.2pt + cprim)
    circle(p2, radius: 0.1, fill: red, stroke: none)
    content((p2.at(0) + 0.15, p2.at(1)), text(size: 9pt)[$P(x, y)$], anchor: "west")
    content((1.5, 1.25), text(size: 9pt)[$l_1$], anchor: "south-east")
    content((p1.at(0) + 0.2, p1.at(1) + 1.4), text(size: 9pt)[$l_2$], anchor: "east")
    // burchaklar
    arc((0, 0), start: 0deg, stop: 30deg, radius: 1.2, anchor: "origin", stroke: 0.7pt)
    content((1.35, 0.3), text(size: 9pt)[$theta_1$], anchor: "west")
    line(p1, (p1.at(0) + 1.4 * calc.cos(t1), p1.at(1) + 1.4 * calc.sin(t1)), stroke: (
      paint: luma(140),
      dash: "dashed",
      thickness: 0.6pt,
    ))
    arc(p1, start: 30deg, stop: 75deg, radius: 0.9, anchor: "origin", stroke: 0.7pt)
    content((p1.at(0) + 0.95, p1.at(1) + 0.55), text(size: 9pt)[$theta_2$], anchor: "west")
    // proyeksiyalar
    line(p2, (p2.at(0), 0), stroke: (paint: luma(150), dash: "dotted"))
    line(p2, (0, p2.at(1)), stroke: (paint: luma(150), dash: "dotted"))
  }),
  caption: [Ikki zvenoli tekis manipulyatorning kinematik sxemasi],
) <fig-2r>

== Manipulyatorlarning kinematik komponovkalari

*Komponovka* --- manipulyator böğinlarining turi, soni va özaro joylaşuvi. U pozitsiyalovçi uçta böğin kodi bilan belgilanadi va robotning işçi zonasi şakli, qattiqligi, aniqligi va qöllaniş sohasini aniqlaydi. Asosiy komponovkalar @fig-layouts da sxematik tarzda körsatilgan, ularning tavsifi @tab-layouts da keltirilgan.

#figure(
  cetz.canvas(length: 0.62cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let lk(a, b, w: 2.2pt, c: csec) = line(a, b, stroke: w + c)
    let rj(p) = {
      circle(p, radius: 0.22, fill: white, stroke: 1pt + cprim)
      circle(p, radius: 0.06, fill: cprim, stroke: none)
    }
    let pj(c, w, h) = rect(
      (c.at(0) - w / 2, c.at(1) - h / 2),
      (c.at(0) + w / 2, c.at(1) + h / 2),
      fill: csec.lighten(70%),
      stroke: 1pt + cprim,
    )
    let base(x) = {
      line((x - 0.9, 0), (x + 0.9, 0), stroke: 1.2pt)
      for k in range(6) { line((x - 0.85 + k * 0.32, 0), (x - 1.05 + k * 0.32, -0.25), stroke: 0.5pt) }
    }
    let ttl(x, body) = content((x, -0.6), align(center, text(size: 8pt, body)), anchor: "north")
    let ar(a, b) = line(a, b, stroke: 0.7pt + cacc, mark: (start: ">", end: ">", fill: cacc, scale: 0.4))

    // 1) Dekart
    let x = 1.5
    base(x)
    lk((x - 1.2, 0), (x - 1.2, 3.6), w: 1.5pt, c: luma(100))
    lk((x + 1.2, 0), (x + 1.2, 3.6), w: 1.5pt, c: luma(100))
    lk((x - 1.4, 3.6), (x + 1.4, 3.6), w: 2.5pt)
    pj((x + 0.2, 3.6), 0.7, 0.45)
    lk((x + 0.2, 3.4), (x + 0.2, 1.6), w: 2.2pt, c: cacc)
    ar((x - 1.0, 4.2), (x + 1.0, 4.2))
    ar((x + 0.55, 2.0), (x + 0.55, 3.0))
    ttl(x, [Dekart \ $P P P$])

    // 2) Silindrik
    x = 5.3
    base(x)
    lk((x, 0), (x, 3.8), w: 3pt, c: luma(110))
    pj((x, 2.6), 0.6, 0.6)
    lk((x, 2.6), (x + 1.6, 2.6), w: 2.2pt, c: cacc)
    ar((x + 0.5, 1.2), (x + 0.5, 2.1))
    ar((x + 0.6, 3.0), (x + 1.5, 3.0))
    arc((x, 0.7), start: 200deg, stop: 340deg, radius: (0.6, 0.2), anchor: "origin", stroke: 0.7pt + cacc, mark: (
      end: ">",
      fill: cacc,
      scale: 0.4,
    ))
    ttl(x, [Silindrik \ $R P P$])

    // 3) Sferik
    x = 9.1
    base(x)
    lk((x, 0), (x, 2.0), w: 3pt, c: luma(110))
    rj((x, 2.2))
    lk((x, 2.2), (x + 1.3, 3.2), w: 3.2pt)
    lk((x + 1.0, 2.97), (x + 1.9, 3.66), w: 2pt, c: cacc)
    arc((x, 0.7), start: 200deg, stop: 340deg, radius: (0.6, 0.2), anchor: "origin", stroke: 0.7pt + cacc, mark: (
      end: ">",
      fill: cacc,
      scale: 0.4,
    ))
    ttl(x, [Sferik \ $R R P$])

    // 4) SCARA (yon ko'rinish)
    x = 12.9
    base(x)
    lk((x - 0.6, 0), (x - 0.6, 2.8), w: 3pt, c: luma(110))
    lk((x - 0.6, 2.8), (x + 0.6, 2.8), w: 3pt)
    lk((x + 0.6, 2.55), (x + 1.7, 2.55), w: 2.6pt, c: cacc)
    line((x - 0.6, 3.3), (x - 0.6, 2.95), stroke: (paint: luma(120), dash: "dashed", thickness: 0.5pt))
    line((x + 0.6, 3.3), (x + 0.6, 2.4), stroke: (paint: luma(120), dash: "dashed", thickness: 0.5pt))
    lk((x + 1.7, 2.9), (x + 1.7, 1.4), w: 1.8pt, c: cprim)
    ar((x + 2.0, 1.5), (x + 2.0, 2.4))
    ttl(x, [SCARA \ $R R P$ (vertikal öqlar)])

    // 5) Antropomorf
    x = 16.7
    base(x)
    lk((x, 0), (x, 1.6), w: 3pt, c: luma(110))
    rj((x, 1.8))
    lk((x, 1.8), (x + 1.0, 3.3), w: 3.2pt)
    rj((x + 1.0, 3.3))
    lk((x + 1.0, 3.3), (x + 2.0, 2.3), w: 2.6pt, c: cacc)
    rj((x + 2.0, 2.3))
    ttl(x, [Antropomorf \ $R R R$])

    // 6) Delta
    x = 20.5
    lk((x - 1.4, 3.9), (x + 1.4, 3.9), w: 3pt, c: luma(110))
    for s in (-1, 0, 1) {
      let a = (x + s * 0.9, 3.9)
      let e = (x + s * 1.5, 2.8)
      let b = (x + s * 0.35, 1.2)
      lk(a, e, w: 2.2pt)
      lk(e, b, w: 1.2pt, c: cacc)
      circle(a, radius: 0.12, fill: white, stroke: 0.8pt + cprim)
    }
    lk((x - 0.5, 1.2), (x + 0.5, 1.2), w: 3pt, c: cprim)
    ttl(x, [Parallel (delta) \ yopiq zanjir])
  }),
  caption: [Sanoat robotlari manipulyatorlarining asosiy kinematik komponovkalari (sxematik)],
) <fig-layouts>

#figure(
  btable(
    columns: (auto, auto, 1fr, 1fr),
    align: (left + horizon, center + horizon, left + horizon, left + horizon),
    ([*Komponovka*], [*Işçi zona*], [*Afzalliklari*], [*Kamçiliklari*]),
    [Dekart (portal)],
    [Parallelepiped],
    [Boşqaruv sodda, aniqlik yuqori, katta yuklar],
    [Egallaydigan maydoni katta],
    [Silindrik],
    [Içi böş silindr],
    [Konstruksiyasi sodda, qattiqligi yaxşi],
    [Asos atrofidagi obyektlarga yetiş qiyin],
    [Sferik],
    [Sfera qatlami],
    [Işçi zona katta],
    [Aniqlik radius ösişi bilan kamayadi],
    [SCARA],
    [Silindrsimon],
    [Gorizontal tekislikda juda tez, vertikal yönalişda qattiq],
    [Vertikal yuriş va orientatsiya çeklangan],
    [Antropomorf],
    [Murakkab sferik],
    [Eng universal, tösiqlarni aylanib ötadi, ixçam asos],
    [Kinematikasi va boşqaruvi murakkab],
    [Parallel (delta)],
    [Gumbazsimon],
    [Tezlik va tezlaniş juda yuqori, zvenolar yengil],
    [Işçi zona kiçik],
  ),
  caption: [Asosiy komponovkalarning qiyosiy tavsifi],
) <tab-layouts>

== Manipulyatorlarning konstruktiv xususiyatlari

Sanoat robotining konstruksiyasi uning *asosiy texnik körsatkiçlari* bilan tavsiflanadi: erkinlik darajalari soni; nominal yuk kötariş qobiliyati (kg); erişiş radiusi (mm); takroriy pozitsiyalaş aniqligi (mm); böğinlarning maksimal burçak tezliklari (°/s); manipulyator massasi va himoya darajasi (IP).

*Yuritmalar.* Manipulyator böğinlari elektr, pnevmatik yoki gidravlik yuritmalar bilan harakatlantiriladi (@tab-drives). Zamonaviy sanoat robotlarining aksariyatida servoelektr yuritmalar işlatiladi: ular yuqori aniqlik, boşqaruvning qulayligi va toza iş muhitini taʼminlaydi.

#figure(
  btable(
    columns: (auto, 1fr, 1fr),
    align: (left + horizon, left + horizon, left + horizon),
    ([*Yuritma turi*], [*Afzalliklari*], [*Kamçiliklari va qöllanişi*]),
    [Elektr (servomotor)],
    [Aniqlik va boşqariluvçanlik yuqori, energiya manbai qulay, şovqin kam],
    [Katta momentlar uçun reduktor kerak; köpçilik zamonaviy robotlar],
    [Pnevmatik],
    [Arzon, sodda, tez, portlaş xavfsiz],
    [Oraliq nuqtalarda pozitsiyalaş qiyin; qisqiçlar, sodda manipulyatorlar],
    [Gidravlik],
    [Katta kuç va moment, ixçam],
    [Suyuqlik oqişi, qimmat xizmat; oğir yuk robotlari, maxsus texnika],
  ),
  caption: [Manipulyator yuritmalarining qiyosiy tavsifi],
) <tab-drives>

*Mexanik uzatmalar.* Elektr dvigatellarning yuqori tezligi va kiçik momenti böğinga reduktor orqali uzatiladi. Robotlarda böşliği (lyufti) juda kiçik reduktorlar işlatiladi: *tölqinli (garmonik) reduktorlar* --- katta uzatiş soni (50–160) va ixçamligi tufayli bilak böğinlarida; *sikloid (RV) reduktorlar* --- yuqori qattiqlik va zarbaga çidamliligi tufayli asos va yelka böğinlarida; *planetar reduktorlar* va *şarikli vint-gayka uzatmalari* --- ilgarilanma öqlarda. Reduktor dvigatel va böğin tezliklari hamda momentlarini quyidagiça boğlaydi ($i$ --- uzatiş soni, $eta$ --- FIK):

$ omega_q = omega_m / i, quad tau_q = eta dot i dot tau_m $ <eq-gear>

*Muvozanatlaş.* Yelka böğiniga tuşadigan oğirlik kuçi momentini kamaytiriş uçun oğir robotlarda prujinali, gidropnevmatik yoki yuk (ballast) muvozanatlagiçlari örnatiladi. Bundan taşqari, kabellar va pnevmatik şlanglar zvenolar içidan ötkaziladi, böğinlarda esa elektr töxtatilganda zvenoni uşlab turuvçi elektromagnit tormozlar böladi.

== Sanoat robotlarining qisqiç qurilmalari

*Qisqiç qurilmasi* --- manipulyator flanetsiga örnatiladigan va obyektni uşlaş, tutib turiş hamda qöyib yuboriş uçun möljallangan işçi organ. Uşlaş prinsipi böyiça qisqiçlar quyidagi turlarga bölinadi:

- *mexanik (barmoqli)* --- parallel siljuvçi yoki burçakli barmoqlar işqalaniş yoki şakl hisobiga uşlaydi; universal, uşlaş kuçi katta;
- *vakuumli* --- sörğiçlar bosimlar farqi hisobiga tekis va ziç sirtlarni uşlaydi (list, şişa, qutilar);
- *magnitli* --- elektromagnit yoki doimiy magnit ferromagnit detallarni uşlaydi;
- *moslaşuvçan va maxsus* --- adaptiv, yumşoq (_soft_), granulali, ignali qisqiçlar turli şakldagi obyektlar uçun.

Ikki barmoqli tekis jağli mexanik qisqiçda obyekt işqalaniş kuçi hisobiga uşlanadi. Obyekt massasi $m$, vertikal tezlaniş $a$, işqalaniş koeffitsiyenti $mu$, işqalaniş sirtlari soni $n$ va zaxira koeffitsiyenti $S$ bölganda har bir jağning zarur normal kuçi:

$ F_g = (m (g + a) S) / (mu n) $ <eq-grip>

Vakuumli qisqiçda bitta sörğiçning uşlab turiş kuçi $F_1 = Delta p dot pi D^2 \/ 4$ ga teng, bunda $Delta p$ --- atmosfera va sörğiç içidagi bosimlar farqi, $D$ --- sörğiç diametri.

== Robotlarning harakatlaniş qurilmalari

Mobil robotlar va harakatlanuvçi platformaga örnatilgan manipulyatorlar işçi zonani kengaytiriş uçun turli harakatlaniş qurilmalaridan foydalanadi (@tab-loco).

#figure(
  btable(
    columns: (auto, 1fr, 1fr),
    align: (left + horizon, left + horizon, left + horizon),
    ([*Harakatlaniş qurilmasi*], [*Xususiyatlari*], [*Qöllanişi*]),
    [Ğildirakli],
    [Tekis sirtda tez va energiya tejamkor; differensial, Akkerman, omni va mekanum ğildirakli sxemalar],
    [Sexlar va omborlardagi AGV/AMR, xizmat robotlari],
    [Tirtilli (gusenitsali)],
    [Notekis va yumşoq gruntda yuqori ötuvçanlik, burilişda sirpaniş],
    [Qutqaruv, harbiy, qişloq xöjaligi robotlari],
    [Qadamlovçi (oyoqli)],
    [Tösiq va zinapoyalardan ötadi, boşqaruvi murakkab, energiya sarfi yuqori],
    [Inspeksiya, tadqiqot, gumanoid robotlar],
    [Relsli (çiziqli öq)],
    [Sanoat robotini yönaltiruvçi böylab siljitadi (“7-öq”), aniqligi yuqori],
    [Bir neçta stanokka xizmat körsatiş, uzun detallarni payvandlaş],
    [Maxsus],
    [Uçuvçi, suzuvçi, sudraluvçi, quvur içida harakatlanuvçi],
    [Dronlar, suv osti va quvur inspeksiyasi],
  ),
  caption: [Robotlarning harakatlaniş qurilmalari],
) <tab-loco>

Sanoat şaroitida eng köp tarqalgan *differensial yuritmali* ğildirakli robotda ikki yetakçi ğildirak bitta öqda joylaşgan va mustaqil dvigatellar bilan aylantiriladi (@fig-diff). Ğildiraklar radiusi $r$, ular orasidagi masofa $L$, öng va çap ğildiraklarning burçak tezliklari $omega_R$ va $omega_L$ bölganda robotning çiziqli va burçak tezliklari hamda buriliş radiusi:

$ v = r (omega_R + omega_L) / 2, quad omega = r (omega_R - omega_L) / L, quad R = v / omega $ <eq-diff>

$omega_R = omega_L$ bölganda robot töğri çiziq böylab harakatlanadi, $omega_R = -omega_L$ bölganda esa joyida aylanadi.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let ar(a, b, col: black) = line(a, b, stroke: 1pt + col, mark: (end: ">", fill: col, scale: 0.6))
    // korpus
    rect((-1.6, -1.2), (1.6, 1.2), fill: luma(235), stroke: 1pt + cprim, radius: 4pt)
    // g'ildiraklar
    rect((-0.6, 1.25), (0.6, 1.65), fill: luma(80), stroke: none, radius: 2pt)
    rect((-0.6, -1.65), (0.6, -1.25), fill: luma(80), stroke: none, radius: 2pt)
    circle((-1.1, 0), radius: 0.15, fill: white, stroke: 0.8pt)
    content((-1.1, -0.2), text(size: 7pt)[tayanç \ ğildirak], anchor: "north")
    // o'q
    line((0, -2.4), (0, 2.4), stroke: (paint: luma(140), dash: "dash-dotted", thickness: 0.6pt))
    circle((0, 0), radius: 0.07, fill: black)
    // tezliklar
    ar((0.7, 1.45), (2.4, 1.45), col: cacc)
    content((2.45, 1.45), text(size: 9pt)[$v_L = r omega_L$], anchor: "west")
    ar((0.7, -1.45), (3.0, -1.45), col: cacc)
    content((3.05, -1.45), text(size: 9pt)[$v_R = r omega_R$], anchor: "west")
    ar((0, 0), (2.6, 0), col: csec)
    content((2.65, 0), text(size: 9pt)[$v$], anchor: "west")
    arc((0, 0), start: -40deg, stop: 40deg, radius: 0.8, anchor: "origin", stroke: 0.8pt + csec, mark: (
      end: ">",
      fill: csec,
      scale: 0.5,
    ))
    content((0.75, 0.65), text(size: 9pt)[$omega$], anchor: "south")
    // L
    line((-2.1, -1.45), (-2.1, 1.45), stroke: 0.8pt + cacc, mark: (start: ">", end: ">", fill: cacc, scale: 0.5))
    content((-2.2, 0), text(size: 9pt)[$L$], anchor: "east")
  }),
  caption: [Differensial yuritmali mobil robotning kinematik sxemasi (yuqoridan köriniş)],
) <fig-diff>

= Namunaviy masalalar va ularning yeçimlari

== Masala 1: Ikki zvenoli manipulyatorning töğri va teskari kinematikasi

*Masala şarti:* tekis manipulyator zvenolarining uzunliklari $l_1 = 0.5$ m, $l_2 = 0.4$ m, böğin burçaklari $theta_1 = 30 degree$, $theta_2 = 45 degree$.

#set enum(numbering: "a)")
+ Işçi organning koordinatalarini ($x, y$) toping.
+ Topilgan nuqta böyiça teskari kinematika masalasini yeçib, natijani tekşiring.
#set enum(numbering: "1.")

*Hisoblaş bosqiçlari:*

- *Töğri kinematika* (@eq-fk), $theta_1 + theta_2 = 75 degree$:
  $ x = 0.5 dot cos 30 degree + 0.4 dot cos 75 degree = 0.4330 + 0.1035 approx 0.5365 "m" $
  $ y = 0.5 dot sin 30 degree + 0.4 dot sin 75 degree = 0.2500 + 0.3864 approx 0.6364 "m" $

- *Işçi zonani tekşiriş:* $sqrt(x^2 + y^2) = sqrt(0.6928) approx 0.832$ m; $0.1 <= 0.832 <= 0.9$, nuqta işçi zonada.

- *Teskari kinematika* (@eq-ik2, @eq-ik1):
  $
    cos theta_2 = (0.6928 - 0.25 - 0.16) / (2 dot 0.5 dot 0.4) = 0.2828 / 0.4 = 0.7071 quad arrow.double quad theta_2 = 45 degree
  $
  $
    theta_1 = op("atan2")(0.6364, 0.5365) - op("atan2")(0.4 dot 0.7071, thin 0.5 + 0.4 dot 0.7071) \
    = 49.86 degree - 19.86 degree = 30 degree
  $
  Natija berilgan burçaklar bilan mos keladi. Ikkinçi yeçim ($theta_2 = -45 degree$) “tirsak yuqorida” konfiguratsiyasiga töğri keladi.

*Javob:* $x approx 0.537$ m, $y approx 0.636$ m; teskari masala $theta_1 = 30 degree$, $theta_2 = 45 degree$ ni beradi.

== Masala 2: Mexanik qisqiçning uşlaş kuçi

*Masala şarti:* ikki barmoqli tekis jağli qisqiç massasi $m = 1.5$ kg bölgan detalni $a = 4 "m/s"^2$ vertikal tezlaniş bilan kötaradi. Işqalaniş koeffitsiyenti $mu = 0.25$, zaxira koeffitsiyenti $S = 2$, işqalaniş sirtlari soni $n = 2$.

*Hisoblaş* (@eq-grip):
$ F_g = (1.5 dot (9.81 + 4) dot 2) / (0.25 dot 2) = 41.43 / 0.5 approx 82.9 "N" $

*Javob:* har bir jağ detalni kamida $F_g approx 82.9$ N kuç bilan siqişi kerak.

== Masala 3: Differensial yuritmali mobil robotning harakati

*Masala şarti:* AGV robotining ğildiraklari radiusi $r = 0.1$ m, ğildiraklar orasidagi masofa $L = 0.5$ m. Öng ğildirak $omega_R = 12$ rad/s, çap ğildirak $omega_L = 8$ rad/s burçak tezligi bilan aylanmoqda.

#set enum(numbering: "a)")
+ Robotning çiziqli va burçak tezligini, buriliş radiusini toping.
+ Robot $90 degree$ ga burilişi uçun qança vaqt kerakligini aniqlang.
#set enum(numbering: "1.")

*Hisoblaş bosqiçlari* (@eq-diff):

- *Tezliklar:*
  $ v = 0.1 dot (12 + 8) / 2 = 1.0 "m/s", quad omega = 0.1 dot (12 - 8) / 0.5 = 0.8 "rad/s" $
- *Buriliş radiusi:* $R = 1.0 \/ 0.8 = 1.25$ m. $omega_R > omega_L$ bölgani uçun robot çapga buriladi.
- *Buriliş vaqti:*
  $ t = (pi \/ 2) / omega = 1.571 / 0.8 approx 1.96 "s" $

*Javob:* $v = 1.0$ m/s, $omega = 0.8$ rad/s, $R = 1.25$ m; $t approx 1.96$ s.

= Individual amaliy topşiriqlar

Har bir talaba öz variant raqamiga mos maʼlumotlar (@tab-variants) böyiça quyidagilarni bajarişi lozim (barça variantlarda $S = 2$, $n = 2$):

+ Ikki zvenoli manipulyator uçun töğri kinematika masalasini yeçiş, nuqtaning işçi zonada ekanini tekşiriş va teskari masala orqali natijani tasdiqlaş.
+ Mexanik qisqiçning zarur uşlaş kuçini hisoblaş.
+ Differensial yuritmali robotning $v$, $omega$, $R$ qiymatlarini va $90 degree$ ga buriliş vaqtini aniqlaş.
+ Hisoblarni Python dasturi yordamida tekşiriş.

#figure(
  btable(
    columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto, auto, auto),
    (
      [*Var.*],
      [*$l_1$ \ \[m\]*],
      [*$l_2$ \ \[m\]*],
      [*$theta_1$*],
      [*$theta_2$*],
      [*$m$ \ \[kg\]*],
      [*$mu$*],
      [*$a$ \ \[m/s#super[2]\]*],
      [*$r$ \ \[m\]*],
      [*$L$ \ \[m\]*],
      [*$omega_R \/ omega_L$ \ \[rad/s\]*],
    ),
    [*1*],
    [0.40],
    [0.30],
    [$20 degree$],
    [$60 degree$],
    [1.0],
    [0.20],
    [3.0],
    [0.08],
    [0.40],
    [10 / 6],
    [*2*],
    [0.60],
    [0.45],
    [$45 degree$],
    [$30 degree$],
    [2.5],
    [0.30],
    [2.0],
    [0.10],
    [0.50],
    [15 / 9],
    [*3*],
    [0.50],
    [0.35],
    [$15 degree$],
    [$75 degree$],
    [0.8],
    [0.15],
    [5.0],
    [0.12],
    [0.60],
    [8 / 4],
    [*4*],
    [0.70],
    [0.50],
    [$60 degree$],
    [$40 degree$],
    [3.0],
    [0.35],
    [1.5],
    [0.075],
    [0.45],
    [20 / 16],
    [*5*],
    [0.45],
    [0.40],
    [$35 degree$],
    [$50 degree$],
    [1.2],
    [0.25],
    [4.0],
    [0.10],
    [0.55],
    [12 / 6],
    [*6*],
    [0.55],
    [0.30],
    [$10 degree$],
    [$90 degree$],
    [2.0],
    [0.40],
    [2.5],
    [0.09],
    [0.48],
    [9 / 5],
    [*7*],
    [0.65],
    [0.55],
    [$50 degree$],
    [$25 degree$],
    [4.0],
    [0.30],
    [2.0],
    [0.15],
    [0.70],
    [7 / 3],
    [*8*],
    [0.35],
    [0.25],
    [$25 degree$],
    [$65 degree$],
    [0.5],
    [0.20],
    [6.0],
    [0.06],
    [0.35],
    [18 / 12],
    [*9*],
    [0.80],
    [0.60],
    [$40 degree$],
    [$35 degree$],
    [5.0],
    [0.35],
    [1.0],
    [0.11],
    [0.52],
    [11 / 9],
    [*10*],
    [0.50],
    [0.50],
    [$30 degree$],
    [$80 degree$],
    [1.8],
    [0.25],
    [3.5],
    [0.10],
    [0.40],
    [14 / 6],
  ),
  caption: [Talabalar uçun individual topşiriqlar],
) <tab-variants>

= Nazorat savollari

+ Zveno, kinematik juftlik va kinematik zanjir deganda nima tuşuniladi? Oçiq va yopiq zanjirlar qanday farqlanadi?
+ Kinematikaning töğri va teskari masalalari nima? Nima uçun teskari masala bir neçta yeçimga ega bölişi mumkin?
+ Manipulyatorlarning asosiy kinematik komponovkalarini sanab, har birining işçi zonasi şaklini körsating.
+ SCARA va antropomorf robotlarning afzalliklari va qöllaniş sohalarini taqqoslang.
+ Robotlarda qanday yuritmalar va reduktorlar işlatiladi? Tölqinli va sikloid reduktorlar qaysi böğinlarda qöllaniladi?
+ Qisqiç qurilmalari uşlaş prinsipi böyiça qanday turlarga bölinadi?
+ Mexanik qisqiçning zarur uşlaş kuçi qanday omillarga boğliq?
+ Mobil robotlarning harakatlaniş qurilmalarini taqqoslang. Differensial yuritmali robot qanday qilib joyida aylanadi?
