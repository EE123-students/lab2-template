import urllib

def get_icao_info(icao_id):
    try:
        with urllib.request.urlopen("https://junzis.com/adb/?q=%s" % icao_id, timeout=3) as html:
            resp = html.read()
        segs = str(resp).split('<tr>')
        entries = list(map(lambda x: x.replace('\\t', '').replace('\\n', '').replace('</td>', ''),
                         segs[2].split('<td>')))
        entries = list(map(lambda x: ' '.join(x.split()[:-2]) if len(x.split()) > 2 else x, entries))
        return {'ICAO': entries[1], 'Reg. ID': entries[2], 'Model': entries[3], 'Aircraft Type': entries[4],
                'Operator': entries[5]}
    except urllib.error.URLError as err:
        print("Failed to get ICAO info: ", err)
        print("Are you connected to the internet?")
        return {'ICAO': icao_id.upper()}
