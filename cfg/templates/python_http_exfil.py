import base64
import logging
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs, urlparse, unquote_plus

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        parsed_path = urlparse(self.path)
        params = parse_qs(parsed_path.query)
        if param_name in params:
            data_b64_encoded = unquote_plus(params["data"][0])
            data_b64_encoded = data_b64_encoded.replace(" ", "+")
            try:
                data = base64.b64decode(data_b64_encoded).decode("utf-8")
                print(data)
            except UnicodeDecodeError:
                logging.warning(
                    "Data is not a valid UTF-8 string. Handling it as bytes."
                )

        # Send response
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(b"OK")


def run_server(host, port):
    server_address = (host, port)
    with HTTPServer(server_address, Handler) as httpd:
        logging.info(f"Starting server on http://{host}:{port}, use <Ctrl-C> to stop")
        httpd.serve_forever()


if __name__ == "__main__":
    param_name = "data"
    port = 80
    try:
        run_server("0.0.0.0", port)
    except KeyboardInterrupt:
        logging.info("Shutting down server")
