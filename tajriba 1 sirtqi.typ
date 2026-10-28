// ============================================================
//  Robotlar va robototexnik tizimlar — 1-tajriba mashgʻuloti (sirtqi taʼlim) — Typst versiyasi
//  Kompilyatsiya: typst compile tajriba_1_sirtqi.typ
// ============================================================

#import "@preview/cetz:0.4.2"

#let headingblue = rgb(20, 50, 120)

#set document(title: "«Elektronika-NSTM-01» sanoat robotining işlaş prinsipini örganiş")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 1  // tajriba raqami
#set document(keywords: (info.fan,))
#set page(header: context {
  set text(size: 9pt, fill: luma(110))
  grid(
    columns: (1fr, auto, 1fr),
    align: (left, center, right),
    info.fan, info.semestr, [Tajriba №#raqam (sirtqi)],
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[TAJRIBA MAŞĞULOTI №#raqam]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[Mavzu: «Elektronika-NSTM-01» sanoat robotining işlaş prinsipini örganiş]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* tokarlik stanoklariga xizmat körsatuvçi «Elektronika-NSTM-01» sanoat robotining vazifasi, tuzilişi, kinematik sxemasi, elektromexanik va pnevmatik yuritmalari hamda mikroEHM asosidagi boşqaruv tizimining işlaş prinsipini örganiş, robotning iş siklini dasturlaş va uning pozitsiyalaş aniqligini tajriba yöli bilan baholaş.

*Öquv vazifalari:*

+ *Konstruktiv tuzilmani tahlil qiliş:* robotning mexanik tugunlari, harakat öqlari va ikki qisqiçli işçi organi tuzilişini örganiş.
+ *Kinematik tahlil:* manipulyatorning kinematik sxemasini tuziş, erkinlik darajalari sonini aniqlaş va işçi zonasini hisoblaş.
+ *Yuritmalarni örganiş:* özgarmas tok dvigatelli elektromexanik yuritmalar va pnevmoyuritmalar işlaş prinsipini, ularning boşqaruv sxemasini tahlil qiliş.
+ *Dasturlaş:* stanokka zagotovka örnatiş va tayyor detalni oliş siklini dasturlaş.
+ *Aniqlikni baholaş:* takroriy sikllarda tutqiçning pozitsiyalaş aniqligi va takroriyligini ölçaş va hisoblaş.

= Kerakli asbob-uskunalar

- *Öquv-laboratoriya stendi:* «Elektronika-NSTM-01» sanoat roboti, boşqaruv bloki va qölda boşqariş pulti.
- *Pnevmatik jihozlar:* kompressor (işçi bosim $0.4 dots 0.6$ MPa), havo tayyorlaş bloki (filtr, bosim rostlagiçi, moylagiç).
- *Nazorat-ölçov vositalari:* ştangensirkul, indikator soat (millimetr bölinmali), sekundomer.
- *Işçi detallar töplami:* turli diametrli “aylaniş jismi” turidagi silindrsimon zagotovkalar.

#block(
  fill: luma(245),
  inset: 8pt,
  radius: 3pt,
  width: 100%,
)[
  *Sirtqi taʼlim talabalari uçun eslatma.* Maşğulot bitta auditoriya darsida bajarilişga möljallangan. Laboratoriya stendida işlaş imkoni bölmasa, 4-bölimdagi tajriba bosqiçlari öqituvçi namoyişi asosida kuzatiladi, hisob-kitoblar esa 6-bölimdagi 3-masalada keltirilgan namunaviy ölçaş natijalari böyiça bajariladi.
]

= Nazariy maʼlumotlar

== Sanoat robotining avtomatlaştirişdagi örni

Sanoat roboti --- ISO 8373 standartiga köra, avtomatik boşqariladigan, qayta dasturlanadigan, uç yoki undan ortiq öq böyiça dasturlanadigan köp maqsadli manipulyator. Robotlar dastgohlarga zagotovka örnatiş va tayyor detalni oliş kabi monoton operatsiyalarni bajarib, dastgoh bilan birgalikda *moslaşuvçan işlab çiqariş moduli* (MIM) ni hosil qiladi. Bunday modul inson iştirokisiz uzoq vaqt işlay oladi va moslaşuvçan işlab çiqariş tizimlarining asosiy “ğişti” hisoblanadi.

== «Elektronika-NSTM-01» robotining vazifasi va tuzilişi

«Elektronika-NSTM-01» («Электроника НЦТМ-01») roboti metall kesuvçi tokarlik stanoklariga xizmat körsatiş uçun möljallangan: u diametri va balandligi 150 mm gaça bölgan “aylaniş jismi” turidagi detallarni kassetadan olib, stanokka örnatadi va tayyor detalni stanokdan olib, kassetaga qaytaradi. Robot raqamli dastur bilan boşqariladigan tokarlik-revolver stanogi bilan birgalikda moslaşuvçan işlab çiqariş modulini taşkil etadi.

Robot uçta asosiy qismdan iborat: *elektromexanik manipulyator*, *boşqaruv bloki* (yuritmalarning quvvat kuçaytirgiçlari, pnevmotaqsimlagiçlar) va *mikroprotsessorli boşqaruv tizimi*. Manipulyatorning işçi organi bir-biriga nisbatan $90 degree$ burçak ostida joylaşgan *ikkita qisqiçdan* iborat: biri zagotovkani, ikkinçisi tayyor detalni uşlaş uçun sozlanadi. Şu tufayli robot stanok yonida bir marta töxtab, avval tayyor detalni olişi, söngra qölni burib, zagotovkani örnatişi mumkin. Robotning asosiy tavsifi @tab-spec da keltirilgan.

#figure(
  btable(
    columns: (auto, 1fr),
    align: (left + horizon, left + horizon),
    ([*Körsatkiç*], [*Qiymati / tavsifi*]),
    [Vazifasi],
    [Tokarlik stanoklariga “aylaniş jismi” turidagi detallarni yuklaş va tuşiriş],
    [Detal ölçamlari],
    [Diametri va balandligi 150 mm gaça],
    [Koordinata tizimi],
    [Dekart ($X$, $Y$, $Z$) va qölning $90 degree$ ga burilişi ($phi$)],
    [Erkinlik darajalari soni],
    [Manbalarda 4 yoki 5 deb keltiriladi (stendda aniqlanadi)],
    [Işçi zona],
    [$X$ va $Y$ böyiça 300 mm gaça, $Z$ böyiça 150 mm (kub $300 times 300 times 150$ mm)],
    [Işçi organ],
    [Ikkita pnevmatik qisqiç, özaro $90 degree$ burçak ostida],
    [Çiziqli öqlar yuritmasi],
    [Özgarmas tok dvigatellari (24 V, reversiv) va impuls datçiklari],
    [Buriliş va qisqiç yuritmasi],
    [Pnevmosilindrlar va elektropnevmatik taqsimlagiçlar],
    [Boşqaruv tizimi],
    [«Elektronika-60» oilasidagi mikroEHM asosida (MS 1201.01 platasi)],
    [Robot avlodi],
    [Ikkinçi avlod (adaptatsiya elementlariga ega)],
  ),
  caption: [«Elektronika-NSTM-01» robotining asosiy tavsifi],
) <tab-spec>

== Kinematik sxema va erkinlik darajalari

Manipulyator oçiq kinematik zanjirdan iborat va *dekart (töğri burçakli) koordinata tizimida* işlaydi (@fig-kin). Uning harakatlari:

+ *$X$ öqi böylab gorizontal siljiş* --- ilgarilanma juftlik $P_1$;
+ *$Y$ öqi böylab gorizontal siljiş* --- ilgarilanma juftlik $P_2$;
+ *$Z$ öqi böylab vertikal siljiş* --- ilgarilanma juftlik $P_3$;
+ *qölning $90 degree$ ga burilişi* ($phi$) --- aylanma juftlik $R_4$; u ikki qisqiçdan birini işçi holatga keltiradi;
+ *qisqiçlarning oçilişi va yopilişi* --- pnevmatik işçi organ ($G_1$, $G_2$).

Erkinlik darajalari soni Grübler--Kutzbach formulasi bilan aniqlanadi ($m = 6$ --- fazodagi jismning erkinlik darajalari soni, $N$ --- asos bilan birga zvenolar soni, $J$ --- kinematik juftliklar soni, $f_i$ --- $i$-juftlikning erkinlik darajasi):

$ "DoF" = m (N - 1 - J) + sum_(i=1)^J f_i $ <eq-gk>

Oçiq zanjirda $N = J + 1$ bölgani uçun formula $"DoF" = sum f_i$ ga soddalaşadi. $P_1, P_2, P_3, R_4$ juftliklar uçun $"DoF" = 4$. Qisqiçlarning oçiliş-yopiliş harakati odatda manipulyatorning erkinlik darajasiga qöşilmaydi. $R_4$ juftlik faqat ikki qatʼiy holatda ($phi = 0 degree$ yoki $90 degree$) işlaydi, şuning uçun u orientatsiyani uzluksiz boşqarmaydi, balki qisqiçni almaştiradi.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let ar(a, b, col: cacc) = line(a, b, stroke: 0.9pt + col, mark: (start: ">", end: ">", fill: col, scale: 0.5))
    // asos va ustunlar
    line((-0.5, 0), (6.5, 0), stroke: 1.2pt)
    for k in range(17) { line((-0.4 + k * 0.42, 0), (-0.6 + k * 0.42, -0.25), stroke: 0.5pt) }
    rect((0, 0), (0.4, 4.2), fill: luma(215), stroke: 1pt)
    rect((5.6, 0), (6.0, 4.2), fill: luma(215), stroke: 1pt)
    // X yo'naltiruvchi (portal)
    rect((-0.1, 4.2), (6.1, 4.6), fill: csec.lighten(60%), stroke: 1pt + cprim)
    // X karetkasi (Y yo'naltiruvchi bilan)
    rect((2.3, 3.9), (3.7, 4.9), fill: white, stroke: 1.2pt + cprim)
    content((3.0, 4.4), text(size: 8pt)[$X$/$Y$ \ karetka])
    // Z ustuni
    rect((2.8, 1.6), (3.2, 3.9), fill: cacc.lighten(70%), stroke: 1pt + cprim)
    // qo'l (burilish moduli)
    circle((3.0, 1.35), radius: 0.28, fill: white, stroke: 1.2pt + cprim)
    circle((3.0, 1.35), radius: 0.07, fill: cprim, stroke: none)
    // 1-qisqich (pastga)
    line((3.0, 1.07), (3.0, 0.8), stroke: 2pt + luma(60))
    line((2.75, 0.8), (3.25, 0.8), stroke: 1.5pt)
    line((2.75, 0.8), (2.75, 0.45), stroke: 1.5pt)
    line((3.25, 0.8), (3.25, 0.45), stroke: 1.5pt)
    content((2.65, 0.6), text(size: 8pt)[$G_1$], anchor: "east")
    // 2-qisqich (yon tomonga)
    line((3.28, 1.35), (3.55, 1.35), stroke: 2pt + luma(60))
    line((3.55, 1.1), (3.55, 1.6), stroke: 1.5pt)
    line((3.55, 1.1), (3.9, 1.1), stroke: 1.5pt)
    line((3.55, 1.6), (3.9, 1.6), stroke: 1.5pt)
    content((4.0, 1.35), text(size: 8pt)[$G_2$], anchor: "west")
    // harakatlar
    ar((1.0, 5.2), (5.0, 5.2))
    content((5.05, 5.2), text(size: 9pt)[$X$ ($P_1$)], anchor: "west")
    circle((1.7, 3.55), radius: 0.18, stroke: 0.9pt + cacc)
    circle((1.7, 3.55), radius: 0.05, fill: cacc, stroke: none)
    content((1.45, 3.55), text(size: 9pt)[$Y$ ($P_2$)], anchor: "east")
    ar((2.4, 1.8), (2.4, 3.6))
    content((2.3, 2.2), text(size: 9pt)[$Z$ ($P_3$)], anchor: "east")
    arc((3.0, 1.35), start: 110deg, stop: 20deg, radius: 0.55, anchor: "origin", stroke: 0.9pt + cacc, mark: (
      end: ">",
      fill: cacc,
      scale: 0.5,
    ))
    content((3.6, 1.95), text(size: 9pt)[$phi = 90 degree$ ($R_4$)], anchor: "west")
    // izoh
    content((9.2, 2.6), box(
      fill: luma(245),
      stroke: 0.6pt + csec,
      radius: 3pt,
      inset: 6pt,
      align(left, text(size: 8.5pt)[
        $P_1$: $X$ böylab siljiş \
        $P_2$: $Y$ böylab siljiş \
        #h(1.2em) (çizma tekisligiga \
        #h(1.2em) perpendikulyar) \
        $P_3$: $Z$ böylab siljiş \
        $R_4$: qölning $90 degree$ burilişi \
        $G_1$: zagotovka qisqiçi \
        $G_2$: detal qisqiçi
      ]),
    ))
  }),
  caption: [«Elektronika-NSTM-01» robotining kinematik sxemasi (soddalaştirilgan, old tomondan köriniş)],
) <fig-kin>

*Töğri kinematika.* Dekart manipulyatorida tutqiç markazining (TCP) holati çiziqli öqlar koordinatalari bilan bevosita aniqlanadi. Bazaviy koordinatalar tizimida ($bold(p)_0$ --- nol holatdagi TCP koordinatalari, $bold(R)(phi)$ --- qöl burilişining aylaniş matritsasi, $bold(p)_q$ --- buriliş markazidan qisqiç markazigaça bölgan vektor):

$ bold(p) = bold(p)_0 + mat(delim: "[", X; Y; Z) + bold(R)(phi) bold(p)_q $ <eq-fk>

Dekart robotining afzalligi şundaki, töğri va teskari kinematika masalalari juda sodda: har bir öq faqat bitta koordinatani özgartiradi.

*Işçi zona.* Dekart robotining işçi zonasi töğri burçakli parallelepiped şaklida bölib, uning hajmi öqlar böylab yurişlar köpaytmasiga teng:

$ V_"iz" = L_x dot L_y dot L_z $ <eq-ws>

== Yuritmalar

*Elektromexanik yuritmalar.* $X$, $Y$ va $Z$ öqlari 24 V kuçlanişli reversiv özgarmas tok dvigatellari bilan harakatlantiriladi. Dvigatel valiga örnatilgan *impuls datçigi* har bir buriliş qadamida impuls hosil qiladi; boşqaruv tizimi impulslarni sanab, öqning bosib ötgan yölini aniqlaydi. Yuritma *ikki tezlikli pozitsion* rejimda işlaydi: maqsadli nuqtaga tez yaqinlaşadi, unga yaqin qolganda sekin tezlikka ötadi va kerakli impulslar soni sanalganda töxtaydi. Şunday qilib, harakat vaqti va aniqlik örtasida murosaga erişiladi. Ikki tezlikli harakatda bitta öq böylab siljiş vaqti ($L$ --- umumiy yöl, $L_s$ --- sekin tezlikda bosib ötiladigan yöl, $v_t$ va $v_s$ --- tez va sekin tezliklar; tezlaniş vaqti hisobga olinmagan):

$ t = (L - L_s) / v_t + L_s / v_s $ <eq-time>

Impuls datçigining ajratiş qobiliyati ($h$ --- uzatmaning bir aylanişdagi çiziqli siljişi, $N_i$ --- bir aylanişdagi impulslar soni):

$ Delta = h / N_i $ <eq-res>

*Pnevmatik yuritmalar.* Qölning $90 degree$ ga burilişi va qisqiçlarning oçilib-yopilişi pnevmosilindrlar bilan bajariladi. Siqilgan havo elektropnevmatik taqsimlagiçlar ($5\/2$ yoki $3\/2$ yölli) orqali silindr böşliqlariga beriladi. Ikki tomonlama silindrning kuçi va qisqiçning qisiş kuçi ($p$ --- havo bosimi, $D$ --- porşen diametri, $k$ --- qisqiç riçagining uzatiş koeffitsiyenti, $eta$ --- FIK):

$ F_c = p dot (pi D^2) / 4, quad F_q = F_c dot k dot eta $ <eq-grip>

Detal işonçli uşlanişi uçun qisiş kuçi zarur kuçdan katta bölişi kerak ($m$ --- detal massasi, $a$ --- tezlaniş, $S$ --- zaxira koeffitsiyenti, $mu$ --- işqalaniş koeffitsiyenti, $n$ --- işqalaniş sirtlari soni):

$ F_q >= (m (g + a) S) / (mu n) $ <eq-greq>

== Boşqaruv tizimi

Robotning boşqaruv tizimi mikroEHM asosida qurilgan (@fig-ctrl). MikroEHM iş dasturini bajaradi, impuls datçiklaridan kelgan signallarni sanaydi, har bir öq uçun tezlikni tanlaydi va dvigatellarning quvvat kuçaytirgiçlariga hamda pnevmotaqsimlagiçlarga buyruq beradi. Oxirgi uzgiçlar öqlarning çekka holatlarini va boşlanğiç (nol) holatni qayd etadi. Robot stanokning boşqaruv tizimi bilan signallar almaşadi: “stanok tayyor”, “detal örnatildi”, “işlov beriş tugadi”.

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

    bx((1.4, 4.4), 3.0, 0.9)[Qölda boşqariş \ pulti]
    bx((1.4, 2.4), 2.8, 1.6, fill: csec.lighten(85%))[*MikroEHM* \ («Elektronika-60» \ oilasi)]
    bx((1.4, 0.3), 2.8, 0.9)[Stanokning \ boşqaruv tizimi]
    bx((6.0, 3.4), 3.0, 1.0)[Quvvat \ kuçaytirgiçlari]
    bx((10.2, 3.4), 3.0, 1.0)[DC dvigatellar \ $X$, $Y$, $Z$]
    bx((14.0, 3.4), 2.4, 1.0, fill: cacc.lighten(88%))[Çiziqli \ öqlar]
    bx((6.0, 1.4), 3.0, 1.0)[Elektropnevmatik \ taqsimlagiçlar]
    bx((10.2, 1.4), 3.0, 1.0)[Pnevmosilindrlar]
    bx((14.0, 1.4), 2.4, 1.0, fill: cacc.lighten(88%))[Buriliş, \ qisqiçlar]
    bx((10.2, 5.2), 3.0, 0.8)[Impuls datçiklari]

    ar((1.4, 3.95), (1.4, 3.2))
    line((1.4, 0.75), (1.4, 1.6), stroke: 0.8pt, mark: (start: ">", end: ">", fill: black, scale: 0.55))
    lb((1.5, 1.15), [signallar], anchor: "west")
    ar((2.8, 2.9), (4.5, 3.4))
    ar((2.8, 1.9), (4.5, 1.4))
    ar((7.5, 3.4), (8.7, 3.4))
    ar((11.7, 3.4), (12.8, 3.4))
    ar((7.5, 1.4), (8.7, 1.4))
    lb((8.1, 1.45), [havo])
    ar((11.7, 1.4), (12.8, 1.4))
    ar((10.2, 3.9), (10.2, 4.8))
    line((8.7, 5.2), (3.4, 5.2), stroke: 0.8pt)
    ar((3.4, 5.2), (2.4, 3.2))
    lb((6.0, 5.25), [impulslar (yöl)])
  }),
  caption: [«Elektronika-NSTM-01» robotining boşqaruv tizimi tuzilişi],
  placement: auto,
) <fig-ctrl>

= Tajriba maşğulotini bajariş tartibi

== 1-bosqiç: xavfsizlik texnikasi va stendni tayyorlaş

- Stendning yerga ulanganligini, elektr kabellari va pnevmoşlanglarning butunligini tekşiring.
- Kompressorni yoqing va tarmoqdagi havo bosimi $0.4 dots 0.5$ MPa oraliğida ekanini qayd eting.
- Avariya töxtatiş tugmasining (_E-Stop_) işlaşini tekşiring. Robot harakatlanayotgan paytda uning işçi zonasiga kirmang.

== 2-bosqiç: qölda boşqariş rejimida öqlarni sinaş

- Boşqaruv blokini qölda boşqariş rejimiga ötkazing va robotni boşlanğiç (nol) holatga keltiring.
- $X$, $Y$, $Z$ öqlarini navbatma-navbat ikki tezlikda harakatlantiring va çekka holatlarda oxirgi uzgiçlar işlaşini kuzating.
- Qölni buriş ($phi$) va qisqiçlarni oçiş-yopiş buyruqlarini bajaring. Robotning erkinlik darajalari sonini aniqlab, @tab-spec bilan soliştiring.
- Har bir öqning maksimal yurişini ştangensirkul yoki çizğiç bilan ölçang va natijani @tab-results1 ga yozing.

== 3-bosqiç: iş siklini dasturlaş

Stanokka zagotovka örnatiş va tayyor detalni oliş sikli dasturlanadi (@tab-prog). Ikki qisqiç tufayli robot stanok yonida bir marta töxtaydi: avval $G_2$ qisqiç bilan tayyor detalni oladi, qölni $90 degree$ ga buradi va $G_1$ qisqiçdagi zagotovkani patronga örnatadi.

#figure(
  btable(
    columns: (auto, 1fr, 1fr),
    align: (center + horizon, left + horizon, left + horizon),
    ([*Qadam*], [*Buyruq*], [*Ijroçi organ*]),
    [1],
    [Boşlanğiç holatga keliş],
    [$X$, $Y$, $Z$ öqlari, oxirgi uzgiçlar],
    [2],
    [Kassetadagi zagotovka ustiga siljiş],
    [$X$, $Y$ öqlari],
    [3],
    [Pastga tuşiş va zagotovkani oliş],
    [$Z$ öqi, $G_1$ qisqiç (yopiş)],
    [4],
    [Yuqoriga kötariliş],
    [$Z$ öqi],
    [5],
    [Stanok patroni oldiga siljiş, stanokdan “tayyor” signalini kutiş],
    [$X$, $Y$ öqlari],
    [6],
    [Tayyor detalni patrondan oliş],
    [$Z$ öqi, $G_2$ qisqiç (yopiş)],
    [7],
    [Qölni $90 degree$ ga buriş],
    [Buriliş pnevmosilindri ($R_4$)],
    [8],
    [Zagotovkani patronga örnatiş va qöyib yuboriş],
    [$Z$ öqi, $G_1$ qisqiç (oçiş)],
    [9],
    [Stanokdan uzoqlaşiş, stanokka “işlov berişni boşlaş” signali],
    [$X$, $Y$ öqlari],
    [10],
    [Tayyor detalni kassetaga qöyiş],
    [$X$, $Y$, $Z$ öqlari, $G_2$ qisqiç (oçiş)],
    [11],
    [Qölni dastlabki holatga qaytariş va keyingi siklga ötiş],
    [Buriliş pnevmosilindri],
  ),
  caption: [Stanokka xizmat körsatiş sikli dasturining tuzilişi],
  placement: auto,
) <tab-prog>

== 4-bosqiç: avtomatik rejimda işga tuşiriş va aniqlikni ölçaş

- Boşqaruv blokini avtomatik rejimga ötkazing va siklni $N = 10$ marta takrorlang.
- Har bir siklning davomiyligini sekundomer bilan ölçang.
- Har bir siklda tutqiçni bir xil nazorat nuqtasiga keltirib, uning maqsadli holatdan oğişini ($Delta x_j$, $Delta y_j$) indikator soat yoki ştangensirkul bilan ölçang. Natijalarni @tab-results2 ga yozing.

= Tajriba natijalarini qayd etiş va işlov beriş

#figure(
  btable(
    columns: (auto, 1fr, 1fr, 1fr),
    ([*Öq*], [*Yuriş (pasport), mm*], [*Yuriş (ölçangan), mm*], [*Farq, mm*]),
    [$X$],
    [300],
    [],
    [],
    [$Y$],
    [300],
    [],
    [],
    [$Z$],
    [150],
    [],
    [],
  ),
  caption: [Öqlarning yurişini ölçaş natijalari],
) <tab-results1>

#figure(
  btable(
    columns: (auto, 1fr, 1fr, 1fr, 1fr),
    ([*Sikl $j$*], [*$T_"sikl"$, s*], [*$Delta x_j$, mm*], [*$Delta y_j$, mm*], [*$l_j$, mm*]),
    [1],
    [],
    [],
    [],
    [],
    [2],
    [],
    [],
    [],
    [],
    [3],
    [],
    [],
    [],
    [],
    [$dots$],
    [],
    [],
    [],
    [],
    [10],
    [],
    [],
    [],
    [],
  ),
  caption: [Takroriy sikllarda ölçaş natijalari],
) <tab-results2>

Natijalar ISO 9283 standartida qabul qilingan usul böyiça qayta işlanadi. Örtaça oğişlar va *pozitsiyalaş aniqligi* (örtaça holatning maqsadli nuqtadan uzoqligi):

$
  overline(x) = 1 / N sum_(j=1)^N Delta x_j, quad overline(y) = 1 / N sum_(j=1)^N Delta y_j, quad A P = sqrt(overline(x)^2 + overline(y)^2)
$ <eq-ap>

Har bir siklda erişilgan nuqtaning örtaça holatdan uzoqligi va *takroriy pozitsiyalaş aniqligi* (_repeatability_):

$
  l_j = sqrt((Delta x_j - overline(x))^2 + (Delta y_j - overline(y))^2), quad overline(l) = 1 / N sum_(j=1)^N l_j
$ <eq-lj>

$ S_l = sqrt((sum_(j=1)^N (l_j - overline(l))^2) / (N - 1)), quad R P = overline(l) + 3 S_l $ <eq-rp>

= Namunaviy masalalar va ularning yeçimlari

== Masala 1: pnevmatik qisqiçning qisiş kuçi

*Şarti:* qisqiç porşen diametri $D = 30$ mm bölgan ikki tomonlama pnevmosilindr bilan harakatlantiriladi. Havo bosimi $p = 0.5$ MPa, riçagning uzatiş koeffitsiyenti $k = 1.2$, FIK $eta = 0.9$. Qisiş kuçini toping va massasi $m = 2$ kg bölgan zagotovkani uşlaş uçun yetarli ekanini tekşiring ($a = 3 "m/s"^2$, $mu = 0.2$, $n = 2$, $S = 2$).

*Yeçiş* (@eq-grip, @eq-greq):

- Porşen yuzasi va silindr kuçi:
  $
    A = (pi dot 0.03^2) / 4 approx 7.07 dot 10^(-4) "m"^2, quad F_c = 0.5 dot 10^6 dot 7.07 dot 10^(-4) approx 353.4 "N"
  $
- Qisiş kuçi:
  $ F_q = 353.4 dot 1.2 dot 0.9 approx 381.7 "N" $
- Zarur kuç:
  $ F_"zar" = (2 dot (9.81 + 3) dot 2) / (0.2 dot 2) approx 128.1 "N" $

*Javob:* $F_q approx 381.7 "N" > F_"zar" approx 128.1 "N"$, qisqiç zagotovkani işonçli uşlaydi.

== Masala 2: işçi zona hajmi va öq böylab siljiş vaqti

*Şarti:* robotning işçi zonasi $300 times 300 times 150$ mm. $X$ öqi böylab $L = 300$ mm siljişda yuritma avval $v_t = 0.2$ m/s tezlikda harakatlanadi, oxirgi $L_s = 20$ mm ni esa $v_s = 0.02$ m/s tezlikda bosib ötadi. (Tezliklar öquv maqsadida şartli olingan.) Işçi zona hajmini va siljiş vaqtini toping.

*Yeçiş* (@eq-ws, @eq-time):
$ V_"iz" = 0.3 dot 0.3 dot 0.15 = 0.0135 "m"^3 = 13.5 "l" $
$ t = (0.30 - 0.02) / 0.2 + 0.02 / 0.02 = 1.4 + 1.0 = 2.4 "s" $

*Javob:* $V_"iz" = 13.5$ l; $t = 2.4$ s. Sekin tezlikdagi qisqa yöl umumiy vaqtning qariyb $40 %$ ini egallaydi: aniqlik uçun “tölanadigan narx” şu.

== Masala 3: tajriba natijalari böyiça aniqlik va takroriylikni hisoblaş

*Şarti:* 10 ta siklda nazorat nuqtasida quyidagi oğişlar (mm) ölçangan:

#align(center)[
  #set text(size: 10pt)
  #table(
    columns: 11,
    stroke: none,
    align: center,
    inset: (x: 5pt, y: 4pt),
    table.hline(stroke: 1pt),
    [*$j$*], [1], [2], [3], [4], [5], [6], [7], [8], [9], [10],
    table.hline(stroke: 0.5pt),
    [*$Delta x_j$*], [0.12], [0.08], [0.15], [0.10], [0.05], [0.11], [0.14], [0.09], [0.07], [0.13],
    [*$Delta y_j$*], [$-0.05$], [0.02], [$-0.03$], [0.00], [$-0.06$], [0.01], [$-0.04$], [0.03], [$-0.02$], [$-0.01$],
    table.hline(stroke: 1pt),
  )
]

Pozitsiyalaş aniqligi va takroriyligini toping.

*Yeçiş:*

- Örtaça oğişlar va aniqlik (@eq-ap):
  $ overline(x) = 1.04 / 10 = 0.104 "mm", quad overline(y) = -0.15 / 10 = -0.015 "mm" $
  $ A P = sqrt(0.104^2 + 0.015^2) approx 0.105 "mm" $
- Har bir sikl uçun $l_j$ (@eq-lj), mm: 0.039; 0.042; 0.048; 0.016; 0.070; 0.026; 0.044; 0.047; 0.034; 0.027. Ularning örtaçasi $overline(l) approx 0.039$ mm.
- Standart oğiş va takroriylik (@eq-rp):
  $ S_l approx 0.015 "mm", quad R P = 0.039 + 3 dot 0.015 approx 0.085 "mm" $

*Javob:* $A P approx 0.11$ mm; $R P approx 0.09$ mm. Takroriylik aniqlikdan yaxşi: robot nuqtaga har safar deyarli bir xil çiqadi, lekin örtaça holat maqsaddan siljigan. Bunday sistematik xatoni robotni nuqtaga qayta örgatiş yoki kalibrlaş orqali kamaytiriş mumkin.

= Nazorat savollari

+ «Elektronika-NSTM-01» roboti qanday vazifaga möljallangan va u stanok bilan qanday modul hosil qiladi?
+ Robot qanday koordinata tizimida işlaydi? Uning harakat öqlarini va erkinlik darajalari sonini körsating.
+ Nima uçun robot ikkita qisqiç bilan jihozlangan va bu iş siklini qanday qisqartiradi?
+ Çiziqli öqlarning elektromexanik yuritmasi qanday işlaydi? Impuls datçigining vazifasi nima?
+ Ikki tezlikli pozitsion yuritma qanday işlaydi va u nima uçun qöllaniladi?
+ Robotda pnevmoyuritma qaysi harakatlar uçun işlatiladi? Uning afzalliklari nimada?
+ Dekart robotining töğri va teskari kinematika masalalari nima uçun sodda?
+ Pozitsiyalaş aniqligi va takroriy pozitsiyalaş aniqligi qanday farqlanadi va qanday hisoblanadi?
