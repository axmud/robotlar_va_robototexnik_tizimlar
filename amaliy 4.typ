// ============================================================
//  Robotlar va robototexnik tizimlar — 3-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile rrti_amaliy_mashgulot_3.typ
// ============================================================

#import "@preview/cetz:0.4.2"

#let headingblue = rgb(20, 50, 120)

#set document(title: "Sanoat robotining kinematikasini oʻrganish. 2-qism")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 4  // amaliyot raqami
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MASHGʻULOTI №4]
  #v(0.4cm)
  #text(
    size: 14pt,
    weight: "bold",
  )[Mavzu: Sanoat robotining kinematikasini oʻrganish. 2-qism: Koordinatalar tizimlari, D-H parametrlari va ishchi zona topologiyasi]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Ishning maqsadi

*Mashgʻulotning maqsadi:* talabalarda sanoat robotlarida qoʻllaniladigan koordinatalar tizimlarini (bazaviy, boʻgʻin, tutqich va obyekt freymlari) toʻgʻri oʻrnatish, *Denavit–Hartenberg (D-H)* standart konvensiyasi boʻyicha kinematik zanjirlarni parametrlash hamda robot manipulyatorining *ishchi zonasini* (_workspace_) va uning chegaraviy qobigʻini analitik hisoblash koʻnikmalarini shakllantirish.

*Oʻquv vazifalari va kutilayotgan natijalar:*

- *Koordinata freymlarini oʻrnatish:* bazaviy ${s}$, manipulyator korpusi ${b}$, bilak/flanets ${e}$ va ishchi asbob TCP ${t}$ freymlari oʻrtasidagi transformatsiya zanjirlarini tuzish.
- *D-H parametrlash:* $a_i$ (boʻgʻin uzunligi), $alpha_i$ (boʻgʻin buralishi), $d_i$ (boʻgʻin siljishi) va $theta_i$ (boʻgʻin burchagi) parametrlarini aniqlash va bir jinsli transformatsiya matritsalarini ($A_i^(i-1) in "SE"(3)$) shakllantirish.
- *Ishchi zona topologiyasi:* erishiladigan (_reachable_, $cal(W)_R$) va epchillik / orientatsion (_dextrous_, $cal(W)_D$) ishchi sohalarini farqlash hamda 3D qobiq hajmini ($cal(V)_"ws"$) analitik hisoblash.
- *Singulyarlik va chegaralar:* Yakobi matritsasining singulyar holatlarini ($det J(q) = 0$) va ularning ishchi soha chegaralariga taʼsirini tahlil qilish.

= Nazariy asoslar va analitik formulalar

== Sanoat robotlarida koordinata tizimlari va transformatsiyalar

Robot manipulyatori fazoda harakatlanganda uning har bir boʻgʻini hamda atrof-muhitdagi obyektlar maxsus koordinata freymlari orqali tasvirlanadi.

*Taʼrif.* *Oʻng qoʻl koordinata freymi* ($cal(F)$) --- 3D Evklid fazosidagi $O X Y Z$ dekart koordinata tizimi boʻlib, uning birlik vektorlari $hat(x), hat(y), hat(z)$ uchun $hat(z) = hat(x) times hat(y)$ sharti bajariladi.

Sanoat robototexnikasida quyidagi asosiy freymlar kaskadi qoʻllaniladi:

+ *Bazaviy / statsionar freym* (${s}$ -- _base frame_): robot asosining markazida joylashtiriladi.
+ *Boʻgʻin freymlari* (${i}$ -- _link frames_): har bir $i$-boʻgʻinga mahkamlangan lokal koordinata tizimlari.
+ *Bilak / flanets freymi* (${e}$ -- _wrist / flange frame_): manipulyatorning oxirgi mexanik flanetsida joylashadi.
+ *Asbob markaziy nuqtasi freymi* (${t}$ -- _TCP frame_): payvandlash gorelkasi uchi, pnevmotutqich markazi yoki lazer boshi kabi ishchi asbobga biriktirilgan freym.
+ *Obyekt / ishchi maydon freymi* (${o}$ -- _object / world frame_): konveyer, ishlov beriladigan detal yoki stol markazidagi koordinata tizimi.

Transformatsiya zanjiri quyidagi tenglama bilan ifodalanadi:

$ T_"object"^"base" = T_"body"^"base" (q) dot T_"flange"^"body" dot T_"tcp"^"flange" dot T_"object"^"tcp" $ <eq-chain>

Bir jinsli transformatsiya matritsasi $T in "SE"(3)$ pozitsiya vektori $P in bb(R)^3$ va rotatsiya matritsasi $R in "SO"(3)$ dan tashkil topadi:

$
  T = mat(R, P; 0_(1 times 3), 1) = mat(
    r_11, r_12, r_13, P_x;
    r_21, r_22, r_23, P_y;
    r_31, r_32, r_33, P_z;
    0, 0, 0, 1
  )
$ <eq-T>

bunda $R^T R = I_(3 times 3)$ va $det R = +1$ ortonormallik shartlari bajariladi.

== Denavit–Hartenberg (D-H) parametrlash konvensiyasi

Denavit va Hartenberg taklif etgan konvensiyaga muvofiq har bir kinematik boʻgʻinga koordinata freymi quyidagi qatʼiy qoidalar asosida oʻrnatiladi:

+ $z_i$ oʻqi $(i+1)$-boʻgʻinning harakat oʻqi (aylanma yoki ilgarilanma) boʻylab yoʻnaltiriladi.
+ $x_i$ oʻqi $z_(i-1)$ va $z_i$ oʻqlari orasidagi umumiy perpendikulyar ($x_i perp z_(i-1)$ va $x_i perp z_i$) boʻylab yoʻnaltiriladi.
+ $y_i$ oʻqi oʻng qoʻl qoidasi boʻyicha $y_i = z_i times x_i$ sifatida aniqlanadi.

D-H konvensiyasidagi freymlar va 4 ta kinematik parametr @fig-dh da koʻrsatilgan.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let ax(a, b, col) = line(a, b, stroke: 1.3pt + col, mark: (end: ">", fill: col))
    let zc = blue.darken(10%)
    let xc = red.darken(10%)
    let O1 = (3.6, 1.6)

    // z_{i-1} oʻqi va x_{i-1}
    line((0, -0.6), (0, 0), stroke: (paint: zc, dash: "dashed"))
    ax((0, 0), (0, 3.4), zc)
    content((0, 3.4), [$z_(i-1)$], anchor: "south")
    ax((0, 0), (1.5, -0.65), xc)
    content((1.5, -0.65), [$x_(i-1)$], anchor: "west")
    circle((0, 0), radius: 0.06, fill: black)
    content((-0.1, -0.05), [$O_(i-1)$], anchor: "north-east")

    // d_i
    line((-0.45, 0), (-0.45, 1.6), stroke: 1pt + cacc, mark: (start: ">", end: ">", fill: cacc))
    content((-0.5, 0.8), [$d_i$], anchor: "east")

    // Umumiy normal a_i
    line((0, 1.6), O1, stroke: (paint: cacc, thickness: 1.2pt, dash: "dashed"))
    content((1.8, 1.65), [$a_i$], anchor: "south")

    // theta_i: x_{i-1} nusxasi va x_i orasida
    line((0, 1.6), (1.3, 1.6 - 0.56), stroke: (paint: luma(140), dash: "dotted"))
    arc((0.9, 1.6 - 0.39), start: -23deg, stop: 0deg, radius: 0.98, stroke: 1pt + cprim, mark: (
      end: ">",
      fill: cprim,
      scale: 0.6,
    ))
    content((1.15, 1.32), text(size: 10pt)[$theta_i$], anchor: "west")

    // Freym {i}
    ax(O1, (5.2, 1.6), xc)
    content((5.2, 1.6), [$x_i$], anchor: "west")
    line(O1, (3.6, 3.3), stroke: (paint: luma(140), dash: "dotted"))
    ax(O1, (4.45, 3.25), zc)
    content((4.45, 3.25), [$z_i$], anchor: "south")
    ax(O1, (3.05, 0.9), green.darken(40%))
    content((3.05, 0.9), [$y_i$], anchor: "north-east")
    arc((3.6, 2.5), start: 90deg, stop: 62.7deg, radius: 0.9, stroke: 1pt + cprim, mark: (
      end: ">",
      fill: cprim,
      scale: 0.6,
    ))
    content((3.95, 2.75), text(size: 10pt)[$alpha_i$], anchor: "south")
    circle(O1, radius: 0.06, fill: black)
    content((3.65, 1.55), [$O_i$], anchor: "north-west")

    // Izoh
    content((8.4, 1.4), box(
      fill: luma(245),
      stroke: 0.6pt + csec,
      radius: 3pt,
      inset: 6pt,
      align(left, text(size: 9pt)[
        $a_i$: $z_(i-1)$ va $z_i$ orasidagi masofa \
        $alpha_i$: $z_(i-1)$ va $z_i$ orasidagi burchak \
        $d_i$: $x_(i-1)$ va $x_i$ orasidagi siljish \
        $theta_i$: $x_(i-1)$ va $x_i$ orasidagi burchak
      ]),
    ))
  }),
  caption: [D-H konvensiyasiga muvofiq freymlarni joylashtirish va 4 ta kinematik parametr],
) <fig-dh>

Ikki qoʻshni ${i-1}$ va ${i}$ freymlar orasidagi transformatsiya matritsasi $A_i^(i-1)$ 4 ta elementar operatsiyaning koʻpaytmasidan iborat:

$
  A_i^(i-1) = bold("Rot")_(z, theta_i) dot bold("Trans")_(z, d_i) dot bold("Trans")_(x, a_i) dot bold("Rot")_(x, alpha_i)
$

Matritsa shaklida:

$
  A_i^(i-1) = mat(
    cos theta_i, -sin theta_i cos alpha_i, sin theta_i sin alpha_i, a_i cos theta_i;
    sin theta_i, cos theta_i cos alpha_i, -cos theta_i sin alpha_i, a_i sin theta_i;
    0, sin alpha_i, cos alpha_i, d_i;
    0, 0, 0, 1
  )
$ <eq-dh>

== Robot ishchi zonasi topologiyasi va uning chegaraviy qobigʻi

Sanoat robotining ishchi sohasi ($cal(W)$) --- asbob markaziy nuqtasi (TCP) yetib borishi mumkin boʻlgan fazoviy nuqtalar toʻplami (@fig-ws).

#figure(
  cetz.canvas(length: 0.95cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let C = (0, 1.2)
    let J2 = (1.0, 1.2 + 1.732)
    let TCP = (1.0 + 1.039, 1.2 + 1.732 - 0.6)

    // Ishchi soha (halqa)
    circle(C, radius: 3.2, fill: csec.lighten(85%), stroke: (paint: cprim, thickness: 1.2pt, dash: "dashed"))
    circle(C, radius: 0.8, fill: white, stroke: (paint: cacc, thickness: 1.2pt, dash: "dashed"))

    // Asos va L1
    rect((-0.5, -0.2), (0.5, 0), fill: luma(180), stroke: none)
    line((-0.5, 0), (0.5, 0), stroke: 1.2pt)
    line((0, 0), C, stroke: 1.5pt)
    content((0.1, 0.18), [$L_1$], anchor: "west")

    // L2 va L3
    line(C, J2, stroke: 3pt + csec)
    content((0.3, 2.35), [$L_2$], anchor: "east")
    line(J2, TCP, stroke: 2.5pt + cacc)
    content((1.6, 2.8), [$L_3$], anchor: "south-west")
    circle(C, radius: 0.07, fill: black)
    circle(J2, radius: 0.07, fill: black)
    circle(TCP, radius: 0.1, fill: red)
    content(TCP, text(size: 9pt)[TCP], anchor: "north-west")

    content((2.6, 4.25), text(size: 9pt, fill: cprim)[$cal(W)_R$ (tashqi chegara)], anchor: "south-west")
    content((-1.05, 1.2), text(size: 9pt, fill: cacc)[$cal(W)_"in"$ (ichki chegara)], anchor: "east")
  }),
  caption: [Planar manipulyatorning erishiladigan va ichkaridan chegaralangan ishchi sohasi],
) <fig-ws>

Ishchi zonalarning tasnifi:

+ *Erishiladigan ishchi zona* (_reachable workspace_, $cal(W)_R$): TCP hech boʻlmaganda bitta orientatsiya bilan yetib boradigan sohaning toʻliq hajmi.
+ *Epchillik (orientatsion) ishchi zona* (_dextrous workspace_, $cal(W)_D$): TCP barcha ixtiyoriy orientatsiyalarda ($forall R in "SO"(3)$) yetib boradigan ichki toʻplam: $cal(W)_D subset.eq cal(W)_R$.

Turli kinematik komponovkalar ishchi zona hajmining ($cal(V)_"ws"$) analitik ifodalari @tab-vol da keltirilgan.

#figure(
  btable(
    columns: (auto, auto, 1fr),
    align: (left + horizon, center + horizon, left + horizon),
    ([*Komponovka*], [*Kinematika*], [*Ishchi zona hajmi ($cal(V)_"ws"$) tenglamasi*]),
    [Dekart],
    [PPP],
    [$cal(V)_"ws" = Delta X dot Delta Y dot Delta Z$],
    [Silindrik],
    [RPP],
    [$cal(V)_"ws" = (Delta theta) / 2 (R_"out"^2 - R_"in"^2) dot Delta Z$],
    [Sferik],
    [RRP],
    [$cal(V)_"ws" = 1 / 3 Delta phi (cos theta_"min" - cos theta_"max") (R_"out"^3 - R_"in"^3)$],
    [SCARA],
    [RRP],
    [$cal(V)_"ws" = pi ((l_1 + l_2)^2 - (l_1 - l_2)^2) Delta Z = 4 pi l_1 l_2 Delta Z$],
    [Antropomorf],
    [6R],
    [$cal(V)_"ws" = 4 / 3 pi R_"max"^3 -$ singulyar ichki boʻshliqlar],
  ),
  caption: [Kinematik komponovkalar ishchi zonasi hajmining tenglamalari],
) <tab-vol>

= Namunaviy masalalar va ularning yechimlari

== Masala 1: 2R planar manipulyatorning D-H parametrlari va ishchi yuzasi

*Masala sharti:* tekislikdagi 2R manipulyatorning boʻgʻin uzunliklari $l_1 = 0.45 "m"$ va $l_2 = 0.30 "m"$. Boʻgʻin burchaklarining harakat diapazoni: $theta_1 in [0, pi]$ rad va $theta_2 in [-3 pi \/ 4, 3 pi \/ 4]$ rad.

#set enum(numbering: "a)")
+ D-H parametrlar jadvalini tuzing.
+ $T_2^0$ toʻgʻri kinematika matritsasini simvolik koʻrinishda chiqaring.
+ Manipulyatorning erishiladigan ishchi yuzasini ($S_"ws"$) hisoblang.
#set enum(numbering: "1.")

*Hisoblash bosqichlari:*

- *D-H parametrlar jadvali.* Boʻgʻinlar tekislikda joylashgani sababli barcha $z_i$ oʻqlari chizma tekisligiga perpendikulyar ($alpha_i = 0$, $d_i = 0$):

  #figure(
    btable(
      columns: 5,
      ([*Boʻgʻin $i$*], [*$a_i$ \[m\]*], [*$alpha_i$ \[rad\]*], [*$d_i$ \[m\]*], [*$theta_i$ \[rad\]*]),
      [1],
      [$l_1 = 0.45$],
      [0],
      [0],
      [$theta_1^*$],
      [2],
      [$l_2 = 0.30$],
      [0],
      [0],
      [$theta_2^*$],
    ),
    caption: [2R planar manipulyatorning D-H parametrlari],
  )

- *Bir jinsli transformatsiya matritsalari* ($c_i = cos theta_i$, $s_i = sin theta_i$, $c_(12) = cos(theta_1 + theta_2)$, $s_(12) = sin(theta_1 + theta_2)$ belgilashlari bilan):
  $
    A_1^0 = mat(c_1, -s_1, 0, l_1 c_1; s_1, c_1, 0, l_1 s_1; 0, 0, 1, 0; 0, 0, 0, 1), quad
    A_2^1 = mat(c_2, -s_2, 0, l_2 c_2; s_2, c_2, 0, l_2 s_2; 0, 0, 1, 0; 0, 0, 0, 1)
  $
  Toʻliq transformatsiya matritsasi $T_2^0 = A_1^0 A_2^1$:
  $
    T_2^0 = mat(
      c_(12), -s_(12), 0, l_1 c_1 + l_2 c_(12);
      s_(12), c_(12), 0, l_1 s_1 + l_2 s_(12);
      0, 0, 1, 0;
      0, 0, 0, 1
    )
  $
  TCP koordinatalari:
  $ P_x = l_1 cos theta_1 + l_2 cos(theta_1 + theta_2), quad P_y = l_1 sin theta_1 + l_2 sin(theta_1 + theta_2) $

- *Ishchi zona yuzasi.* Maksimal tashqi radius: $R_"out" = l_1 + l_2 = 0.45 + 0.30 = 0.75 "m"$. Minimal ichki radius ($abs(theta_2) = 3 pi \/ 4 = 135 degree$ boʻlganda):
  $
    R_"in" = sqrt(l_1^2 + l_2^2 - 2 l_1 l_2 cos(pi - abs(theta_(2,max)))) \
    = sqrt(0.45^2 + 0.30^2 - 2 dot 0.45 dot 0.30 dot cos 45 degree)
  $
  $
    R_"in" = sqrt(0.2025 + 0.09 - 0.27 dot 0.7071) = sqrt(0.2925 - 0.1909) \
    = sqrt(0.1016) approx 0.3187 "m"
  $
  Halqa sektori yuzasi ($theta_1 in [0, pi]$, yaʼni $Delta theta_1 = pi$ rad):
  $
    S_"ws" = (Delta theta_1) / (2 pi) dot pi (R_"out"^2 - R_"in"^2) = pi / (2 pi) dot pi (0.75^2 - 0.3187^2) \
    = pi / 2 (0.5625 - 0.1016) = 3.14159 / 2 dot 0.4609 approx 0.724 "m"^2
  $

*Javob:* $R_"out" = 0.75 "m"$, $R_"in" approx 0.319 "m"$, $S_"ws" approx 0.724 "m"^2$ (halqa sektori yaqinlashuvida).

== Masala 2: SCARA robotining D-H parametrlari va ishchi zona hajmi

*Masala sharti:* SCARA ($R R P$) sanoat roboti quyidagi oʻlchamlarga ega: $a_1 = 0.40 "m"$, $a_2 = 0.30 "m"$, ustun balandligi $d_1 = 0.50 "m"$; birinchi va ikkinchi boʻgʻinlarning burilish diapazonlari $theta_1 in [-120 degree, 120 degree]$, $theta_2 in [-140 degree, 140 degree]$; vertikal ilgarilanma boʻgʻin harakati $d_3 in [0, 0.25] "m"$.

#set enum(numbering: "a)")
+ D-H parametrlar jadvalini tuzing.
+ Ishchi zona hajmini ($cal(V)_"ws"$) analitik hisoblang.
#set enum(numbering: "1.")

*Hisoblash bosqichlari:*

- *D-H parametrlar jadvali.* SCARA robotida $z_0, z_1, z_2$ oʻqlari oʻzaro parallel va vertikal yoʻnalgan, $z_3$ esa vertikal siljish oʻqi:

  #figure(
    btable(
      columns: 5,
      ([*Boʻgʻin $i$*], [*$a_i$ \[m\]*], [*$alpha_i$ \[rad\]*], [*$d_i$ \[m\]*], [*$theta_i$ \[rad\]*]),
      [1],
      [$a_1 = 0.40$],
      [0],
      [$d_1 = 0.50$],
      [$theta_1^*$],
      [2],
      [$a_2 = 0.30$],
      [$pi$],
      [0],
      [$theta_2^*$],
      [3],
      [0],
      [0],
      [$d_3^*$],
      [0],
    ),
    caption: [SCARA robotining D-H parametrlari],
  )

- *Ishchi zona hajmi.* SCARA robotining ishchi sohasi gorizontal tekislikdagi figura yuzasi $S_(x y)$ ning vertikal yoʻl $Delta Z = d_(3,max) - d_(3,min) = 0.25 "m"$ ga koʻpaytmasiga teng:
  $ cal(V)_"ws" = S_(x y) dot Delta Z $
  Gorizontal tekislikdagi maksimal va minimal radiuslar:
  $ R_"max" = a_1 + a_2 = 0.40 + 0.30 = 0.70 "m" $
  $
    R_"min" = sqrt(a_1^2 + a_2^2 - 2 a_1 a_2 cos(pi - theta_(2,max))) \
    = sqrt(0.40^2 + 0.30^2 - 2 dot 0.40 dot 0.30 dot cos 40 degree)
  $
  $
    R_"min" = sqrt(0.16 + 0.09 - 0.24 dot 0.7660) = sqrt(0.25 - 0.1838) \
    = sqrt(0.0662) approx 0.2572 "m"
  $
  Burilish sektori $Delta theta_1 = 240 degree = 4 pi \/ 3$ rad:
  $
    S_(x y) = (Delta theta_1) / (2 pi) dot pi (R_"max"^2 - R_"min"^2) = (4 pi \/ 3) / (2 pi) dot pi (0.70^2 - 0.2572^2) \
    = 2 / 3 pi (0.49 - 0.0662) approx 0.8877 "m"^2
  $
  Ishchi zona hajmi:
  $ cal(V)_"ws" = 0.8877 "m"^2 dot 0.25 "m" approx 0.2219 "m"^3 approx 221.9 "litr" $

*Javob:* $R_"max" = 0.70 "m"$, $R_"min" approx 0.257 "m"$, $cal(V)_"ws" approx 0.222 "m"^3$.

= Individual amaliy topshiriqlar

Har bir talaba oʻz variant raqamiga mos robot koʻrsatkichlari (@tab-variants) boʻyicha quyidagilarni bajarishi lozim:

+ D-H parametrlar jadvalini tuzish.
+ Toʻgʻri kinematika tenglamalarini ($P_x, P_y, P_z$) shakllantirish.
+ Ishchi zona hajmini ($cal(V)_"ws"$) va maksimal erishish radiusini ($R_"max"$) analitik hisoblash.

#figure(
  btable(
    columns: (auto, 1fr, auto, auto, auto, auto, auto),
    align: (
      center + horizon,
      left + horizon,
      center + horizon,
      center + horizon,
      center + horizon,
      center + horizon,
      center + horizon,
    ),
    (
      [*Var.*],
      [*Robot modeli va turi*],
      [*$l_1 \/ a_1$ \ \[m\]*],
      [*$l_2 \/ a_2$ \ \[m\]*],
      [*$theta_(1,max)$*],
      [*$theta_(2,max)$*],
      [*$Delta Z \/ d_3$ \ \[m\]*],
    ),
    [*1*],
    [UR3e (antropomorf 6R)],
    [0.243],
    [0.213],
    [$plus.minus 180 degree$],
    [$plus.minus 150 degree$],
    [0.35],
    [*2*],
    [Adept Cobra s600 (SCARA)],
    [0.325],
    [0.275],
    [$plus.minus 105 degree$],
    [$plus.minus 130 degree$],
    [0.20],
    [*3*],
    [KUKA KR 6 R900 (6R)],
    [0.450],
    [0.400],
    [$plus.minus 170 degree$],
    [$plus.minus 120 degree$],
    [0.45],
    [*4*],
    [Fanuc M-10iA (antropomorf)],
    [0.560],
    [0.510],
    [$plus.minus 180 degree$],
    [$plus.minus 135 degree$],
    [0.50],
    [*5*],
    [ABB IRB 120 (6R)],
    [0.270],
    [0.220],
    [$plus.minus 165 degree$],
    [$plus.minus 110 degree$],
    [0.30],
    [*6*],
    [Epson G3 (SCARA)],
    [0.250],
    [0.200],
    [$plus.minus 120 degree$],
    [$plus.minus 140 degree$],
    [0.18],
    [*7*],
    [Yaskawa Motoman GP8],
    [0.345],
    [0.340],
    [$plus.minus 170 degree$],
    [$plus.minus 125 degree$],
    [0.40],
    [*8*],
    [Stäubli TS2-60 (SCARA)],
    [0.350],
    [0.250],
    [$plus.minus 110 degree$],
    [$plus.minus 135 degree$],
    [0.22],
    [*9*],
    [Kawasaki RS007L (6R)],
    [0.455],
    [0.375],
    [$plus.minus 180 degree$],
    [$plus.minus 130 degree$],
    [0.42],
    [*10*],
    [Comau RACER 5-0.80 (6R)],
    [0.400],
    [0.390],
    [$plus.minus 170 degree$],
    [$plus.minus 125 degree$],
    [0.38],
  ),
  caption: [Talabalar uchun individual hisoblash topshiriqlari],
) <tab-variants>

= Nazorat savollari

+ Bazaviy koordinatalar tizimi (${s}$) va TCP freymi (${t}$) oʻrtasidagi asosiy farqlar nimadan iborat?
+ D-H konvensiyasida $x_i$ oʻqining yoʻnalishini tanlash boʻyicha qanday cheklovlar mavjud?
+ Erishiladigan ($cal(W)_R$) va epchillik ($cal(W)_D$) ishchi zonalari bir-biridan nimasi bilan farq qiladi?
+ Robot manipulyatorida kinematik singulyarlik yuz berganda ishchi soha chegarasida nima kuzatiladi?
+ SCARA va antropomorf robotlarning ishchi zona shakli va samaradorlik koʻrsatkichlarini solishtiring.
+ Bir jinsli transformatsiya matritsasi $T in "SE"(3)$ ning teskari matritsasi $T^(-1)$ qanday sodda koʻrinishda topiladi?
