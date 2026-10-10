// ============================================================
//  Robotlar va robototexnik tizimlar — 2-amaliy mashgʻulot — Typst versiyasi
//  Kompilyatsiya: typst compile rrti_amaliy_mashgulot_2.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "«Elektronika-NSTM-01» sanoat robotining ishlash prinsipini oʻrganish")
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

// Blok formula (raqamlangan)
#let eq(body) = math.equation(block: true, numbering: "(1)", body)

// Chizmalar uchun ranglar
#let navy = rgb(0, 51, 102)
#let crimson = rgb(192, 57, 43)
#let accent = rgb(211, 84, 0)

// ---------------- Sarlavha ----------------
#align(center)[
  #set par(justify: false)
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MASHGʻULOTI №2]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[Mavzu: «Elektronika-NSTM-01» sanoat robotining ishlash prinsipini oʻrganish va analitik hisoblash]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Ishning maqsadi

*Mashgʻulotning maqsadi:* talabalarda «Elektronika-NSTM-01» tipidagi sanoat robotlarining pnevmo-elektr boshqaruv tizimlari, kinematik zanjiri, pnevmotutqichlarining qisish kuchi hamda silindrik ishchi sohasi hajmini analitik hisoblash va muhandislik loyihalash koʻnikmalarini shakllantirish.

*Kutilayotgan oʻquv va amaliy natijalar.* Ushbu amaliyot mashgʻulotini muvaffaqiyatli bajargan talaba quyidagilarni oʻrganadi:

+ *Pnevmoyuritmalar hisobi:* pnevmotsilindrlarning porshen ($D$) va shtok ($d$) diametrlari hamda pnevmotizim ishchi bosimi ($P$) asosida ilgarilanma va qisish kuchlarini ($F_"pnevm"$, $F_"grip"$) hisoblash.
+ *Kinematik modellashtirish:* 4-DoF ($R$-$P$-$P$-$R$) kinematik zanjirli robot uchun Denavit–Hartenberg (D-H) parametrlar jadvalini tuzish va toʻgʻri kinematika masalasi ($T_4^0$) orqali tutqichning (TCP -- _Tool Center Point_) dekart koordinatalarini ($P_x, P_y, P_z$) aniqlash.
+ *Ishchi soha va unumdorlik:* robotning silindrik ishchi sohasi hajmi ($V_"ws"$), pnevmosiljishlar vaqti ($T_"cycle"$) va havo sarfini ($Q$) analitik hisoblash.

= Nazariy asoslar va hisoblash formulalari

«Elektronika-NSTM-01» sanoat roboti kichik va oʻrta oʻlchamli detallarni ($0.5 dots 1.0 "kg"$) qadoqlash, yigʻish va texnologik liniyalarga uzatish uchun moʻljallangan pnevmo-elektr yuritmalarga ega manipulyatordir.

== Pnevmotsilindr va pnevmotutqichlarning kuch hisoblari

Robotning boʻgʻin harakatlari va tutqichining qisish kuchi pnevmotsilindrlar yordamida amalga oshiriladi.

#set enum(numbering: "a)")
+ *Pnevmotsilindr porshenining surishda hosil qiladigan kuchi ($F_"ext"$):*
  $ F_"ext" = P dot A_"p1" dot eta_"mech" = P dot (pi D^2) / 4 dot eta_"mech" $ <eq-fext>
  bunda $P$ --- pnevmotizimdagi ishchi bosim (Pa yoki N/m#super[2]), $D$ --- porshen diametri (m), $eta_"mech"$ --- pnevmotsilindrning mexanik foydali ish koeffitsienti ($eta_"mech" approx 0.85 dots 0.92$).

+ *Pnevmotsilindr shtoki tortilgandagi kuch ($F_"ret"$):*
  $ F_"ret" = P dot A_"p2" dot eta_"mech" = P dot (pi (D^2 - d^2)) / 4 dot eta_"mech" $ <eq-fret>
  bunda $d$ --- shtok diametri (m).

+ *Pnevmotutqichning qisish kuchi ($F_"grip"$) va detalni ushlab turish sharti.* Tutqich qismida richag-ponali (_lever-wedge_) mexanizm qoʻllanilgan boʻlib, qisish kuchi richag uzatish koeffitsienti ($k_"mech"$) orqali aniqlanadi:
  $ F_"grip" = k_"mech" dot F_"pnevm" $
  Detal tutqichdan sirpanib ketmasligi uchun quyidagi dinamik muvozanat sharti bajarilishi shart:
  $ 2 mu F_"grip" >= m (g + a_"max") k_"saf" quad ==> quad F_"grip" >= (m (g + a_"max") k_"saf") / (2 mu) $ <eq-grip>
  bunda $m$ --- detal massasi (kg), $g = 9.81 "m/s"^2$, $a_"max"$ --- robot manipulyatorining maksimal tezlanishi (m/s#super[2]), $mu$ --- tutqich va detal sirti oʻrtasidagi ishqalanish koeffitsienti, $k_"saf"$ --- ehtiyotlik (xavfsizlik) koeffitsienti ($k_"saf" approx 1.5 dots 2.0$).
#set enum(numbering: "1.")

== Robotning kinematikasi va Denavit–Hartenberg (D-H) tenglamalari

«Elektronika-NSTM-01» roboti *$R$-$P$-$P$-$R$* (aylanma -- ilgarilanma -- ilgarilanma -- aylanma) kinematik strukturaga ega (@fig-kin).

#figure(
  cetz.canvas(length: 1.2cm, {
    import cetz.draw: *
    let rot = (stroke: 2pt + crimson, mark: (end: ">", fill: crimson))
    let lin = (stroke: 2pt + accent, mark: (start: ">", end: ">", fill: accent))
    set-style(content: (padding: 2pt))

    // Asos
    rect((-1.5, -0.3), (1.5, 0), fill: luma(200), stroke: none)
    for i in range(0, 12) {
      line((-1.5 + i * 0.25, -0.3), (-1.25 + i * 0.25, 0), stroke: 0.5pt)
    }
    line((-1.5, 0), (1.5, 0), stroke: 1pt)
    rect((-1.2, 0), (1.2, 0.5), fill: luma(200), stroke: 1pt)
    content((0, 0.25), text(size: 8pt)[*Asos (Base)*])

    // 1-oʻq: burilish theta_1
    line((0, 0.5), (0, 3.5), stroke: (paint: gray, dash: "dashed"))
    rect((-0.5, 0.5), (0.5, 2.0), fill: blue.lighten(80%), stroke: 1pt)
    arc((0, 1.25), start: -90deg, stop: 180deg, radius: (0.4, 0.2), ..rot)
    content((0.75, 1.45), [$theta_1$], anchor: "west")

    // 2-oʻq: vertikal ilgarilanma z_2
    rect((-0.3, 2.0), (0.3, 4.0), fill: green.lighten(80%), stroke: 1pt)
    line((0.6, 2.2), (0.6, 3.4), ..lin)
    content((0.65, 2.8), [$z_2$], anchor: "west")

    // 3-oʻq: gorizontal ilgarilanma r_3
    rect((0, 3.5), (3.0, 4.1), fill: orange.lighten(80%), stroke: 1pt)
    line((1.0, 4.3), (2.8, 4.3), ..lin)
    content((1.9, 4.35), [$r_3$], anchor: "south")

    // 4-oʻq: bilak burilishi alpha_4 va tutqich
    rect((3.0, 3.2), (3.6, 4.2), fill: purple.lighten(80%), stroke: 1pt)
    arc((3.3, 3.0), start: -90deg, stop: 180deg, radius: (0.3, 0.15), ..rot)
    content((3.7, 2.9), [$alpha_4$], anchor: "west")
    rect((3.6, 3.2), (4.2, 3.4), fill: luma(150), stroke: 1pt)
    rect((3.6, 4.0), (4.2, 4.2), fill: luma(150), stroke: 1pt)
    circle((4.2, 3.7), radius: 0.07, fill: red)
    content((4.35, 3.7), text(size: 10pt)[*TCP* $(P_x, P_y, P_z)$], anchor: "west")

    // Koordinata freymlari
    content((-0.85, 0.85), text(fill: blue.darken(20%))[${0}$])
    content((-0.65, 2.5), text(fill: green.darken(40%))[${1}$])
    content((1.5, 3.2), text(fill: orange.darken(30%))[${2}$])
    content((3.3, 4.55), text(fill: purple.darken(20%))[${3}$])
  }),
  caption: [«Elektronika-NSTM-01» sanoat robotining 4-DoF kinematik strukturasi va koordinata freymlari],
) <fig-kin>

D-H matritsasining umumiy koʻrinishi:

$
  A_i = mat(
    cos theta_i, -sin theta_i cos alpha_i, sin theta_i sin alpha_i, a_i cos theta_i;
    sin theta_i, cos theta_i cos alpha_i, -cos theta_i sin alpha_i, a_i sin theta_i;
    0, sin alpha_i, cos alpha_i, d_i;
    0, 0, 0, 1
  )
$ <eq-dh>

Robot uchun umumiy transformatsiya matritsasi $T_4^0 = A_1 dot A_2 dot A_3 dot A_4$ boʻlib, tutqich markazining (TCP) dekart koordinatalari quyidagi analitik koʻrinishga ega boʻladi:

$
  cases(
    P_x = r_3 dot cos theta_1,
    P_y = r_3 dot sin theta_1,
    P_z = d_1 + z_2
  )
$ <eq-fk>

bunda $d_1$ --- robot asosining oʻzgarmas balandligi, $theta_1$ --- ustunning burilish burchagi, $z_2$ --- vertikal koʻtarilish, $r_3$ --- gorizontal qoʻlning siljishi.

== Silindrik ishchi soha hajmi va pnevmotizim havo sarfi

Robot tutqichining harakat sohasi silindrik sektor koʻrinishida boʻlib, uning hajmi ($V_"ws"$) quyidagi ifoda orqali hisoblanadi:

$
  V_"ws" = (theta_("1,max") - theta_("1,min")) / (360 degree) dot pi (r_("3,max")^2 - r_("3,min")^2) \
  dot (z_("2,max") - z_("2,min"))
$ <eq-vws>

Pnevmotsilindrlarning bitta toʻliq sikl davomida sarflaydigan siqilgan havo hajmi ($Q_"cycle"$, erkin havo hajmiga keltirilgan):

$
  Q_"cycle" = sum_(i=1)^k ((P_i + P_"atm") / P_"atm") dot pi / 4 \
  dot (D_i^2 L_i + (D_i^2 - d_i^2) L_i)
$ <eq-q>

bunda $P_"atm" = 0.1013 "MPa"$, $L_i$ --- $i$-pnevmotsilindrning yurish masofasi (xodi).

= Pnevmoavtomatika va boʻgʻinlarning grafik sxemalari

== Pnevmoavtomatik boshqaruv tizimining funksional sxemasi

#figure(
  {
    set text(size: 8.5pt)
    let b(body) = align(center, body)
    let vfill = orange.lighten(80%)
    let cfill = green.lighten(85%)
    diagram(
      node-stroke: 0.8pt + headingblue,
      node-fill: blue.lighten(93%),
      node-corner-radius: 3pt,
      node-inset: 5pt,
      spacing: (7mm, 5mm),
      edge-stroke: 1pt + headingblue,

      node((0, 1), b[*Siqilgan havo* \ ($P = 0.5 "MPa"$)], width: 2.5cm, height: 1.1cm),
      node((1, 1), b[*FRL bloki* \ (filtr / rostlagich)], width: 2.5cm, height: 1.1cm, fill: yellow.lighten(75%)),
      node((2, 0), b[*5/2 taqsimlagich 1* \ ($theta_1$)], width: 3.1cm, height: 1.1cm, fill: vfill),
      node((2, 1), b[*5/2 taqsimlagich 2* \ ($z_2$)], width: 3.1cm, height: 1.1cm, fill: vfill),
      node((2, 2), b[*5/2 taqsimlagich 3* \ ($r_3$)], width: 3.1cm, height: 1.1cm, fill: vfill),
      node((3, 0), b[Pnevmomotor / \ pnevmotsilindr 1], width: 2.9cm, height: 1.1cm, fill: cfill),
      node((3, 1), b[Pnevmotsilindr 2], width: 2.9cm, height: 1.1cm, fill: cfill),
      node((3, 2), b[Pnevmotsilindr 3], width: 2.9cm, height: 1.1cm, fill: cfill),

      edge((0, 1), (1, 1), "-|>"),
      edge((1, 1), (1.5, 1), (1.5, 0), (2, 0), "-|>"),
      edge((1, 1), (2, 1), "-|>"),
      edge((1, 1), (1.5, 1), (1.5, 2), (2, 2), "-|>"),
      edge((2, 0), (3, 0), "=>"),
      edge((2, 1), (3, 1), "=>"),
      edge((2, 2), (3, 2), "=>"),
    )
  },
  caption: [«Elektronika-NSTM-01» pnevmoavtomatik boshqaruv tizimining funksional sxemasi],
) <fig-pneu>

== Pnevmotutqichning richag-ponali mexanizmi

#figure(
  cetz.canvas(length: 1.25cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let farrow = (stroke: 2pt + navy, mark: (end: ">", fill: navy))

    rect((0, 0), (2, 1), fill: luma(220), stroke: 1pt)
    content((1, 0.5), text(size: 8pt)[Porshen shtoki])
    line((2, 0.5), (3.5, 0.5), stroke: 2pt + red, mark: (end: ">", fill: red))
    content((2.75, 0.55), [$F_"pnevm"$], anchor: "south")

    line((3.5, 0), (5, 0.5), (3.5, 1), close: true, fill: orange.lighten(65%), stroke: 1pt)
    line((4.5, 1.2), (6.5, 1.8), (6.5, 1.4), (4.5, 0.8), close: true, fill: blue.lighten(80%), stroke: 1pt)
    line((4.5, -0.2), (6.5, -0.8), (6.5, -0.4), (4.5, 0.2), close: true, fill: blue.lighten(80%), stroke: 1pt)

    circle((7.1, 0.5), radius: 0.6, fill: red.lighten(60%), stroke: 1pt)
    content((7.1, 0.5), text(size: 8pt)[Detal])

    line((7.1, 1.75), (7.1, 1.15), ..farrow)
    content((7.2, 1.55), [$F_"grip"$], anchor: "west")
    line((7.1, -0.75), (7.1, -0.15), ..farrow)
    content((7.2, -0.55), [$F_"grip"$], anchor: "west")
  }),
  caption: [Pnevmotutqichning richag-ponali mexanizmidagi kuchlar taqsimoti sxemasi],
) <fig-wedge>

= Namunaviy hisoblash misollari va amaliy masalalar yechimi

== Masala 1: pnevmotutqich va detal muvozanati hisobi

*Masala sharti:* «Elektronika-NSTM-01» robot pnevmotutqichi massasi $m = 0.8 "kg"$ boʻlgan poʻlat detalni vertikal koʻtarib koʻchirmoqda. Manipulyatorning maksimal vertikal tezlanishi $a_"max" = 3.5 "m/s"^2$. Tutqich va detal oʻrtasidagi ishqalanish koeffitsienti $mu = 0.25$, xavfsizlik koeffitsienti $k_"saf" = 1.8$.

#set enum(numbering: "a)")
+ Detalni sirpanib ketmasdan ushlab turish uchun zarur boʻlgan minimal qisish kuchini ($F_"grip"$) hisoblang.
+ Agar pnevmotutqichning richag uzatish koeffitsienti $k_"mech" = 1.4$, pnevmotsilindr porshen diametri $D = 25 "mm"$ va $eta_"mech" = 0.90$ boʻlsa, zaruriy minimal pnevmotizim bosimini ($P_"min"$) aniqlang.
#set enum(numbering: "1.")

*Hisoblash bosqichlari:*

- Minimal qisish kuchi @eq-grip dagi dinamik muvozanat shartidan:
  $ F_"grip" = (m (g + a_"max") k_"saf") / (2 mu) = (0.8 dot (9.81 + 3.5) dot 1.8) / (2 dot 0.25) \
    = (0.8 dot 13.31 dot 1.8) / 0.5 = 19.1664 / 0.5 approx 38.33 "N" $
- Tutqich richag uzatmasi orqali pnevmotsilindrning zaruriy kuchi:
  $ F_"pnevm" = F_"grip" / k_"mech" = 38.33 / 1.4 approx 27.38 "N" $
- Pnevmotsilindr porshen yuzasi:
  $ A_"p1" = (pi D^2) / 4 = (pi dot (0.025)^2) / 4 approx 4.9087 times 10^(-4) "m"^2 $
- Talab etiladigan minimal manba bosimi:
  $ P_"min" = F_"pnevm" / (A_"p1" dot eta_"mech") = 27.38 / (4.9087 times 10^(-4) dot 0.90) = 27.38 / (4.4178 times 10^(-4)) \
    approx 61976 "Pa" approx 0.062 "MPa" thick (0.62 "bar") $

== Masala 2: toʻgʻri kinematika va TCP koordinatalarini aniqlash

*Masala sharti:* «Elektronika-NSTM-01» roboti boʻgʻinlariga quyidagi umumlashtirilgan koordinatalar berilgan:

- asos balandligi $d_1 = 350 "mm"$;
- ustunning burilish burchagi $theta_1 = 60 degree$;
- vertikal koʻtarilish $z_2 = 120 "mm"$;
- gorizontal qoʻl uzayishi $r_3 = 280 "mm"$.

Tutqich markazining (TCP) dekart koordinatalarini ($P_x, P_y, P_z$) va asos koordinatalar sistemasiga nisbatan umumiy masofasini ($R_"TCP"$) aniqlang.

*Hisoblash bosqichlari:*

- Toʻgʻri kinematika tenglamalariga (@eq-fk) berilgan qiymatlarni qoʻyamiz:
  $
    P_x &= r_3 dot cos theta_1 = 280 dot cos 60 degree = 280 dot 0.5 = 140.0 "mm" \
    P_y &= r_3 dot sin theta_1 = 280 dot sin 60 degree = 280 dot 0.8660 approx 242.49 "mm" \
    P_z &= d_1 + z_2 = 350 + 120 = 470.0 "mm"
  $
- TCP nuqtasining koordinata boshidan umumiy masofasi ($P_x^2 + P_y^2 = r_3^2$ ekanligidan):
  $ R_"TCP" = sqrt(P_x^2 + P_y^2 + P_z^2) = sqrt(r_3^2 + P_z^2) = sqrt(78400 + 220900) \
    = sqrt(299300) approx 547.08 "mm" $

= Talabalar uchun individual amaliy topshiriqlar

Har bir talaba oʻzining variant raqami boʻyicha @tab-variants dan texnik koʻrsatkichlarni olib, quyidagi hisoblarni bajarishi shart:

+ Detalni xavfsiz qisish uchun minimal kuch $F_"grip"$ va pnevmotizim bosimi $P_"min"$ ni hisoblash.
+ Berilgan boʻgʻin koordinatalari boʻyicha tutqichning (TCP) dekart koordinatalarini ($P_x, P_y, P_z$) topish.
+ Robotning silindrik ishchi sohasi hajmini ($V_"ws"$) hisoblash.

#figure(
  {
    set text(size: 9.5pt)
    set par(justify: false)
    table(
      columns: 10,
      align: center + horizon,
      stroke: none,
      inset: (x: 4pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header(
        [*Var.*],
        [*$m$ \ [kg]*],
        [*$a_"max"$ \ [m/s#super[2]]*],
        [*$mu$*],
        [*$D$ \ [mm]*],
        [*$k_"mech"$*],
        [*$theta_1$ \ [°]*],
        [*$z_2$ \ [mm]*],
        [*$r_3$ \ [mm]*],
        [*$theta_"max"$ \ [°]*],
      ),
      table.hline(stroke: 0.5pt),
      [*1*], [0.5], [2.0], [0.20], [20], [1.2], [30], [100], [200], [180],
      [*2*], [0.6], [2.5], [0.22], [20], [1.3], [45], [120], [220], [210],
      [*3*], [0.7], [3.0], [0.25], [25], [1.4], [60], [150], [250], [240],
      [*4*], [0.8], [3.5], [0.28], [25], [1.5], [90], [180], [280], [270],
      [*5*], [0.9], [4.0], [0.30], [25], [1.6], [120], [200], [300], [300],
      [*6*], [1.0], [4.5], [0.32], [30], [1.7], [135], [220], [320], [320],
      [*7*], [1.1], [5.0], [0.35], [30], [1.8], [150], [250], [350], [330],
      [*8*], [1.2], [2.2], [0.25], [30], [1.5], [180], [160], [260], [360],
      [*9*], [0.75], [3.2], [0.27], [25], [1.4], [210], [140], [240], [270],
      [*10*], [0.95], [3.8], [0.29], [30], [1.6], [270], [190], [290], [300],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Individual amaliy topshiriqlar variantlari jadvali],
) <tab-variants>

_Izoh:_ barcha variantlar uchun asos balandligi $d_1 = 300 "mm"$, $r_("3,min") = 100 "mm"$, $z_("2,min") = 0 "mm"$, $k_"saf" = 1.5$, $eta_"mech" = 0.90$ deb qabul qilinsin.

= Nazorat savollari

+ «Elektronika-NSTM-01» robotida pnevmoyuritmalar qoʻllanilishining asosiy texnik-iqtisodiy afzalliklari va cheklovlari nimada?
+ Pnevmotsilindr porshenining surishdagi kuchi ($F_"ext"$) va shtok tortilgandagi kuchi ($F_"ret"$) nima uchun bir-biridan farq qiladi?
+ Tutqichda detalni ushlab turuvchi ishqalanish kuchi qanday omillarga (tezlanish, ishqalanish koeffitsienti, xavfsizlik koeffitsienti) bogʻliq?
+ Silindrik robotning toʻgʻri kinematik tenglamalari qanday tuziladi va ularni dekart koordinatalariga oʻtkazish formulalarini tushuntiring.
+ Robotning ishchi sohasi hajmi ($V_"ws"$) boʻgʻinlarning geometrik chegaralari bilan qanday bogʻlangan?
