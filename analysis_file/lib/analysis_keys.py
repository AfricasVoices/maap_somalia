import time

import pytz  # Timezone library for converting datetime objects between timezones
from core_data_modules.cleaners import Codes
from core_data_modules.traced_data import Metadata
from dateutil.parser import isoparse


class AnalysisKeys(object):
    @staticmethod
    def set_matrix_keys(user, list_td, keys_to_matrix):
        '''
        :param user: Person running this program
        :type user: str
        :param list_td: List of TracedData Objects
        :type list_td: list
        :param keys_to_matrix: List of keys to convert to matrix
        :type keys_to_matrix: list
        :return: List of keys that will be used to create the matrix
        :rtype: list
        '''
        matrix_keys = set()

        for td in list_td:
            matrix_d = dict()
            for key in keys_to_matrix:
                if key in td:
                    matrix_keys.add(td[key])
                    matrix_d[td[key]] = Codes.MATRIX_1
            td.append_data(matrix_d, Metadata(user, Metadata.get_call_location(), time.time()))
        
        for td in list_td:
            matrix_d = dict()
            for key in matrix_keys:
                if key not in td:
                    matrix_d[key] = Codes.MATRIX_0
            td.append_data(matrix_d, Metadata(user, Metadata.get_call_location(), time.time()))

        return list(matrix_keys)

    @staticmethod
    def set_analysis_keys(user, list_td, key_map):
        '''
        :param user: Person running this program
        :type user: str
        :param list_td: List of TracedData Objects
        :type list_td: list
        :param key_map: Dict of key, value pairs to translate keys to. The key
                        is what the value will be converted to
        :type key_map: dict
        '''
        for td in list_td:
            td.append_data(
                {new_key: td[old_key] for new_key, old_key in key_map.items()
                if old_key in td},
                Metadata(user, Metadata.get_call_location(), time.time())
            )