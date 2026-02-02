from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import base64
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from dsa.xml_parsing_script import parse_sms_xml

xml_file = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "dsa", "modified_sms_v2.xml")
transactions = parse_sms_xml(xml_file)
transaction_dict = {}
for t in transactions:
    key = t["id"]
    value = t
transaction_dict[key]= value

USERNAME = "MoMo-user"
PASSWORD = "password321"

def check_auth(headers):
    auth = headers.get("Authorization")
    if not auth or not auth.startswith("Basic "):
        return False

    encoded = auth.split(" ")[1]
    decoded = base64.b64decode(encoded).decode()
    username, password = decoded.split(":")

    return username == USERNAME and password == PASSWORD
class RequestHandler(BaseHTTPRequestHandler):

    def authenticate(self):
        if not check_auth(self.headers):
            self.send_response(401)
            self.send_header("WWW-Authenticate", "Basic realm='Secure API'")
            self.end_headers()
            return False
        return True
    def do_GET(self):
        if not self.authenticate():
            return

        if self.path == "/transactions":
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps(transactions).encode())
        elif self.path.startswith("/transactions/"):
            tid = self.path.split("/")[-1]
            tx = transaction_dict.get(tid)

            if tx:
                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps(tx).encode())
            else:
                self.send_response(404)
                self.end_headers()
    def do_POST(self):
        if not self.authenticate():
            return

        if self.path == "/transactions":
            length = int(self.headers["Content-Length"])
            body = json.loads(self.rfile.read(length))

            transactions.append(body)
            transaction_dict[body["id"]] = body

            self.send_response(201)
            self.end_headers()
    def do_PUT(self):
        if not self.authenticate():
            return

        tid = self.path.split("/")[-1]
        if tid in transaction_dict:
            length = int(self.headers["Content-Length"])
            body = json.loads(self.rfile.read(length))

            transaction_dict[tid].update(body)

            self.send_response(200)
            self.end_headers()
        else:
            self.send_response(404)
            self.end_headers()
    def do_DELETE(self):
        if not self.authenticate():
            return

        tid = self.path.split("/")[-1]
        if tid in transaction_dict:
            transactions.remove(transaction_dict[tid])
            del transaction_dict[tid]

            self.send_response(204)
            self.end_headers()
        else:
            self.send_response(404)
            self.end_headers()
            
if __name__ == "__main__":
    server = HTTPServer(("localhost", 8000), RequestHandler)
    print("Server running on port 8000")
    server.serve_forever()
