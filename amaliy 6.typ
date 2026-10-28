// ============================================================
//  Robotlar va robototexnik tizimlar — 6-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_6.typ
// ============================================================

#import "@preview/cetz:0.4.2"

#let headingblue = rgb(20, 50, 120)

#set document(title: "Sanoat robotlarining qisqiç qurilmalarini örganiş")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 6  // amaliyot raqami
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
  #text(size: 14pt, weight: "bold")[Mavzu: Sanoat robotlarining qisqiç qurilmalarini örganiş. Robotlarning harakatlaniş qurilmalari. 1-qism: qisqiç qurilmalari]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* talabalarni sanoat robotlarining qisqiç qurilmalari (_grippers_) --- ularning vazifasi, tasnifi, işlaş prinsiplari va konstruktiv turlari bilan taniştiriş, şuningdek mexanik, vakuumli va elektromagnitli qisqiçlarning uşlaş kuçini hamda yuritma parametrlarini hisoblaş könikmalarini şakllantiriş.

*Öquv vazifalari va kutilayotgan natijalar:*

- *Tasnif:* qisqiç qurilmalarini işlaş prinsipi, yuritma turi, barmoqlar soni va boşqariş usuli böyiça tasniflaş, ularning qöllaniş sohalarini farqlaş.
- *Uşlaş mexanikasi:* işqalaniş konusi, şakl böyiça va kuç böyiça yopiliş (_form closure_, _force closure_) tuşunçalarini özlaştiriş; tekis va V-simon jağlar uçun zarur uşlaş kuçini hisoblaş.
- *Yuritma hisobi:* ponali uzatiş mexanizmli pnevmatik qisqiç uçun silindr kuçi va diametrini aniqlaş.
- *Vakuumli va magnitli qisqiçlar:* sörğiçlar soni va diametrini, elektromagnit qutblaridagi zarur magnit induksiyasini hisoblaş.

= Nazariy asoslar va analitik formulalar

== Qisqiç qurilmalarining vazifasi va tasnifi

*Qisqiç qurilmasi* (uşlagiç, _gripper_) --- manipulyatorning oxirgi zvenosiga (flanetsiga) örnatiladigan va obyektni uşlab oliş, uni köçiriş davomida berilgan holatda tutib turiş hamda kerakli joyda qöyib yuboriş uçun möljallangan işçi organ. Qisqiç robotning taşqi muhit bilan bevosita taʼsirlaşadigan yagona qismi bölgani uçun butun robototexnik kompleksning işonçliligi va unumdorligi köp jihatdan unga boğliq. Köp hollarda bitta robot turli detallar bilan işlaşi uçun qisqiçlar *asbobni avtomatik almaştiriş qurilmasi* (_tool changer_) orqali flanetsga ulanadi.

Qisqiç qurilmalari asosan obyektni uşlab turiş prinsipi böyiça tasniflanadi (@fig-class).

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let bx(c, w, h, body, fill: white) = {
      rect(
        (c.at(0) - w / 2, c.at(1) - h / 2),
        (c.at(0) + w / 2, c.at(1) + h / 2),
        fill: fill,
        stroke: 0.9pt + cprim,
        radius: 2pt,
      )
      content(c, align(center, text(size: 8.5pt, body)))
    }
    let xs = (1.75, 5.45, 9.15, 12.85)
    bx((7.3, 4.0), 4.4, 0.8, fill: csec.lighten(80%))[*Qisqiç qurilmalari*]
    line((7.3, 3.6), (7.3, 3.1), stroke: 0.8pt)
    line((xs.at(0), 3.1), (xs.at(3), 3.1), stroke: 0.8pt)
    for x in xs {
      line((x, 3.1), (x, 2.65), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.5))
    }
    let names = ([*Mexanik* \ (barmoqli)], [*Vakuumli*], [*Magnitli*], [*Moslaşuvçan* \ *va maxsus*])
    let subs = (
      [parallel siljuvçi \ burçakli (riçagli) \ ponali, reyka-tişli \ 2, 3 va köp barmoqli],
      [ejektorli (pnevmatik) \ vakuum nasosli \ passiv sörğiçli],
      [elektromagnitli \ doimiy magnitli \ elektropermanent],
      [adaptiv barmoqli \ yumşoq (_soft_) \ granulali (universal) \ ignali, adgeziv],
    )
    for (k, x) in xs.enumerate() {
      bx((x, 2.2), 3.3, 0.9, fill: cacc.lighten(88%), names.at(k))
      line((x, 1.75), (x, 1.45), stroke: (paint: luma(140), dash: "dashed"))
      content((x, 1.4), align(center, text(size: 8pt, subs.at(k))), anchor: "north")
    }
  }),
  caption: [Sanoat robotlari qisqiç qurilmalarining uşlaş prinsipi böyiça tasnifi],
) <fig-class>

Uşlaş prinsipidan taşqari qisqiçlar quyidagi belgilar böyiça ham farqlanadi: *yuritma turi* böyiça (pnevmatik, elektr, gidravlik); *boşqariş usuli* böyiça (boşqarilmaydigan --- passiv, buyruq böyiça işlaydigan, qatʼiy dasturlanadigan va datçiklar yordamida moslaşuvçan --- adaptiv); *ixtisoslaşuv darajasi* böyiça (maxsus, keng kölamli va universal). Turli prinsiplarning qiyosiy tavsifi @tab-compare da keltirilgan.

#figure(
  btable(
    columns: (auto, 1fr, 1fr, 1fr),
    align: (left + horizon, left + horizon, left + horizon, left + horizon),
    ([*Turi*], [*Afzalliklari*], [*Kamçiliklari*], [*Qöllaniş sohasi*]),
    [Mexanik], [Katta uşlaş kuçi, joylaştiriş aniqligi yuqori, istalgan materialga mos], [Har bir şakl uçun jağlarni moslaş kerak, detalni şikastlaşi mumkin], [Maşinasozlik detallari, stanoklarga xizmat körsatiş, yiğiş],
    [Vakuumli], [Konstruksiyasi oddiy, yengil, sirtni şikastlamaydi], [Faqat tekis va ziç sirtlar, kuç atmosfera bosimi bilan çeklangan], [Listli materiallar, şişa, qadoqlangan mahsulotlar],
    [Magnitli], [Tez işlaydi, uşlaş kuçi katta, sirt şakliga kam boğliq], [Faqat ferromagnit materiallar, qoldiq magnitlaniş], [Pölat list va detallar, temir-tersak],
    [Moslaşuvçan], [Turli şakldagi obyektlarni bitta qisqiç bilan uşlaydi], [Uşlaş kuçi va aniqligi past, boşqaruvi murakkab], [Oziq-ovqat, qişloq xöjaligi, logistika],
  ),
  caption: [Qisqiç qurilmalarining asosiy turlarini qiyosiy tavsifi],
) <tab-compare>

== Uşlaş mexanikasi: işqalaniş konusi va yopiliş şartlari

Obyekt qisqiçda ikki usulda uşlab turiladi. *Şakl böyiça yopiliş* (_form closure_) da obyekt jağlar geometriyasi bilan töliq öralib, işqalanişsiz ham heç qanday yönalişda siljiy olmaydi. *Kuç böyiça yopiliş* (_force closure_) da esa obyekt kontakt nuqtalaridagi normal kuçlar va ular hosil qiladigan işqalaniş kuçlari hisobiga uşlanadi. Sanoat qisqiçlarining aksariyati, ayniqsa tekis jağli parallel qisqiçlar, kuç böyiça yopiliş prinsipida işlaydi.

Kulon işqalaniş modeliga köra, kontakt nuqtasida sirpaniş bölmasligi uçun urinma kuç $f_t$ normal kuç $f_n$ va işqalaniş koeffitsiyenti $mu$ bilan quyidagiça çegaralangan:

$ |f_t| <= mu f_n, quad alpha = arctan mu $ <eq-cone>

Bu şart geometrik jihatdan *işqalaniş konusi* deb ataladi: kontakt kuçining natijaviy vektori yarim burçagi $alpha$ ga teng konus içida yotişi kerak.

*Tekis jağli qisqiç.* Obyekt $n$ ta işqalaniş sirti (ikki barmoqli qisqiçda $n = 2$) orqali uşlanib, vertikal yönalişda $a$ tezlaniş bilan harakatlanayotgan bölsin (@fig-fbd, a). Har bir jağning normal kuçi $F_g$ bölganda, işqalaniş kuçlari yiğindisi oğirlik va inersiya kuçlarini zaxira koeffitsiyenti $S$ bilan muvozanatlaşi kerak:

$ n mu F_g >= m (g + a) S quad arrow.double quad F_g = (m (g + a) S) / (mu n) $ <eq-flat>

*V-simon jağli qisqiç.* Silindrsimon detalni oçiliş burçagi $2 gamma$ bölgan V-simon prizma bilan uşlaganda (@fig-fbd, b), jağ kuçi $F_g$ ikki yoqqa taqsimlanadi va har bir yoqdagi normal kuç $N = F_g \/ (2 sin gamma)$ ga teng böladi. Natijada bitta jağdagi işqalaniş kuçi $2 mu N = mu F_g \/ sin gamma$, yaʼni samarali işqalaniş koeffitsiyenti ortadi:

$ mu_"ef" = mu / (sin gamma), quad F_g = (m (g + a) S sin gamma) / (mu n) $ <eq-vjaw>

Tekis jağ $gamma = 90 degree$ holatiga mos keladi. Masalan, $2 gamma = 90 degree$ bölganda zarur kuç taxminan $sin 45 degree approx 0.71$ marta kamayadi.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let ar(a, b, col: black, w: 1pt) = line(a, b, stroke: w + col, mark: (end: ">", fill: col, scale: 0.6))
    // a) tekis jag'lar
    rect((-0.8, -1.0), (0.8, 1.0), fill: luma(220), stroke: 1pt)
    rect((-1.5, -0.9), (-0.8, 0.9), fill: csec.lighten(60%), stroke: 1pt + cprim)
    rect((0.8, -0.9), (1.5, 0.9), fill: csec.lighten(60%), stroke: 1pt + cprim)
    ar((-2.6, 0), (-1.5, 0), col: cacc)
    content((-2.6, 0), text(size: 9pt)[$F_g$], anchor: "east")
    ar((2.6, 0), (1.5, 0), col: cacc)
    content((2.6, 0), text(size: 9pt)[$F_g$], anchor: "west")
    ar((-0.65, -0.5), (-0.65, 0.6), col: csec)
    content((-0.55, 0.45), text(size: 8pt)[$mu F_g$], anchor: "west")
    ar((0.65, -0.5), (0.65, 0.6), col: csec)
    ar((0, 0), (0, -1.9), col: black)
    circle((0, 0), radius: 0.06, fill: black)
    content((0.1, -1.7), text(size: 9pt)[$m(g+a)$], anchor: "west")
    ar((2.0, -1.4), (2.0, -0.4), col: luma(100), w: 0.8pt)
    content((2.1, -0.9), text(size: 9pt)[$a$], anchor: "west")
    content((0, -2.5), [a)])

    // b) V-simon jag'
    let cx = 7.2
    let r = 0.9
    let ap = cx - r / calc.sin(45deg)
    circle((cx, 0), radius: r, fill: luma(220), stroke: 1pt)
    line(
      (ap - 1.0, 1.05), (ap + 1.05, 1.05), (ap, 0), (ap + 1.05, -1.05), (ap - 1.0, -1.05),
      close: true, fill: csec.lighten(60%), stroke: 1pt + cprim,
    )
    rect((cx + r, -0.9), (cx + r + 0.6, 0.9), fill: csec.lighten(60%), stroke: 1pt + cprim)
    ar((ap - 2.0, 0), (ap - 1.0, 0), col: cacc)
    content((ap - 2.0, 0), text(size: 9pt)[$F_g$], anchor: "east")
    ar((cx + r + 1.6, 0), (cx + r + 0.6, 0), col: cacc)
    content((cx + r + 1.6, 0), text(size: 9pt)[$F_g$], anchor: "west")
    // normal kuchlar
    let t1 = (cx - r * calc.cos(45deg), r * calc.sin(45deg))
    let t2 = (cx - r * calc.cos(45deg), -r * calc.sin(45deg))
    ar(t1, (t1.at(0) + 0.45, t1.at(1) - 0.45), col: cacc)
    ar(t2, (t2.at(0) + 0.45, t2.at(1) + 0.45), col: cacc)
    content((t1.at(0) + 0.45, t1.at(1) - 0.3), text(size: 8pt)[$N$], anchor: "west")
    content((t2.at(0) + 0.45, t2.at(1) + 0.3), text(size: 8pt)[$N$], anchor: "west")
    content((ap - 0.05, 0), text(size: 8pt)[$2 gamma$], anchor: "east")
    content((cx, -2.5), [b)])
  }),
  caption: [Uşlaş kuçlari sxemasi: a) tekis jağli qisqiç; b) V-simon jağli qisqiç],
) <fig-fbd>

== Pnevmatik yuritmali mexanik qisqiç

Sanoat robotlarida eng köp tarqalgan qisqiçlar pnevmatik silindr bilan harakatlantiriladi. Silindr ştokidagi kuç quyidagiça aniqlanadi ($p$ --- ortiqça havo bosimi, $D$ --- porşen diametri, $eta_c$ --- silindrning FIK):

$ F_c = p dot (pi D^2) / 4 dot eta_c $ <eq-cyl>

Silindr kuçi barmoqlarga uzatiş mexanizmi orqali uzatiladi. *Ponali (klinli) mexanizmda* (@fig-wedge) yon tomonlari öq bilan $beta$ burçak hosil qiladigan pona ikki rolikni bir-biridan uzoqlaştiradi. Har bir barmoqqa uzatiladigan kuç, barmoq riçaglarining yelkalari nisbati $l_1 \/ l_2$ ni hisobga olganda:

$ F_g = eta (F_c) / (2 tan beta) dot l_1 / l_2 $ <eq-wedge>

bunda $eta$ --- mexanizmning FIK. Kiçik $beta$ burçakda kuç sezilarli darajada kuçayadi, ammo barmoqlar yurişi kamayadi. $beta$ burçak işqalaniş burçagidan kiçik bölganda mexanizm *öz-özidan tormozlanadi*, yaʼni havo bosimi yöqolganda ham detal tuşib ketmaydi. Zarur uşlaş kuçi @eq-flat yoki @eq-vjaw dan topilgaç, @eq-wedge va @eq-cyl dan silindrning zarur diametri aniqlanadi:

$ D >= sqrt((4 F_c) / (pi p eta_c)) $ <eq-dcyl>

Hisoblangan diametr standart qatordagi eng yaqin katta qiymatgaça yaxlitlanadi: 10, 12, 16, 20, 25, 32, 40, 50 mm.

#figure(
  cetz.canvas(length: 1.25cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let ar(a, b, col: black) = line(a, b, stroke: 1pt + col, mark: (end: ">", fill: col, scale: 0.6))
    let tb = calc.tan(20deg)
    let hw = 2.0 * tb
    // shtok va pona
    rect((-0.2, -1.4), (0.2, 0), fill: luma(200), stroke: 1pt)
    line((-hw, 0), (0, 2.0), (hw, 0), close: true, fill: luma(225), stroke: 1pt + cprim)
    ar((0, -2.4), (0, -1.4), col: cacc)
    content((0.1, -2.2), text(size: 9pt)[$F_c$], anchor: "west")
    // o'q chizig'i va beta
    line((0, -0.2), (0, 2.8), stroke: (paint: luma(120), dash: "dash-dotted", thickness: 0.5pt))
    arc((0, 2.0), start: 270deg, stop: 290deg, radius: 1.0, stroke: 0.7pt, anchor: "origin")
    content((0.24, 0.72), text(size: 9pt)[$beta$], anchor: "north")
    // roliklar
    let n = (calc.cos(20deg), calc.sin(20deg))
    let cp = ((2.0 - 1.2) * tb, 1.2)
    let rc = (cp.at(0) + 0.3 * n.at(0), cp.at(1) + 0.3 * n.at(1))
    for s in (1, -1) {
      let c = (s * rc.at(0), rc.at(1))
      circle(c, radius: 0.3, fill: white, stroke: 1.2pt + cprim)
      circle(c, radius: 0.05, fill: cprim, stroke: none)
      // barmoq richagi (yo'naltiruvchi)
      line(c, (s * 2.4, c.at(1)), stroke: 3pt + csec)
      ar((s * 2.5, c.at(1)), (s * 3.5, c.at(1)), col: cacc)
    }
    content((3.55, rc.at(1)), text(size: 9pt)[$F_r = F_c \/ (2 tan beta)$], anchor: "west")
    content((-3.55, rc.at(1)), text(size: 9pt)[$F_r$], anchor: "east")
    line((-1.1, 0.35), (-0.4, 0.55), stroke: 0.5pt)
    content((-1.1, 0.35), text(size: 8pt)[pona], anchor: "east")
  }),
  caption: [Ponali uzatiş mexanizmining kuçlar sxemasi (işqalaniş hisobga olinmagan)],
) <fig-wedge>

== Vakuumli qisqiçlar

Vakuumli qisqiçda elastik sörğiç obyekt sirtiga bosiladi va uning içidan havo sörib olinadi (@fig-vac). Sörğiç içidagi bosim $p_v$ atmosfera bosimi $p_a$ dan past bölgani uçun bosimlar farqi $Delta p = p_a - p_v$ obyektni sörğiçga bosib turadi. Vakuum odatda siqilgan havo bilan işlaydigan *ejektor* (Venturi effekti) yoki vakuum nasosi yordamida hosil qilinadi. Bitta sörğiçning nazariy uşlab turiş kuçi:

$ F_1 = Delta p dot (pi D^2) / 4 $ <eq-cup>

Gorizontal joylaşgan obyektni vertikal kötarişda (yuk sörğiç sirtiga perpendikulyar) $n$ ta sörğiç uçun şart:

$ n dot F_1 >= m (g + a) S quad arrow.double quad D >= sqrt((4 m (g + a) S) / (pi Delta p n)) $ <eq-dcup>

Obyekt vertikal joylaşganda (yuk sörğiç sirtiga parallel) u faqat işqalaniş hisobiga uşlanadi, şuning uçun @eq-dcup dagi zarur kuç $1 \/ mu$ marta ortadi. Vakuumli qisqiçlar uçun zaxira koeffitsiyenti odatda gorizontal holatda $S >= 2$, vertikal holatda $S >= 4$ qabul qilinadi. Sörğiçlarning standart diametrlari: 10, 15, 20, 25, 30, 40, 50, 60, 80 mm.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let ar(a, b, col: black) = line(a, b, stroke: 1pt + col, mark: (end: ">", fill: col, scale: 0.6))
    rect((-3.0, -0.3), (3.0, 0), fill: luma(200), stroke: 1pt)
    content((3.1, -0.15), text(size: 8pt)[obyekt (list)], anchor: "west")
    line((-1.0, 0), (-0.35, 0.8), (0.35, 0.8), (1.0, 0), stroke: 1.2pt + cprim, fill: csec.lighten(75%))
    content((0, 0.33), text(size: 9pt)[$p_v$])
    rect((-0.15, 0.8), (0.15, 1.9), fill: luma(210), stroke: 1pt)
    rect((-0.9, 1.9), (0.9, 2.6), fill: white, stroke: 0.9pt + cprim, radius: 2pt)
    content((0, 2.25), text(size: 8.5pt)[Ejektor])
    ar((-2.2, 2.25), (-0.9, 2.25), col: csec)
    content((-2.2, 2.25), text(size: 8pt)[siqilgan havo], anchor: "east")
    ar((0.9, 2.25), (2.0, 2.25), col: luma(120))
    content((2.0, 2.25), text(size: 8pt)[çiqiş], anchor: "west")
    content((-2.0, 0.6), text(size: 9pt)[$p_a$])
    line((-1.0, -0.65), (1.0, -0.65), stroke: 0.8pt + cacc, mark: (start: ">", end: ">", fill: cacc, scale: 0.55))
    content((0, -0.7), text(size: 9pt)[$D$], anchor: "north")
    ar((2.4, -1.7), (2.4, -0.4), col: cacc)
    content((2.5, -1.2), text(size: 9pt)[$F_1$], anchor: "west")
  }),
  caption: [Ejektorli vakuumli qisqiçning sxemasi],
) <fig-vac>

== Elektromagnitli qisqiçlar

Elektromagnitli qisqiç ferromagnit obyektlarni magnit maydon kuçi bilan uşlaydi. Havo tirqişi juda kiçik bölganda qutblarning uşlab turiş kuçi Maksvell formulasi bilan baholanadi ($B$ --- tirqişdagi magnit induksiyasi, $A$ --- qutblarning umumiy yuzasi, $mu_0 = 4 pi dot 10^(-7)$ Gn/m):

$ F_m = (B^2 A) / (2 mu_0) quad arrow.double quad B >= sqrt((2 mu_0 m (g + a) S) / A) $ <eq-mag>

Real şaroitda havo tirqişi, sirt ğadir-budurligi va obyekt qalinligining yetarli emasligi (magnit oqimining töyinişi) tufayli kuç sezilarli kamayadi, şuning uçun zaxira koeffitsiyenti $S = 2 dots 3$ olinadi. Pölatning töyiniş induksiyasi taxminan $1.5 dots 1.8$ T ekanini hisobga olib, $B$ ning hisoblangan qiymati şu çegaradan ança past bölişi kerak. Elektromagnit öçirilgandan keyin qoldiq magnitlaniş tufayli detal darhol ajralmasligi mumkin; buning oldini oliş uçun qisqa muddatli teskari qutbli tok impulsi beriladi.

= Namunaviy masalalar va ularning yeçimlari

== Masala 1: Pnevmatik qisqiçning uşlaş kuçi va silindr diametri

*Masala şarti:* ikki barmoqli tekis jağli qisqiç massasi $m = 2$ kg bölgan detalni köçiradi. Işqalaniş koeffitsiyenti $mu = 0.3$, vertikal tezlaniş $a = 5 "m/s"^2$, zaxira koeffitsiyenti $S = 2$. Barmoqlar ponali mexanizm orqali harakatlanadi: $beta = 15 degree$, $l_1 \/ l_2 = 1$, $eta = 0.85$. Tarmoqdagi havo bosimi $p = 0.5$ MPa, silindr FIK $eta_c = 1$ deb olinsin.

#set enum(numbering: "a)")
+ Har bir jağning zarur uşlaş kuçini ($F_g$) toping.
+ Agar detal silindrsimon bölib, $2 gamma = 90 degree$ li V-simon jağlar işlatilsa, $F_g$ qançaga kamayişini aniqlang.
+ Tekis jağlar uçun silindrning zarur kuçi va diametrini hisoblang, standart diametrni tanlang.
#set enum(numbering: "1.")

*Hisoblaş bosqiçlari:*

- *Tekis jağlar uçun uşlaş kuçi* (@eq-flat):
  $ F_g = (2 dot (9.81 + 5) dot 2) / (0.3 dot 2) = 59.24 / 0.6 approx 98.7 "N" $

- *V-simon jağlar uçun* (@eq-vjaw), $gamma = 45 degree$:
  $ F_g^V = 98.7 dot sin 45 degree = 98.7 dot 0.7071 approx 69.8 "N" $
  Zarur kuç taxminan $29 %$ ga kamayadi.

- *Silindrning zarur kuçi* (@eq-wedge dan):
  $ F_c = (2 F_g tan beta) / eta dot l_2 / l_1 = (2 dot 98.7 dot 0.2679) / 0.85 approx 62.2 "N" $

- *Silindr diametri* (@eq-dcyl):
  $
    D >= sqrt((4 dot 62.2) / (pi dot 0.5 dot 10^6)) = sqrt(1.585 dot 10^(-4)) \
    approx 0.0126 "m" = 12.6 "mm"
  $
  Standart qatordan $D = 16$ mm tanlanadi.

- *Tekşiriş.* $D = 16$ mm uçun @eq-cyl va @eq-wedge böyiça:
  $
    F_c = 0.5 dot 10^6 dot (pi dot 0.016^2) / 4 approx 100.5 "N", \
    F_g = 0.85 dot 100.5 / (2 dot 0.2679) approx 159.5 "N" > 98.7 "N"
  $

*Javob:* $F_g approx 98.7$ N (V-simon jağlarda $approx 69.8$ N); $F_c approx 62.2$ N; $D = 16$ mm (haqiqiy uşlaş kuçi $approx 159.5$ N).

== Masala 2: Vakuumli qisqiçning sörğiçlarini tanlaş

*Masala şarti:* ölçamlari $600 times 400 times 2$ mm bölgan pölat list ($rho = 7850 "kg/m"^3$) gorizontal holatda $n = 4$ ta sörğiçli vakuumli qisqiç bilan $a = 3 "m/s"^2$ tezlanişda kötariladi. Ejektor hosil qiladigan bosimlar farqi $Delta p = 60$ kPa, zaxira koeffitsiyenti $S = 2$.

#set enum(numbering: "a)")
+ Listning massasini va zarur uşlab turiş kuçini toping.
+ Sörğiçning zarur diametrini hisoblang va standart qiymatni tanlang.
+ Tanlangan sörğiçlar uçun haqiqiy zaxira koeffitsiyentini aniqlang.
#set enum(numbering: "1.")

*Hisoblaş bosqiçlari:*

- *Massa va zarur kuç:*
  $ m = 0.6 dot 0.4 dot 0.002 dot 7850 approx 3.77 "kg" $
  $ F_"zar" = m (g + a) S = 3.77 dot (9.81 + 3) dot 2 approx 96.5 "N" $
  Bitta sörğiçga $96.5 \/ 4 approx 24.1$ N töğri keladi.

- *Sörğiç diametri* (@eq-dcup):
  $
    D >= sqrt((4 dot 96.5) / (pi dot 60 dot 10^3 dot 4)) = sqrt(5.12 dot 10^(-4)) \
    approx 0.0226 "m" = 22.6 "mm"
  $
  Standart qatordan $D = 25$ mm yoki işonçlilikni oşiriş uçun $D = 30$ mm tanlanadi. Quyida $D = 30$ mm uçun tekşiramiz.

- *Haqiqiy zaxira koeffitsiyenti* (@eq-cup):
  $ F_1 = 60 dot 10^3 dot (pi dot 0.03^2) / 4 approx 42.4 "N" $
  $ S_"haq" = (n F_1) / (m (g + a)) = (4 dot 42.4) / (3.77 dot 12.81) approx 3.5 $

*Javob:* $m approx 3.77$ kg; $F_"zar" approx 96.5$ N; $D_"min" approx 22.6$ mm, tanlangan $D = 30$ mm; $S_"haq" approx 3.5$.

== Masala 3: Elektromagnitli qisqiçning magnit induksiyasi

*Masala şarti:* massasi $m = 5$ kg bölgan pölat detal $a = 2 "m/s"^2$ tezlaniş bilan kötariladi. Elektromagnit qutblarining umumiy yuzasi $A = 12 "sm"^2$, zaxira koeffitsiyenti $S = 2.5$. Tirqişdagi zarur magnit induksiyasini toping.

*Hisoblaş bosqiçlari:*

- *Zarur kuç:*
  $ F_"zar" = 5 dot (9.81 + 2) dot 2.5 approx 147.6 "N" $

- *Magnit induksiyasi* (@eq-mag), $A = 1.2 dot 10^(-3) "m"^2$:
  $
    B >= sqrt((2 dot 4 pi dot 10^(-7) dot 147.6) / (1.2 dot 10^(-3))) = sqrt(3.709 dot 10^(-4) / (1.2 dot 10^(-3))) \
    = sqrt(0.309) approx 0.56 "T"
  $
  Bu qiymat pölatning töyiniş induksiyasidan ($approx 1.5$ T) ança past, demak talab bajarilişi mumkin.

*Javob:* $F_"zar" approx 147.6$ N; $B approx 0.56$ T.

= Individual amaliy topşiriqlar

Har bir talaba öz variant raqamiga mos maʼlumotlar (@tab-variants) böyiça quyidagilarni bajarişi lozim. Barça variantlarda: ikki barmoqli qisqiç ($n = 2$), $S = 2$, $eta = 0.85$, $eta_c = 1$, $l_1 \/ l_2 = 1$; list materiali pölat ($rho = 7850 "kg/m"^3$), list gorizontal holatda kötariladi, vakuumli qisqiç uçun $S = 2$ va tezlaniş $a$ mexanik qisqiçniki bilan bir xil.

+ Tekis jağlar uçun zarur uşlaş kuçini ($F_g$) hisoblaş.
+ Detal silindrsimon bölgan holat uçun $2 gamma = 90 degree$ li V-simon jağlarda $F_g$ ni hisoblaş va natijalarni soliştiriş.
+ Tekis jağlar uçun silindr kuçi va diametrini hisoblaş, standart diametrni tanlaş va haqiqiy uşlaş kuçini tekşiriş.
+ List massasini, vakuumli qisqiç sörğiçlarining zarur diametrini hisoblaş, standart diametrni tanlaş va haqiqiy zaxira koeffitsiyentini aniqlaş.
+ Hisoblarni Python (NumPy) dasturi yordamida tekşiriş.

#figure(
  btable(
    columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto),
    (
      [*Var.*],
      [*$m$ \ \[kg\]*],
      [*$mu$*],
      [*$a$ \ \[m/s#super[2]\]*],
      [*$beta$*],
      [*$p$ \ \[MPa\]*],
      [*List ölçami \ $L times B times s$ \[mm\]*],
      [*$n_v$ \ \[dona\]*],
      [*$Delta p$ \ \[kPa\]*],
    ),
    [*1*], [1.5], [0.25], [4.0], [$15 degree$], [0.4], [$500 times 300 times 2$], [4], [50],
    [*2*], [3.0], [0.30], [3.0], [$12 degree$], [0.6], [$800 times 500 times 1.5$], [6], [60],
    [*3*], [2.5], [0.20], [5.0], [$18 degree$], [0.5], [$400 times 400 times 3$], [4], [55],
    [*4*], [4.0], [0.35], [2.0], [$10 degree$], [0.6], [$1000 times 600 times 1$], [6], [65],
    [*5*], [1.0], [0.15], [6.0], [$20 degree$], [0.4], [$600 times 300 times 2.5$], [4], [45],
    [*6*], [2.0], [0.40], [4.0], [$15 degree$], [0.5], [$700 times 500 times 2$], [6], [70],
    [*7*], [5.0], [0.30], [2.0], [$12 degree$], [0.6], [$900 times 600 times 1.5$], [8], [60],
    [*8*], [3.5], [0.25], [3.0], [$16 degree$], [0.5], [$500 times 500 times 3$], [4], [50],
    [*9*], [0.8], [0.20], [8.0], [$14 degree$], [0.4], [$450 times 350 times 2$], [4], [40],
    [*10*], [6.0], [0.35], [1.5], [$10 degree$], [0.6], [$1200 times 800 times 1$], [8], [75],
  ),
  caption: [Talabalar uçun individual topşiriqlar],
) <tab-variants>

= Nazorat savollari

+ Qisqiç qurilmasi deganda nima tuşuniladi va u robototexnik kompleksda qanday vazifani bajaradi?
+ Qisqiç qurilmalari uşlaş prinsipi va boşqariş usuli böyiça qanday tasniflanadi?
+ Şakl böyiça va kuç böyiça yopiliş örtasidagi farq nimada?
+ Işqalaniş konusi nima va u uşlaş şarti bilan qanday boğliq?
+ Nima uçun V-simon jağlar silindrsimon detallarni uşlaşda zarur kuçni kamaytiradi?
+ Ponali mexanizmda $beta$ burçakning kamayişi uşlaş kuçi va barmoqlar yurişiga qanday taʼsir qiladi? Öz-özidan tormozlaniş şarti nima?
+ Vakuumli qisqiçning uşlab turiş kuçi nimalarga boğliq va u qanday çeklangan?
+ Elektromagnitli qisqiçlarning afzalliklari va kamçiliklarini tuşuntiring. Qoldiq magnitlanişning oldi qanday olinadi?
