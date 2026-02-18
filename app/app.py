from flask import Flask, render_template
import psycopg2
import os

app = Flask(__name__)

def get_db_connection():
    conn = psycopg2.connect(
        host=os.environ.get("DB_HOST"),
        database="appdb",
        user=os.environ.get("DB_USER"),
        password=os.environ.get("DB_PASS")
    )
    return conn

@app.route("/")
def index():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT version();")
    db_version = cur.fetchone()
    cur.close()
    conn.close()

    return render_template("index.html", db_version=db_version)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
