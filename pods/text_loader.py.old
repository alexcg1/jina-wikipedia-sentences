__copyright__ = "Copyright (c) 2020 Jina AI Limited. All rights reserved."
__license__ = "Apache-2.0"

from typing import Dict
from pprint import pprint

from jina.executors.crafters import BaseCrafter


class TextExtractor(BaseCrafter):
    def craft(self, text: str, *args, **kwargs) -> Dict:
        crafted_text = text.split(' ')
        print(crafted_text)
        full_text = " ".join(crafted_text)
        is_position = crafted_text.index("is")
        subject = " ".join(crafted_text[:is_position])
        # sentence = " ".join(crafted_text[is_position:])
        # to_index = full_text
        # to_show = {"subject": subject.encode('utf8'), "info": sentence.encode('utf-8')}
        # return dict(weight=1., text=sentence, meta_info=subject.encode('utf8'))
        output = dict(weight=1., meta_info=subject.encode('utf-8'), text=full_text.encode('utf8'))
        print(output)
        return output

