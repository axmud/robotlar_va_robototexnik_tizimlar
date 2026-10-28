// ============================================================
//  Robotlar va Robototexnik Tizimlar — 2-tajriba mashgʻuloti
//  Kompilyatsiya: typst compile rrt_tajriba_mashgulot_2.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)
#let accent = rgb(0, 120, 130)
#let secondary = rgb(180, 50, 20)

#set document(title: "«Elektronika-NSTM-01» sanoat robotining işlaş prinsipini örganiş")
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
    info.fan, info.semestr, [Tajriba №#raqam],
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

// ---------------- Sarlavha ----------------
#align(center)[
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIY MAŞĞULOTI №2]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[
    Mavzu: «Elektronika-NSTM-01» sanoat robotining işlaş prinsipini örganiş
  ]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* öquv va sanoat işlab çiqarişida keng qöllaniladigan «Elektronika-NSTM-01» sanoat roboti manipulyatorining tuzilişi, kinematik zanjiri, pnevmatik va elektr yuritmalari, datçiklar tizimi hamda dasturlanadigan boşqaruv blokining işlaş prinsiplarini örganiş.

*Öquv vazifalari:*

+ *Konstruktiv tuzilmani tahlil qiliş:* «Elektronika-NSTM-01» robotining mexanik tugunlari, böğinlari va işçi aʼzosi (tutqiç --- _end-effector_) tuzilişini örganiş.
+ *Kinematik tahlil va DoF hisobi:* manipulyatorning kinematik sxemasini tuziş, erkinlik darajalari sonini (_degrees of freedom_ --- DoF) Grübler--Kutzbach formulasi böyiça hisoblaş.
+ *Pnevmoyuritma elementlarini örganiş:* pnevmotsilindrlar, pnevmotaqsimlagiçlar (_directional control valves_) hamda havo bosimini boşqaruvçi klapanlarning iş rejimlarini tahlil qiliş.
+ *Boşqaruv va sensorika:* dasturlanadigan boşqaruv blokida siklik buyruqlar yaratiş va çekli öçirgiçlar (_limit switches_) orqali aks aloqani örganiş.
+ *Töğri kinematika masalasi:* robot tutqiçining fazoviy köçişlarini koordinata sistemalari va transformatsiya matritsalari orqali ifodalaş.

= Kerakli asbob-uskunalar va dasturiy taʼminot

- *Öquv-laboratoriya stendi:* «Elektronika-NSTM-01» sanoat roboti, dasturlanadigan boşqaruv pulti (_teach pendant_).
- *Pnevmatik jihozlar:* kompressor (işçi havo bosimi $0.5 "MPa"$), havo tayyorlaş bloki (FRL).
- *Nazorat-ölçov vositalari:* raqamli multimetr, pozitsiya datçiklari indikatsiya bloki, ştangensirkul.
- *Işçi detallar töplami:* silindrik va törtburçak şakldagi obyektlar.

= Nazariy maʼlumotlar

== Sanoat robotlarining avtomatlaştirişdagi roli

Zamonaviy moslaşuvçan işlab çiqariş tizimlarida (FMS --- _Flexible Manufacturing Systems_) sanoat robotlari inson omilini kamaytiriş, yuqori takrorlanuvçanlik va xavfsizlikni taʼminlaşda hal qiluvçi rol öynaydi. ISO 8373 standartiga köra, *sanoat roboti* --- bu köp maqsadli, avtomatik boşqariladigan, qayta dasturlanadigan va uç yoki undan ortiq öq böyiça harakatlana oladigan manipulyatsion qurilma.

== «Elektronika-NSTM-01» sanoat robotining umumiy tavsifi

«Elektronika-NSTM-01» --- kiçik va örta ölçamdagi detallarni (massasi $0.5 dots 1.0 "kg"$) ştamplaş, yiğiş, saralaş hamda dastgohlarga örnatiş va oliş operatsiyalarini avtomatlaştiriş uçun möljallangan modulli sanoat roboti. Manipulyatorning asosiy xususiyatlari:

- *Modullilik:* har bir harakat böğini pnevmatik yoki elektr modul şaklida mustaqil yiğilgan.
- *Yuqori tezlik va işonçlilik:* pnevmotsilindrlar yordamida tezkor ilgarilanma va aylanma harakatlar amalga oşiriladi.
- *Pozitsion boşqaruv:* har bir böğin harakati çekli öçirgiçlar yoki optoelektron datçiklar yordamida çegaralanadi.

== Kinematik struktura va erkinlik darajalari

Manipulyator oçiq kinematik zanjirdan (_serial kinematic chain_) iborat bölib, ketma-ket ulangan böğinlar (_links_) va kinematik juftliklardan (_joints_) taşkil topgan:

- *Aylanma juftlik (revolute --- R):* bir öq atrofida nisbiy buriliş harakatini taʼminlaydi (1 DoF).
- *Ilgarilanma juftlik (prismatic --- P):* bir öq böylab töğri çiziqli suriliş harakatini taʼminlaydi (1 DoF).

Fazoviy mexanizmlar uçun erkinlik darajasi *Grübler--Kutzbach formulasi* orqali hisoblanadi:

$ "DoF" = m (N - 1 - J) + sum_(i=1)^J f_i $

bunda:

- $m = 6$ --- uç ölçamli fazodagi jismning erkinlik darajalari soni;
- $N$ --- mexanizmdagi jami böğinlar soni (qözğalmas asos bilan birga);
- $J$ --- kinematik juftliklar soni;
- $f_i$ --- $i$-çi kinematik juftlikning erkinlik darajasi (R va P juftliklar uçun $f_i = 1$).

Oçiq kinematik zanjirli manipulyatorlarda barça $J$ ta juftlik bir erkinlikli va $N = J + 1$ bölsa, formula soddalaşadi:

$ "DoF" = sum_(i=1)^n f_i = n $

«Elektronika-NSTM-01» roboti 4 ta asosiy harakat böğiniga hamda 1 ta tutqiç qisiş mexanizmiga ega, yaʼni jami $4 + 1$ erkinlik darajasi mavjud.

= «Elektronika-NSTM-01» robotining kinematik sxemasi va tuzilişi

«Elektronika-NSTM-01» roboti silindrik koordinata sistemasida işlaydi. Uning kinematik harakatlari quyidagilardan iborat (@fig-kin):

+ *Asos burilişi ($theta_1$):* manipulyator tanasining vertikal öq atrofidagi aylanma harakati ($R_1$ böğin).
+ *Vertikal kötariliş/tuşiş ($z_2$):* manipulyator yelkasining $Z$ öqi böylab ilgarilanma köçişi ($P_2$ böğin).
+ *Gorizontal uzayiş ($r_3$):* qölning gorizontal konsol böylab surilişi ($P_3$ böğin).
+ *Tutqiç burilişi ($alpha_4$):* işçi organning (tutqiçning) öz öqi atrofida burilişi ($R_4$ böğin).
+ *Qisiş harakati ($q_5$):* pnevmotutqiç jağlarining yopilişi va oçilişi ($G_5$).

#figure(
  {
    set text(size: 8pt)
    cetz.canvas(length: 1.1cm, {
      import cetz.draw: *

      // Zamin
      rect((-1.5, -0.4), (1.5, 0), fill: luma(200), stroke: 0.9pt + headingblue)
      for i in range(7) {
        line((-1.3 + i * 0.4, -0.4), (-1.5 + i * 0.4, -0.7), stroke: 0.6pt + luma(90))
      }

      // Asos ustuni
      rect((-0.6, 0), (0.6, 2.5), fill: luma(240), stroke: 0.9pt + headingblue)
      content((0, 0.45), text(size: 7pt, weight: "bold")[Asos])

      // Z0 oʻqi
      line((0, -0.2), (0, 3.5), stroke: (paint: secondary, thickness: 0.8pt, dash: "dashed"), mark: (end: "straight"))
      content((0, 3.75), text(size: 7.5pt, fill: secondary)[$Z_0$ (vertikal öq)])

      // theta_1
      arc((0, 1.3), start: -30deg, stop: 210deg, radius: (0.85, 0.3), anchor: "origin", stroke: 1pt + secondary, mark: (
        end: "straight",
      ))
      content((1.55, 1.05), text(size: 7.5pt, fill: secondary)[$theta_1$])

      // Vertikal karetka (P2)
      rect((-0.8, 2.2), (0.8, 3.0), fill: accent.lighten(80%), stroke: 0.9pt + accent)
      line((-1.15, 2.0), (-1.15, 3.2), stroke: 1pt + accent, mark: (start: "straight", end: "straight"))
      content((-1.8, 2.6), text(size: 7.5pt, fill: accent)[$z_2$])

      // Gorizontal qoʻl (P3)
      rect((0.8, 2.4), (4.2, 2.8), fill: luma(240), stroke: 0.9pt + headingblue)
      line((1.5, 3.15), (3.8, 3.15), stroke: 1pt + headingblue, mark: (start: "straight", end: "straight"))
      content((2.65, 3.45), text(size: 7.5pt)[$r_3$ (uzayiş)])

      // Tutqich burilish moduli (R4)
      rect((4.2, 2.2), (4.8, 3.0), fill: secondary.lighten(75%), stroke: 0.9pt + secondary)
      arc(
        (4.5, 1.85),
        start: -30deg,
        stop: 210deg,
        radius: (0.4, 0.13),
        anchor: "origin",
        stroke: 1pt + secondary,
        mark: (end: "straight"),
      )
      content((3.65, 1.85), text(size: 7.5pt, fill: secondary)[$alpha_4$])

      // Pnevmotutqich
      rect((4.4, 1.5), (4.6, 2.2), fill: headingblue, stroke: none)
      line((4.1, 1.0), (4.3, 1.5), (4.45, 1.5), (4.45, 1.0), close: true, fill: luma(80), stroke: 0.7pt)
      line((4.9, 1.0), (4.7, 1.5), (4.55, 1.5), (4.55, 1.0), close: true, fill: luma(80), stroke: 0.7pt)
      circle((4.5, 0.75), radius: 0.07, fill: secondary, stroke: none)
      content((4.5, 0.45), text(size: 7pt, weight: "bold")[TCP])

      // Izoh
      rect((5.6, 0.3), (8.4, 2.6), fill: white, stroke: 0.8pt + headingblue, radius: 3pt)
      content((7.0, 1.45), align(left, text(size: 7pt)[
        *Böğinlar:* \
        1. Asos burilişi ($R_1$) \
        2. Vertikal suriliş ($P_2$) \
        3. Gorizontal suriliş ($P_3$) \
        4. Tutqiç burilişi ($R_4$) \
        5. Pnevmotutqiç ($G_5$)
      ]))
    })
  },
  caption: [«Elektronika-NSTM-01» sanoat robotining kinematik sxemasi va böğinlar harakati],
) <fig-kin>

= Pnevmatik yuritma va boşqaruv tizimi

== Pnevmoyuritma elementlari

«Elektronika-NSTM-01» robotining asosiy ilgarilanma va qisiş harakatlari *pnevmoyuritmalar* yordamida amalga oşiriladi. Pnevmoyuritmaning asosiy afzalliklari:

- yuqori tezkorlik (porşen tezligi $1.0 dots 1.5 "m/s"$ gaça);
- konstruksiyaning soddaligi va arzonligi;
- ortiqça yuklanişga (_overload_) çidamliligi;
- işçi muhitning (siqilgan havoning) ekologik xavfsizligi.

Pnevmatik tizim quyidagi asosiy bloklardan taşkil topgan:

+ *Siqilgan havo manbai (kompressor):* işçi bosim $P = 0.4 dots 0.6 "MPa"$ ($4 dots 6 "bar"$).
+ *Havo tayyorlaş bloki (FRL):* filtrlaş, bosimni rostlaş va moylaş moslamasi.
+ *Pnevmotaqsimlagiçlar (directional control valves):* elektropnevmatik $5\/2$ yoki $3\/2$ yölli zolotnikli klapanlar.
+ *Pnevmotsilindrlar:* ikki tomonlama taʼsir etuvçi (_double-acting_) pnevmotsilindrlar.

== Datçiklar va pozitsion aks aloqa

Manipulyator böğinlarining çekka nuqtalarga yetib borganligini qayd etiş uçun *çekli öçirgiçlar (limit switches)* yoki *optoelektron datçiklar* örnatilgan. Datçiklardan kelgan signal boşqaruv blokiga uzatiladi va navbatdagi pnevmoklapanga buyruq beriladi (@fig-ctrl).

#figure(
  {
    set text(size: 8pt)
    let b(body) = align(center, body)
    let small(body) = text(size: 7pt, body)
    let orng = orange.darken(15%)
    diagram(
      node-stroke: 0.8pt + headingblue,
      node-fill: blue.lighten(93%),
      node-corner-radius: 3pt,
      node-inset: 5pt,
      spacing: (10mm, 12mm),
      edge-stroke: 1pt + headingblue,

      node((1, 0), b[*Dasturlanadigan \ boşqaruv bloki* \ (PLC / mikrokontroller)], width: 3.3cm, height: 1.4cm),
      node(
        (2, 0),
        b[*Pnevmotaqsimlagiçlar* \ ($5\/2$ elektromagnit \ klapanlar)],
        width: 3.3cm,
        height: 1.4cm,
        fill: accent.lighten(88%),
        stroke: 0.8pt + accent,
      ),
      node((2, -1), b[*Kompressor* \ $P = 0.5 "MPa"$], width: 2.6cm, height: 1cm, fill: white, stroke: (
        paint: luma(90),
        thickness: 0.8pt,
        dash: "dashed",
      )),
      node(
        (2, 1),
        b[*Pnevmotsilindrlar* \ va yuritma modullari],
        width: 3.3cm,
        height: 1.4cm,
        fill: accent.lighten(88%),
        stroke: 0.8pt + accent,
      ),
      node((1, 1), b[*Manipulyator \ va tutqiç* \ (mexanik tuzilma)], width: 3.3cm, height: 1.4cm),
      node(
        (0, 1),
        b[*Çekli datçiklar* \ (limit switches)],
        width: 3cm,
        height: 1.4cm,
        fill: orange.lighten(85%),
        stroke: 0.8pt + orng,
      ),

      edge((1, 0), (2, 0), "-|>", label: small[elektr signal], label-sep: 12pt),
      edge((2, -1), (2, 0), "-|>", stroke: (paint: luma(90), thickness: 1pt, dash: "dashed")),
      edge((2, 0), (2, 1), "-|>", stroke: 1pt + accent, label: small[siqilgan havo], label-side: left, label-sep: 8pt),
      edge((2, 1), (1, 1), "-|>", stroke: 1pt + accent, label: small[mexanik kuç], label-sep: 12pt),
      edge((1, 1), (0, 1), "-|>", stroke: 1pt + orng, label: small[pozitsiya], label-sep: 12pt),
      edge(
        (0, 1),
        (0, 0),
        (1, 0),
        "-|>",
        stroke: 1pt + orng,
        label: small[aks aloqa],
        label-pos: 0.3,
        label-side: left,
      ),
    )
  },
  caption: [«Elektronika-NSTM-01» robotining pnevmo-elektr va aks aloqali boşqaruv strukturasi],
) <fig-ctrl>

= Matematik va kinematik modellaştiriş

== Denavit--Hartenberg (D-H) parametrlari

Manipulyatorning har bir böğiniga öng qöl koordinatalar sistemasi $\{i\}$ boğlanadi. Ikki qöşni koordinata sistemasi orasidagi transformatsiya matritsasi $T_i^(i-1)$ törtta D-H parametri orqali aniqlanadi:

- $a_i$ --- $Z_(i-1)$ va $Z_i$ öqlari orasidagi masofa ($X_i$ böylab);
- $alpha_i$ --- $Z_(i-1)$ va $Z_i$ öqlari orasidagi burçak ($X_i$ atrofida);
- $d_i$ --- $X_(i-1)$ va $X_i$ öqlari orasidagi masofa ($Z_(i-1)$ böylab);
- $theta_i$ --- $X_(i-1)$ va $X_i$ öqlari orasidagi burçak ($Z_(i-1)$ atrofida).

Bir sistemadan ikkinçisiga ötişning umumiy bir jinsli transformatsiya matritsasi (_homogeneous transformation matrix_):

$
  T_i^(i-1) = mat(
    delim: "[",
    cos theta_i, -sin theta_i cos alpha_i, sin theta_i sin alpha_i, a_i cos theta_i;
    sin theta_i, cos theta_i cos alpha_i, -cos theta_i sin alpha_i, a_i sin theta_i;
    0, sin alpha_i, cos alpha_i, d_i;
    0, 0, 0, 1;
  )
$

«Elektronika-NSTM-01» robotining RPP-R kinematik zanjiri uçun D-H parametrlari @tab-dh da keltirilgan ($*$ belgisi --- özgaruvçi böğin parametri).

#figure(
  {
    set text(size: 9.5pt)
    set par(justify: false)
    table(
      columns: (auto, auto, 1fr, 1fr, 1fr, 1fr),
      align: center + horizon,
      stroke: none,
      inset: (x: 4pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Böğin \ ($i$)*], [*Böğin turi*], [*$a_i$*], [*$alpha_i$*], [*$d_i$*], [*$theta_i$*]),
      table.hline(stroke: 0.5pt),
      [1], [Aylanma ($R_1$)], [$0$], [$0 degree$], [$d_1$], [$theta_1^*$],
      [2], [Ilgarilanma ($P_2$)], [$0$], [$-90 degree$], [$z_2^*$], [$-90 degree$],
      [3], [Ilgarilanma ($P_3$)], [$0$], [$+90 degree$], [$r_3^*$], [$0 degree$],
      [4], [Aylanma ($R_4$)], [$a_4$], [$0 degree$], [$0$], [$alpha_4^* + 90 degree$],
      table.hline(stroke: 1pt),
    )
  },
  caption: [«Elektronika-NSTM-01» manipulyatorining D-H parametrlari],
) <tab-dh>

== Töğri kinematika masalasi

Töğri kinematika masalasi --- böğin parametrlarining berilgan qiymatlari ($theta_1, z_2, r_3, alpha_4$) böyiça robot tutqiçining (TCP --- _Tool Center Point_) bazaviy koordinata sistemasidagi ($X_0, Y_0, Z_0$) holati va orientatsiyasini topiş. Töliq transformatsiya matritsasi alohida matritsalar köpaytmasiga teng:

$ T_4^0 = T_1^0 (theta_1) dot T_2^1 (z_2) dot T_3^2 (r_3) dot T_4^3 (alpha_4) $

Köpaytiriş natijasida tutqiç koordinatalari quyidagi analitik körinişga ega böladi:

$ P_x = r_3 cos theta_1 + a_4 cos(theta_1 + alpha_4) $

$ P_y = r_3 sin theta_1 + a_4 sin(theta_1 + alpha_4) $

$ P_z = d_1 + z_2 $

== Robotning işçi sohasi

Silindrik konfiguratsiyali «Elektronika-NSTM-01» robotining işçi sohasi içki va taşqi radiusli halqasimon silindr sektori şakliga ega (@fig-ws).

#figure(
  {
    set text(size: 8pt)
    cetz.canvas(length: 0.9cm, {
      import cetz.draw: *

      // Halqasimon sektor
      arc(
        (0, 0),
        start: -45deg,
        stop: 225deg,
        radius: 3.2,
        anchor: "origin",
        mode: "PIE",
        fill: accent.lighten(85%),
        stroke: 1pt + accent,
      )
      circle((0, 0), radius: 1.2, fill: white, stroke: 1pt + headingblue)
      circle((0, 0), radius: 0.1, fill: headingblue, stroke: none)
      content((0, -0.45), text(size: 7.5pt)[Asos ($O_0$)])

      // Radiuslar
      line((0, 0), (-0.6, 1.04), stroke: 0.9pt + headingblue, mark: (end: "straight"))
      content((-0.85, 0.5), text(size: 7.5pt)[$R_"min"$])
      line((0, 0), (2.77, 1.6), stroke: 1pt + accent, mark: (end: "straight"))
      content((1.75, 1.35), text(size: 7.5pt)[$R_"max"$])

      // Burilish sektori
      line((0, 0), (2.47, -2.47), stroke: (paint: secondary, thickness: 0.8pt, dash: "dashed"))
      line((0, 0), (-2.47, -2.47), stroke: (paint: secondary, thickness: 0.8pt, dash: "dashed"))
      arc((0, 0), start: -45deg, stop: 225deg, radius: 2.2, anchor: "origin", stroke: 1pt + secondary, mark: (
        start: "straight",
        end: "straight",
      ))
      content((0, 2.5), box(fill: white, inset: 2pt)[$Delta theta_1 = 270 degree$])

      content((0, -3.1), text(size: 7.5pt, weight: "bold")[Gorizontal işçi zona (yuqoridan köriniş)])
    })
  },
  caption: [«Elektronika-NSTM-01» robotining gorizontal tekislikdagi işçi sohasi],
) <fig-ws>

Işçi soha hajmi quyidagi formula orqali hisoblanadi:

$ V_"ws" = (Delta theta_1) / (360 degree) dot pi dot (R_"max"^2 - R_"min"^2) dot Delta z_2 $

= Tajriba maşğulotini bajariş tartibi

== 1-bosqiç: xavfsizlik texnikasi va stendni tayyorlaş

- Laboratoriya stendining yerga ulanganligini va elektr kabellarining butunligini tekşiring.
- Kompressorni yoqing va pnevmotizimda havo bosimi $0.4 dots 0.5 "MPa"$ oraliğida ekanligini qayd eting.
- Avariya töxtatiş tugmasi (_E-Stop_) işçi holatda ekanligiga işonç hosil qiling.

== 2-bosqiç: qölda boşqariş rejimida böğinlarni sinaş

- Boşqaruv pultini *Manual / Teach* rejimiga ötkazing.
- Har bir böğinni ($R_1, P_2, P_3, R_4, G_5$) navbatma-navbat harakatlantiruvçi tugmalarni bosing.
- Böğinlar çekka holatga yetganda mos çekli öçirgiçlar va svetodiod indikatorlarining yonişini kuzating.

== 3-bosqiç: boşqaruv dasturini yoziş va xotiraga kiritiş

Kiçik detalni A nuqtadan B nuqtaga köçiriş operatsiyasi uçun buyruqlar ketma-ketligi (sikli) dasturlanadi (@tab-prog).

#figure(
  {
    set text(size: 9pt)
    set par(justify: false)
    table(
      columns: (auto, 1fr, 1fr, auto),
      align: (center + horizon, left + horizon, left + horizon, center + horizon),
      stroke: none,
      inset: (x: 4pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Qadam*], [*Buyruq*], [*Ijroçi organ / datçik*], [*Kutiş \ vaqti $t$ [s]*]),
      table.hline(stroke: 0.5pt),
      [1], [Boşlanğiç holatga keliş (_Home_)], [Barça çekli öçirgiçlar faol], [1.0],
      [2], [A nuqtaga buriliş ($theta_1 = 45 degree$)], [$R_1$ pnevmoyuritmasi], [1.5],
      [3], [Pastga tuşiş ($z_2 = -150 "mm"$)], [$P_2$ pnevmotsilindri], [1.0],
      [4], [Detalni qisiş (_gripper close_)], [$G_5$ pnevmotutqiç], [0.8],
      [5], [Yuqoriga kötariliş ($z_2 = 0$)], [$P_2$ pnevmotsilindri], [1.0],
      [6], [B nuqtaga buriliş ($theta_1 = 135 degree$)], [$R_1$ pnevmoyuritmasi], [2.0],
      [7], [Detalni qöyib yuboriş (_gripper open_)], [$G_5$ pnevmotutqiç], [0.8],
      [8], [Boşlanğiç holatga qaytiş], [$R_1, P_2, P_3 -> "Home"$], [2.0],
      table.hline(stroke: 1pt),
    )
  },
  caption: [«Elektronika-NSTM-01» roboti uçun buyruqlar sikli dasturi],
) <tab-prog>

== 4-bosqiç: avtomatik rejimda işga tuşiriş va xatolikni ölçaş

- Boşqaruv pultini *Auto / Run* rejimiga ötkazing.
- Avtomatik sikllar sonini $N = 10$ ga sozlang va *Start* tugmasini bosing.
- Sikl davomiyligini ($T_"sikl"$) va tutqiçning B nuqtadagi absolyut pozitsiyalaş xatoligini ($Delta x, Delta y$) ştangensirkul yordamida ölçang.

= Amaliy masalalar va yeçimlar

== Masala 1: pnevmotutqiçning qisiş kuçini hisoblaş

*Şarti:* «Elektronika-NSTM-01» robotining pnevmotutqiçi porşen diametri $D = 30 "mm"$ bölgan ikki tomonlama pnevmotsilindr bilan harakatlantiriladi. Pnevmotizimdagi havo bosimi $P = 0.5 "MPa"$ ($5 dot 10^5 "Pa"$). Tutqiç mexanizmining riçag uzatiş koeffitsienti $k = 1.2$, mexanik foydali iş koeffitsienti $eta = 0.9$. Tutqiçning qisiş kuçini ($F_"grip"$) hisoblang.

*Yeçiş:*

- Pnevmotsilindr porşenining yuzasi:
  $ A = (pi D^2) / 4 = (3.14159 dot (0.03)^2) / 4 approx 7.0685 dot 10^(-4) "m"^2 $
- Porşen hosil qiladigan nazariy kuç:
  $ F_"cyl" = P dot A = 5 dot 10^5 "Pa" dot 7.0685 dot 10^(-4) "m"^2 approx 353.42 "N" $
- Riçag va FIK ni hisobga olgan holda real qisiş kuçi:
  $ F_"grip" = F_"cyl" dot k dot eta = 353.42 "N" dot 1.2 dot 0.9 approx 381.7 "N" $

*Javob:* pnevmotutqiçning real qisiş kuçi $F_"grip" approx 381.7 "N"$.

== Masala 2: manipulyator işçi sohasining hajmini hisoblaş

*Şarti:* «Elektronika-NSTM-01» robotining minimal radiusi $R_"min" = 200 "mm"$, konsolning maksimal uzayişidagi radiusi $R_"max" = 500 "mm"$, vertikal kötariliş masofasi $Delta z_2 = 300 "mm"$, asosning maksimal buriliş burçagi $Delta theta_1 = 270 degree$. Robot işçi sohasining hajmini ($V_"ws"$) kub metrda hisoblang.

*Yeçiş:*

- Ölçamlarni SI sistemasiga ötkazamiz: $R_"min" = 0.2 "m"$, $R_"max" = 0.5 "m"$, $Delta z_2 = 0.3 "m"$, $Delta theta_1 \/ 360 degree = 270 \/ 360 = 0.75$.
- Formula böyiça hisoblaymiz:
  $ V_"ws" = 0.75 dot pi dot (R_"max"^2 - R_"min"^2) dot Delta z_2 = 0.75 dot 3.14159 dot (0.5^2 - 0.2^2) dot 0.3 $
  $ V_"ws" = 2.3562 dot (0.25 - 0.04) dot 0.3 = 2.3562 dot 0.21 dot 0.3 approx 0.1484 "m"^3 $

*Javob:* robot işçi sohasining hajmi $V_"ws" approx 0.148 "m"^3$ ($148.4$ litr).

= Nazorat savollari

+ Avtomatlaştirişning qanday turlari (qatʼiy, moslaşuvçan) mavjud va «Elektronika-NSTM-01» qaysi biriga kiradi?
+ «Elektronika-NSTM-01» sanoat robotida neçta erkinlik darajasi (DoF) bor va har bir böğin qanday harakat bajaradi?
+ Grübler formulasi böyiça fazoviy va tekislikdagi mexanizmlarning erkinlik darajasi qanday aniqlanadi?
+ Pnevmatik yuritmalarning elektr va gidravlik yuritmalarga nisbatan afzalliklari va kamçiliklari nimada?
+ $5\/2$ pnevmotaqsimlagiç klapanining vazifasi va işlaş prinsipi nimadan iborat?
+ Denavit--Hartenberg (D-H) koordinata sistemasi va parametrlari nimani ifodalaydi?
+ Töğri va teskari kinematika masalalarining bir-biridan farqi nimada?
+ Robot tutqiçining pozitsiyalaş aniqligi (_accuracy_) va takrorlanuvçanligi (_repeatability_) tuşunçalari nimani bildiradi?
+ Işçi soha (_workspace envelope_) turlari va ularning geometrik şakllari qanday aniqlanadi?
+ Sanoat robotlarini dasturlaşda örgatiş pulti (_teach pendant_) va avtomatik sikllarning roli nimadan iborat?
