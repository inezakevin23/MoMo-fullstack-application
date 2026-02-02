import re
import xml.etree.ElementTree as ET
import json

def get_transaction_type(body):
    body = body.lower()

    if "received" in body:
        return "RECEIVE"
    elif "transferred to" in body:
        return "TRANSFER"
    elif "payment of" in body and "airtime" in body:
        return "AIRTIME"
    elif "payment of" in body:
        return "PAYMENT"
    elif "bank deposit" in body:
        return "DEPOSIT"
    else:
        return "UNKNOWN"

def extract_amount(body):
    match = re.search(r'([\d,]+)\s*RWF', body)
    if match:
        return int(match.group(1).replace(',', ''))
    return 0


def extract_sender(body, tx_type):
    if tx_type == "RECEIVE":
        match = re.search(r'from ([A-Za-z ]+)', body)
        return match.group(1).strip() if match else "Unknown"

    elif tx_type in ["TRANSFER", "PAYMENT"]:
        return "Account Owner"

    return "Unknown"

def extract_timestamp(readable_date):
    return readable_date

def extract_transaction_fee(body):
    match = re.search(r'Fee (?:was|was:)\s*([\d,]+)', body)
    if match:
        return int(match.group(1).replace(',', ''))
    return 0

def extract_new_balance(body):
    match = re.search(r'new balance[:\s]*([\d,]+) RWF', body, re.IGNORECASE)
    if match:
        return int(match.group(1).replace(',', ''))
    return 0



def extract_receiver(body, tx_type):
    if tx_type in ["TRANSFER", "PAYMENT"]:
        match = re.search(r'to ([A-Za-z ]+)', body)
        return match.group(1).strip() if match else "Unknown"

    elif tx_type == "RECEIVE":
        return "Account Owner"

    elif tx_type == "DEPOSIT":
        return "Account Owner"

    return "Unknown"


def parse_sms_xml(file_path):
    tree = ET.parse(file_path)
    root = tree.getroot()

    transactions = []
    tx_id = 1

    for sms in root.findall('sms'):
        body = sms.get('body')
        readable_date = sms.get('readable_date')

        tx_type = get_transaction_type(body)
        amount = extract_amount(body)
        sender = extract_sender(body, tx_type)
        receiver = extract_receiver(body, tx_type)
        new_balance = extract_new_balance(body)
        transaction_fee = extract_transaction_fee(body)

        transaction = {
            "id": tx_id,
            "transaction_type": tx_type,
            "amount": amount,
            "sender": sender,
            "receiver": receiver,
            "timestamp": readable_date,
            "new_balance": new_balance,
            "transaction_fee": transaction_fee
        }

        transactions.append(transaction)
        tx_id += 1

    return transactions

if __name__ == "__main__":
    xml_file = "modified_sms_v2.xml"

    transactions = parse_sms_xml(xml_file)

    json_output = json.dumps(transactions, indent=4)

    print(json_output)

    with open("transactions.json", "w") as f:
        f.write(json_output)

    print("\n Parsing completed")
    print(f"Extracted transactions are saved to transactions.json")