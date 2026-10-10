// ============================================================
//  Robotlar va Robototexnik Tizimlar — 3-tajriba mashgʻuloti
//  Kompilyatsiya: typst compile rrt_tajriba_mashgulot_3.typ
// ============================================================

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let headingblue = rgb(20, 50, 120)
#let teal = rgb(53, 162, 159)
#let accent = rgb(219, 100, 0)

#set document(title: "Sanoat robotining kinematikasini oʻrganish")
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[TAJRIBA MASHGʻULOTI №3]
  #v(0.4cm)
  #text(size: 14pt, weight: "bold")[
    Mavzu: Sanoat robotining kinematikasini oʻrganish. Robot manipulyatorlarining kinematik komponovkalari va konstruktiv xususiyatlari
  ]
  #v(0.2cm)
  #text(size: 12pt, style: "italic")[1-qism: kinematik zanjir va erkinlik darajalari (DoF)]
  #v(0.5cm)
  #line(length: 100%, stroke: 1pt)
]
#v(0.3cm)

= Ishning maqsadi

*Mashgʻulotning maqsadi:* sanoat robot manipulyatorlarining kinematik tuzilishi, kinematik zanjir turlari, kinematik juftliklar hamda ularning erkinlik darajalarini (_degrees of freedom_ --- DoF) nazariy va amaliy jihatdan oʻrganish; Grübler--Kutzbach tenglamasi yordamida ochiq va yopiq zanjirli robotik mexanizmlarning harakatchanlik darajasini hisoblash koʻnikmalarini shakllantirish.

*Kutilayotgan oʻquv natijalari:*

+ Robot manipulyatorlarining kinematik zanjir va komponovka turlarini (ketma-ket, parallel, gibrid) farqlay olish.
+ Bir va koʻp erkinlikli kinematik juftliklarni (aylanma --- R, ilgarilanma --- P, silindrik --- C, sferik --- S) tasniflash.
+ Fazoviy ($m = 6$) va tekislikdagi ($m = 3$) robotik mexanizmlar uchun Grübler formulasi boʻyicha erkinlik darajasini toʻgʻri hisoblash.
+ Manipulyatorning konfiguratsiya fazosi (C-space) hamda boʻgʻinlardagi geometrik va mexanik cheklovlarni tahlil qilish.
+ Sanoat robotlarining konstruktiv elementlari (reduktorlar, podshipniklar, boʻgʻin materiallari) va ularning dinamik xususiyatlarga taʼsirini baholash.

= Kerakli asbob-uskunalar va dasturiy taʼminot

- *Laboratoriya stendi:* sanoat robotlari modellari yoki stendi (PUMA, KUKA, FANUC), ilmiy kalkulyator.
- *Dasturiy muhit:* MATLAB (Robotics System Toolbox), CoppeliaSim, ROS --- robot modellarini yuklash va kinematik tahlil uchun.

= Nazariy maʼlumotlar

== Sanoat robotlari kinematikasiga kirish

Sanoat robotining kinematikasi manipulyator boʻgʻinlarining kuch va momentlarni hisobga olmagan holdagi geometrik va vaqt boʻyicha harakatini (pozitsiya, tezlik, tezlanish) oʻrganadi. Robot manipulyatori ketma-ket yoki parallel birikkan harakatlanuvchi qattiq jismlar --- *boʻgʻinlar (links)* va ularni oʻzaro bogʻlovchi *kinematik juftliklar (joints)* majmuasidan iborat.

Kinematik tahlilda ikkita asosiy masala koʻriladi:

+ *Toʻgʻri kinematika masalasi (forward kinematics):* boʻgʻin koordinatalari ($theta_1, theta_2, dots, theta_n$) berilganda ishchi aʼzo yoki tutqichning (_Tool Center Point_ --- TCP) dekart koordinatalar sistemasidagi oʻrni va orientatsiyasini ($x, y, z, alpha, beta, gamma$) topish.
+ *Teskari kinematika masalasi (inverse kinematics):* tutqichning fazodagi berilgan oʻrni va orientatsiyasiga mos keluvchi boʻgʻin burchaklari va siljishlarini ($theta_1, theta_2, dots, theta_n$) aniqlash.

== Kinematik juftliklar va ularning turlari

Ikki qoʻshni boʻgʻinning oʻzaro nisbiy harakatiga ruxsat beruvchi harakatlanuvchi birikma *kinematik juftlik* deb ataladi. Har bir kinematik juftlik boʻgʻinlar orasida muayyan cheklovlar (_constraints_) oʻrnatadi va maʼlum erkinlik darajasini ($f_i$) beradi. Sanoat robototexnikasida eng keng tarqalgan bir erkinlikli ($f_i = 1$) juftliklar (@fig-joints):

- *Aylanma juftlik (revolute joint --- R):* faqat bitta oʻq atrofida nisbiy burilish ($f_i = 1$).
- *Ilgarilanma juftlik (prismatic joint --- P):* faqat bitta oʻq boʻylab chiziqli siljish ($f_i = 1$).
- *Vintli juftlik (helical joint --- H):* chiziqli siljish va burilish oʻzaro qatʼiy bogʻlangan birikma ($f_i = 1$).

Koʻp erkinlikli juftliklar:

- *Silindrik juftlik (cylindrical joint --- C):* bir oʻq atrofida aylanma va shu oʻq boʻylab ilgarilanma harakat ($f_i = 2$).
- *Sferik juftlik (spherical joint --- S):* bitta nuqta atrofida uch oʻlchamli burilish ($f_i = 3$).
- *Tekislik juftligi (planar joint --- E):* tekislikda ikkita chiziqli va bitta aylanma harakat ($f_i = 3$).

#figure(
  {
    set text(size: 8pt)
    cetz.canvas(length: 1cm, {
      import cetz.draw: *

      // (a) Aylanma juftlik
      rect((-0.8, -0.5), (0.8, -0.2), fill: luma(210), stroke: 0.9pt)
      rect((-0.3, -0.2), (0.3, 0.5), fill: blue.lighten(80%), stroke: 0.9pt)
      rect((-0.5, 0.5), (0.5, 1.1), fill: orange.lighten(65%), stroke: 0.9pt)
      line((0.0, 0.8), (1.5, 1.3), (1.4, 1.6), (-0.1, 1.1), close: true, fill: green.lighten(75%), stroke: 0.9pt)
      line((0, 0.1), (0, 2.0), stroke: (thickness: 0.6pt, dash: "dashed"))
      arc((0, 1.75), start: -20deg, stop: 230deg, radius: (0.45, 0.15), anchor: "origin", stroke: 1pt + accent, mark: (end: "straight"))
      content((-0.75, 1.85), text(size: 8pt, fill: accent)[$theta_1$])
      content((0.3, -0.95), text(weight: "bold")[(a) Aylanma juftlik (R)])

      // (b) Ilgarilanma juftlik
      let x0 = 5.5
      rect((x0 - 1.0, 0), (x0 + 1.0, 0.8), fill: luma(210), stroke: 0.9pt)
      rect((x0 - 0.6, 0.2), (x0 + 0.6, 0.6), fill: white, stroke: 0.6pt)
      rect((x0 - 1.5, 0.3), (x0 + 1.5, 0.5), fill: teal.lighten(55%), stroke: 0.9pt)
      line((x0 - 1.2, 1.05), (x0 + 1.2, 1.05), stroke: 1.2pt + accent, mark: (start: "straight", end: "straight"))
      content((x0, 1.35), text(size: 8pt)[$d_1$ siljish])
      content((x0, -0.95), text(weight: "bold")[(b) Ilgarilanma juftlik (P)])
    })
  },
  caption: [Eng koʻp qoʻllaniladigan bir erkinlikli kinematik juftliklar: (a) aylanma (R); (b) ilgarilanma (P)],
) <fig-joints>

== Robot manipulyatorlarining kinematik komponovkalari

Sanoat robotlari kinematik tuzilishiga (topologiyasiga) koʻra uchta asosiy guruhga boʻlinadi (@fig-chains):

+ *Ochiq kinematik zanjirli manipulyatorlar (serial / open-chain):* boʻgʻinlar asosdan (_base_) ishchi aʼzogacha (_end-effector_) ketma-ket bogʻlangan.
  - _Afzalliklari:_ ishchi zona (_workspace_) hajmi katta, epchilligi (_dexterity_) yuqori, konstruksiyasi tushunarli.
  - _Kamchiliklari:_ bikrligi (_stiffness_) nisbatan past, xatoliklar zanjir boʻylab yigʻilib boradi, yuk koʻtaruvchanligining oʻz massasiga nisbati kichik.
+ *Yopiq kinematik zanjirli robotlar (parallel / closed-chain):* ishchi aʼzo bir nechta parallel kinematik zanjirlar orqali qoʻzgʻalmas asos bilan tutashtirilgan. Masalan, Delta robotlari va Stewart--Gough platformasi (6-UPS).
  - _Afzalliklari:_ yuqori bikrlik, katta tezlik va aniqlik, yuqori yuk koʻtarish qobiliyati.
  - _Kamchiliklari:_ ishchi zona hajmi cheklangan, singulyarlik zonalari murakkab, kinematika va dinamikasi murakkab.
+ *Gibrid kinematik zanjirlar (hybrid chain):* ochiq va yopiq zanjirlar birikmasidan tashkil topgan modulli konstruksiyalar.

#figure(
  {
    set text(size: 7.5pt)
    cetz.canvas(length: 1cm, {
      import cetz.draw: *

      // (a) Ketma-ket zanjir
      line((-0.8, 0), (0.8, 0), stroke: 0.9pt)
      for i in range(6) {
        line((-0.7 + i * 0.3, 0), (-0.8 + i * 0.3, -0.2), stroke: 0.5pt)
      }
      rect((-0.5, 0), (0.5, 0.3), fill: luma(80), stroke: none)
      line((0, 0.3), (1.0, 1.8), stroke: 2.5pt + headingblue)
      line((1.0, 1.8), (2.5, 1.5), stroke: 2.5pt + headingblue)
      line((2.5, 1.5), (3.2, 2.2), stroke: 2.5pt + accent)
      line((3.2, 2.2), (3.0, 2.5), stroke: 2pt + accent)
      line((3.2, 2.2), (3.4, 2.5), stroke: 2pt + accent)
      circle((0, 0.3), radius: 0.22, fill: blue.lighten(75%), stroke: 0.8pt)
      circle((1.0, 1.8), radius: 0.2, fill: blue.lighten(75%), stroke: 0.8pt)
      circle((2.5, 1.5), radius: 0.18, fill: blue.lighten(75%), stroke: 0.8pt)
      content((0, -0.45), [Asos ($L_0$)])
      content((-0.25, 1.2), [Boʻgʻin 1 ($L_1$)])
      content((1.85, 1.95), [Boʻgʻin 2 ($L_2$)])
      content((3.7, 2.8), [Tutqich (TCP)])
      content((1.4, 3.6), text(size: 8pt, weight: "bold")[(a) Ketma-ket (ochiq) zanjir])

      // (b) Parallel zanjir
      let x0 = 6.5
      line((x0 - 0.5, 2.8), (x0 + 3.5, 2.8), (x0 + 3.3, 3.0), (x0 - 0.3, 3.0), close: true, fill: luma(200), stroke: 0.9pt)
      content((x0 + 1.5, 3.25), [Qoʻzgʻalmas asos])
      line((x0 + 0.5, 0.5), (x0 + 2.5, 0.5), (x0 + 2.3, 0.7), (x0 + 0.7, 0.7), close: true, fill: accent.lighten(70%), stroke: 0.9pt)
      content((x0 + 1.5, 0.2), [Harakatlanuvchi platforma])
      for (top, bot) in (((0.2, 2.8), (0.9, 0.6)), ((1.5, 2.8), (1.5, 0.6)), ((2.8, 2.8), (2.1, 0.6))) {
        let t = (x0 + top.at(0), top.at(1))
        let b = (x0 + bot.at(0), bot.at(1))
        line(t, b, stroke: 2.5pt + headingblue)
        circle(t, radius: 0.12, fill: blue.lighten(60%), stroke: 0.7pt)
        circle(b, radius: 0.1, fill: blue.lighten(60%), stroke: 0.7pt)
      }
      content((x0 + 1.5, 3.6), text(size: 8pt, weight: "bold")[(b) Parallel (yopiq) zanjir])
    })
  },
  caption: [Robot manipulyatorlarining kinematik komponovkalari: (a) ketma-ket ochiq zanjirli manipulyator; (b) parallel yopiq zanjirli mexanizm],
) <fig-chains>

= Erkinlik darajalari va Grübler tenglamasi

== Erkinlik darajasi tushunchasi

Mexanizmning *erkinlik darajasi (DoF / mobility)* --- uning fazodagi holatini (pozitsiya va orientatsiyasini) toʻliq va bir qiymatli aniqlash uchun zarur boʻlgan mustaqil koordinatalar soni. Erkin qattiq jism:

- tekislikda *3 ta* erkinlik darajasiga ega (2 ta chiziqli siljish $x, y$ va 1 ta burilish $theta$);
- fazoda *6 ta* erkinlik darajasiga ega (3 ta chiziqli siljish $x, y, z$ va 3 ta burilish --- _roll, pitch, yaw_ / $alpha, beta, gamma$).

Mexanizm boʻgʻinlari oʻzaro kinematik juftliklar orqali biriktirilganda, har bir juftlik erkin harakat yoʻnalishlarining maʼlum qismini cheklaydi.

== Grübler--Kutzbach formulasi

Robotik mexanizmlarning erkinlik darajasini aniqlash uchun *Grübler--Kutzbach tenglamasi* ishlatiladi:

$ "DoF" = m (N - 1 - J) + sum_(i=1)^J f_i $

bunda:

- $m$ --- ishchi fazo oʻlchamligi ($m = 3$ --- tekislikdagi, $m = 6$ --- fazoviy harakat uchun);
- $N$ --- mexanizmdagi jami boʻgʻinlar soni (qoʻzgʻalmas asos bilan birga);
- $J$ --- kinematik juftliklar soni;
- $f_i$ --- $i$-chi kinematik juftlikning erkinlik darajasi (R va P juftliklar uchun $f_i = 1$).

Agar barcha $J$ ta juftlik bir erkinlikli ($f_i = 1$) boʻlsa, formula soddalashadi:

$ "DoF" = m (N - 1 - J) + J $

=== Ochiq zanjirli (serial) robotlar uchun xususiy holat

$N - 1$ ta harakatlanuvchi boʻgʻin va $J = N - 1$ ta bir erkinlikli juftlikdan iborat ochiq zanjir uchun:

$ "DoF" = m (N - 1 - (N - 1)) + sum_(i=1)^(N-1) 1 = m dot 0 + (N - 1) = N - 1 $

Demak, *ochiq zanjirli manipulyatorning erkinlik darajasi harakatlanuvchi boʻgʻinlar (va juftliklar) soniga teng*.

== Konfiguratsiya fazosi (C-space)

Robot manipulyatorining barcha mumkin boʻlgan holatlari toʻplami uning *konfiguratsiya fazosi (C-space)* deb ataladi (@fig-cspace):

- cheklovsiz aylanadigan $n$ ta aylanma (R) boʻgʻinli robotning C-fazosi $n$ oʻlchamli tor topologiyasiga ega: $C = SS^1 times SS^1 times dots times SS^1 = TT^n$;
- ilgarilanma (P) boʻgʻin uchun esa toʻgʻri chiziq kesmasi ($RR^1$ ning qismi) olinadi.

#figure(
  {
    set text(size: 8pt)
    cetz.canvas(length: 1cm, {
      import cetz.draw: *

      // (a) Ishchi fazo
      rect((-0.3, -0.3), (0.3, 0), fill: luma(200), stroke: 0.7pt)
      line((0, 0), (1.5, 1.2), stroke: 2.5pt + headingblue)
      line((1.5, 1.2), (2.8, 0.8), stroke: 2.5pt + teal)
      circle((0, 0), radius: 0.18, fill: blue.lighten(65%), stroke: 0.7pt)
      circle((1.5, 1.2), radius: 0.14, fill: teal.lighten(55%), stroke: 0.7pt)
      circle((2.8, 0.8), radius: 0.08, fill: accent, stroke: none)
      line((0, 0), (1.3, 0), stroke: (thickness: 0.5pt, dash: "dashed"))
      arc((0, 0), start: 0deg, stop: 38deg, radius: 0.65, anchor: "origin", stroke: 0.9pt + red, mark: (end: "straight"))
      content((0.95, 0.28), text(fill: red)[$theta_1$])
      line((1.5, 1.2), (2.6, 1.2), stroke: (thickness: 0.5pt, dash: "dashed"))
      arc((1.5, 1.2), start: 0deg, stop: -17deg, radius: 0.6, anchor: "origin", stroke: 0.9pt + blue, mark: (end: "straight"))
      content((2.35, 1.42), text(fill: blue)[$theta_2$])
      content((1.4, 3.3), text(weight: "bold")[(a) Ishchi fazo (task space)])

      // (b) Konfiguratsiya fazosi
      let x0 = 5.5
      rect((x0, 0), (x0 + 3, 2.5), fill: blue.lighten(95%), stroke: 0.9pt)
      line((x0, 0), (x0 + 3.4, 0), stroke: 0.9pt, mark: (end: "straight"))
      line((x0, 0), (x0, 2.85), stroke: 0.9pt, mark: (end: "straight"))
      content((x0 + 3.0, -0.35), [$theta_1 in [0, 2 pi)$])
      content((x0 - 0.15, 3.05), [$theta_2 in [0, 2 pi)$])
      circle((x0 + 1.2, 1.0), radius: 0.08, fill: accent, stroke: none)
      line((x0 + 1.2, 0), (x0 + 1.2, 1.0), (x0, 1.0), stroke: (thickness: 0.5pt, dash: "dashed"))
      content((x0 + 2.0, 1.3), [$q = (theta_1, theta_2)$])
      content((x0 + 1.5, 3.5), text(weight: "bold")[(b) Konfiguratsiya fazosi (C-space)])
    })
  },
  caption: [2R manipulyator: (a) dekart ishchi fazosidagi holati; (b) ikki oʻlchamli $TT^2$ konfiguratsiya fazosida nuqta sifatidagi tasviri (kvadratning qarama-qarshi tomonlari aynan bir xil holatni bildiradi)],
) <fig-cspace>

= Robot manipulyatorlarining konstruktiv xususiyatlari

Robot manipulyatorining kinematik va dinamik aniqligi, yuk koʻtaruvchanligi hamda tezkorligi uning konstruktiv elementlariga bevosita bogʻliq.

== Boʻgʻinlar va konstruktiv materiallar

Sanoat robotlarining boʻgʻinlari yuqori solishtirma bikrlik (_stiffness-to-weight ratio_) va kichik inersiya momentiga ega boʻlishi lozim:

- *Alyuminiy qotishmalari (AL 6061-T6, AL 7075):* yengil va oʻrta yuklamali robotlarda keng qoʻllaniladi.
- *Toblangan poʻlat va choʻyan:* yuqori yuk koʻtaruvchi (100 kg va undan ortiq) sanoat robotlarining asosi va birinchi boʻgʻinlarida ishlatiladi.
- *Kompozit materiallar (uglerod tolasi):* oʻta yuqori tezlikda harakatlanuvchi va kichik inersiyali (Delta, SCARA) robotlarda qoʻllaniladi.

== Mexanik uzatmalar va reduktorlar

Robot boʻgʻinlaridagi servomotorlar odatda yuqori aylanish chastotasi va nisbatan kichik momentga ega. Shu sababli har bir boʻgʻinga yuqori aniqlikdagi reduktor oʻrnatiladi (@fig-module):

+ *Toʻlqinli uzatmalar (harmonic drive):* lyufti deyarli nolga teng ($< 1 "arcmin"$), bir bosqichda katta uzatish nisbatini ($1:50 dots 1:160$) beradi va oʻta ixcham.
+ *Sikloid reduktorlar (cycloidal drive / RV reducer):* katta zarbali yuklamalar va yuqori momentlarga chidamli; sanoat robotlarining asosiy (1--3) boʻgʻinlarida qoʻllaniladi.

#figure(
  {
    set text(size: 7.5pt)
    cetz.canvas(length: 1cm, {
      import cetz.draw: *

      // Korpus
      rect((-1.2, -1.0), (1.2, 2.0), fill: luma(235), stroke: 0.9pt)
      // Enkoder
      rect((-0.6, 1.55), (0.6, 1.8), fill: green.lighten(70%), stroke: 0.8pt)
      // Servomotor
      rect((-0.9, 0.5), (0.9, 1.4), fill: blue.lighten(75%), stroke: 0.8pt)
      content((0, 0.95), [Servomotor])
      // Harmonic drive
      rect((-0.9, -0.6), (0.9, 0.3), fill: orange.lighten(65%), stroke: 0.8pt)
      content((0, -0.15), align(center)[Harmonic Drive \ reduktor])
      // Chiqish vali
      rect((-0.3, -1.6), (0.3, -1.0), fill: accent, stroke: 0.8pt)
      arc((0, -1.85), start: -20deg, stop: 230deg, radius: (0.5, 0.15), anchor: "origin", stroke: 1.1pt + red, mark: (end: "straight"))

      // Izohlar
      line((0.6, 1.67), (1.7, 1.67), stroke: 0.5pt)
      content((1.75, 1.67), anchor: "west", [Optik enkoder])
      line((1.2, -0.85), (1.7, -0.85), stroke: 0.5pt)
      content((1.75, -0.85), anchor: "west", [Boʻgʻin korpusi])
      content((0.65, -1.95), anchor: "west", [Chiqish valining burilishi ($theta_i$)])
    })
  },
  caption: [Sanoat roboti boʻgʻinining tipik konstruktiv moduli],
) <fig-module>

= Grübler formulasi boʻyicha masalalar yechish

== 1-masala: tekislikdagi 3R manipulyator

*Sharti:* tekislikda harakatlanuvchi 3 ta aylanma juftlikli (3R) ochiq zanjirli manipulyatorning erkinlik darajasini aniqlang.

*Yechish:* tekislikdagi harakat boʻlgani uchun $m = 3$. Boʻgʻinlar soni: 3 ta harakatlanuvchi boʻgʻin va asos, yaʼni $N = 4$. Juftliklar soni $J = 3$ (barchasi R, $f_i = 1$). Grübler formulasini qoʻllaymiz:

$ "DoF" = m (N - 1 - J) + sum_(i=1)^J f_i = 3 times (4 - 1 - 3) + (1 + 1 + 1) = 3 times 0 + 3 = 3 $

*Javob:* $"DoF" = 3$. Manipulyator tekislikdagi obyektning $x, y$ koordinatalarini va burilish burchagi $phi$ ni toʻliq boshqara oladi.

== 2-masala: fazoviy 6R PUMA-560 sanoat roboti

*Sharti:* 6 ta aylanma juftlikli (6R) PUMA-560 sanoat manipulyatorining erkinlik darajasini hisoblang.

*Yechish:* fazoviy harakat uchun $m = 6$; boʻgʻinlar soni $N = 6 + 1 = 7$; juftliklar soni $J = 6$, har biri $f_i = 1$:

$ "DoF" = 6 times (7 - 1 - 6) + sum_(i=1)^6 1 = 6 times 0 + 6 = 6 $

*Javob:* $"DoF" = 6$. PUMA-560 fazoda ixtiyoriy pozitsiya ($x, y, z$) va orientatsiyani ($alpha, beta, gamma$) egallay oladi.

== 3-masala: Stewart--Gough parallel platformasi (6-UPS)

*Sharti:* Stewart--Gough platformasi qoʻzgʻalmas asos va harakatlanuvchi platformadan iborat boʻlib, ular uzunligi oʻzgaruvchan 6 ta parallel oyoq orqali bogʻlangan. Har bir oyoq asosga universal ($U$, $f = 2$), platformaga sferik ($S$, $f = 3$) juftlik bilan birikkan, oʻrtasida esa ilgarilanma ($P$, $f = 1$) juftlik bor. Platformaning erkinlik darajasini toping.

*Yechish:*

- fazoviy harakat: $m = 6$;
- boʻgʻinlar soni: asos (1) + platforma (1) + har bir oyoqda 2 tadan boʻgʻin ($6 times 2 = 12$), yaʼni $N = 14$;
- juftliklar soni: 6 ta U, 6 ta P, 6 ta S, yaʼni $J = 18$;
- erkinlik darajalari yigʻindisi:

$ sum f_i = 6 f_U + 6 f_P + 6 f_S = 6 times 2 + 6 times 1 + 6 times 3 = 12 + 6 + 18 = 36 $

Grübler formulasi boʻyicha:

$ "DoF" = 6 times (14 - 1 - 18) + 36 = 6 times (-5) + 36 = -30 + 36 = 6 $

*Javob:* Stewart--Gough platformasi $"DoF" = 6$ ga ega fazoviy parallel robot.

= Tajriba mashgʻulotini bajarish tartibi

== 1-bosqich: kinematik sxemalarni tahlil qilish

+ Laboratoriya stendidagi yoki simulyatordagi robot modelini (KUKA KR6, FANUC LR Mate, ABB IRB 120) koʻzdan kechiring.
+ Robot asosidan tutqichgacha barcha boʻgʻinlarni ($L_0, L_1, dots, L_n$) raqamlang.
+ Har bir kinematik juftlik turini (R yoki P) va uning harakat oʻqini aniqlang.

== 2-bosqich: erkinlik darajasini analitik va simulyatsion aniqlash

+ Berilgan manipulyator uchun Grübler formulasini yozing va $N, J, f_i$ qiymatlarini qoʻyib DoF ni hisoblang.
+ MATLAB Robotics System Toolbox yoki CoppeliaSim muhitida robot modelini yuklang.
+ Dasturdagi boʻgʻin oʻzgaruvchilari vektori ($q = [q_1, q_2, dots, q_n]^T$) oʻlchami analitik hisoblangan DoF ga mos kelishini tekshiring.

== 3-bosqich: boʻgʻin cheklovlari va C-space tahlili

+ Har bir boʻgʻinning harakat chegaralarini ($theta_(i,min) <= theta_i <= theta_(i,max)$) @tab-joints ga kiriting.
+ Boʻgʻin cheklovlari hisobiga konfiguratsiya fazosining haqiqiy sohasi va chegaralarini aniqlang.

#figure(
  {
    set text(size: 9.5pt)
    set par(justify: false)
    table(
      columns: (auto, 1fr, 1fr, 1fr, 1fr),
      align: center + horizon,
      stroke: none,
      inset: (x: 4pt, y: 5pt),
      table.hline(stroke: 1pt),
      table.header(
        [*Boʻgʻin \ №*], [*Juftlik turi*], [*Harakat \ diapazoni*], [*Reduktor turi*], [*Datchik turi*],
      ),
      table.hline(stroke: 0.5pt),
      [1], [Aylanma (R)], [$-170 degree dots +170 degree$], [Sikloid (RV)], [Absolyut enkoder],
      [2], [Aylanma (R)], [$-100 degree dots +135 degree$], [Sikloid (RV)], [Absolyut enkoder],
      [3], [Aylanma (R)], [$-210 degree dots +65 degree$], [Harmonic Drive], [Absolyut enkoder],
      [4], [Aylanma (R)], [$-180 degree dots +180 degree$], [Harmonic Drive], [Inkremental enkoder],
      [5], [Aylanma (R)], [$-125 degree dots +125 degree$], [Harmonic Drive], [Inkremental enkoder],
      [6], [Aylanma (R)], [$-360 degree dots +360 degree$], [Harmonic Drive], [Inkremental enkoder],
      table.hline(stroke: 1pt),
    )
  },
  caption: [Robot boʻgʻinlarining kinematik va konstruktiv koʻrsatkichlari (namuna)],
) <tab-joints>

= Nazorat savollari

+ Kinematik juftlik nima va u erkin qattiq jism harakatini qanday cheklaydi?
+ Bir erkinlik darajali ($f_i = 1$) kinematik juftliklarga qaysi birikmalar kiradi?
+ Fazoviy ($m = 6$) va tekislikdagi ($m = 3$) mexanizmlar uchun Grübler formulasining farqi nimada?
+ Ketma-ket (serial) va parallel robot manipulyatorlarining konstruktiv afzalliklari va kamchiliklarini solishtiring.
+ Konfiguratsiya fazosi (C-space) bilan dekart ishchi fazosi (task space) oʻrtasidagi farqni tushuntiring.
+ Reduktorlardagi lyuft (_backlash_) robot tutqichining aniqligiga qanday taʼsir koʻrsatadi va u qanday kamaytiriladi?
+ Nima uchun koʻpchilik sanoat robotlari 6 ta erkinlik darajasiga (6 DoF) ega qilib loyihalanadi?
