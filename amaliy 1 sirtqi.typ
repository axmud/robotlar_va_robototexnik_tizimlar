// ============================================================
//  Robotlar va robototexnik tizimlar — 1-amaliy mashgʻulot (sirtqi taʼlim) — Typst versiyasi
//  Kompilyatsiya: typst compile amaliy_1_sirtqi.typ
// ============================================================

#import "@preview/cetz:0.4.2"

#let headingblue = rgb(20, 50, 120)

#set document(title: "Avtomatlaştirişda robotlarning roli. Robotlar haqida umumiy tuşunçalar va taʼriflar")
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
    info.fan, info.semestr, [Amaliyot №#raqam (sirtqi)],
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
  #text(size: 20pt, weight: "bold", fill: headingblue)[AMALIYOT MAŞĞULOTI №#raqam]
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

*Maşğulotning maqsadi:* talabalarni işlab çiqarişni avtomatlaştirişda robotlarning örni, robototexnikaning asosiy atamalari va xalqaro standartlardagi taʼriflar, robotlarning rivojlaniş tarixi, avlodlari va tasnifi bilan taniştiriş, şuningdek robotlaştiriş darajasi, iqtisodiy samaradorlik va manipulyatorning kinematik körsatkiçlarini hisoblaş könikmalarini şakllantiriş.

*Öquv vazifalari va kutilayotgan natijalar:*

- *Atamalar:* robot, sanoat roboti, xizmat körsatuvçi robot, manipulyator, robototexnik tizim tuşunçalarini ISO 8373 standarti asosida farqlaş.
- *Avtomatlaştiriş:* qatʼiy, dasturlanadigan va moslaşuvçan avtomatlaştiriş turlarini taqqoslaş, robotlarning ulardagi örnini tuşuntiriş.
- *Tasnif:* robotlarni avlodlari, qöllaniş sohasi va kinematik tuzilişi böyiça tasniflaş.
- *Hisob-kitob:* robotlaştiriş ziçligini, robotni joriy etişning özini oqlaş muddatini, manipulyatorning erkinlik darajalari sonini va işçi zona hajmini aniqlaş.

= Nazariy asoslar va analitik formulalar

== Avtomatlaştiriş va robotlarning örni

*Avtomatlaştiriş* --- texnologik jarayonlarni bajariş, boşqariş va nazorat qilişda inson iştirokini kamaytiriş yoki butunlay istisno qiliş maqsadida texnik vositalardan foydalaniş. Işlab çiqarişni avtomatlaştiriş odatda uç turga ajratiladi (@tab-auto):

#figure(
  btable(
    columns: (auto, 1.3fr, 1.2fr, 0.8fr),
    align: (left + horizon, left + horizon, left + horizon, left + horizon),
    ([*Turi*], [*Tavsifi*], [*Afzalligi va kamçiligi*], [*Işlab çiqariş \ turi*]),
    [Qatʼiy \ (_fixed_)],
    [Jihozlar konfiguratsiyasi bitta mahsulot uçun qatʼiy belgilangan (avtomatik liniyalar, agregat stanoklar)],
    [Unumdorlik juda yuqori; mahsulot özgarganda qayta jihozlaş qimmat va uzoq],
    [Ommaviy],
    [Dasturlanadigan \ (_programmable_)],
    [Jihozlar yangi dastur yuklaş orqali boşqa mahsulotga qayta sozlanadi (CNC stanoklar, sanoat robotlari)],
    [Turli mahsulotlar uçun moslaşadi; qayta sozlaşda töxtab qoliş vaqti mavjud],
    [Seriyali],
    [Moslaşuvçan \ (_flexible_)],
    [Turli mahsulotlar qayta sozlaş uçun töxtaşsiz ketma-ket işlab çiqariladi (moslaşuvçan işlab çiqariş tizimlari)],
    [Moslaşuvçanlik eng yuqori; boşlanğiç investitsiya katta],
    [Kiçik seriyali, köp nomenklaturali],
  ),
  caption: [Işlab çiqarişni avtomatlaştiriş turlari],
  placement: auto,
) <tab-auto>

Sanoat roboti *dasturlanadigan avtomatlaştirişning* asosiy vositasi va *moslaşuvçan işlab çiqariş tizimlarining* markaziy elementi hisoblanadi: u yangi dastur va işçi organni almaştiriş orqali boşqa vazifaga tez moslaşadi. Robotlar quyidagi hollarda ayniqsa samarali: oğir, zararli va xavfli şaroitdagi işlar (payvandlaş, böyaş, quyiş, issiq ştamplaş); bir xil harakatlar köp marta takrorlanadigan monoton operatsiyalar; inson imkoniyatidan yuqori aniqlik, tezlik yoki barqarorlik talab etiladigan jarayonlar (elektronika yiğiş, lazerli kesiş); toza xonalar va steril muhitdagi işlar.

*Robotlaştiriş darajasi* xalqaro miqyosda *robot ziçligi* bilan baholanadi --- qayta işlaş sanoatida band bölgan har 10 000 xodimga töğri keladigan işlayotgan sanoat robotlari soni:

$ rho = N_r / N_x dot 10 thin 000 $ <eq-density>

bunda $N_r$ --- işlayotgan robotlar soni, $N_x$ --- xodimlar soni. Xalqaro robototexnika federatsiyasi (IFR) maʼlumotlariga köra, 2024-yilda dunyoda 542 076 ta sanoat roboti örnatilgan, bu ön yil avvalgidan ikki baravardan köp. Dunyo böyiça örtaça robot ziçligi 2023-yilda 10 000 xodimga 162 ta robotni taşkil etgan va yetti yil içida ikki baravardan köproq oşgan. 2024-yilda mintaqalar böyiça bu körsatkiç Ğarbiy Yevropada 267 ta, Şimoliy Amerikada 204 ta va Osiyoda 131 ta bölgan.

== Asosiy atamalar va taʼriflar

“Robot” sözi birinçi marta çex yozuvçisi Karel Çapekning 1920-yilda yozilgan “R.U.R.” (“Rossumning universal robotlari”) pyesasida qöllanilgan va çex tilidagi _robota_ (“majburiy mehnat”) sözidan kelib çiqqan. Robototexnikadagi atamalar xalqaro *ISO 8373:2021* “Robototexnika. Luğat” standartida belgilangan; asosiylari @tab-terms da keltirilgan.

#figure(
  btable(
    columns: (auto, 1fr),
    align: (left + horizon, left + horizon),
    ([*Atama*], [*Taʼrifi (ISO 8373:2021 asosida)*]),
    [Robot],
    [Harakatlaniş, manipulyatsiya yoki joylaştiriş vazifalarini bajariş uçun maʼlum darajada avtonomlikka ega bölgan, dasturlangan va yuritmalar bilan harakatlantiriladigan mexanizm],
    [Sanoat roboti],
    [Avtomatik boşqariladigan, qayta dasturlanadigan, köp maqsadli, uç yoki undan ortiq öq böyiça dasturlanadigan manipulyator; u bir joyga mahkamlangan yoki mobil platformaga örnatilgan bölib, sanoat muhitida avtomatlaştiriş uçun işlatiladi],
    [Xizmat körsatuvçi robot],
    [Şaxsiy yoki professional maqsadlarda inson yoki jihozlar uçun foydali vazifalarni bajaradigan robot],
    [Manipulyator],
    [Obyektlarni (detallar, asboblar) uşlab oliş va/yoki köçiriş uçun möljallangan, özaro boğlangan va bir-biriga nisbatan aylanadigan yoki siljiydigan segmentlardan iborat mexanizm],
    [Avtonomlik],
    [Inson aralaşuvisiz, joriy holat va sezgilar asosida belgilangan vazifalarni bajariş qobiliyati],
    [Robototexnik tizim],
    [Robot(lar), işçi organ(lar) va robotning vazifasini bajarişi uçun zarur bölgan har qanday maşina, jihoz va datçiklardan taşkil topgan tizim],
  ),
  caption: [Robototexnikaning asosiy atamalari],
  placement: auto,
) <tab-terms>

Robotning manipulyatordan asosiy farqi --- *qayta dasturlanişi*: oddiy avtooperator (“qattiq dasturli manipulyator”) mexanik tayançlar yordamida bitta siklni bajaradi, robot esa dasturni özgartiriş orqali yangi vazifaga ötkaziladi. Har qanday robototexnik tizim quyidagi asosiy qismlardan taşkil topadi (@fig-struct).

#figure(
  cetz.canvas(length: 0.9cm, {
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
      content(c, align(center, text(size: 8.5pt, body)))
    }
    let ar(..pts) = line(..pts, stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.55))
    let lb(p, body, anchor: "south") = content(p, text(size: 7.5pt, fill: cacc, body), anchor: anchor)

    bx((1.3, 3.0), 2.6, 1.0)[Operator, \ dastur]
    bx((5.3, 3.0), 3.0, 1.0, fill: csec.lighten(85%))[*Boşqaruv tizimi*]
    bx((9.1, 3.0), 2.2, 1.0)[Yuritmalar]
    bx((13.2, 3.0), 2.8, 1.0, fill: cacc.lighten(88%))[*Manipulyator* \ (mexanik tizim)]
    bx((9.1, 1.0), 2.2, 1.0)[Sensorlar]
    bx((13.2, 1.0), 2.8, 1.0)[Işçi organ \ (qisqiç, asbob)]
    bx((13.2, -1.0), 3.4, 0.9, fill: luma(240))[Obyekt, taşqi muhit]

    ar((2.6, 3.0), (3.8, 3.0))
    ar((6.8, 3.0), (8.0, 3.0))
    lb((7.4, 3.05), [buyruq])
    ar((10.2, 3.0), (11.8, 3.0))
    lb((11.0, 3.05), [moment])
    ar((13.2, 2.5), (13.2, 1.5))
    line((13.2, 0.5), (13.2, -0.55), stroke: 0.8pt, mark: (start: ">", end: ">", fill: black, scale: 0.55))
    ar((11.8, 1.0), (10.2, 1.0))
    lb((11.0, 0.95), [holat, kuç], anchor: "north")
    line((11.5, -1.0), (9.1, -1.0), stroke: 0.8pt)
    ar((9.1, -1.0), (9.1, 0.5))
    lb((10.3, -0.95), [taşqi maʼlumot])
    line((8.0, 1.0), (5.3, 1.0), stroke: 0.8pt)
    ar((5.3, 1.0), (5.3, 2.5))
    lb((6.65, 1.05), [teskari aloqa])
  }),
  caption: [Robototexnik tizimning umumlaşgan tuziliş sxemasi],
  placement: auto,
) <fig-struct>

== Robotlarning rivojlaniş tarixi va avlodlari

Robototexnika rivojidagi asosiy bosqiçlar @fig-history da keltirilgan. 1954-yilda amerikalik ixtiroçi Jorj Devol dasturlanadigan manipulyatorga patent talabnomasi bergan; u Jozef Engelberger bilan birga Unimation kompaniyasiga asos solgan va 1961-yilda birinçi *Unimate* sanoat roboti General Motors zavodida quyma detallar bilan işlaş uçun örnatilgan.

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let ev = (
      ([1920], [“R.U.R.” pyesasi: \ “robot” sözi]),
      ([1942], [A. Azimov: \ robototexnika qonunlari]),
      ([1954], [J. Devol patent \ talabnomasi]),
      ([1961], [Unimate: birinçi \ sanoat roboti (GM)]),
      ([1973], [KUKA Famulus: \ 6 elektromexanik öq]),
      ([1978], [PUMA roboti \ (Unimation)]),
      ([2008], [UR5: kollaborativ \ robotlar davri]),
      ([2024], [Dunyoda 542 ming \ robot örnatildi]),
    )
    line((-0.3, 0), (15.0, 0), stroke: 1.4pt + cprim, mark: (end: ">", fill: cprim, scale: 0.7))
    for (k, e) in ev.enumerate() {
      let x = 0.5 + k * 2.0
      let up = calc.rem(k, 2) == 0
      circle((x, 0), radius: 0.12, fill: cacc, stroke: none)
      content((x, if up { -0.2 } else { 0.2 }), text(size: 9pt, weight: "bold", e.at(0)), anchor: if up {
        "north"
      } else { "south" })
      line((x, if up { 0.15 } else { -0.15 }), (x, if up { 0.7 } else { -0.7 }), stroke: (
        paint: luma(140),
        thickness: 0.6pt,
      ))
      content(
        (x, if up { 0.75 } else { -0.75 }),
        align(center, text(size: 7.5pt, e.at(1))),
        anchor: if up { "south" } else { "north" },
      )
    }
  }),
  caption: [Robototexnika rivojlanişining asosiy bosqiçlari],
) <fig-history>

Boşqaruv tizimining “intellekt” darajasiga köra robotlar uç avlodga ajratiladi:

+ *Birinçi avlod (dasturlanadigan robotlar):* oldindan berilgan qatʼiy dastur böyiça işlaydi, taşqi muhit özgarişini sezmaydi; obyektlar aniq belgilangan joyda turişi şart.
+ *Ikkinçi avlod (adaptiv, sezgir robotlar):* kuç-moment, texnik köriş, yaqinlik datçiklari yordamida muhit haqida maʼlumot oladi va harakatini şunga moslab özgartiradi.
+ *Uçinçi avlod (intellektual robotlar):* muhitni idrok etadi, vazifani tuşunadi, harakatlar ketma-ketligini mustaqil rejalaştiradi va tajribadan örganadi (sunʼiy intellekt usullari).

== Robotlarning tasnifi

Robotlar *qöllaniş sohasi* böyiça sanoat robotlari (payvandlaş, böyaş, yiğiş, yuklaş-tuşiriş, stanoklarga xizmat körsatiş) va xizmat körsatuvçi robotlarga (tibbiy, logistika, qişloq xöjaligi, maişiy) bölinadi; *harakatlaniş qobiliyati* böyiça statsionar va mobil robotlarga ajratiladi. Manipulyatorlar uçun eng muhim tasnif belgisi --- *kinematik tuzilişi*. U pozitsiyalaşni taʼminlovçi dastlabki uçta böğin turiga qarab aniqlanadi: $R$ --- aylanma (_revolute_), $P$ --- ilgarilanma (_prismatic_) böğin (@tab-kin).

#figure(
  btable(
    columns: (auto, auto, 1fr, 1fr),
    align: (left + horizon, center + horizon, left + horizon, left + horizon),
    ([*Tuziliş turi*], [*Böğinlar \ kodi*], [*Işçi zona şakli*], [*Tipik qöllanişi*]),
    [Dekart (portal)],
    [$P P P$],
    [Töğri burçakli parallelepiped],
    [Yuklaş-tuşiriş, 3D-printer, portal manipulyatorlar],
    [Silindrik],
    [$R P P$],
    [Içi böş silindr (sektor)],
    [Stanoklarga xizmat körsatiş, yiğiş],
    [Sferik (qutbli)],
    [$R R P$],
    [Sfera qatlami],
    [Nuqtali payvandlaş, quyiş (Unimate)],
    [SCARA],
    [$R R P$ \ (vertikal öqlar)],
    [Silindrsimon],
    [Elektronika yiğiş, tez joylaştiriş],
    [Antropomorf (burçakli)],
    [$R R R$],
    [Murakkab şakldagi sfera qismi],
    [Payvandlaş, böyaş, universal işlar (PUMA, KUKA)],
    [Parallel (delta)],
    [Yopiq zanjir],
    [Gumbazsimon],
    [Saralaş, qadoqlaş (yuqori tezlik)],
  ),
  caption: [Manipulyatorlarning kinematik tuzilişi böyiça tasnifi],
) <tab-kin>

*Erkinlik darajalari soni.* Fazoviy mexanizm uçun Somov–Malişev formulasi qöllaniladi ($n$ --- harakatlanuvçi zvenolar soni, $p_k$ --- $k$-sinf kinematik juftliklar soni):

$ W = 6 n - 5 p_5 - 4 p_4 - 3 p_3 - 2 p_2 - p_1 $ <eq-somov>

Oçiq kinematik zanjirli (ketma-ket) manipulyatorda har bir harakatlanuvçi zveno bitta V sinf juftlik ($R$ yoki $P$) bilan ulanadi, yaʼni $p_5 = n$, şuning uçun $W = 6n - 5n = n$: erkinlik darajalari soni böğinlar soniga teng. Işçi organni fazoda ixtiyoriy holat va orientatsiyaga keltiriş uçun $W = 6$ talab etiladi; $W > 6$ bölgan manipulyator *ortiqça* (_redundant_) deyiladi.

*Işçi zona hajmi.* Dekart va silindrik robotlarning işçi zonasi hajmi quyidagiça hisoblanadi ($L_x, L_y, L_z$ --- öqlar böylab yuriş, $r_min, r_max$ --- radial yuriş çegaralari, $h$ --- vertikal yuriş, $phi$ --- asosning buriliş burçagi):

$ V_"Dek" = L_x L_y L_z, quad V_"sil" = pi (r_max^2 - r_min^2) h dot phi / (360 degree) $ <eq-volume>

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(content: (padding: 2pt))
    let r1 = 1.0
    let r2 = 2.8
    let a0 = -150
    let a1 = 150
    let pts = ()
    for k in range(0, 31) {
      let a = (a0 + k * (a1 - a0) / 30) * 1deg
      pts.push((r2 * calc.cos(a), r2 * calc.sin(a)))
    }
    for k in range(0, 31) {
      let a = (a1 - k * (a1 - a0) / 30) * 1deg
      pts.push((r1 * calc.cos(a), r1 * calc.sin(a)))
    }
    line(..pts, close: true, fill: csec.lighten(80%), stroke: 1pt + csec)
    circle((0, 0), radius: 0.35, fill: luma(200), stroke: 1pt)
    // r_min, r_max
    line((0, 0), (r1 * calc.cos(60deg), r1 * calc.sin(60deg)), stroke: 0.8pt + cacc, mark: (
      end: ">",
      fill: cacc,
      scale: 0.5,
    ))
    content((0.15, 0.75), text(size: 9pt)[$r_min$], anchor: "east")
    line((0, 0), (r2 * calc.cos(20deg), r2 * calc.sin(20deg)), stroke: 0.8pt + cacc, mark: (
      end: ">",
      fill: cacc,
      scale: 0.5,
    ))
    content((2.1, 0.55), text(size: 9pt)[$r_max$], anchor: "south")
    // phi
    arc((0, 0), start: -150deg, stop: 150deg, radius: 0.6, anchor: "origin", stroke: 0.7pt, mark: (
      end: ">",
      fill: black,
      scale: 0.4,
    ))
    content((-0.75, 0.0), text(size: 9pt)[$phi$], anchor: "east")
    content((0, -3.3), text(size: 9pt)[yuqoridan köriniş])

    // Yon koʻrinish
    let x0 = 5.0
    rect((x0 + r1, -1.0), (x0 + r2, 1.0), fill: csec.lighten(80%), stroke: 1pt + csec)
    line((x0, -2.0), (x0, 1.8), stroke: (paint: luma(120), dash: "dash-dotted", thickness: 0.6pt))
    rect((x0 - 0.3, -1.6), (x0 + 0.3, 1.3), fill: luma(220), stroke: 1pt)
    line((x0 + r2 + 0.4, -1.0), (x0 + r2 + 0.4, 1.0), stroke: 0.8pt + cacc, mark: (
      start: ">",
      end: ">",
      fill: cacc,
      scale: 0.5,
    ))
    content((x0 + r2 + 0.5, 0), text(size: 9pt)[$h$], anchor: "west")
    line((x0, -1.85), (x0 + r1, -1.85), stroke: 0.8pt + cacc, mark: (end: ">", fill: cacc, scale: 0.5))
    content((x0 + r1 / 2, -1.9), text(size: 8pt)[$r_min$], anchor: "north")
    line((x0, 1.35), (x0 + r2, 1.35), stroke: 0.8pt + cacc, mark: (end: ">", fill: cacc, scale: 0.5))
    content((x0 + 2.0, 1.4), text(size: 8pt)[$r_max$], anchor: "south")
    content((x0 + 1.5, -3.3), text(size: 9pt)[yon köriniş])
  }),
  caption: [Silindrik robotning işçi zonasi],
  placement: auto,
) <fig-zone>

== Robotlaştirişning iqtisodiy samaradorligi

Robotni joriy etiş samaradorligining eng sodda körsatkiçi --- investitsiyalarning *özini oqlaş muddati*:

$ T_"öq" = K / (Delta S_"iş" - C_"ek" + Delta P) $ <eq-payback>

bunda $K$ --- robototexnik kompleksga kapital xarajatlar (robot, işçi organ, xavfsizlik tösiqlari, örnatiş va dasturlaş); $Delta S_"iş"$ --- ozod qilingan işçilarga yillik iş haqi va ijtimoiy tölovlarning tejalişi; $C_"ek"$ --- robotning yillik ekspluatatsiya xarajatlari (elektr energiyasi, texnik xizmat, ehtiyot qismlar); $Delta P$ --- unumdorlik oşişi va brak kamayişi hisobiga qöşimça yillik foyda. Işlab çiqarişda özini oqlaş muddati odatda 2–4 yil bölgan loyihalar maqsadga muvofiq hisoblanadi.

= Namunaviy masalalar va ularning yeçimlari

== Masala 1: Korxonaning robotlaştiriş ziçligi

*Masala şarti:* maşinasozlik korxonasida $N_x = 840$ nafar xodim işlaydi va $N_r = 21$ ta sanoat roboti işlatiladi.

#set enum(numbering: "a)")
+ Korxonaning robot ziçligini hisoblang va uni dunyo örtaça körsatkiçi (162 ta, 2023-yil) hamda Ğarbiy Yevropa körsatkiçi (267 ta, 2024-yil) bilan soliştiring.
+ Xodimlar soni özgarmagan holda ziçlikni 300 taga yetkaziş uçun neçta qöşimça robot kerakligini aniqlang.
#set enum(numbering: "1.")

*Hisoblaş bosqiçlari:*

- *Robot ziçligi* (@eq-density):
  $ rho = 21 / 840 dot 10 thin 000 = 250 $
  Bu dunyo örtaça körsatkiçidan $250 \/ 162 approx 1.54$ marta yuqori, ammo Ğarbiy Yevropa körsatkiçidan biroz past.

- *Maqsadli ziçlik uçun robotlar soni:*
  $ N_r^* = (rho^* N_x) / (10 thin 000) = (300 dot 840) / (10 thin 000) = 25.2 arrow 26 $
  Qöşimça robotlar soni: $26 - 21 = 5$ ta (natija butun songa yuqoriga yaxlitlanadi).

*Javob:* $rho = 250$ ta robot/10 000 xodim; 5 ta qöşimça robot.

== Masala 2: Robotlaştirilgan payvandlaş katagining özini oqlaş muddati

*Masala şarti:* korxona qölda bajariladigan payvandlaş postini robotlaştirilgan katakka almaştirmoqçi. Kapital xarajatlar $K = 900$ mln söm. Robot ikki smenada işlaydi va har smenada ikki nafardan, jami 4 nafar payvandçini ozod qiladi; bir işçiga yillik xarajat (iş haqi va ijtimoiy tölovlar) 60 mln söm. Robotning yillik ekspluatatsiya xarajatlari $C_"ek" = 40$ mln söm, unumdorlik oşişi va brak kamayişidan qöşimça foyda $Delta P = 60$ mln söm/yil. (Qiymatlar öquv maqsadida şartli olingan.)

*Hisoblaş bosqiçlari:*

- *Iş haqining tejalişi:*
  $ Delta S_"iş" = 4 dot 60 = 240 "mln söm/yil" $

- *Yillik sof tejamkorlik:*
  $ E = Delta S_"iş" - C_"ek" + Delta P = 240 - 40 + 60 = 260 "mln söm/yil" $

- *Özini oqlaş muddati* (@eq-payback):
  $ T_"öq" = 900 / 260 approx 3.46 "yil" approx 3 "yil" 6 "oy" $
  Muddat 2–4 yil oraliğida, demak loyiha iqtisodiy jihatdan maqsadga muvofiq.

*Javob:* $E = 260$ mln söm/yil; $T_"öq" approx 3.5$ yil.

== Masala 3: Manipulyatorning tuzilişi va işçi zonasi

*Masala şarti:* manipulyatorning böğinlari kodi $R P P - R R$ (birinçi uçtasi pozitsiyalovçi, keyingilari orientatsiyalovçi böğinlar). Uning işçi zonasi parametrlari: $r_min = 0.3$ m, $r_max = 1.2$ m, $h = 0.8$ m, $phi = 300 degree$.

#set enum(numbering: "a)")
+ Manipulyatorning kinematik tuziliş turini aniqlang.
+ Erkinlik darajalari sonini @eq-somov böyiça hisoblang.
+ Işçi zona hajmini toping.
#set enum(numbering: "1.")

*Hisoblaş bosqiçlari:*

- *Tuziliş turi.* Pozitsiyalovçi böğinlar $R P P$: asosning aylanişi, vertikal va radial siljiş. @tab-kin ga köra bu *silindrik* robot.

- *Erkinlik darajalari soni.* Harakatlanuvçi zvenolar $n = 5$, har biri V sinf juftlik bilan ulangan: $p_5 = 5$.
  $ W = 6 dot 5 - 5 dot 5 = 5 $
  $W < 6$ bölgani uçun işçi organning orientatsiyasi çeklangan: uçta orientatsiya burçagidan faqat ikkitasi mustaqil boşqariladi.

- *Işçi zona hajmi* (@eq-volume):
  $
    V = pi (1.2^2 - 0.3^2) dot 0.8 dot (300 degree) / (360 degree) \
    = pi dot 1.35 dot 0.8 dot 0.8333 approx 2.83 "m"^3
  $

*Javob:* silindrik robot; $W = 5$; $V approx 2.83 "m"^3$.

= Individual amaliy topşiriqlar

Har bir talaba öz variant raqamiga mos maʼlumotlar (@tab-var1 va @tab-var2) böyiça quyidagilarni bajarişi lozim:

+ Korxonaning robot ziçligini hisoblaş, uni dunyo örtaça körsatkiçi bilan soliştiriş va maqsadli ziçlik $rho^*$ ga erişiş uçun zarur qöşimça robotlar sonini aniqlaş.
+ Robotlaştiriş loyihasining yillik sof tejamkorligini va özini oqlaş muddatini hisoblaş, loyihaning maqsadga muvofiqligi haqida xulosa çiqariş.
+ Berilgan böğinlar kodi böyiça manipulyatorning kinematik tuziliş turini aniqlaş va erkinlik darajalari sonini hisoblaş.
+ Silindrik robotning berilgan parametrlari böyiça işçi zona hajmini hisoblaş.
+ 1–4-bandlar natijalarini Python dasturi yordamida tekşiriş.

#figure(
  btable(
    columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto),
    (
      [*Var.*],
      [*$N_x$ \ \[nafar\]*],
      [*$N_r$ \ \[dona\]*],
      [*$rho^*$*],
      [*$K$ \ \[mln söm\]*],
      [*Ozod qilingan \ işçilar*],
      [*1 işçiga \ \[mln söm/yil\]*],
      [*$C_"ek"$ \ \[mln söm\]*],
      [*$Delta P$ \ \[mln söm\]*],
    ),
    [*1*],
    [620],
    [9],
    [200],
    [750],
    [3],
    [54],
    [35],
    [40],
    [*2*],
    [1450],
    [38],
    [300],
    [1200],
    [4],
    [60],
    [50],
    [80],
    [*3*],
    [380],
    [4],
    [150],
    [600],
    [2],
    [58],
    [30],
    [70],
    [*4*],
    [2100],
    [65],
    [350],
    [1500],
    [6],
    [56],
    [70],
    [60],
    [*5*],
    [950],
    [18],
    [250],
    [800],
    [3],
    [62],
    [40],
    [50],
    [*6*],
    [500],
    [12],
    [300],
    [950],
    [4],
    [55],
    [45],
    [30],
    [*7*],
    [1700],
    [24],
    [200],
    [1100],
    [5],
    [57],
    [60],
    [90],
    [*8*],
    [720],
    [15],
    [260],
    [680],
    [2],
    [64],
    [32],
    [85],
    [*9*],
    [1250],
    [44],
    [400],
    [1300],
    [4],
    [59],
    [55],
    [100],
    [*10*],
    [880],
    [7],
    [120],
    [700],
    [3],
    [52],
    [38],
    [45],
  ),
  caption: [Individual topşiriqlar: robotlaştiriş ziçligi va iqtisodiy samaradorlik],
  placement: auto,
) <tab-var1>

= Nazorat savollari

+ Qatʼiy, dasturlanadigan va moslaşuvçan avtomatlaştiriş qanday farqlanadi? Sanoat roboti qaysi turga tegişli?
+ Robot ziçligi qanday aniqlanadi va u nimani körsatadi?
+ ISO 8373 standartiga köra robot va sanoat roboti qanday taʼriflanadi?
+ Robotning oddiy avtooperatordan (qattiq dasturli manipulyatordan) asosiy farqi nimada?
+ Robototexnik tizim qanday asosiy qismlardan taşkil topadi?
+ Robotlarning uç avlodini tavsiflang.
+ Manipulyatorlar kinematik tuzilişi böyiça qanday turlarga bölinadi? Har biriga misol keltiring.
+ Oçiq kinematik zanjirli manipulyatorning erkinlik darajalari soni nimaga teng? Qanday manipulyator ortiqça deyiladi?

#figure(
  btable(
    columns: (auto, auto, auto, auto, auto, auto),
    (
      [*Var.*],
      [*Böğinlar kodi*],
      [*$r_min$ \ \[m\]*],
      [*$r_max$ \ \[m\]*],
      [*$h$ \ \[m\]*],
      [*$phi$*],
    ),
    [*1*],
    [$R R R - R R R$],
    [0.25],
    [1.00],
    [0.60],
    [$270 degree$],
    [*2*],
    [$P P P - R R$],
    [0.30],
    [1.40],
    [0.90],
    [$300 degree$],
    [*3*],
    [$R P P - R R R$],
    [0.20],
    [0.90],
    [0.50],
    [$330 degree$],
    [*4*],
    [$R R P - R R R$],
    [0.35],
    [1.50],
    [1.00],
    [$240 degree$],
    [*5*],
    [$R R P$ (SCARA) $- R$],
    [0.15],
    [0.80],
    [0.40],
    [$300 degree$],
    [*6*],
    [$R R R - R R$],
    [0.40],
    [1.60],
    [1.20],
    [$280 degree$],
    [*7*],
    [$P P P - R R R$],
    [0.25],
    [1.10],
    [0.70],
    [$320 degree$],
    [*8*],
    [$R P P - R R$],
    [0.30],
    [1.30],
    [0.85],
    [$290 degree$],
    [*9*],
    [$R R P - R R$],
    [0.20],
    [1.00],
    [0.65],
    [$310 degree$],
    [*10*],
    [$R R R - R R R - P$],
    [0.45],
    [1.80],
    [1.10],
    [$260 degree$],
  ),
  caption: [Individual topşiriqlar: kinematik tuziliş va silindrik robotning işçi zonasi],
) <tab-var2>
