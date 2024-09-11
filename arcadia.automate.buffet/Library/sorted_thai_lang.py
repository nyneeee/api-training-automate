import icu


def Sort_List_UTF8(list: list):
    collator = icu.Collator.createInstance(icu.Locale('th_TH.UTF-8'))
    list_sorted = sorted(list, key=collator.getSortKey)
    return list_sorted
