# Kochirib olish

```cmd
set PROJECT=robotlar_va_robototexnik_tizimlar
git clone https://github.com/axmud/robotlar_va_robototexnik_tizimlar.git %PROJECT%
winget install typst -v 0.14.2
cd %PROJECT%
for %f in (*.typ) do typst compile "%f"
```
