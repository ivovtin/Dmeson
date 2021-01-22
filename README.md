# Dmeson - Пакет для анализа масс D0 и D+ мезонов

Для получения кода нужно выполнить команду:  <br />
```
git clone https://github.com/ivovtin/Dmeson
```
Данный пакет зависит от пакета [KaFramework](https://github.com/ivovtin/KaFramework) <br />

Списки обрабатываемых заходов сохранены в директории runsDmeson. <br />
Информацию для заходов по энергии и светимости в БД можно получить с помощью скриптов в директории beam_en. <br />
В директории demo расположен скрипт для отрисовки известных измеренных значений масс D-мезонов из PDG. <br />

analysis_D0meson.C - обработка сырых событий для D0 с помощью пакетов реконструкции детектора КЕДР и запись структур в Root-файл. <br />
analysis_Dplusmeson.C - тоже самое для D+ мезона. <br />
analysis_Ks - отбор для Ks->pi+pi- <br />
analysis_bhabha - обработка BhaBha событий <br />
BhaBhaSimpleSampleCC - обработка BhaBha событий, простой пример <br />

Примеры запуска на локальном хосте: <br />
```
./runAnalysisD0.sh

./runAnalysisDplus.sh

./runAnalysisBhaBha.sh
```

Запуск задач на batch и просмотр статуса выполнения, удаление:
```
qsub batch_data_D0meson.sh
или
qsub batch_data_Dplusmeson.sh
batch_data_Ks.sh
batch_data_bhabha.sh
batch_run_BhaBhaSimpleSampleCC.sh

qstat
qstat -u ovtin
qdel 772354
```

Запуск программы с KDisplay для просмотра событий:
```
analysis_D0meson -x -n 2000 /space/runs/daq023930.nat.bz2
```
Запуск KDisplay для просмотра событий с реконструкцией:
```
bzcat /space/runs/daq021913.nat.bz2 | KDisplay -r -e3197
```

Для обработки подготовленных Root-файлов какого-либо процесса нужно перейти в соответсвующие каталоги analysisD0 / analysisDplus / Kspp_analysis / bhabha . <br />
Пример запуска обработки: <br />
```
./D0meson 0

. runD0meson.sh
```

Все выходные картинки сохраняются здесь http://kedr.inp.nsk.su/~ovtin/outDmeson/

# Моделирование

Все скрипты для запуска моделирования расположены в директории simulation. <br />
KedrGen - содержит модифицированный генератор 60 с ISR (RADCOR пакет) и FSR (PHOTOS пакет). <br />

В simulation/simD0 - моделирование сигнала от D0-мезона и фона от ee->DD (в директории BG_eetoDD). То же самое для D+ и BhaBha событий. <br />

Для запуска моделирования:
```
qsub batch_mc_D0meson.sh
```

Для реконструкции полученных файлов моделирования нужно запустить:
```
qsub batch_Analysismc_D0meson.sh
```

Пример запуска моделирования и реконструкции событий из файла моделирования sim.dat:
```
ks < mc.cards.ee_to_DD > /dev/null

KDisplay < simout/sim000001.dat -r -R19697

или 

. runsimDmeson.sh

. runsimKDisplay.sh

```

Информацию о генераторах можно найти здесь http://kedr.inp.nsk.su/FOR_MEMBERS/SOFTWARE/SIMULATION/generators.html#60  <br />
```
GENE 60 Wtot SigmaW
```
Wtot - total energy of collision (GeV) <br />
SigmaW - sigma total energy of collision (GeV) <br />
pair D+D- and anti-D0D0 born equiprobably <br />

Магнитное поле составляет 6 kGs. <br />
D0 масса для моделирвоания 1864.60 MeV. <br />
Комбинаторный фре от событий континиума (e+e-->qq, q=u,d,s) моделируется с генератором 205 (Jetset 7.4). <br />
Фон от распадов e+e-->DD моделируется с генератором 60 для которого распад D0->K-pi+ является запрещенным в таблице JETSET. <br />

# Подгонка экспериментальных данных

Подгонка осуществляется в директориях analysisD0/fitD0 или analysisDplus/fitDplus/ . Нужно предварительно поместить dat-файлы с данными и моделированием в директорию dat. <br />
Запуск подгонки (внтури выбрать данные или какой тип моделируемого файла):
```
qsub batch_fits_res.sh
```
Начальные параметры для функций подгонки инициализируются из директории par и туда же сохраняется результат подгонки. <br />


