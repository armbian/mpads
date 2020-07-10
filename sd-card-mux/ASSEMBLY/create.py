#!/usr/bin/env python3

import xml.etree.ElementTree as ET
import csv
import argparse

project_name = 'sd-card-mux'
project_quantity = 1

orders = {'TME Part#':{}, 'LCSC Part#':{}, 'Mouser Part#':{}}
companies = orders.keys()
designators = {}

root = ET.parse('../' + project_name + '.xml')
for node in root.findall('.//components'):
    for elem in list(node):
        designator = elem.attrib['ref']
        designators[designator] = {}
        value = elem.find('value').text.strip()
        footprints = elem.find('footprint').text.split(':')
        footprint = ' '.join(footprints[1].split('_')) 
        
        tht = False
        mechanical = False
        rotation = 0
        company = ''
        part = ''
        
        fields = elem.find('fields')
        if hasattr(fields,'getchildren'):
            for field in list(fields):
                name = field.get('name')
                if name == 'Rotation':
                    rotation = int(field.text)
                elif name == 'Mechanical':
                    if field.text == 'T':
                        mechanical = True
                elif name == 'THT':
                    if field.text == 'T':
                        tht = True
                elif name in companies:
                    company = name
                    part = field.text 
        
        if not mechanical:
            if part == '':
                print("Missing ordering info",designator,footprint)
                exit
            if part not in orders[company]:
                orders[company][part] = {'footprint': footprint, 'value': value, 'tht': tht, 'rotation': rotation, 'references':[]}
            orders[company][part]['references'].append(designator)

def designator_to_rotation(designator):
    for company in companies:
        for part in orders[company].keys():
            if designator in orders[company][part]['references']:
                return orders[company][part]['rotation']
    return 0
            
columns = []
for file in ['../CAM/' + project_name + '-top-pos.csv', '../CAM/' + project_name + '-bottom-pos.csv']:
    with open(file) as fp:
        while True: 
            line = fp.readline().strip()
            if not line: 
                break
            if len(columns) == 0:
                columns = line.split(',')
                col_ref = columns.index('Ref')
                col_posx = columns.index('PosX')
                col_posy = columns.index('PosY')
                col_rot = columns.index('Rot')
                col_side = columns.index('Side')
            else:
                data = line.replace('"', '').split(',')
                designators[data[col_ref]] = {'posX':data[col_posx],'posY':data[col_posy],'rotation':data[col_rot],'layer':data[col_side]}
    
for company in companies:
    if company == 'LCSC Part#':
        with open('jlcpcb-bom.csv', 'w') as of:
            w = csv.writer(of, dialect='excel')
            w.writerow([company, 'Designator', 'Comment', 'Footprint'])
            for part in orders[company].keys():
                element = orders[company][part]
                w.writerow([part,' '.join(element['references']), element['value'], element['footprint']])
            
        with open('jlcpcb-cpl.csv', 'w') as of:
            w = csv.writer(of, dialect='excel')
            w.writerow(["Designator", "Mid X", "Mid Y","Layer", "Rotation"])
            for part in orders[company].keys():
                for designator in orders[company][part]['references']:
                    rotation = designator_to_rotation(designator) + float(designators[designator]['rotation'])
                    w.writerow([designator,float(designators[designator]['posX']),float(designators[designator]['posY']),designators[designator]['layer'],rotation])
        
    elif company == 'Mouser Part#':
        with open('mouser-bom.csv', 'w') as of:
            w = csv.writer(of, dialect='excel')
            w.writerow(["Part#", "Count"])
            for part in orders[company].keys():
                element = orders[company][part]
                w.writerow([part,project_quantity * len(element['references'])])
    elif company == 'TME Part#':
        with open('tme-bom.csv', 'w') as of:
            w = csv.writer(of, dialect='excel')
            for part in orders[company].keys():
                element = orders[company][part]
                w.writerow([part,project_quantity * len(element['references'])])

