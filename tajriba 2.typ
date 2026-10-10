// ============================================================
//  Robotlar va Robototexnik Tizimlar — 2-tajriba mashgʻuloti
//  Kompilyatsiya: typst compile rrt_tajriba_mashgulot_2.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)
#let accent = rgb(0, 120, 130)
#let secondary = rgb(180, 50, 20)

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

// ---------------- Sarlavha ----------------
#align(center)[
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIY MASHGʻULOTI №2]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[
    Mavzu: «Elektronika-NSTM-01» sanoat robotining ishlash prinsipini oʻrganish
  ]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Ishning maqsadi

*Mashgʻulotning maqsadi:* oʻquv va sanoat ishlab chiqarishida keng qoʻllaniladigan «Elektronika-NSTM-01» sanoat roboti manipulyatorining tuzilishi, kinematik zanjiri, pnevmatik va elektr yuritmalari, datchiklar tizimi hamda dasturlanadigan boshqaruv blokining ishlash prinsiplarini oʻrganish.

*Oʻquv vazifalari:*

+ *Konstruktiv tuzilmani tahlil qilish:* «Elektronika-NSTM-01» robotining mexanik tugunlari, boʻgʻinlari va ishchi aʼzosi (tutqich --- _end-effector_) tuzilishini oʻrganish.
+ *Kinematik tahlil va DoF hisobi:* manipulyatorning kinematik sxemasini tuzish, erkinlik darajalari sonini (_degrees of freedom_ --- DoF) Grübler--Kutzbach formulasi boʻyicha hisoblash.
+ *Pnevmoyuritma elementlarini oʻrganish:* pnevmotsilindrlar, pnevmotaqsimlagichlar (_directional control valves_) hamda havo bosimini boshqaruvchi klapanlarning ish rejimlarini tahlil qilish.
+ *Boshqaruv va sensorika:* dasturlanadigan boshqaruv blokida siklik buyruqlar yaratish va chekli oʻchirgichlar (_limit switches_) orqali aks aloqani oʻrganish.
+ *Toʻgʻri kinematika masalasi:* robot tutqichining fazoviy koʻchishlarini koordinata sistemalari va transformatsiya matritsalari orqali ifodalash.

= Kerakli asbob-uskunalar va dasturiy taʼminot

- *Oʻquv-laboratoriya stendi:* «Elektronika-NSTM-01» sanoat roboti, dasturlanadigan boshqaruv pulti (_teach pendant_).
- *Pnevmatik jihozlar:* kompressor (ishchi havo bosimi $0.5 "MPa"$), havo tayyorlash bloki (FRL).
- *Nazorat-oʻlchov vositalari:* raqamli multimetr, pozitsiya datchiklari indikatsiya bloki, shtangensirkul.
- *Ishchi detallar toʻplami:* silindrik va toʻrtburchak shakldagi obyektlar.

= Nazariy maʼlumotlar

== Sanoat robotlarining avtomatlashtirishdagi roli

Zamonaviy moslashuvchan ishlab chiqarish tizimlarida (FMS --- _Flexible Manufacturing Systems_) sanoat robotlari inson omilini kamaytirish, yuqori takrorlanuvchanlik va xavfsizlikni taʼminlashda hal qiluvchi rol oʻynaydi. ISO 8373 standartiga koʻra, *sanoat roboti* --- bu koʻp maqsadli, avtomatik boshqariladigan, qayta dasturlanadigan va uch yoki undan ortiq oʻq boʻyicha harakatlana oladigan manipulyatsion qurilma.

== «Elektronika-NSTM-01» sanoat robotining umumiy tavsifi

«Elektronika-NSTM-01» --- kichik va oʻrta oʻlchamdagi detallarni (massasi $0.5 dots 1.0 "kg"$) shtamplash, yigʻish, saralash hamda dastgohlarga oʻrnatish va olish operatsiyalarini avtomatlashtirish uchun moʻljallangan modulli sanoat roboti. Manipulyatorning asosiy xususiyatlari:

- *Modullilik:* har bir harakat boʻgʻini pnevmatik yoki elektr modul shaklida mustaqil yigʻilgan.
- *Yuqori tezlik va ishonchlilik:* pnevmotsilindrlar yordamida tezkor ilgarilanma va aylanma harakatlar amalga oshiriladi.
- *Pozitsion boshqaruv:* har bir boʻgʻin harakati chekli oʻchirgichlar yoki optoelektron datchiklar yordamida chegaralanadi.

== Kinematik struktura va erkinlik darajalari

Manipulyator ochiq kinematik zanjirdan (_serial kinematic chain_) iborat boʻlib, ketma-ket ulangan boʻgʻinlar (_links_) va kinematik juftliklardan (_joints_) tashkil topgan:

- *Aylanma juftlik (revolute --- R):* bir oʻq atrofida nisbiy burilish harakatini taʼminlaydi (1 DoF).
- *Ilgarilanma juftlik (prismatic --- P):* bir oʻq boʻylab toʻgʻri chiziqli surilish harakatini taʼminlaydi (1 DoF).

Fazoviy mexanizmlar uchun erkinlik darajasi *Grübler--Kutzbach formulasi* orqali hisoblanadi:

$ "DoF" = m (N - 1 - J) + sum_(i=1)^J f_i $

bunda:

- $m = 6$ --- uch oʻlchamli fazodagi jismning erkinlik darajalari soni;
- $N$ --- mexanizmdagi jami boʻgʻinlar soni (qoʻzgʻalmas asos bilan birga);
- $J$ --- kinematik juftliklar soni;
- $f_i$ --- $i$-chi kinematik juftlikning erkinlik darajasi (R va P juftliklar uchun $f_i = 1$).

Ochiq kinematik zanjirli manipulyatorlarda barcha $J$ ta juftlik bir erkinlikli va $N = J + 1$ boʻlsa, formula soddalashadi:

$ "DoF" = sum_(i=1)^n f_i = n $

«Elektronika-NSTM-01» roboti 4 ta asosiy harakat boʻgʻiniga hamda 1 ta tutqich qisish mexanizmiga ega, yaʼni jami $4 + 1$ erkinlik darajasi mavjud.

= «Elektronika-NSTM-01» robotining kinematik sxemasi va tuzilishi

«Elektronika-NSTM-01» roboti silindrik koordinata sistemasida ishlaydi. Uning kinematik harakatlari quyidagilardan iborat (@fig-kin):

+ *Asos burilishi ($theta_1$):* manipulyator tanasining vertikal oʻq atrofidagi aylanma harakati ($R_1$ boʻgʻin).
+ *Vertikal koʻtarilish/tushish ($z_2$):* manipulyator yelkasining $Z$ oʻqi boʻylab ilgarilanma koʻchishi ($P_2$ boʻgʻin).
+ *Gorizontal uzayish ($r_3$):* qoʻlning gorizontal konsol boʻylab surilishi ($P_3$ boʻgʻin).
+ *Tutqich burilishi ($alpha_4$):* ishchi organning (tutqichning) oʻz oʻqi atrofida burilishi ($R_4$ boʻgʻin).
+ *Qisish harakati ($q_5$):* pnevmotutqich jagʻlarining yopilishi va ochilishi ($G_5$).

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
      content((0, 3.75), text(size: 7.5pt, fill: secondary)[$Z_0$ (vertikal oʻq)])

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
      content((2.65, 3.45), text(size: 7.5pt)[$r_3$ (uzayish)])

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
        *Boʻgʻinlar:* \
        1. Asos burilishi ($R_1$) \
        2. Vertikal surilish ($P_2$) \
        3. Gorizontal surilish ($P_3$) \
        4. Tutqich burilishi ($R_4$) \
        5. Pnevmotutqich ($G_5$)
      ]))
    })
  },
  caption: [«Elektronika-NSTM-01» sanoat robotining kinematik sxemasi va boʻgʻinlar harakati],
) <fig-kin>

= Pnevmatik yuritma va boshqaruv tizimi

== Pnevmoyuritma elementlari

«Elektronika-NSTM-01» robotining asosiy ilgarilanma va qisish harakatlari *pnevmoyuritmalar* yordamida amalga oshiriladi. Pnevmoyuritmaning asosiy afzalliklari:

- yuqori tezkorlik (porshen tezligi $1.0 dots 1.5 "m/s"$ gacha);
- konstruksiyaning soddaligi va arzonligi;
- ortiqcha yuklanishga (_overload_) chidamliligi;
- ishchi muhitning (siqilgan havoning) ekologik xavfsizligi.

Pnevmatik tizim quyidagi asosiy bloklardan tashkil topgan:

+ *Siqilgan havo manbai (kompressor):* ishchi bosim $P = 0.4 dots 0.6 "MPa"$ ($4 dots 6 "bar"$).
+ *Havo tayyorlash bloki (FRL):* filtrlash, bosimni rostlash va moylash moslamasi.
+ *Pnevmotaqsimlagichlar (directional control valves):* elektropnevmatik $5\/2$ yoki $3\/2$ yoʻlli zolotnikli klapanlar.
+ *Pnevmotsilindrlar:* ikki tomonlama taʼsir etuvchi (_double-acting_) pnevmotsilindrlar.

== Datchiklar va pozitsion aks aloqa

Manipulyator boʻgʻinlarining chekka nuqtalarga yetib borganligini qayd etish uchun *chekli oʻchirgichlar (limit switches)* yoki *optoelektron datchiklar* oʻrnatilgan. Datchiklardan kelgan signal boshqaruv blokiga uzatiladi va navbatdagi pnevmoklapanga buyruq beriladi (@fig-ctrl).

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

      node((1, 0), b[*Dasturlanadigan \ boshqaruv bloki* \ (PLC / mikrokontroller)], width: 3.3cm, height: 1.4cm),
      node(
        (2, 0),
        b[*Pnevmotaqsimlagichlar* \ ($5\/2$ elektromagnit \ klapanlar)],
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
      node((1, 1), b[*Manipulyator \ va tutqich* \ (mexanik tuzilma)], width: 3.3cm, height: 1.4cm),
      node(
        (0, 1),
        b[*Chekli datchiklar* \ (limit switches)],
        width: 3cm,
        height: 1.4cm,
        fill: orange.lighten(85%),
        stroke: 0.8pt + orng,
      ),

      edge((1, 0), (2, 0), "-|>", label: small[elektr signal], label-sep: 12pt),
      edge((2, -1), (2, 0), "-|>", stroke: (paint: luma(90), thickness: 1pt, dash: "dashed")),
      edge((2, 0), (2, 1), "-|>", stroke: 1pt + accent, label: small[siqilgan havo], label-side: left, label-sep: 8pt),
      edge((2, 1), (1, 1), "-|>", stroke: 1pt + accent, label: small[mexanik kuch], label-sep: 12pt),
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
  caption: [«Elektronika-NSTM-01» robotining pnevmo-elektr va aks aloqali boshqaruv strukturasi],
) <fig-ctrl>

= Matematik va kinematik modellashtirish

== Denavit--Hartenberg (D-H) parametrlari

Manipulyatorning har bir boʻgʻiniga oʻng qoʻl koordinatalar sistemasi $\{i\}$ bogʻlanadi. Ikki qoʻshni koordinata sistemasi orasidagi transformatsiya matritsasi $T_i^(i-1)$ toʻrtta D-H parametri orqali aniqlanadi:

- $a_i$ --- $Z_(i-1)$ va $Z_i$ oʻqlari orasidagi masofa ($X_i$ boʻylab);
- $alpha_i$ --- $Z_(i-1)$ va $Z_i$ oʻqlari orasidagi burchak ($X_i$ atrofida);
- $d_i$ --- $X_(i-1)$ va $X_i$ oʻqlari orasidagi masofa ($Z_(i-1)$ boʻylab);
- $theta_i$ --- $X_(i-1)$ va $X_i$ oʻqlari orasidagi burchak ($Z_(i-1)$ atrofida).

Bir sistemadan ikkinchisiga oʻtishning umumiy bir jinsli transformatsiya matritsasi (_homogeneous transformation matrix_):

$
  T_i^(i-1) = mat(
    delim: "[",
    cos theta_i, -sin theta_i cos alpha_i, sin theta_i sin alpha_i, a_i cos theta_i;
    sin theta_i, cos theta_i cos alpha_i, -cos theta_i sin alpha_i, a_i sin theta_i;
    0, sin alpha_i, cos alpha_i, d_i;
    0, 0, 0, 1;
  )
$

«Elektronika-NSTM-01» robotining RPP-R kinematik zanjiri uchun D-H parametrlari @tab-dh da keltirilgan ($*$ belgisi --- oʻzgaruvchi boʻgʻin parametri).

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
      table.header([*Boʻgʻin \ ($i$)*], [*Boʻgʻin turi*], [*$a_i$*], [*$alpha_i$*], [*$d_i$*], [*$theta_i$*]),
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

== Toʻgʻri kinematika masalasi

Toʻgʻri kinematika masalasi --- boʻgʻin parametrlarining berilgan qiymatlari ($theta_1, z_2, r_3, alpha_4$) boʻyicha robot tutqichining (TCP --- _Tool Center Point_) bazaviy koordinata sistemasidagi ($X_0, Y_0, Z_0$) holati va orientatsiyasini topish. Toʻliq transformatsiya matritsasi alohida matritsalar koʻpaytmasiga teng:

$ T_4^0 = T_1^0 (theta_1) dot T_2^1 (z_2) dot T_3^2 (r_3) dot T_4^3 (alpha_4) $

Koʻpaytirish natijasida tutqich koordinatalari quyidagi analitik koʻrinishga ega boʻladi:

$ P_x = r_3 cos theta_1 + a_4 cos(theta_1 + alpha_4) $

$ P_y = r_3 sin theta_1 + a_4 sin(theta_1 + alpha_4) $

$ P_z = d_1 + z_2 $

== Robotning ishchi sohasi

Silindrik konfiguratsiyali «Elektronika-NSTM-01» robotining ishchi sohasi ichki va tashqi radiusli halqasimon silindr sektori shakliga ega (@fig-ws).

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

      content((0, -3.1), text(size: 7.5pt, weight: "bold")[Gorizontal ishchi zona (yuqoridan koʻrinish)])
    })
  },
  caption: [«Elektronika-NSTM-01» robotining gorizontal tekislikdagi ishchi sohasi],
) <fig-ws>

Ishchi soha hajmi quyidagi formula orqali hisoblanadi:

$ V_"ws" = (Delta theta_1) / (360 degree) dot pi dot (R_"max"^2 - R_"min"^2) dot Delta z_2 $

= Tajriba mashgʻulotini bajarish tartibi

== 1-bosqich: xavfsizlik texnikasi va stendni tayyorlash

- Laboratoriya stendining yerga ulanganligini va elektr kabellarining butunligini tekshiring.
- Kompressorni yoqing va pnevmotizimda havo bosimi $0.4 dots 0.5 "MPa"$ oraligʻida ekanligini qayd eting.
- Avariya toʻxtatish tugmasi (_E-Stop_) ishchi holatda ekanligiga ishonch hosil qiling.

== 2-bosqich: qoʻlda boshqarish rejimida boʻgʻinlarni sinash

- Boshqaruv pultini *Manual / Teach* rejimiga oʻtkazing.
- Har bir boʻgʻinni ($R_1, P_2, P_3, R_4, G_5$) navbatma-navbat harakatlantiruvchi tugmalarni bosing.
- Boʻgʻinlar chekka holatga yetganda mos chekli oʻchirgichlar va svetodiod indikatorlarining yonishini kuzating.

== 3-bosqich: boshqaruv dasturini yozish va xotiraga kiritish

Kichik detalni A nuqtadan B nuqtaga koʻchirish operatsiyasi uchun buyruqlar ketma-ketligi (sikli) dasturlanadi (@tab-prog).

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
      table.header([*Qadam*], [*Buyruq*], [*Ijrochi organ / datchik*], [*Kutish \ vaqti $t$ [s]*]),
      table.hline(stroke: 0.5pt),
      [1], [Boshlangʻich holatga kelish (_Home_)], [Barcha chekli oʻchirgichlar faol], [1.0],
      [2], [A nuqtaga burilish ($theta_1 = 45 degree$)], [$R_1$ pnevmoyuritmasi], [1.5],
      [3], [Pastga tushish ($z_2 = -150 "mm"$)], [$P_2$ pnevmotsilindri], [1.0],
      [4], [Detalni qisish (_gripper close_)], [$G_5$ pnevmotutqich], [0.8],
      [5], [Yuqoriga koʻtarilish ($z_2 = 0$)], [$P_2$ pnevmotsilindri], [1.0],
      [6], [B nuqtaga burilish ($theta_1 = 135 degree$)], [$R_1$ pnevmoyuritmasi], [2.0],
      [7], [Detalni qoʻyib yuborish (_gripper open_)], [$G_5$ pnevmotutqich], [0.8],
      [8], [Boshlangʻich holatga qaytish], [$R_1, P_2, P_3 -> "Home"$], [2.0],
      table.hline(stroke: 1pt),
    )
  },
  caption: [«Elektronika-NSTM-01» roboti uchun buyruqlar sikli dasturi],
) <tab-prog>

== 4-bosqich: avtomatik rejimda ishga tushirish va xatolikni oʻlchash

- Boshqaruv pultini *Auto / Run* rejimiga oʻtkazing.
- Avtomatik sikllar sonini $N = 10$ ga sozlang va *Start* tugmasini bosing.
- Sikl davomiyligini ($T_"sikl"$) va tutqichning B nuqtadagi absolyut pozitsiyalash xatoligini ($Delta x, Delta y$) shtangensirkul yordamida oʻlchang.

= Amaliy masalalar va yechimlar

== Masala 1: pnevmotutqichning qisish kuchini hisoblash

*Sharti:* «Elektronika-NSTM-01» robotining pnevmotutqichi porshen diametri $D = 30 "mm"$ boʻlgan ikki tomonlama pnevmotsilindr bilan harakatlantiriladi. Pnevmotizimdagi havo bosimi $P = 0.5 "MPa"$ ($5 dot 10^5 "Pa"$). Tutqich mexanizmining richag uzatish koeffitsienti $k = 1.2$, mexanik foydali ish koeffitsienti $eta = 0.9$. Tutqichning qisish kuchini ($F_"grip"$) hisoblang.

*Yechish:*

- Pnevmotsilindr porshenining yuzasi:
  $ A = (pi D^2) / 4 = (3.14159 dot (0.03)^2) / 4 approx 7.0685 dot 10^(-4) "m"^2 $
- Porshen hosil qiladigan nazariy kuch:
  $ F_"cyl" = P dot A = 5 dot 10^5 "Pa" dot 7.0685 dot 10^(-4) "m"^2 approx 353.42 "N" $
- Richag va FIK ni hisobga olgan holda real qisish kuchi:
  $ F_"grip" = F_"cyl" dot k dot eta = 353.42 "N" dot 1.2 dot 0.9 approx 381.7 "N" $

*Javob:* pnevmotutqichning real qisish kuchi $F_"grip" approx 381.7 "N"$.

== Masala 2: manipulyator ishchi sohasining hajmini hisoblash

*Sharti:* «Elektronika-NSTM-01» robotining minimal radiusi $R_"min" = 200 "mm"$, konsolning maksimal uzayishidagi radiusi $R_"max" = 500 "mm"$, vertikal koʻtarilish masofasi $Delta z_2 = 300 "mm"$, asosning maksimal burilish burchagi $Delta theta_1 = 270 degree$. Robot ishchi sohasining hajmini ($V_"ws"$) kub metrda hisoblang.

*Yechish:*

- Oʻlchamlarni SI sistemasiga oʻtkazamiz: $R_"min" = 0.2 "m"$, $R_"max" = 0.5 "m"$, $Delta z_2 = 0.3 "m"$, $Delta theta_1 \/ 360 degree = 270 \/ 360 = 0.75$.
- Formula boʻyicha hisoblaymiz:
  $ V_"ws" = 0.75 dot pi dot (R_"max"^2 - R_"min"^2) dot Delta z_2 = 0.75 dot 3.14159 dot (0.5^2 - 0.2^2) dot 0.3 $
  $ V_"ws" = 2.3562 dot (0.25 - 0.04) dot 0.3 = 2.3562 dot 0.21 dot 0.3 approx 0.1484 "m"^3 $

*Javob:* robot ishchi sohasining hajmi $V_"ws" approx 0.148 "m"^3$ ($148.4$ litr).

= Nazorat savollari

+ Avtomatlashtirishning qanday turlari (qatʼiy, moslashuvchan) mavjud va «Elektronika-NSTM-01» qaysi biriga kiradi?
+ «Elektronika-NSTM-01» sanoat robotida nechta erkinlik darajasi (DoF) bor va har bir boʻgʻin qanday harakat bajaradi?
+ Grübler formulasi boʻyicha fazoviy va tekislikdagi mexanizmlarning erkinlik darajasi qanday aniqlanadi?
+ Pnevmatik yuritmalarning elektr va gidravlik yuritmalarga nisbatan afzalliklari va kamchiliklari nimada?
+ $5\/2$ pnevmotaqsimlagich klapanining vazifasi va ishlash prinsipi nimadan iborat?
+ Denavit--Hartenberg (D-H) koordinata sistemasi va parametrlari nimani ifodalaydi?
+ Toʻgʻri va teskari kinematika masalalarining bir-biridan farqi nimada?
+ Robot tutqichining pozitsiyalash aniqligi (_accuracy_) va takrorlanuvchanligi (_repeatability_) tushunchalari nimani bildiradi?
+ Ishchi soha (_workspace envelope_) turlari va ularning geometrik shakllari qanday aniqlanadi?
+ Sanoat robotlarini dasturlashda oʻrgatish pulti (_teach pendant_) va avtomatik sikllarning roli nimadan iborat?
