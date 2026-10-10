"""Enumerate serial ports without opening them; emit JSON for the port picker."""
import json
import sys


def describe_ports(ports, platform):
    result = []
    for port in ports:
        if platform.startswith('linux') and not port.device.startswith(('/dev/ttyUSB', '/dev/ttyACM')):
            continue
        names = list(dict.fromkeys(s for s in (
            port.manufacturer, port.product, port.description
        ) if s and s != 'n/a'))
        details = []
        if port.vid is not None and port.pid is not None:
            details.append(f'USB {port.vid:04X}:{port.pid:04X}')
        if port.serial_number:
            details.append(f'Serial: {port.serial_number}')
        if port.location:
            details.append(f'Location: {port.location}')
        result.append(dict(label=port.device, description=' · '.join(names) or 'Serial port',
                           detail=' · '.join(details)))
    return sorted(result, key=lambda p: p['label'])


if __name__ == '__main__':
    try:
        from serial.tools import list_ports
    except ImportError:
        sys.exit('Serial discovery requires pyserial. Install it in the interpreter selected by vscpu.pythonPath.')
    print(json.dumps(describe_ports(list_ports.comports(), sys.platform)))
