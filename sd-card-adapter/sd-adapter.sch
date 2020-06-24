EESchema Schematic File Version 4
LIBS:sd-adapter-cache
EELAYER 29 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector:Conn_01x04_Male J101
U 1 1 5D3FFDB5
P 1750 2000
F 0 "J101" H 1858 2281 50  0000 C CNN
F 1 "Conn" H 1858 2190 50  0000 C CNN
F 2 "Connector_JST:JST_XH_S4B-XH-A-1_1x04_P2.50mm_Horizontal" H 1750 2000 50  0001 C CNN
F 3 "~" H 1750 2000 50  0001 C CNN
	1    1750 2000
	1    0    0    -1  
$EndComp
Text Label 2150 1900 0    50   ~ 0
CS
Text Label 2150 2000 0    50   ~ 0
DO
Text Label 2150 2100 0    50   ~ 0
DI
Text Label 2150 2200 0    50   ~ 0
CLK
Wire Wire Line
	2350 2200 1950 2200
Wire Wire Line
	2350 2100 1950 2100
Wire Wire Line
	2350 2000 1950 2000
Wire Wire Line
	2350 1900 1950 1900
$Comp
L Connector:Conn_01x06_Male J102
U 1 1 5D400AE0
P 2550 2100
F 0 "J102" H 2658 2381 50  0000 C CNN
F 1 "Conn_01x06_Male" H 2658 2290 50  0001 C CNN
F 2 "Connector_PinHeader_1.00mm:PinHeader_1x06_P1.00mm_Vertical" H 2550 2100 50  0001 C CNN
F 3 "~" H 2550 2100 50  0001 C CNN
	1    2550 2100
	-1   0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x01_Male J103
U 1 1 5D402EF9
P 1350 2300
F 0 "J103" H 1458 2581 50  0000 C CNN
F 1 "VCC" H 1458 2490 50  0000 C CNN
F 2 "Connector_Pin:Pin_D1.0mm_L10.0mm" H 1350 2300 50  0001 C CNN
F 3 "~" H 1350 2300 50  0001 C CNN
	1    1350 2300
	1    0    0    -1  
$EndComp
Wire Wire Line
	1550 2300 2350 2300
Text Label 2150 2300 0    50   ~ 0
VCC
$Comp
L Connector:Conn_01x01_Male J104
U 1 1 5D404E79
P 1350 2750
F 0 "J104" H 1458 3031 50  0000 C CNN
F 1 "VSS" H 1458 2940 50  0000 C CNN
F 2 "Connector_Pin:Pin_D1.0mm_L10.0mm" H 1350 2750 50  0001 C CNN
F 3 "~" H 1350 2750 50  0001 C CNN
	1    1350 2750
	1    0    0    -1  
$EndComp
Wire Wire Line
	1550 2400 2350 2400
Wire Wire Line
	1550 2400 1550 2750
Text Label 2150 2400 0    50   ~ 0
VSS
$EndSCHEMATC
