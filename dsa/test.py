import json
import time
from xml_parsing_script import parse_sms_xml

# list of transactions
transactions = parse_sms_xml("modified_sms_v2.xml")
transactions = transactions[:50]
print(f"Testing with {len(transactions)} records\n")
# dictionary of transactions
transaction_dict = {}
for t in transactions:
    key = t["id"]
    value = t
    transaction_dict[key]= value

# 1. Linear Search (linear time complexity O(n))
def linear_search(transactions, target_id):
    for t in transactions:
        if t["id"] == target_id:
            return t
    return None
# 2. Dictionary Lookup (constant time complexity O(1))
def dict_lookup(transaction_dict, target_id):
    return transaction_dict.get(target_id)

# Performance Comparison
search_id = transactions[0]["id"]  # Search for the first transaction's ID
start = time.time()
linear_result = linear_search(transactions, search_id)
end = time.time()
linear_time = end - start

start = time.time()
dict_result = dict_lookup(transaction_dict, search_id)
end = time.time()
dict_time = end - start

print("Linear Search Time:", linear_time)
print("Dictionary Lookup Time:", dict_time)