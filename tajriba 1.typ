// ============================================================
//  Robotlar va Robototexnik Tizimlar — 1-tajriba mashgʻuloti
//  Kompilyatsiya: typst compile rrt_tajriba_mashgulot_1.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)

#set document(title: "Avtomatlashtirishda robotlarning roli")
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MASHGʻULOTI №1]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[
    Mavzu: Avtomatlashtirishda robotlarning roli. Robotlar haqida umumiy tushunchalar va taʼriflar
  ]
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Ishning maqsadi

*Amaliy maqsad:* sanoat ishlab chiqarishini avtomatlashtirishda robotlarning oʻrni va texnik-iqtisodiy rolini tahlil qilish, robot manipulyatorlarining kinematik strukturasi, erkinlik darajalari va ishchi sohasi toʻgʻrisidagi nazariy bilimlarni amaliy hisoblashlar bilan mustahkamlash.

*Oʻquv vazifalari:*

+ Sanoat ishlab chiqarishini avtomatlashtirishda robotlarning oʻrni va iqtisodiy hamda texnik rolini tahlil qilish.
+ ISO 8373 va RIA xalqaro standartlari boʻyicha „robot" va „robototexnika" tushunchalariga akademik taʼrif berish.
+ Robot manipulyatorlarining kinematik strukturasi, boʻgʻinlari hamda erkinlik darajalarini (DoF) Grübler formulasi orqali hisoblashni oʻrganish.
+ Sanoat robotlarining asosiy geometrik konfiguratsiyalari va ishchi sohasini (_workspace_) geometrik baholash.

= Kerakli asbob-uskunalar va dasturiy taʼminot

- *Hisoblash texnikasi:* shaxsiy kompyuter yoki ish stansiyasi, ilmiy kalkulyator, chizmachilik qurollari.
- *Modellashtirish dasturlari:* ROS (Robot Operating System), MATLAB / Simulink (Robotics System Toolbox), CoppeliaSim (V-REP).
- *Yordamchi materiallar:* sanoat robotlari (PUMA 560, FANUC, ABB, KUKA) texnik pasportlari va kinematik sxemalari.

= Kirish va nazariy qism

== Avtomatlashtirish tushunchasi va sanoat robotlarining rivojlanish tarixi

Zamonaviy sanoat ishlab chiqarish jarayonlarini avtomatlashtirish mehnat unumdorligini keskin oshirish, mahsulot sifatini kafolatlash hamda xavfli, ogʻir va bir xil takrorlanuvchi (monoton) mehnat sharoitlaridan insonni ozod etishning asosiy texnik omilidir. Sanoat avtomatlashtirish texnikasi oʻz rivojlanishida ikkita yirik va tubdan farq qiluvchi bosqichni bosib oʻtdi:

+ *Qatʼiy (fiksatsiyalangan) avtomatlashtirish (fixed / hard automation):* maxsus loyihalangan mexanik liniyalar va avtomat-stanoklar majmuasi. Ular faqat bitta turdagi mahsulotni oʻta katta hajmda (_mass production_) ishlab chiqarishga moʻljallangan. Yuqori unumdorlikka ega boʻlsa-da, moslashuvchanlikdan mahrum: mahsulot shakli, oʻlchami yoki konstruksiyasi oʻzgarganda butun liniyani qayta jihozlash (_retooling_) katta moliyaviy xarajat va uzoq vaqt talab etadi.
+ *Moslashuvchan (dasturlanadigan) avtomatlashtirish (flexible / programmable automation):* dasturiy taʼminot orqali harakat trayektoriyasi, tezligi va texnologik vazifasi tezda oʻzgartiriladigan raqamli boshqariluvchi mexanizmlar. Sanoat robotlari moslashuvchan avtomatlashtirishning markaziy poydevori hisoblanadi.

Sanoat robotlarining rivojlanish tarixi 1960-yillardan boshlanadi. Dastlabki sanoat roboti --- _Unimate_ (1961-yilda George Devol va Joseph Engelberger tomonidan yaratilgan) General Motors zavodida issiq metall quyish va nuqtaviy payvandlash ishlariga joriy etilgan. 1970--1980-yillarda kompyuter yordamida loyihalash (CAD --- _Computer-Aided Design_) va kompyuter yordamida ishlab chiqarish (CAM --- _Computer-Aided Manufacturing_) tizimlarining jadal rivojlanishi sanoat robotlarini yagona moslashuvchan ishlab chiqarish tizimlariga (FMS --- _Flexible Manufacturing Systems_) birlashtirish imkonini berdi.

Dunyo iqtisodiyotidagi demografik oʻzgarishlar, yaʼni ishchi kuchi narxining yildan-yilga oshishi hamda mikroelektronika va robototexnik qurilmalar narxining nisbiy arzonlashishi sanoat robotlarining ommalashuviga kuchli turtki boʻldi. Sanoat robotlarining aksariyati payvandlash (_welding_), materiallarni koʻchirish va yuklash (_material handling_), yigʻuv (_assembly_) hamda sirtlarga ishlov berish operatsiyalarida qoʻllaniladi.

== Robot va robototexnik tizim taʼriflari

„Robot" soʻzi ilk bor 1921-yilda chex dramaturgi Karel Čapekning „R.U.R." (_Rossum's Universal Robots_) pyesasida qoʻllanilgan boʻlib, chexcha _robota_ (majburiy mehnat, qullik) soʻzidan olingan. Bugungi kunda „robot" tushunchasiga aniq standartlashtirilgan taʼriflar berilgan.

#block(
  width: 100%,
  fill: blue.lighten(95%),
  stroke: (left: 2.5pt + headingblue),
  inset: 10pt,
  radius: 2pt,
)[
  *Xalqaro standartlashtirish tashkiloti (ISO 8373) taʼrifi.* _Sanoat roboti_ --- bu avtomatik boshqariladigan, qayta dasturlanadigan, koʻp maqsadli, uch yoki undan ortiq oʻqda dasturlana oladigan, fiksatsiyalangan yoki harakatlanuvchi platformaga oʻrnatilgan hamda sanoat avtomatlashtirish ilovalarida qoʻllaniladigan manipulyatsiyalash mexanizmidir.
]

#v(0.2cm)

#block(
  width: 100%,
  fill: orange.lighten(93%),
  stroke: (left: 2.5pt + orange.darken(25%)),
  inset: 10pt,
  radius: 2pt,
)[
  *Amerika robototexnika sanoati assotsiatsiyasi (RIA) taʼrifi.* _Robot_ --- bu turli materiallar, detallar, asboblar va maxsus moslamalarni har xil dasturlanadigan harakatlar orqali koʻchirish hamda berilgan texnologik topshiriqni bajarish uchun moʻljallangan qayta dasturlanuvchi koʻp funksiyali manipulyatordir.
]

*Robototexnika (_robotics_)* --- robotlarni loyihalash, konstruksiyalash, ularni boshqarish, datchiklar maʼlumotlarini qayta ishlash hamda dasturiy taʼminotini yaratish bilan shugʻullanuvchi kompleks fan va texnika sohasi. Robototexnika toʻrtta asosiy ustunga tayanadi:

- *Mexanik manipulyatsiya (mechanical manipulation):* kinematika, dinamika, mexanizmlar va materiallar qarshiligi.
- *Harakatlanish (locomotion):* mobil robotlar, gʻildirakli va oyoqli tizimlar navigatsiyasi.
- *Kompyuterli koʻrish va sensorika (computer vision & sensing):* atrof-muhitni idrok etish, obyektlarni tanish.
- *Sunʼiy intellekt va avtonomlik (artificial intelligence & planning):* harakat trayektoriyasini optimallashtirish, qaror qabul qilish.

= Robototexnik tizimning tuzilishi va tarkibiy qismlari

== Robototexnik tizimning funksional strukturasi

Robototexnik tizim --- bu tashqi muhit bilan uzviy bogʻliqlikda ishlovchi murakkab mexatronik majmua boʻlib, toʻrtta asosiy tarkibiy qismdan tashkil topadi (@fig-block):

+ *Mexanik manipulyator (manipulator arm):* kinematik juftliklar orqali ketma-ket (yoki parallel) bogʻlangan qattiq boʻgʻinlar (_links_) majmuasi. U asos (_base_) bilan ishchi aʼzo oʻrtasida harakat uzatish vazifasini bajaradi.
+ *Ishchi aʼzo (end-effector / TCP):* manipulyatorning oxirgi boʻgʻiniga oʻrnatiladigan va texnologik operatsiyani bevosita bajaruvchi moslama (qisqich, payvandlash gorelkasi, boʻyoq purkagichi, lazerli kalla va h.k.).
+ *Ijrochi mexanizmlar va datchiklar (actuators & sensors):* boʻgʻinlarni harakatga keltiruvchi elektr dvigatellar (DC, BLDC, servo, qadamli), gidravlik va pnevmatik silindrlar; boʻgʻinlar burchagini oʻlchovchi enkoderlar, potensiometrlar hamda kuch-moment datchiklari.
+ *Boshqaruv tizimi (controller):* mikrokontroller, DSP yoki sanoat kompyuteri boʻlib, sensor maʼlumotlarini qabul qiladi, toʻgʻri va teskari kinematika/dinamika masalalarini yechadi hamda dvigatellarga boshqaruv signallarini beradi.

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
      spacing: (14mm, 14mm),
      edge-stroke: 1pt + headingblue,

      node((0, 0), b[*Boshqaruv tizimi* \ (kontroller / PLC)], width: 3cm, height: 1.3cm),
      node((1, 0), b[*Ijrochi mexanizmlar* \ (actuators / motors)], width: 3cm, height: 1.3cm),
      node((2, 0), b[*Mexanik manipulyator* \ va ishchi aʼzo (TCP)], width: 3cm, height: 1.3cm),
      node(
        (1, 1),
        b[*Sensor tizimi* \ (proprioseptiv va \ eksteroseptiv)],
        width: 3cm,
        height: 1.3cm,
        fill: orange.lighten(85%),
        stroke: 0.8pt + orng,
      ),
      node((2, 1), b[*Tashqi muhit va \ texnologik obyekt*], width: 3cm, height: 1.3cm, fill: luma(245)),

      edge((0, 0), (1, 0), "-|>", label: small[buyruq signali], label-sep: 12pt),
      edge((1, 0), (2, 0), "-|>", label: small[moment / kuch], label-sep: 12pt),
      edge((2, 0), (2, 1), "-|>", label: small[mexanik taʼsir], label-sep: 12pt),
      edge((2, 1), (1, 1), "-|>", stroke: 1pt + orng, label: small[muhit holati], label-sep: 12pt),
      edge(
        (1, 1),
        (0, 0),
        "-|>",
        stroke: 1pt + orng,
        label: small[aks aloqa (feedback)],
        label-pos: 0.4,
        label-sep: 6pt,
      ),
    )
  },
  caption: [Robototexnik tizimning yopiq aks aloqali funksional blok-sxemasi],
) <fig-block>

= Kinematik boʻgʻinlar, erkinlik darajalari va Grübler formulasi

== Kinematik juftlik turlari va koordinata sistemalari

Robot manipulyatori boʻgʻinlar (_links_) va ularni tutashtiruvchi kinematik juftliklardan (_joints_) tashkil topadi. Eng koʻp tarqalgan 1 erkinlik darajali kinematik juftliklar:

- *Aylanma juftlik (revolute joint --- R):* faqat bitta oʻq atrofida nisbiy burchakli burilish harakatiga ruxsat beradi ($theta$ burchak).
- *Ilgarilanma juftlik (prismatic joint --- P):* faqat bitta oʻq boʻylab toʻgʻri chiziqli siljish harakatiga ruxsat beradi ($d$ masofa).

Murakkabroq kinematik juftliklarga silindrik ($C$, 2 DoF), universal ($U$, 2 DoF) va sferik ($S$, 3 DoF) birikmalar kiradi (@fig-kin).

#figure(
  {
    set text(size: 8pt)
    cetz.canvas(length: 1cm, {
      import cetz.draw: *

      // Zamin
      line((-1.3, 0), (1.3, 0), stroke: 1.2pt)
      for i in range(9) {
        line((-1.25 + i * 0.3, 0), (-1.45 + i * 0.3, -0.28), stroke: 0.6pt)
      }

      // Asos (Link 0)
      rect((-0.5, 0), (0.5, 1.0), fill: luma(225), stroke: 0.9pt)
      content((0, 0.5), text(size: 7pt)[Asos (Link 0)])
      line((0, 0.5), (0.95, 0.5), stroke: 1pt + red, mark: (end: "straight"))
      content((1.25, 0.5), text(size: 7.5pt)[$x_s$])
      line((0, 0.5), (0, 1.45), stroke: 1pt + blue, mark: (end: "straight"))
      content((-0.3, 1.5), text(size: 7.5pt)[$z_s$])
      content((-1.5, 0.5), text(size: 7pt)[Bazis $\{s\}$])

      // Joint 1
      circle((0, 1.0), radius: 0.32, fill: blue.lighten(65%), stroke: 0.9pt)
      content((1.15, 1.1), text(size: 7pt)[Joint 1 (R)])
      arc((-0.45, 1.55), start: 150deg, stop: 40deg, radius: 0.8, anchor: "origin", stroke: 0.8pt, mark: (
        end: "straight",
      ))
      content((0.05, 2.0), text(size: 7.5pt)[$theta_1$])

      // Link 1
      line((0, 1.3), (3.0, 2.8), (2.85, 3.15), (-0.15, 1.65), close: true, fill: luma(235), stroke: 0.9pt)
      content((1.15, 2.6), text(size: 7pt)[Link 1 ($L_1$)])

      // Joint 2
      circle((2.9, 3.0), radius: 0.28, fill: blue.lighten(65%), stroke: 0.9pt)
      content((2.55, 3.55), text(size: 7pt)[Joint 2 (R)])
      arc((2.45, 3.4), start: 140deg, stop: 40deg, radius: 0.6, anchor: "origin", stroke: 0.8pt, mark: (
        end: "straight",
      ))
      content((3.5, 3.5), text(size: 7.5pt)[$theta_2$])

      // Link 2
      line((2.9, 3.0), (6.0, 1.8), stroke: 2.5pt + luma(150))
      content((4.7, 2.75), text(size: 7pt)[Link 2 ($L_2$)])

      // TCP
      circle((6.0, 1.8), radius: 0.12, fill: headingblue, stroke: none)
      content((6.4, 1.45), text(size: 7pt)[TCP $\{b\}$])
      line((6.0, 1.8), (6.95, 1.8), stroke: 1pt + red, mark: (end: "straight"))
      content((7.25, 1.8), text(size: 7.5pt)[$x_b$])
      line((6.0, 1.8), (6.0, 2.75), stroke: 1pt + blue, mark: (end: "straight"))
      content((5.7, 2.8), text(size: 7.5pt)[$z_b$])
    })
  },
  caption: [Ochiq kinematik zanjirli 2R planar manipulyator va uning koordinata tizimlari],
) <fig-kin>

== Erkinlik darajasi va Grübler formulasi

Mexanizmning *erkinlik darajasi (DoF --- degrees of freedom)* u egallashi mumkin boʻlgan mustaqil fazoviy koordinatalar sonini bildiradi. Mexanizmlarning erkinlik darajasi *Grübler formulasi* orqali aniqlanadi:

$ "DoF" = m (N - 1 - J) + sum_(i=1)^J f_i $

bunda:

- $m$ --- ishchi fazoning oʻlchami ($m = 6$ --- uch oʻlchamli fazoviy mexanizmlar uchun, $m = 3$ --- tekislikdagi mexanizmlar uchun);
- $N$ --- mexanizmdagi jami boʻgʻinlar soni (qoʻzgʻalmas asos bilan birgalikda);
- $J$ --- kinematik juftliklar (birikmalar) soni;
- $f_i$ --- $i$-chi kinematik juftlikning erkinlik darajasi ($R$ va $P$ juftliklar uchun $f_i = 1$).

Ochiq kinematik zanjirli (_serial chain_) robotlarda $N$ ta boʻgʻin va $J = N - 1$ ta 1 DoF li birikma boʻlsa, jami erkinlik darajasi birikmalar soniga teng boʻladi: $"DoF" = J$.

= Sanoat robotlarining geometrik konfiguratsiyalari va ishchi sohasi

== Asosiy kinematik konfiguratsiyalar

Sanoat robotlari dastlabki uchta asosiy boʻgʻinining harakat xarakteriga koʻra beshta geometrik guruhga boʻlinadi (@fig-conf, @tab-conf).

#figure(
  {
    set text(size: 8pt)
    cetz.canvas(length: 1cm, {
      import cetz.draw: *

      // a) Dekart
      line((0, 0), (1.5, 0), stroke: 0.9pt, mark: (end: "straight"))
      line((0, 0), (0, 1.5), stroke: 0.9pt, mark: (end: "straight"))
      line((0, 0), (-0.8, -0.8), stroke: 0.9pt, mark: (end: "straight"))
      content((1.75, 0), text(size: 7pt)[X])
      content((0, 1.75), text(size: 7pt)[Z])
      content((-1.05, -0.95), text(size: 7pt)[Y])
      rect((0.5, 0.5), (1.2, 1.2), fill: blue.lighten(80%), stroke: 0.9pt)
      content((0.4, -1.5), text(size: 8pt, weight: "bold")[a) Dekart (PPP)])

      // b) Silindrik
      let b0 = 4.2
      line((b0, 0), (b0, 1.5), stroke: 1.1pt)
      circle((b0, 0.8), radius: 0.2, fill: blue.lighten(65%), stroke: 0.9pt)
      line((b0 + 0.2, 0.8), (b0 + 1.3, 0.8), stroke: 1.1pt)
      line((b0 + 1.3, 0.8), (b0 + 1.3, 0.35), stroke: 1pt, mark: (end: "straight"))
      arc((b0 + 0.55, 0.25), start: -40deg, stop: 40deg, radius: 0.55, anchor: "origin", stroke: 0.8pt, mark: (
        end: "straight",
      ))
      content((b0 + 0.5, -1.5), text(size: 8pt, weight: "bold")[b) Silindrik (RPP)])

      // c) SCARA
      let c0 = 8.4
      line((c0, 0), (c0, 1.0), (c0 + 1.0, 1.0), (c0 + 1.0, 0.5), (c0 + 1.8, 0.5), stroke: 1.1pt)
      circle((c0, 1.0), radius: 0.11, fill: headingblue, stroke: none)
      circle((c0 + 1.0, 1.0), radius: 0.11, fill: headingblue, stroke: none)
      circle((c0 + 1.8, 0.5), radius: 0.11, fill: headingblue, stroke: none)
      line((c0 + 1.8, 0.35), (c0 + 1.8, -0.25), stroke: 1.3pt, mark: (end: "straight"))
      content((c0 + 0.9, -1.5), text(size: 8pt, weight: "bold")[c) SCARA (RRP)])

      // d) Antropomorf
      let d0 = 12.4
      line((d0, 0), (d0, 0.6), (d0 + 0.8, 1.35), (d0 + 1.7, 0.8), stroke: 1.1pt)
      circle((d0, 0.6), radius: 0.11, fill: blue.darken(10%), stroke: none)
      circle((d0 + 0.8, 1.35), radius: 0.11, fill: blue.darken(10%), stroke: none)
      circle((d0 + 1.7, 0.8), radius: 0.11, fill: blue.darken(10%), stroke: none)
      content((d0 + 0.8, -1.5), text(size: 8pt, weight: "bold")[d) Antropomorf (3R)])
    })
  },
  caption: [Sanoat robotlarining asosiy kinematik konfiguratsiyalari sxemasi],
  placement: auto,
) <fig-conf>

#figure(
  {
    set text(size: 9pt)
    set par(justify: false)
    table(
      columns: (3cm, auto, 3.2cm, 1fr),
      align: left + horizon,
      stroke: none,
      inset: (x: 4pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header([*Konfiguratsiya*], [*Juftliklar*], [*Ishchi soha \ shakli*], [*Qoʻllanilish sohasi*]),
      table.hline(stroke: 0.5pt),
      [*Dekart (Cartesian)*], [PPP], [Parallelepiped],
      [Portal (gantry) robotlar, 3D printerlar, ogʻir yuk tashish va CNC stanoklarga xizmat koʻrsatish.],
      [*Silindrik*], [RPP], [Silindr / halqa],
      [Kichik maydonda silindrik detallarga ishlov berish va quyuv ishlari.],
      [*Sferik (polyar)*], [RRP], [Sfera sektori],
      [Press ostiga detallarni uzatish, quyuv mashinalariga xizmat koʻrsatish.],
      [*SCARA*], [RRP], [Vertikal silindr],
      [Elektronikada platalarga detallarni oʻrnatish (_pick-and-place_), vertikal yigʻuv.],
      [*Antropomorf (Articulated)*], [RRR (6R)], [Murakkab sferik sirt],
      [Payvandlash, boʻyash, kompleks yigʻuv (PUMA 560, FANUC, ABB).],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Sanoat robotlarining kinematik konfiguratsiyalari tavsifi],
) <tab-conf>

== Ishchi soha (workspace) va metrologik parametrlar

Robotning *ishchi sohasi (workspace)* --- bu manipulyator ishchi nuqtasi (TCP) erisha oladigan barcha fazoviy nuqtalar toʻplamidir (@fig-ws):

+ *Erishiladigan ishchi soha (reachable workspace):* robot kamida bitta yoʻnalish bilan erisha oladigan barcha nuqtalar toʻplami.
+ *Epchillik ishchi sohasi (dextrous workspace):* robot ixtiyoriy yoʻnalish (_orientation_) bilan erisha oladigan nuqtalar toʻplami.

#figure(
  {
    set text(size: 8pt)
    cetz.canvas(length: 1cm, {
      import cetz.draw: *

      circle((0, 0), radius: 3.6, fill: blue.lighten(88%), stroke: 1.1pt + headingblue)
      circle((0, 0), radius: 1.3, fill: white, stroke: 1.1pt + headingblue)
      circle((0, 0), radius: 0.13, fill: headingblue, stroke: none)
      content((0, -0.45), text(size: 7pt)[Asos])
      content((0, 0.55), text(size: 7pt)[Taqiqlangan \ zona])

      line((0, 0), (1.126, 0.65), stroke: (thickness: 0.8pt, dash: "dashed"))
      content((1.35, 0.9), text(size: 7pt)[$R_"in" = |L_1 - L_2|$])

      line((0, 0), (-3.12, 1.8), stroke: 1.1pt + headingblue, mark: (end: "straight"))
      content((-1.5, 1.35), text(size: 7pt)[$R_"out" = L_1 + L_2$])

      content((0, 2.5), text(size: 8pt, weight: "bold")[Erishiladigan ishchi soha])
    })
  },
  caption: [2R tekislikdagi manipulyatorning halqasimon ishchi sohasi ($L_1 > L_2$)],
) <fig-ws>

Sanoat robotlarining aniqlik koʻrsatkichlari:

- *Takrorlanuvchanlik (repeatability):* robot avval oʻrgatilgan (_taught point_) nuqtaga qayta harakatlanganda qanchalik kichik ogʻish bilan borishi. Sanoat robotlarida bu koʻrsatkich $plus.minus 0.01 dots plus.minus 0.05 "mm"$ ni tashkil etadi.
- *Absolyut aniqlik (accuracy):* dasturda hisoblangan (_computed point_) koordinataga robotning qanchalik aniq borishi.

= Sanoatda robotlarning roli va qoʻllanilish sohalari

+ *Payvandlash (spot & arc welding):* avtomobil kuzovlarini yigʻishda 6 DoF li antropomorf robotlar yuqori tezlik va doimiy sifat bilan ishlaydi.
+ *Materiallarni koʻchirish va yuklash (material handling):* CNC stanoklariga detallarni oʻrnatish hamda tayyor mahsulotlarni palletlarga joylash (_palletizing_).
+ *Yigʻuv operatsiyalari (assembly):* SCARA va delta robotlari yordamida elektronikada mikrosxemalarni yuqori tezlikda yigʻish.
+ *Sirtlarga ishlov berish (boʻyash, jilolash):* purkash va jilolashda gibrid kuch-vaziyat boshqaruvi (_hybrid position/force control_) qoʻllaniladi.

= Tajriba topshiriqlari va misollar

== 1-topshiriq: erkinlik darajasini (DoF) hisoblash

*1-masala.* Tekislikda harakatlanuvchi 3R ochiq kinematik zanjirli robot manipulyatori berilgan. Zanjirda 3 ta aylanma juftlik va 3 ta qoʻzgʻaluvchi boʻgʻin mavjud. Grübler formulasi yordamida robotning erkinlik darajasini hisoblang.

*Yechish.* Tekislikdagi mexanizmlar uchun $m = 3$. Boʻgʻinlar soni $N = 3 + 1 = 4$ (3 ta qoʻzgʻaluvchi boʻgʻin va asos). Juftliklar soni $J = 3$, barchasi R-juftlik ($f_i = 1$):

$ "DoF" = m (N - 1 - J) + sum_(i=1)^J f_i = 3 (4 - 1 - 3) + (1 + 1 + 1) = 3 dot 0 + 3 = 3 $

*Javob:* robot 3 erkinlik darajasiga (3 DoF) ega.

*2-masala.* 6R tipidagi PUMA 560 fazoviy sanoat robotining erkinlik darajasini hisoblang. U 6 ta aylanma juftlik va 6 ta qoʻzgʻaluvchi boʻgʻindan tashkil topgan.

*Yechish.* Fazoviy mexanizm uchun $m = 6$, boʻgʻinlar soni $N = 6 + 1 = 7$, juftliklar soni $J = 6$, har birining $f_i = 1$:

$ "DoF" = 6 (7 - 1 - 6) + 6 dot 1 = 6 dot 0 + 6 = 6 $

*Javob:* PUMA 560 roboti 6 erkinlik darajasiga (6 DoF) ega.

*3-masala.* Fazoviy Stewart--Gough platformasining erkinlik darajasini hisoblang. Platforma qoʻzgʻalmas asos va harakatlanuvchi yuqori platformadan iborat boʻlib, ular 6 ta oyoq orqali bogʻlangan. Har bir oyoqda 1 ta universal ($f_i = 2$), 1 ta ilgarilanma ($f_i = 1$) va 1 ta sferik ($f_i = 3$) juftlik bor.

*Yechish.* Fazoviy mexanizm uchun $m = 6$. Jami boʻgʻinlar soni: 2 ta platforma va $6 times 2 = 12$ ta oyoq boʻgʻini, yaʼni $N = 14$. Jami juftliklar soni $J = 6 times 3 = 18$. Juftliklar erkinliklari yigʻindisi:

$ sum_(i=1)^18 f_i = 6 times (2 + 1 + 3) = 36 $

$ "DoF" = 6 (14 - 1 - 18) + 36 = 6 dot (-5) + 36 = -30 + 36 = 6 $

*Javob:* Stewart--Gough platformasi 6 erkinlik darajasiga (6 DoF) ega.

== 2-topshiriq: 2R manipulyatorning ishchi sohasini hisoblash

Tekislikdagi 2R manipulyatorning boʻgʻin uzunliklari $L_1 = 0.85 "m"$ va $L_2 = 0.55 "m"$ ga teng.

#set enum(numbering: "a)")
+ Manipulyatorning maksimal erishish radiusi ($R_"out"$) va minimal radiusini ($R_"in"$) toping.
+ Ishchi soha yuzasini ($S$) hisoblang.
#set enum(numbering: "1.")

*Yechish:*

$ R_"out" = L_1 + L_2 = 0.85 + 0.55 = 1.40 "m" $

$ R_"in" = |L_1 - L_2| = |0.85 - 0.55| = 0.30 "m" $

Ishchi soha yuzasi:

$ S = pi (R_"out"^2 - R_"in"^2) = pi (1.40^2 - 0.30^2) = pi (1.96 - 0.09) = 1.87 pi approx 5.875 "m"^2 $

*Javob:* $R_"out" = 1.40 "m"$, $R_"in" = 0.30 "m"$, ishchi soha yuzasi $S approx 5.88 "m"^2$.

= Nazorat va mustaqil ish savollari

+ Avtomatlashtirishda qatʼiy (_fixed_) va moslashuvchan (_flexible_) avtomatlashtirish tizimlarining farqi nimada?
+ ISO 8373 standartiga muvofiq sanoat robotiga berilgan taʼrifni keltiring.
+ Grübler formulasi nima uchun ishlatiladi va fazoviy hamda tekislikdagi mexanizmlar uchun $m$ koʻrsatkichi qanday tanlanadi?
+ Antropomorf (_articulated_) va SCARA robotlarining tuzilishidagi farqlarni hamda asosiy qoʻllanilish sohalarini tushuntiring.
+ Robotning takrorlanuvchanligi (_repeatability_) va absolyut aniqligi (_accuracy_) oʻrtasidagi farq nima?
+ Ochiq (_serial_) va yopiq (_parallel_) kinematik zanjirli manipulyatorlarning ustunlik hamda kamchiliklarini qiyoslang.
+ Erishiladigan va epchillik ishchi sohalari nima bilan farqlanadi?
