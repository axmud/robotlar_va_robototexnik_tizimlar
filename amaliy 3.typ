// ============================================================
//  Robotlar va robototexnik tizimlar — 1-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile rrti_amaliy_mashgulot_1.typ
// ============================================================

#import "@preview/cetz:0.4.2"

#let headingblue = rgb(20, 50, 120)

#set document(title: "Sanoat robotining kinematikasini örganiş. 1-qism")
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

// Blok formula (raqamlangan)
#let eq(body) = math.equation(block: true, numbering: "(1)", body)

// Chizmalar uchun ranglar
#let pblue = rgb(0, 51, 102)
#let sblue = rgb(102, 178, 255)
#let dslate = rgb(47, 79, 79)

// ---------------- Sarlavha ----------------
#align(center)[
  #set par(justify: false)
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №3]
  #v(0.4cm)
  #text(
    size: 14pt,
    weight: "bold",
  )[Mavzu: Sanoat robotining kinematikasini örganiş. Robot manipulyatorlarining kinematik komponovkalari. Robot manipulyatorlarining konstruktiv xususiyatlari. 1-qism: Kinematik zanjir va erkinlik darajalari]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* sanoat robotlarining kinematik zanjirlari va komponovkalarini tahlil qiliş, kinematik juftliklarni tasniflaş, Grübler–Kutzbach formulasi yordamida oçiq, yopiq hamda gibrid manipulyatorlarning erkinlik darajalarini (DoF) va konfiguratsiya fazosini (C-space) hisoblaş könikmalarini şakllantiriş.

= Amaliy maşğulotning nazariy asoslari va hisoblaş formulalari

Sanoat robot manipulyatorlari bir-biri bilan harakatlanuvçan biriktirilgan va bir-biriga nisbatan nisbiy harakat qiladigan qattiq böğinlar ($N$) va kinematik juftliklar ($J$) majmuasidan iborat #strong[kinematik zanjirlar]ni hosil qiladi.

== Kinematik juftliklar va ularning tasnifi

Ikkita tutaş böğinning ularning nisbiy harakatiga çeklov qöyuvçi harakatlanuvçan birikmasi *kinematik juftlik* deyiladi. Tekislikdagi harakatda erkin böğin $m = 3$ erkinlik darajasiga ($x, y$ va $theta$), fazoda esa $m = 6$ erkinlik darajasiga (3 ta ilgarilaş $x, y, z$ va 3 ta buriliş $alpha, beta, gamma$) ega böladi. Kinematik juftlik bitta böğinning ikkinçisiga nisbatan harakatiga $s$ ta çeklov (svyaz) qöysa, uşbu juftlikning erkinlik darajasi $f = m - s$ böladi.

Sanoat robototexnikasida eng keng tarqalgan 1-sinf juftliklar ($f = 1$):

#set enum(numbering: "a)")
+ *Aylanma juftlik (Revolute -- R):* faqat bitta öq atrofida nisbiy burilişga ruxsat beradi ($f = 1$).
+ *Ilgarilanma juftlik (Prismatic -- P):* faqat bitta öq böylab nisbiy ilgarilanma siljişga ruxsat beradi ($f = 1$).
+ *Vintli juftlik (Helical -- H):* buriliş va ilgarilaş qatʼiy vint qadami $p$ bilan boğlangan ($f = 1$).
#set enum(numbering: "1.")

Yuqori tartibli kinematik juftliklar:

- *Silindrik juftlik (Cylindrical -- C):* bitta öq böyiça buriliş va ilgarilaş ($f = 2$).
- *Sferik juftlik (Spherical -- S):* uçta öq atrofida buriliş (şarnir, $f = 3$).
- *Tekislikdagi juftlik (Planar -- E):* tekislikda 2 ta ilgarilaş va 1 ta buriliş ($f = 3$).

Asosiy kinematik juftliklarning sxematik tasviri @fig-joints da keltirilgan.

#figure(
  cetz.canvas(length: 0.9cm, {
    import cetz.draw: *
    let red-arc = (stroke: 1.2pt + red, mark: (end: ">", fill: red))
    set-style(content: (padding: 2pt))

    // (a) Aylanma juftlik R
    group({
      line((0, 0.6), (0, 1.6), stroke: 3pt + pblue)
      line((0, -0.6), (0, -1.4), stroke: 3pt + pblue)
      rect((-0.4, -0.6), (0.4, 0.6), fill: luma(220), stroke: 1pt)
      content((0, 1.6), text(size: 9pt)[Böğin 2], anchor: "south")
      content((0, -1.4), text(size: 9pt)[Böğin 1], anchor: "north")
      arc((0.6, 0), start: 0deg, stop: 270deg, radius: (0.6, 0.25), ..red-arc)
      content((0, -2.5), text(size: 9pt)[#align(center)[*(a) Aylanma juftlik (R)* \ $f = 1$]])
    })

    // (b) Ilgarilanma juftlik P
    group({
      translate((5.5, 0))
      rect((-1.2, -0.2), (1.2, 0.2), fill: pblue.lighten(70%), stroke: 1pt)
      rect((-0.6, -0.6), (0.6, 0.6), fill: luma(220), stroke: 1pt)
      line((-1.5, 0.9), (1.5, 0.9), stroke: 1.5pt + red, mark: (start: ">", end: ">", fill: red))
      content((0, -2.5), text(size: 9pt)[#align(center)[*(b) Ilgarilanma juftlik (P)* \ $f = 1$]])
    })

    // (c) Sferik juftlik S
    group({
      translate((11, 0))
      line((0, -1.2), (0, -0.45), stroke: 3pt + luma(110))
      line((0.3, 0.3), (0.9, 0.9), stroke: 3pt + pblue)
      circle((0, 0), radius: 0.5, fill: luma(220), stroke: 1pt)
      content((0.9, 0.9), text(size: 9pt)[Böğin 2], anchor: "west")
      arc((0.6, 0), start: 0deg, stop: 180deg, radius: (0.6, 0.2), ..red-arc)
      arc((0, 0.6), start: 90deg, stop: -90deg, radius: (0.2, 0.6), ..red-arc)
      content((0, -2.5), text(size: 9pt)[#align(center)[*(c) Sferik juftlik (S)* \ $f = 3$]])
    })
  }),
  caption: [Sanoat robotlaridagi asosiy kinematik juftliklar sxemasi],
) <fig-joints>

== Grübler–Kutzbach mobil formulasi (DoF)

Robot manipulyatorining harakat erkinligi darajasi (DoF -- _Degrees of Freedom_) deb uning barça böğinlarining fazodagi vaziyatini töliq va bir qiymatli aniqlaş uçun zarur bölgan mustaqil umumlaştirilgan koordinatalar $q = [q_1, q_2, dots, q_n]^T$ soniga aytiladi.

*Grübler (Kutzbach) tenglamasi:*

$ "DoF" = m (N - 1 - J) + sum_(i=1)^J f_i $ <eq-grubler>

bunda $m$ --- işçi fazo ölçami ($m = 3$ tekislikdagi mexanizmlar uçun, $m = 6$ fazoviy mexanizmlar uçun), $N$ --- kinematik zanjirdagi böğinlarning umumiy soni (qözğalmas asos / poydevor bilan birga), $J$ --- kinematik juftliklar (birikmalar) soni, $f_i$ --- $i$-çi kinematik juftlikning erkinlik darajasi.

Agar mexanizmdagi barça juftliklar 1-sinf (odatiy $R$ va $P$ juftliklar, yaʼni $f_i = 1$) bölsa, formula soddalaşadi:

$ "DoF" = m (N - 1 - J) + J $

*Muhim ilova:* agar kinematik zanjir oçiq ketma-ket zanjir (_serial open chain_) bölsa, $N$ ta böğin uçun juftliklar soni $J = N - 1$ böladi. U holda:

$ "DoF" = m (N - 1 - (N - 1)) + sum_(i=1)^(N-1) f_i = sum_(i=1)^J f_i $

Yaʼni oçiq zanjirli sanoat robotining erkinlik darajasi uning juftliklari erkinlik darajalarining oddiy yiğindisiga teng.

== Konfiguratsiya fazosi (Configuration Space -- C-space)

Robotning har qanday lahzadagi vaziyati uning *konfiguratsiyasi* deb ataladi. Barça mumkin bölgan konfiguratsiyalar töplami *konfiguratsiya fazosi* ($cal(C)$) deyiladi.

- $n$ ta aylanma ($R$) juftlikka ega robot uçun C-fazo $n$-ölçamli tor körinişida böladi: $cal(C) = bb(T)^n = bb(S)^1 times bb(S)^1 times dots times bb(S)^1$.
- $n$ ta $R$ va $m$ ta ilgarilanma ($P$) juftlikka ega robot uçun: $cal(C) = bb(T)^n times bb(R)^m$.

= Namunaviy kinematik komponovkalar va ularning tahlili

Sanoat robotlari konstruktiv joylaşuvi va işçi soha (_workspace_) şakliga köra quyidagi asosiy komponovkalarga bölinadi (@tab-layouts).

#figure(
  {
    set text(size: 9.5pt)
    set par(justify: false)
    table(
      columns: (auto, auto, auto, auto, 1fr),
      align: (left + horizon, center + horizon, center + horizon, left + horizon, left + horizon),
      stroke: none,
      inset: (x: 4pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Komponovka \ nomi*], [*Kodi*], [*DoF*], [*Işçi soha*], [*Qöllaniliş sohasi*]),
      table.hline(stroke: 0.5pt),
      [*Dekart (Cartesian)*], [PPP], [3], [Parallelepiped], [Dastgohlarga xizmat körsatiş, 3D bosma, CNC],
      [*Silindrik (Cylindrical)*], [RPP], [3], [Silindr], [Presslaş, bosib çiqariş, konveyer liniyalari],
      [*Sferik (Spherical)*], [RRP], [3], [Sfera / şar], [Quyuv işlab çiqarişi, payvandlaş],
      [*SCARA*],
      [RRP],
      [3/4],
      [Gorizontal silindr],
      [Elektrotexnika platalarini yuqori tezlikda yiğiş (_pick-and-place_)],
      [*Antropomorf (Articulated)*], [6R], [6], [Murakkab sfera], [Avtomobilsozlikda payvandlaş, böyaş, yiğuv],
      [*Parallel (Stewart / Delta)*],
      [6-UPS],
      [6],
      [Kiçik gumbaz],
      [Yuqori aniqlikdagi simulyatorlar, tezkor saralaş],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Sanoat robotlarining asosiy kinematik komponovkalari xarakteristikasi],
) <tab-layouts>

SCARA va antropomorf robotlarning kinematik komponovka sxemalari @fig-layouts da körsatilgan.

#figure(
  cetz.canvas(length: 0.85cm, {
    import cetz.draw: *
    let red-arc = (stroke: 1pt + red, mark: (end: ">", fill: red))
    let dark = luma(77)

    // (a) SCARA (RRP)
    group({
      rect((-0.8, 0), (0.8, 0.3), fill: dark)
      rect((-0.3, 0.3), (0.3, 1.5), fill: luma(180))
      rect((-0.4, 1.5), (0.4, 2.0), fill: pblue.lighten(60%))
      arc((0.6, 1.75), start: 0deg, stop: 270deg, radius: (0.6, 0.2), ..red-arc)
      rect((0, 1.8), (2.0, 2.3), fill: sblue.lighten(70%), stroke: 1pt)
      rect((1.6, 2.3), (2.4, 2.8), fill: pblue.lighten(60%))
      rect((2.0, 2.5), (3.8, 3.0), fill: sblue.lighten(70%), stroke: 1pt)
      rect((3.6, 1.0), (4.0, 3.5), fill: luma(128))
      line((4.2, 1.2), (4.2, 3.3), stroke: 1.2pt + red, mark: (start: ">", end: ">", fill: red))
      content((2.0, -0.6), text(size: 9pt)[*(a) SCARA (RRP) robot*])
    })

    // (b) Antropomorf 6R
    group({
      translate((8, 0))
      rect((-0.8, 0), (0.8, 0.3), fill: dark)
      rect((-0.4, 0.3), (0.4, 1.0), fill: luma(180))
      arc((0.6, 0.65), start: 0deg, stop: 270deg, radius: (0.6, 0.2), ..red-arc)
      line((-0.2, 1.2), (1.0, 3.2), (1.4, 3.0), (0.2, 1.0), close: true, fill: sblue.lighten(70%), stroke: 1pt)
      rect((1.2, 3.1), (3.2, 3.4), fill: sblue.lighten(70%), stroke: 1pt)
      circle((0, 1.2), radius: 0.4, fill: pblue.lighten(50%))
      circle((1.2, 3.1), radius: 0.35, fill: pblue.lighten(50%))
      circle((3.2, 3.25), radius: 0.25, fill: red.lighten(40%))
      content((1.5, -0.6), text(size: 9pt)[*(b) Antropomorf 6R robot*])
    })
  }),
  caption: [SCARA va 6R antropomorf sanoat robotlarining kinematik komponovka sxemalari],
) <fig-layouts>

= Yeçilişi körsatilgan namunaviy amaliy masalalar

== Masala 1: tekislikdagi 3R manipulyatorning erkinlik darajasini hisoblaş

*Masala şarti:* tekislikdagi $3R$ oçiq kinematik zanjirli manipulyator berilgan (3 ta aylanma juftlik). Uşbu robotning böğinlar soni $N$, juftliklar soni $J$, Grübler formulasi böyiça erkinlik darajasi DoF va konfiguratsiya fazosi $cal(C)$ tuzilişini aniqlang.

*Yeçiş bosqiçlari:*

+ *Böğinlar sonini sanaymiz ($N$):* qözğalmas poydevor (asos) = 1 ta böğin (Böğin 0). Harakatlanuvçi böğinlar = 3 ta (Böğin 1, Böğin 2, Böğin 3). Jami böğinlar soni: $N = 1 + 3 = 4$.
+ *Kinematik juftliklar soni ($J$):* aylanma şarnirlar soni $J = 3$ (barçasi $f_i = 1$ erkinlikka ega 1-sinf juftliklar).
+ *Işçi fazo ölçami ($m$):* robot tekislikda harakat qilgani uçun $m = 3$.
+ *Grübler formulasi böyiça hisoblaş:*
  $ "DoF" = m (N - 1 - J) + sum_(i=1)^J f_i = 3 (4 - 1 - 3) + (1 + 1 + 1) = 3 dot 0 + 3 = 3 $
+ *Konfiguratsiya fazosi ($cal(C)$):* $n = 3$ ta aylanma juftlik mavjud va har bir $theta_i in \[0, 2 pi)$ bölgani uçun C-space 3-ölçamli tor hosil qiladi:
  $ cal(C) = bb(S)^1 times bb(S)^1 times bb(S)^1 = bb(T)^3 $

*Javob:* robot $"DoF" = 3$ ga ega va uning C-fazo ölçami 3 ga teng.

== Masala 2: yopiq zanjirli 5-böğinli tekislik mexanizmini tahlil qiliş

*Masala şarti:* sanoat yiğuv robotida qöllaniladigan yopiq zanjirli 5-böğinli tekislik mexanizmi (_planar 5-bar linkage_) berilgan (@fig-fivebar). Mexanizmdagi barça juftliklar aylanma ($R$) şarnirlardan iborat. Uşbu mexanizmning erkinlik darajasini va uni töliq boşqariş uçun neçta privod (motor) talab qilinişini aniqlang.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    let A = (0, 0)
    let B = (4, 0)
    let C = (1, 2.5)
    let D = (3, 3)
    let E = (2, 4.2)
    set-style(content: (padding: 3pt))

    rect((-0.5, -0.3), (4.5, 0), fill: luma(77))
    line(A, B, stroke: 1.2pt)
    content((0, -0.3), text(size: 9pt)[Asos (A)], anchor: "north")
    content((4, -0.3), text(size: 9pt)[Asos (B)], anchor: "north")

    line(A, C, stroke: 2pt + pblue)
    line(B, D, stroke: 2pt + pblue)
    line(C, E, stroke: 2pt + dslate)
    line(D, E, stroke: 2pt + dslate)
    content((0.5, 1.25), text(size: 9pt)[Böğin 1], anchor: "east")
    content((3.5, 1.5), text(size: 9pt)[Böğin 4], anchor: "west")
    content((1.5, 3.35), text(size: 9pt)[Böğin 2], anchor: "south-east")
    content((2.5, 3.6), text(size: 9pt)[Böğin 3], anchor: "south-west")

    circle(A, radius: 0.15, fill: red)
    circle(B, radius: 0.15, fill: red)
    circle(C, radius: 0.12, fill: luma(220))
    circle(D, radius: 0.12, fill: luma(220))
    circle(E, radius: 0.15, fill: green.darken(30%))
    content((2, 4.35), text(size: 9pt)[TCP (E)], anchor: "south")

    arc((0.5, 0.3), start: 30deg, stop: 120deg, radius: 0.5, stroke: 1.5pt + red, mark: (end: ">", fill: red))
    arc((3.5, 0.3), start: 150deg, stop: 60deg, radius: 0.5, stroke: 1.5pt + red, mark: (end: ">", fill: red))
  }),
  caption: [Yopiq zanjirli 5-böğinli tekislik mexanizmi kinematik sxemasi],
) <fig-fivebar>

*Yeçiş bosqiçlari:*

+ *Böğinlar soni ($N$):* qözğalmas poydevor (AB masofa) = Böğin 0. Harakatlanuvçi böğinlar: AC (1), CE (2), ED (3), DB (4). Jami böğinlar: $N = 5$.
+ *Juftliklar soni ($J$):* A, B, C, D, E nuqtalardagi aylanma şarnirlar $arrow.r J = 5$ ta $R$ juftlik ($f_i = 1$).
+ *Işçi fazo:* tekislik bölgani uçun $m = 3$.
+ *Grübler formulasi hisobi:*
  $
    "DoF" & = m (N - 1 - J) + sum_(i=1)^J f_i = 3 (5 - 1 - 5) + (1 + 1 + 1 + 1 + 1) \
          & = 3 dot (-1) + 5 = 2
  $

*Xulosa va amaliy tahlil:* mexanizm $"DoF" = 2$ ga ega. Demak, uşbu yopiq mexanizmdagi işçi aʼzo (TCP -- E nuqta) harakatini töliq va aniq boşqariş uçun aynan *2 ta aktiv servomotor* (masalan, A va B şarnirlarga örnatilgan) yetarli.

== Masala 3: fazoviy Stewart–Gough parallel manipulyatorini hisoblaş

*Masala şarti:* fazoviy 6-UPS (_Universal–Prismatic–Spherical_) Stewart platformasining erkinlik darajasini aniqlang. Platforma 6 ta gidravlik/elektr silindrli (P) oyoqlar orqali pastki asosga universal ($U$, $f = 2$) va yuqori harakatlanuvçi platformaga sferik ($S$, $f = 3$) juftliklar orqali biriktirilgan.

*Yeçiş bosqiçlari:*

+ *Işçi fazo:* fazoviy harakat bölgani uçun $m = 6$.
+ *Böğinlar soni ($N$):*
  - qözğalmas asos = 1;
  - yuqori harakatlanuvçi platforma = 1;
  - 6 ta oyoqning har biri 2 ta porşen qismidan iborat = $6 times 2 = 12$.
  Jami böğinlar: $N = 1 + 1 + 12 = 14$.
+ *Juftliklar va ularning erkinliklari ($J$):*
  - 6 ta universal juftlik ($U$): $f_U = 2 arrow.r sum = 12$;
  - 6 ta ilgarilanma juftlik ($P$): $f_P = 1 arrow.r sum = 6$;
  - 6 ta sferik juftlik ($S$): $f_S = 3 arrow.r sum = 18$.
  Jami juftliklar soni: $J = 6 + 6 + 6 = 18$. Juftlik erkinliklari yiğindisi: $sum f_i = 12 + 6 + 18 = 36$.
+ *Grübler hisobi:*
  $ "DoF" = 6 (14 - 1 - 18) + 36 = 6 dot (-5) + 36 = -30 + 36 = 6 $

*Javob:* Stewart platformasi fazoda töliq $"DoF" = 6$ (3 ta ilgarilaş va 3 ta buriliş) erkinlik darajasiga ega.

= Talabalar mustaqil bajarişi uçun amaliy variantlar töplami

Har bir talaba özining tartib raqamiga mos variantni (@tab-variants) tanlaydi va quyidagi vazifalarni bajaradi:

+ Variantdagi robotning kinematik zanjir turini (oçiq, yopiq, gibrid) aniqlang.
+ Böğinlar soni ($N$), kinematik juftliklar soni ($J$) hamda har bir juftlik erkinligini ($f_i$) jadval körinişida tuzing.
+ Grübler formulasi böyiça DoF ni hisoblang.
+ Robotning konfiguratsiya fazosi ($cal(C)$) ölçami va topologiyasini körsating.

#figure(
  {
    set text(size: 9.5pt)
    set par(justify: false)
    table(
      columns: (auto, 1fr, auto, auto, 1fr),
      align: (center + horizon, left + horizon, center + horizon, center + horizon, left + horizon),
      stroke: none,
      inset: (x: 4pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Var.*], [*Robot modeli / turi*], [*Juftliklar*], [*Fazo*], [*Qöşimça şart*]),
      table.hline(stroke: 0.5pt),
      [*1*], [KUKA KR 6 R900 (6R antropomorf)], [6R], [$m = 6$], [Barça öqlar aylanma],
      [*2*], [Fanuc M-1iA (3-RHR parallel Delta)], [3 RRR], [$m = 3$], [Yopiq parallel zanjir],
      [*3*], [Epson T3 SCARA roboti], [2R + 1P], [$m = 3$], [Vertikal $z$ öqi bilan],
      [*4*], [ABB IRB 6640 (seriyali payvandlaş)], [6R], [$m = 6$], [Asosiy va bilak öqlari],
      [*5*], [Stanford Arm manipulyatori], [2R-1P-3R], [$m = 6$], [Sferik bilakli RRP-3R],
      [*6*], [PUMA 560 sanoat roboti], [6R], [$m = 6$], [Töliq aylanma şarnirli],
      [*7*], [Planar 3-PRR parallel manipulyator], [3 PRR], [$m = 3$], [Tekislikdagi 3 DoF parallel],
      [*8*], [Universal Robots UR10e (kobot)], [6R], [$m = 6$], [Absolyut enkoderli 6 DoF],
      [*9*], [Silindrik koordinatali robot], [1R + 2P], [$m = 3$], [RPP komponovkali],
      [*10*], [4-DoF palletayzer roboti], [3R + 1P], [$m = 6$], [Parallelogramm mexanizm bilan],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Amaliyot topşiriqlari uçun variantlar jadvali],
  placement: auto,
) <tab-variants>

= Nazorat va muammoli savollar

+ Nima uçun oçiq kinematik zanjirli robotlarda erkinlik darajasi (DoF) şarnirlar erkinliklari yiğindisiga teng böladi, yopiq zanjirlarda esa unday emas?
+ Grübler formulasidagi $m = 3$ va $m = 6$ parametrlarining fizik maʼnosini tuşuntiring.
+ Passiv (ortiqça) erkinlik darajasi nima va u robotni boşqarişga qanday taʼsir körsatadi?
+ SCARA robotining vertikal yönalişdagi yuqori qattiqligi (_rigidity_) uning qaysi kinematik juftliklar joylaşuviga boğliq?
+ Parallel manipulyatorlarning (masalan, Delta va Stewart) oçiq seriyali robotlarga nisbatan asosiy kinematik afzalliklari va kamçiliklari nimada?
+ Konfiguratsiya fazosi (C-space) bilan dekart işçi fazosi (_task space_) örtasidagi farqni misollar bilan tuşuntiring.
