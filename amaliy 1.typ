// ============================================================
//  Robotlar va robototexnik tizimlar — 1-amaliy mashgʻulot (Avtomatlashtirishda robotlarning roli) — Typst versiyasi
//  Kompilyatsiya: typst compile rrti_amaliy_mashgulot_1_robotlar_roli.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "Avtomatlaştirişda robotlarning roli")
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)
// ===== HOSHIYA =====
#let info = json("fan.json")
#let raqam = 1  // amaliyot raqami
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
#let pblue = rgb(24, 76, 120)
#let sblue = rgb(41, 128, 185)
#let accent = rgb(211, 84, 0)

// ---------------- Sarlavha ----------------
#align(center)[
  #set par(justify: false)
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №1]
  #v(0.4cm)
  #text(
    size: 14pt,
    weight: "bold",
  )[Mavzu: Avtomatlaştirişda robotlarning roli. Robotlar haqida umumiy tuşunçalar va taʼriflar]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Işning maqsadi

*Maşğulotning maqsadi:* talabalarda avtomatlaştirilgan işlab çiqariş tizimlarida sanoat va xizmat körsatuvçi robotlarning iqtisodiy-texnik rolini baholaş, xalqaro ISO 8373 hamda RIA standartlari asosida robototexnik tizimlar parametrlarini analitik hisoblaş, fazoviy almaştirişlar hamda datçiklar noaniqligi şaroitida holatni baholaş böyiça amaliy könikmalarni şakllantiriş.

*Öquv vazifalari:*

+ Qatʼiy (_fixed_) va moslaşuvçan (_flexible_) avtomatlaştiriş texnologiyalarining iqtisodiy samaradorligi hamda özini qoplaş muddatini ($T_"payback"$) hisoblaşni örganiş.
+ ISO 8373 va RIA (_Robot Industries Association_) standartlari böyiça robotlarni turlarga ajratiş va ularning funksional komponentlarini analitik tahlil qiliş.
+ Asosiy va işçi koordinata sistemalari örtasidagi transformatsiya matritsalarini ($T_b^s$) tuziş hamda TCP (_Tool Center Point_) holatini aniqlaş.
+ Stoxastik muhitda robot holatini Bayes filtri orqali ehtimollik asosida yangilaş ($"bel"(x_t)$) böyiça amaliy masalalarni yeçiş.

= Kerakli jihozlar va dasturiy taʼminot

- *Hisoblaş vositalari:* muhandislik kalkulyatori, hisoblaş jadvallari.
- *Dasturiy muhit:* MATLAB, Python (NumPy).

= Nazariy rezyume va metodik körsatmalar

Sanoatni avtomatlaştiriş jarayonida texnologik uskunalar va avtomatlaştiriş turlari uçta asosiy toifaga bölinadi (@fig-auto):

- *Qatʼiy avtomatlaştiriş (_fixed automation_):* maxsus möljallangan agregat stanoklar va ketma-ket avtomat liniyalar. Işlab çiqariş hajmi juda yuqori ($Q > 10^5$ dona/yil), ammo mahsulot nomenklaturasi özgarmas.
- *Dasturlanadigan avtomatlaştiriş (_programmed automation_):* sonli boşqariladigan (NC/CNC) stanoklar. Partiya özgarganda dasturni qayta yuklaş va mexanik sozlaş talab etiladi.
- *Moslaşuvçan avtomatlaştiriş (_flexible automation_ / FMS):* sanoat robotlari, AGV (_Automated Guided Vehicles_) va moslaşuvçan işlab çiqariş modullari. Işlab çiqariş jarayonini töxtatmasdan mahsulot turini özgartiriş imkonini beradi.

#figure(
  cetz.canvas(length: 1.3cm, {
    import cetz.draw: *
    set-style(content: (padding: 3pt))
    let lbl(t1, t2) = align(center, text(size: 8.5pt)[*#t1* \ #t2])

    // Oʻqlar
    line((0, 0), (10, 0), stroke: 1.2pt, mark: (end: ">", fill: black))
    line((0, 0), (0, 6), stroke: 1.2pt, mark: (end: ">", fill: black))
    content((10, -0.1), text(size: 9pt)[*Işlab çiqariş hajmi ($Q$, dona/yil)*], anchor: "north-east")
    content((0, 6.05), align(center, text(size: 9pt)[*Mahsulot xilma-xilligi* \ *nomenklatura ($P$)*]), anchor: "south")

    // Yordamchi chiziqlar
    let dsh = (paint: luma(160), dash: "dashed")
    line((2.5, 0), (2.5, 1.5), stroke: dsh)
    line((6.5, 0), (6.5, 1.5), stroke: dsh)
    line((0, 1.5), (2.5, 1.5), stroke: dsh)
    line((0, 4.0), (2.5, 4.0), stroke: dsh)

    // Sohalar
    rect((0.5, 3.5), (3.5, 5.5), fill: pblue.lighten(85%), stroke: 1.2pt + pblue)
    rect((2.5, 1.5), (6.5, 4.0), fill: sblue.lighten(80%).transparentize(15%), stroke: 1.2pt + sblue)
    rect((5.5, 0.2), (9.2, 2.0), fill: accent.lighten(85%).transparentize(15%), stroke: 1.2pt + accent)
    content((2, 4.75), lbl[Yakkalik / kiçik \ partiyali][CNC stanoklar, \ qöl mehnati])
    content((4.5, 2.75), lbl[Moslaşuvçan (FMS)][*Sanoat robotlari*])
    content((7.35, 1.1), lbl[Qatʼiy (fixed)][Avtomat liniyalar])
  }),
  caption: [Avtomatlaştiriş turlarining mahsulot nomenklaturasi va işlab çiqariş hajmi böyiça taqsimlanişi],
) <fig-auto>

== Robototexnika taʼriflari va tizim arxitekturasi

*ISO 8373 standarti böyiça taʼrif:* sanoat roboti --- bu köp maqsadli, qayta dasturlanadigan, uç yoki undan ortiq erkinlik darajasiga ega bölgan, avtomatlaştirişda harakatsiz yoki harakatlanuvçi tarzda qöllaniladigan avtomatik boşqariluvçi manipulyatordir.

Sanoat roboti quyidagi 4 ta asosiy kiçik tizimning (_subsystems_) özaro integratsiyasidan taşkil topadi (@fig-arch):

+ *Mexanik manipulyator (kinematik zanjir):* böğinlar (_links_) va kinematik juftliklar (_joints_) töplami.
+ *Ijroçi yuritmalar (_actuators_):* elektr (servodvigatellar), pnevmatik yoki gidravlik dvigatellar.
+ *Sensor va axborot tizimi (_sensors_):* içki (enkoderlar, taxogeneratorlar) va taşqi (videokamera, kuç-moment datçiklari, ultratovuş) datçiklar.
+ *Boşqaruv va hisoblaş bloki (_controller_):* traektoriyani rejalaştiriş, teskari aloqani qayta işlaş hamda datçiklar şovqinini Bayes filtri orqali filtrlaş algoritmlari.

#figure(
  {
    set text(size: 8.5pt)
    set par(justify: false)
    let b(body) = align(center, body)
    let small(body) = text(size: 7.5pt, body)
    diagram(
      node-stroke: 0.8pt + headingblue,
      node-fill: blue.lighten(93%),
      node-corner-radius: 3pt,
      node-inset: 5pt,
      spacing: (18mm, 12mm),
      edge-stroke: 1pt + headingblue,

      node(
        (1, -0.75),
        text(size: 8.5pt, weight: "bold", fill: red.darken(30%))[Kibernetik tizim (yopiq zanjir)],
        stroke: none,
        fill: none,
        name: <ttl>,
      ),
      node((0, 0), b[*Boşqaruv bloki* \ traektoriya va algoritm], width: 3.0cm, height: 1.3cm, name: <ctrl>),
      node(
        (1, 0),
        b[*Ijroçi yuritmalar* \ servomotorlar, pnevmatika],
        width: 3.1cm,
        height: 1.3cm,
        fill: sblue.lighten(88%),
        name: <act>,
      ),
      node(
        (2, 0),
        b[*Manipulyator* \ mexanik böğinlar va TCP],
        width: 3.1cm,
        height: 1.3cm,
        fill: accent.lighten(88%),
        stroke: 0.8pt + accent,
        name: <rob>,
      ),
      node(
        (1, 1),
        b[*Datçiklar va axborot* \ enkoderlar, kamera, kuç],
        width: 3.8cm,
        height: 1.3cm,
        fill: luma(235),
        stroke: 0.8pt + luma(80),
        name: <sen>,
      ),
      node(
        enclose: (<ttl>, <ctrl>, <act>, <rob>, <sen>),
        stroke: (paint: red.darken(20%), dash: "dashed"),
        fill: none,
        inset: 12pt,
      ),

      edge(<ctrl>, <act>, "-|>", label: small[$u_t$ (boşqaruv)]),
      edge(<act>, <rob>, "-|>", label: small[$F$, $M$ (moment)]),
      edge(
        <rob>,
        (2, 1),
        <sen>,
        "-|>",
        stroke: 1pt + luma(60),
        label: small[Holat özgarişi],
        label-pos: 0.3,
        label-side: left,
      ),
      edge(
        <sen>,
        (0, 1),
        <ctrl>,
        "-|>",
        stroke: 1pt + accent,
        label: small[$z_t$ (ölçov)],
        label-pos: 0.7,
        label-side: left,
      ),
    )
  },
  caption: [Robototexnik tizimning axborot-boşqaruv va teskari aloqa blok-sxemasi],
  placement: auto,
) <fig-arch>

== Fazoviy koordinata almaştirişlari va Bayes filtri

Robot manipulyatori böğinlari va obyektlarining uç ölçamli fazodagi holati ($P$) va orientatsiyasi ($R$) $4 times 4$ ölçamli bir jinsli transformatsiya matritsasi (_homogeneous transformation matrix_) orqali ifodalanadi:

$
  T_b^s = mat(R_(3 times 3), P_(3 times 1); 0_(1 times 3), 1)
  = mat(
    r_11, r_12, r_13, p_x;
    r_21, r_22, r_23, p_y;
    r_31, r_32, r_33, p_z;
    0, 0, 0, 1
  )
$ <eq-T>

Stoxastik muhitda datçiklardagi şovqin va harakatdagi noaniqliklarni hisobga olgan holda robotning joriy holatiga bölgan işonç taqsimoti (_belief distribution_) rekursiv *Bayes filtri* tenglamasi orqali hisoblanadi:

$ "bel"(x_t) = eta dot p(z_t mid(|) x_t) integral p(x_t mid(|) u_t, x_(t-1)) dot "bel"(x_(t-1)) dif x_(t-1) $ <eq-bayes>

bunda $x_t$ --- $t$ vaqtdagi robot holati (pozitsiya / orientatsiya), $u_t$ --- $t$ vaqtdagi boşqaruv taʼsiri (_control action_), $z_t$ --- $t$ vaqtdagi datçik ölçov körsatkiçlari (_sensor measurement_), $p(z_t mid(|) x_t)$ --- datçik ölçov modeli (_measurement model_), $p(x_t mid(|) u_t, x_(t-1))$ --- robot harakat dinamikasi modeli (_motion model_), $eta$ --- normalaştiruvçi koeffitsient ($eta = 1 \/ p(z_t mid(|) z_(1:t-1))$).

= Namunaviy masalalar va ularning töliq analitik yeçimlari

== Masala 1: avtomatlaştiriş samaradorligi va breakeven tahlili

*Masala şarti:* sanoat korxonasida detallarga işlov beriş operatsiyasini bajariş uçun ikkita variant körib çiqilmoqda:

- *A varianti (qatʼiy avtomatlaştiriş):* boşlanğiç kapital xarajat $C_"cap,A" = \$ 250 thin 000$, bir dona mahsulot uçun ekspluatatsiya xarajati $c_"var,A" = \$ 1.20$/dona.
- *B varianti (sanoat roboti bilan moslaşuvçan avtomatlaştiriş):* boşlanğiç kapital xarajat $C_"cap,B" = \$ 110 thin 000$, bir dona mahsulot uçun ekspluatatsiya xarajati $c_"var,B" = \$ 2.80$/dona.

#set enum(numbering: "a)")
+ Yillik işlab çiqariş hajmining qanday kritik qiymatida ($Q_"crit"$) ikkala variant xarajatlari tenglaşadi (_breakeven point_)?
+ Agar yillik reja $Q = 120 thin 000$ dona bölsa, qaysi avtomatlaştiriş varianti iqtisodiy jihatdan afzalroq?
+ A variantiga qöşimça kiritilgan kapital qöyilmaning (B variantiga nisbatan) özini oqlaş muddatini ($T_"payback"$) hisoblang.
#set enum(numbering: "1.")

*Yeçiş va formulalar:*

$ "TC"_A (Q) = C_"cap,A" + c_"var,A" dot Q, quad quad "TC"_B (Q) = C_"cap,B" + c_"var,B" dot Q $

*Hisoblaş bosqiçlari:*

- a) Ikkala xarajatni tenglaştiramiz ($"TC"_A (Q_"crit") = "TC"_B (Q_"crit")$):
  $ C_"cap,A" + c_"var,A" dot Q_"crit" = C_"cap,B" + c_"var,B" dot Q_"crit" $
  $
    Q_"crit" = (C_"cap,A" - C_"cap,B") / (c_"var,B" - c_"var,A") = (250 thin 000 - 110 thin 000) / (2.80 - 1.20) \
    = (140 thin 000) / 1.60 = 87 thin 500 "dona/yil"
  $
- b) Yillik reja $Q = 120 thin 000$ dona bölganda umumiy xarajatlar:
  $ "TC"_A (120 thin 000) = 250 thin 000 + 1.20 times 120 thin 000 = 250 thin 000 + 144 thin 000 = \$ 394 thin 000 $
  $ "TC"_B (120 thin 000) = 110 thin 000 + 2.80 times 120 thin 000 = 110 thin 000 + 336 thin 000 = \$ 446 thin 000 $
  $Q = 120 thin 000 > 87 thin 500$ bölgani uçun *A varianti (qatʼiy avtomatlaştiriş)* yiliga $\$ 52 thin 000$ tejamkorlik beradi va afzalroq.
- c) A variantiga qöşimça kapital qöyilma $Delta C = \$ 140 thin 000$, yillik ekspluatatsiya tejami esa $Delta c dot Q = 1.60 times 120 thin 000 = \$ 192 thin 000$/yil. Özini oqlaş muddati:
  $ T_"payback" = (Delta C) / (Delta c dot Q) = (140 thin 000) / (192 thin 000) approx 0.73 "yil" approx 8.75 "oy" $
  Demak, B varianti (robot) faqat moslaşuvçanlik zarur bölganda, yaʼni mahsulot nomenklaturasi tez-tez özgarganda yoki $Q < Q_"crit"$ bölganda özini oqlaydi.

== Masala 2: koordinata almaştirişlari va robot tutqiçi (TCP) hisobi

*Masala şarti:* sanoat roboti asosiy köçirişni tugatgandan söng, uning bazaviy ${s}$ koordinata sistemasiga nisbatan tutqiç (TCP) freymi ${t}$ quyidagiça joylaşgan:

- tutqiç freymi ${t}$ bazaviy freym ${s}$ ning $Z$-öqi atrofida $theta = 90 degree$ ga burilgan;
- robot bazasidan TCP markazigaça bölgan siljiş vektori $P = [450, 200, 350]^T "mm"$.

#set enum(numbering: "a)")
+ $Z$-öqi atrofidagi buriliş matritsasi $R_z (90 degree)$ ni tuzing.
+ $4 times 4$ bir jinsli transformatsiya matritsasi $T_t^s$ ni hisoblang.
+ Detal ${t}$ freymida $P_"detail"^({t}) = [10, 0, 50, 1]^T "mm"$ koordinataga ega bölsa, uşbu detalning bazaviy ${s}$ sistemadagi $P_"detail"^({s})$ koordinatasini toping.
#set enum(numbering: "1.")

*Yeçiş va formulalar:*

$ R_z (theta) = mat(cos theta, -sin theta, 0; sin theta, cos theta, 0; 0, 0, 1) $

*Hisoblaş bosqiçlari:*

- a) $theta = 90 degree$ bölganda ($cos 90 degree = 0$, $sin 90 degree = 1$):
  $ R_z (90 degree) = mat(0, -1, 0; 1, 0, 0; 0, 0, 1) $
- b) Bir jinsli transformatsiya matritsasi:
  $ T_t^s = mat(0, -1, 0, 450; 1, 0, 0, 200; 0, 0, 1, 350; 0, 0, 0, 1) $
- c) Detalning bazaviy sistemadagi koordinatasi:
  $
    P_"detail"^({s}) = T_t^s dot P_"detail"^({t}) = mat(0, -1, 0, 450; 1, 0, 0, 200; 0, 0, 1, 350; 0, 0, 0, 1) dot vec(10, 0, 50, 1)
  $
  Matritsalarni köpaytiramiz:
  $
    P_x^({s}) & = 0 dot 10 + (-1) dot 0 + 0 dot 50 + 450 dot 1 = 450 "mm" \
    P_y^({s}) & = 1 dot 10 + 0 dot 0 + 0 dot 50 + 200 dot 1 = 210 "mm" \
    P_z^({s}) & = 0 dot 10 + 0 dot 0 + 1 dot 50 + 350 dot 1 = 400 "mm"
  $

*Natija:* detalning bazaviy koordinatalar sistemasidagi örni $P_"detail"^({s}) = [450, 210, 400]^T "mm"$.

== Masala 3: stoxastik Bayes filtri orqali robot holatini baholaş

*Masala şarti:* avtonom mobil sanoat roboti (AGV) sex içida harakatlanmoqda. Dastlabki vaqt momentida robotning $x_1$ pozitsiyada bölişining apriori ehtimolligi $"bel"(x_1) = 0.60$, $x_2$ pozitsiyada bölişiniki esa $"bel"(x_2) = 0.40$. Robot ultratovuşli masofa ölçagiç orqali tösiqqaça bölgan masofani ölçadi ($z$). Datçikning ölçov modellari (_likelihood_) quyidagiça berilgan:

- $p(z mid(|) x_1) = 0.80$ --- robot $x_1$ da bölganda uşbu körsatkiçni beriş ehtimoli;
- $p(z mid(|) x_2) = 0.20$ --- robot $x_2$ da bölganda uşbu körsatkiçni beriş ehtimoli.

Datçik körsatkiçidan söng Bayes qoidasi orqali aposterior işonç taqsimotlarini ($"bel"'(x_1)$ va $"bel"'(x_2)$) hisoblang.

*Hisoblaş bosqiçlari:*

- Har bir holat uçun normalaştirilmagan ehtimolliklar:
  $ overline("bel")(x_1) = p(z mid(|) x_1) dot "bel"(x_1) = 0.80 times 0.60 = 0.48 $
  $ overline("bel")(x_2) = p(z mid(|) x_2) dot "bel"(x_2) = 0.20 times 0.40 = 0.08 $
- Normalaştiruvçi koeffitsient $eta$ (töliq ölçov ehtimoli $p(z)$):
  $ p(z) = overline("bel")(x_1) + overline("bel")(x_2) = 0.48 + 0.08 = 0.56 $
  $ eta = 1 / p(z) = 1 / 0.56 approx 1.7857 $
- Yangi (aposterior) işonç taqsimotlari:
  $ "bel"'(x_1) = eta dot overline("bel")(x_1) = 0.48 / 0.56 = 6 / 7 approx 0.8571 thick (85.71 %) $
  $ "bel"'(x_2) = eta dot overline("bel")(x_2) = 0.08 / 0.56 = 1 / 7 approx 0.1429 thick (14.29 %) $

*Natija:* yangi datçik axboroti olingandan söng robotning $x_1$ nuqtada joylaşganligiga bölgan işonç ehtimoli $60 %$ dan $85.71 %$ gaça oşdi.

= Talabalar uçun individual amaliy topşiriqlar

Har bir talaba özining tartib raqamiga mos keluvçi variant körsatkiçlari (@tab-variants) böyiça quyidagi hisoblaşlarni bajarişi lozim:

+ Qatʼiy va moslaşuvçan avtomatlaştiriş breakeven nuqtasi ($Q_"crit"$) hamda berilgan $Q_"plan"$ hajmdagi tejamkorlikni aniqlaş.
+ Berilgan siljiş va $Z$-öqi atrofidagi buriliş burçagi $theta$ böyiça $T_t^s$ matritsasini tuziş hamda berilgan nuqta koordinatasini hisoblaş.
+ Bayes filtri böyiça aposterior ehtimollik $"bel"'(x_1)$ ni topiş.

#figure(
  {
    set text(size: 9pt)
    set par(justify: false)
    table(
      columns: 9,
      align: center + horizon,
      stroke: none,
      inset: (x: 3.5pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header(
        [*Var.*],
        [*$C_"cap,A"$ \ [\$]*],
        [*$c_"var,A"$ \ [\$]*],
        [*$C_"cap,B"$ \ [\$]*],
        [*$c_"var,B"$ \ [\$]*],
        [*$theta$ \ [°]*],
        [*Siljiş $P$ \ [mm]*],
        [*$"bel"(x_1)$*],
        [*$p(z mid(|) x_1)$*],
      ),
      table.hline(stroke: 0.5pt),
      [*1*], [200~000], [1.50], [90~000], [3.00], [90], [[300, 150, 200]], [0.70], [0.85],
      [*2*], [220~000], [1.20], [100~000], [2.80], [45], [[400, 200, 300]], [0.65], [0.90],
      [*3*], [180~000], [1.80], [80~000], [3.20], [180], [[250, 100, 150]], [0.55], [0.75],
      [*4*], [250~000], [1.00], [120~000], [2.50], [−90], [[500, 300, 400]], [0.80], [0.95],
      [*5*], [300~000], [0.80], [140~000], [2.20], [90], [[350, 250, 250]], [0.60], [0.80],
      [*6*], [210~000], [1.40], [95~000], [2.90], [60], [[450, 180, 320]], [0.72], [0.88],
      [*7*], [240~000], [1.10], [110~000], [2.60], [30], [[380, 220, 280]], [0.58], [0.82],
      [*8*], [190~000], [1.60], [85~000], [3.10], [120], [[280, 120, 180]], [0.64], [0.78],
      [*9*], [280~000], [0.90], [130~000], [2.40], [−45], [[480, 280, 380]], [0.75], [0.92],
      [*10*], [260~000], [1.05], [115~000], [2.55], [90], [[420, 210, 310]], [0.68], [0.86],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Individual amaliy hisoblaş topşiriqlari variantlari],
) <tab-variants>

= Nazorat savollari

+ ISO 8373 böyiça sanoat roboti taʼrifining asosiy 3 ta mezonini tuşuntirib bering.
+ Qatʼiy avtomatlaştiriş (_fixed_) qanday hollarda moslaşuvçan avtomatlaştirişdan (_flexible_) iqtisodiy jihatdan afzalroq böladi?
+ Bir jinsli transformatsiya matritsasida $R_(3 times 3)$ va $P_(3 times 1)$ bloklari nimani anglatadi?
+ Nima uçun real dunyo robototexnikasida datçiklar axborotini qayta işlaşda stoxastik va Bayes usullari qöllaniladi?
+ RIA tasnifiga köra sanoat robotlarining boşqaruv turlari böyiça avlodlarini taʼriflang.
