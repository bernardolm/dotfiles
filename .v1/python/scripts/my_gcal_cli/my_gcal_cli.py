#!/usr/bin/env python

import os
# from pprint import pprint

from gcalcli.cli import parse_cal_names
from gcalcli.gcal import GoogleCalendarInterface
from gcalcli.printer import Printer
from gcalcli.utils import get_time_from_str

config_path = f'{os.getenv("HOME")}/sync/.gcalcli'


def config_path_exists():
    if not os.path.isdir(config_path):
        raise Exception('invalid config path')


def get_calendars():
    config_path_exists()

    file_path = f'{config_path}/calendars'
    calendars = []

    with open(file_path, encoding='utf-8') as file:
        calendars = file.readlines()

    return calendars


def dictfilt(x, y):
    return dict([(i, x[i]) for i in x if i in set(y)])


def format_date(dt):
    return dt.strftime("%d %b")


def format_time(dt):
    if dt.hour == 0:
        return "     "
    else:
        return dt.strftime("%Hh%M")


if __name__ == '__main__':
    cal_names_str = get_calendars()
    cal_names = parse_cal_names(cal_names_str)
    printer = Printer(conky=False, use_color=False, art_style='unicode')

    c = GoogleCalendarInterface(
        calendar=cal_names_str,
        command='agenda',
        config_folder=config_path,
        details={'end': True},
        ignore_declined=True,
        ignore_started=False,
        includeRc=True,
        logging_level='DEBUG',
        military=True,
        printer=printer,
        refresh_cache=False,
        tsv=True,
        use_cache=True,
    )

    cal_list = c._retry_with_backoff(  # pylint: disable=protected-access
        c.get_cal_service().calendarList().list()
    ) or {}

    # pprint(
    #     [{
    #         'summary': x.get('summary'),
    #         'description': x.get('description')
    #     }
    #         for x in cal_list['items']]
    # )

    # for item in cal_list['items']:
    #     pprint(dictfilt(item, ('summary', 'description')))

    ranges = [
        {
            'start': '2023-05-01',
            'end': 'today',
        },
        # {
        #     'start': 'yesterday',
        #     'end': 'today',
        # },
        # {
        #     'start': 'today',
        #     'end': '23:59',
        # },
        # {
        #     'start': 'tomorrow',
        #     'end': ''+ 5 days'',
        # },
    ]

    # print('')

    space = ''.rjust(32, ' ')

    for r in ranges:

        start_dt = get_time_from_str(r['start'])
        end_dt = get_time_from_str(r['end'])

        # c.AgendaQuery(start=start_dt, end=end_dt)
        events = c._search_for_events(  # pylint: disable=protected-access
            start=start_dt, end=end_dt, search_text=None)

        # print(len(events))

        _start_date = ''
        _end_date = ''

        for e in events:
            summary = e['summary']

            if e.get('organizer').get('displayName') not in \
                    ['Engineering Hurb', 'Aniversários Tecnologia',
                     'Aniversários Product Design', 'Aniversários Produto']:

                start_date = format_date(e['s'])
                if _start_date == '':
                    _start_date = start_date
                    # pprint(e)
                elif start_date == _start_date:
                    start_date = ''.rjust(6, ' ')
                else:
                    _start_date = start_date

                start_time = format_time(e['s'])
                if start_time == '00:00':
                    start_time = ''.rjust(5, ' ')

                end_date = format_date(e['e'])
                if _end_date == '':
                    _end_date = end_date
                    # pprint(e)
                elif end_date == _end_date:
                    end_date = ''.rjust(6, ' ')
                else:
                    _end_date = end_date

                end_time = format_time(e['e'])
                if end_time == '00:00':
                    end_time = ''.rjust(5, ' ')

                if end_date == start_date:
                    end_date = ''.rjust(6, ' ')

                print(f'{start_date} {start_time}    '
                      f'{end_date} {end_time}    {summary}')

            else:
                _start_date = ''
                _end_date = ''
                print(f'{space}{summary}')
