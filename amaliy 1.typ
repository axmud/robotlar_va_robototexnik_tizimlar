// ============================================================
//  Robotlar va robototexnik tizimlar — 1-amaliy mashgʻulot (Avtomatlashtirishda robotlarning roli) — Typst versiyasi
//  Kompilyatsiya: typst compile rrti_amaliy_mashgulot_1_robotlar_roli.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "Avtomatlashtirishda robotlarning roli")
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
#let pblue = rgb(24, 76, 120)
#let sblue = rgb(41, 128, 185)
#let accent = rgb(211, 84, 0)

// ---------------- Sarlavha ----------------
#align(center)[
  #set par(justify: false)
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MASHGʻULOTI №1]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[Mavzu: Avtomatlashtirishda robotlarning roli. Robotlar haqida umumiy tushunchalar va taʼriflar]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Ishning maqsadi

*Mashgʻulotning maqsadi:* talabalarda avtomatlashtirilgan ishlab chiqarish tizimlarida sanoat va xizmat koʻrsatuvchi robotlarning iqtisodiy-texnik rolini baholash, xalqaro ISO 8373 hamda RIA standartlari asosida robototexnik tizimlar parametrlarini analitik hisoblash, fazoviy almashtirishlar hamda datchiklar noaniqligi sharoitida holatni baholash boʻyicha amaliy koʻnikmalarni shakllantirish.

*Oʻquv vazifalari:*

+ Qatʼiy (_fixed_) va moslashuvchan (_flexible_) avtomatlashtirish texnologiyalarining iqtisodiy samaradorligi hamda oʻzini qoplash muddatini ($T_"payback"$) hisoblashni oʻrganish.
+ ISO 8373 va RIA (_Robot Industries Association_) standartlari boʻyicha robotlarni turlarga ajratish va ularning funksional komponentlarini analitik tahlil qilish.
+ Asosiy va ishchi koordinata sistemalari oʻrtasidagi transformatsiya matritsalarini ($T_b^s$) tuzish hamda TCP (_Tool Center Point_) holatini aniqlash.
+ Stoxastik muhitda robot holatini Bayes filtri orqali ehtimollik asosida yangilash ($"bel"(x_t)$) boʻyicha amaliy masalalarni yechish.

= Kerakli jihozlar va dasturiy taʼminot

- *Hisoblash vositalari:* muhandislik kalkulyatori, hisoblash jadvallari.
- *Dasturiy muhit:* MATLAB, Python (NumPy).

= Nazariy rezyume va metodik koʻrsatmalar

Sanoatni avtomatlashtirish jarayonida texnologik uskunalar va avtomatlashtirish turlari uchta asosiy toifaga boʻlinadi (@fig-auto):

- *Qatʼiy avtomatlashtirish (_fixed automation_):* maxsus moʻljallangan agregat stanoklar va ketma-ket avtomat liniyalar. Ishlab chiqarish hajmi juda yuqori ($Q > 10^5$ dona/yil), ammo mahsulot nomenklaturasi oʻzgarmas.
- *Dasturlanadigan avtomatlashtirish (_programmed automation_):* sonli boshqariladigan (NC/CNC) stanoklar. Partiya oʻzgarganda dasturni qayta yuklash va mexanik sozlash talab etiladi.
- *Moslashuvchan avtomatlashtirish (_flexible automation_ / FMS):* sanoat robotlari, AGV (_Automated Guided Vehicles_) va moslashuvchan ishlab chiqarish modullari. Ishlab chiqarish jarayonini toʻxtatmasdan mahsulot turini oʻzgartirish imkonini beradi.

#figure(
  cetz.canvas(length: 1.3cm, {
    import cetz.draw: *
    set-style(content: (padding: 3pt))
    let lbl(t1, t2) = align(center, text(size: 8.5pt)[*#t1* \ #t2])

    // Oʻqlar
    line((0, 0), (10, 0), stroke: 1.2pt, mark: (end: ">", fill: black))
    line((0, 0), (0, 6), stroke: 1.2pt, mark: (end: ">", fill: black))
    content((10, -0.1), text(size: 9pt)[*Ishlab chiqarish hajmi ($Q$, dona/yil)*], anchor: "north-east")
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
    content((2, 4.75), lbl[Yakkalik / kichik \ partiyali][CNC stanoklar, \ qoʻl mehnati])
    content((4.5, 2.75), lbl[Moslashuvchan (FMS)][*Sanoat robotlari*])
    content((7.35, 1.1), lbl[Qatʼiy (fixed)][Avtomat liniyalar])
  }),
  caption: [Avtomatlashtirish turlarining mahsulot nomenklaturasi va ishlab chiqarish hajmi boʻyicha taqsimlanishi],
) <fig-auto>

== Robototexnika taʼriflari va tizim arxitekturasi

*ISO 8373 standarti boʻyicha taʼrif:* sanoat roboti --- bu koʻp maqsadli, qayta dasturlanadigan, uch yoki undan ortiq erkinlik darajasiga ega boʻlgan, avtomatlashtirishda harakatsiz yoki harakatlanuvchi tarzda qoʻllaniladigan avtomatik boshqariluvchi manipulyatordir.

Sanoat roboti quyidagi 4 ta asosiy kichik tizimning (_subsystems_) oʻzaro integratsiyasidan tashkil topadi (@fig-arch):

+ *Mexanik manipulyator (kinematik zanjir):* boʻgʻinlar (_links_) va kinematik juftliklar (_joints_) toʻplami.
+ *Ijrochi yuritmalar (_actuators_):* elektr (servodvigatellar), pnevmatik yoki gidravlik dvigatellar.
+ *Sensor va axborot tizimi (_sensors_):* ichki (enkoderlar, taxogeneratorlar) va tashqi (videokamera, kuch-moment datchiklari, ultratovush) datchiklar.
+ *Boshqaruv va hisoblash bloki (_controller_):* traektoriyani rejalashtirish, teskari aloqani qayta ishlash hamda datchiklar shovqinini Bayes filtri orqali filtrlash algoritmlari.

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

      node((1, -0.75), text(size: 8.5pt, weight: "bold", fill: red.darken(30%))[Kibernetik tizim (yopiq zanjir)], stroke: none, fill: none, name: <ttl>),
      node((0, 0), b[*Boshqaruv bloki* \ traektoriya va algoritm], width: 3.0cm, height: 1.3cm, name: <ctrl>),
      node((1, 0), b[*Ijrochi yuritmalar* \ servomotorlar, pnevmatika], width: 3.1cm, height: 1.3cm, fill: sblue.lighten(88%), name: <act>),
      node((2, 0), b[*Manipulyator* \ mexanik boʻgʻinlar va TCP], width: 3.1cm, height: 1.3cm, fill: accent.lighten(88%), stroke: 0.8pt + accent, name: <rob>),
      node((1, 1), b[*Datchiklar va axborot* \ enkoderlar, kamera, kuch], width: 3.8cm, height: 1.3cm, fill: luma(235), stroke: 0.8pt + luma(80), name: <sen>),
      node(
        enclose: (<ttl>, <ctrl>, <act>, <rob>, <sen>),
        stroke: (paint: red.darken(20%), dash: "dashed"),
        fill: none,
        inset: 12pt,
      ),

      edge(<ctrl>, <act>, "-|>", label: small[$u_t$ (boshqaruv)]),
      edge(<act>, <rob>, "-|>", label: small[$F$, $M$ (moment)]),
      edge(<rob>, (2, 1), <sen>, "-|>", stroke: 1pt + luma(60), label: small[Holat oʻzgarishi], label-pos: 0.3, label-side: left),
      edge(<sen>, (0, 1), <ctrl>, "-|>", stroke: 1pt + accent, label: small[$z_t$ (oʻlchov)], label-pos: 0.7, label-side: left),
    )
  },
  caption: [Robototexnik tizimning axborot-boshqaruv va teskari aloqa blok-sxemasi],
) <fig-arch>

== Fazoviy koordinata almashtirishlari va Bayes filtri

Robot manipulyatori boʻgʻinlari va obyektlarining uch oʻlchamli fazodagi holati ($P$) va orientatsiyasi ($R$) $4 times 4$ oʻlchamli bir jinsli transformatsiya matritsasi (_homogeneous transformation matrix_) orqali ifodalanadi:

$
  T_b^s = mat(R_(3 times 3), P_(3 times 1); 0_(1 times 3), 1)
  = mat(
    r_11, r_12, r_13, p_x;
    r_21, r_22, r_23, p_y;
    r_31, r_32, r_33, p_z;
    0, 0, 0, 1
  )
$ <eq-T>

Stoxastik muhitda datchiklardagi shovqin va harakatdagi noaniqliklarni hisobga olgan holda robotning joriy holatiga boʻlgan ishonch taqsimoti (_belief distribution_) rekursiv *Bayes filtri* tenglamasi orqali hisoblanadi:

$ "bel"(x_t) = eta dot p(z_t mid(|) x_t) integral p(x_t mid(|) u_t, x_(t-1)) dot "bel"(x_(t-1)) dif x_(t-1) $ <eq-bayes>

bunda $x_t$ --- $t$ vaqtdagi robot holati (pozitsiya / orientatsiya), $u_t$ --- $t$ vaqtdagi boshqaruv taʼsiri (_control action_), $z_t$ --- $t$ vaqtdagi datchik oʻlchov koʻrsatkichlari (_sensor measurement_), $p(z_t mid(|) x_t)$ --- datchik oʻlchov modeli (_measurement model_), $p(x_t mid(|) u_t, x_(t-1))$ --- robot harakat dinamikasi modeli (_motion model_), $eta$ --- normalashtiruvchi koeffitsient ($eta = 1 \/ p(z_t mid(|) z_(1:t-1))$).

= Namunaviy masalalar va ularning toʻliq analitik yechimlari

== Masala 1: avtomatlashtirish samaradorligi va breakeven tahlili

*Masala sharti:* sanoat korxonasida detallarga ishlov berish operatsiyasini bajarish uchun ikkita variant koʻrib chiqilmoqda:

- *A varianti (qatʼiy avtomatlashtirish):* boshlangʻich kapital xarajat $C_"cap,A" = \$ 250 thin 000$, bir dona mahsulot uchun ekspluatatsiya xarajati $c_"var,A" = \$ 1.20$/dona.
- *B varianti (sanoat roboti bilan moslashuvchan avtomatlashtirish):* boshlangʻich kapital xarajat $C_"cap,B" = \$ 110 thin 000$, bir dona mahsulot uchun ekspluatatsiya xarajati $c_"var,B" = \$ 2.80$/dona.

#set enum(numbering: "a)")
+ Yillik ishlab chiqarish hajmining qanday kritik qiymatida ($Q_"crit"$) ikkala variant xarajatlari tenglashadi (_breakeven point_)?
+ Agar yillik reja $Q = 120 thin 000$ dona boʻlsa, qaysi avtomatlashtirish varianti iqtisodiy jihatdan afzalroq?
+ A variantiga qoʻshimcha kiritilgan kapital qoʻyilmaning (B variantiga nisbatan) oʻzini oqlash muddatini ($T_"payback"$) hisoblang.
#set enum(numbering: "1.")

*Yechish va formulalar:*

$ "TC"_A (Q) = C_"cap,A" + c_"var,A" dot Q, quad quad "TC"_B (Q) = C_"cap,B" + c_"var,B" dot Q $

*Hisoblash bosqichlari:*

- a) Ikkala xarajatni tenglashtiramiz ($"TC"_A (Q_"crit") = "TC"_B (Q_"crit")$):
  $ C_"cap,A" + c_"var,A" dot Q_"crit" = C_"cap,B" + c_"var,B" dot Q_"crit" $
  $ Q_"crit" = (C_"cap,A" - C_"cap,B") / (c_"var,B" - c_"var,A") = (250 thin 000 - 110 thin 000) / (2.80 - 1.20) \
    = (140 thin 000) / 1.60 = 87 thin 500 "dona/yil" $
- b) Yillik reja $Q = 120 thin 000$ dona boʻlganda umumiy xarajatlar:
  $ "TC"_A (120 thin 000) = 250 thin 000 + 1.20 times 120 thin 000 = 250 thin 000 + 144 thin 000 = \$ 394 thin 000 $
  $ "TC"_B (120 thin 000) = 110 thin 000 + 2.80 times 120 thin 000 = 110 thin 000 + 336 thin 000 = \$ 446 thin 000 $
  $Q = 120 thin 000 > 87 thin 500$ boʻlgani uchun *A varianti (qatʼiy avtomatlashtirish)* yiliga $\$ 52 thin 000$ tejamkorlik beradi va afzalroq.
- c) A variantiga qoʻshimcha kapital qoʻyilma $Delta C = \$ 140 thin 000$, yillik ekspluatatsiya tejami esa $Delta c dot Q = 1.60 times 120 thin 000 = \$ 192 thin 000$/yil. Oʻzini oqlash muddati:
  $ T_"payback" = (Delta C) / (Delta c dot Q) = (140 thin 000) / (192 thin 000) approx 0.73 "yil" approx 8.75 "oy" $
  Demak, B varianti (robot) faqat moslashuvchanlik zarur boʻlganda, yaʼni mahsulot nomenklaturasi tez-tez oʻzgarganda yoki $Q < Q_"crit"$ boʻlganda oʻzini oqlaydi.

== Masala 2: koordinata almashtirishlari va robot tutqichi (TCP) hisobi

*Masala sharti:* sanoat roboti asosiy koʻchirishni tugatgandan soʻng, uning bazaviy ${s}$ koordinata sistemasiga nisbatan tutqich (TCP) freymi ${t}$ quyidagicha joylashgan:

- tutqich freymi ${t}$ bazaviy freym ${s}$ ning $Z$-oʻqi atrofida $theta = 90 degree$ ga burilgan;
- robot bazasidan TCP markazigacha boʻlgan siljish vektori $P = [450, 200, 350]^T "mm"$.

#set enum(numbering: "a)")
+ $Z$-oʻqi atrofidagi burilish matritsasi $R_z (90 degree)$ ni tuzing.
+ $4 times 4$ bir jinsli transformatsiya matritsasi $T_t^s$ ni hisoblang.
+ Detal ${t}$ freymida $P_"detail"^({t}) = [10, 0, 50, 1]^T "mm"$ koordinataga ega boʻlsa, ushbu detalning bazaviy ${s}$ sistemadagi $P_"detail"^({s})$ koordinatasini toping.
#set enum(numbering: "1.")

*Yechish va formulalar:*

$ R_z (theta) = mat(cos theta, -sin theta, 0; sin theta, cos theta, 0; 0, 0, 1) $

*Hisoblash bosqichlari:*

- a) $theta = 90 degree$ boʻlganda ($cos 90 degree = 0$, $sin 90 degree = 1$):
  $ R_z (90 degree) = mat(0, -1, 0; 1, 0, 0; 0, 0, 1) $
- b) Bir jinsli transformatsiya matritsasi:
  $ T_t^s = mat(0, -1, 0, 450; 1, 0, 0, 200; 0, 0, 1, 350; 0, 0, 0, 1) $
- c) Detalning bazaviy sistemadagi koordinatasi:
  $ P_"detail"^({s}) = T_t^s dot P_"detail"^({t}) = mat(0, -1, 0, 450; 1, 0, 0, 200; 0, 0, 1, 350; 0, 0, 0, 1) dot vec(10, 0, 50, 1) $
  Matritsalarni koʻpaytiramiz:
  $
    P_x^({s}) &= 0 dot 10 + (-1) dot 0 + 0 dot 50 + 450 dot 1 = 450 "mm" \
    P_y^({s}) &= 1 dot 10 + 0 dot 0 + 0 dot 50 + 200 dot 1 = 210 "mm" \
    P_z^({s}) &= 0 dot 10 + 0 dot 0 + 1 dot 50 + 350 dot 1 = 400 "mm"
  $

*Natija:* detalning bazaviy koordinatalar sistemasidagi oʻrni $P_"detail"^({s}) = [450, 210, 400]^T "mm"$.

== Masala 3: stoxastik Bayes filtri orqali robot holatini baholash

*Masala sharti:* avtonom mobil sanoat roboti (AGV) sex ichida harakatlanmoqda. Dastlabki vaqt momentida robotning $x_1$ pozitsiyada boʻlishining apriori ehtimolligi $"bel"(x_1) = 0.60$, $x_2$ pozitsiyada boʻlishiniki esa $"bel"(x_2) = 0.40$. Robot ultratovushli masofa oʻlchagich orqali toʻsiqqacha boʻlgan masofani oʻlchadi ($z$). Datchikning oʻlchov modellari (_likelihood_) quyidagicha berilgan:

- $p(z mid(|) x_1) = 0.80$ --- robot $x_1$ da boʻlganda ushbu koʻrsatkichni berish ehtimoli;
- $p(z mid(|) x_2) = 0.20$ --- robot $x_2$ da boʻlganda ushbu koʻrsatkichni berish ehtimoli.

Datchik koʻrsatkichidan soʻng Bayes qoidasi orqali aposterior ishonch taqsimotlarini ($"bel"'(x_1)$ va $"bel"'(x_2)$) hisoblang.

*Hisoblash bosqichlari:*

- Har bir holat uchun normalashtirilmagan ehtimolliklar:
  $ overline("bel")(x_1) = p(z mid(|) x_1) dot "bel"(x_1) = 0.80 times 0.60 = 0.48 $
  $ overline("bel")(x_2) = p(z mid(|) x_2) dot "bel"(x_2) = 0.20 times 0.40 = 0.08 $
- Normalashtiruvchi koeffitsient $eta$ (toʻliq oʻlchov ehtimoli $p(z)$):
  $ p(z) = overline("bel")(x_1) + overline("bel")(x_2) = 0.48 + 0.08 = 0.56 $
  $ eta = 1 / p(z) = 1 / 0.56 approx 1.7857 $
- Yangi (aposterior) ishonch taqsimotlari:
  $ "bel"'(x_1) = eta dot overline("bel")(x_1) = 0.48 / 0.56 = 6 / 7 approx 0.8571 thick (85.71 %) $
  $ "bel"'(x_2) = eta dot overline("bel")(x_2) = 0.08 / 0.56 = 1 / 7 approx 0.1429 thick (14.29 %) $

*Natija:* yangi datchik axboroti olingandan soʻng robotning $x_1$ nuqtada joylashganligiga boʻlgan ishonch ehtimoli $60 %$ dan $85.71 %$ gacha oshdi.

= Talabalar uchun individual amaliy topshiriqlar

Har bir talaba oʻzining tartib raqamiga mos keluvchi variant koʻrsatkichlari (@tab-variants) boʻyicha quyidagi hisoblashlarni bajarishi lozim:

+ Qatʼiy va moslashuvchan avtomatlashtirish breakeven nuqtasi ($Q_"crit"$) hamda berilgan $Q_"plan"$ hajmdagi tejamkorlikni aniqlash.
+ Berilgan siljish va $Z$-oʻqi atrofidagi burilish burchagi $theta$ boʻyicha $T_t^s$ matritsasini tuzish hamda berilgan nuqta koordinatasini hisoblash.
+ Bayes filtri boʻyicha aposterior ehtimollik $"bel"'(x_1)$ ni topish.

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
        [*Siljish $P$ \ [mm]*],
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
  caption: [Individual amaliy hisoblash topshiriqlari variantlari],
) <tab-variants>

= Nazorat savollari

+ ISO 8373 boʻyicha sanoat roboti taʼrifining asosiy 3 ta mezonini tushuntirib bering.
+ Qatʼiy avtomatlashtirish (_fixed_) qanday hollarda moslashuvchan avtomatlashtirishdan (_flexible_) iqtisodiy jihatdan afzalroq boʻladi?
+ Bir jinsli transformatsiya matritsasida $R_(3 times 3)$ va $P_(3 times 1)$ bloklari nimani anglatadi?
+ Nima uchun real dunyo robototexnikasida datchiklar axborotini qayta ishlashda stoxastik va Bayes usullari qoʻllaniladi?
+ RIA tasnifiga koʻra sanoat robotlarining boshqaruv turlari boʻyicha avlodlarini taʼriflang.
